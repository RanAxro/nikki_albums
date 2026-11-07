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
  pub icon: IconRule
}

impl_json_frb!(GameRegistry);

#[derive(Serialize, Deserialize)]
pub struct Game{
  pub unique_id: String,
  pub info: HashMap<String, String>,
  pub install_path: String,
}

impl_json_frb!(Game);
impl_vec_json_frb!(Game);

#[derive(Serialize, Deserialize)]
pub struct GameSession{
  pub game: Game,
  pub account: Option<String>,
  pub album: Option<String>,
}

impl_json_frb!(GameSession);