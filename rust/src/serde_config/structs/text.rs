use serde::{Deserialize, Serialize};

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum Text{
  Ordinary(OrdinaryText),
  Translate(TranslateText),
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct OrdinaryText{
  pub text: String,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct TranslateText{
  pub key: String,
  pub args: Option<Vec<String>>,
  pub named_args: Option<Vec<String>>,
  pub gender: Option<String>,
}