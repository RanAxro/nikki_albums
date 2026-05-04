// use flutter_rust_bridge::frb;
// use crate::nuan5_media_param::de::from_slice;
// use crate::nuan5_media_param::decrypt;
// use crate::nuan5_media_param::structs::camera_params::CameraParams;
// use crate::nuan5_media_param::structs::image_custom_data::{ClockInPhotoCustomData, CollageCustomData, DIYCustomData, MagazinePhotoCustomData, NikkiPhotoCustomData};
// use crate::nuan5_media_param::structs::share_code::{DiyHistoryShareCode, ShareCode};
// use crate::nuan5_media_param::structs::video_custom_data::{VideoCoverCustomData, VideoCustomData};
// 
// pub enum MediaParamType{
//   CameraParams,
//   NikkiPhoto,
//   MagazinePhoto,
//   ClockInPhoto,
//   Collage,
//   DIY,
//   Video,
//   VideoCover,
//   ShareCode,
//   DiyHistoryShareCode,
// }
//
// #[frb(non_opaque)]
// #[derive(Clone)]
// pub enum MediaParam{
//   CameraParams(CameraParams),
//   NikkiPhoto(NikkiPhotoCustomData),
//   MagazinePhoto(MagazinePhotoCustomData),
//   ClockInPhoto(ClockInPhotoCustomData),
//   Collage(CollageCustomData),
//   DIY(DIYCustomData),
//   Video(VideoCustomData),
//   VideoCover(VideoCoverCustomData),
//   ShareCode(ShareCode),
//   DiyHistoryShareCode(DiyHistoryShareCode),
// }
//
// #[frb(non_opaque)]
// #[derive(Clone)]
// pub enum MediaCustomData{
//   Invalid,
//   Valid(MediaParam),
// }
//
//
//
// // const EMPTY_FLAG: &[u8; 0] = b"";
// // const IMAGE_FLAG: &[u8; 2] = b"\xFF\xD9";
// // const VIDEO_FLAG: &[u8; 12] = b"%PAPERGAMES%";
//
// // #[inline]
// // fn get_flag(param_type: MediaParamType) -> &'static [u8]{
// //   use MediaParamType::*;
// //
// //   match param_type{
// //     CameraParams | ShareCode | DiyHistoryShareCode => EMPTY_FLAG,
// //     NikkiPhoto | MagazinePhoto | ClockInPhoto | Collage | DIY => IMAGE_FLAG,
// //     Video | VideoCover => VIDEO_FLAG,
// //   }
// // }
//
// pub fn decode_param(param_type: MediaParamType, data: decrypt::CustomData) -> MediaCustomData{
//   match data{
//     decrypt::CustomData::Valid(bytes) => {
//       use MediaParamType::*;
//
//       let decoded = match param_type{
//         CameraParams => from_slice(&bytes).ok().map(MediaParam::CameraParams),
//         NikkiPhoto => from_slice(&bytes).ok().map(MediaParam::NikkiPhoto),
//         MagazinePhoto => from_slice(&bytes).ok().map(MediaParam::MagazinePhoto),
//         ClockInPhoto => from_slice(&bytes).ok().map(MediaParam::ClockInPhoto),
//         Collage => from_slice(&bytes).ok().map(MediaParam::Collage),
//         DIY => from_slice(&bytes).ok().map(MediaParam::DIY),
//         Video => from_slice(&bytes).ok().map(MediaParam::Video),
//         VideoCover => from_slice(&bytes).ok().map(MediaParam::VideoCover),
//         ShareCode => from_slice(&bytes).ok().map(MediaParam::ShareCode),
//         DiyHistoryShareCode => from_slice(&bytes).ok().map(MediaParam::DiyHistoryShareCode),
//       };
//
//       match decoded{
//         Some(param) => MediaCustomData::Valid(param),
//         None => MediaCustomData::Invalid,
//       }
//     },
//     decrypt::CustomData::Invalid => MediaCustomData::Invalid,
//   }
// }