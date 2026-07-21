use prost::Message;
use crate::nuan5_database::nuan5_database::nuan5_database_decrypt;
use super::model::Nuan5Config;

impl Nuan5Config{
  pub fn try_from(path: &str) -> Option<Self>{
    let bytes = nuan5_database_decrypt(path)?;

    Self::decode(&*bytes).ok()
  }
}