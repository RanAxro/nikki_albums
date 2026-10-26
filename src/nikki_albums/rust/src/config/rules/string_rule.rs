use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use crate::impl_json_frb;


impl_json_frb!(StringRule);

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringRule{
  pub process: Vec<StringProcess>,
}

#[frb]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum StringProcess{
  Join(StringJoinProcess),
  Match(StringMatchProcess),
  Replace(StringReplaceProcess),
  ReplaceAll(StringReplaceAllProcess),
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringJoinProcess{
  pub separator: String,
  pub target: Vec<Vec<StringProcess>>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringMatchProcess{
  pub regex: String,
  pub which: i32,
  pub successful: String,
  pub failed: Vec<StringProcess>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringReplaceProcess{
  pub regex: String,
  pub which: i32,
  pub to: String,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct StringReplaceAllProcess{
  pub regex: String,
  pub to: String,
}