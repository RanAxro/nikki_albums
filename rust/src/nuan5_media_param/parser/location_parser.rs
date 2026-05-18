use super::super::structs::nikki_photo_params::{LocationParams, LocationType};
use super::super::structs::world::Location;

pub fn parse_location(x: f64, y: f64, z: f64) -> LocationParams{
  // todo
  LocationParams{
    pos: (x, y, z),
    loc: LocationType::Unknown,
  }
}