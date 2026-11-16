pub struct DeviceInfo{
  pub model: String,
  pub brand: String,
  pub manufacturer: String,
  pub name: String,
  pub device_name: String,
}

pub struct FileStat{
  pub atime: u32,
  pub mtime: u32,
  pub ctime: u32,
  pub perms: u64,
  pub size: u64,
}

#[derive(Default)]
pub struct DirList{
  pub filenames: Vec<String>,
  pub dir_names: Vec<String>,
  pub link_names: Vec<String>,
}