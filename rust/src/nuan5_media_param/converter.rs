use std::collections::HashMap;
use crate::nuan5_media_param::serde_nuan5_json::ext_type::{AdaptiveArray, OptionMap};
use crate::nuan5_media_param::serde_nuan5_json::structs::image_custom_data;
use crate::nuan5_media_param::parser::camera_params_parser::*;
use super::structs::nikki_photo_params::*;

pub fn convert_nikki_photo_params(data: &image_custom_data::NikkiPhotoCustomData) -> NikkiPhotoParams{
  NikkiPhotoParams{
    photography: convert_photography_params(data),
    camera: None,
    nikki: None,
    momo: data.social_photo.as_ref()
      .map(|social_photo| &social_photo.da_miao_info)
      .map(convert_momo_params),
  }
}

fn convert_photography_params(data: &image_custom_data::NikkiPhotoCustomData) -> PhotographyParams{
  PhotographyParams{
    edit: match &data.edit_photo_handler{
      Some(edit_photo_handler) => {
        EditPhotoState::Enabled(EditPhotoParams{
          has_sticker: edit_photo_handler.has_sticker,
          has_text: edit_photo_handler.has_text,
        })
      },
      None => EditPhotoState::Disabled,
    },
    date: data.social_photo.as_ref().map(|social_photo|{
      ShootingDate{
        day: social_photo.time.day,
      }
    }),
    time: data.social_photo.as_ref().map(|social_photo|{
      ShootingTime{
        hour: social_photo.time.hour,
        min: social_photo.time.min,
        sec: social_photo.time.sec,
      }
    }),
    location: None,
    weather: data.social_photo.as_ref().map(|social_photo| social_photo.weather_type),
    photo_wall: match &data.photo_wall_plugin{
      Some(photo_wall) => photo_wall.photo_id.as_vec(),
      None => vec![],
    },
    task: convert_task_params(data),
  }
}

fn convert_camera_params(data: &image_custom_data::SocialPhoto, portrait_data: &Option<image_custom_data::PortraitModeHandler>) -> CameraParams{
  let params = parse_camera_params(&data.camera_params);

  CameraParams{
    params: data.camera_params.clone(),
    portrait_mode: match portrait_data{
      Some(portrait_mode_handler) => {
        if portrait_mode_handler.portrait_mode == 1 { true } else { false }
      },
      None => false,
    },
    zoom: {
      let i = &data.photo_info;
      let dx = i.nikki_loc_x - i.camera_actor_loc_x;
      let dy = i.nikki_loc_y - i.camera_actor_loc_y;
      let dz = i.nikki_loc_z - i.camera_actor_loc_z;
      let distance = (dx * dx + dy * dy + dz * dz).sqrt();
      -0.0035 * distance + 6.45
    },
    focal_length: data.photo_info.camera_focal_length,
    rotation: data.photo_info.camera_actor_rot_roll,
    aperture_section: data.photo_info.aperture_section,
    vignette_intensity: data.photo_info.vignette_intensity,
    bloom_intensity: parse_bloom_intensity(&params),
    bloom_threshold: parse_bloom_intensity(&params),
    brightness: parse_brightness(&params),
    exposure: parse_exposure(&params),
    contrast: parse_contrast(&params),
    saturation: parse_saturation(&params),
    vibrance: parse_vibrance(&params),
    highlights: parse_highlights(&params),
    shadows: parse_shadows(&params),
    light: if data.photo_info.light_id == "None" {
      LightParams::None
    }else{
      LightParams::Some{
        id: data.photo_info.light_id.clone(),
        strength: data.photo_info.light_strength,
      }
    },
    filter: if data.photo_info.filter_id == "None" {
      FilterParams::None
    }else{
      FilterParams::Some{
        id: data.photo_info.filter_id.clone(),
        strength: data.photo_info.filter_strength,
      }
    },
    pose: data.photo_info.pose_id,
  }
}

fn convert_nikki_params(data: &image_custom_data::SocialPhoto) -> NikkiParams{
  NikkiParams{
    giant_state: if let Some(true) = data.giant_state { true } else { false },
    hidden: data.photo_info.nikki_hidden,
    loc: (data.photo_info.nikki_loc_x, data.photo_info.nikki_loc_y, data.photo_info.nikki_loc_z),
    rot: (data.photo_info.nikki_rot_yaw, data.photo_info.nikki_rot_pitch, data.photo_info.nikki_rot_roll),
    scale: (data.photo_info.nikki_scale_x, data.photo_info.nikki_scale_y, data.photo_info.nikki_scale_z),
    // TODO
    dressing: vec![],
    weapon: data.weapon_snap_shot.as_ref().map(|weapon_snap_shot|{
      WeaponParams{
        id: weapon_snap_shot.weapon_id,
        slot_type: weapon_snap_shot.slot_type.clone(),
        state: weapon_snap_shot.custom_state.clone(),
      }
    }),
    interactions: data.interactions.as_vec().iter().map(|interaction|{
      ObjectParams{
        id: interaction.cfg_id,
        loc: (interaction.loc_x, interaction.loc_y, interaction.loc_z),
        rot: (interaction.rot_yaw, interaction.rot_pitch, interaction.rot_roll),
        scale: (interaction.scale_x, interaction.scale_y, interaction.scale_z),
      }
    }).collect(),
    mount: match &data.mount_info{
      Some(mount_info) => {
        mount_info.as_option_ref().map(|mount|{
          ObjectParams{
            id: mount.config_id.clone(),
            loc: (mount.loc_x, mount.loc_y, mount.loc_z),
            rot: (mount.rot_yaw, mount.rot_pitch, mount.rot_roll),
            scale: (mount.scale_x, mount.scale_y, mount.scale_z),
          }
        })
      },
      None => None,
    },
    carrier: data.carrier_info.as_ref().map(|carrier|{
      ObjectParams{
        id: carrier.config_obj_id.clone(),
        loc: (carrier.loc_x, carrier.loc_y, carrier.loc_z),
        rot: (carrier.rot_yaw, carrier.rot_pitch, carrier.rot_roll),
        scale: (carrier.scale_x, carrier.scale_y, carrier.scale_z),
      }
    }),
  }
}

pub fn convert_momo_params(data: &OptionMap<image_custom_data::DaMiaoInfo>) -> MomoHiddenState{
  match &data{
    OptionMap::None{} => MomoHiddenState::Enabled,
    OptionMap::Some(momo_data) => {
      MomoHiddenState::Disabled(MomoParams{
        loc: (momo_data.loc_x, momo_data.loc_y, momo_data.loc_z),
        rot: (momo_data.rot_yaw, momo_data.rot_pitch, momo_data.rot_roll),
        scale: (momo_data.scale_x, momo_data.scale_y, momo_data.scale_z),
        clothes: vec![],
      })
    },
  }
}

pub fn convert_task_params(data: &image_custom_data::NikkiPhotoCustomData) -> Vec<TaskParams>{
  let mut res = Vec::new();

  if let Some(puzzle_game) = &data.puzzle_game_plugin{
    if puzzle_game.tag != -1 {
      res.push(TaskParams::Puzzle(puzzle_game.tag));
    }
  };

  if let Some(risk_photo) = &data.risk_photo{
    if !risk_photo.is_empty() {
      res.push(TaskParams::Risk(risk_photo.as_map()))
    }
  };

  if let Some(interactive_photo) = &data.interactive_photo{
    if !interactive_photo.is_empty() {
      res.push(TaskParams::Risk(interactive_photo.as_map()))
    }
  };

  res
}

pub fn convert_cloth(data: &Vec<i64>, data_nikki_diy: Option<&AdaptiveArray<image_custom_data::NikkiDIY>>) -> Vec<ClothParams>{




  vec![]
}

fn convert_nikki_diy(data: &AdaptiveArray<image_custom_data::NikkiDIY>) -> Vec<ClothParams>{
  fn convert_color_params(data_color: &Option<image_custom_data::Color>, data_grid: &Option<i64>) -> Option<DyeColorParams>{
    match (data_color, data_grid){
      (Some(color), Some(grid)) => {
        Some(DyeColorParams{
          color: (color.r, color.g, color.b, color.a),
          color_grid: grid.clone(),
        })
      },
      (_, _) => None,
    }
  }

  fn resolve_item(item: &image_custom_data::NikkiDIY) -> ClothParams{
    ClothParams{
      id: item.target_cloth_id,
      diy: match &item.core_data{
        image_custom_data::CoreData::Hair(hair) => {
          DiyData{
            outfit_dye: vec![
              OutfitDyeData::Hair(OutfitDyeHairData{
                target_group_id: item.target_group_id,
                feature_tag: item.feature_tag,
                color_0: DyeColorParams{
                  color: if let Some(color) = &hair.target_color_0 { (color.r, color.g, color.b, color.a) } else { (0.0, 0.0, 0.0, 0.0) },
                  color_grid: hair.color_grid_id_0,
                },
                color_1: convert_color_params(&hair.target_color_1, &hair.color_grid_id_1),
                roughness: hair.roughness_offset,
                color_mode: hair.hair_color_mode,
              })
            ],
            special_effect: vec![],
            pattern_creation: vec![],
          }
        },
        image_custom_data::CoreData::General(general) => {
          DiyData{
            outfit_dye: vec![
              OutfitDyeData::General(OutfitDyeGeneralData{
                target_group_id: item.target_group_id,
                feature_tag: item.feature_tag,
                color: DyeColorParams{
                  color: (general.r, general.g, general.b, general.a),
                  color_grid: general.color_grid_id,
                },
              })
            ],
            special_effect: vec![],
            pattern_creation: vec![],
          }
        }
        image_custom_data::CoreData::SpecialEffect(special_effect) => {
          DiyData{
            outfit_dye: vec![],
            special_effect: vec![
              SpecialEffectData{
                target_group_id: item.target_group_id,
                feature_tag: item.feature_tag,
                color_grid: special_effect.color_grid_id,
                cover_diy_color: special_effect.cover_diy_color,
              }
            ],
            pattern_creation: vec![],
          }
        }
        image_custom_data::CoreData::PatternCreation(pattern_creation) => {
          DiyData{
            outfit_dye: vec![],
            special_effect: vec![],
            pattern_creation: vec![
              PatternCreationData{
                target_group_id: item.target_group_id,
                feature_tag: item.feature_tag,
                texture_id: pattern_creation.replace_texture_id,
                override_pattern_a: pattern_creation.override_pattern_a,
                tiling: 0.0,
              }
            ],
          }
        }
        image_custom_data::CoreData::PatternCreationExt(pattern_creation_ext) => {
          DiyData{
            outfit_dye: vec![],
            special_effect: vec![],
            pattern_creation: vec![
              PatternCreationData{
                target_group_id: item.target_group_id,
                feature_tag: item.feature_tag,
                texture_id: 0,
                override_pattern_a: false,
                tiling: pattern_creation_ext.tiling_data,
              }
            ],
          }
        }
      },
    }
  }


  let mut clothes: HashMap<i64, ClothParams> = HashMap::new();

  match data{
    AdaptiveArray::Array(items) => {
      let mut pattern_creation_tiling: HashMap<i64, f64> = HashMap::new();

      for item in items {
        match clothes.get_mut(&item.target_cloth_id){
          Some(params) => {
            match &item.core_data{
              image_custom_data::CoreData::Hair(hair) => {
                params.diy.outfit_dye.push(OutfitDyeData::Hair(OutfitDyeHairData{
                  target_group_id: item.target_group_id,
                  feature_tag: item.feature_tag,
                  color_0: DyeColorParams{
                    color: if let Some(color) = &hair.target_color_0 { (color.r, color.g, color.b, color.a) } else { (0.0, 0.0, 0.0, 0.0) },
                    color_grid: hair.color_grid_id_0,
                  },
                  color_1: convert_color_params(&hair.target_color_1, &hair.color_grid_id_1),
                  roughness: hair.roughness_offset,
                  color_mode: hair.hair_color_mode,
                }));
              },
              image_custom_data::CoreData::General(general) => {
                params.diy.outfit_dye.push(OutfitDyeData::General(OutfitDyeGeneralData{
                  target_group_id: item.target_group_id,
                  feature_tag: item.feature_tag,
                  color: DyeColorParams{
                    color: (general.r, general.g, general.b, general.a),
                    color_grid: general.color_grid_id,
                  },
                }));
              }
              image_custom_data::CoreData::SpecialEffect(special_effect) => {
                params.diy.special_effect.push(SpecialEffectData{
                  target_group_id: item.target_group_id,
                  feature_tag: item.feature_tag,
                  color_grid: special_effect.color_grid_id,
                  cover_diy_color: special_effect.cover_diy_color,
                });
              }
              image_custom_data::CoreData::PatternCreation(pattern_creation) => {
                params.diy.pattern_creation.push(PatternCreationData{
                  target_group_id: item.target_group_id,
                  feature_tag: item.feature_tag,
                  texture_id: pattern_creation.replace_texture_id,
                  override_pattern_a: pattern_creation.override_pattern_a,
                  tiling: 0.0,
                });
              }
              image_custom_data::CoreData::PatternCreationExt(pattern_creation_ext) => {
                pattern_creation_tiling.insert(item.target_cloth_id, pattern_creation_ext.tiling_data);
              }
            };
          },
          None => {
            if let image_custom_data::CoreData::PatternCreationExt(pattern_creation_ext) = &item.core_data {
              pattern_creation_tiling.insert(item.target_cloth_id, pattern_creation_ext.tiling_data);
            }else{
              clothes.insert(item.target_cloth_id, resolve_item(item));
            }
          },
        }
      }

      for (id, params) in clothes.iter_mut(){
        if let Some(tiling) = pattern_creation_tiling.get(id) {
          for pattern_creation in &mut params.diy.pattern_creation {
            pattern_creation.tiling = tiling.clone();
          }
        }
      }
    },
    AdaptiveArray::Item(item) => {
      clothes.insert(item.target_cloth_id, resolve_item(item));
    },
    AdaptiveArray::Empty{} => {
    },
  };

  clothes.into_values().collect()
}