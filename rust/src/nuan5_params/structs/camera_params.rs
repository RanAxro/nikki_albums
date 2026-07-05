use super::super::structs::nikki_photo_params::{LightParams, FilterParams};

#[derive(Clone)]
pub struct CameraParams{
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
  
  pub momo: Option<CameraParamsMomoHidden>,
}

#[derive(Clone)]
pub enum CameraParamsMomoHidden{
  Enable,
  Disable{
    momo_pose: i64,
    horizontal: f64,
    distance: f64,
    height: f64,
    rotate_momo: f64,
    auto_ground_snap: bool,
    floating_effect: bool,
    pose_with_nikki: bool,
  },
}