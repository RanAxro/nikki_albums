use flutter_rust_bridge::frb;

#[frb]
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ArchiveFileStat {
    pub is_file: bool,
    pub is_dir: bool,
    pub is_symlink: bool,
    pub is_encrypted: bool,
    pub compression_method: u16,
    pub compressed_size: u64,
    pub size: u64,
    pub crc32: u32,
    pub unix_mode: Option<u32>,
    /// ZIP creation timestamp (or the best supported equivalent), exposed as
    /// `changed` because the archive model has no separate `created` field.
    pub changed: Option<i64>,
    pub modified: Option<i64>,
    pub accessed: Option<i64>,
}

#[frb]
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ArchiveFileData {
    pub compression_method: u16,
    pub unix_mode: Option<u32>,
    pub changed: Option<i64>,
    pub modified: Option<i64>,
    pub accessed: Option<i64>,
}
