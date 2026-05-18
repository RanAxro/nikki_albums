use super::super::structs::nikki_photo_params::{LightParams, FilterParams};

#[derive(Clone)]
pub struct MomoCameraParams{
  pub camera_actor_loc: (f64, f64, f64),
  pub camera_actor_rot: (f64, f64, f64),
  pub camera_component_loc: (f64, f64, f64),
  pub camera_component_rot: (f64, f64, f64),

  pub portrait_mode: i64,
  pub camera_focal_length: f64,
  pub aperture_section: u8,
  pub vignette_intensity: f64,
  pub bloom_intensity: f64,
  pub bloom_threshold: f64,
  pub brightness: f64,
  pub exposure: f64,
  pub contrast: f64,
  pub saturation: f64,
  pub vibrance: f64,
  pub highlights: f64,
  pub shadows: f64,

  pub light: LightParams,
  pub filter: FilterParams,
}