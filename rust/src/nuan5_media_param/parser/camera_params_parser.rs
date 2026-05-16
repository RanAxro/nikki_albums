use super::super::serde_nuan5_json::structs::camera_params;
use super::super::serde_nuan5_json::de;
use super::super::decrypt;

pub fn parse_camera_params(params: &str) -> Option<camera_params::CameraParams>{
  let key = decrypt::Key::camera_param().ok()?;
  let decrypt::CustomData::Valid(data) = decrypt::decrypt(Vec::from(params), &key)? else {
    return None;
  };
  de::from_slice(&data).ok()
}

#[inline]
pub fn parse_bloom_intensity(data: &Option<camera_params::CameraParams>) -> f64{
  if let Some(params) = data {
    params.bloom_intensity / 8.0
  }else{
    0.0
  }
}
#[inline]
pub fn parse_bloom_threshold(data: &Option<camera_params::CameraParams>) -> f64{
  if let Some(params) = data {
    params.bloom_threshold
  }else{
    0.0
  }
}
#[inline]
pub fn parse_brightness(data: &Option<camera_params::CameraParams>) -> f64{
  if let Some(params) = data {
    (params.brightness - 0.3) / 1.2
  }else{
    0.0
  }
}
#[inline]
pub fn parse_exposure(data: &Option<camera_params::CameraParams>) -> f64{
  if let Some(params) = data {
    params.exposure
  }else{
    0.0
  }
}
#[inline]
pub fn parse_contrast(data: &Option<camera_params::CameraParams>) -> f64{
  if let Some(params) = data {
    (params.contrast - 0.55) / 1.45
  }else{
    0.0
  }
}
#[inline]
pub fn parse_saturation(data: &Option<camera_params::CameraParams>) -> f64{
  if let Some(params) = data {
    params.saturation
  }else{
    0.0
  }
}
#[inline]
pub fn parse_vibrance(data: &Option<camera_params::CameraParams>) -> f64{
  if let Some(params) = data {
    params.vibrance * 2.0
  }else{
    0.0
  }
}
#[inline]
pub fn parse_highlights(data: &Option<camera_params::CameraParams>) -> f64{
  if let Some(params) = data {
    params.highlights
  }else{
    0.0
  }
}
#[inline]
pub fn parse_shadows(data: &Option<camera_params::CameraParams>) -> f64{
  if let Some(params) = data {
    params.shadows
  }else{
    0.0
  }
}