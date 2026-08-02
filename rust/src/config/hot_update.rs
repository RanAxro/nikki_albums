use flutter_rust_bridge::frb;
use serde::{Serialize, Deserialize};
use crate::impl_json_frb;

#[frb]
#[derive(Serialize, Deserialize)]
pub struct HotUpdateInfo{
  pub id: String,

  #[serde(rename = "versionId")]
  pub version_id: String,

  #[serde(rename = "targetAppVersion")]
  pub target_app_version: Vec<AppVersionHotUpdateInfo>,

  pub files: Vec<FileHotUpdateInfo>,
}

impl_json_frb!(HotUpdateInfo);

#[frb]
#[derive(Serialize, Deserialize)]
pub struct AppVersionHotUpdateInfo{
  pub min: i32,
  pub max: i32,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct FileHotUpdateInfo{
  pub path: String,

  #[serde(rename = "downloadLink")]
  pub download_link: String,
}