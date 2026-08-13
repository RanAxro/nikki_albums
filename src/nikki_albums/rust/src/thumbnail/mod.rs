pub mod jpeg;
pub mod png;
pub mod mp4_h264;
mod utils;

pub struct Thumbnail{
  pub width: u32,
  pub height: u32,
  pub bytes: Vec<u8>,
}