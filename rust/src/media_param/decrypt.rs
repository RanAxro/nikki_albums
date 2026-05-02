use flutter_rust_bridge::frb;
use std::ffi::{c_char, CString};
use std::ptr;

// ============================================================
// FFI 绑定（保持不变）
// ============================================================
#[allow(non_snake_case, dead_code)]
mod ffi {
  use std::ffi::c_char;

  #[flutter_rust_bridge::frb(ignore)]
  #[repr(C)]
  pub struct DecryptionResult {
    pub status: u32,
    pub data: *mut u8,
    pub len: usize,
  }

  #[repr(C)]
  pub struct Key {
    _private: [u8; 0],
  }

  pub type ProgressCallback = Option<extern "C" fn(current: usize, total: usize)>;

  extern "C" {
    pub fn free_decryption_result(result: DecryptionResult);
    pub fn key_from_bytes(bytes: *const u8, len: usize) -> *mut Key;
    pub fn key_from_str_bytes(bytes: *const u8, len: usize) -> *mut Key;
    pub fn key_from_str(s: *const c_char) -> *mut Key;
    pub fn key_camera_param() -> *mut Key;
    pub fn free_key(key: *mut Key);
    pub fn decrypt(data: *const u8, len: usize, key: *const Key) -> DecryptionResult;
    pub fn decode_file_bytes_unchecked(
      flag: *const u8,
      flag_len: usize,
      bytes: *const u8,
      bytes_len: usize,
      key: *const Key,
    ) -> DecryptionResult;
    pub fn decode_file_unchecked(
      flag: *const u8,
      flag_len: usize,
      path: *const c_char,
      key: *const Key,
    ) -> DecryptionResult;
    pub fn decode_files_unchecked(
      flag: *const u8,
      flag_len: usize,
      paths: *const *const c_char,
      path_count: usize,
      key: *const Key,
      callback: ProgressCallback,
    ) -> *mut DecryptionResult;
    pub fn free_results_array(arr: *mut DecryptionResult, count: usize);
    pub fn free_results_array_and_data(arr: *mut DecryptionResult, count: usize);
  }
}

// ============================================================
// CustomData
// ============================================================
#[frb]
#[derive(Debug, Clone)]
pub enum CustomData {
  Invalid,
  Valid(Vec<u8>),
}

// ============================================================
// Key 封装
// ============================================================
#[frb(opaque)]
pub struct Key {
  ptr: *mut ffi::Key,
}

unsafe impl Send for Key {}
unsafe impl Sync for Key {}

impl Key {
  #[frb(sync, positional)]
  pub fn from_bytes(bytes: Vec<u8>) -> anyhow::Result<Key> {
    let ptr = unsafe { ffi::key_from_bytes(bytes.as_ptr(), bytes.len()) };
    if ptr.is_null() {
      anyhow::bail!("failed to create key from bytes");
    }
    Ok(Key { ptr })
  }

  #[frb(sync, positional)]
  pub fn from_str_bytes(bytes: Vec<u8>) -> anyhow::Result<Key> {
    let ptr = unsafe { ffi::key_from_str_bytes(bytes.as_ptr(), bytes.len()) };
    if ptr.is_null() {
      anyhow::bail!("failed to create key from str bytes");
    }
    Ok(Key { ptr })
  }

  #[frb(sync, positional)]
  pub fn from_str(s: String) -> anyhow::Result<Key> {
    let c_str = CString::new(s).map_err(|e| anyhow::anyhow!("invalid string: {e}"))?;
    let ptr = unsafe { ffi::key_from_str(c_str.as_ptr()) };
    if ptr.is_null() {
      anyhow::bail!("failed to create key from string");
    }
    Ok(Key { ptr })
  }

  #[frb(sync)]
  pub fn camera_param() -> anyhow::Result<Key> {
    let ptr = unsafe { ffi::key_camera_param() };
    if ptr.is_null() {
      anyhow::bail!("failed to create camera param key");
    }
    Ok(Key { ptr })
  }

  pub fn dispose(self) {
    if !self.ptr.is_null() {
      unsafe { ffi::free_key(self.ptr) };
    }
  }
}

// ============================================================
// 内部辅助：转换 DecryptionResult
// ============================================================
fn convert_result(result: ffi::DecryptionResult) -> Option<CustomData> {
  if result.status != 0 {
    unsafe { ffi::free_decryption_result(result) };
    return None;
  }

  if result.data.is_null() || result.len == 0 {
    unsafe { ffi::free_decryption_result(result) };
    Some(CustomData::Invalid)
  } else {
    let data = unsafe {
      let slice = std::slice::from_raw_parts(result.data, result.len);
      let vec = slice.to_vec();
      ffi::free_decryption_result(result);
      vec
    };
    Some(CustomData::Valid(data))
  }
}

// ============================================================
// 单文件/内存解密
// ============================================================
#[frb(sync, positional)]
pub fn decrypt(data: Vec<u8>, key: &Key) -> Option<CustomData> {
  let result = unsafe { ffi::decrypt(data.as_ptr(), data.len(), key.ptr) };
  convert_result(result)
}

#[frb(sync)]
pub fn decode_file_bytes_unchecked(
  flag: Vec<u8>,
  bytes: Vec<u8>,
  key: &Key,
) -> Option<CustomData> {
  let result = unsafe {
    ffi::decode_file_bytes_unchecked(
      flag.as_ptr(),
      flag.len(),
      bytes.as_ptr(),
      bytes.len(),
      key.ptr,
    )
  };
  convert_result(result)
}

#[frb]
pub fn decode_file_unchecked(flag: Vec<u8>, path: String, key: &Key) -> Option<CustomData> {
  let c_path = CString::new(path).ok()?;
  let result = unsafe {
    ffi::decode_file_unchecked(flag.as_ptr(), flag.len(), c_path.as_ptr(), key.ptr)
  };
  convert_result(result)
}

#[frb(sync)]
pub fn decode_file_unchecked_sync(flag: Vec<u8>, path: String, key: &Key) -> Option<CustomData> {
  decode_file_unchecked(flag, path, key)
}

// ============================================================
// 批量解密（带进度 Stream）
// ============================================================

// #[frb]
// pub enum DecodeEvent{
//   Progress(u32),
//   Result(Vec<Option<CustomData>>),
// }
//
// /// 使用 u32 百分比（0~100）作为 Stream 类型，避免自定义 struct 的 SseEncode 问题
// thread_local! {
//     static PROGRESS_SINK: RefCell<Option<StreamSink<u32>>> = RefCell::new(None);
// }
//
// extern "C" fn progress_callback(current: usize, total: usize) {
//   PROGRESS_SINK.with(|sink| {
//     if let Some(ref s) = *sink.borrow() {
//       let pct = if total > 0 {
//         ((current as f64 / total as f64) * 100.0).min(100.0) as u32
//       } else {
//         0
//       };
//       let _ = s.add(pct);
//     }
//   });
// }
//
// #[frb]
// pub fn decode_files_unchecked(
//   flag: Vec<u8>,
//   paths: Vec<String>,
//   key: &Key,
//   progress_sink: StreamSink<u32>,
// ) -> Vec<Option<CustomData>> {
//   PROGRESS_SINK.with(|s| {
//     *s.borrow_mut() = Some(progress_sink);
//   });
//
//   let c_paths: Vec<CString> = paths.into_iter().filter_map(|p| CString::new(p).ok()).collect();
//   let path_count = c_paths.len();
//   let ptrs: Vec<*const c_char> = c_paths.iter().map(|c| c.as_ptr()).collect();
//
//   let results_ptr = unsafe {
//     ffi::decode_files_unchecked(
//       flag.as_ptr(),
//       flag.len(),
//       ptrs.as_ptr(),
//       path_count,
//       key.ptr,
//       Some(progress_callback),
//     )
//   };
//
//   PROGRESS_SINK.with(|s| {
//     *s.borrow_mut() = None;
//   });
//
//   if results_ptr.is_null() {
//     return vec![];
//   }
//
//   let mut results = Vec::with_capacity(path_count);
//   for i in 0..path_count {
//     let item = unsafe { ptr::read(results_ptr.add(i)) };
//     results.push(convert_result(item));
//   }
//
//   unsafe { ffi::free_results_array(results_ptr, path_count) };
//
//   results
// }

/// 批量解密（无进度）
#[frb]
pub fn decode_files_unchecked_no_progress(
  flag: Vec<u8>,
  paths: Vec<String>,
  key: &Key,
) -> Vec<Option<CustomData>> {
  let c_paths: Vec<CString> = paths.into_iter().filter_map(|p| CString::new(p).ok()).collect();
  let path_count = c_paths.len();
  let ptrs: Vec<*const c_char> = c_paths.iter().map(|c| c.as_ptr()).collect();

  let results_ptr = unsafe {
    ffi::decode_files_unchecked(
      flag.as_ptr(),
      flag.len(),
      ptrs.as_ptr(),
      path_count,
      key.ptr,
      None,
    )
  };

  if results_ptr.is_null() {
    return vec![];
  }

  let mut results = Vec::with_capacity(path_count);
  for i in 0..path_count {
    let item = unsafe { ptr::read(results_ptr.add(i)) };
    results.push(convert_result(item));
  }

  unsafe { ffi::free_results_array(results_ptr, path_count) };

  results
}