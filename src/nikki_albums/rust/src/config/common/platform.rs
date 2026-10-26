use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize)]
pub enum Platform{
  Windows,
  MacOS,
  Android,
  Web,
}