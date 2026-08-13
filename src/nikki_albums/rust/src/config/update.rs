use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Serialize, Deserialize};
use crate::impl_json_frb;

#[frb]
#[derive(Serialize, Deserialize)]
pub struct UpdateInfo{
  pub windows: PlatformUpdateInfo,
  pub macos: PlatformUpdateInfo,
}

impl_json_frb!(UpdateInfo);

// impl UpdateInfo{
//   #[frb(sync)]
//   pub fn from_json(json: &str) -> Option<Self>{
//     serde_json::from_str(json).ok()
//   }
// 
//   #[frb(sync)]
//   pub fn to_json(&self) -> Result<String, serde_json::error::Error>{
//     serde_json::to_string(self)
//   }
// 
//   #[frb(sync)]
//   pub fn to_json_pretty(&self) -> Result<String, serde_json::error::Error>{
//     serde_json::to_string_pretty(self)
//   }
// }

#[frb]
#[derive(Serialize, Deserialize)]
pub struct PlatformUpdateInfo{
  pub version: i32,

  #[serde(rename = "versionString")]
  pub version_string: String,

  #[serde(rename = "downloadLink")]
  pub download_link: String,

  #[serde(rename = "updateMessage")]
  pub update_message: HashMap<String, String>,
}