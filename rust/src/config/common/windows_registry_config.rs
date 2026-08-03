use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};


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
pub enum WindowsRegistryValue{
  Binary,
  Int,
  String,
  StringArray,
}

#[frb]
#[derive(Serialize, Deserialize)]
pub struct WindowsRegistryConfig{
  pub hive: WindowsRegistryHive,
  pub path: String,
  pub key: String,
  pub value: WindowsRegistryValue,
}