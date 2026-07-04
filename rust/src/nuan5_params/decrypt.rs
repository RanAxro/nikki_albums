use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use std::ffi::{c_char, c_void, CString};
use std::ptr;
use std::sync::Arc;

// ============================================================
// FFI 绑定
// ============================================================
#[cfg(any(target_os = "windows", target_os = "macos"))]
#[allow(non_snake_case, dead_code)]
pub(super) mod ffi{
  use std::ffi::{c_char, c_void};
  use flutter_rust_bridge::frb;

  #[frb(ignore)]
  #[repr(C)]
  pub struct CBytes{
    pub data: *mut u8,
    pub len: usize,
    pub cap: usize,
  }

  impl CBytes{
    pub fn into_vec(self) -> Vec<u8>{
      if self.data.is_null() {
        return Vec::new();
      }
      let vec = unsafe{ Vec::from_raw_parts(self.data, self.len, self.cap) };
      std::mem::forget(self);
      vec
    }
  }

  impl Drop for CBytes{
    fn drop(&mut self){
      unsafe{ free_c_bytes_ptr(self); }
    }
  }

  #[repr(u32)]
  #[derive(Clone, Copy, Debug, PartialEq, Eq)]
  pub enum DecryptionStatus{
    Success = 0,
    NullPointer = 1,
    DataLenIsNotAMultipleOf16 = 2,
    DecodingBase64Failed = 3,
    FindNoStartFlag = 4,
    FindNoEndFlag = 5,
    Io = 6,
    IllegalUTF8 = 7,
    InvalidClothDiyShareCode = 8,
    NotNumberString = 9,
    NetworkError = 10,
  }

  /// ========== Media ==========
  #[frb(ignore)]
  #[repr(C)]
  pub struct MediaDecryptionResult{
    pub status: u32,
    pub bytes: CBytes,
  }

  #[frb(ignore)]
  #[repr(C)]
  pub struct MediaKey{
    _private: [u8; 0],
  }

  /// ========== ClothDiy ==========
  #[frb(ignore)]
  #[repr(C)]
  pub struct ClothDiyDecryptionResult{
    pub status: u32,
    pub bytes: CBytes,
  }

  #[frb(ignore)]
  #[repr(C)]
  pub struct ClothDiyShareCode{
    _private: [u8; 0],
  }

  /// ========== HomeBuild ==========
  #[frb(ignore)]
  #[repr(C)]
  pub struct HomeBuildDecryptionResult{
    pub status: u32,
    pub bytes: CBytes,
  }

  #[frb(ignore)]
  #[repr(C)]
  pub struct HomeBuildShareCode{
    _private: [u8; 0],
  }


  pub type MediaProgressCallback = Option<extern "C" fn(current: usize, total: usize, userdata: *mut c_void)>;
  pub type MediaStreamCallback = extern "C" fn(index: usize, result: *mut MediaDecryptionResult, userdata: *mut c_void);

  extern "C" {
    pub fn abi_version() -> u32;

    pub fn free_c_bytes(c_bytes: CBytes);
    pub fn free_c_bytes_ptr(c_bytes_ptr: *mut CBytes);
    /// ========== Media ==========
    pub fn media_key_from_str_bytes(bytes: *const u8, len: usize) -> *mut MediaKey;
    pub fn media_key_from_str(s: *const c_char) -> *mut MediaKey;
    pub fn media_key_camera_param() -> *mut MediaKey;
    pub fn free_media_key(key: *mut MediaKey);
    pub fn media_decrypt(data: *const u8, len: usize, key: *const MediaKey) -> MediaDecryptionResult;
    pub fn media_decode_file_bytes_unchecked(
      flag: *const u8,
      flag_len: usize,
      bytes: *const u8,
      bytes_len: usize,
      key: *const MediaKey,
    ) -> MediaDecryptionResult;
    pub fn media_decode_file_unchecked(
      flag: *const u8,
      flag_len: usize,
      path: *const c_char,
      key: *const MediaKey,
    ) -> MediaDecryptionResult;
    pub fn media_decode_files_unchecked(
      flag: *const u8,
      flag_len: usize,
      paths: *const *const c_char,
      path_count: usize,
      key: *const MediaKey,
      callback: MediaProgressCallback,
      userdata: *mut c_void,
    ) -> *mut MediaDecryptionResult;
    pub fn media_decode_files_unchecked_stream(
      flag: *const u8,
      flag_len: usize,
      paths: *const *const c_char,
      path_count: usize,
      key: *const MediaKey,
      callback: MediaStreamCallback,
      userdata: *mut c_void,
    );

    /// ========== ClothDiy ==========
    pub fn cloth_diy_share_code_from_code_str(s: *const c_char) -> *mut ClothDiyShareCode;
    pub fn cloth_diy_share_code_timestamp(key: *mut ClothDiyShareCode) -> i64;
    pub fn cloth_diy_share_code_uid_bytes(key: *mut ClothDiyShareCode) -> ClothDiyDecryptionResult;
    pub fn free_cloth_diy_share_code(key: *mut ClothDiyShareCode);
    pub fn cloth_diy_decode_network(key: *const ClothDiyShareCode) -> ClothDiyDecryptionResult;

    /// ========== HomeBuild ==========
    pub fn home_build_share_code_from_code_str(s: *const c_char) -> *mut HomeBuildShareCode;
    pub fn home_build_share_code_server(key: *mut HomeBuildShareCode) -> i64;
    pub fn free_home_build_share_code(key: *mut HomeBuildShareCode);
    pub fn home_build_decode_network(key: *const HomeBuildShareCode) -> HomeBuildDecryptionResult;
  }
}


/// ============================================================
/// Media
/// ============================================================

// ============================================================
// CustomData
// ============================================================
#[derive(Debug, Clone)]
pub enum CustomData{
  Invalid,
  Valid(Vec<u8>),
}

#[frb(opaque)]
pub struct MediaKey{
  #[cfg(any(target_os = "windows", target_os = "macos"))]
  pub(super) ptr: *mut ffi::MediaKey,
  #[cfg(not(any(target_os = "windows", target_os = "macos")))]
  _dummy: u8,
}

unsafe impl Send for MediaKey{}
unsafe impl Sync for MediaKey{}

impl MediaKey{
  #[frb(sync, positional)]
  pub fn from_str_bytes(bytes: &[u8]) -> anyhow::Result<MediaKey>{
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      let ptr = unsafe{ ffi::media_key_from_str_bytes(bytes.as_ptr(), bytes.len()) };
      if ptr.is_null() {
        anyhow::bail!("failed to create key from str bytes");
      }
      Ok(MediaKey{ ptr })
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
      Ok(MediaKey{ _dummy: 0 })
    }
  }

  #[frb(sync, positional)]
  pub fn from_str(s: String) -> anyhow::Result<MediaKey>{
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      let c_str = CString::new(s).map_err(|e| anyhow::anyhow!("invalid string: {e}"))?;
      let ptr = unsafe{ ffi::media_key_from_str(c_str.as_ptr()) };
      if ptr.is_null() {
        anyhow::bail!("failed to create key from string");
      }
      Ok(MediaKey{ ptr })
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
      Ok(MediaKey{ _dummy: 0 })
    }
  }

  #[frb(sync)]
  pub fn camera_param() -> anyhow::Result<MediaKey>{
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      let ptr = unsafe{ ffi::media_key_camera_param() };
      if ptr.is_null() {
        anyhow::bail!("failed to create camera param key");
      }
      Ok(MediaKey{ ptr })
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
      Ok(MediaKey{ _dummy: 0 })
    }
  }
}

impl Drop for MediaKey{
  fn drop(&mut self){
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      if !self.ptr.is_null() {
        unsafe{ ffi::free_media_key(self.ptr) };
      }
    }
  }
}

// ============================================================
// 内部辅助：转换 DecryptionResult
// ============================================================
#[cfg(any(target_os = "windows", target_os = "macos"))]
pub(super) fn convert_media_result(result: ffi::MediaDecryptionResult) -> Option<CustomData>{
  if result.status != 0 {
    return None;
  }

  if result.bytes.data.is_null() {
    Some(CustomData::Invalid)
  }else{
    Some(CustomData::Valid(result.bytes.into_vec()))
  }
}

#[frb(sync, positional)]
pub fn media_decrypt(data: &[u8], key: &MediaKey) -> Option<CustomData>{
  #[cfg(any(target_os = "windows", target_os = "macos"))]
  {
    let result = unsafe{ ffi::media_decrypt(data.as_ptr(), data.len(), key.ptr) };
    convert_media_result(result)
  }
  #[cfg(not(any(target_os = "windows", target_os = "macos")))]
  {
    None
  }
}

#[frb(sync)]
pub fn media_decode_file_bytes_unchecked(
  flag: &[u8],
  bytes: &[u8],
  key: &MediaKey,
) -> Option<CustomData>{
  #[cfg(any(target_os = "windows", target_os = "macos"))]
  {
    let result = unsafe{
      ffi::media_decode_file_bytes_unchecked(
        flag.as_ptr(),
        flag.len(),
        bytes.as_ptr(),
        bytes.len(),
        key.ptr,
      )
    };
    convert_media_result(result)
  }
  #[cfg(not(any(target_os = "windows", target_os = "macos")))]
  {
    None
  }
}

#[frb]
pub fn media_decode_file_unchecked(flag: &[u8], path: String, key: &MediaKey) -> Option<CustomData>{
  #[cfg(any(target_os = "windows", target_os = "macos"))]
  {
    let c_path = CString::new(path).ok()?;
    let result = unsafe{
      ffi::media_decode_file_unchecked(flag.as_ptr(), flag.len(), c_path.as_ptr(), key.ptr)
    };
    convert_media_result(result)
  }
  #[cfg(not(any(target_os = "windows", target_os = "macos")))]
  {
    None
  }
}

#[frb(sync)]
pub fn media_decode_file_unchecked_sync(flag: &[u8], path: String, key: &MediaKey) -> Option<CustomData>{
  media_decode_file_unchecked(flag, path, key)
}

// ============================================================
// 批量解密（带进度 Stream）
// ============================================================

#[frb]
pub enum MediaDecodeEvent{
  Progress(f64),
  Result(Vec<Option<CustomData>>),
}

#[frb]
pub fn media_decode_files_unchecked(
  flag: &[u8],
  paths: Vec<String>,
  key: &MediaKey,
  progress_sink: StreamSink<MediaDecodeEvent>,
) -> anyhow::Result<()>{
  if paths.is_empty() {
    progress_sink.add(MediaDecodeEvent::Result(vec![]));
    return Ok(());
  }

  #[cfg(any(target_os = "windows", target_os = "macos"))]
  {
    unsafe{
      let c_paths: Vec<CString> = paths
        .into_iter()
        .map(|p| CString::new(p).map_err(|e| anyhow::anyhow!("路径包含非法空字符: {}", e)))
        .collect::<Result<_, _>>()?;
      let path_ptrs: Vec<*const c_char> = c_paths.iter().map(|p| p.as_ptr()).collect();

      let sink = Arc::new(progress_sink);
      let userdata = Arc::into_raw(Arc::clone(&sink)) as *mut c_void;

      extern "C" fn trampoline(
        current: usize,
        total: usize,
        userdata: *mut c_void,
      ){
        if userdata.is_null() || total == 0 {
          return;
        }
        let sink = unsafe{ &*(userdata as *const StreamSink<MediaDecodeEvent>) };
        let percent = current as f64 / total as f64;
        let _ = sink.add(MediaDecodeEvent::Progress(percent));
      }

      let results_ptr = ffi::media_decode_files_unchecked(
        flag.as_ptr(),
        flag.len(),
        path_ptrs.as_ptr(),
        path_ptrs.len(),
        key.ptr,
        Some(trampoline),
        userdata,
      );

      let _ = Arc::from_raw(userdata as *const StreamSink<MediaDecodeEvent>);

      if results_ptr.is_null() {
        return Err(anyhow::anyhow!("decode_files_unchecked 返回了空指针"));
      }

      let mut decoded = Vec::with_capacity(path_ptrs.len());
      for i in 0..path_ptrs.len() {
        let result = ptr::read(results_ptr.add(i));
        decoded.push(convert_media_result(result));
      }

      sink.add(MediaDecodeEvent::Result(decoded));

      Ok(())
    }
  }
  #[cfg(not(any(target_os = "windows", target_os = "macos")))]
  {
    let count = paths.len();
    progress_sink.add(MediaDecodeEvent::Progress(1.0));
    progress_sink.add(MediaDecodeEvent::Result(vec![None; count]));
    Ok(())
  }
}

/// 批量解密（无进度）
#[frb]
pub fn media_decode_files_unchecked_no_progress(
  flag: &[u8],
  paths: Vec<String>,
  key: &MediaKey,
) -> Vec<Option<CustomData>>{
  #[cfg(any(target_os = "windows", target_os = "macos"))]
  {
    let c_paths: Vec<CString> = paths.into_iter().filter_map(|p| CString::new(p).ok()).collect();
    let path_count = c_paths.len();
    let ptrs: Vec<*const c_char> = c_paths.iter().map(|c| c.as_ptr()).collect();

    let results_ptr = unsafe{
      ffi::media_decode_files_unchecked(
        flag.as_ptr(),
        flag.len(),
        ptrs.as_ptr(),
        path_count,
        key.ptr,
        None,
        ptr::null_mut(),
      )
    };

    if results_ptr.is_null() {
      return vec![];
    }

    let mut results = Vec::with_capacity(path_count);
    for i in 0..path_count {
      let item = unsafe{ ptr::read(results_ptr.add(i)) };
      results.push(convert_media_result(item));
    }

    results
  }
  #[cfg(not(any(target_os = "windows", target_os = "macos")))]
  {
    vec![None; paths.len()]
  }
}

// ============================================================
// 【新增】批量解密：流式回调（并行执行，每完成一个文件立即返回）
// ============================================================

/// 流式批量解密的单文件结果
#[frb]
pub struct MediaStreamResult{
  pub index: usize,
  pub data: Option<CustomData>,
}

/// 批量解密文件（流式回调，并行执行）。
#[frb]
pub fn media_decode_files_unchecked_stream(
  flag: &[u8],
  paths: Vec<String>,
  key: &MediaKey,
  sink: StreamSink<MediaStreamResult>,
) -> anyhow::Result<()>{
  if paths.is_empty() {
    return Ok(());
  }

  #[cfg(any(target_os = "windows", target_os = "macos"))]
  {
    let c_paths: Vec<CString> = paths.into_iter().filter_map(|p| CString::new(p).ok()).collect();
    let path_ptrs: Vec<*const c_char> = c_paths.iter().map(|p| p.as_ptr()).collect();

    let sink = Arc::new(sink);
    let userdata = Arc::into_raw(Arc::clone(&sink)) as *mut c_void;

    extern "C" fn stream_trampoline(
      index: usize,
      result: *mut ffi::MediaDecryptionResult,
      userdata: *mut c_void,
    ){
      if userdata.is_null() {
        return;
      }
      let sink = unsafe{ &*(userdata as *const StreamSink<MediaStreamResult>) };

      if result.is_null() {
        let _ = sink.add(MediaStreamResult{ index, data: None });
        return;
      }

      let data = unsafe{ convert_media_result(ptr::read(result)) };

      let _ = sink.add(MediaStreamResult{ index, data });
    }

    unsafe{
      ffi::media_decode_files_unchecked_stream(
        flag.as_ptr(),
        flag.len(),
        path_ptrs.as_ptr(),
        path_ptrs.len(),
        key.ptr,
        stream_trampoline,
        userdata,
      );
    }

    let _ = unsafe{ Arc::from_raw(userdata as *const StreamSink<MediaStreamResult>) };

    Ok(())
  }
  #[cfg(not(any(target_os = "windows", target_os = "macos")))]
  {
    for (i, _) in paths.iter().enumerate() {
      let _ = sink.add(MediaStreamResult { index: i, data: None });
    }
    Ok(())
  }
}


/// ============================================================
/// ShareCode
/// ============================================================
#[frb(opaque)]
pub struct ClothDiyShareCode{
  #[cfg(any(target_os = "windows", target_os = "macos"))]
  pub(super) ptr: *mut ffi::ClothDiyShareCode,
  #[cfg(not(any(target_os = "windows", target_os = "macos")))]
  _dummy: u8,
}

unsafe impl Send for ClothDiyShareCode{}
unsafe impl Sync for ClothDiyShareCode{}

impl ClothDiyShareCode{
  #[frb(sync, positional)]
  pub fn from_code_str(code: &str) -> anyhow::Result<Self>{
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      let c_str = CString::new(code).expect("");
      let ptr = unsafe{ ffi::cloth_diy_share_code_from_code_str(c_str.as_ptr()) };

      Ok(ClothDiyShareCode{ ptr })
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
      Ok(ClothDiyShareCode{ _dummy: 0 })
    }
  }

  #[frb(sync)]
  pub fn timestamp(&self) -> anyhow::Result<i64>{
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      let timestamp = unsafe{ ffi::cloth_diy_share_code_timestamp(self.ptr) };
      Ok(timestamp)
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
      Ok(-1)
    }
  }

  #[frb(sync)]
  pub fn uid(&self) -> anyhow::Result<String>{
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      let result = unsafe{ ffi::cloth_diy_share_code_uid_bytes(self.ptr) };

      if result.status != 0 || result.bytes.data.is_null() {
        return Err(anyhow::anyhow!("failed to decode share code"));
      }else{
        unsafe{
          let slice = std::slice::from_raw_parts(result.bytes.data, result.bytes.len);
          let uid = String::from_utf8_lossy(slice).to_string();
          return Ok(uid);
        };
      }
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
      Ok(String::from(""))
    }
  }
}

impl Drop for ClothDiyShareCode{
  fn drop(&mut self){
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      if !self.ptr.is_null() {
        unsafe{ ffi::free_cloth_diy_share_code(self.ptr) };
      }
    }
  }
}

#[frb]
pub fn cloth_diy_decode_network(share_code: &ClothDiyShareCode) -> Option<Vec<u8>>{
  let result = unsafe{ ffi::cloth_diy_decode_network(share_code.ptr) };

  if result.status != 0 {
    return None;
  }

  if result.bytes.data.is_null() {
    None
  }else{
    Some(result.bytes.into_vec())
  }
}



/// ============================================================
/// HomeBuild
/// ============================================================
#[frb(opaque)]
pub struct HomeBuildShareCode{
  #[cfg(any(target_os = "windows", target_os = "macos"))]
  pub(super) ptr: *mut ffi::HomeBuildShareCode,
  #[cfg(not(any(target_os = "windows", target_os = "macos")))]
  _dummy: u8,
}

unsafe impl Send for HomeBuildShareCode{}
unsafe impl Sync for HomeBuildShareCode{}

impl HomeBuildShareCode{
  #[frb(sync, positional)]
  pub fn from_code_str(code: &str) -> anyhow::Result<Self>{
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      let c_str = CString::new(code).expect("");
      let ptr = unsafe{ ffi::home_build_share_code_from_code_str(c_str.as_ptr()) };

      Ok(HomeBuildShareCode{ ptr })
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
      Ok(ClothDiyShareCode{ _dummy: 0 })
    }
  }

  #[frb(sync)]
  pub fn server(&self) -> anyhow::Result<i64>{
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      let timestamp = unsafe{ ffi::home_build_share_code_server(self.ptr) };
      Ok(timestamp)
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
      Ok(-1)
    }
  }
}

impl Drop for HomeBuildShareCode{
  fn drop(&mut self){
    #[cfg(any(target_os = "windows", target_os = "macos"))]
    {
      if !self.ptr.is_null() {
        unsafe{ ffi::free_home_build_share_code(self.ptr) };
      }
    }
  }
}

#[frb]
pub fn home_build_decode_network(share_code: &HomeBuildShareCode) -> Option<Vec<u8>>{
  let result = unsafe{ ffi::home_build_decode_network(share_code.ptr) };

  if result.status != 0 {
    return None;
  }

  if result.bytes.data.is_null() {
    None
  }else{
    Some(result.bytes.into_vec())
  }
}
