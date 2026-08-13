use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use crate::impl_json_frb;


impl_json_frb!(StringConfig);

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringConfig{
  pub process: Vec<StringProcessConfig>,
}

#[frb]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum StringProcessConfig{
  Join(StringJoinProcessConfig),
  Match(StringMatchProcessConfig),
  Replace(StringReplaceProcessConfig),
  ReplaceAll(StringReplaceAllProcessConfig),
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringJoinProcessConfig{
  pub separator: String,
  pub target: Vec<Vec<StringProcessConfig>>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringMatchProcessConfig{
  pub regex: String,
  pub which: i32,
  pub successful: String,
  pub failed: Vec<StringProcessConfig>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringReplaceProcessConfig{
  pub regex: String,
  pub which: i32,
  pub to: String,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringReplaceAllProcessConfig{
  pub regex: String,
  pub to: String,
}