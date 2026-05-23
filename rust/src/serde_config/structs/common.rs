use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};


#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum Platform{
  Windows,
  MacOS,
  Android,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum ConfigFileType{
  Json,
  Ini,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum FileEntityType{
  File,
  Directory,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct FileEntityLocationConfig{
  pub entity_type: FileEntityType,
  pub on: String,
  pub locate: String,
  
  #[serde(skip_serializing_if = "Option::is_none")]
  pub and_discover_file: Option<Vec<String>>,
  
  #[serde(skip_serializing_if = "Option::is_none")]
  pub and_discover_directory: Option<Vec<String>>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub enum WindowsRegistryHive{
  ClassesRoot,
  CurrentUser,
  LocalMachine,
  AllUsers,
  PerformanceData,
  CurrentConfig,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum Text{
  Ordinary(OrdinaryText),
  Translate(TranslateText),
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct OrdinaryText{
  pub text: String,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct TranslateText{
  pub key: String,
  
  #[serde(skip_serializing_if = "Option::is_none")]
  pub args: Option<Vec<String>>,
  
  #[serde(skip_serializing_if = "Option::is_none")]
  pub named_args: Option<Vec<String>>,
  
  #[serde(skip_serializing_if = "Option::is_none")]
  pub gender: Option<String>,
}

impl TranslateText{
  #[frb(sync)]
  pub fn from_key(key: String) -> Self{
    TranslateText{
      key,
      args: None,
      named_args: None,
      gender: None,
    }
  }
}