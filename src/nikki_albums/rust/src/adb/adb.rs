// use std::net::{IpAddr, Ipv4Addr, SocketAddr, SocketAddrV4};
// use adb_client::{ADBDeviceExt};
// use adb_client::server::ADBServer;
// use adb_client::tcp::ADBTcpDevice;
// use flutter_rust_bridge::frb;
// use crate::adb::adb_device::ADBServerDevice;
//
// #[frb]
// pub fn pair_device(ip: &str, port: &str, code: &str) -> Result<(), String> {
//   // 1. 解析 IP，使用库中定义的 AddrParseError 变体
//   let ip_addr: Ipv4Addr = ip.parse().map_err(|_| String::from("ip解析错误"))?;
//
//   // 2. 解析端口，使用库中定义的 ParseIntError 变体
//   let port_num: u16 = port.parse().map_err(|_| String::from("port解析错误"))?;
//
//   // 3. 构造 SocketAddrV4
//   let address = SocketAddrV4::new(ip_addr, port_num);
//
//   // 4. 创建 ADBServer 并执行配对
//   let mut server = ADBServer::default();
//   server.pair(address, code.to_string()).map_err(|_| String::from("配对失败"))?;
//
//   println!("配对成功: {}:{}", ip, port);
//   Ok(())
// }
//
// #[frb]
// pub fn adb_stat(
//   ip: &str,
//   connect_port: u16,
//   // command: &str,
//   path: &str,
// ) -> Result<String, String> {
//   let ip_addr: IpAddr = ip.parse().map_err(|_| String::from("ip解析错误"))?;
//   let address = SocketAddr::new(ip_addr, connect_port);
//
//   let device = ADBTcpDevice::new(address).map_err(|_| String::from("tcp错误"))?;
//   // device.shell_command(&command, Some(&mut std::io::stdout()), None).map_err(|_| String::from("shell命令执行失败"))?;
//   let info = device.stat(path)
//     .map(|s| s.to_string())
//     .map_err(|_| String::from("stat错误"))?;
//
//   Ok(info)
// }
//
// #[frb]
// pub fn ava_device() -> Result<(), String> {
//   // 连接到本地的 ADB Server（通常运行在 5037 端口）
//   let addr = SocketAddrV4::new(Ipv4Addr::LOCALHOST, 5037);
//   let mut server = ADBServer::new(addr);
//
//   // 获取简要设备列表
//   let devices = server.devices().map_err(|_| String::from("获取设备失败"))?;
//   println!("已连接设备数量: {}", devices.len());
//   for device in devices {
//     println!("设备: {:?}", device);
//   }
//
//   // 获取详细设备列表
//   let devices_long = server.devices_long().map_err(|_| String::from("获取详细设备失败"))?;
//   for device in devices_long {
//     println!("详细设备信息: {:?}", device);
//   }
//
//   Ok(())
// }
//
// pub fn get_adb_server_device() -> Result<Vec<ADBServerDevice>, String>{
//   let addr = SocketAddrV4::new(Ipv4Addr::LOCALHOST, 5037);
//   let mut server = ADBServer::new(addr);
//
//   let devices = server.devices().map_err(|_| String::from("获取设备失败"))?;
//
//   let mut res = Vec::with_capacity(devices.len());
//   for device in devices {
//     let inner = adb_client::server_device::ADBServerDevice::new(device.identifier, server.socket_addr());
//     res.push(ADBServerDevice::new(inner));
//   }
//
//   Ok(res)
// }
//
