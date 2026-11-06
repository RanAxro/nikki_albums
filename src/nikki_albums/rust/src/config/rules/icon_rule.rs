use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use crate::impl_json_frb;


impl_json_frb!(IconRule);

#[frb]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum IconRule{
  Image(ImageIconRule),
  BuiltIn(BuiltInIconRule),
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct ImageIconRule{
  #[serde(default)]
  pub global: bool,

  pub path: String,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct BuiltInIconRule{
  pub name: String,
}