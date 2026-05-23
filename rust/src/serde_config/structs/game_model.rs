use serde::{Deserialize, Serialize};
use crate::serde_config::structs::text::Text;


#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct GameModel{
  pub launcher: LauncherModel,
  pub install_path: Vec<String>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum LauncherModel{
  Windows,
  Android,
  MacOS,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum WindowsLauncherConfig{
  System{
    channel: i64,
    path: Vec<String>,
  },
  Custom{
    name: Text,
    path: Vec<String>,
  },
}

