use std::net::{Ipv4Addr, SocketAddrV4};
use flutter_rust_bridge::frb;
use crate::adb::adb_device::ADBServerDevice;


#[frb(opaque)]
pub struct ADBServer{
  inner: adb_client::server::ADBServer,
}

impl ADBServer{
  #[frb(sync)]
  pub fn get_default() -> Self{
    ADBServer{ inner: adb_client::server::ADBServer::default() }
  }
  #[frb(sync)]
  pub fn get_with(ipv4: Option<String>, port: Option<u16>) -> Result<Self, String>{
    let ip_addr = match ipv4{
      Some(v) => v.parse().map_err(|_| String::from("ip解析错误"))?,
      None => Ipv4Addr::LOCALHOST,
    };

    let addr = SocketAddrV4::new(ip_addr, port.unwrap_or(5037));
    Ok(ADBServer{ inner: adb_client::server::ADBServer::new(addr) })
  }
}

impl ADBServer{
  #[frb]
  pub fn pair(&mut self, ipv4: &str, port: u16, code: &str) -> Result<(), String>{
    let ip_addr: Ipv4Addr = ipv4.parse().map_err(|_| String::from("ip解析错误"))?;
    let addr = SocketAddrV4::new(ip_addr, port);
    self.inner.pair(addr, code.to_string()).map_err(|_| String::from("配对失败"))?;
    Ok(())
  }

  #[frb]
  pub fn get_devices(&mut self) -> Result<Vec<ADBServerDevice>, String>{
    let devices = self.inner.devices().map_err(|_| String::from("获取设备失败"))?;

    let mut res = Vec::with_capacity(devices.len());
    for device in devices {
      let inner = adb_client::server_device::ADBServerDevice::new(device.identifier, self.inner.socket_addr());
      res.push(ADBServerDevice::new(inner));
    }

    Ok(res)
  }
}
