use crate::archive::error::ArchiveError;
use crate::archive::file::ArchiveFileStat;

pub trait Archive {
  /// Open an existing archive.
  fn open(path: String, auto_create: bool) -> Result<Self, ArchiveError>
  where
    Self: Sized;

  /// Create a new, valid empty archive.
  fn create(path: String, overwrite: bool) -> Result<Self, ArchiveError>
  where
    Self: Sized;

  /// Open an existing archive and fail if it does not exist.
  fn open_existing(path: String) -> Result<Self, ArchiveError>
  where
    Self: Sized;

  fn path(&self) -> String;

  fn len(&self) -> usize;

  fn is_empty(&self) -> bool {
    self.len() == 0
  }

  fn comment(&self) -> String;

  /// Return every entry and its metadata in archive order.
  fn entries(&mut self) -> Result<Vec<ArchiveFileStat>, ArchiveError> {
    let count = self.len();
    let mut entries = Vec::with_capacity(count);
    for index in 0..count {
      entries.push(self.stat_by_index(index)?);
    }
    Ok(entries)
  }

  fn filenames(&self) -> Vec<String>;

  fn index_of(&self, name: &str) -> Option<usize>;

  fn contains(&self, name: &str) -> bool {
    self.index_of(name).is_some()
  }

  fn stat_by_index(&mut self, file_number: usize) -> Result<ArchiveFileStat, ArchiveError>;

  fn stat_by_name(&mut self, name: String) -> Result<ArchiveFileStat, ArchiveError> {
    let file_number = self.index_of(&name).ok_or(ArchiveError::FileNotFound)?;
    self.stat_by_index(file_number)
  }

  /// Read and decompress one entry by its archive index.
  fn read_by_index(&mut self, file_number: usize) -> Result<Vec<u8>, ArchiveError>;

  /// Read and decompress one encrypted entry by its archive index.
  fn read_by_index_with_password(
    &mut self,
    file_number: usize,
    password: String,
  ) -> Result<Vec<u8>, ArchiveError>;

  /// Read and decompress one entry by its exact archive name.
  fn read_by_name(&mut self, name: String) -> Result<Vec<u8>, ArchiveError> {
    let file_number = self.index_of(&name).ok_or(ArchiveError::FileNotFound)?;
    self.read_by_index(file_number)
  }

  /// Read and decompress one encrypted entry by its exact archive name.
  fn read_by_name_with_password(
    &mut self,
    name: String,
    password: String,
  ) -> Result<Vec<u8>, ArchiveError> {
    let file_number = self.index_of(&name).ok_or(ArchiveError::FileNotFound)?;
    self.read_by_index_with_password(file_number, password)
  }

  fn read_string_by_index(&mut self, file_number: usize) -> Result<String, ArchiveError> {
    Ok(String::from_utf8(self.read_by_index(file_number)?)?)
  }

  fn read_string_by_name(&mut self, name: String) -> Result<String, ArchiveError> {
    Ok(String::from_utf8(self.read_by_name(name)?)?)
  }

  /// Extract one entry to an exact file or directory path.
  fn extract_by_index(
    &mut self,
    file_number: usize,
    destination: String,
    overwrite: bool,
  ) -> Result<(), ArchiveError>;

  /// Extract one encrypted entry to an exact file or directory path.
  fn extract_by_index_with_password(
    &mut self,
    file_number: usize,
    destination: String,
    overwrite: bool,
    password: String,
  ) -> Result<(), ArchiveError>;

  /// Extract one entry to an exact file or directory path.
  fn extract_by_name(
    &mut self,
    name: String,
    destination: String,
    overwrite: bool,
  ) -> Result<(), ArchiveError> {
    let file_number = self.index_of(&name).ok_or(ArchiveError::FileNotFound)?;
    self.extract_by_index(file_number, destination, overwrite)
  }

  /// Extract one encrypted entry to an exact file or directory path.
  fn extract_by_name_with_password(
    &mut self,
    name: String,
    destination: String,
    overwrite: bool,
    password: String,
  ) -> Result<(), ArchiveError> {
    let file_number = self.index_of(&name).ok_or(ArchiveError::FileNotFound)?;
    self.extract_by_index_with_password(file_number, destination, overwrite, password)
  }

  /// Extract selected entries below `directory`, preserving their archive
  /// paths. Duplicate indices and destination conflicts are rejected.
  fn extract_multi_by_index(
    &mut self,
    file_numbers: Vec<usize>,
    directory: String,
    overwrite: bool,
  ) -> Result<(), ArchiveError>;

  /// Extract selected encrypted entries below `directory` by index.
  fn extract_multi_by_index_with_password(
    &mut self,
    file_numbers: Vec<usize>,
    directory: String,
    overwrite: bool,
    password: String,
  ) -> Result<(), ArchiveError>;

  /// Extract selected entries below `directory` by exact archive name.
  fn extract_multi_by_name(
    &mut self,
    names: Vec<String>,
    directory: String,
    overwrite: bool,
  ) -> Result<(), ArchiveError> {
    let mut file_numbers = Vec::with_capacity(names.len());
    for name in names {
      file_numbers.push(self.index_of(&name).ok_or(ArchiveError::FileNotFound)?);
    }
    self.extract_multi_by_index(file_numbers, directory, overwrite)
  }

  /// Extract selected encrypted entries below `directory` by exact name.
  fn extract_multi_by_name_with_password(
    &mut self,
    names: Vec<String>,
    directory: String,
    overwrite: bool,
    password: String,
  ) -> Result<(), ArchiveError> {
    let mut file_numbers = Vec::with_capacity(names.len());
    for name in names {
      file_numbers.push(self.index_of(&name).ok_or(ArchiveError::FileNotFound)?);
    }
    self.extract_multi_by_index_with_password(file_numbers, directory, overwrite, password)
  }

  /// Extract every entry below `directory`, preserving archive paths.
  ///
  /// Paths that escape the destination and unsafe symbolic links are
  /// rejected by the underlying ZIP reader. When `overwrite` is `false`,
  /// all destination conflicts are checked before any entry is written.
  /// Entry decompression is parallelized when possible.
  fn extract_all(&mut self, directory: String, overwrite: bool) -> Result<(), ArchiveError>;

  /// Extract every entry below `directory` with a password for encrypted
  /// entries. Symbolic-link entries are rejected by this variant, and entry
  /// decompression is parallelized when possible.
  fn extract_all_with_password(
    &mut self,
    directory: String,
    overwrite: bool,
    password: String,
  ) -> Result<(), ArchiveError>;
}
