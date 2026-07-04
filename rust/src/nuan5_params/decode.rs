use std::ffi::{c_char, c_void, CString};
use std::ptr;
use std::sync::Arc;
use flutter_rust_bridge::frb;
use crate::frb_generated::StreamSink;
use crate::nuan5_params::decrypt::{DecryptionError, MediaKey, ClothDiyShareCode};
use super::converter::*;
use super::decrypt;
use crate::serde_nuan5_json::de::from_slice;
use super::structs::{nikki_photo_params::*, clock_in_photo_params::*, collage_params::*, cloth_diy_params::*, momo_camera_params::*};


/// ============================================================
/// Media
/// ============================================================

#[frb]
pub enum MediaParamType{
  CameraParams,
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

#[frb]
#[derive(Clone)]
pub enum MediaParam{
  CameraParams(CameraParams),
  NikkiPhoto(NikkiPhotoParams),
  // MagazinePhoto(MagazinePhotoParams),
  ClockInPhoto(ClockInPhotoParams),
  Collage(CollageParams),
  DIY(ClothDiyParams),
  // Video(VideoParams),
  // VideoCover(VideoCoverParams),
  // ShareCode(ShareCode),
  // DiyHistoryShareCode(DiyHistoryShareCodeParams),
}

#[frb]
#[derive(Clone)]
pub enum MediaCustomData{
  Invalid,
  Valid(MediaParam),
}

const EMPTY_FLAG: &[u8; 0] = b"";
const IMAGE_FLAG: &[u8; 2] = b"\xFF\xD9";
const VIDEO_FLAG: &[u8; 12] = b"%PAPERGAMES%";

#[inline]
fn get_flag(param_type: &MediaParamType) -> &'static [u8]{
  use MediaParamType::*;

  match param_type{
    CameraParams => EMPTY_FLAG,
    NikkiPhoto | ClockInPhoto | Collage | DIY => IMAGE_FLAG,
  }
}

#[frb]
pub fn decode_media_param(param_type: &MediaParamType, data: &decrypt::CustomData) -> MediaCustomData{
  match data{
    decrypt::CustomData::Valid(bytes) => {
      use MediaParamType::*;

      let decoded = match param_type{
        CameraParams => from_slice(&bytes).ok().as_ref().map(convert_camera_params).map(MediaParam::CameraParams),
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

#[frb]
pub fn media_de(param_type: &MediaParamType, data: &[u8], key: &MediaKey) -> Result<MediaCustomData, DecryptionError>{
  decrypt::media_decrypt(data, key).map(|decrypted|{
    decode_media_param(param_type, &decrypted)
  })
}

#[frb]
pub fn media_de_file_bytes_unchecked(param_type: &MediaParamType, bytes: &[u8], key: &MediaKey) -> Result<MediaCustomData, DecryptionError>{
  decrypt::media_decode_file_bytes_unchecked(&get_flag(&param_type), bytes, key).map(|decrypted|{
    decode_media_param(param_type, &decrypted)
  })
}

#[frb]
pub fn media_de_file_unchecked(param_type: &MediaParamType, path: String, key: &MediaKey) -> Result<MediaCustomData, DecryptionError>{
  decrypt::media_decode_file_unchecked(&get_flag(&param_type), path, key).map(|decrypted|{
    decode_media_param(param_type, &decrypted)
  })
}

#[frb(sync)]
pub fn media_de_file_unchecked_sync(param_type: &MediaParamType, path: String, key: &MediaKey) -> Result<MediaCustomData, DecryptionError>{
  decrypt::media_decode_file_unchecked(&get_flag(&param_type), path, key).map(|decrypted|{
    decode_media_param(param_type, &decrypted)
  })
}

#[derive(Clone)]
pub struct MediaCustomDataResult{
  pub index: usize,
  pub data: Option<MediaCustomData>,
}

struct MediaStreamCallbackContext<'a>{
  sink: StreamSink<MediaCustomDataResult>,
  param_type: &'a MediaParamType,
}

#[frb]
pub fn media_de_files_unchecked(
  param_type: &MediaParamType,
  paths: Vec<String>,
  key: &MediaKey,
  sink: StreamSink<MediaCustomDataResult>,
) -> Result<(), DecryptionError>{
  if paths.is_empty() {
    return Ok(());
  }

  use crate::nuan5_params::decrypt::convert_media_result;
  let c_paths: Vec<CString> = paths.into_iter().filter_map(|p| CString::new(p).ok()).collect();
  let path_ptrs: Vec<*const c_char> = c_paths.iter().map(|p| p.as_ptr()).collect();

  let context = Arc::new(MediaStreamCallbackContext{ sink, param_type });
  let userdata = Arc::into_raw(Arc::clone(&context)) as *mut c_void;

  extern "C" fn stream_trampoline(
    index: usize,
    result: *mut decrypt::ffi::MediaDecryptionResult,
    userdata: *mut c_void,
  ){
    if userdata.is_null() {
      return;
    }

    let ctx = unsafe{ &*(userdata as *const MediaStreamCallbackContext) };
    let sink = &ctx.sink;
    let param_type = &ctx.param_type;

    if result.is_null() {
      let _ = sink.add(MediaCustomDataResult { index, data: None });
      return;
    }

    let data = unsafe{ convert_media_result(ptr::read(result)) };

    let _ = sink.add(MediaCustomDataResult{
      index,
      data: data.map(|decrypted|{
        decode_media_param(param_type.clone(), &decrypted)
      }).ok(),
    });
  }

  let flag = get_flag(&param_type);

  unsafe{
    decrypt::ffi::media_decode_files_unchecked_stream(
      flag.as_ptr(),
      flag.len(),
      path_ptrs.as_ptr(),
      path_ptrs.len(),
      key.ptr,
      stream_trampoline,
      userdata,
    );
  }

  let _ = unsafe{ Arc::from_raw(userdata as *const MediaStreamCallbackContext) };

  Ok(())
}


/// ============================================================
/// ClothDiy
/// ============================================================

#[frb]
pub enum ClothDiyParamType{
  ClothDiy,
  // DiyHistoryShareCode,
}

#[frb]
#[derive(Clone)]
pub enum ClothDiyParam{
  ClothDiy(ClothDiyParams),
  // DiyHistoryShareCode(DiyHistoryShareCodeParams),
}

#[frb]
pub fn de_cloth_diy_param(param_type: &ClothDiyParamType, bytes: &[u8]) -> Option<ClothDiyParam>{
  use ClothDiyParamType::*;

  let decoded = match param_type{
    ClothDiy => from_slice(&bytes).ok().as_ref().map(convert_net_cloth_diy_params).map(ClothDiyParam::ClothDiy),
    // DiyHistoryShareCode => from_slice(&bytes).ok().as_ref().map(convert_nikki_photo_params).map(MediaParam::NikkiPhoto),
  };
  
  decoded
}

#[frb]
pub fn cloth_diy_de_network(key: &ClothDiyShareCode) -> Result<Option<ClothDiyParam>, DecryptionError>{
  decrypt::cloth_diy_decode_network(key).map(|decrypted|{
    de_cloth_diy_param(&ClothDiyParamType::ClothDiy, &decrypted)
  })
}





#[test]
fn test_1(){
  use super::decrypt::*;

  let key = MediaKey::camera_param().unwrap();
  let res = media_decrypt(b"q9NiCtwkEpChN5CBIvlM+7UBOn0L5iliMe9/0bUiezw2eSdCZ9TzUfs/JWBGlNv0kMcqySc5lGDPnNjAsqnZ01/iVK/X71xtAImj3Gcd03r0zGE3xXrq4ToOG8KSqPiv7+ecY4UX6H/8PO5yheO24u0LcWKh0Rzk3l9EA07xksHWQlc84xBVcOKWnYNpwGkN", &key);

  if let Ok(custom_data) = res {
    let media_custom_data = decode_media_param(&MediaParamType::CameraParams, &custom_data);

    if let MediaCustomData::Valid(media_param) = media_custom_data {
      if let MediaParam::CameraParams(camera_params) = media_param {
        println!("{:?}", camera_params.highlights);
      }
    }
  }
}

#[test]
fn test_2(){
  use super::decrypt::*;

  let key = MediaKey::from_str(String::from("key")).unwrap();
  let res = media_decode_file_unchecked(&Vec::from(b"\xff\xd9"), String::from(r"image path"), &key);

  if let Ok(custom_data) = res {
    let media_custom_data = decode_media_param(&MediaParamType::NikkiPhoto, &custom_data);

    if let MediaCustomData::Valid(media_param) = media_custom_data {
      if let MediaParam::NikkiPhoto(nikki_photo_params) = media_param {
        println!("{:?}", nikki_photo_params.camera.unwrap().highlights);
      }
    }
  }
}