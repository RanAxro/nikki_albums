use std::collections::HashMap;
use std::ops::{Deref, DerefMut};
use serde::{Deserialize, Serialize};

pub const ID_MAP_TOKEN: &str = "IdMap";


#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct IdMap<T>(HashMap<i64, T>);

impl<T> IdMap<T>{
  pub fn new() -> Self{
    IdMap(HashMap::new())
  }
}

impl IdMap<bool>{
  pub fn as_bool(&self) -> &HashMap<i64, bool>{
    &self.0
  }
}

impl IdMap<i64>{
  pub fn as_i64(&self) -> &HashMap<i64, i64>{
    &self.0
  }
}

impl<T> Deref for IdMap<T>{
  type Target = HashMap<i64, T>;
  fn deref(&self) -> &Self::Target{
    &self.0
  }
}

impl<T> DerefMut for IdMap<T>{
  fn deref_mut(&mut self) -> &mut Self::Target{
    &mut self.0
  }
}

// #[frb(sync, positional)]
// pub fn convert_to_bool_id_map(map: IdMap<bool>) -> HashMap<i64, bool>{
//   map.as_bool().clone()
// }
// #[frb(sync, positional)]
// pub fn convert_to_int_id_map(map: IdMap<i64>) -> HashMap<i64, i64>{
//   map.as_i64().clone()
// }


// #[frb(non_opaque)]
#[derive(Clone)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum AdaptiveArray<T>{
  Array(Vec<T>),
  Item(T),
  Empty{},
}




// #[derive(Clone)]
// #[derive(Serialize, Deserialize)]
// pub struct EmptyMap{
//
// }

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum OptionMap<T>{
  None{},
  Some(T),
}

// #[macro_export]
// macro_rules! option_map{
//   ($($type:ty => $name:ident),+ $(,)?) => {
//     $(
//       #[derive(Clone)]
//       #[derive(Serialize, Deserialize)]
//       #[serde(untagged)]
//       pub enum $name {
//         None(EmptyMap),
//         Some($type),
//       }
//     )+
//   };
// }
//
// option_map!{String => StringOptionMap, i64 => Int}


