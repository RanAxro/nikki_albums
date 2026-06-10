
use std::fs;
use std::process::Command;


#[cfg(windows)]
fn main(){
  // 告诉 cargo 当 build.rs 变更时重新运行
  println!("cargo:rerun-if-changed=build.rs");

  // 如果 input 文件变更也重新运行
  println!("cargo:rerun-if-changed=bin/nikki_albums.exe");

  let status = Command::new("bin/ResourceHacker.exe")
    .args([
      "-open", r"..\build\windows\x64\runner\Release\nikki_albums.exe",
      "-save", r"target\temp\output.rc",
      "-action", "extract",
      "-mask", ",,",
      "-log", "CON",
    ])
    .status()
    .expect("Failed to execute ResourceHacker");

  if !status.success() {
    panic!("ResourceHacker failed with exit code: {:?}", status.code());
  }


  let mut res = winres::WindowsResource::new();
  res.set_resource_file(r"target\temp\output.rc");
  res.compile().unwrap();

  
  // clean cache
  fs::remove_file(r"bin\ResourceHacker.ini").expect(r"Fail delete bin\ResourceHacker.ini");
  fs::remove_dir_all(r"target\temp").expect(r"Fail delete target\temp");

}