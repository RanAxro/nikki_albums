use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use super::icon_rule::IconRule;
use crate::impl_json_frb;


impl_json_frb!(ImageRule);

#[frb]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum ImageRule{
  Icon(IconImageRule),
  NGFS(NGFSImageRule),
  Native(NativeImageRule),
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct IconImageRule{
  pub icon: IconRule,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct NGFSImageRule{
  pub fs_handler_id: String,
  pub path: String,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct NativeImageRule{
  pub path: String,
}