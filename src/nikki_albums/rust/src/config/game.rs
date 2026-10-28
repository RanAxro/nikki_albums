use std::collections::HashMap;
use flutter_rust_bridge::frb;
use serde::{Serialize, Deserialize};
use crate::{impl_json_frb, impl_vec_json_frb};

#[derive(Serialize, Deserialize)]
pub struct Game{
  pub ownership: String,
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