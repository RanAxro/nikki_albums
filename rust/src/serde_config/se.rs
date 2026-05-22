use crate::nuan5_media_param::serde_nuan5_json::error::Error;
use crate::nuan5_media_param::serde_nuan5_json::ser;
use super::structs::theme;

pub fn serialize_theme_config(value: &theme::ThemeConfigWrapper, pretty: bool) -> Result<Vec<u8>, Error>{
  if pretty {
    ser::to_vec_pretty(&value)
  }else{
    ser::to_vec(&value)
  }
}