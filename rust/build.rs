use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

fn main() {
  let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();
  let target_arch = env::var("CARGO_CFG_TARGET_ARCH").unwrap();
  let out_dir = env::var("OUT_DIR").unwrap();

  // 平台对应的库目录、编译必需文件、运行时文件
  let (lib_dir, compile_file, runtime_file) = match (target_os.as_str(), target_arch.as_str()) {
    ("windows", "x86_64") => (
      PathBuf::from("./lib/windows"),
      "nuan5_decryption.lib",
      Some("nuan5_decryption.dll"),
    ),
    ("windows", "x86") => (
      PathBuf::from("./lib/windows"),
      "nuan5_decryption.lib",
      Some("nuan5_decryption.dll"),
    ),
    ("macos", "aarch64") => (
      PathBuf::from("./lib/macos/aarch64"),
      "libnuan5_decryption.dylib",
      Some("libnuan5_decryption.dylib"),
    ),
    _ => (PathBuf::new(), "", None),
  };

  // 非支持平台直接返回
  if lib_dir.as_os_str().is_empty() {
    return;
  }

  let compile_path = lib_dir.join(compile_file);

  // ========================================================================
  // 1. 校验编译必需文件是否存在
  // ========================================================================
  if !lib_dir.exists() {
    panic!(
      "库目录不存在: {}\n\
      请在项目根目录创建对应目录并放入预编译库:\n\n\
      lib/\n\
      ├── windows/\n\
      │   ├── nuan5_decryption.lib   (Windows 编译必需)\n\
      │   └── nuan5_decryption.dll   (Windows 运行必需)\n\
      └── macos/\n\
          ├── x86_64/\n\
          │   └── libnuan5_decryption.dylib\n\
          └── aarch64/\n\
              └── libnuan5_decryption.dylib\n",
      lib_dir.display()
    );
  }
  if !compile_path.exists() {
    panic!(
      "编译必需文件不存在: {}\n\
      当前目标: {}-{}\n\
      需要文件: {}",
      compile_path.display(),
      target_os,
      target_arch,
      compile_file
    );
  }

  // ========================================================================
  // 2. 链接指令
  // ========================================================================
  println!("cargo:rustc-link-search=native={}", lib_dir.display());
  println!("cargo:rustc-link-lib=dylib=nuan5_decryption");

  // ========================================================================
  // 3. 平台特定处理
  // ========================================================================
  if target_os == "windows" {
    if let Some(rt) = runtime_file {
      let rt_path = lib_dir.join(rt);
      if rt_path.exists() {
        copy_to_target_dir(&rt_path, &out_dir);
      } else {
        println!("cargo:warning=运行时 DLL 不存在: {}", rt_path.display());
      }
    }
  } else if target_os == "macos" {
    // 设置 rpath，让 dyld 在可执行文件同级目录及 Frameworks 目录中搜索
    println!("cargo:rustc-link-arg=-Wl,-rpath,@loader_path");
    println!("cargo:rustc-link-arg=-Wl,-rpath,@loader_path/../Frameworks");

    if let Some(rt) = runtime_file {
      let rt_path = lib_dir.join(rt);
      copy_to_target_dir(&rt_path, &out_dir);
      check_macos_install_name(&rt_path);
    }
  }

  println!("cargo:rerun-if-changed={}", lib_dir.display());
}

/// 复制运行时库到 Rust target 目录（target/debug/ 或 target/release/）
fn copy_to_target_dir(src: &Path, out_dir: &str) {
  let out = PathBuf::from(out_dir);
  let target_dir = match out.parent().and_then(|p| p.parent()).and_then(|p| p.parent()) {
    Some(d) => d,
    None => {
      println!("cargo:warning=无法从 OUT_DIR 解析 target 目录: {}", out_dir);
      return;
    }
  };

  let dst = target_dir.join(src.file_name().unwrap());
  if should_copy(src, &dst) {
    match fs::copy(src, &dst) {
      Ok(_) => println!("cargo:warning=已复制运行时库: {} -> {}", src.display(), dst.display()),
      Err(e) => println!("cargo:warning=复制运行时库失败: {} -> {}: {}", src.display(), dst.display(), e),
    }
  }
}

/// 比较修改时间判断是否需要复制
fn should_copy(src: &Path, dst: &Path) -> bool {
  if !dst.exists() {
    return true;
  }
  match (fs::metadata(src).and_then(|m| m.modified()), fs::metadata(dst).and_then(|m| m.modified())) {
    (Ok(s), Ok(d)) => s > d,
    _ => true,
  }
}

/// 检查 macOS dylib 的 install_name。若为绝对路径，分发/运行时会出问题
fn check_macos_install_name(dylib: &Path) {
  let output = Command::new("otool")
    .args(["-D", dylib.to_str().unwrap_or_default()])
    .output();

  match output {
    Ok(out) if out.status.success() => {
      let stdout = String::from_utf8_lossy(&out.stdout);
      let lines: Vec<&str> = stdout.lines().collect();
      if lines.len() >= 2 {
        let install_name = lines[1].trim();
        if install_name.starts_with('/') {
          let fname = dylib.file_name().unwrap_or_default().to_string_lossy();
          println!("cargo:warning=检测到 dylib 的 install_name 为绝对路径: {}", install_name);
          println!("cargo:warning=这会导致 dyld 优先去该绝对路径加载，而不是 exe 同级目录");
          println!("cargo:warning=请在分发前执行以下命令修复:");
          println!("cargo:warning=  install_name_tool -id \"@rpath/{}\" {}", fname, dylib.display());
        }
      }
    }
    _ => {}
  }
}