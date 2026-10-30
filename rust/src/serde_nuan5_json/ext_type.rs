use std::collections::HashMap;
use std::ops::{Deref, DerefMut};
use serde::{Deserialize, Deserializer, Serialize, Serializer};
use serde::de::DeserializeOwned;

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
  pub(crate) fn as_vec(&self) -> Vec<T>{
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

impl<T: Clone> OptionMap<T>{
  pub(crate) fn as_option(&self) -> Option<T>{
    match self{
      OptionMap::Some(v) => Some(v.clone()),
      OptionMap::None{} => None,
    }
  }
}

impl<T> OptionMap<T>{
  pub(crate) fn to_option(self) -> Option<T>{
    match self{
      OptionMap::Some(v) => Some(v),
      OptionMap::None{} => None,
    }
  }

  pub(crate) fn as_option_map_ref(&self) -> OptionMap<&T>{
    match self{
      OptionMap::Some(v) => OptionMap::Some(&v),
      OptionMap::None{} => OptionMap::None{},
    }
  }

  pub(crate) fn as_option_ref(&self) -> Option<&T>{
    match self{
      OptionMap::Some(v) => Some(&v),
      OptionMap::None{} => None,
    }
  }
}


#[derive(Clone)]
pub enum OptionValue<T: Serialize + DeserializeOwned>{
  Value(T),
  None,
}

impl<T: Serialize + DeserializeOwned> OptionValue<T>{
  pub fn as_value(&self) -> Option<&T>{
    match self {
      OptionValue::Value(v) => Some(v),
      OptionValue::None => None,
    }
  }
}

impl<T: Serialize + DeserializeOwned> Serialize for OptionValue<T>{
  fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
  where
    S: Serializer
  {
    match self{
      OptionValue::Value(v) => v.serialize(serializer),
      OptionValue::None => "".serialize(serializer),
    }
  }
}

impl<'de, T: Serialize + DeserializeOwned> Deserialize<'de> for OptionValue<T>{
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>
  {
    #[derive(Deserialize)]
    enum TemporaryOptionValue<T>{
      Value(T),
      None(String),
    }
    let value: TemporaryOptionValue<T> = serde::de::Deserialize::deserialize(deserializer)?;
    Ok(match value{
      TemporaryOptionValue::Value(v) => {
        OptionValue::Value(v)
      },
      TemporaryOptionValue::None(_) => {
        OptionValue::None
      },
    })
  }
}