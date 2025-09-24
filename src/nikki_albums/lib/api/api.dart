import "dart:convert";
import "dart:ffi";
import "dart:io";
import "dart:ui" as ui;

import "../constants.dart";
import "dart:typed_data";
import "dart:async";
import "package:flutter/material.dart";

import "package:ffi/ffi.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";
import "package:path_provider/path_provider.dart";
import "package:http/http.dart" as http;


//user32
class user32Api{
  static final bool _isWindows = Platform.isWindows;

  user32Api._();

  static late final DynamicLibrary? _user32 = (){
    if(_isWindows) return DynamicLibrary.open("user32.dll");
    return null;
  }();

  //EnumWindows
  static late final int Function(Pointer<NativeFunction<Bool Function(IntPtr, IntPtr)>>, int)? enumWindows = (){
    if(_isWindows){
      return _user32!.lookupFunction<
        Int32 Function(Pointer<NativeFunction<Bool Function(IntPtr, IntPtr)>>, IntPtr),
        int Function(Pointer<NativeFunction<Bool Function(IntPtr, IntPtr)>>, int)
      >("EnumWindows");
    }
    return null;
  }();

  //GetWindowThreadProcessId
  static late final int Function(int, Pointer<Uint32>)? getWindowThreadProcessId = (){
    if(_isWindows){
      return _user32!.lookupFunction<
        Uint32 Function(IntPtr, Pointer<Uint32>),
        int Function(int, Pointer<Uint32>)
      >("GetWindowThreadProcessId");
    }
    return null;
  }();

  //GetWindowThreadProcessId
  static late final int Function(int nIndex)? getSystemMetrics = (){
    if(_isWindows){
      return _user32!.lookupFunction<Int32 Function(Int32 nIndex), int Function(int nIndex)>("GetSystemMetrics");
    }
    return null;
  }();

  //IsWindowVisible
  static late final int Function(int)? isWindowVisible = (){
    if(_isWindows){
      return _user32!.lookupFunction<Int32 Function(IntPtr),int Function(int)>("IsWindowVisible");
    }
    return null;
  }();

}

// user32.dll
class advapi32Api{
  static final bool _isWindows = Platform.isWindows;

  advapi32Api._();

  static late final DynamicLibrary? _advapi32 = (){
    if(_isWindows) return DynamicLibrary.open("advapi32.dll");
  }();

  // EnumWindows 函数指针
  // static late final int Function(Pointer<NativeFunction<Bool Function(int, Pointer<Utf16>, int, int, Pointer<IntPtr>)? regOpenKeyExW = (){
  //   if(_isWindows){
  //     return _advapi32!.lookupFunction<Int32 Function(IntPtr, Pointer<Utf16>, Int32, Int32, Pointer<IntPtr>),
  //         int Function(int, Pointer<Utf16>, int, int, Pointer<IntPtr>)>("RegOpenKeyExW");
  //   }
  // }();

}



// Kernel32.dll
class kernel32Api {
  static final bool _isWindows = Platform.isWindows;

  kernel32Api._();

  static late final DynamicLibrary? _kernel32 = (){
    if (_isWindows) return DynamicLibrary.open("kernel32.dll");
    return null;
  }();

  static late final Pointer<Void> Function(int dwFlags, int th32ProcessID)? createToolhelp32Snapshot = (){
    if(_isWindows){
      return _kernel32!.lookupFunction<
          Pointer<Void> Function(Uint32 dwFlags, Uint32 th32ProcessID),
          Pointer<Void> Function(int dwFlags, int th32ProcessID)
      >('CreateToolhelp32Snapshot');
    }
    return null;
  }();

  // BOOL Process32FirstW(HANDLE hSnapshot, LPPROCESSENTRY32W lppe);
  static late final int Function(Pointer<Void> hSnapshot, Pointer<Void> lppe)? process32FirstW = (){
    if(_isWindows){
      return _kernel32!.lookupFunction<
          Int32 Function(Pointer<Void> hSnapshot, Pointer<Void> lppe),
          int Function(Pointer<Void> hSnapshot, Pointer<Void> lppe)
      >('Process32FirstW');
    }
    return null;
  }();

  // BOOL Process32NextW(HANDLE hSnapshot, LPPROCESSENTRY32W lppe);
  static late final int Function(Pointer<Void> hSnapshot, Pointer<Void> lppe)? process32NextW = (){
    if(_isWindows){
      return _kernel32!.lookupFunction<
          Int32 Function(Pointer<Void> hSnapshot, Pointer<Void> lppe),
          int Function(Pointer<Void> hSnapshot, Pointer<Void> lppe)
      >('Process32NextW');
    }
    return null;
  }();

  // HANDLE OpenProcess(DWORD dwDesiredAccess, BOOL bInheritHandle, DWORD dwProcessId);
  static late final Pointer<Void> Function(int dwDesiredAccess, int bInheritHandle, int dwProcessId)? openProcess = (){
    if(_isWindows){
      return _kernel32!.lookupFunction<
          Pointer<Void> Function(Uint32 dwDesiredAccess, Int32 bInheritHandle, Uint32 dwProcessId),
          Pointer<Void> Function(int dwDesiredAccess, int bInheritHandle, int dwProcessId)
      >('OpenProcess');
    }
    return null;
  }();

  // BOOL CloseHandle(HANDLE hObject);
  static late final int Function(Pointer<Void> hObject)? closeHandle = (){
    if(_isWindows){
      return _kernel32!.lookupFunction<
          Int32 Function(Pointer<Void> hObject),
          int Function(Pointer<Void> hObject)
      >('CloseHandle');
    }
    return null;
  }();

  // DWORD GetLastError();
  static late final int Function()? getLastError = (){
    if(_isWindows){
      return _kernel32!.lookupFunction<
          Uint32 Function(),
          int Function()
      >('GetLastError');
    }
    return null;
  }();
}

//psapi.dll
class psapi{
  static final bool _isWindows = Platform.isWindows;

  psapi._(); // 私有构造函数，防止实例化

  static late final DynamicLibrary? _psapi = (){
    if(_isWindows)return DynamicLibrary.open("psapi.dll");
    return null; // 非 Windows 平台返回 null
  }();

  // DWORD GetModuleFileNameExW(HANDLE hProcess, HMODULE hModule, LPWSTR lpFilename, DWORD nSize);
  static late final int Function(Pointer<Void> hProcess, Pointer<Void> hModule, Pointer<Utf16> lpFilename, int nSize)? GetModuleFileNameExW = (){
    if(_isWindows){
      return _psapi!.lookupFunction<
          Uint32 Function(Pointer<Void> hProcess, Pointer<Void> hModule, Pointer<Utf16> lpFilename, Uint32 nSize),
          int Function(Pointer<Void> hProcess, Pointer<Void> hModule, Pointer<Utf16> lpFilename, int nSize)
      >('GetModuleFileNameExW');
    }
    return null;
  }();
}







/// 读取注册表
/// 若注册表不存在则返回 null
String? readRegistry(int hive, String keyPath, String valueName){
  if(!Platform.isWindows) return null;

  final adv = DynamicLibrary.open("advapi32.dll");
  final open = adv.lookupFunction<Int32 Function(IntPtr, Pointer<Utf16>, Int32, Int32, Pointer<IntPtr>),
      int Function(int, Pointer<Utf16>, int, int, Pointer<IntPtr>)>("RegOpenKeyExW");
  final query = adv.lookupFunction<Int32 Function(IntPtr, Pointer<Utf16>, Pointer<Int32>, Pointer<Int32>,
          Pointer<Uint8>, Pointer<Int32>), int Function(int, Pointer<Utf16>, Pointer<Int32>, Pointer<Int32>,
          Pointer<Uint8>, Pointer<Int32>)>("RegQueryValueExW");
  final close = adv.lookupFunction<Int32 Function(IntPtr), int Function(int)>("RegCloseKey");

  final hKey = calloc<IntPtr>();
  try{
    if(open(hive, keyPath.toNativeUtf16(), 0, 0x20019, hKey) != 0) return null;

    final sz = calloc<Int32>();
    if(query(hKey.value, valueName.toNativeUtf16(), nullptr, nullptr, nullptr, sz) != 0){
      return null;
    }

    final buf = calloc<Uint8>(sz.value);
    if(query(hKey.value, valueName.toNativeUtf16(), nullptr, nullptr, buf, sz) != 0){
      return null;
    }

    return buf.cast<Utf16>().toDartString().trim();
  }finally{
    close(hKey.value);
    calloc.free(hKey);
  }
}

/// 获取屏幕像素大小
(int, int) getScreenSize(){
  if(Platform.isWindows){
    try{
      final lib = DynamicLibrary.open("user32.dll");
      final metrics = lib.lookupFunction<Int32 Function(Int32 nIndex), int Function(int nIndex)>("GetSystemMetrics");
      final width = metrics(0);
      final height = metrics(1);
      return (width, height);
    }on ArgumentError catch(_){
      stderr.writeln("error: Cannot find the system files 'user32.dll'");
      return defaultWindowsScreenSize;
    }
  }else if(Platform.isAndroid){
    final view = ui.PlatformDispatcher.instance.views.firstOrNull ?? ui.PlatformDispatcher.instance.implicitView;
    if(view != null){
      final size = view.physicalSize;
      return (size.width.toInt(), size.height.toInt());
    }else{
      return defaultAndroidScreenSize;
    }
  }
  return (0, 0);
}


/// 是否置顶window窗口
void doTopWindow(bool isTop){
  if(!Platform.isWindows){
    writeErrorLog("api.doTopWindow : Cannot top a non-Windows window");
  }else{
    final lib = DynamicLibrary.open("user32.dll");
    final setWindowPos = lib.lookupFunction<
      Void Function(Int hwnd, Int hwndInsertAfter, Int x, Int y, Int cx, Int cy, Int uFlags),
      void Function(int hwnd, int hwndInsertAfter, int x, int y, int cx, int cy, int uFlags)
    >("SetWindowPos");
    final hwnd = appWindow.handle;
    if(hwnd == null){
      writeErrorLog("api.doTopWindow : Cannot get the hwnd");
      return;
    }
    setWindowPos(hwnd, isTop ? -1 : -2, 0, 0, 0, 0, 0x0001 | 0x0002);
  }
}

/// 验证文件是否属于InfinityNikki
/// 若是，返回根目录，否则返回null
Future<String?> verifyINFile(String path) async{
  if(Platform.isWindows){
    const keys = {
      "launcher.exe": 1,  //启动器, 位于根目录
      "uninst.exe": 1,  //删除, 位于根目录
      "xstarter.exe": 2,  //启动器, 位于启动器根目录
      "InfinityNikki.exe": 2,  //游戏, 位于游戏根目录
    };
    final File file = File(path);
    //检查文件是否存在
    if(!await file.exists()){
      return null;
    }
    //截取文件名
    String name = path.split(r"\").last;
    //验证失败, 返回null
    if(!keys.containsKey(name)) return null;

    return extractPath(path, keys[name]!);

  }else if(Platform.isAndroid){

  }
}


/// 获取 InfinityNikki 根目录
/// 返回 [{"source": "...", "path": "..."}, ...]
Future<List<Map<String, String>>> getINDirs() async{
  final res = <Map<String, String>>[];
  if(Platform.isWindows){
    final src = <String>{};  // 记录已处理的 source

    for(final (source, hive, subKey, valueName, addition) in INRegistryPaths){
      if(src.contains(source)) continue;
      src.add(source);

      final path = readRegistry(hive, subKey, valueName);  //读取注册表上的游戏根目录
      if(path == null || path.isEmpty) continue;   // path 为 null 或空直接跳过

      final dir = FileSystemEntity.typeSync(path) == FileSystemEntityType.file
        ? path.substring(0, path.lastIndexOf(r"\"))
        : path;

      bool isExistDir = await Directory(INGameDir.replaceAll(r"$root$", "$dir$addition")).exists();

      if(!isExistDir) continue;  //游戏目录不存在则跳过

      res.add({"source": source, "rootPath": "$dir$addition"});
    }
  }else if(Platform.isAndroid){

  }
  return res;
}

/// 获取account
/// 接收[{"source": "...", "path": "..."}, ...]
Future<List> getINAccountList({List? targetDirs, String pre = ""}) async{
  final accountList = [];
  final dirs = targetDirs ?? await getINDirs();
  if(Platform.isWindows){
    for(var dir in dirs){
      final List<String> uidList = [];

      //通过 $root$\InfinityNikki\X6Game\Saved\DataBase 查找uid
      //获取 $root$\InfinityNikki\X6Game\Saved\DataBase 目录对象
      Directory dirPath = Directory(dir["rootPath"]! + r"\InfinityNikki\X6Game\Saved\DataBase");
      if(! await dirPath.exists()) continue;
      //获取 db文件列表对象
      List<FileSystemEntity> dbs = await dirPath.list(recursive: false).toList();
      dbs.forEach((db){
        //截取uid 格式: UserDB[uid].db
        Match? match = RegExp(r"\[(\d+)\]").firstMatch(db.path.split(r"\").last);
        if(match != null && match.groupCount >= 1) uidList.add(match.group(1)!);
      });

      //通过 INFolderPaths["Windows"][finder] 查找uid
      const finderList = [
        "CustomAvatar",
        "CustomCard",
        "DIY",
        "GamePlayPhotos",
      ];

      for(var finder in finderList){
        //获取完整路径
        String path = INFolderPaths["Windows"]![finder]!;
        //获取$uid$之前的路径
        int uidIndex = path.indexOf(r"$uid$");
        if(uidIndex != -1) path = path.substring(0, uidIndex);
        path = path.replaceAll(r"$root$", dir["rootPath"]!);

        //获取uid文件列表对象
        List<FileSystemEntity> uids = await Directory(path).list(recursive: false).toList();
        uids.forEach((uidFile){
          //截取uid
          String uid = uidFile.path.split(r"\").last;
          //去重并且判断是否为7-11位数字格式
          if(!uidList.contains(uid) && RegExp(r"^\d{7,11}$").hasMatch(uid)) uidList.add(uid);
        });
      }

      accountList.add({"source": dir["source"] + pre, "rootPath": dir["rootPath"], "uidList": uidList});
    }

  }else if(Platform.isAndroid){

  }
  return accountList;
}


/// 按文件名前缀 `yyyy_MM_dd_HH_mm_ss` 排序
/// [isDesc] 为 false 升序（默认），true 降序；格式错误文件沉底
List sortByTimeName(List src, {bool isDesc = false}){
  final ok = [], fail = [];

  DateTime? tryParseTime(String name){
    if(name.length < 19) return null;
    final parts = name.substring(0, 19).split("_");
    if(parts.length != 6) return null;
    try{
      return DateTime(
        int.parse(parts[0]), // 年
        int.parse(parts[1]), // 月
        int.parse(parts[2]), // 日
        int.parse(parts[3]), // 时
        int.parse(parts[4]), // 分
        int.parse(parts[5]), // 秒
      );
    }catch(_){
      return null;
    }
  }

  for(final f in src){
    final n = f.uri.pathSegments.last;
    if(tryParseTime(n) != null){
      ok.add(f);
    }else{
      fail.add(f);
    }
  }

  ok.sort((a, b){
    final dtA = tryParseTime(a.uri.pathSegments.last)!;
    final dtB = tryParseTime(b.uri.pathSegments.last)!;
    return isDesc ? dtB.compareTo(dtA) : dtA.compareTo(dtB);
  });

  return [...ok, ...fail];
}


/////////

///通过可执行文件路径获取pid
int? getPid(String targetPath){
  // 确保此函数仅在 Windows 平台上运行。
  if(!Platform.isWindows){
    writeErrorLog("api.getPid : This function is intended for Windows only. Current OS: ${Platform.operatingSystem}");
    return null;
  }

  // 检查原生函数是否已成功加载
  if(kernel32Api.createToolhelp32Snapshot == null ||
      kernel32Api.process32FirstW == null ||
      kernel32Api.process32NextW == null ||
      kernel32Api.openProcess == null ||
      kernel32Api.closeHandle == null ||
      kernel32Api.getLastError == null ||
      psapi.GetModuleFileNameExW == null){
    writeErrorLog("api.getPid : Failed to load one or more native Windows functions. Check DLL access or platform.");
    return null;
  }

  //Win32 API中的 INVALID_HANDLE_VALUE
  final Pointer<Void> INVALID_HANDLE_VALUE = Pointer<Void>.fromAddress(-1);

  //规范化目标路径：转换为小写并统一斜杠方向
  final String normalizedTargetPath = targetPath.toLowerCase().replaceAll("/", r"\");

  Pointer<Void> hSnapshot = INVALID_HANDLE_VALUE;
  Pointer<Uint8> pe32Buffer = calloc<Uint8>(568);
  Pointer<Utf16> filenameBuffer = calloc<Uint16>(260).cast<Utf16>();

  try{
    pe32Buffer.cast<Uint32>().value = 568;

    hSnapshot = kernel32Api.createToolhelp32Snapshot!(0x00000002, 0);

    if(hSnapshot == INVALID_HANDLE_VALUE){
      writeErrorLog("api.getPid : Failed to create process snapshot. Error: ${kernel32Api.getLastError!()}");
      return null;
    }

    //尝试获取第一个进程信息
    if(kernel32Api.process32FirstW!(hSnapshot, pe32Buffer.cast<Void>()) == 0){
      writeErrorLog("api.getPid : Failed to retrieve first process. Error: ${kernel32Api.getLastError!()}");
      kernel32Api.closeHandle!(hSnapshot);
      return null;
    }

    //循环遍历所有进程
    do {
      // 从缓冲区中读取 th32ProcessID
      final int pid = (pe32Buffer + 8).cast<Uint32>().value;
      Pointer<Void> hProcess = INVALID_HANDLE_VALUE;

      try{
        //尝试打开进程以获取其模块文件名
        hProcess = kernel32Api.openProcess!(0x0400, 0, pid);
        if(hProcess == nullptr){
          //无法打开进程（例如，系统进程或权限不足），跳过此进程。
          writeErrorLog("api.getPid : Failed to open process $pid. Error: ${kernel32Api.getLastError!()}");
          continue;
        }

        //获取进程的可执行文件完整路径
        final int charsCopied = psapi.GetModuleFileNameExW!(hProcess, nullptr, filenameBuffer, 260);
        if(charsCopied > 0 && charsCopied < 260){
          //将 UTF-16 缓冲区转换为 Dart 字符串
          final String currentProcessPath = filenameBuffer.toDartString().toLowerCase().replaceAll("/", r"\");

          //比较路径
          if(currentProcessPath == normalizedTargetPath){
            return pid;
          }
        }
      }finally{
        //确保关闭 OpenProcess 打开的句柄
        if(hProcess != INVALID_HANDLE_VALUE && hProcess != nullptr){
          kernel32Api.closeHandle!(hProcess);
        }
      }
    }while(kernel32Api.process32NextW!(hSnapshot, pe32Buffer.cast<Void>()) != 0); // 继续获取下一个进程，直到没有更多进程

    return null; //未找到匹配的进程
  }finally{
    //释放资源
    if (hSnapshot != INVALID_HANDLE_VALUE && hSnapshot != nullptr) {
      kernel32Api.closeHandle!(hSnapshot);
    }
    calloc.free(pe32Buffer);
    calloc.free(filenameBuffer);
  }
}


//通过进程PID, 获取该应用的第一个可见窗口句柄 (HWND)。

//必须为顶级，_enumWindowsProc回调函数需要访问它们
int _targetPidForCallback = 0;
int _foundHwndFromCallback = 0;

//EnumWindowsProc 回调函数, 它必须是顶级的
bool _enumWindowsProc(int hwnd, int lParam){
  using((arena){ //使用arena管理内存，确保即时释放
    final processIdPtr = arena<Uint32>(); //分配一个Uint32指针来接收PID

    //获取当前窗口的进程ID
    if(user32Api.getWindowThreadProcessId != null){
      user32Api.getWindowThreadProcessId!(hwnd, processIdPtr);
      final currentWindowPid = processIdPtr.value;

      //比较当前窗口的PID和目标PID
      if(currentWindowPid == _targetPidForCallback){
        _foundHwndFromCallback = hwnd; // 找到匹配项，存储HWND
        return false; // 返回false，停止EnumWindows枚举
      }
    }
  });
  return true; //继续枚举下一个窗口
}
///通过进程PID, 获取该应用的第一个可见窗口句柄 (HWND)。
int? getWindowHandle(int uid){
  if(!user32Api._isWindows){
    writeErrorLog("api.getWindowHandle : This function is only supported on Windows.");
    return null;
  }

  //重置全局变量
  _targetPidForCallback = uid;
  _foundHwndFromCallback = 0;

  final lpEnumFunc = Pointer.fromFunction<Bool Function(IntPtr, IntPtr)>(_enumWindowsProc, false);

  final result = user32Api.enumWindows?.call(lpEnumFunc, 0);

  // 检查EnumWindows是否成功。如果返回0且GetLastError不为0，表示失败。
  if(result == null || (result == 0 && kernel32Api.getLastError != null && kernel32Api.getLastError!() != 0)){
    writeErrorLog("api.getWindowHandle : EnumWindows failed with error code ${kernel32Api.getLastError?.call() ?? "unknown"}");
    return 0;
  }

  return _foundHwndFromCallback;
}



//打开资源管理器并定位到指定路径
Future<void> openPath(String path) async{
  if(Platform.isWindows){
    await Process.run("explorer", [path]);
  }
}



/// 获取缩略图
///
/// [originalImageProvider]: 原始的图片提供者，例如 AssetImage, NetworkImage。
/// [targetWidth]: 目标宽度。如果为 null，则不限制宽度。
/// [targetHeight]: 目标高度。如果为 null，则不限制高度。
/// [outputFormat]: 输出的字节数据格式。可以是 ui.ImageByteFormat.png (默认，压缩后PNG)
///                 或 ui.ImageByteFormat.rawRgba (原始RGBA像素数据)。
///
/// 返回一个包含图片数据的 Uint8List，如果失败则返回 null。
Future<Uint8List?> getResizedImageData({
  required ImageProvider originalImageProvider,
  int? targetWidth,
  int? targetHeight,
  ui.ImageByteFormat outputFormat = ui.ImageByteFormat.png, // 默认输出PNG格式
})async{
  // 1. 创建 ResizeImage 实例
  final ResizeImage resizedImage = ResizeImage(
    originalImageProvider,
    width: targetWidth,
    height: targetHeight,
  );

  // 2. 解析 ImageProvider 为 ImageStream
  final ImageStream stream = resizedImage.resolve(ImageConfiguration.empty);

  final Completer<ui.Image> completer = Completer();
  late ImageStreamListener listener;

  listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall){
      // 3. 当 ImageStream 发出 ImageInfo 时，完成 Completer
      completer.complete(info.image);
      // 4. 完成后，移除监听器以防止内存泄漏
      stream.removeListener(listener);
    },
    onError: (dynamic exception, StackTrace? stackTrace){
      completer.completeError(exception, stackTrace);
      stream.removeListener(listener);
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stackTrace,
          library: "image_data_util",
          context: ErrorDescription("while loading resized image"),
        ),
      );
    },
  );

  stream.addListener(listener);

  try{
    // 5. 等待 ui.Image 对象加载完成
    final ui.Image image = await completer.future;

    // 6. 从 ui.Image 获取 ByteData
    //    - ui.ImageByteFormat.png: 会将图片重新编码为 PNG 格式的字节数据
    //    - ui.ImageByteFormat.rawRgba: 提供原始的 RGBA 8888 像素数据
    final ByteData? byteData = await image.toByteData(format: outputFormat);

    // 7. 释放 ui.Image 资源
    image.dispose();

    if(byteData != null){
      // 8. 将 ByteData 转换为 Uint8List
      return byteData.buffer.asUint8List();
    }
  }catch(e){
    writeErrorLog("api.getResizedImageData : getting resized image data: $e");
  }
  return null;
}



///初始化配置
Future initConfig() async{
  //获取应用的文档目录
  final Directory dir = await getApplicationDocumentsDirectory();
  //构建目标文件夹的路径
  final Directory configDir = Directory("${dir.path}/Nikki Albums");
  //检查文件夹是否存在，如果不存在则创建
  if(!await configDir.exists()){
    await configDir.create(recursive: true);
  }
  //构建文件路径
  final File file = File("${dir.path}/Nikki Albums/config.json");
  //检查文件是否存在，如果不存在则创建并写入默认内容
  if(!await file.exists()){
    await file.writeAsString(jsonEncode(defaultConfig));
  }
  return file;
}

/// 读取配置文件
Future<Map> readConfig() async{
  final File file = await initConfig();
  final json = await file.readAsString();
  try{
    return jsonDecode(json);
  }catch(e){
    writeErrorLog("api.readConfig : $e");
    return {};
  }
}
/// 保存配置文件
Future<void> saveConfig(Map jsonMap) async{
  final File file = await initConfig();
  await file.writeAsString(jsonEncode(jsonMap));
}

/// 写入error
Future<void> writeErrorLog(String error) async{
  final DateTime utcTime = DateTime.now().toUtc();
  try{
    //获取应用的文档目录
    final Directory dir = await getApplicationDocumentsDirectory();
    //构建目标文件夹的路径
    final Directory configDir = Directory("${dir.path}/Nikki Albums");
    //检查文件夹是否存在，如果不存在则创建
    if(!await configDir.exists()){
      await configDir.create(recursive: true);
    }
    //构建文件路径
    final File file = File("${dir.path}/Nikki Albums/errorLog.txt");
    //检查文件是否存在，如果不存在则创建并写入默认内容
    if(!await file.exists()){
      await file.writeAsString("$utcTime: It was created.");
    }
    // 以追加模式写入内容
    await file.writeAsString("\n$utcTime : $error", mode: FileMode.append, flush: true,);
  }on FileSystemException catch(e){
    final errno = e.osError?.errorCode;
    switch(errno){
      case 13:
        print("权限被拒（Android 6+ 没动态申请存储权限，或 iOS 沙盒外路径）");
        break;
      case 28:
        print("磁盘已满");
        break;
      case 16 || 32:
        print("进程被占用");
        break;
    }
  }catch(e){
    print("写入失败: $e");
  }
}


String pathLast(String){
  if(Platform.isWindows){
    return String.split(r"\").last;
  }else if(Platform.isAndroid){
    return String.split(r"/").last;
  }else{
    return String.split(r"/").last;
  }
}
String pathSymbol(){
  if(Platform.isWindows){
    return r"\";
  }else if(Platform.isAndroid){
    return r"/";
  }else{
    return r"/";
  }
}

/// 截取路径
/// 返回路径的上n级
String extractPath(String path, int level){
  if(Platform.isWindows){
    if(level == 0){
      return path;
    }
    //确保路径以 \ 结尾
    if(!path.endsWith(r"\")){
      path += r"\";
    }
    //将路径分割成多个部分
    List<String> parts = path.split(r"\");
    //去掉空的部分（例如路径开头的 '\' 会导致空部分）
    parts.removeWhere((part) => part.isEmpty);
    //如果 keys[name] 大于路径的深度，返回根路径
    if(level >= parts.length){
      return parts[0];
    }
    return parts.sublist(0, parts.length - level).join(r"\");
  }
  return path;
}



String getBilibiliApiUrl(String bvid){
  return "https://api.bilibili.com/x/web-interface/view?bvid=$bvid";
}
String getBilibiliVideoUrl(String bvid){
  return "https://www.bilibili.com/video/$bvid";
}
// TODO 使用迭代体
///解析网络接口
Future getWebApi(String url, {String? source}) async{
  try{
    final response = await http.get(Uri.parse(url), headers: {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"});

    if(response.statusCode == 200){
      switch (source) {
        case "github":
          final data = json.decode(response.body);
          final content = data["content"] as String;
          final cleaned = content.replaceAll(RegExp(r"\s"), ""); // 去换行/空格
          final decoded = utf8.decode(base64.decode(cleaned));
          return jsonDecode(decoded);

        case "bilibili":
          final data = json.decode(response.body);
          if(data["code"] != 0){
            writeErrorLog("api.getWebApi : B站错误: ${data["message"]}");
          }
          return data["data"];

        case "cdkey":
          final data = json.decode(response.body);
          return data as List;

        default:
          return response.body;
      }
    }else{
      writeErrorLog("api.getWebApi : Failed to load content: ${response.statusCode}");
    }
  }catch(e){
    writeErrorLog("api.getWebApi : Error fetching GitHub file: $e");
  }
}



//判断列表的关系
int checkRelation<T>(List<T> list1, List<T> list2) {
  Set<T> set1 = Set.from(list1);
  Set<T> set2 = Set.from(list2);

  if(set1.containsAll(set2)){
    return 0;  //list1 包含 list2
  }else if(set2.containsAll(set1)){
    return 1;  //list2 包含 list1
  }else if(set1.intersection(set2).isEmpty){
    return 2;  //相离
  }else{
    return 3;  //相交
  }
}