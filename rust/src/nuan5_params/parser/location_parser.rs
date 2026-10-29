use crate::nuan5_params::nuan5_structs::image_custom_data::TrackInfo;
use super::super::structs::nikki_photo_params::LocationParams;

pub fn parse_location(x: f64, y: f64, z: f64, track_info: Option<&TrackInfo>) -> LocationParams{
  // todo
  LocationParams{
    pos: (x, y, z),
    world_id: track_info.map(|info| info.world_id),
    // loc: LocationType::Unknown,
  }
}