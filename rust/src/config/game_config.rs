use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Serialize, Deserialize};
use crate::config::common::string_config::StringConfig;
use crate::config::common::text_config::TextConfig;
use crate::config::common::windows_registry_config::WindowsRegistryConfig;
use crate::impl_json_frb;


impl_json_frb!(GameConfig);

#[frb]
#[derive(Serialize, Deserialize)]
pub struct GameConfig{
  pub id: String,
  pub name: TextConfig,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub icon: Option<String>,
  pub albums_config: Vec<GameAlbumConfig>,

  pub channel_config: Vec<GameChannelConfig>,
  // pub uid_config: GameUidConfig,
  // pub selector_config: GameSelectorConfig,
  pub windows: Option<WindowsGameConfig>,
  // pub macos: Option<MacOSGameConfig>,
  // pub android: Option<AndroidGameConfig>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct GameChannelConfig{
  pub id: String,
  pub name: TextConfig,
  pub icon: Option<String>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct GameAlbumConfig{
  pub id: String,
  pub visible: bool,
  pub name: TextConfig,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub description: Option<TextConfig>,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub icon: Option<String>,
  pub require_uid: bool,
  pub locate: String,
  pub to_media: String,
  pub to_cover: Option<String>,
  pub to_thumbnail: Option<String>,
  pub allow_move: bool,
  pub allow_delete: bool,
  pub allow_cache: bool,
  pub chain_deletion: HashMap<String, bool>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct WindowsGameConfig{
  pub locate: Vec<WindowsGameLocationConfig>,
  // pub custom: Option<WindowsCustomGameConfig>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct WindowsGameLocationConfig{
  pub channel_id: String,
  pub require_launcher: bool,
  pub searcher: Vec<WindowsGameSearcherConfig>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub enum WindowsGameSearcherConfig{
  Registry(WindowsGameRegistrySearcherConfig),
  ConfigFile(WindowsGameConfigFileSearcherConfig)
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct WindowsGameRegistrySearcherConfig{
  pub to_launcher: Option<WindowsGameRegistryLocationConfig>,
  pub to_install: WindowsGameRegistryLocationConfig,
  pub use_config_file: bool,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct WindowsGameRegistryLocationConfig{
  pub registry: WindowsRegistryConfig,
  pub output: StringConfig,
  pub failed: Option<String>,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct WindowsGameConfigFileSearcherConfig{
  pub path: String,
  pub config_type: ConfigFileType,
  pub to_launcher: Option<WindowsGameConfigFileLocationConfig>,
  pub to_install: WindowsGameConfigFileLocationConfig,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub enum ConfigFileType{
  Json,
  Ini,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct WindowsGameConfigFileLocationConfig{
  pub key: String,
  pub output: StringConfig,
  pub failed: Option<String>,
}