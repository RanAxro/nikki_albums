use flutter_rust_bridge::frb;
use super::converter::*;
use super::decrypt;
use super::serde_nuan5_json::de::from_slice;
use super::structs::{nikki_photo_params::*, clock_in_photo_params::*, collage_params::*, diy_params::*, momo_camera_params::*};

pub enum MediaParamType{
  MomoCameraParams,
  NikkiPhoto,
  // MagazinePhoto,
  ClockInPhoto,
  Collage,
  DIY,
  // Video,
  // VideoCover,
  // ShareCode,
  // DiyHistoryShareCode,
}

#[frb(non_opaque)]
#[derive(Clone)]
pub enum MediaParam{
  MomoCameraParams(MomoCameraParams),
  NikkiPhoto(NikkiPhotoParams),
  // MagazinePhoto(MagazinePhotoParams),
  ClockInPhoto(ClockInPhotoParams),
  Collage(CollageParams),
  DIY(DiyParams),
  // Video(VideoParams),
  // VideoCover(VideoCoverParams),
  // ShareCode(ShareCode),
  // DiyHistoryShareCode(DiyHistoryShareCodeParams),
}

#[frb(non_opaque)]
#[derive(Clone)]
pub enum MediaCustomData{
  Invalid,
  Valid(MediaParam),
}

// const EMPTY_FLAG: &[u8; 0] = b"";
// const IMAGE_FLAG: &[u8; 2] = b"\xFF\xD9";
// const VIDEO_FLAG: &[u8; 12] = b"%PAPERGAMES%";

// #[inline]
// fn get_flag(param_type: MediaParamType) -> &'static [u8]{
//   use MediaParamType::*;
//
//   match param_type{
//     CameraParams | ShareCode | DiyHistoryShareCode => EMPTY_FLAG,
//     NikkiPhoto | MagazinePhoto | ClockInPhoto | Collage | DIY => IMAGE_FLAG,
//     Video | VideoCover => VIDEO_FLAG,
//   }
// }

pub fn decode_media_param(param_type: MediaParamType, data: &decrypt::CustomData) -> MediaCustomData{
  match data{
    decrypt::CustomData::Valid(bytes) => {
      use MediaParamType::*;

      let decoded = match param_type{
        MomoCameraParams => from_slice(&bytes).ok().as_ref().map(convert_momo_camera_params).map(MediaParam::MomoCameraParams),
        NikkiPhoto => from_slice(&bytes).ok().as_ref().map(convert_nikki_photo_params).map(MediaParam::NikkiPhoto),
        ClockInPhoto => from_slice(&bytes).ok().as_ref().map(convert_clock_in_photo_params).map(MediaParam::ClockInPhoto),
        Collage => from_slice(&bytes).ok().as_ref().map(convert_collage_params).map(MediaParam::Collage),
        DIY => from_slice(&bytes).ok().as_ref().map(convert_diy_params).map(MediaParam::DIY),
      };

      match decoded{
        Some(param) => MediaCustomData::Valid(param),
        None => MediaCustomData::Invalid,
      }
    },
    decrypt::CustomData::Invalid => MediaCustomData::Invalid,
  }
}

#[test]
fn test_1(){
  use super::decrypt::*;

  let key = MediaKey::camera_param().unwrap();
  let res = media_decrypt(Vec::from(r"q9NiCtwkEpChN5CBIvlM+7UBOn0L5iliMe9/0bUiezw2eSdCZ9TzUfs/JWBGlNv0kMcqySc5lGDPnNjAsqnZ01/iVK/X71xtAImj3Gcd03r0zGE3xXrq4ToOG8KSqPiv7+ecY4UX6H/8PO5yheO24u0LcWKh0Rzk3l9EA07xksHWQlc84xBVcOKWnYNpwGkN"), &key);

  if let Some(custom_data) = res {
    let media_custom_data = decode_media_param(MediaParamType::MomoCameraParams, &custom_data);

    if let MediaCustomData::Valid(media_param) = media_custom_data {
      if let MediaParam::MomoCameraParams(momo_camera_params) = media_param {
        println!("{:?}", momo_camera_params.highlights);
      }
    }
  }
}

#[test]
fn test_2(){
  use super::decrypt::*;
  
  let key = MediaKey::from_str(String::from("108328049")).unwrap();
  let res = media_decode_file_unchecked(Vec::from(b"\xff\xd9"), String::from(r"image path"), &key);

  if let Some(custom_data) = res {
    let media_custom_data = decode_media_param(MediaParamType::NikkiPhoto, &custom_data);

    if let MediaCustomData::Valid(media_param) = media_custom_data {
      if let MediaParam::NikkiPhoto(nikki_photo_params) = media_param {
        println!("{:?}", nikki_photo_params.camera.unwrap().highlights);
      }
    }
  }
}