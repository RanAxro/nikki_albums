use crate::nuan5_params::nuan5_structs::camera_params;
use crate::serde_nuan5_json::de;
use super::super::decrypt;

pub fn parse_camera_params(params: &str) -> Option<camera_params::CameraParams>{
  let key = decrypt::MediaKey::camera_param().ok()?;
  let decrypt::CustomData::Valid(data) = decrypt::media_decrypt(params.as_ref(), &key)? else {
    return None;
  };
  de::from_slice(&data).ok()
}

#[inline]
pub fn parse_bloom_intensity(bloom_intensity: f64) -> f64{
  bloom_intensity / 8.0
}
#[inline]
pub fn parse_bloom_threshold(bloom_threshold: f64) -> f64{
  bloom_threshold
}
#[inline]
pub fn parse_brightness(brightness: f64) -> f64{
  (brightness - 0.3) / 1.2
}
#[inline]
pub fn parse_exposure(exposure: f64) -> f64{
  exposure
}
#[inline]
pub fn parse_contrast(contrast: f64) -> f64{
  (contrast - 0.55) / 1.45
}
#[inline]
pub fn parse_saturation(saturation: f64) -> f64{
  saturation
}
#[inline]
pub fn parse_vibrance(vibrance: f64) -> f64{
  vibrance * 2.0
}
#[inline]
pub fn parse_highlights(highlights: f64) -> f64{
  highlights
}
#[inline]
pub fn parse_shadows(shadows: f64) -> f64{
  shadows
}

#[inline]
pub fn parse_horizontal(horizontal: f64) -> f64{
  horizontal * 400.0
}
#[inline]
pub fn parse_distance(distance: f64) -> f64{
  distance * 400.0
}
#[inline]
pub fn parse_height(height: f64) -> f64{
  height * 400.0
}
#[inline]
pub fn parse_rotate_momo(rotate_momo: f64) -> f64{
  rotate_momo * 180.0
}