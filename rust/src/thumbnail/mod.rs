pub mod jpeg;
pub mod png;
mod utils;

pub struct Thumbnail{
  width: u32,
  height: u32,
  bytes: Vec<u8>,
}