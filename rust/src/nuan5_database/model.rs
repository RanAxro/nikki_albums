use std::collections::HashMap;
use prost::Message;

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5Config{
  #[prost(message, tag = "20000")]
  pub table: Option<Nuan5Table>,

  #[prost(message, tag = "20001")]
  pub network_image: Option<Nuan5NetworkImage>,

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

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5Table{
  #[prost(int32, repeated, tag = "1")]
  pub light_type: Vec<i32>,

  #[prost(int32, repeated, tag = "2")]
  pub filter_type: Vec<i32>,

  #[prost(int32, repeated, tag = "3")]
  pub momo_pose: Vec<i32>,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5NetworkImage{
  #[prost(message, tag = "1")]
  pub light: Option<Nuan5NetworkImageItem>,

  #[prost(message, tag = "2")]
  pub filter: Option<Nuan5NetworkImageItem>,

  #[prost(message, tag = "3")]
  pub momo_pose: Option<Nuan5NetworkImageItem>,

  #[prost(message, tag = "4")]
  pub cloth: Option<Nuan5NetworkImageItem>,

  #[prost(message, tag = "5")]
  pub cloth_outfit: Option<Nuan5NetworkImageItem>,

  #[prost(message, tag = "6")]
  pub diy_pattern: Option<Nuan5NetworkImageItem>,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5NetworkImageItem{
  #[prost(string, tag = "1")]
  pub base_url: String,

  #[prost(string, tag = "2")]
  pub replace: String,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5Light{
  #[prost(string, tag = "1")]
  pub string_id: String,

  #[prost(string, tag = "2")]
  pub param_id: String,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5LightType{
  #[prost(int32, repeated, tag = "1")]
  pub light: Vec<i32>,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5Filter{
  #[prost(string, tag = "1")]
  pub string_id: String,

  #[prost(string, tag = "2")]
  pub param_id: String,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5FilterType{
  #[prost(int32, repeated, tag = "1")]
  pub filter: Vec<i32>,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5MomoPose{
  #[prost(string, tag = "1")]
  pub string_id: String,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5ClothDyeArea{
  #[prost(int32, tag = "1")]
  pub max_color_area_num: i32,

  #[prost(int32, tag = "2")]
  pub max_pattern_area_num: i32,

  #[prost(int32, tag = "3")]
  pub max_pattern_mask_num: i32,

  #[prost(int32, repeated, tag = "4")]
  pub custom_area_order: Vec<i32>,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5ClothDyePalette{
  #[prost(int32, repeated, tag = "1")]
  pub directly: Vec<i32>,

  #[prost(int32, repeated, tag = "2")]
  pub complete: Vec<i32>,

  #[prost(int32, repeated, tag = "3")]
  pub grow_up: Vec<i32>,

  #[prost(int32, repeated, tag = "4")]
  pub evolution_1: Vec<i32>,

  #[prost(int32, repeated, tag = "5")]
  pub evolution_2: Vec<i32>,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5ClothDiySwatchColor{
  #[prost(double, repeated, tag = "1")]
  pub rgba: Vec<f64>,
}

#[derive(Clone, PartialEq)]
#[derive(Message)]
pub struct Nuan5DiyPattern{
  #[prost(string, tag = "1")]
  pub string_id: String,
}