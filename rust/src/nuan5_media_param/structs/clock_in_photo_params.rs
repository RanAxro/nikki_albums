use super::nikki_photo_params::{RichCameraParams, DressingParams, LocationParams, MomoHiddenState, NikkiParams, PhotographyParams, ShootingTime};


#[derive(Clone)]
pub struct ClockInPhotoMainParams{
  pub tag: i64,
  pub camera: Option<RichCameraParams>,
  pub dressing: DressingParams,
  pub time: Option<ShootingTime>,
  pub weather: Option<i64>,
  pub location: Option<LocationParams>,
}

#[derive(Clone)]
pub struct ClockInPhotoParams{
  pub tag: i64,
  pub photography: PhotographyParams,
  pub camera: Option<RichCameraParams>,
  pub nikki: Option<NikkiParams>,
  pub momo: Option<MomoHiddenState>,
}