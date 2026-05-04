use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use std::ffi::{c_char, c_void, CString};
use std::ptr;
use std::sync::Arc;

// ============================================================
// FFI 绑定
// ============================================================
#[allow(non_snake_case, dead_code)]
mod ffi {
  use std::ffi::{c_char, c_void};
  use flutter_rust_bridge::frb;

  #[repr(u32)]
  #[derive(Clone, Copy, Debug, PartialEq, Eq)]
  pub enum DecryptionStatus {
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
  pub struct DecryptionResult {
    pub status: u32,
    pub data: *mut u8,
    pub len: usize,
  }

  #[frb(ignore)]
  #[repr(C)]
  pub struct Key {
    _private: [u8; 0],
  }

  pub type ProgressCallback = Option<extern "C" fn(current: usize, total: usize, userdata: *mut c_void)>;

  extern "C" {
    pub fn abi_version() -> u32;
    pub fn free_decryption_result(result: DecryptionResult);
    pub fn free_results_array(arr: *mut DecryptionResult, count: usize);
    pub fn free_results_array_and_data(arr: *mut DecryptionResult, count: usize);
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
      userdata: *mut c_void,
    ) -> *mut DecryptionResult;
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
pub struct Key {
  ptr: *mut ffi::Key,
}

unsafe impl Send for Key {}
unsafe impl Sync for Key {}

impl Key {
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

#[frb]
pub enum DecodeEvent {
  Progress(f64),
  Result(Vec<Option<CustomData>>),
}

#[frb]
pub fn decode_files_unchecked(
  flag: Vec<u8>,
  paths: Vec<String>,
  key: &Key,
  progress_sink: StreamSink<DecodeEvent>,
) -> anyhow::Result<()> {
  if paths.is_empty() {
    progress_sink.add(DecodeEvent::Result(vec![]));
    return Ok(());
  }

  unsafe {
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
    ) {
      if userdata.is_null() || total == 0 {
        return;
      }
      let sink = unsafe { &*(userdata as *const StreamSink<DecodeEvent>) };
      let percent = current as f64 / total as f64;
      let _ = sink.add(DecodeEvent::Progress(percent));
    }

    // 3. 调用 C 接口
    let results_ptr = ffi::decode_files_unchecked(
      flag.as_ptr(),
      flag.len(),
      path_ptrs.as_ptr(),
      path_ptrs.len(),
      key.ptr,
      Some(trampoline),
      userdata,
    );

    // 4. 释放 userdata 对应的 Arc
    let _ = Arc::from_raw(userdata as *const StreamSink<DecodeEvent>);

    if results_ptr.is_null() {
      return Err(anyhow::anyhow!("decode_files_unchecked 返回了空指针"));
    }

    // 5. 逐个移出 DecryptionResult，交给 convert_result 统一处理
    let mut decoded = Vec::with_capacity(path_ptrs.len());
    for i in 0..path_ptrs.len() {
      let result = ptr::read(results_ptr.add(i));
      decoded.push(convert_result(result));
    }

    // 6. convert_result 已经释放了每个元素的内部 data，
    //    这里只释放 C 侧分配的数组外壳
    ffi::free_results_array(results_ptr, path_ptrs.len());

    // 7. 推送最终结果事件
    sink.add(DecodeEvent::Result(decoded));

    Ok(())
  }
}

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
      ptr::null_mut(),
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