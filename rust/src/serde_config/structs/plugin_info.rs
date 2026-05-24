use serde::{Deserialize, Serialize};
use super::common::*;

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum PluginSource{
  Internal,
  External,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct PluginInfo{
  pub id: String,
  pub name: Text,
  pub description: Text,
  pub icon: Option<String>,
  pub version: u32,
  pub author: Option<String>,
  pub web: Option<String>,
  pub download_url: Option<String>,
  pub plugin_list: Option<String>,
  pub app_version: u32,
  pub platforms: Vec<Platform>,
}