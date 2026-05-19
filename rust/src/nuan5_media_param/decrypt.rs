use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use std::ffi::{c_char, c_void, CString};
use std::ptr;
use std::sync::Arc;
use crate::nuan5_media_param::decrypt::ffi::free_media_decryption_result;

// ============================================================
// FFI 绑定
// ============================================================
#[allow(non_snake_case, dead_code)]
pub(super) mod ffi{
  use std::ffi::{c_char, c_void};
  use flutter_rust_bridge::frb;

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
  }

  #[frb(ignore)]
  #[repr(C)]
  pub struct MediaDecryptionResult{
    pub status: u32,
    pub data: *mut u8,
    pub len: usize,
  }

  #[frb(ignore)]
  #[repr(C)]
  pub struct MediaKey{
    _private: [u8; 0],
  }

  pub type MediaProgressCallback = Option<extern "C" fn(current: usize, total: usize, userdata: *mut c_void)>;

  pub type MediaStreamCallback = extern "C" fn(index: usize, result: *mut MediaDecryptionResult, userdata: *mut c_void);

  extern "C" {
    pub fn abi_version() -> u32;
    pub fn free_media_decryption_result(result: MediaDecryptionResult);
    pub fn free_media_results_array(arr: *mut MediaDecryptionResult, count: usize);
    pub fn free_media_results_array_and_data(arr: *mut MediaDecryptionResult, count: usize);
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
  }
}

// ============================================================
// CustomData
// ============================================================
#[derive(Debug, Clone)]
pub enum CustomData{
  Invalid,
  Valid(Vec<u8>),
}

// ============================================================
// Key 封装
// ============================================================
#[frb(opaque)]
pub struct MediaKey{
  pub(super) ptr: *mut ffi::MediaKey,
}

unsafe impl Send for MediaKey{}
unsafe impl Sync for MediaKey{}

impl MediaKey{
  #[frb(sync, positional)]
  pub fn from_str_bytes(bytes: &[u8]) -> anyhow::Result<MediaKey>{
    let ptr = unsafe{ ffi::media_key_from_str_bytes(bytes.as_ptr(), bytes.len()) };
    if ptr.is_null() {
      anyhow::bail!("failed to create key from str bytes");
    }
    Ok(MediaKey{ ptr })
  }

  #[frb(sync, positional)]
  pub fn from_str(s: String) -> anyhow::Result<MediaKey>{
    let c_str = CString::new(s).map_err(|e| anyhow::anyhow!("invalid string: {e}"))?;
    let ptr = unsafe{ ffi::media_key_from_str(c_str.as_ptr()) };
    if ptr.is_null() {
      anyhow::bail!("failed to create key from string");
    }
    Ok(MediaKey{ ptr })
  }

  #[frb(sync)]
  pub fn camera_param() -> anyhow::Result<MediaKey>{
    let ptr = unsafe{ ffi::media_key_camera_param() };
    if ptr.is_null() {
      anyhow::bail!("failed to create camera param key");
    }
    Ok(MediaKey{ ptr })
  }

  pub fn dispose(self){
    if !self.ptr.is_null() {
      unsafe{ ffi::free_media_key(self.ptr) };
    }
  }
}

// ============================================================
// 内部辅助：转换 DecryptionResult
// ============================================================
pub(super) fn convert_media_result(result: ffi::MediaDecryptionResult) -> Option<CustomData>{
  if result.status != 0 {
    unsafe{ ffi::free_media_decryption_result(result) };
    return None;
  }

  if result.data.is_null() || result.len == 0 {
    unsafe{ ffi::free_media_decryption_result(result) };
    Some(CustomData::Invalid)
  }else{
    let data = unsafe{
      let slice = std::slice::from_raw_parts(result.data, result.len);
      let vec = slice.to_vec();
      ffi::free_media_decryption_result(result);
      vec
    };
    Some(CustomData::Valid(data))
  }
}

// ============================================================
// 单文件/内存解密
// ============================================================
#[frb(sync, positional)]
pub fn media_decrypt(data: &[u8], key: &MediaKey) -> Option<CustomData>{
  let result = unsafe{ ffi::media_decrypt(data.as_ptr(), data.len(), key.ptr) };
  convert_media_result(result)
}

#[frb(sync)]
pub fn media_decode_file_bytes_unchecked(
  flag: &[u8],
  bytes: &[u8],
  key: &MediaKey,
) -> Option<CustomData>{
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

#[frb]
pub fn media_decode_file_unchecked(flag: &[u8], path: String, key: &MediaKey) -> Option<CustomData>{
  let c_path = CString::new(path).ok()?;
  let result = unsafe{
    ffi::media_decode_file_unchecked(flag.as_ptr(), flag.len(), c_path.as_ptr(), key.ptr)
  };
  convert_media_result(result)
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

  unsafe{
    // 1. 路径转 CString
    let c_paths: Vec<CString> = paths
      .into_iter()
      .map(|p| CString::new(p).map_err(|e| anyhow::anyhow!("路径包含非法空字符: {}", e)))
      .collect::<Result<_, _>>()?;
    let path_ptrs: Vec<*const c_char> = c_paths.iter().map(|p| p.as_ptr()).collect();

    // 2. Arc 包装 StreamSink
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

    // 3. 调用 C 接口
    let results_ptr = ffi::media_decode_files_unchecked(
      flag.as_ptr(),
      flag.len(),
      path_ptrs.as_ptr(),
      path_ptrs.len(),
      key.ptr,
      Some(trampoline),
      userdata,
    );

    // 4. 释放 userdata 对应的 Arc
    let _ = Arc::from_raw(userdata as *const StreamSink<MediaDecodeEvent>);

    if results_ptr.is_null() {
      return Err(anyhow::anyhow!("decode_files_unchecked 返回了空指针"));
    }

    // 5. 逐个移出 DecryptionResult，交给 convert_result 统一处理
    let mut decoded = Vec::with_capacity(path_ptrs.len());
    for i in 0..path_ptrs.len() {
      let result = ptr::read(results_ptr.add(i));
      decoded.push(convert_media_result(result));
    }

    // 6. convert_result 已经释放了每个元素的内部 data，
    //    这里只释放 C 侧分配的数组外壳
    ffi::free_media_results_array(results_ptr, path_ptrs.len());

    // 7. 推送最终结果事件
    sink.add(MediaDecodeEvent::Result(decoded));

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

  unsafe{ ffi::free_media_results_array(results_ptr, path_count) };

  results
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

  let c_paths: Vec<CString> = paths.into_iter().filter_map(|p| CString::new(p).ok()).collect();
  let path_ptrs: Vec<*const c_char> = c_paths.iter().map(|p| p.as_ptr()).collect();

  // 2. Arc 包装 StreamSink，作为 userdata 传入 C 侧
  let sink = Arc::new(sink);
  let userdata = Arc::into_raw(Arc::clone(&sink)) as *mut c_void;

  // 3. 流式回调 trampoline
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

  // 4. 调用 C 流式接口
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

  // 5. 释放 userdata 对应的 Arc（假设 C 函数在所有回调完成后才返回）
  let _ = unsafe{ Arc::from_raw(userdata as *const StreamSink<MediaStreamResult>) };

  Ok(())
}