use serde::{Serialize, Deserialize};
use rust_lib_nikki_albums_macro::with_transform_fields;
use super::super::ext_type::*;

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct NikkiPhotoCustomData{
  #[serde(rename = "EditPhotoHandler")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub edit_photo_handler: Option<EditPhotoHandler>,

  #[serde(rename = "InteractivePhoto")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub interactive_photo: Option<IdMap<bool>>,

  #[serde(rename = "PhotoWallPlugin")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub photo_wall_plugin: Option<PhotoWallPlugin>,

  #[serde(rename = "PortraitModeHandler")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub portrait_mode_handler: Option<PortraitModeHandler>,

  #[serde(rename = "PuzzleGamePlugin")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub puzzle_game_plugin: Option<PuzzleGamePlugin>,

  #[serde(rename = "RiskPhoto")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub risk_photo: Option<IdMap<bool>>,

  #[serde(rename = "SocialPhoto")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub social_photo: Option<SocialPhoto>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct MagazinePhotoCustomData{

}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct ClockInPhotoCustomData{
  #[serde(rename = "ClockGamePlugin")]
  pub clock_game_plugin: ClockGamePlugin,

  #[serde(rename = "PortraitModeHandler")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub portrait_mode_handler: Option<PortraitModeHandler>,

  #[serde(rename = "SocialPhoto")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub social_photo: Option<SocialPhoto>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct CollageCustomData{
  #[serde(rename = "TemplateId")]
  pub template_id: i64,

  #[serde(rename = "RegionPictures")]
  pub region_pictures: Vec<RegionPicture>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct DIYCustomData{
  #[serde(rename = "Content")]
  pub content: Content,
}



#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct Content{
  #[serde(rename = "PoseId")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub pose_id: Option<i64>,

  #[serde(rename = "patternData")]
  pub pattern_data: IdMap<i64>,

  #[serde(rename = "wearingClothes")]
  pub wearing_clothes: Vec<i64>,

  #[serde(rename = "wearingDIYInfos")]
  pub wearing_diy_infos: AdaptiveArray<NikkiDIY>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct RegionPicture{
  #[serde(rename = "ImageId")]
  pub image_id: String,

  #[serde(rename = "oriCustomData")]
  pub ori_custom_data: NikkiPhotoCustomData,

  #[serde(rename = "Position")]
  pub position: Position,

  #[serde(rename = "Rotation")]
  pub rotation: f64,

  #[serde(rename = "Scale")]
  pub scale: f64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct Position{
  #[serde(rename = "x")]
  pub x: f64,

  #[serde(rename = "y")]
  pub y: f64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct ClockGamePlugin{
  #[serde(rename = "Tag")]
  pub tag: i64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct EditPhotoHandler{
  #[serde(rename = "editState")]
  pub edit_state: bool,

  #[serde(rename = "hasSticker")]
  pub has_sticker: bool,

  #[serde(rename = "hasText")]
  pub has_text: bool,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct PhotoWallPlugin{
  #[serde(rename = "photoID")]
  pub photo_id: AdaptiveArray<i64>,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct PortraitModeHandler{
  #[serde(rename = "PortraitMode")]
  pub portrait_mode: i64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct PuzzleGamePlugin{
  #[serde(rename = "Tag")]
  pub tag: i64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct SocialPhoto{
  #[serde(rename = "CameraParams")]
  pub camera_params: String,

  #[serde(rename = "CarrierInfo")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub carrier_info: Option<CarrierInfo>,

  #[serde(rename = "DaMiaoInfo")]
  pub da_miao_info: OptionMap<DaMiaoInfo>,

  #[serde(rename = "GiantState")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub giant_state: Option<bool>,

  #[serde(rename = "Interactions")]
  pub interactions: AdaptiveArray<Interactions>,

  #[serde(rename = "LocalTransforms")]
  pub local_transforms: String,

  #[serde(rename = "MountInfo")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub mount_info: Option<OptionMap<MountInfo>>,

  #[serde(rename = "PhotoInfo")]
  pub photo_info: PhotoInfo,

  #[serde(rename = "StaticInfos")]
  pub static_infos: OptionMap<StaticInfos>,

  #[serde(rename = "Time")]
  pub time: Time,

  #[serde(rename = "WeaponSnapShot")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub weapon_snap_shot: Option<WeaponSnapShot>,

  #[serde(rename = "WeatherType")]
  pub weather_type: i64,
}

#[with_transform_fields(loc = 3, scale = 3, rot = 3)]
#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct CarrierInfo{
  #[serde(rename = "ConfigObjID")]
  pub config_obj_id: i64,

  #[serde(rename = "Pose")]
  pub pose: String,
}

#[with_transform_fields(loc = 3, scale = 3, rot = 3)]
#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct DaMiaoInfo{
  #[serde(rename = "ClothIDS")]
  pub cloth_ids: Vec<i64>,

  #[serde(rename = "Action")]
  pub action: String,
}

#[with_transform_fields(loc = 3, scale = 3, rot = 3)]
#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct Interactions{
  #[serde(rename = "CfgID")]
  pub cfg_id: i64,
}

#[with_transform_fields(loc = 3, scale = 3, rot = 3)]
#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct MountInfo{
  #[serde(rename = "ConfigID")]
  pub config_id: i64,

  #[serde(rename = "Pose")]
  pub pose: String,
}

#[with_transform_fields(loc = 3, scale = 0, rot = 3, pre_field = "camera_actor", pre_rename = "cameraActor")]
#[with_transform_fields(loc = 3, scale = 0, rot = 3, pre_field = "camera_component", pre_rename = "cameraComponent")]
#[with_transform_fields(loc = 3, scale = 3, rot = 3, pre_field = "nikki", pre_rename = "nikki")]
#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct PhotoInfo{
  #[serde(rename = "apertureSection")]
  pub aperture_section: u8,

  #[serde(rename = "cameraFocalLength")]
  pub camera_focal_length: f64,

  #[serde(rename = "filterId")]
  pub filter_id: String,

  #[serde(rename = "filterStrength")]
  pub filter_strength: f64,

  #[serde(rename = "lightId")]
  pub light_id: String,

  #[serde(rename = "lightStrength")]
  pub light_strength: f64,

  #[serde(rename = "magicballColorIds")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub magicball_color_ids: Option<Vec<i64>>,

  #[serde(rename = "nikkiClothes")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub nikki_clothes: Option<Vec<i64>>,

  #[serde(rename = "nikkiDIY")]
  pub nikki_diy: AdaptiveArray<NikkiDIY>,

  #[serde(rename = "nikkiHidden")]
  pub nikki_hidden: bool,

  #[serde(rename = "nikkiWeaponTagName")]
  #[serde(skip_serializing_if = "Option::is_none")]
  pub nikki_weapon_tag_name: Option<String>,

  #[serde(rename = "poseId")]
  pub pose_id: i64,

  #[serde(rename = "vignetteIntensity")]
  pub vignette_intensity: f64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct StaticInfos{

}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct Time{
  pub day: i64,
  pub hour: u8,
  pub min: u8,
  pub sec: f64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct NikkiDIY{
  #[serde(rename = "TargetGroupID")]
  pub target_group_id: i64,

  #[serde(rename = "CoreData")]
  pub core_data: CoreData,

  #[serde(rename = "FeatureTag")]
  pub feature_tag: i64,

  #[serde(rename = "TargetClothID")]
  pub target_cloth_id: i64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct WeaponSnapShot{
  #[serde(rename = "weaponID")]
  pub weapon_id: i64,

  #[serde(rename = "customState")]
  pub custom_state: String,

  #[serde(rename = "slotType")]
  pub slot_type: String,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum CoreData{
  Hair(HairCoreData),
  General(GeneralCoreData),
  SpecialEffect(SpecialEffectCoreData),
  PatternCreation(PatternCreationCoreData),
  PatternCreationExt(PatternCreationExtCoreData),
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct HairCoreData{
  #[serde(rename = "TargetColor0")]
  pub target_color_0: Color,

  #[serde(rename = "ColorGridID0")]
  pub color_grid_id_0: i64,

  #[serde(rename = "RoughnessOffset")]
  pub roughness_offset: f64,

  #[serde(rename = "ColorGridID1")]
  pub color_grid_id_1: i64,

  #[serde(rename = "HairColorMode")]
  pub hair_color_mode: i64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct Color{
  #[serde(rename = "R")]
  pub r: f64,

  #[serde(rename = "G")]
  pub g: f64,

  #[serde(rename = "B")]
  pub b: f64,

  #[serde(rename = "A")]
  pub a: f64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct GeneralCoreData{
  #[serde(rename = "R")]
  pub r: f64,

  #[serde(rename = "G")]
  pub g: f64,

  #[serde(rename = "B")]
  pub b: f64,

  #[serde(rename = "A")]
  pub a: f64,

  #[serde(rename = "ColorGridID")]
  pub color_grid_id: i64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct SpecialEffectCoreData{
  #[serde(rename = "ColorGridID")]
  pub color_grid_id: i64,

  #[serde(rename = "CoverDIYColor")]
  pub cover_diy_color: bool,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct PatternCreationCoreData{
  #[serde(rename = "ReplaceTextureID")]
  pub replace_texture_id: i64,

  #[serde(rename = "OverridePatternA")]
  pub override_pattern_a: bool,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct PatternCreationExtCoreData{
  #[serde(rename = "TilingData")]
  pub replace_texture_id: f64,
}





