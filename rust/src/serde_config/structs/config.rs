use serde::{Deserialize, Serialize};
use crate::serde_config::structs::common::Text;



#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum Channel{
  NikkiAlbums,
  Plugin(PluginConfig),
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct PluginConfig{
  pub id: i64,
  pub name: Text,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum UserConfigWrapper{
  V1(UserConfigV1),
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct UserConfigV1{
  pub v1: bool,
  pub is_agree_agreement: bool,
  pub lang: (String, Channel),
  pub theme: (String, Channel),
  // pub current_game: (GameConfig, Channel),
}

// #[derive(Clone)]
// #[derive(Serialize, Deserialize)]
// pub struct GameConfig{
//   pub launcher_channel: i64,
//   pub launcher_name: bool,
//   pub launcher_path: String,
//   pub install_path: String,
//   pub uid: Option<String>,
// }
