use crate::nuan5_media_param::serde_nuan5_json::ext_type::{OptionMap};
use crate::nuan5_media_param::serde_nuan5_json::structs::image_custom_data;
use crate::nuan5_media_param::parser::camera_params_parser::*;
use crate::nuan5_media_param::serde_nuan5_json::structs::image_custom_data::MountInfo;
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

// pub fn convert_cloth()