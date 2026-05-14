use crate::nuan5_media_param::serde_nuan5_json::ext_type::OptionMap;
use crate::nuan5_media_param::serde_nuan5_json::structs::image_custom_data;
use super::serde_nuan5_json::structs;
use super::structs::nikki_photo_params::*;

pub fn convert_nikki_photo_params(data: image_custom_data::NikkiPhotoCustomData) -> NikkiPhotoParams{
  NikkiPhotoParams{
    photography: PhotographyParams{
      edit: EditPhotoState::Disabled,
      date: None,
      time: None,
      location: None,
      weather: None,
      photo_wall: vec![],
      task: vec![],
    },
    camera: None,
    nikki: None,
    momo: data.social_photo
      .map(|social_photo| social_photo.da_miao_info)
      .map(convert_momo_params),
  }
}

fn convert_photography_params(data: image_custom_data::NikkiPhotoCustomData) -> PhotographyParams{
  PhotographyParams{
    edit: match data.edit_photo_handler{
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
    weather: None,
    photo_wall: vec![],
    task: vec![],
  }
}

pub fn convert_momo_params(data: OptionMap<image_custom_data::DaMiaoInfo>) -> MomoHiddenState{
  match data{
    OptionMap::None {} => MomoHiddenState::Enabled,
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

// pub fn convert_cloth()