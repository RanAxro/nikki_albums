import "dart:convert";
import "dart:io";

import "package:nikkialbums/api/system/system.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/api/path.dart";
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "dart:io";

import "dart:ffi" hide Size;
import "package:ffi/ffi.dart";
import "package:win32/win32.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";

/// 获取屏幕大小
(int, int) getWindowsScreenSize(){

  if(Platform.isWindows){
    try{
      return (GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));
    }catch(e){
      AppState.writeError("api.system.getScreenSize", e.toString());
      return (1920, 1080);
    }
  }
  return (0, 0);
}

/// 是否置顶window窗口
void doTopWindow(bool isTop, {int? hwnd}){
  if(!Platform.isWindows) return;

  try{
    final lib = DynamicLibrary.open("user32.dll");
    final setWindowPos = lib.lookupFunction<
        Void Function(Int hwnd, Int hwndInsertAfter, Int x, Int y, Int cx, Int cy, Int uFlags),
        void Function(int hwnd, int hwndInsertAfter, int x, int y, int cx, int cy, int uFlags)
    >("SetWindowPos");

    hwnd = hwnd ?? appWindow.handle;
    if(hwnd == null){
      AppState.writeError("api.system.doTopWindow", "Cannot get the hwnd");
      return;
    }
    setWindowPos(hwnd, isTop ? -1 : -2, 0, 0, 0, 0, 0x0001 | 0x0002);
  }catch(e){
    AppState.writeError("api.system.doTopWindow", e.toString());
  }
}


Path? getWindowsDesktopPath(){
  final userProfile = Platform.environment["USERPROFILE"];
  if(userProfile == null){
    return null;
  }
  return Path(userProfile) + "Desktop";
}


/// 返回  (剩余可用字节, 总字节, 空闲字节)  单位 Byte
(int, int, int) getDiskFreeSpaceEx(String path){
  if(Platform.isWindows){
    final pAvailable = calloc<Uint64>();
    final pTotal = calloc<Uint64>();
    final pFree = calloc<Uint64>();

    try{
      final int res = GetDiskFreeSpaceEx(path.toNativeUtf16(), pAvailable, pTotal, pFree);
      if(res == 0){
        final err = GetLastError();
        throw Exception("GetDiskFreeSpaceEx 失败, GetLastError=$err");
      }

      // 读 QuadPart 得到 64 位值
      final available = pAvailable.value;
      final total = pTotal.value;
      final free = pFree.value;

      return (available, total, free);
    }catch(e){
      AppState.writeError("api.system.getDiskFreeSpaceEx", e.toString());
      return (0, 0, 0);
    }finally{
      calloc.free(pAvailable);
      calloc.free(pTotal);
      calloc.free(pFree);
    }
  }
  return (0, 0, 0);
}


Future<bool> runWindowsCommandAsAdmin(List<String> commands) async{
  try{
    final joinedCommands = commands.join(" & ");
    print(joinedCommands);
    final ProcessResult result = await Process.run(
      "powershell",
      [
        "-Command",
        "Start-Process -Verb RunAs cmd.exe -Args '/c', '$joinedCommands'",
      ],
    );
    return result.exitCode == 0;
  }catch(e){
    AppState.writeError("api.system.runWindowsCommandAsAdmin", e.toString());
    return false;
  }
}


Future<int> compressInWindows(List<Path> files, Path to, [void Function(double)? onProcess]) async{
  if(files.isEmpty){
    onProcess?.call(1);
    return 0;
  }

  final Path temp = await getTempPath();
  final Path todoList = temp + "toBeCompressed.txt";
  final File todo = todoList.file;

  if(await todo.exists()) todo.delete();
  await todo.create();


  for(Path path in files){
    await todo.writeAsString("${path.path}\n", mode: FileMode.append);
  }


  final Path bin7z = getBin() + "7za.exe";

  final Process process = await Process.start(bin7z.path, ["a", "-tzip", "-mx=0", to.path, "@${todo.path}"]);

  int current = 0;
  final int all = files.length;

  process.stdout.transform(utf8.decoder).listen((String line){
    current += line.split("\n").length;
    onProcess?.call(current / all);
  });

  return await process.exitCode;
}

Future<int> decompressInWindows(Path file, Path to) async{
  final Path bin7z = getBin() + "7za.exe";

  final ProcessResult process = await Process.run(bin7z.path, ["x", file.path, "-o${to.path}", "-y"]);

  return process.exitCode;
}


Future<int> playBk2VideoInWindows(Path video) async{
  final Path binBinkPlay = getBin() + "binkplay.exe";

  final result = await Process.run(binBinkPlay.path, [video.path]);

  return result.exitCode;
}


Future<String> getWindowsUserName() async{
  final result = await Process.run("whoami", [], runInShell: true);
  if(result.exitCode != 0){
    // throw Exception("获取用户名失败: ${result.stderr}");
  }
  // whoami 输出格式一般是 “域\用户名” 或单独用户名，这里只取最后一段
  return result.stdout.toString().trim().split(r"\").last;
}