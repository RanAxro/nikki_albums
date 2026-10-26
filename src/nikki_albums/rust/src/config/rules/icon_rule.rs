use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use crate::impl_json_frb;


impl_json_frb!(IconRule);

#[frb]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum IconRule{
  Image(ImageIconRule),
  Font(FontIconRule),
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct ImageIconRule{
  pub global: bool,
  pub path: String,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct FontIconRule{
  pub global: bool,
  pub path: String,
  pub font_family: String,
  pub code_point: u32,
}