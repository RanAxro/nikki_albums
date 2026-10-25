use std::fmt;
use std::io;

use flutter_rust_bridge::frb;

/// The variants intentionally do not carry platform-specific error values so
/// they can be sent across the Flutter/Rust bridge directly.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[frb]
pub enum ArchiveError {
  Io,
  InvalidArchive,
  UnsupportedArchive,
  FileNotFound,
  InvalidPassword,
  PasswordRequired,
  CompressionMethodNotSupported,
  InvalidEntryName,
  EntryAlreadyExists,
  DestinationExists,
  InvalidUtf8,
  Unknown,
}

impl fmt::Display for ArchiveError {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    let message = match self {
      Self::Io => "an I/O error occurred",
      Self::InvalidArchive => "the file is not a valid archive",
      Self::UnsupportedArchive => "the archive uses an unsupported feature",
      Self::FileNotFound => "the archive entry was not found",
      Self::InvalidPassword => "the archive password is incorrect",
      Self::PasswordRequired => "the archive entry requires a password",
      Self::CompressionMethodNotSupported => {
        "the archive uses an unsupported compression method"
      }
      Self::InvalidEntryName => "the archive entry name is not safe to use",
      Self::EntryAlreadyExists => "an archive entry with that name already exists",
      Self::DestinationExists => "the extraction destination already exists",
      Self::InvalidUtf8 => "the archive entry is not valid UTF-8",
      Self::Unknown => "an unknown Archive error occurred",
    };
    f.write_str(message)
  }
}

impl std::error::Error for ArchiveError {}

impl From<io::Error> for ArchiveError {
  fn from(error: io::Error) -> Self {
    match error.kind() {
      io::ErrorKind::NotFound => Self::FileNotFound,
      _ => Self::Io,
    }
  }
}

impl From<std::string::FromUtf8Error> for ArchiveError {
  fn from(_: std::string::FromUtf8Error) -> Self {
    Self::InvalidUtf8
  }
}
