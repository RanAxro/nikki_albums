use std::collections::{HashMap, HashSet};
use crate::nuan5_media_param::serde_nuan5_json::ext_type::{AdaptiveArray, OptionMap};
use crate::nuan5_media_param::serde_nuan5_json::structs::{image_custom_data, camera_params};
use crate::nuan5_media_param::parser::momo_camera_params_parser::*;
use crate::nuan5_media_param::parser::location_parser::parse_location;
use super::structs::{nikki_photo_params::*, clock_in_photo_params::*, collage_params::*, diy_params::*, momo_camera_params::*};

pub(crate) fn convert_momo_camera_params(data: &camera_params::CameraParams) -> MomoCameraParams{
  MomoCameraParams{
    camera_actor_loc: (data.dx_camera_actor, data.dy_camera_actor, data.dz_camera_actor),
    camera_actor_rot: (data.d_yaw_camera_actor, data.d_pitch_camera_actor, data.d_roll_camera_actor),
    camera_component_loc: (data.dx_camera_component, data.dy_camera_component, data.dz_camera_component),
    camera_component_rot: (data.d_yaw_camera_component, data.d_pitch_camera_component, data.d_roll_camera_component),
    portrait_mode: data.portrait_mode,
    camera_focal_length: data.camera_focal_length,
    aperture_section: data.aperture_section,
    vignette_intensity: data.vignette_intensity,
    bloom_intensity: parse_bloom_intensity(data.bloom_intensity),
    bloom_threshold: parse_bloom_threshold(data.bloom_threshold),
    brightness: parse_brightness(data.brightness),
    exposure: parse_exposure(data.exposure),
    contrast: parse_contrast(data.contrast),
    saturation: parse_saturation(data.saturation),
    vibrance: parse_vibrance(data.vibrance),
    highlights: parse_highlights(data.highlights),
    shadows: parse_shadows(data.shadows),
    light: if data.light_id == "None" {
      LightParams::None
    }else{
      LightParams::Some{
        id: data.light_id.clone(),
        strength: data.light_strength,
      }
    },
    filter: if data.filter_id == "None" {
      FilterParams::None
    }else{
      FilterParams::Some{
        id: data.filter_id.clone(),
        strength: data.filter_strength,
      }
    },
  }
}

pub(crate) fn convert_nikki_photo_params(data: &image_custom_data::NikkiPhotoCustomData) -> NikkiPhotoParams{
  NikkiPhotoParams{
    photography: convert_nikki_photo_photography_params(data),
    camera: data.social_photo.as_ref().map(|social_photo|{
      convert_camera_params(social_photo, &data.portrait_mode_handler)
    }),
    nikki: data.social_photo.as_ref().map(convert_nikki_params),
    momo: data.social_photo.as_ref()
      .map(|social_photo| &social_photo.da_miao_info)
      .map(convert_momo_params),
  }
}

pub(crate) fn convert_clock_in_photo_params(data: &image_custom_data::ClockInPhotoCustomData) -> ClockInPhotoParams{
  ClockInPhotoParams{
    tag: data.clock_game_plugin.tag,
    photography: convert_clock_in_photo_photography_params(&data),
    camera: data.social_photo.as_ref().map(|social_photo|{
      convert_camera_params(social_photo, &data.portrait_mode_handler)
    }),
    nikki: data.social_photo.as_ref().map(convert_nikki_params),
    momo: data.social_photo.as_ref()
      .map(|social_photo| &social_photo.da_miao_info)
      .map(convert_momo_params),
  }
}

pub(crate) fn convert_collage_params(data: &image_custom_data::CollageCustomData) -> CollageParams{
  CollageParams{
    template_id: data.template_id,
    region_pictures: data.region_pictures.iter().map(|region_picture|{
      RegionPicture{
        position: (region_picture.position.x, region_picture.position.y),
        rotation: region_picture.rotation,
        scale: region_picture.scale,
        image_id: region_picture.image_id.clone(),
        ori_custom_data: convert_nikki_photo_params(&region_picture.ori_custom_data),
      }
    }).collect(),
  }
}

pub(crate) fn convert_diy_params(data: &image_custom_data::DIYCustomData) -> DiyParams{
  DiyParams{
    pose_id: data.content.pose_id,
    pattern_data: data.content.pattern_data.as_map(),
    clothes: convert_cloth(&data.content.wearing_clothes, Some(&data.content.wearing_diy_infos)),
  }
}

pub(crate) fn convert_nikki_photo_photography_params(data: &image_custom_data::NikkiPhotoCustomData) -> PhotographyParams{
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
    location: data.social_photo.as_ref().map(|social_photo|{
      parse_location(social_photo.photo_info.nikki_loc_x, social_photo.photo_info.nikki_loc_y, social_photo.photo_info.nikki_loc_z)
    }),
    weather: data.social_photo.as_ref().map(|social_photo| social_photo.weather_type),
    photo_wall: match &data.photo_wall_plugin{
      Some(photo_wall) => photo_wall.photo_id.as_vec(),
      None => vec![],
    },
    task: convert_task_params(data),
  }
}

pub(crate) fn convert_clock_in_photo_photography_params(data: &image_custom_data::ClockInPhotoCustomData) -> PhotographyParams{
  PhotographyParams{
    edit: EditPhotoState::Disabled,
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
    location: data.social_photo.as_ref().map(|social_photo|{
      parse_location(social_photo.photo_info.nikki_loc_x, social_photo.photo_info.nikki_loc_y, social_photo.photo_info.nikki_loc_z)
    }),
    weather: data.social_photo.as_ref().map(|social_photo| social_photo.weather_type),
    photo_wall: vec![],
    task: vec![],
  }
}

pub(crate) fn convert_camera_params(data: &image_custom_data::SocialPhoto, portrait_data: &Option<image_custom_data::PortraitModeHandler>) -> CameraParams{
  const DEFAULT_MOMO_CAMERA_PARAMS: MomoCameraParams = MomoCameraParams{
    camera_actor_loc: (0.0, 0.0, 0.0),
    camera_actor_rot: (0.0, 0.0, 0.0),
    camera_component_loc: (0.0, 0.0, 0.0),
    camera_component_rot: (0.0, 0.0, 0.0),
    portrait_mode: 0,
    camera_focal_length: 0.0,
    aperture_section: 0,
    vignette_intensity: 0.0,
    bloom_intensity: 0.0,
    bloom_threshold: 0.0,
    brightness: 0.0,
    exposure: 0.0,
    contrast: 0.0,
    saturation: 0.0,
    vibrance: 0.0,
    highlights: 0.0,
    shadows: 0.0,
    light: LightParams::None,
    filter: FilterParams::None,
  };
  
  let params = parse_momo_camera_params(&data.camera_params).as_ref().map(convert_momo_camera_params);

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
    bloom_intensity: params.as_ref().unwrap_or(&DEFAULT_MOMO_CAMERA_PARAMS).bloom_intensity,
    bloom_threshold: params.as_ref().unwrap_or(&DEFAULT_MOMO_CAMERA_PARAMS).bloom_threshold,
    brightness: params.as_ref().unwrap_or(&DEFAULT_MOMO_CAMERA_PARAMS).brightness,
    exposure: params.as_ref().unwrap_or(&DEFAULT_MOMO_CAMERA_PARAMS).exposure,
    contrast: params.as_ref().unwrap_or(&DEFAULT_MOMO_CAMERA_PARAMS).contrast,
    saturation: params.as_ref().unwrap_or(&DEFAULT_MOMO_CAMERA_PARAMS).saturation,
    vibrance: params.as_ref().unwrap_or(&DEFAULT_MOMO_CAMERA_PARAMS).vibrance,
    highlights: params.as_ref().unwrap_or(&DEFAULT_MOMO_CAMERA_PARAMS).highlights,
    shadows: params.as_ref().unwrap_or(&DEFAULT_MOMO_CAMERA_PARAMS).shadows,
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

pub(crate) fn convert_nikki_params(data: &image_custom_data::SocialPhoto) -> NikkiParams{
  NikkiParams{
    giant_state: if let Some(true) = data.giant_state { true } else { false },
    hidden: data.photo_info.nikki_hidden,
    loc: (data.photo_info.nikki_loc_x, data.photo_info.nikki_loc_y, data.photo_info.nikki_loc_z),
    rot: (data.photo_info.nikki_rot_yaw, data.photo_info.nikki_rot_pitch, data.photo_info.nikki_rot_roll),
    scale: (data.photo_info.nikki_scale_x, data.photo_info.nikki_scale_y, data.photo_info.nikki_scale_z),
    dressing: DressingParams{
      clothes: data.photo_info.nikki_clothes.as_ref().map(|nikki_clothes|{
        convert_cloth(nikki_clothes, Some(&data.photo_info.nikki_diy))
      }).unwrap_or(vec![]),
      magicball: data.photo_info.magicball_color_ids.clone().unwrap_or(vec![]),
    },
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

pub(crate) fn convert_momo_params(data: &OptionMap<image_custom_data::DaMiaoInfo>) -> MomoHiddenState{
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

pub(crate) fn convert_task_params(data: &image_custom_data::NikkiPhotoCustomData) -> Vec<TaskParams>{
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

pub(crate) fn convert_cloth(data: &Vec<i64>, data_nikki_diy: Option<&AdaptiveArray<image_custom_data::NikkiDIY>>) -> Vec<ClothParams>{
  let mut res = Vec::new();

  let mut set = HashSet::new();
  if let Some(nikki_diy) = data_nikki_diy {
    let diy_clothes = convert_nikki_diy(nikki_diy);

    set.extend(diy_clothes.iter().map(|param| param.id));
    res.extend_from_slice(&diy_clothes);
  }

  for cloth in data {
    if !set.contains(cloth) {
      res.push(ClothParams{
        id: cloth.clone(),
        diy: None,
      })
    }
  }

  res
}

pub(crate) fn convert_nikki_diy(data: &AdaptiveArray<image_custom_data::NikkiDIY>) -> Vec<ClothParams>{
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

  #[inline]
  fn convert_hair(item: &image_custom_data::NikkiDIY, hair: &image_custom_data::HairCoreData) -> OutfitDyeData{
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
  }
  #[inline]
  fn convert_general(item: &image_custom_data::NikkiDIY, general: &image_custom_data::GeneralCoreData) -> OutfitDyeData{
    OutfitDyeData::General(OutfitDyeGeneralData{
      target_group_id: item.target_group_id,
      feature_tag: item.feature_tag,
      color: DyeColorParams{
        color: (general.r, general.g, general.b, general.a),
        color_grid: general.color_grid_id,
      },
    })
  }
  #[inline]
  fn convert_special_effect(item: &image_custom_data::NikkiDIY, special_effect: &image_custom_data::SpecialEffectCoreData) -> SpecialEffectData{
    SpecialEffectData{
      target_group_id: item.target_group_id,
      feature_tag: item.feature_tag,
      color_grid: special_effect.color_grid_id,
      cover_diy_color: special_effect.cover_diy_color,
    }
  }
  #[inline]
  fn convert_pattern_creation(item: &image_custom_data::NikkiDIY, pattern_creation: &image_custom_data::PatternCreationCoreData) -> PatternCreationData{
    PatternCreationData{
      target_group_id: item.target_group_id,
      feature_tag: item.feature_tag,
      texture_id: pattern_creation.replace_texture_id,
      override_pattern_a: pattern_creation.override_pattern_a,
      tiling: 0.0,
    }
  }
  #[inline]
  fn convert_pattern_creation_ext(item: &image_custom_data::NikkiDIY, pattern_creation_ext: &image_custom_data::PatternCreationExtCoreData) -> PatternCreationData{
    PatternCreationData{
      target_group_id: item.target_group_id,
      feature_tag: item.feature_tag,
      texture_id: 0,
      override_pattern_a: false,
      tiling: pattern_creation_ext.tiling_data,
    }
  }

  fn resolve_item(item: &image_custom_data::NikkiDIY) -> ClothParams{
    ClothParams{
      id: item.target_cloth_id,
      diy: Some(match &item.core_data{
        image_custom_data::CoreData::Hair(hair) => DiyData{
          outfit_dye: vec![convert_hair(item, hair)],
          special_effect: vec![],
          pattern_creation: vec![],
        },
        image_custom_data::CoreData::General(general) => DiyData{
          outfit_dye: vec![convert_general(item, general)],
          special_effect: vec![],
          pattern_creation: vec![],
        },
        image_custom_data::CoreData::SpecialEffect(special_effect) => DiyData{
          outfit_dye: vec![],
          special_effect: vec![convert_special_effect(item, special_effect)],
          pattern_creation: vec![],
        },
        image_custom_data::CoreData::PatternCreation(pattern_creation) => DiyData{
          outfit_dye: vec![],
          special_effect: vec![],
          pattern_creation: vec![convert_pattern_creation(item, pattern_creation)],
        },
        image_custom_data::CoreData::PatternCreationExt(pattern_creation_ext) => DiyData{
          outfit_dye: vec![],
          special_effect: vec![],
          pattern_creation: vec![convert_pattern_creation_ext(item, pattern_creation_ext)],
        },
      }),
    }
  }


  let mut clothes: HashMap<i64, ClothParams> = HashMap::new();

  match data{
    AdaptiveArray::Array(items) => {
      // PatternCreationData 由 image_custom_data::CoreData::PatternCreation 与 image_custom_data::CoreData::PatternCreationExt 的数据组成
      // 将 image_custom_data::CoreData::PatternCreationExt (tiling_data字段) 单独收集
      // items 遍历完毕后, 再把 tiling_data 插回到 对应的 image_custom_data::CoreData::PatternCreation
      let mut pattern_creation_tiling: HashMap<i64, f64> = HashMap::new();

      for item in items {
        match clothes.get_mut(&item.target_cloth_id){
          Some(params) => {
            match &item.core_data{
              image_custom_data::CoreData::Hair(hair) => {
                params.diy.as_mut().unwrap().outfit_dye.push(convert_hair(item, hair));
              },
              image_custom_data::CoreData::General(general) => {
                params.diy.as_mut().unwrap().outfit_dye.push(convert_general(item, general));
              }
              image_custom_data::CoreData::SpecialEffect(special_effect) => {
                params.diy.as_mut().unwrap().special_effect.push(convert_special_effect(item, special_effect));
              }
              image_custom_data::CoreData::PatternCreation(pattern_creation) => {
                params.diy.as_mut().unwrap().pattern_creation.push(convert_pattern_creation(item, pattern_creation));
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
          for pattern_creation in &mut params.diy.as_mut().unwrap().pattern_creation {
            pattern_creation.tiling = tiling.clone();
          }
        }
      }
    },
    // 处理单例
    // 理论上不应该出现 image_custom_data::CoreData::PatternCreationExt
    AdaptiveArray::Item(item) => {
      clothes.insert(item.target_cloth_id, resolve_item(item));
    },
    AdaptiveArray::Empty{} => {},
  };

  clothes.into_values().collect()
}