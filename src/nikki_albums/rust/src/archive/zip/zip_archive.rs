use std::collections::HashMap;
use std::fs::{self, File, OpenOptions};
use std::io::{self, Read, Write};
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicU64, Ordering};
use std::time::{Duration, SystemTime};

use flutter_rust_bridge::frb;
use rayon::prelude::*;

use crate::archive::archive::Archive;
use crate::archive::error::ArchiveError;
use crate::archive::file::ArchiveFileStat;

use super::zip_file::archive_file_timestamps;

static TEMP_FILE_SEQUENCE: AtomicU64 = AtomicU64::new(0);

#[frb(opaque)]
pub struct ZipArchive {
  path: PathBuf,
  z_archive: zip::ZipArchive<File>,
}

struct PlannedEntry {
  index: usize,
  relative_path: PathBuf,
  is_dir: bool,
  is_symlink: bool,
  is_encrypted: bool,
}

impl ZipArchive {
  fn open_impl(path: String, auto_create: bool) -> Result<Self, ArchiveError> {
    let path = PathBuf::from(path);

    match fs::symlink_metadata(&path) {
      Ok(_) => {}
      Err(error) if error.kind() == io::ErrorKind::NotFound && auto_create => {
        create_empty_archive(&path)?;
      }
      Err(error) => return Err(error.into()),
    }

    let file = File::open(&path)?;
    let z_archive = zip::ZipArchive::new(file)?;
    Ok(Self { path, z_archive })
  }

  fn create_impl(path: String, overwrite: bool) -> Result<Self, ArchiveError> {
    let path = PathBuf::from(path);

    if let Some(parent) = path
      .parent()
      .filter(|parent| !parent.as_os_str().is_empty())
    {
      fs::create_dir_all(parent)?;
    }

    match fs::symlink_metadata(&path) {
      Ok(metadata) => {
        if metadata.is_dir() || !overwrite {
          return Err(ArchiveError::DestinationExists);
        }
        if metadata.file_type().is_symlink() {
          remove_existing_destination(&path, &metadata)?;
        }
      }
      Err(error) if error.kind() == io::ErrorKind::NotFound => {}
      Err(error) => return Err(error.into()),
    }

    let file = File::create(&path)?;
    zip::ZipWriter::new(file).finish()?;
    Self::open_existing_impl(path)
  }

  fn open_existing_impl(path: PathBuf) -> Result<Self, ArchiveError> {
    let file = File::open(&path)?;
    let z_archive = zip::ZipArchive::new(file)?;
    Ok(Self { path, z_archive })
  }

  fn preflight_entries(
    &mut self,
    file_numbers: &[usize],
    directory: &Path,
    overwrite: bool,
    allow_encrypted: bool,
  ) -> Result<Vec<PlannedEntry>, ArchiveError> {
    let destination_exists = match fs::symlink_metadata(directory) {
      Ok(_) => {
        if !fs::metadata(directory)?.is_dir() {
          return Err(ArchiveError::DestinationExists);
        }
        true
      }
      Err(error) if error.kind() == io::ErrorKind::NotFound => false,
      Err(error) => return Err(error.into()),
    };

    let canonical_destination = if destination_exists {
      Some(directory.canonicalize()?)
    } else {
      None
    };

    let mut plans = Vec::new();
    let mut planned_paths = HashMap::<String, bool>::new();

    for &index in file_numbers {
      let file = self.z_archive.by_index_raw(index)?;
      if file.encrypted() && !allow_encrypted {
        return Err(ArchiveError::PasswordRequired);
      }

      let relative_path = file
        .enclosed_name()
        .filter(|path| !path.as_os_str().is_empty())
        .ok_or(ArchiveError::InvalidEntryName)?;
      let key = path_key(&relative_path);

      if planned_paths.insert(key.clone(), file.is_dir()).is_some() {
        return Err(ArchiveError::EntryAlreadyExists);
      }

      if let Some(canonical_destination) = &canonical_destination {
        check_existing_path_chain(canonical_destination, directory, &relative_path)?;

        if let Ok(metadata) = fs::symlink_metadata(directory.join(&relative_path)) {
          let compatible_directory =
            file.is_dir() && metadata.is_dir() && !metadata.file_type().is_symlink();
          if !overwrite && !compatible_directory {
            return Err(ArchiveError::DestinationExists);
          }
          if !file.is_dir() && metadata.is_dir() {
            return Err(ArchiveError::DestinationExists);
          }
        }
      }

      plans.push(PlannedEntry {
        index,
        relative_path,
        is_dir: file.is_dir(),
        is_symlink: file.is_symlink(),
        is_encrypted: file.encrypted(),
      });
    }

    for plan in &plans {
      let mut parent = plan.relative_path.parent();
      while let Some(path) = parent {
        if !path.as_os_str().is_empty()
          && matches!(planned_paths.get(&path_key(path)), Some(false))
        {
          return Err(ArchiveError::EntryAlreadyExists);
        }
        parent = path.parent();
      }
    }

    Ok(plans)
  }

  fn prepare_extraction(
    &mut self,
    file_numbers: &[usize],
    directory: &Path,
    overwrite: bool,
    allow_encrypted: bool,
  ) -> Result<Vec<PlannedEntry>, ArchiveError> {
    self.preflight_entries(file_numbers, directory, overwrite, allow_encrypted)
  }

  fn extract_entry_to(
    file: &mut zip::read::ZipFile<'_, File>,
    destination: &Path,
    overwrite: bool,
  ) -> Result<(), ArchiveError> {
    if destination.as_os_str().is_empty() {
      return Err(ArchiveError::InvalidEntryName);
    }
    if file.is_symlink() {
      return Err(ArchiveError::InvalidEntryName);
    }

    if file.is_dir() {
      return create_destination_directory(destination, overwrite);
    }

    let parent = destination
      .parent()
      .filter(|parent| !parent.as_os_str().is_empty())
      .unwrap_or_else(|| Path::new("."));
    fs::create_dir_all(parent)?;

    if let Ok(metadata) = fs::symlink_metadata(destination) {
      if metadata.is_dir() {
        return Err(ArchiveError::DestinationExists);
      }
      if !overwrite {
        return Err(ArchiveError::DestinationExists);
      }
    }

    let (temporary_path, mut temporary_file) = create_temporary_file(parent)?;
    let extraction_result = (|| -> Result<(), ArchiveError> {
      let copied = io::copy(file, &mut temporary_file)?;
      if copied != file.size() {
        return Err(ArchiveError::InvalidArchive);
      }
      temporary_file.flush()?;

      let (_, modified, accessed) = archive_file_timestamps(file);
      let mut file_times = fs::FileTimes::new();
      if let Some(modified) = modified.and_then(system_time_from_unix) {
        file_times = file_times.set_modified(modified);
      }
      if let Some(accessed) = accessed.and_then(system_time_from_unix) {
        file_times = file_times.set_accessed(accessed);
      }
      temporary_file.set_times(file_times)?;
      drop(temporary_file);

      if let Ok(metadata) = fs::symlink_metadata(destination) {
        if metadata.is_dir() {
          return Err(ArchiveError::DestinationExists);
        }
        if !overwrite {
          return Err(ArchiveError::DestinationExists);
        }
        remove_existing_destination(destination, &metadata)?;
      }

      fs::rename(&temporary_path, destination)?;
      Ok(())
    })();

    if extraction_result.is_err() {
      let _ = fs::remove_file(&temporary_path);
    }
    extraction_result
  }

  fn extract_multi_impl(
    &mut self,
    file_numbers: Vec<usize>,
    directory: PathBuf,
    overwrite: bool,
    password: Option<String>,
  ) -> Result<(), ArchiveError> {
    if file_numbers.is_empty() {
      return Ok(());
    }

    let plans =
      self.prepare_extraction(&file_numbers, &directory, overwrite, password.is_some())?;
    if plans.iter().any(|plan| plan.is_symlink) {
      return Err(ArchiveError::InvalidEntryName);
    }
    if password.as_deref() == Some("") && plans.iter().any(|plan| plan.is_encrypted) {
      return Err(ArchiveError::PasswordRequired);
    }
    extract_plans_parallel(
      &self.path,
      &directory,
      plans,
      overwrite,
      password.as_deref(),
    )
  }
}

impl Archive for ZipArchive {
  fn open(path: String, auto_create: bool) -> Result<Self, ArchiveError> {
    Self::open_impl(path, auto_create)
  }

  fn create(path: String, overwrite: bool) -> Result<Self, ArchiveError> {
    Self::create_impl(path, overwrite)
  }

  fn open_existing(path: String) -> Result<Self, ArchiveError> {
    Self::open_existing_impl(PathBuf::from(path))
  }

  fn path(&self) -> String {
    self.path.to_string_lossy().into_owned()
  }

  fn len(&self) -> usize {
    self.z_archive.len()
  }

  fn comment(&self) -> String {
    String::from_utf8_lossy(self.z_archive.comment()).into_owned()
  }

  fn filenames(&self) -> Vec<String> {
    self.z_archive.file_names().map(str::to_owned).collect()
  }

  fn index_of(&self, name: &str) -> Option<usize> {
    self.z_archive.index_for_name(name)
  }

  fn stat_by_index(&mut self, file_number: usize) -> Result<ArchiveFileStat, ArchiveError> {
    let file = self.z_archive.by_index_raw(file_number)?;
    Ok(ArchiveFileStat::from_zip_file(&file))
  }

  fn read_by_index(&mut self, file_number: usize) -> Result<Vec<u8>, ArchiveError> {
    let mut file = self.z_archive.by_index(file_number)?;
    read_entry(&mut file)
  }

  fn read_by_index_with_password(
    &mut self,
    file_number: usize,
    password: String,
  ) -> Result<Vec<u8>, ArchiveError> {
    let mut file = self
      .z_archive
      .by_index_decrypt(file_number, password.as_bytes())?;
    read_entry(&mut file)
  }

  fn extract_by_index(
    &mut self,
    file_number: usize,
    destination: String,
    overwrite: bool,
  ) -> Result<(), ArchiveError> {
    let mut file = self.z_archive.by_index(file_number)?;
    Self::extract_entry_to(&mut file, Path::new(&destination), overwrite)
  }

  fn extract_by_index_with_password(
    &mut self,
    file_number: usize,
    destination: String,
    overwrite: bool,
    password: String,
  ) -> Result<(), ArchiveError> {
    let mut file = self
      .z_archive
      .by_index_decrypt(file_number, password.as_bytes())?;
    Self::extract_entry_to(&mut file, Path::new(&destination), overwrite)
  }

  fn extract_all(&mut self, directory: String, overwrite: bool) -> Result<(), ArchiveError> {
    let directory = PathBuf::from(directory);
    let file_numbers: Vec<_> = (0..self.len()).collect();
    let plans = self.prepare_extraction(&file_numbers, &directory, overwrite, false)?;

    fs::create_dir_all(&directory)?;
    if plans.iter().any(|plan| plan.is_symlink) {
      self.z_archive.extract(&directory)?;
      Ok(())
    } else {
      extract_plans_parallel(&self.path, &directory, plans, overwrite, None)
    }
  }

  fn extract_all_with_password(
    &mut self,
    directory: String,
    overwrite: bool,
    password: String,
  ) -> Result<(), ArchiveError> {
    let directory = PathBuf::from(directory);
    let file_numbers: Vec<_> = (0..self.len()).collect();
    let plans = self.prepare_extraction(&file_numbers, &directory, overwrite, true)?;
    if plans.iter().any(|plan| plan.is_symlink) {
      return Err(ArchiveError::InvalidEntryName);
    }
    if password.is_empty() && plans.iter().any(|plan| plan.is_encrypted) {
      return Err(ArchiveError::PasswordRequired);
    }
    extract_plans_parallel(
      &self.path,
      &directory,
      plans,
      overwrite,
      Some(password.as_str()),
    )
  }

  fn extract_multi_by_index(
    &mut self,
    file_numbers: Vec<usize>,
    directory: String,
    overwrite: bool,
  ) -> Result<(), ArchiveError> {
    self.extract_multi_impl(file_numbers, PathBuf::from(directory), overwrite, None)
  }

  fn extract_multi_by_index_with_password(
    &mut self,
    file_numbers: Vec<usize>,
    directory: String,
    overwrite: bool,
    password: String,
  ) -> Result<(), ArchiveError> {
    self.extract_multi_impl(
      file_numbers,
      PathBuf::from(directory),
      overwrite,
      Some(password),
    )
  }
}

fn create_empty_archive(path: &Path) -> Result<(), ArchiveError> {
  if let Some(parent) = path
    .parent()
    .filter(|parent| !parent.as_os_str().is_empty())
  {
    fs::create_dir_all(parent)?;
  }
  let file = File::create(path)?;
  zip::ZipWriter::new(file).finish()?;
  Ok(())
}

fn read_entry(file: &mut zip::read::ZipFile<'_, File>) -> Result<Vec<u8>, ArchiveError> {
  let mut data = Vec::new();
  file.read_to_end(&mut data)?;
  if data.len() as u64 != file.size() {
    return Err(ArchiveError::InvalidArchive);
  }
  Ok(data)
}

fn create_destination_directory(destination: &Path, overwrite: bool) -> Result<(), ArchiveError> {
  if let Ok(metadata) = fs::symlink_metadata(destination) {
    if metadata.is_dir() && !metadata.file_type().is_symlink() {
      return Ok(());
    }
    if !overwrite {
      return Err(ArchiveError::DestinationExists);
    }
    remove_existing_destination(destination, &metadata)?;
  }
  fs::create_dir_all(destination)?;
  Ok(())
}

fn remove_existing_destination(destination: &Path, metadata: &fs::Metadata) -> io::Result<()> {
  let is_directory = if metadata.file_type().is_symlink() {
    fs::metadata(destination)
      .map(|target| target.is_dir())
      .unwrap_or(false)
  } else {
    metadata.is_dir()
  };

  if is_directory {
    fs::remove_dir(destination)
  } else {
    fs::remove_file(destination)
  }
}

fn check_existing_path_chain(
  canonical_destination: &Path,
  extraction_root: &Path,
  relative_path: &Path,
) -> Result<(), ArchiveError> {
  let mut current = extraction_root.to_path_buf();
  let mut components = relative_path.components().peekable();

  while let Some(component) = components.next() {
    current.push(component);
    if components.peek().is_none() {
      break;
    }

    match fs::symlink_metadata(&current) {
      Ok(metadata) if metadata.file_type().is_symlink() => {
        let target = current.canonicalize()?;
        if !target.starts_with(canonical_destination) {
          return Err(ArchiveError::InvalidEntryName);
        }
      }
      Ok(metadata) if !metadata.is_dir() => {
        return Err(ArchiveError::DestinationExists);
      }
      Ok(_) => {}
      Err(error) if error.kind() == io::ErrorKind::NotFound => {}
      Err(error) => return Err(error.into()),
    }
  }

  Ok(())
}

fn create_temporary_file(parent: &Path) -> Result<(PathBuf, File), ArchiveError> {
  for _ in 0..128 {
    let sequence = TEMP_FILE_SEQUENCE.fetch_add(1, Ordering::Relaxed);
    let path = parent.join(format!(".nikki-zip-{}-{sequence}.tmp", std::process::id()));
    match OpenOptions::new().write(true).create_new(true).open(&path) {
      Ok(file) => return Ok((path, file)),
      Err(error) if error.kind() == io::ErrorKind::AlreadyExists => continue,
      Err(error) => return Err(error.into()),
    }
  }
  Err(ArchiveError::Io)
}

fn extract_plans_parallel(
  archive_path: &Path,
  directory: &Path,
  plans: Vec<PlannedEntry>,
  overwrite: bool,
  password: Option<&str>,
) -> Result<(), ArchiveError> {
  fs::create_dir_all(directory)?;
  if plans.is_empty() {
    return Ok(());
  }

  let chunk_size = plans.len().div_ceil(rayon::current_num_threads()).max(1);
  plans.par_chunks(chunk_size).try_for_each(|plans| {
    let mut archive = None;
    for plan in plans {
      extract_plan(
        archive_path,
        directory,
        plan,
        overwrite,
        password,
        &mut archive,
      )?;
    }
    Ok(())
  })
}

fn extract_plan(
  archive_path: &Path,
  directory: &Path,
  plan: &PlannedEntry,
  overwrite: bool,
  password: Option<&str>,
  archive: &mut Option<zip::ZipArchive<File>>,
) -> Result<(), ArchiveError> {
  let destination = directory.join(&plan.relative_path);
  if plan.is_dir {
    return create_destination_directory(&destination, overwrite);
  }
  if plan.is_symlink {
    return Err(ArchiveError::InvalidEntryName);
  }
  if plan.is_encrypted && password.is_none() {
    return Err(ArchiveError::PasswordRequired);
  }

  if archive.is_none() {
    *archive = Some(zip::ZipArchive::new(File::open(archive_path)?)?);
  }
  let archive = archive.as_mut().expect("archive was initialized");
  let mut entry = match password {
    Some(password) => archive.by_index_decrypt(plan.index, password.as_bytes())?,
    None => archive.by_index(plan.index)?,
  };
  ZipArchive::extract_entry_to(&mut entry, &destination, overwrite)
}

fn system_time_from_unix(seconds: i64) -> Option<SystemTime> {
  let duration = Duration::from_secs(seconds.unsigned_abs());
  if seconds >= 0 {
    SystemTime::UNIX_EPOCH.checked_add(duration)
  } else {
    SystemTime::UNIX_EPOCH.checked_sub(duration)
  }
}

fn path_key(path: &Path) -> String {
  let path = path.to_string_lossy();
  if cfg!(windows) {
    path.to_lowercase()
  } else {
    path.into_owned()
  }
}

#[cfg(test)]
mod tests {
  use super::*;
  use zip::write::SimpleFileOptions;

  struct TestDirectory(PathBuf);

  impl TestDirectory {
    fn new(name: &str) -> Self {
      let sequence = TEMP_FILE_SEQUENCE.fetch_add(1, Ordering::Relaxed);
      let path = std::env::temp_dir().join(format!(
        "nikki-albums-zip-{name}-{}-{sequence}",
        std::process::id()
      ));
      fs::create_dir_all(&path).unwrap();
      Self(path)
    }
  }

  impl Drop for TestDirectory {
    fn drop(&mut self) {
      let _ = fs::remove_dir_all(&self.0);
    }
  }

  fn write_test_archive(path: &Path, entries: &[(&str, &[u8])]) -> Result<(), ArchiveError> {
    let file = File::create(path)?;
    let mut writer = zip::ZipWriter::new(file);
    let options =
      SimpleFileOptions::default().compression_method(zip::CompressionMethod::Stored);

    for (name, contents) in entries {
      writer.start_file(*name, options)?;
      writer.write_all(contents)?;
    }
    writer.finish()?;
    Ok(())
  }

  #[test]
  fn reads_and_extracts_archive_entries() -> Result<(), ArchiveError> {
    let directory = TestDirectory::new("roundtrip");
    let archive_path = directory.0.join("archive.zip");
    let output_path = directory.0.join("output");

    write_test_archive(
      &archive_path,
      &[("folder/hello.txt", b"hello"), ("root.bin", &[0, 1, 2, 3])],
    )?;

    let mut archive = ZipArchive::open_existing(archive_path.to_string_lossy().into())?;
    assert_eq!(archive.len(), 2);
    assert_eq!(
      archive.filenames(),
      vec!["folder/hello.txt".to_owned(), "root.bin".to_owned()]
    );
    assert_eq!(
      archive.read_string_by_name("folder/hello.txt".to_owned())?,
      "hello"
    );
    assert_eq!(
      archive.read_by_name("root.bin".to_owned())?,
      vec![0, 1, 2, 3]
    );
    assert!(archive.stat_by_name("root.bin".to_owned())?.is_file);

    archive.extract_all(output_path.to_string_lossy().into(), false)?;
    assert_eq!(fs::read(output_path.join("folder/hello.txt"))?, b"hello");
    assert_eq!(fs::read(output_path.join("root.bin"))?, vec![0, 1, 2, 3]);
    Ok(())
  }

  #[test]
  fn refuses_existing_destinations_before_writing() -> Result<(), ArchiveError> {
    let directory = TestDirectory::new("overwrite");
    let archive_path = directory.0.join("archive.zip");
    let output_path = directory.0.join("output");

    write_test_archive(&archive_path, &[("new.txt", b"new contents")])?;
    fs::create_dir_all(&output_path)?;
    let target = output_path.join("new.txt");
    fs::write(&target, b"old contents")?;

    let mut archive = ZipArchive::open_existing(archive_path.to_string_lossy().into())?;
    assert_eq!(
      archive.extract_all(output_path.to_string_lossy().into(), false),
      Err(ArchiveError::DestinationExists)
    );
    assert_eq!(fs::read(&target)?, b"old contents");

    let exact_path = directory.0.join("exact.txt");
    fs::write(&exact_path, b"old")?;
    assert_eq!(
      archive.extract_by_name(
        "new.txt".to_owned(),
        exact_path.to_string_lossy().into(),
        false,
      ),
      Err(ArchiveError::DestinationExists)
    );
    assert_eq!(fs::read(&exact_path)?, b"old");

    archive.extract_by_name(
      "new.txt".to_owned(),
      exact_path.to_string_lossy().into(),
      true,
    )?;
    assert_eq!(fs::read(&exact_path)?, b"new contents");
    Ok(())
  }

  #[test]
  fn extracts_multiple_entries_by_index_and_name() -> Result<(), ArchiveError> {
    let directory = TestDirectory::new("multi");
    let archive_path = directory.0.join("archive.zip");

    write_test_archive(
      &archive_path,
      &[
        ("keep/a.txt", b"a"),
        ("skip.txt", b"skip"),
        ("keep/b.txt", b"b"),
      ],
    )?;

    let mut archive = ZipArchive::open_existing(archive_path.to_string_lossy().into())?;
    let by_index_output = directory.0.join("by-index");
    archive.extract_multi_by_index(
      vec![0, 2],
      by_index_output.to_string_lossy().into(),
      false,
    )?;
    assert_eq!(fs::read(by_index_output.join("keep/a.txt"))?, b"a");
    assert_eq!(fs::read(by_index_output.join("keep/b.txt"))?, b"b");
    assert!(!by_index_output.join("skip.txt").exists());

    let by_name_output = directory.0.join("by-name");
    archive.extract_multi_by_name(
      vec!["keep/b.txt".to_owned(), "keep/a.txt".to_owned()],
      by_name_output.to_string_lossy().into(),
      false,
    )?;
    assert_eq!(fs::read(by_name_output.join("keep/a.txt"))?, b"a");
    assert_eq!(fs::read(by_name_output.join("keep/b.txt"))?, b"b");

    let duplicate_output = directory.0.join("duplicate");
    assert_eq!(
      archive.extract_multi_by_index(
        vec![0, 0],
        duplicate_output.to_string_lossy().into(),
        false,
      ),
      Err(ArchiveError::EntryAlreadyExists)
    );
    assert!(!duplicate_output.exists());
    Ok(())
  }

  #[test]
  fn rejects_entries_that_escape_the_destination() -> Result<(), ArchiveError> {
    let directory = TestDirectory::new("traversal");
    let archive_path = directory.0.join("archive.zip");
    let output_path = directory.0.join("output");

    write_test_archive(&archive_path, &[("../escape.txt", b"blocked")])?;
    let mut archive = ZipArchive::open_existing(archive_path.to_string_lossy().into())?;

    assert_eq!(
      archive.extract_all(output_path.to_string_lossy().into(), true),
      Err(ArchiveError::InvalidEntryName)
    );
    assert!(!directory.0.join("escape.txt").exists());
    Ok(())
  }

  #[test]
  fn creates_and_opens_empty_archives() -> Result<(), ArchiveError> {
    let directory = TestDirectory::new("lifecycle");
    let archive_path = directory.0.join("nested/archive.zip");
    let path = archive_path.to_string_lossy().into_owned();

    assert_eq!(
      ZipArchive::open(path.clone(), false).err(),
      Some(ArchiveError::FileNotFound)
    );

    let archive = ZipArchive::open(path.clone(), true)?;
    assert!(archive.is_empty());
    assert_eq!(archive.path(), path);

    assert_eq!(
      ZipArchive::create(path.clone(), false).err(),
      Some(ArchiveError::DestinationExists)
    );
    let mut archive = ZipArchive::create(path, true)?;
    assert!(archive.is_empty());
    assert!(archive.entries()?.is_empty());
    Ok(())
  }

  #[test]
  fn reads_and_extracts_encrypted_entries_with_a_password() -> Result<(), ArchiveError> {
    let directory = TestDirectory::new("encrypted");
    let archive_path = directory.0.join("archive.zip");
    let output_path = directory.0.join("output");

    let file = File::create(&archive_path)?;
    let mut writer = zip::ZipWriter::new(file);
    let options = SimpleFileOptions::default()
      .compression_method(zip::CompressionMethod::Deflated)
      .with_aes_encryption(zip::AesMode::Aes256, "secret");
    writer.start_file("secret.txt", options)?;
    writer.write_all(b"classified")?;
    writer.start_file("secret-2.txt", options)?;
    writer.write_all(b"classified-2")?;
    writer.finish()?;

    let mut archive = ZipArchive::open_existing(archive_path.to_string_lossy().into())?;
    assert!(archive.stat_by_name("secret.txt".to_owned())?.is_encrypted);
    assert_eq!(
      archive.read_by_name("secret.txt".to_owned()),
      Err(ArchiveError::PasswordRequired)
    );
    assert_eq!(
      archive.read_by_name_with_password("secret.txt".to_owned(), "secret".to_owned(),)?,
      b"classified"
    );
    assert_eq!(
      archive.extract_all(output_path.to_string_lossy().into(), false),
      Err(ArchiveError::PasswordRequired)
    );
    archive.extract_all_with_password(
      output_path.to_string_lossy().into(),
      false,
      "secret".to_owned(),
    )?;
    assert_eq!(fs::read(output_path.join("secret.txt"))?, b"classified");

    let exact_path = directory.0.join("exact.txt");
    archive.extract_by_index_with_password(
      0,
      exact_path.to_string_lossy().into(),
      false,
      "secret".to_owned(),
    )?;
    assert_eq!(fs::read(exact_path)?, b"classified");

    let multi_output = directory.0.join("multi");
    archive.extract_multi_by_name_with_password(
      vec!["secret.txt".to_owned(), "secret-2.txt".to_owned()],
      multi_output.to_string_lossy().into(),
      false,
      "secret".to_owned(),
    )?;
    assert_eq!(fs::read(multi_output.join("secret.txt"))?, b"classified");
    assert_eq!(
      fs::read(multi_output.join("secret-2.txt"))?,
      b"classified-2"
    );
    Ok(())
  }

  #[test]
  fn reads_extended_zip_timestamps() -> Result<(), ArchiveError> {
    let directory = TestDirectory::new("timestamps");
    let archive_path = directory.0.join("archive.zip");
    let modified = 1_700_000_001_u32;
    let accessed = 1_700_000_002_u32;
    let created = 1_700_000_003_u32;
    let mut timestamp_data = Vec::with_capacity(13);
    timestamp_data.push(0b0000_0111);
    timestamp_data.extend_from_slice(&modified.to_le_bytes());
    timestamp_data.extend_from_slice(&accessed.to_le_bytes());
    timestamp_data.extend_from_slice(&created.to_le_bytes());

    let mut options = zip::write::FullFileOptions::default();
    options.add_extra_data(0x5455, timestamp_data, false)?;

    let file = File::create(&archive_path)?;
    let mut writer = zip::ZipWriter::new(file);
    writer.start_file("timestamps.txt", options)?;
    writer.write_all(b"timestamped")?;
    writer.finish()?;

    let mut archive = ZipArchive::open_existing(archive_path.to_string_lossy().into())?;
    let stat = archive.stat_by_name("timestamps.txt".to_owned())?;
    assert_eq!(stat.modified, Some(i64::from(modified)));
    assert_eq!(stat.accessed, Some(i64::from(accessed)));
    assert_eq!(stat.changed, Some(i64::from(created)));

    let output_path = directory.0.join("timestamped.txt");
    archive.extract_by_name(
      "timestamps.txt".to_owned(),
      output_path.to_string_lossy().into(),
      false,
    )?;
    let extracted_modified = fs::metadata(output_path)?
      .modified()?
      .duration_since(SystemTime::UNIX_EPOCH)
      .map_err(|_| ArchiveError::InvalidArchive)?;
    assert_eq!(extracted_modified.as_secs(), u64::from(modified));
    Ok(())
  }
}
