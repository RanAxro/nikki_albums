use flutter_rust_bridge::frb;
use crate::nuan5_params::reverter::revert_camera_params;
use crate::nuan5_params::unparser::camera_params_unparser::unparse_camera_params;
use super::structs::camera_params::*;


/// ============================================================
/// Media
/// ============================================================

#[frb]
pub fn encode_camera_params(camera_params: &CameraParams) -> Option<String>{
  let reverted = revert_camera_params(camera_params);
  unparse_camera_params(&reverted)
}