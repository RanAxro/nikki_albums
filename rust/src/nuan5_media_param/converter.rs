use crate::nuan5_media_param::serde_nuan5_json::ext_type::{OptionMap};
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
      Some(photo_wall) => photo_wall.photo_id.to_vec(),
      None => vec![],
    },
    task: convert_task_params(data),
  }
}

fn convert_camera_params(data: &image_custom_data::SocialPhoto, portrait_data: &Option<image_custom_data::PortraitModeHandler>) -> CameraParams{
  let params = parse_camera_params(data.camera_params.as_ref());

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