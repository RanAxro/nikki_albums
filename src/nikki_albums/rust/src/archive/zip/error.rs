use crate::archive::error::ArchiveError;

impl From<zip::result::ZipError> for ArchiveError {
  fn from(error: zip::result::ZipError) -> Self {
    match error {
      zip::result::ZipError::Io(_) => Self::Io,
      zip::result::ZipError::InvalidArchive(_) => Self::InvalidArchive,
      zip::result::ZipError::UnsupportedArchive(zip::result::ZipError::PASSWORD_REQUIRED) => {
        Self::PasswordRequired
      }
      zip::result::ZipError::UnsupportedArchive(_) => Self::UnsupportedArchive,
      zip::result::ZipError::FileNotFound => Self::FileNotFound,
      zip::result::ZipError::InvalidPassword => Self::InvalidPassword,
      zip::result::ZipError::CompressionMethodNotSupported(_) => {
        Self::CompressionMethodNotSupported
      }
      _ => Self::Unknown,
    }
  }
}
