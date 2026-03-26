import "dart:io";

import "system/system.dart";

class Path{
  static Path? from(dynamic value){
    if(value is! String) return null;

    return Path(value);
  }


  final String _path;

  Path(String path) : _path = normalizePath(path);

  String get name{
    return _path.split("/").last;
  }

  String get subName{
    final int extensionLength = extension.length;

    return name.substring(0, name.length - (extensionLength == 0 ? 0 : extensionLength + 1));
  }

  String get path{
    return _path.replaceAll("/", symbol);
  }

  FileSystemEntityType get type{
    return FileSystemEntity.typeSync(_path);
  }

  Future<FileSystemEntityType> get typeAsync{
    return FileSystemEntity.type(_path);
  }

  String get extension{
    final idx = path.split("/").last.lastIndexOf(".");
    return (idx < 0 || idx == path.length - 1) ? "" : path.substring(idx + 1);
  }

  FileStat? _cacheStat;

  FileStat get stat{
    return FileStat.statSync(path);
  }

  Future<FileStat> get statAsync{
    return FileStat.stat(path);
  }

  FileStat get cacheStat{
    _cacheStat ??= FileStat.statSync(path);
    return _cacheStat!;
  }

  Future<FileStat> get cacheStatAsync async{
    _cacheStat ??= await FileStat.stat(path);
    return _cacheStat!;
  }

  // String? _exif;
  //
  // Future<String?> get exifAsync async{
  //   if(Platform.isWindows){
  //     final process = await Process.run(Bin.jhead.path, [path]);
  //     if(process.exitCode != 0) return null;
  //     return process.stdout as String;
  //   }else if(Platform.isAndroid){
  //     // TODO
  //     return null;
  //   }
  //   return null;
  // }

  FileSystemEntity? get entity{
    switch(FileSystemEntity.typeSync(path)){
      case FileSystemEntityType.directory:
        return Directory(path);
      case FileSystemEntityType.file:
        return File(path);
      case FileSystemEntityType.link:
        return Link(path);
      default:
        return null;
    }
  }

  Future<FileSystemEntity?> get entityAsync async{
    switch(await FileSystemEntity.type(path)){
      case FileSystemEntityType.directory:
        return Directory(path);
      case FileSystemEntityType.file:
        return File(path);
      case FileSystemEntityType.link:
        return Link(path);
      default:
        return null;
    }
  }

  File get file{
    return File(path);
  }

  Directory get directory{
    return Directory(path);
  }

  Link get link{
    return Link(path);
  }

  Future<int> size() async{
    final FileSystemEntityType type = await typeAsync;
    if(type == FileSystemEntityType.file){
      return file.length();
    }else if(type == FileSystemEntityType.directory){
      final Directory dir = directory;
      if(!await dir.exists()) return 0;

      int total = 0;
      await for(final entity in dir.list(recursive: true, followLinks: false)){
        if(entity is File){
          try{
            total += await entity.length();
          }catch(_){}
        }
      }
      return total;
    }
    return 0;
  }

  Future<void> open([FileSystemEntityType? targetType]) async{
    try{
      switch(await typeAsync){
        case FileSystemEntityType.file:
          if(targetType != null && targetType != FileSystemEntityType.file) return;

          if(Platform.isWindows){
            Process.start(path, [], mode: ProcessStartMode.detached);
          }else if(Platform.isAndroid){

          }
          break;
        case FileSystemEntityType.directory:
          if(targetType != null && targetType != FileSystemEntityType.directory) return;

          if(Platform.isWindows){
            Process.run("explorer", [path]);
          }else if(Platform.isAndroid){

          }
          break;
        default:
          break;
      }
    }catch(e){
      return;
    }
  }

  Future<File> moveFileToDirectory(Path destination) async{
    final Path newPath = destination + name;

    try{
      // prefer using rename as it is probably faster
      return await file.rename(newPath.path);
    }on FileSystemException catch(e){
      // if rename fails, copy the source file and then delete it
      final newFile = await file.copy(newPath.path);
      await file.delete();
      return newFile;
    }
  }

  Future<void> _copyDir(Directory a, Directory b) async{
    if(await b.exists()) await b.delete(recursive: true);
    await b.create(recursive: true);

    await for(final entity in a.list(recursive: false)){
      final name = entity.uri.pathSegments.last;
      if(entity is File){
        await entity.copy("${b.path}$symbol$name");
      }else if(entity is Directory){
        await _copyDir(entity, Directory("${b.path}$symbol$name"));
      }
    }
  }

  Future<void> copyDirectoryToDirectory(Path destination, {bool ignoreExists = false}) async{
    final Path to = destination + name;
    if(await to.directory.exists() && !ignoreExists) return;

    await _copyDir(directory, to.directory);
  }

  Future<void> moveDirectoryToDirectory(Path destination, {bool ignoreExists = false}) async{
    await copyDirectoryToDirectory(destination, ignoreExists: ignoreExists);
    await directory.delete(recursive: true);
  }

  Future<ProcessResult> generateDirectoryMklink(Path destination, {String? dirName, bool ignoreExists = false}){
    return Process.run("cmd", ["/c", "mklink", "/D", (destination + (dirName ?? name)).path, _path]);
    // return Process.run("cmd", ["/c", "mklink", "/D", "\"${(destination + (dirName ?? name)).path}\"", "\"$_path\""]);
  }

  Future<bool> generateDirectoryMklinkAsAdmin(Path destination, {String? dirName, bool ignoreExists = false}){
    return runWindowsCommandAsAdmin([["mklink", "/D", "\"${(destination + (dirName ?? name)).path}\"", "\"$_path\""].join(" ")]);
  }

  /// 假设 path 已经 normalize 过，level >= 0。
  /// 返回删掉末尾 level 段之后的路径；若删光了就返回 "."。
  Path cut(int level){
    if(level <= 0) return Path(_path);
    if(_path == "." || _path.isEmpty) return Path(".");

    // 1. 拆分
    final parts = _path.split("/");

    // 2. 计算要保留的段数
    final keep = parts.length - level;
    if(keep <= 0) return Path(".");

    // 3. 拼回去
    return Path(parts.sublist(0, keep).join("/"));
  }

  /// 保留“前 level 级”目录。
  /// level <= 0 时返回 "."。
  String last(int level){
    if(level <= 0 || _path == "." || _path.isEmpty) return ".";

    // 1. 拆分
    final parts = _path.split("/");

    // 2. 找出“目录段”的起止位置
    int start = 0;
    int end = parts.length;

    // 盘符（Windows 如 "C:"）一定在 parts[0]
    final bool hasDrive = parts[0].length == 2 && parts[0][1] == ":";
    if(hasDrive) start = 1;

    // 绝对路径的根 "/" 会拆出一个空串，跳过它
    if(parts[start] == "") start++;

    // 3. 真正待截取的目录段
    final dirParts = parts.sublist(start, end);

    // 4. 截取
    final take = level > dirParts.length ? dirParts.length : level;
    final taken = dirParts.sublist(0, take);

    // 5. 拼回去
    final buffer = StringBuffer();
    if(hasDrive) buffer.write(parts[0]);
    if(start > 0 && parts[start - 1] == "") buffer.write("/");
    for(int i = 0; i < taken.length; i++){
      if(i != 0 || buffer.isNotEmpty) buffer.write("/");
      buffer.write(taken[i]);
    }

    final result = buffer.toString();
    return result.isEmpty ? "." : result;
  }



  Path copy(){
    return copyWith(this);
  }

  static Path copyWith(Path target){
    return Path(target.path);
  }

  static String get symbol{
    return Platform.pathSeparator;
  }

  /// 解析路径
  static String normalizePath(String input){
    if(input.isEmpty) return ".";

    // 1. 统一分隔符
    String s = input.replaceAll(r"\", "/");

    // 2. 记录末尾斜杠
    final bool endsWithSlash = s.endsWith("/");

    // 3. 判断盘符
    final bool hasDrive = s.length >= 2 && s[1] == ":";
    final String? drive = hasDrive ? s.substring(0, 2) : null;

    // 4. 去掉盘符部分，只处理后面那段
    if (hasDrive) s = s.substring(2);

    // 5. 判断是否绝对（Unix 根 /  或  Windows 盘符根  C:/）
    final bool isAbsolute = s.startsWith("/");

    // 6. 拆分、去空、去“.”
    final List<String> parts = s.split("/")..removeWhere((e) => e.isEmpty || e == ".");

    // 7. 栈消“..”
    final List<String> stack = [];
    for(final seg in parts){
      if(seg == ".."){
        if(stack.isNotEmpty && stack.last != ".."){
          if(!isAbsolute || stack.length > 1){
            stack.removeLast();
            continue;
          }
        }
        // 退无可退，保留“..”
      }
      stack.add(seg);
    }

    // 8. 拼路径
    String result = stack.join("/");
    if(isAbsolute) result = "/$result";
    if(drive != null) result = drive + result;

    // 9. 还原末尾斜杠
    // if(endsWithSlash && !result.endsWith("/")) result += "/";

    return result.isEmpty ? "." : result;
  }

  Path operator + (dynamic other){
    if(other is String){
      return Path("$path/$other");
    }else if(other is Path){
      return Path("$path/${other._path}");
    }else{
      return Path(path);
    }
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Path && runtimeType == other.runtimeType && _path == other._path;

  @override
  int get hashCode => _path.hashCode;
}