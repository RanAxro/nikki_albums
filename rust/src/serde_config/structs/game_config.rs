use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use super::common::*;


#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct GameConfig{
  pub id: String,
  pub name: Text,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub icon: Option<String>,
  pub albums_config: Vec<GameAlbumConfig>,
  pub windows: Option<WindowsGameConfig>,
  pub macos: Option<MacOSGameConfig>,
  pub android: Option<AndroidGameConfig>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct GameAlbumConfig{
  pub id: String,
  pub visible: bool,
  pub unimportance: bool,
  pub name: Text,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub description: Option<Text>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub icon: Option<String>,
  pub require_uid: bool,
  pub locate: String,
  pub to_media: String,
  pub to_cover: Option<String>,
  pub to_thumbnail: Option<String>,
  pub allow_move: bool,
  pub allow_delete: bool,
  pub cache_by_name: bool,
  pub chain_deletion: HashMap<String, bool>,
  pub platforms: Vec<Platform>,
}

/// -----------------
/// WindowsGameConfig
/// -----------------
#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct WindowsGameConfig{
  pub locate: Vec<WindowsGameLocationConfig>,
  pub custom: Option<WindowsCustomGameConfig>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct WindowsGameLocationConfig{
  pub channel: String,
  pub name: Text,
  pub icon: String,
  pub require_launcher: bool,
  pub searcher: Vec<WindowsGameSearcherConfig>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum WindowsGameSearcherConfig{
  Registry{
    to_launcher: Option<WindowsRegistryConfig>,
    to_install: WindowsRegistryConfig,
    use_config_file: bool,
  },
  ConfigFile{
    path: String,
    config_type: ConfigFileType,
    to_launcher: Option<String>,

    #[serde(skip_serializing_if = "Option::is_none")]
    to_launcher_regex: Option<String>,
    to_install: String,

    #[serde(skip_serializing_if = "Option::is_none")]
    to_install_regex: Option<String>,
  }
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct WindowsRegistryConfig{
  pub hive: WindowsRegistryHive,
  pub path: String,
  pub key: String,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub regex: Option<String>,
  pub locate: String,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct WindowsCustomGameConfig{
  #[serde(skip_serializing_if = "Option::is_none")]
  pub to_launcher_tip: Option<Text>,
  pub to_launcher: Option<Vec<FileEntityLocationConfig>>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub to_launcher_then_to_install: Option<Vec<String>>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub to_install_tip: Option<Text>,
  pub to_install: Vec<FileEntityLocationConfig>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub to_install_then_to_launcher: Option<Vec<String>>,
}


/// -----------------
/// MacOSGameConfig
/// -----------------
#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct MacOSGameConfig{
  pub locate: Vec<MacOSGameLocationConfig>,
  pub custom: Option<MacOSCustomGameConfig>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct MacOSGameLocationConfig{
  pub channel: String,
  pub name: Text,
  pub icon: String,
  pub searcher: MacOSGameSearcherConfig,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct MacOSGameSearcherConfig{
  pub bundle_id: String,
  pub to_install: String,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct MacOSCustomGameConfig{
  #[serde(skip_serializing_if = "Option::is_none")]
  pub to_launcher_tip: Option<Text>,
  pub to_launcher_then_to_install: String,
}

/// -----------------
/// AndroidGameConfig
/// -----------------
#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct AndroidGameConfig{
  pub locate: Vec<AndroidGameLocationConfig>,
  pub custom: Option<AndroidCustomGameConfig>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct AndroidGameLocationConfig{
  pub channel: String,
  pub name: Text,
  pub icon: String,
  pub searcher: AndroidGameSearcherConfig,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct AndroidGameSearcherConfig{
  pub application_id: String,
  pub to_install: String,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct AndroidCustomGameConfig{
  #[serde(skip_serializing_if = "Option::is_none")]
  pub to_launcher_tip: Option<Text>,
  pub to_launcher_then_to_install: String,
}



