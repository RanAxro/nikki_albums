
use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;
use windows::{
  Win32::{
    Foundation::{CloseHandle, MAX_PATH},
    System::{
      ProcessStatus::{EnumProcesses, GetModuleFileNameExW},
      Threading::{
        OpenProcess, PROCESS_QUERY_INFORMATION, PROCESS_TERMINATE, TerminateProcess,
      },
    },
  },
};


pub(crate) fn get_current_exe_path() -> std::io::Result<PathBuf>{
  // let path = env::current_exe()?;

  // 解析符号链接，获取真实绝对路径
  // fs::canonicalize(&path)
  env::current_exe()
}

pub(crate) fn run_target_exe(exe: impl AsRef<Path>) -> std::io::Result<u32>{
  Command::new(exe.as_ref())
    .arg(format!("-sfx={}", &get_current_exe_path()?.display()))
    .args(env::args().skip(1))
    .spawn().map(|child| child.id())
}

pub(crate) fn get_process_path(pid: u32) -> Option<String>{
  unsafe{
    let handle = OpenProcess(PROCESS_QUERY_INFORMATION, false, pid).ok()?;
    let mut path = vec![0u16; MAX_PATH as usize];
    let len = GetModuleFileNameExW(Option::from(handle), None, &mut path);
    CloseHandle(handle).ok()?;

    if len == 0 {
      return None;
    }

    Some(String::from_utf16_lossy(&path[..len as usize]))
  }
}

pub(crate) fn find_pids_by_path(target: &PathBuf) -> Vec<u32>{
  let mut pids = vec![0u32; 1024];
  let mut needed = 0u32;

  unsafe{
    if EnumProcesses(pids.as_mut_ptr(), (pids.len() * 4) as u32, &mut needed).is_err() {
      return vec![];
    }
  }

  let count = needed as usize / 4;
  pids[..count]
    .iter()
    .filter(|&&pid| pid != 0)
    .filter(|&&pid| get_process_path(pid).map_or(false, |path| path.eq_ignore_ascii_case(&target.to_string_lossy().into_owned())))
    .copied()
    .collect()
}

pub(crate) fn kill_process(pid: u32) -> bool{
  unsafe{
    let handle = match OpenProcess(PROCESS_TERMINATE, false, pid) {
      Ok(h) => h,
      Err(_) => return false,
    };
    let result = TerminateProcess(handle, 1).is_ok();
    let _ = CloseHandle(handle);
    result
  }
}