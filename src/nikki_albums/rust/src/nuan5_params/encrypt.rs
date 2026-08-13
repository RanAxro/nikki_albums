use flutter_rust_bridge::frb;
use super::decrypt::ffi::*;

// ============================================================
// FFI 绑定
// ============================================================
#[cfg(any(target_os = "windows", target_os = "macos"))]
#[allow(non_snake_case, dead_code)]
pub(super) mod ffi{
  use flutter_rust_bridge::frb;

  #[frb(ignore)]
  #[repr(u32)]
  #[derive(Clone, Copy, Debug, PartialEq, Eq)]
  pub enum EncryptionStatus{
    Success = 0,
    NullPointer = 1,
  }

  /// ========== Media ==========
  #[frb(ignore)]
  #[repr(C)]
  pub struct MediaEncryptionResult{
    pub status: u32,
    pub bytes: super::CBytes,
  }

  extern "C" {
    /// ========== Media ==========
    pub fn media_encode_camera_params_bytes(bytes: *const u8, bytes_len: usize) -> MediaEncryptionResult;
  }
}


#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum EncryptionError{
  Unknown = 0,
  NullPointer = 1,
}

impl EncryptionError{
  const fn from_u32(value: u32) -> Self{
    match value{
      1 => Self::NullPointer,
      _ => Self::Unknown,
    }
  }
}

macro_rules! impl_from_int{
  ($($t:ty),*) => {
    $(
      impl From<$t> for EncryptionError{
        fn from(value: $t) -> Self{
          Self::from_u32(value as u32)
        }
      }
    )*
  };
}

impl_from_int!(u8, u16, u32, u64, usize, i8, i16, i32, i64, isize);

/// ============================================================
/// Media
/// ============================================================

#[frb(sync)]
pub fn media_encode_camera_params_bytes(bytes: &[u8]) -> Result<Vec<u8>, EncryptionError>{
  let result = unsafe{
    ffi::media_encode_camera_params_bytes(
      bytes.as_ptr(),
      bytes.len(),
    )
  };

  if result.status == ffi::EncryptionStatus::Success as u32{
    Ok(result.bytes.into_vec())
  }else{
    Err(EncryptionError::from_u32(result.status))
  }
}
