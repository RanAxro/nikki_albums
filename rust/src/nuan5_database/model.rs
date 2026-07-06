use serde::Deserialize;

pub enum Nuan5DatabaseCategory{
  Light = 1,
  Filter = 2,
  ClothDyeArea = 3,
  ClothDyePalette = 4,
  ClothDiySwatchColor = 5,
}

pub enum Nuan5DatabaseItem{
  Light(Nuan5Light),
  Filter(Nuan5Filter),
  ClothDyeArea(Nuan5ClothDyeArea),
  ClothDyePalette(Nuan5ClothDyePalette),
  ClothDiySwatchColor(Nuan5ClothDiySwatchColor),
}

#[derive(Clone)]
#[derive(Deserialize)]
pub struct Nuan5Light{
  pub string_id: String,
}

#[derive(Clone)]
#[derive(Deserialize)]
pub struct Nuan5Filter{
  pub string_id: String,
}

#[derive(Clone)]
#[derive(Deserialize)]
pub struct Nuan5ClothDyeArea{
  pub max_color_area_num: i32,
  pub max_pattern_area_num: i32,
  pub max_pattern_mask_num: i32,
}

#[derive(Clone)]
#[derive(Deserialize)]
pub struct Nuan5ClothDyePalette{
  pub directly: Vec<i32>,
  pub complete: Vec<i32>,
  pub grow_up: Vec<i32>,
  pub evolution_1: Vec<i32>,
  pub evolution_2: Vec<i32>,
}

#[derive(Clone)]
#[derive(Deserialize)]
pub struct Nuan5ClothDiySwatchColor{
  pub r: f64,
  pub g: f64,
  pub b: f64,
  pub a: f64,
}