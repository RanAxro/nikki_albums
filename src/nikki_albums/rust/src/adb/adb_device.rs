use adb_client::{ADBDeviceExt, ADBListItemType};
use flutter_rust_bridge::frb;
use crate::adb::model::*;

pub trait ADBDevice{
  fn get_product_info(&self) -> Result<DeviceInfo, String>;
  fn file_stat(&self, path: &str) -> Result<Option<FileStat>, String>;
  fn list(&self, path: &str) -> Result<DirList, String>;
  fn read_file(&self, path: &str) -> Result<Vec<u8>, String>;
}

#[frb(opaque)]
pub struct ADBServerDevice{
  inner: adb_client::server_device::ADBServerDevice,
}

impl ADBServerDevice{
  pub(crate) fn new(server_device: adb_client::server_device::ADBServerDevice) -> Self{
    Self{ inner: server_device }
  }
}

impl ADBDevice for ADBServerDevice{
  fn get_product_info(&self) -> Result<DeviceInfo, String>{
    let mut model_out_buf = Vec::new();
    self.inner.shell_command(
      "getprop ro.product.model",
      Some(&mut model_out_buf),
      None,
    ).map_err(|e| e.to_string())?;

    let mut brand_out_buf = Vec::new();
    self.inner.shell_command(
      "getprop ro.product.brand",
      Some(&mut brand_out_buf),
      None,
    ).map_err(|e| e.to_string())?;

    let mut manufacturer_out_buf = Vec::new();
    self.inner.shell_command(
      "getprop ro.product.manufacturer",
      Some(&mut manufacturer_out_buf),
      None,
    ).map_err(|e| e.to_string())?;

    let mut name_out_buf = Vec::new();
    self.inner.shell_command(
      "getprop ro.product.name",
      Some(&mut name_out_buf),
      None,
    ).map_err(|e| e.to_string())?;

    let mut device_name_out_buf = Vec::new();
    self.inner.shell_command(
      "settings get global device_name",
      Some(&mut device_name_out_buf),
      None,
    ).map_err(|e| e.to_string())?;

    Ok(DeviceInfo{
      model: String::from_utf8_lossy(&model_out_buf).trim().to_string(),
      brand: String::from_utf8_lossy(&brand_out_buf).trim().to_string(),
      manufacturer: String::from_utf8_lossy(&manufacturer_out_buf).trim().to_string(),
      name: String::from_utf8_lossy(&name_out_buf).trim().to_string(),
      device_name: String::from_utf8_lossy(&device_name_out_buf).trim().to_string(),
    })
  }

  fn file_stat(&self, path: &str) -> Result<Option<FileStat>, String>{
    let raw_stat = self.inner.stat_extended(path).map_err(|e| e.to_string())?;
    Ok(raw_stat.map(|stat| FileStat{
      atime: stat.atime,
      mtime: stat.mtime,
      ctime: stat.ctime,
      perms: stat.perms,
      size: stat.size,
    }))
  }

  fn list(&self, path: &str) -> Result<DirList, String>{
    let raw_list = self.inner.list(path).map_err(|e| e.to_string())?;

    let mut res = DirList::default();
    for item in raw_list {
      match item{
        ADBListItemType::File(item) => res.filenames.push(item.name),
        ADBListItemType::Directory(item) => res.dir_names.push(item.name),
        ADBListItemType::Symlink(item) => res.link_names.push(item.name),
        _ => {},
      }
    }
    Ok(res)
  }

  fn read_file(&self, path: &str) -> Result<Vec<u8>, String>{
    let mut buf = Vec::new();
    self.inner.pull(path, &mut buf).map_err(|e| e.to_string())?;
    Ok(buf)
  }
}