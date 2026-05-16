use std::collections::HashMap;
use std::ops::{Deref, DerefMut};
use serde::{Deserialize, Serialize};

pub const ID_MAP_TOKEN: &str = "IdMap";


#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub(crate) struct IdMap<T>(HashMap<i64, T>);

impl<T> IdMap<T>{
  pub(crate) fn new() -> Self{
    IdMap(HashMap::new())
  }
}

impl<T: Clone> IdMap<T>{
  pub(crate) fn as_map(&self) -> HashMap<i64, T>{
    self.0.clone()
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


#[derive(Clone)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub(crate) enum AdaptiveArray<T>{
  Array(Vec<T>),
  Item(T),
  Empty{},
}

impl<T: Clone> AdaptiveArray<T>{
  pub(crate) fn to_vec(&self) -> Vec<T>{
    match self{
      AdaptiveArray::Array(v) => {
        v.clone()
      },
      AdaptiveArray::Item(v) => {
        vec![v.clone()]
      },
      AdaptiveArray::Empty{} => vec![],
    }
  }
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub(crate) enum OptionMap<T>{
  None{},
  Some(T),
}