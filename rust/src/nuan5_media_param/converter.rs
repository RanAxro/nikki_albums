use crate::nuan5_media_param::serde_nuan5_json::ext_type::{OptionMap};
use crate::nuan5_media_param::serde_nuan5_json::structs::image_custom_data;
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