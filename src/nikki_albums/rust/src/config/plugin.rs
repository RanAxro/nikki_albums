use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use crate::config::common::platform::Platform;
use crate::config::script::Script;
use crate::impl_json_frb;
use super::rules::{
  text_rule::TextRule,
  icon_rule::IconRule,
};

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
  pub name: TextRule,
  pub description: TextRule,
  pub icon: Option<IconRule>,
  pub version: u32,
  pub author: Option<String>,
  pub web: Option<String>,
  pub download_url: Option<String>,
  pub plugin_list: Option<String>,
  pub app_version: u32,
  pub platforms: Vec<Platform>,

  pub entrance: Script,
}

impl_json_frb!(PluginInfo);