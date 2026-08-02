use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};


#[macro_export] macro_rules! impl_json_frb{
  ($($struct_name:ty),+ $(,)?) => {
    $(
      impl $struct_name {
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
    )+
  };
}

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
  pub named_args: Option<Vec<String>>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub gender: Option<String>,
}