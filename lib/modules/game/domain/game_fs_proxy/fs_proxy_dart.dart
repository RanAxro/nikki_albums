import "dart:io";
import "dart:typed_data";

import "package:path/path.dart" as p;

import "game_fs_entity.dart";
import "game_fs_exception.dart";
import "game_fs_proxy.dart";

/// 基于 dart:io（File / Directory / Link）的实现。
///
/// 适用于桌面与移动端，不适用于 web。
class DartFSProxy extends GameFSProxy{
  DartFSProxy(super.installPath);

  @override
  p.Context get pathContext => Platform.isWindows ? p.windows : p.posix;

  /// 相对路径 -> 本地绝对路径。
  String _native(String path) => resolve(path);

  /// 转为相对 installPath 的相对路径。
  String _toRelative(String path) => pathContext.isAbsolute(path)
    ? pathContext.relative(pathContext.normalize(path), from: pathContext.normalize(installPath))
    : pathContext.normalize(path);

  /// 执行 [action]，将 dart:io 错误转为 [GameFSException]。
  Future<T> _guard<T>(Future<T> Function() action) async{
    try{
      return await action();
    }on FileSystemException catch(e){
      throw _toGameFSException(e);
    }
  }

  /// 将 dart:io 异常映射为带类型的 [GameFSException]。
  GameFSException _toGameFSException(FileSystemException e){
    GameFSErrorType type = GameFSErrorType.io;
    final int? code = e.osError?.errorCode;
    switch(code){
      case 1: // EPERM
      case 5: // Windows 拒绝访问
      case 13: // EACCES
        type = GameFSErrorType.permissionDenied;
        break;
      case 2: // ENOENT
      case 3: // Windows 找不到路径
        type = GameFSErrorType.notFound;
        break;
      case 17: // EEXIST
      case 80: // ERROR_FILE_EXISTS
      case 183: // ERROR_ALREADY_EXISTS
        type = GameFSErrorType.alreadyExists;
        break;
    }
    if(type == GameFSErrorType.io){
      final String message = e.message.toLowerCase();
      if(message.contains("no such file") || message.contains("not found")){
        type = GameFSErrorType.notFound;
      }else if(message.contains("already exists") || message.contains("file exists")){
        type = GameFSErrorType.alreadyExists;
      }else if(message.contains("permission denied") || message.contains("access denied")){
        type = GameFSErrorType.permissionDenied;
      }
    }
    return GameFSException(type, message: e.message, path: e.path, cause: e);
  }

  /// 返回 [path] 对应的 dart:io 实体，不存在时抛异常。
  Future<FileSystemEntity> _entityByType(String path) async{
    final String nativePath = _native(path);
    switch(await FileSystemEntity.type(nativePath, followLinks: false)){
      case FileSystemEntityType.file:
        return File(nativePath);
      case FileSystemEntityType.directory:
        return Directory(nativePath);
      case FileSystemEntityType.link:
        return Link(nativePath);
      default:
        throw GameFSException(GameFSErrorType.notFound, message: "No such file or directory", path: path);
    }
  }

  @override
  Future<bool> exists(String path) => _guard(() async{
    return await FileSystemEntity.type(_native(path), followLinks: false) != FileSystemEntityType.notFound;
  });

  @override
  Future<GameFSEntityType> type(String path) => _guard(() async{
    switch(await FileSystemEntity.type(_native(path), followLinks: false)){
      case FileSystemEntityType.file:
        return GameFSEntityType.file;
      case FileSystemEntityType.directory:
        return GameFSEntityType.directory;
      case FileSystemEntityType.link:
        return GameFSEntityType.link;
      default:
        return GameFSEntityType.notFound;
    }
  });

  @override
  Future<GameFSEntity?> entity(String path) => _guard(() async{
    final String nativePath = _native(path);
    final String relative = _toRelative(path);
    switch(await FileSystemEntity.type(nativePath, followLinks: false)){
      case FileSystemEntityType.file:
        return GameFile(this, relative);
      case FileSystemEntityType.directory:
        return GameDirectory(this, relative);
      case FileSystemEntityType.link:
        return GameLink(this, relative);
      default:
        return null;
    }
  });

  @override
  Future<List<GameFSEntity>> list(String path, {bool recursive = false}) => _guard(() async{
    final String relativePath = _toRelative(path);
    final String nativePath = _native(relativePath);
    final List<GameFSEntity> result = [];

    await for(final FileSystemEntity e in Directory(nativePath).list(recursive: recursive, followLinks: false)){
      final String relative = pathContext.relative(
        pathContext.normalize(e.path),
        from: pathContext.normalize(nativePath),
      );
      final String logical = pathContext.normalize(pathContext.join(relativePath, relative));

      switch(await FileSystemEntity.type(e.path, followLinks: false)){
        case FileSystemEntityType.file:
          result.add(GameFile(this, logical));
        case FileSystemEntityType.directory:
          result.add(GameDirectory(this, logical));
        case FileSystemEntityType.link:
          result.add(GameLink(this, logical));
        default:
          break;
      }
    }

    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  });

  @override
  Future<void> createDirectory(String path, {bool recursive = false}) =>
    _guard(() => Directory(_native(path)).create(recursive: recursive));

  @override
  Future<Uint8List> readAsBytes(String path) =>
    _guard(() => File(_native(path)).readAsBytes());

  @override
  Future<void> writeAsBytes(
    String path,
    Uint8List bytes, {
    bool create = true,
    bool overwrite = true,
  }) => _guard(() async{
    final File file = File(_native(path));
    final bool exists = await file.exists();

    if(!create && !exists){
      throw GameFSException(GameFSErrorType.notFound, message: "File does not exist", path: path);
    }
    if(!overwrite && exists){
      throw GameFSException(GameFSErrorType.alreadyExists, message: "File already exists", path: path);
    }
    if(create){
      await file.parent.create(recursive: true);
    }
    await file.writeAsBytes(bytes, flush: true);
  });

  @override
  Future<int> length(String path) => _guard(() => File(_native(path)).length());

  @override
  Future<void> createFile(
    String path, {
    bool recursive = true,
    bool exclusive = false,
  }) => _guard(() async{
    final File file = File(_native(path));
    if(exclusive && await file.exists()){
      throw GameFSException(GameFSErrorType.alreadyExists, message: "File already exists", path: path);
    }
    if(recursive){
      await file.parent.create(recursive: true);
    }
    await file.create(exclusive: exclusive);
  });

  @override
  Future<void> delete(String path, {bool recursive = false}) => _guard(() async{
    final FileSystemEntity entity = await _entityByType(path);
    if(entity is Directory){
      await entity.delete(recursive: recursive);
    }else{
      await entity.delete();
    }
  });

  @override
  Future<void> rename(String from, String to) => _guard(() async{
    final FileSystemEntity entity = await _entityByType(from);
    await entity.rename(_native(to));
  });

  @override
  Future<void> copy(String from, String to) => _guard(() async{
    final FileSystemEntity entity = await _entityByType(from);
    final String nativeTo = _native(to);

    if(entity is File){
      await entity.copy(nativeTo);
    }else if(entity is Link){
      await Link(nativeTo).create(await entity.target(), recursive: true);
    }else if(entity is Directory){
      await _copyDirectory(entity, Directory(nativeTo));
    }
  });

  @override
  Future<void> download(String path, {String? savePath}) => _guard(() async{
    if(savePath == null){
      throw GameFSException(GameFSErrorType.invalidArgument, message: "savePath is required on non-web platforms");
    }
    final FileSystemEntity entity = await _entityByType(path);
    if(entity is File){
      await entity.copy(savePath);
    }else if(entity is Directory){
      await _copyDirectory(entity, Directory(savePath));
    }else if(entity is Link){
      throw GameFSException(GameFSErrorType.unsupported, message: "Downloading a symbolic link is not supported");
    }
  });

  Future<void> _copyDirectory(Directory from, Directory to) async{
    await to.create(recursive: true);
    await for(final FileSystemEntity e in from.list(followLinks: false)){
      final String childPath = pathContext.join(
        to.path,
        pathContext.basename(e.path),
      );

      if(e is File){
        await e.copy(childPath);
      }else if(e is Link){
        await Link(childPath).create(await e.target(), recursive: true);
      }else if(e is Directory){
        await _copyDirectory(e, Directory(childPath));
      }
    }
  }

  @override
  Future<String> readLinkTarget(String path) => _guard(() => Link(_native(path)).target());

  @override
  Future<void> createLink(String path, String target) => _guard(() async{
    final String nativePath = _native(path);
    await Directory(pathContext.dirname(nativePath)).create(recursive: true);
    await Link(nativePath).create(target);
  });
}
