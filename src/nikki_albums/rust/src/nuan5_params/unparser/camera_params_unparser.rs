use std::str::from_utf8;
use crate::nuan5_params::nuan5_structs::camera_params;
use crate::serde_nuan5_json::ser;
use super::super::encrypt;

pub fn unparse_camera_params(params: &camera_params::CameraParams) -> Option<String>{
  let bytes = ser::to_vec(params).ok()?;
  let encoded = encrypt::media_encode_camera_params_bytes(&bytes).ok()?;
  from_utf8(&encoded).map(|s| s.to_string()).ok()
}

#[inline]
pub fn unparse_bloom_intensity(bloom_intensity: f64) -> f64{
  bloom_intensity * 8.0
}
#[inline]
pub fn unparse_bloom_threshold(bloom_threshold: f64) -> f64{
  bloom_threshold
}
#[inline]
pub fn unparse_brightness(brightness: f64) -> f64{
  0.3 + brightness * 1.2
}
#[inline]
pub fn unparse_exposure(exposure: f64) -> f64{
  exposure
}
#[inline]
pub fn unparse_contrast(contrast: f64) -> f64{
  0.55 + contrast * 1.45
}
#[inline]
pub fn unparse_saturation(saturation: f64) -> f64{
  saturation
}
#[inline]
pub fn unparse_vibrance(vibrance: f64) -> f64{
  vibrance / 2.0
}
#[inline]
pub fn unparse_highlights(highlights: f64) -> f64{
  highlights
}
#[inline]
pub fn unparse_shadows(shadows: f64) -> f64{
  shadows
}

#[inline]
pub fn unparse_horizontal(horizontal: f64) -> f64{
  horizontal / 400.0
}
#[inline]
pub fn unparse_distance(distance: f64) -> f64{
  distance / 400.0
}
#[inline]
pub fn unparse_height(height: f64) -> f64{
  height / 400.0
}
#[inline]
pub fn unparse_rotate_momo(rotate_momo: f64) -> f64{
  rotate_momo / 180.0
}