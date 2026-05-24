use serde::{Deserialize, Serialize};
use crate::serde_config::structs::common::Text;


#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct GameModel{
  pub plugin: String,
  pub game: String,
  pub launcher: LauncherModel,
  pub install_path: Vec<String>,
  pub uid: Option<String>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum LauncherModel{
  Windows(WindowsLauncherModel),
  MacOS(MacOSLauncherModel),
  Android(AndroidLauncherModel),
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum WindowsLauncherModel{
  System{
    channel: String,
    path: Vec<String>,
  },
  Custom{
    name: Text,
    path: Vec<String>,
  },
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum MacOSLauncherModel{
  System{
    channel: String,
    bundle_id: String,
  },
}


#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum AndroidLauncherModel{
  System{
    channel: String,
    application_id: String,
  },
}

