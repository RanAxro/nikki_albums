pub mod jpeg;
pub mod png;
pub mod mp4_h264;
mod utils;

pub struct Thumbnail{
  width: u32,
  height: u32,
  bytes: Vec<u8>,
}