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
  pub dressing: Vec<Cloth>,
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
pub struct Dressing{
  pub clothes: Vec<Cloth>,
  pub magicball: Vec<i64>,
}

#[derive(Clone)]
pub struct Cloth{
  pub id: i64,
  pub diy: Vec<Diy>,
}

#[derive(Clone)]
pub enum Diy{
  OutfitDye(Vec<OutfitDyeData>),
  SpecialEffect(Vec<SpecialEffectData>),
  PatternCreation(Vec<PatternCreationData>),
}

#[derive(Clone)]
pub enum OutfitDyeData{
  Hair(OutfitDyeHairData),
  General(OutfitDyeGeneralData),
}

#[derive(Clone)]
pub struct OutfitDyeHairData{
  pub target_group_id: i64,
  pub feature_tag: i64,
  pub color_0: DyeColor,
  pub color_1: Option<DyeColor>,
  pub roughness: f64,
  pub color_mode: Option<i64>,
}

#[derive(Clone)]
pub struct OutfitDyeGeneralData{
  pub target_group_id: i64,
  pub feature_tag: i64,
  pub color: DyeColor,
}

#[derive(Clone)]
pub struct SpecialEffectData{
  pub target_group_id: i64,
  pub feature_tag: i64,
  pub color_grid: u16,
  pub cover_diy_color: bool,
}

#[derive(Clone)]
pub struct PatternCreationData{
  pub target_group_id: i64,
  pub feature_tag: i64,
  pub texture_id: i64,
  pub override_pattern_a: bool,
  pub tiling: f64,
}

#[derive(Clone)]
pub struct DyeColor{
  pub color: (f64, f64, f64, f64),
  pub color_grid: u16,
}

#[derive(Clone)]
pub struct Weapon{
  pub id: i64,
  pub slot_type: String,
  pub state: Option<String>,
}

#[derive(Clone)]
pub struct Object{
  pub id: i64,
  pub loc: (f64, f64, f64),
  pub rot: (f64, f64, f64),
  pub scale: (f64, f64, f64),
}








