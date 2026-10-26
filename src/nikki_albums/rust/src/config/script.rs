use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub enum Script{
  EasyScript(Vec<EasyScript>),
  JS(String),
  Wasm(String),
}

#[derive(Serialize, Deserialize)]
pub enum EasyScript{
  RegisterLoc(),
  RegisterGlobalLoc(),
  RegisterIcon(),
  RegisterGlobalIcon(),
  RegisterScript(),
}