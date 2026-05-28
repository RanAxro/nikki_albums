use std::env;

fn main() {
  let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();
  let target_arch = env::var("CARGO_CFG_TARGET_ARCH").unwrap();

  // 平台对应的库目录
  let lib_dir = match (target_os.as_str(), target_arch.as_str()) {
    ("windows", "x86_64") => Some("./lib/windows"), // x64
    ("windows", "x86") => Some("./lib/windows"),    // x86
    _ => None,
  };

  if let Some(dir) = lib_dir {
    println!("cargo:rustc-link-search=native={}", dir);
    if target_os == "windows" {
      // Windows 下链接 .lib (导入库) 或 .dll
      println!("cargo:rustc-link-lib=dylib=nuan5_decryption");
    }
    println!("cargo:rerun-if-changed={}", dir);
  }
}