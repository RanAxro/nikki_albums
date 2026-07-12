use prost::Message;

pub enum Nuan5DatabaseCategory{
  Light = 1,
  LightType = 2,
  Filter = 3,
  FilterType = 4,
  MomoPose = 5,
  ClothDyeArea = 6,
  ClothDyePalette = 7,
  ClothDiySwatchColor = 8,
}

pub enum Nuan5DatabaseItem{
  Light(Nuan5Light),
  LightType(Nuan5LightType),
  Filter(Nuan5Filter),
  FilterType(Nuan5FilterType),
  MomoPose(Nuan5MomoPose),
  ClothDyeArea(Nuan5ClothDyeArea),
  ClothDyePalette(Nuan5ClothDyePalette),
  ClothDiySwatchColor(Nuan5ClothDiySwatchColor),
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