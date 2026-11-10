use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use crate::config::common::platform::Platform;
use crate::config::game::DeviceGame;
use crate::config::rules::text_rule::TextRule;
use crate::impl_json_frb;

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum PluginSource{
  Internal,
  External,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct PluginInfo{
  pub as_extension_of: Option<String>,
  pub uuid: String,
  pub name: HashMap<String, String>,
  pub description: HashMap<String, String>,
  pub icon: Option<String>,
  pub version: u32,
  pub author: Option<String>,
  pub web: Option<String>,
  pub download_url: Option<String>,
  pub plugin_list: Option<String>,
  pub app_version: u32,
  pub platforms: Vec<Platform>,

  pub script_info: ScriptInfo,
}

impl_json_frb!(PluginInfo);


#[frb]
#[derive(Serialize, Deserialize)]
pub enum ScriptInfo{
  NES(Vec<NES>),
  JS(JSScriptInfo),
  Wasm(String),
}


#[frb]
#[derive(Serialize, Deserialize)]
pub struct JSScriptInfo{
  pub entrance: String,
  pub modules: HashMap<String, String>,
}


#[derive(Serialize, Deserialize)]
pub enum NES{
  RegisterLoc,
  RegisterGlobalLoc,
  RegisterIcon,
  RegisterGlobalIcon,
  RegisterScript,
}


#[derive(Serialize, Deserialize)]
pub enum PickedDeviceGameResult{
  Ok(DeviceGame),
  Err(Option<TextRule>),
}

impl_json_frb!(PickedDeviceGameResult);


#[derive(Serialize, Deserialize)]
pub enum AddedCustomAccountResult{
  Ok(String),
  Err(Option<TextRule>),
}

impl_json_frb!(AddedCustomAccountResult);

