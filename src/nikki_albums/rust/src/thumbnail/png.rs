use super::Thumbnail;
use super::utils::calculate_dimensions;
use fast_image_resize::images::Image;
use fast_image_resize::{FilterType, PixelType, ResizeAlg, ResizeOptions, Resizer};
use zune_core::bytestream::ZCursor;
use zune_core::colorspace::ColorSpace;
use zune_core::options::DecoderOptions;
use zune_core::result::DecodingResult;
use zune_png::PngDecoder;

/// 生成 PNG 缩略图
///
/// # Arguments
/// * `png_bytes` - PNG 文件字节数据
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
pub fn generate_thumbnail(png_bytes: &Vec<u8>, target_width: Option<u32>, target_height: Option<u32>) -> Result<Thumbnail, String>{
  // 配置解码器：强制 8bit 输出，避免 U16 分支
  let options = DecoderOptions::default().png_set_strip_to_8bit(true);
  let mut decoder = PngDecoder::new_with_options(ZCursor::new(&png_bytes), options);

  // 全图解码
  let result = decoder
    .decode()
    .map_err(|e| format!("PNG decode error: {:?}", e))?;

  // 提取元数据
  let info = decoder.info().ok_or("Missing PNG info")?;
  let src_w = info.width as u32;
  let src_h = info.height as u32;

  let cs = decoder.colorspace().ok_or("Missing colorspace")?;

  // 拿到 U8 数据（strip_to_8bit 已启用）
  let raw = match result {
    DecodingResult::U8(v) => v,
    _ => return Err("Unexpected 16-bit output after strip_to_8bit".into()),
  };

  // 手动颜色空间转换到 RGBA
  let rgba: Vec<u8> = match cs {
    ColorSpace::RGBA => raw,
    ColorSpace::RGB => raw
      .chunks_exact(3)
      .flat_map(|c| [c[0], c[1], c[2], 255])
      .collect(),
    ColorSpace::Luma => raw
      .iter()
      .flat_map(|&l| [l, l, l, 255])
      .collect(),
    ColorSpace::LumaA => raw
      .chunks_exact(2)
      .flat_map(|c| [c[0], c[0], c[0], c[1]])
      .collect(),
    _ => return Err(format!("Unsupported colorspace: {:?}", cs)),
  };

  // 计算目标尺寸（保持宽高比 Fit）
  let (dst_w, dst_h) = calculate_dimensions(src_w, src_h, target_width, target_height);

  // 无需缩放时直接返回，避免 fast_image_resize 分配
  if dst_w == src_w && dst_h == src_h {
    return Ok(Thumbnail{
      width: src_w,
      height: src_h,
      bytes: rgba,
    });
  }

  // SIMD 加速缩放（U8x4 = RGBA8）
  let src_img =
    Image::from_vec_u8(src_w, src_h, rgba, PixelType::U8x4)
      .map_err(|e| format!("Source image error: {:?}", e))?;

  let mut dst_img = Image::new(dst_w, dst_h, PixelType::U8x4);

  let mut resizer = Resizer::new();
  resizer
    .resize(
      &src_img,
      &mut dst_img,
      &ResizeOptions::new().resize_alg(ResizeAlg::Convolution(FilterType::Box)),
    )
    .map_err(|e| format!("Resize error: {:?}", e))?;

  Ok(Thumbnail{
    width: dst_w,
    height: dst_h,
    bytes: dst_img.buffer().to_vec(),
  })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_generate_thumbnail_invalid_bytes() {
        let invalid_bytes = vec![0, 1, 2, 3];
        let result = generate_thumbnail(&invalid_bytes, Some(100), Some(100));
        assert!(result.is_err());
    }

    #[test]
    fn test_generate_thumbnail_valid_1x1_png() {
        let png_hex = "89504e470d0a1a0a0000000d49484452000000010000000108060000001f15c4890000000a49444154789c63000100000500010d0a2db40000000049454e44ae426082";
        let mut bytes = vec![0; png_hex.len() / 2];
        faster_hex::hex_decode(png_hex.as_bytes(), &mut bytes).unwrap();
        
        let result = generate_thumbnail(&bytes, None, None);
        assert!(result.is_ok());
        if let Ok(thumb) = result {
            assert_eq!(thumb.width, 1);
            assert_eq!(thumb.height, 1);
            assert_eq!(thumb.bytes.len(), 4);
        }
    }
}