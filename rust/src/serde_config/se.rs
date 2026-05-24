use crate::nuan5_media_param::serde_nuan5_json::error::Error;
use crate::nuan5_media_param::serde_nuan5_json::ser;
use super::structs::theme;
use super::structs::game_config;
use super::structs::plugin_info;

pub fn serialize_theme_config(value: &theme::ThemeConfigWrapper, pretty: bool) -> Result<Vec<u8>, Error>{
  if pretty {
    ser::to_vec_pretty(&value)
  }else{
    ser::to_vec(&value)
  }
}

pub fn serialize_game_config(value: &game_config::GameConfig, pretty: bool) -> Result<Vec<u8>, Error>{
  if pretty {
    ser::to_vec_pretty(&value)
  }else{
    ser::to_vec(&value)
  }
}

pub fn serialize_plugin_info(value: &plugin_info::PluginInfo, pretty: bool) -> Result<Vec<u8>, Error>{
  if pretty {
    ser::to_vec_pretty(&value)
  }else{
    ser::to_vec(&value)
  }
}