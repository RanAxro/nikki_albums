use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Serialize, Deserialize};
use crate::config::game::{DeviceGame, DeviceGameSession, DeviceGameAccount};
use crate::impl_json_frb;

#[frb(dart_metadata=("freezed"))]
#[derive(Serialize, Deserialize)]
pub struct AppPersistentState{
  pub is_agree_agreement: Option<bool>,
  pub is_initial_startup: Option<bool>,

  pub lang: Option<String>,
  pub theme: Option<i32>,

  pub selected_device_game: Option<DeviceGameSession>,
  pub picked_device_game: Option<Vec<DeviceGame>>,
  pub hidden_account: Option<Vec<DeviceGameAccount>>,
  pub starred_account: Option<Vec<DeviceGameAccount>>,
  pub customly_added_account: Option<Vec<DeviceGameAccount>>,

  #[serde(flatten)]
  pub unknown_field: HashMap<String, String>,
}

impl_json_frb!(AppPersistentState);