use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[frb]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum TextConfig{
  Literal(LiteralTextConfig),
  Translate(TranslateTextConfig),
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct LiteralTextConfig{
  pub text: String,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct TranslateTextConfig{
  pub key: String,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub args: Option<Vec<String>>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub named_args: Option<HashMap<String, String>>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub gender: Option<String>,
}