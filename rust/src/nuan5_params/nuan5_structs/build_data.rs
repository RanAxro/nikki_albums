use std::collections::HashMap;
use serde::{Serialize, Deserialize};
use crate::serde_nuan5_json::ext_type::IdMap;

#[derive(Serialize, Deserialize)]
pub struct BuildData{
  #[serde(rename = "NeedRestore")]
  pub need_restore: bool,

  #[serde(rename = "PlaceInfo")]
  pub place_info: Vec<PlaceInfo>,
}

#[derive(Serialize, Deserialize)]
pub struct RichBuildData{
  #[serde(rename = "Name")]
  pub name: String,

  #[serde(rename = "CoverImage")]
  pub cover_image: Option<String>,

  #[serde(rename = "Rid")]
  pub rid: Option<Vec<i64>>,

  #[serde(rename = "MapID")]
  pub map_id: i32,

  #[serde(rename = "LastModifyTime")]
  pub last_modify_time: i64,

  #[serde(rename = "Uid")]
  pub uid: i64,

  #[serde(rename = "GameArea")]
  pub game_area: String,

  #[serde(rename = "TemplateType")]
  pub template_type: i32,

  #[serde(rename = "PlaceInfo")]
  pub place_info: Vec<PlaceInfo>,

  #[serde(rename = "ExtraInfo")]
  pub extra_info: ExtraInfo,
}

#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum ColorMap{
  Map(HashMap<String, i32>),
  Vec(Vec<Option<i32>>),
}

#[derive(Serialize, Deserialize)]
pub struct PlaceInfo{
  #[serde(rename = "InstanceID")]
  pub instance_id: i32,

  #[serde(rename = "GroupID")]
  pub group_id: i32,

  #[serde(rename = "ItemID")]
  pub item_id: i32,

  #[serde(rename = "AttachID")]
  pub attach_id: i32,

  #[serde(rename = "ColorMap")]
  pub color_map: ColorMap,

  #[serde(rename = "TempInfo")]
  pub temp_info: TempInfo,

  #[serde(rename = "Location")]
  pub location: Location,

  #[serde(rename = "Rotation")]
  pub rotation: Rotation,

  #[serde(rename = "Scale")]
  pub scale: Scale,
}

#[derive(Serialize, Deserialize, Default)]
pub struct TempInfo{
  #[serde(skip_serializing_if = "Option::is_none")]
  pub points: Option<Vec<Vec<f64>>>,
}

#[derive(Serialize, Deserialize)]
pub struct Location{
  #[serde(rename = "X")]
  pub x: f32,

  #[serde(rename = "Y")]
  pub y: f32,

  #[serde(rename = "Z")]
  pub z: f32,
}

#[derive(Serialize, Deserialize)]
pub struct Rotation{
  #[serde(rename = "Pitch")]
  pub pitch: f32,

  #[serde(rename = "Yaw")]
  pub yaw: f32,

  #[serde(rename = "Roll")]
  pub roll: f32,
}

#[derive(Serialize, Deserialize)]
pub struct Scale{
  #[serde(rename = "X")]
  pub x: f32,

  #[serde(rename = "Y")]
  pub y: f32,

  #[serde(rename = "Z")]
  pub z: f32,
}

#[derive(Serialize, Deserialize)]
pub struct ExtraInfo{
  #[serde(rename = "Content")]
  pub content: ExtraInfoContent,
}

#[derive(Serialize, Deserialize)]
pub struct ExtraInfoContent{
  pub version: String,

  #[serde(skip_serializing_if = "Option::is_none")]
  pub temp_infos: Option<IdMap<TempInfo>>,
}