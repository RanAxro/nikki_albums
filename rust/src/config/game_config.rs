// use std::collections::HashMap;
// use flutter_rust_bridge::frb;
// use serde::{Serialize, Deserialize};
// use crate::config::common::TextConfig;
// 
// #[frb]
// #[derive(Serialize, Deserialize)]
// pub struct GameConfig{
//   pub id: String,
//   pub name: TextConfig,
// 
//   #[serde(skip_serializing_if = "Option::is_none")]
//   pub icon: Option<String>,
//   pub albums_config: Vec<GameAlbumConfig>,
//   pub uid_config: GameUidConfig,
//   pub selector_config: GameSelectorConfig,
//   pub windows: Option<WindowsGameConfig>,
//   pub macos: Option<MacOSGameConfig>,
//   pub android: Option<AndroidGameConfig>,
// }
// 
// 
// #[frb]
// #[derive(Serialize, Deserialize)]
// pub struct GameAlbumConfig{
//   pub id: String,
//   pub visible: bool,
//   pub name: TextConfig,
// 
//   #[serde(skip_serializing_if = "Option::is_none")]
//   pub description: Option<TextConfig>,
// 
//   #[serde(skip_serializing_if = "Option::is_none")]
//   pub icon: Option<String>,
//   pub require_uid: bool,
//   pub locate: String,
//   pub to_media: String,
//   pub to_cover: Option<String>,
//   pub to_thumbnail: Option<String>,
//   pub allow_move: bool,
//   pub allow_delete: bool,
//   pub allow_cache: bool,
//   pub chain_deletion: HashMap<String, bool>,
// }