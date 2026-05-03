// fn main(){
//   println!(r"cargo:rustc-link-search=native=./lib/windows");
//   println!("cargo:rustc-link-lib=dylib=nuan5_decryption");
// }

use std::env;

fn main() {
  let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();
  let target_arch = env::var("CARGO_CFG_TARGET_ARCH").unwrap();
  let out_dir = env::var("OUT_DIR").unwrap();

  // 平台对应的库目录
  let lib_dir = match (target_os.as_str(), target_arch.as_str()) {
    ("windows", "x86_64") => "./lib/windows", // x64
    ("windows", "x86") => "./lib/windows",    // x86
    ("linux", "x86_64") => "./lib/linux",     // x64
    ("linux", "aarch64") => "./lib/linux",    // arm64
    ("macos", "x86_64") => "./lib/macos",     // x64
    ("macos", "aarch64") => "./lib/macos",    // arm64
    (os, arch) => panic!("不支持的平台: {}-{}", os, arch),
  };

  println!("cargo:rustc-link-search=native={}", lib_dir);

  // 根据平台选择库类型
  if target_os == "windows" {
    // Windows 下链接 .lib (导入库) 或 .dll
    println!("cargo:rustc-link-lib=dylib=nuan5_decryption");
  } else if target_os == "macos" {
    // macOS 动态库
    println!("cargo:rustc-link-lib=dylib=nuan5_decryption");
    // 如果需要 rpath
    println!("cargo:rustc-link-arg=-Wl,-rpath,@loader_path/{}", lib_dir);
  } else {
    // Linux 下通常静态链接更稳妥
    println!("cargo:rustc-link-lib=static=nuan5_decryption");
  }

  // 告诉 Cargo 当 lib 目录变化时重新构建
  println!("cargo:rerun-if-changed={}", lib_dir);
}