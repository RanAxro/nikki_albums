use super::Thumbnail;
use super::utils::calculate_dimensions;
use fast_image_resize::images::Image;
use fast_image_resize::{FilterType, PixelType, ResizeAlg, ResizeOptions, Resizer};
use mp4::{Mp4Reader, TrackType};
use rust_h264::decoder::Decoder;
use rust_h264::nal::{parse_avcc, parse_avcc_config};
use std::io::Cursor;
use yuv::{YuvPlanarImage, YuvRange, YuvStandardMatrix};

/// 生成 MP4 H.264 缩略图
///
/// # Arguments
/// * `mp4_bytes` - MP4 H.264 文件字节数据
/// * `target_width` - 目标宽度(None 表示按高度等比缩放)
/// * `target_height` - 目标高度(None 表示按宽度等比缩放)
///
/// # Returns
/// * `Ok(Thumbnail)` - 缩略图宽度、高度、RGBA 像素数据
/// * `Err(String)` - 错误信息
///
/// # 注意
/// - 如果 width 和 height 都指定，会保持原图比例进行 **Fit**(适应)缩放
/// - 如果都未指定，返回原图尺寸的 RGBA 数据
pub fn generate_thumbnail(mp4_bytes: &Vec<u8>, target_width: Option<u32>, target_height: Option<u32>) -> Result<Thumbnail, String>{
  // 1. 解析 MP4 容器
  let size = mp4_bytes.len() as u64;
  let reader = Cursor::new(mp4_bytes);
  let mut mp4 = Mp4Reader::read_header(reader, size)
    .map_err(|e| format!("MP4 parse error: {:?}", e))?;

  // 2. 找到第一个 H.264 视频轨
  let (&track_id, track) = mp4
    .tracks()
    .iter()
    .find(|(_, t)| {
      t.track_type().ok() == Some(TrackType::Video)
        && t.media_type().ok().map(|m| m.to_string()).as_deref() == Some("avc1")
    })
    .ok_or("No H.264 video track found")?;

  // 3. 从 avcC 提取解码器配置（SPS/PPS + length_size）
  // mp4 0.14.0: Mp4Track 有 sequence_parameter_set() 和 picture_parameter_set() 方法
  let sps = track
    .sequence_parameter_set()
    .map_err(|e| format!("Missing SPS: {:?}", e))?;
  let pps = track
    .picture_parameter_set()
    .map_err(|e| format!("Missing PPS: {:?}", e))?;

  // 手动构建 avcC 数据用于 parse_avcc_config
  // avcC 格式: configurationVersion(1) + profile(1) + compatibility(1) + level(1) +
  //            reserved(6bits)|lengthSizeMinusOne(2bits) + reserved(3bits)|numSPS(5bits) +
  //            sps_len(2) + sps + numPPS(1) + pps_len(2) + pps
  let mut avcc_data = Vec::new();
  avcc_data.extend_from_slice(&[1, sps[1], sps[2], sps[3]]); // configVersion, profile, compat, level
  avcc_data.push(0xFF); // reserved(6bits)=0x3F | lengthSizeMinusOne(2bits)=0x03 => 4 bytes length
  avcc_data.push(0xE1); // reserved(3bits)=0x07 | numSPS(5bits)=0x01 => 1 SPS
  avcc_data.extend_from_slice(&(sps.len() as u16).to_be_bytes());
  avcc_data.extend_from_slice(sps);
  avcc_data.push(0x01); // numPPS = 1
  avcc_data.extend_from_slice(&(pps.len() as u16).to_be_bytes());
  avcc_data.extend_from_slice(pps);

  let config = parse_avcc_config(&avcc_data)
    .map_err(|e| format!("AVCC config parse error: {}", e))?;

  // 4. 初始化 H.264 解码器，注入 SPS/PPS
  let mut decoder = Decoder::new();
  for nal in config.sps_nals.iter().chain(config.pps_nals.iter()) {
    decoder
      .decode_nal(nal)
      .map_err(|e| format!("SPS/PPS decode error: {:?}", e))?;
  }

  // 5. 逐 sample 读取，解码首帧即停
  let sample_count = track.sample_count();
  let mut first_frame: Option<rust_h264::decoder::Frame> = None;

  for sample_id in 1..=sample_count {
    let sample = mp4
      .read_sample(track_id, sample_id)
      .map_err(|e| format!("Read sample error: {:?}", e))?
      .ok_or("Sample not found")?;

    // 解析 AVCC length-prefixed NAL 单元
    for nal in parse_avcc(&sample.bytes, config.length_size) {
      if let Ok(Some(frame)) = decoder.decode_nal(&nal) {
        first_frame = Some(frame);
        break;
      }
    }
    if first_frame.is_some() {
      break;
    }
  }

  // 排空解码器缓冲（B-frame 重排序后可能有延迟帧）
  if first_frame.is_none() {
    if let Some(frame) = decoder.flush() {
      first_frame = Some(frame);
    }
  }

  let frame = first_frame.ok_or("No decodable frame found")?;
  let src_w = frame.width;
  let src_h = frame.height;

  // 6. YUV420 → RGBA（SIMD 加速）
  // rust_h264 Frame: y = width*height, u = (width/2)*(height/2), v = (width/2)*(height/2)
  let chroma_w = src_w / 2;
  let chroma_h = src_h / 2;

  let planar = YuvPlanarImage {
    y_plane: &frame.y,
    y_stride: src_w,
    u_plane: &frame.u,
    u_stride: chroma_w,
    v_plane: &frame.v,
    v_stride: chroma_w,
    width: src_w,
    height: src_h,
  };

  let mut rgba = vec![0u8; (src_w * src_h * 4) as usize];
  yuv::yuv420_to_rgba(
    &planar,
    &mut rgba,
    src_w * 4,
    YuvRange::Limited,
    YuvStandardMatrix::Bt601,
  )
    .map_err(|e| format!("YUV to RGBA error: {:?}", e))?;

  // 7. 计算目标尺寸（保持宽高比 Fit）
  let (dst_w, dst_h) = calculate_dimensions(src_w, src_h, target_width, target_height);

  // 无需缩放时直接返回
  if dst_w == src_w && dst_h == src_h {
    return Ok(Thumbnail{
      width: src_w,
      height: src_h,
      bytes: rgba,
    });
  }

  // 8. SIMD 加速缩放
  let src_img = Image::from_vec_u8(src_w, src_h, rgba, PixelType::U8x4)
    .map_err(|e| format!("Source image error: {:?}", e))?;

  let mut dst_img = Image::new(dst_w, dst_h, PixelType::U8x4);

  let mut resizer = Resizer::new();
  resizer
    .resize(
      &src_img,
      &mut dst_img,
      &ResizeOptions::new().resize_alg(ResizeAlg::Convolution(FilterType::Lanczos3)),
    )
    .map_err(|e| format!("Resize error: {:?}", e))?;

  Ok(Thumbnail{
    width: dst_w,
    height: dst_h,
    bytes: dst_img.buffer().to_vec(),
  })
}