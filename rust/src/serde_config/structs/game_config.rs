use serde::{Deserialize, Serialize};
use super::common::*;


#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct GameConfig{
  pub id: String,
  pub name: Text,
  pub icon: Option<String>,
  pub windows: Option<WindowsGameConfig>,
  pub macos: Option<MacOSGameConfig>,
  pub android: Option<AndroidGameConfig>,
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
    to_launcher_regex: Option<String>,
    to_install: String,
    to_install_regex: Option<String>,
  }
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct WindowsRegistryConfig{
  pub hive: WindowsRegistryHive,
  pub path: String,
  pub key: String,
  pub regex: Option<String>,
  pub locate: String,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct WindowsCustomGameConfig{
  pub to_launcher_tip: Option<Text>,
  pub to_launcher: Option<Vec<FileEntityLocationConfig>>,
  pub to_launcher_then_to_install: Option<Vec<String>>,
  pub to_install_tip: Option<Text>,
  pub to_install: Vec<FileEntityLocationConfig>,
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
  pub to_launcher_tip: Option<Text>,
  pub to_launcher_then_to_install: String,
}



