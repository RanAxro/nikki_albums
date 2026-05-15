pub mod jpeg;
pub mod png;
mod utils;
mod mp4_h264;

pub struct Thumbnail{
  width: u32,
  height: u32,
  bytes: Vec<u8>,
}