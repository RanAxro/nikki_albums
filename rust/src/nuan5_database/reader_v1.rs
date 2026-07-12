use flutter_rust_bridge::frb;
use std::collections::HashMap;
use prost::Message;
use super::model::{Nuan5DatabaseCategory, Nuan5DatabaseItem};
use super::nuan5_database::Nuan5DatabaseReader;
use super::model::*;


#[frb(opaque)]
pub struct Nuan5DatabaseReaderV1{
  data: Option<Nuan5DatabaseV1>,
}

impl Nuan5DatabaseReaderV1{
  #[frb(sync)]
  pub fn new() -> Self{
    Self{ data: None }
  }
}

impl Nuan5DatabaseReader for Nuan5DatabaseReaderV1{
  #[frb(sync)]
  fn is_open(&self) -> bool{
    self.data.is_some()
  }

  fn open(&mut self, path: &str) -> bool{
    let bytes = match nuan5_data_decrypt(path){
      Some(b) => b,
      None => {
        return false;
      },
    };

    match Nuan5DatabaseV1::decode(&*bytes){
      Ok(data) => {
        self.data = Some(data);
      },
      Err(_) => {
        return false;
      }
    }

    true
  }

  fn close(&mut self){
    self.data = None;
  }

  fn has(&self, category: &Nuan5DatabaseCategory) -> bool{
    if !self.is_open() {
      return false;
    }

    use Nuan5DatabaseCategory::*;

    !match category{
      Light => self.data.as_ref().unwrap().light.is_empty(),
      LightType => self.data.as_ref().unwrap().light_type.is_empty(),
      Filter => self.data.as_ref().unwrap().filter.is_empty(),
      FilterType => self.data.as_ref().unwrap().filter_type.is_empty(),
      MomoPose => self.data.as_ref().unwrap().momo_pose.is_empty(),
      ClothDyeArea => self.data.as_ref().unwrap().cloth_dye_area.is_empty(),
      ClothDyePalette => self.data.as_ref().unwrap().cloth_dye_palette.is_empty(),
      ClothDiySwatchColor => self.data.as_ref().unwrap().cloth_diy_swatch_color.is_empty(),
    }
  }

  fn list(&self, category: &Nuan5DatabaseCategory, from: usize, max: isize) -> Vec<i32>{
    if !self.is_open() {
      return Vec::new();
    }

    use Nuan5DatabaseCategory::*;

    let mut keys: Vec<i32> = match category{
      Light => self.data.as_ref().unwrap().light.keys().copied().collect(),
      LightType => self.data.as_ref().unwrap().light_type.keys().copied().collect(),
      Filter => self.data.as_ref().unwrap().filter.keys().copied().collect(),
      FilterType => self.data.as_ref().unwrap().filter_type.keys().copied().collect(),
      MomoPose => self.data.as_ref().unwrap().momo_pose.keys().copied().collect(),
      ClothDyeArea => self.data.as_ref().unwrap().cloth_dye_area.keys().copied().collect(),
      ClothDyePalette => self.data.as_ref().unwrap().cloth_dye_palette.keys().copied().collect(),
      ClothDiySwatchColor => self.data.as_ref().unwrap().cloth_diy_swatch_color.keys().copied().collect(),
    };

    // 排序! HashMap的key不保证顺序
    keys.sort_unstable();

    if from >= keys.len() {
      return Vec::new();
    }

    let end = if max < 0 {
      keys.len()
    }else{
      (from + max as usize).min(keys.len())
    };

    keys[from..end].to_vec()
  }

  fn get(&self, category: &Nuan5DatabaseCategory, ids: &[i32]) -> HashMap<i32, Nuan5DatabaseItem>{
    if !self.is_open() || ids.is_empty() {
      return HashMap::new();
    }

    use Nuan5DatabaseCategory::*;

    let mut result = HashMap::with_capacity(ids.len());

    match category{
      Light => {
        let map = &self.data.as_ref().unwrap().light;
        for &id in ids {
          if let Some(item) = map.get(&id) {
            result.insert(id, Nuan5DatabaseItem::Light(item.clone()));
          }
        }
      },
      LightType => {
        let map = &self.data.as_ref().unwrap().light_type;
        for &id in ids {
          if let Some(item) = map.get(&id) {
            result.insert(id, Nuan5DatabaseItem::LightType(item.clone()));
          }
        }
      },
      Filter => {
        let map = &self.data.as_ref().unwrap().filter;
        for &id in ids {
          if let Some(item) = map.get(&id) {
            result.insert(id, Nuan5DatabaseItem::Filter(item.clone()));
          }
        }
      },
      FilterType => {
        let map = &self.data.as_ref().unwrap().filter_type;
        for &id in ids {
          if let Some(item) = map.get(&id) {
            result.insert(id, Nuan5DatabaseItem::FilterType(item.clone()));
          }
        }
      },
      MomoPose => {
        let map = &self.data.as_ref().unwrap().momo_pose;
        for &id in ids {
          if let Some(item) = map.get(&id) {
            result.insert(id, Nuan5DatabaseItem::MomoPose(item.clone()));
          }
        }
      },
      ClothDyeArea => {
        let map = &self.data.as_ref().unwrap().cloth_dye_area;
        for &id in ids {
          if let Some(item) = map.get(&id) {
            result.insert(id, Nuan5DatabaseItem::ClothDyeArea(item.clone()));
          }
        }
      },
      ClothDyePalette => {
        let map = &self.data.as_ref().unwrap().cloth_dye_palette;
        for &id in ids {
          if let Some(item) = map.get(&id) {
            result.insert(id, Nuan5DatabaseItem::ClothDyePalette(item.clone()));
          }
        }
      },
      ClothDiySwatchColor => {
        let map = &self.data.as_ref().unwrap().cloth_diy_swatch_color;
        for &id in ids {
          if let Some(item) = map.get(&id) {
            result.insert(id, Nuan5DatabaseItem::ClothDiySwatchColor(item.clone()));
          }
        }
      },
    }

    result
  }
}

impl Nuan5DatabaseReaderV1{
  #[frb(sync)]
  pub fn has_sync(&self, category: &Nuan5DatabaseCategory) -> bool{
    self.has(category)
  }

  #[frb(sync)]
  pub fn list_sync(&self, category: &Nuan5DatabaseCategory, from: usize, max: isize) -> Vec<i32>{
    self.list(category, from, max)
  }

  #[frb(sync)]
  pub fn get_sync(&self, category: &Nuan5DatabaseCategory, ids: &[i32]) -> HashMap<i32, Nuan5DatabaseItem>{
    self.get(category, ids)
  }
}

#[frb(ignore)]
#[derive(Message)]
struct Nuan5DatabaseV1{
  #[prost(map = "int32, message", tag = "1")]
  pub light: HashMap<i32, Nuan5Light>,

  #[prost(map = "int32, message", tag = "2")]
  pub light_type: HashMap<i32, Nuan5LightType>,

  #[prost(map = "int32, message", tag = "3")]
  pub filter: HashMap<i32, Nuan5Filter>,

  #[prost(map = "int32, message", tag = "4")]
  pub filter_type: HashMap<i32, Nuan5FilterType>,

  #[prost(map = "int32, message", tag = "5")]
  pub momo_pose: HashMap<i32, Nuan5MomoPose>,

  #[prost(map = "int32, message", tag = "6")]
  pub cloth_dye_area: HashMap<i32, Nuan5ClothDyeArea>,

  #[prost(map = "int32, message", tag = "7")]
  pub cloth_dye_palette: HashMap<i32, Nuan5ClothDyePalette>,

  #[prost(map = "int32, message", tag = "8")]
  pub cloth_diy_swatch_color: HashMap<i32, Nuan5ClothDiySwatchColor>,
}


use aes_gcm::{
  aead::{Aead, KeyInit},
  Aes256Gcm, Key,
};
use hkdf::Hkdf;
use sha2::Sha256;
use std::fs;

const KEY: &[u8; 32] = b"9C46C6BF431F5AFFF97A2002AEDFA8B7";
const SALT_LEN: usize = 16;
const NONCE_LEN: usize = 12;

fn derive_key(salt: &[u8; SALT_LEN]) -> Key<Aes256Gcm>{
  let hkdf = Hkdf::<Sha256>::new(Some(salt), KEY);
  let mut okm = [0u8; 32];
  hkdf.expand(b"aes-gcm-filebox", &mut okm).unwrap();
  okm.into()
}

pub fn nuan5_data_decrypt(input: &str) -> Option<Vec<u8>>{
  let data = fs::read(input).ok()?;

  if data.len() < SALT_LEN + NONCE_LEN + 16 {
    return None;
  }

  let salt: [u8; SALT_LEN] = data[..SALT_LEN].try_into().ok()?;
  let nonce: [u8; NONCE_LEN] = data[SALT_LEN..SALT_LEN + NONCE_LEN].try_into().ok()?;
  let ciphertext = &data[SALT_LEN + NONCE_LEN..];

  let aes_key = derive_key(&salt);
  let cipher = Aes256Gcm::new(&aes_key);

  cipher.decrypt(&nonce.into(), ciphertext).ok()
}
