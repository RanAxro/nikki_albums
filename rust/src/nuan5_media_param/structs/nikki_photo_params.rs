use std::collections::HashMap;
use super::world::Location;

#[derive(Clone)]
pub struct NikkiPhotoParams{
  pub photography: PhotographyParams,
  pub camera: Option<CameraParams>,
  pub nikki: Option<NikkiParams>,
  pub momo: Option<MomoHiddenState>,
}

#[derive(Clone)]
pub struct PhotographyParams{
  pub edit: EditPhotoState,
  pub date: Option<ShootingDate>,
  pub time: Option<ShootingTime>,
  pub location: Option<Location>,
  pub weather: Option<i64>,
  pub photo_wall: Vec<i64>,
  pub task: Vec<Task>,
}

#[derive(Clone)]
pub struct CameraParams{
  pub params: String,
  pub portrait_mode: bool,
  pub zoom: f64,
  pub focal_length: f64,
  pub rotation: f64,
  pub aperture_section: u8,
  pub vignette_intensity: f64,
  pub bloom_intensity: f64,
  pub bloom_threshold: f64,
  pub brightness: f64,
  pub exposure: f64,
  pub contrast: f64,
  pub saturation: f64,
  pub vibrance: f64,
  pub highlights: f64,
  pub shadows: f64,
  pub light: Light,
  pub filter: Filter,
  pub pose: String,
}

#[derive(Clone)]
pub struct NikkiParams{
  pub giant_state: bool,
  pub hidden: bool,
  pub loc: (f64, f64, f64),
  pub rot: (f64, f64, f64),
  pub scale: (f64, f64, f64),
  // dressing 
  pub clothes: Vec<Cloth>,
  pub weapon: Option<Weapon>,
  pub interactions: Vec<Object>,
  pub mount: Option<Object>,
  pub carrier: Option<Object>,
}

#[derive(Clone)]
pub enum MomoHiddenState{
  Enabled,
  Disabled(MomoParams),
}

#[derive(Clone)]
pub struct MomoParams{
  pub loc: (f64, f64, f64),
  pub rot: (f64, f64, f64),
  pub scale: (f64, f64, f64),
  pub clothes: Vec<Cloth>,
}



#[derive(Clone)]
pub enum EditPhotoState{
  Enabled(EditPhotoParams),
  Disabled,
}

#[derive(Clone)]
pub struct EditPhotoParams{
  pub has_sticker: bool,
  pub has_text: bool,
}

#[derive(Clone)]
pub struct ShootingDate{
  pub day: i64,
}

#[derive(Clone)]
pub struct ShootingTime{
  pub hour: u8,
  pub min: u8,
  pub sec: f64,
}

#[derive(Clone)]
pub enum Task{
  Puzzle(i64),
  Risk(HashMap<i64, bool>),
  Interactive(HashMap<i64, bool>),
}

#[derive(Clone)]
pub enum Light{
  Some{
    id: String,
    strength: f64,
  },
  None,
}

#[derive(Clone)]
pub enum Filter{
  Some{
    id: String,
    strength: f64,
  },
  None,
}

#[derive(Clone)]
pub struct Cloth{

}

#[derive(Clone)]
pub struct Weapon{
  id: i64,
  slot_type: String,
  state: Option<String>,
}

#[derive(Clone)]
pub struct Object{
  pub id: i64,
  pub loc: (f64, f64, f64),
  pub rot: (f64, f64, f64),
  pub scale: (f64, f64, f64),
}








