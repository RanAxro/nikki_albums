
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod utils;

use std::env;
use rust_embed::Embed;
use std::fs::{self, File};
use std::io::Write;
use std::path::Path;
use std::process::exit;
use crate::utils::*;


const VERSION: usize = 15;


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

fn extract_lack(target_dir: impl AsRef<Path>) -> std::io::Result<()>{
  let target = target_dir.as_ref();
  fs::create_dir_all(target)?;

  let mut extracted = 0usize;
  let mut skipped = 0usize;

  for path in Release::iter() {
    let rel_path = path.as_ref();

    // 构建目标路径，保持深层目录结构
    let dest = target.join(rel_path);

    // 文件已存在则跳过
    if dest.exists() {
      skipped += 1;
      continue;
    }

    // 获取嵌入资源
    let file = Release::get(rel_path).ok_or_else(|| {
      std::io::Error::new(std::io::ErrorKind::NotFound, rel_path)
    })?;

    // 确保父目录存在
    if let Some(parent) = dest.parent() {
      fs::create_dir_all(parent)?;
    }

    // 写入文件
    let mut f = File::create(&dest)?;
    f.write_all(&file.data)?;

    extracted += 1;
    println!("extracted: {} ({} bytes)", dest.display(), file.data.len());
  }

  println!("done: {} extracted, {} skipped", extracted, skipped);
  Ok(())
}

/// 按需解压单个文件
#[warn(dead_code)]
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

fn run_release_exe(target_dir: impl AsRef<Path>, exe: impl AsRef<Path>) -> std::io::Result<u32>{
  extract_lack(target_dir)?;
  run_target_exe(exe)
}

enum State{
  Init,
  Verification,
  Extract,
  SaveVersionInfo,
  ForceRun,
  TryRun,
  Run,
  Error,
  Exit,
}

fn main(){
  let tmp = env::temp_dir().join("Nikki Albums");
  let exe = tmp.join("nikki_albums.exe");

  let mut state = State::Init;
  let mut error: Option<String> = None;

  loop{
    match state{
      State::Init => {
        // 强制启动
        // 会结束已有的进程后启动
        if env::args().any(|arg| arg == "-force") {
          state = State::ForceRun;
        }
        // 正常启动流程
        else{
          // 不存在已启动的程序
          if find_pids_by_path(&exe).is_empty() {
            state = State::Verification;
          }
          // 已存在已启动的程序
          // 这会将已存在的程序窗口提前
          else{
            state = State::Run;
          }
        }
      },
      State::Verification => {
        // 版本号正确, 尝试启动程序
        if verify_version(&tmp) {
          state = State::TryRun;
        }
        // 版本号不正确, 解压当前版本并运行
        else{
          state = State::Extract;
        }
      },
      State::Extract => {
        match extract_all(&tmp){
          // 解压成功, 保存当前版本号, 下次可无需解压直接启动
          Ok(_) => {
            state = State::SaveVersionInfo;
          },
          Err(e) => {
            error = Some(e.to_string());
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
      State::ForceRun => {
        let pids = find_pids_by_path(&exe);

        for pid in pids{
          kill_process(pid);
        }

        std::thread::sleep(std::time::Duration::from_millis(500));

        state = State::Verification;
      },
      State::TryRun => {
        match run_release_exe(&tmp, &exe){
          Ok(_) => {
            state = State::Exit;
          },
          // 尝试启动失败, 解压当前版本并运行
          Err(_) => {
            state = State::Extract;
          },
        }
      },
      State::Run => {
        match run_release_exe(&tmp, &exe){
          Ok(_) => {
            state = State::Exit;
          },
          Err(e) => {
            error = Some(e.to_string());
            state = State::Error;
          },
        }
      },
      State::Error => {
        // TODO show message box
        let _ = error;
        exit(1);
      },
      State::Exit => {
        exit(0);
      },
    }
  }
}