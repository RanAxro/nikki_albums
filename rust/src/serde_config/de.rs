use std::fs;
use crate::nuan5_media_param::serde_nuan5_json::error::{Error, ErrorCode};
use crate::nuan5_media_param::serde_nuan5_json::de;
use crate::serde_config::structs::game_config::GameConfig;
use super::structs::theme;
use super::structs::game_config;
use super::structs::plugin_info;

pub fn deserialize_theme_config(value: &[u8]) -> Result<theme::ThemeConfigWrapper, Error>{
  de::from_slice(value)
}

pub fn decode_theme_config_file(path: &str) -> Result<theme::ThemeConfigWrapper, Error>{
  let bytes = fs::read(path).map_err(|e| Error::code(ErrorCode::Message(e.to_string())))?;

  de::from_slice(&bytes)
}

pub fn deserialize_game_config(value: &[u8]) -> Result<game_config::GameConfig, Error>{
  de::from_slice(value)
}

pub fn decode_game_config_file(path: &str) -> Result<game_config::GameConfig, Error>{
  let bytes = fs::read(path).map_err(|e| Error::code(ErrorCode::Message(e.to_string())))?;

  de::from_slice(&bytes)
}

pub fn deserialize_plugin_info(value: &[u8]) -> Result<plugin_info::PluginInfo, Error>{
  de::from_slice(value)
}

pub fn decode_plugin_info_file(path: &str) -> Result<plugin_info::PluginInfo, Error>{
  let bytes = fs::read(path).map_err(|e| Error::code(ErrorCode::Message(e.to_string())))?;

  de::from_slice(&bytes)
}