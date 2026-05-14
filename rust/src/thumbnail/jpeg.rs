use super::Thumbnail;
use super::utils::calculate_dimensions;
use fast_image_resize::images::Image;
use fast_image_resize::{IntoImageView, Resizer, ResizeOptions, ResizeAlg, FilterType};
use zune_core::bytestream::ZCursor;
use zune_core::colorspace::ColorSpace;
use zune_core::options::DecoderOptions;
use zune_jpeg::JpegDecoder;

/// 生成 JPEG 缩略图
///
/// # Arguments
/// * `jpeg_bytes` - JPEG 文件字节数据
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
pub fn generate_thumbnail(jpeg_bytes: &Vec<u8>, target_width: Option<u32>, target_height: Option<u32>) -> Result<Thumbnail, String>{
  // 配置解码器, 直接输出 RGBA
  let options = DecoderOptions::default().jpeg_set_out_colorspace(ColorSpace::RGBA);

  let cursor = ZCursor::new(jpeg_bytes);
  let mut decoder = JpegDecoder::new_with_options(cursor, options);

  // 解码 JPEG 为 RGBA
  let pixels = decoder.decode()
    .map_err(|e| format!("JPEG decode error: {:?}", e))?;

  let info = decoder.info()
    .ok_or("Failed to get image info")?;

  let src_width = info.width as u32;
  let src_height = info.height as u32;

  // 计算目标尺寸(保持宽高比)
  let (dst_width, dst_height) = calculate_dimensions(
    src_width,
    src_height,
    target_width,
    target_height,
  );

  // 如果无需缩放，直接返回
  if dst_width == src_width && dst_height == src_height {
    return Ok(Thumbnail{
      width: src_width,
      height: src_height,
      bytes: pixels,
    });
  }

  // 创建源图像视图(RGBA = U8x4)
  let src_image = Image::from_vec_u8(
    src_width,
    src_height,
    pixels,
    fast_image_resize::PixelType::U8x4,
  ).map_err(|e| format!("Source image error: {:?}", e))?;

  // 创建目标图像缓冲区
  let mut dst_image = Image::new(
    dst_width,
    dst_height,
    fast_image_resize::PixelType::U8x4,
  );

  // 配置缩放器：使用 Lanczos3 获得较好质量，或 Bilinear 获得更快速度
  let mut resizer = Resizer::new();

  // 可选：启用多线程（需要 rayon feature）
  // resizer.set_alg(ResizeAlg::Convolution(FilterType::Lanczos3));

  let options = ResizeOptions::new()
    .resize_alg(ResizeAlg::Convolution(FilterType::Box));

  resizer.resize(&src_image, &mut dst_image, &options)
    .map_err(|e| format!("Resize error: {:?}", e))?;

  // 返回结果
  let result_pixels = dst_image.buffer().to_vec();
  Ok(Thumbnail{
    width: dst_width,
    height: dst_height,
    bytes: result_pixels,
  })
}