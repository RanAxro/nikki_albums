use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Serialize, Deserialize};
use crate::{impl_json_frb, impl_vec_json_frb};
use crate::config::rules::{
  text_rule::TextRule,
  icon_rule::IconRule,
};

#[frb(dart_metadata=("freezed"))]
#[derive(Serialize, Deserialize)]
pub struct GameRegistry{
  #[serde(default)]
  pub ownership: String,

  pub uuid: String,
  pub name: TextRule,
  pub icon: IconRule,
  pub connect_method: GameConnectionMethod,
  pub device_game_picker: Option<DeviceGamePickerConfig>,
  pub custom_account_adder: Option<CustomAccountAdderConfig>,
}

impl_json_frb!(GameRegistry);

#[derive(Serialize, Deserialize)]
pub enum GameConnectionMethod{
  Native,
  Adb,
  Shizuku,
}

#[derive(Serialize, Deserialize)]
pub struct DeviceGamePickerConfig{
  pub entrance_btn_text: Option<TextRule>,
  pub title: Option<TextRule>,
  pub tip: TextRule,
  pub name_text_field_label: Option<TextRule>,
  pub name_text_field_hint: Option<TextRule>,
  pub path_text_field_label: Option<TextRule>,
  pub path_text_field_hint: Option<TextRule>,
  pub picker_btn_tooltip: Option<TextRule>,
  pub picker_title: Option<TextRule>,
}

#[derive(Serialize, Deserialize)]
pub struct CustomAccountAdderConfig{
  pub entrance_btn_text: Option<TextRule>,
  pub title: Option<TextRule>,
  pub tip: TextRule,
  pub account_text_field_label: Option<TextRule>,
  pub account_text_field_hint: Option<TextRule>,
}

#[frb(dart_metadata=("freezed"))]
#[derive(Serialize, Deserialize)]
pub struct DeviceGame{
  pub unique_id: String,
  pub info: HashMap<String, String>,
  pub install_path: String,
}

impl_json_frb!(DeviceGame);
impl_vec_json_frb!(DeviceGame);

#[derive(Serialize, Deserialize)]
pub struct DeviceGameSession{
  pub device_game: DeviceGame,
  pub account: Option<String>,
  pub album: Option<String>,
}

impl_json_frb!(DeviceGameSession);

#[derive(Serialize, Deserialize)]
pub struct DeviceGameAccount{
  pub device_game: DeviceGame,
  pub account: String,
}

#[derive(Serialize, Deserialize)]
pub struct DeviceGameAccountNote{
  pub device_game_account: DeviceGameAccount,
  pub note: String,
}