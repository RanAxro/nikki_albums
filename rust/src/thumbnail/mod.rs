pub mod jpeg;
mod utils;

use std::fs::File;
use std::io::BufWriter;
pub struct Thumbnail{
  width: u32,
  height: u32,
  bytes: Vec<u8>,
}
impl Thumbnail {
  pub fn save_png_lightweight(&self, path: &str) -> Result<(), png::EncodingError> {
    let file = File::create(path)?;
    let w = BufWriter::new(file);

    let mut encoder = png::Encoder::new(w, self.width, self.height);
    encoder.set_color(png::ColorType::Rgba);
    encoder.set_depth(png::BitDepth::Eight);

    let mut writer = encoder.write_header()?;
    writer.write_image_data(&self.bytes)?;

    Ok(())
  }
}