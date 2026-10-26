use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use crate::impl_json_frb;


impl_json_frb!(TextRule);

#[frb]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum TextRule{
  Literal(LiteralTextRule),
  Translate(TranslateTextRule),
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct LiteralTextRule{
  pub text: String,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct TranslateTextRule{
  pub global: bool,
  pub key: String,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub args: Option<Vec<String>>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub named_args: Option<HashMap<String, String>>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub gender: Option<String>,
}