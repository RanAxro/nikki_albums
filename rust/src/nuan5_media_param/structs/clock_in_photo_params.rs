use super::nikki_photo_params::{CameraParams, MomoHiddenState, NikkiParams, PhotographyParams};

#[derive(Clone)]
pub struct ClockInPhotoParams{
  pub tag: i64,
  pub photography: PhotographyParams,
  pub camera: Option<CameraParams>,
  pub nikki: Option<NikkiParams>,
  pub momo: Option<MomoHiddenState>,
}