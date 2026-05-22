use crate::nuan5_media_param::serde_nuan5_json::error::Error;
use crate::nuan5_media_param::serde_nuan5_json::de;
use super::structs::theme;

pub fn deserialize_theme_config(value: &[u8]) -> Result<theme::ThemeConfigWrapper, Error>{
  de::from_slice(value)
}