use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Serialize, Deserialize};

#[frb]
#[derive(Serialize, Deserialize)]
pub struct AppPersistentState{
  pub is_agree_agreement: bool,
  pub is_initial_startup: bool,

  pub lang: String,
  pub theme: i32,

  #[serde(flatten)]
  pub unknown_field: HashMap<String, serde_json::Value>,
}

impl AppPersistentState{
  #[frb(sync)]
  pub fn from_json(json: &str) -> Option<Self>{
    serde_json::from_str(json).ok()
  }

  #[frb(sync)]
  pub fn to_json(&self) -> Result<String, serde_json::error::Error>{
    serde_json::to_string(self)
  }

  #[frb(sync)]
  pub fn to_json_pretty(&self) -> Result<String, serde_json::error::Error>{
    serde_json::to_string_pretty(self)
  }
}