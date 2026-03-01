export "windows_api.dart";

import "dart:convert";
import "dart:io";

import "system.dart";
import "package:nikkialbums/state.dart";
import "../path.dart";

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
      AppState.writeError("utils.system.getScreenSize", e.toString());
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
      AppState.writeError("utils.system.doTopWindow", "Cannot get the hwnd");
      return;
    }
    setWindowPos(hwnd, isTop ? -1 : -2, 0, 0, 0, 0, 0x0001 | 0x0002);
  }catch(e){
    AppState.writeError("utils.system.doTopWindow", e.toString());
  }
}

void toForeground(){
  appWindow.show();
  BringWindowToTop(appWindow.handle!);
  SetForegroundWindow(appWindow.handle!);
}



List<int> getAllWindowHandle(){
  final List<int> res = <int>[];

  int enumWindowsCallback(int hwnd, int lParam){
    res.add(hwnd);
    return 1;
  }

  final NativeCallable<WNDENUMPROC> callback = NativeCallable<WNDENUMPROC>.isolateLocal(
    enumWindowsCallback,
    exceptionalReturn: 0,
  );

  try{
    EnumWindows(callback.nativeFunction, 0);
  }finally{
    callback.close();
  }

  return res;
}


Path? getWindowsDesktopPath(){
  final userProfile = Platform.environment["USERPROFILE"];
  if(userProfile == null){
    return null;
  }
  return Path(userProfile) + "Desktop";
}


/// 返回  (剩余可用字节, 总字节, 空闲字节)  单位 Byte
(int, int, int) getDiskFreeSpaceEx(Path path){
  if(Platform.isWindows){
    final pAvailable = calloc<Uint64>();
    final pTotal = calloc<Uint64>();
    final pFree = calloc<Uint64>();

    try{
      final int res = GetDiskFreeSpaceEx(path.path.toNativeUtf16(), pAvailable, pTotal, pFree);
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
      AppState.writeError("utils.system.getDiskFreeSpaceEx", e.toString());
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
    // print(joinedCommands);
    final ProcessResult result = await Process.run(
      "powershell",
      [
        "-Command",
        "Start-Process -Verb RunAs cmd.exe -Args '/c', '$joinedCommands'",
      ],
    );
    return result.exitCode == 0;
  }catch(e){
    AppState.writeError("utils.system.runWindowsCommandAsAdmin", e.toString());
    return false;
  }
}


Future<int> compressInWindows(List<Path> paths, Path to, [void Function(double)? onProcess]) async{
  if(paths.isEmpty){
    onProcess?.call(1);
    return 0;
  }

  final Path temp = await getTempPath();
  final Path todoList = temp + "toBeCompressed.txt";
  final File todo = todoList.file;

  if(await todo.exists()) await todo.delete();
  await todo.create();

  if(await to.file.exists()) await to.file.delete();


  for(Path path in paths){
    await todo.writeAsString("${path.path}\n", mode: FileMode.append);
  }


  final Path bin7z = getBinPath() + "7za.exe";

  final Process process = await Process.start(bin7z.path, ["a", "-tzip", "-mx=0", to.path, "@${todo.path}"]);

  int current = 0;
  final int all = paths.length;

  process.stdout.transform(utf8.decoder).listen((String line){
    current += line.split("\n").length;
    onProcess?.call(current / all);
  });

  return await process.exitCode;
}

Future<int> decompressInWindows(Path zipPath, Path to) async{
  final Path bin7z = getBinPath() + "7za.exe";

  final ProcessResult process = await Process.run(bin7z.path, ["x", zipPath.path, "-o${to.path}", "-y"]);

  return process.exitCode;
}


Future<int> playBk2VideoInWindows(Path video) async{
  final Path binBinkPlay = getBinPath() + "binkplay.exe";

  final result = await Process.run(binBinkPlay.path, [video.path]);

  return result.exitCode;
}


Future<String?> getWindowsUserName() async{
  try{
    final result = await Process.run("whoami", [], runInShell: true);
    if(result.exitCode != 0){
      AppState.writeError("utils.system.windows.getWindowsUserName", "fail to get username");
      return null;
    }
    // whoami 输出格式一般是 “域\用户名” 或单独用户名，这里只取最后一段
    return result.stdout.toString().trim().split(r"\").last;
  }catch(e){
    return Platform.environment["USERNAME"] ?? Platform.environment["username"] ?? Platform.environment["UserName"];
  }
}


abstract class Explorer{
  static void open(){
    Process.run("explorer", []);
  }

  static void openFile(File file){
    Process.run("explorer", ["/select,", file.path]);
  }

  static void openDir(Directory dir){
    Process.run("explorer", [dir.path]);
  }
}