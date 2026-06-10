

use rust_embed::Embed;
use std::fs::{self, File};
use std::io::Write;
use std::path::Path;
use std::process::{exit, Command};


const VERSION: usize = 1;


#[derive(Embed)]
#[folder = "..\\build\\windows\\x64\\runner\\Release\\"]
#[prefix = ""]
struct Release;

/// 按需解压所有文件到指定目录，保持原始目录结构
fn extract_all(target_dir: impl AsRef<Path>) -> std::io::Result<()>{
  let target = target_dir.as_ref();
  fs::create_dir_all(target)?;

  for path in Release::iter() {
    let rel_path = path.as_ref();
    let file = Release::get(rel_path).ok_or_else(||{
      std::io::Error::new(std::io::ErrorKind::NotFound, rel_path)
    })?;

    // 构建目标路径，保持深层目录结构
    let dest = target.join(rel_path);
    if let Some(parent) = dest.parent() {
      fs::create_dir_all(parent)?;
    }

    // file.data 已经是解压后的内容
    let mut f = File::create(&dest)?;
    f.write_all(&file.data)?;
    println!("extracted: {} ({} bytes)", dest.display(), file.data.len());
  }

  Ok(())
}

/// 按需解压单个文件
fn extract_one(rel_path: &str, target_dir: impl AsRef<Path>) -> std::io::Result<()>{
  let file = Release::get(rel_path).ok_or_else(||{
    std::io::Error::new(std::io::ErrorKind::NotFound, rel_path)
  })?;

  let dest = target_dir.as_ref().join(rel_path);
  if let Some(parent) = dest.parent() {
    fs::create_dir_all(parent)?;
  }

  File::create(&dest)?.write_all(&file.data)?;
  Ok(())
}

fn run_exe(exe: impl AsRef<Path>) -> std::io::Result<u32>{
  Command::new(exe.as_ref()).spawn().map(|child| child.id())

  // match Command::new(exe.as_ref()).spawn(){
  //   Ok(child) => {
  //     println!("进程已创建，PID: {:?}", child.id());
  //     // 此时进程存在，但可能立刻崩溃
  //     true
  //   }
  //   Err(e) => {
  //     eprintln!("启动失败: {}", e);
  //     false
  //   }
  // }
}

fn verify_version(target_dir: impl AsRef<Path>) -> bool{
  let version_file = target_dir.as_ref().join("version.txt");

  if let Ok(file_string) = fs::read_to_string(&version_file) {
    let version = file_string.trim().to_string();

    if version == VERSION.to_string() {
      return true;
    }
  }

  false
}

fn create_version_file(target_dir: impl AsRef<Path>) -> std::io::Result<()>{
  let version_file = target_dir.as_ref().join("version.txt");

  fs::write(version_file, VERSION.to_string())
}


enum State{
  Init,
  Extract,
  SaveVersionInfo,
  TryRun,
  Run,
  Error,
  Exit,
}

fn main() {
  let tmp = std::env::temp_dir().join("myapp_extracted");
  let exe = tmp.join("nikki_albums.exe");

  let mut state = State::Init;

  loop{
    match state{
      State::Init => {
        if verify_version(&tmp) {
          state = State::TryRun;
        }else{
          state = State::Extract;
        }
      },
      State::Extract => {
        match extract_all(&tmp){
          Ok(_) => {
            state = State::SaveVersionInfo;
          },
          Err(_) => {
            state = State::Error;
          },
        }
      },
      State::SaveVersionInfo => {
        match create_version_file(&tmp){
          _ => {
            state = State::Run;
          }
        }
      },
      State::TryRun => {
        match run_exe(&exe){
          Ok(_) => {
            state = State::Exit;
          },
          Err(_) => {
            state = State::Extract;
          },
        }
      },
      State::Run => {
        match run_exe(&exe){
          Ok(_) => {
            state = State::Exit;
          },
          Err(_) => {
            state = State::Error;
          },
        }
      },
      State::Error => {
        exit(1);
      },
      State::Exit => {
        exit(0);
      },
    }
  }
}