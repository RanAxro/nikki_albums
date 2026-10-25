use crate::archive::file::ArchiveFileStat;
use chrono::NaiveDate;
use std::fs::File;

impl ArchiveFileStat {
  pub(super) fn from_zip_file(file: &zip::read::ZipFile<'_, File>) -> Self {
    let (changed, modified, accessed) = archive_file_timestamps(file);

    Self {
      is_file: file.is_file(),
      is_dir: file.is_dir(),
      is_symlink: file.is_symlink(),
      is_encrypted: file.encrypted(),
      compression_method: compression_method_id(file.compression()),
      compressed_size: file.compressed_size(),
      size: file.size(),
      crc32: file.crc32(),
      unix_mode: file.unix_mode(),
      changed,
      modified,
      accessed,
    }
  }
}

pub(super) fn archive_file_timestamps(
  file: &zip::read::ZipFile<'_, File>,
) -> (Option<i64>, Option<i64>, Option<i64>) {
  let mut ntfs_modified = None;
  let mut ntfs_accessed = None;
  let mut ntfs_changed = None;
  let mut extended_modified = None;
  let mut extended_accessed = None;
  let mut extended_changed = None;

  for field in file.extra_data_fields() {
    match field {
      zip::ExtraField::Ntfs(ntfs) => {
        ntfs_modified = filetime_to_unix_seconds(ntfs.mtime());
        ntfs_accessed = filetime_to_unix_seconds(ntfs.atime());
        ntfs_changed = filetime_to_unix_seconds(ntfs.ctime());
      }
      zip::ExtraField::ExtendedTimestamp(timestamp) => {
        extended_modified = timestamp.mod_time().map(i64::from);
        extended_accessed = timestamp.ac_time().map(i64::from);
        extended_changed = timestamp.cr_time().map(i64::from);
      }
    }
  }

  (
    // The ZIP format calls this field creation time. Expose it through
    // `changed` because the common archive metadata has no `created` field.
    ntfs_changed.or(extended_changed),
    ntfs_modified
      .or(extended_modified)
      .or_else(|| dos_datetime_to_unix_seconds(file.last_modified())),
    ntfs_accessed.or(extended_accessed),
  )
}

fn dos_datetime_to_unix_seconds(date_time: Option<zip::DateTime>) -> Option<i64> {
  let date_time = date_time?;
  NaiveDate::from_ymd_opt(
    date_time.year() as i32,
    date_time.month() as u32,
    date_time.day() as u32,
  )
    .and_then(|date| {
      date.and_hms_opt(
        date_time.hour() as u32,
        date_time.minute() as u32,
        date_time.second() as u32,
      )
    })
    .map(|date_time| date_time.and_utc().timestamp())
}

fn filetime_to_unix_seconds(file_time: u64) -> Option<i64> {
  if file_time == 0 {
    return None;
  }
  const WINDOWS_TO_UNIX_EPOCH_SECONDS: i128 = 11_644_473_600;
  let seconds = i128::from(file_time / 10_000_000) - WINDOWS_TO_UNIX_EPOCH_SECONDS;
  i64::try_from(seconds).ok()
}

#[allow(deprecated)]
fn compression_method_id(method: zip::CompressionMethod) -> u16 {
  method.to_u16()
}
