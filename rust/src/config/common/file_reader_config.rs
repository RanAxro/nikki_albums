use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use crate::impl_json_frb;


impl_json_frb!(FileReaderConfig);

#[frb]
#[derive(Serialize, Deserialize)]
pub struct FileReaderConfig{
  pub path: String,
  pub file_type: FileType,
  pub keys: HashMap<String, String>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub enum FileType{
  Json,
  Ini,
}