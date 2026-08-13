import "dart:typed_data";

import "package:path/path.dart" as p;

import "game_fs_proxy.dart";

/// 文件系统实体类型。
enum GameFSEntityType{
  /// 普通文件。
  file,

  /// 目录。
  directory,

  /// 符号链接。
  link,

  /// 路径不存在。
  notFound,
}

/// 文件系统实体抽象基类，与 dart:io 的 FileSystemEntity 类似。
abstract class GameFSEntity{
  /// 所属代理。
  final GameFSProxy proxy;

  /// 相对路径，相对于 [GameFSProxy.installPath]。
  ///
  /// 使用相对路径便于兼容 web File System Access API。
  final String path;

  const GameFSEntity(this.proxy, this.path);

  /// 实体类型。
  GameFSEntityType get type;

  /// 文件名（最后一段路径）。
  String get name => proxy.pathContext.basename(path);

  /// 父目录路径。
  String get dirname => proxy.pathContext.dirname(path);

  /// 校验 [path] 位于 installPath 内，否则抛异常。
  void _checkInside(String path){
    final p.Context ctx = proxy.pathContext;
    final String root = ctx.normalize(proxy.installPath);
    final String resolved = ctx.normalize(proxy.resolve(path));
    if(resolved == root || ctx.isWithin(root, resolved)) return;
    throw GameFSException(GameFSErrorType.outsideInstallPath, message: "Path is outside installPath", path: path);
  }

  /// 是否存在。
  Future<bool> exists() async{
    _checkInside(path);
    return proxy.exists(path);
  }

  /// 删除实体，非空目录需 [recursive]。
  Future<void> delete({bool recursive = false}) async{
    _checkInside(path);
    await proxy.delete(path, recursive: recursive);
  }

  /// 重命名 / 移动到 [newPath]（相对路径）。
  Future<void> rename(String newPath) async{
    _checkInside(path);
    _checkInside(newPath);
    await proxy.rename(path, newPath);
  }

  @override
  String toString() => "$runtimeType($path)";
}

/// 普通文件。
class GameFile extends GameFSEntity{
  const GameFile(super.proxy, super.path);

  @override
  GameFSEntityType get type => GameFSEntityType.file;

  /// 一次性读取整个文件。
  Future<Uint8List> readAsBytes() async{
    _checkInside(path);
    return proxy.readAsBytes(path);
  }

  /// 一次性写入整个文件。
  Future<void> writeAsBytes(
    Uint8List bytes, {
    bool create = true,
    bool overwrite = true,
  }) async{
    _checkInside(path);
    await proxy.writeAsBytes(
      path,
      bytes,
      create: create,
      overwrite: overwrite,
    );
  }

  /// 文件字节长度。
  Future<int> length() async{
    _checkInside(path);
    return proxy.length(path);
  }

  /// 创建文件。
  Future<void> create({bool recursive = true, bool exclusive = false}) async{
    _checkInside(path);
    await proxy.createFile(
      path,
      recursive: recursive,
      exclusive: exclusive,
    );
  }

  /// 复制到 [newPath]（相对路径）。
  Future<void> copy(String newPath) async{
    _checkInside(path);
    _checkInside(newPath);
    await proxy.copy(path, newPath);
  }

  /// 下载到本地，[savePath] 为绝对路径（web 上忽略）。
  Future<void> download({String? savePath}) async{
    _checkInside(path);
    await proxy.download(path, savePath: savePath);
  }
}

/// 目录。
class GameDirectory extends GameFSEntity{
  const GameDirectory(super.proxy, super.path);

  @override
  GameFSEntityType get type => GameFSEntityType.directory;

  /// 创建目录。
  Future<void> create({bool recursive = false}) async{
    _checkInside(path);
    await proxy.createDirectory(path, recursive: recursive);
  }

  /// 列出子项（一次性返回全部）。
  Future<List<GameFSEntity>> list({bool recursive = false}) async{
    _checkInside(path);
    return proxy.list(path, recursive: recursive);
  }

  /// 复制到 [newPath]（相对路径）。
  Future<void> copy(String newPath) async{
    _checkInside(path);
    _checkInside(newPath);
    await proxy.copy(path, newPath);
  }

  /// 下载到本地（递归复制），[savePath] 为绝对路径（web 上忽略）。
  Future<void> download({String? savePath}) async{
    _checkInside(path);
    await proxy.download(path, savePath: savePath);
  }
}

/// 符号链接。
class GameLink extends GameFSEntity{
  const GameLink(super.proxy, super.path);

  @override
  GameFSEntityType get type => GameFSEntityType.link;

  /// 链接目标。
  Future<String> target() async{
    _checkInside(path);
    return proxy.readLinkTarget(path);
  }

  /// 创建链接指向 [target]。
  Future<void> create(String target) async{
    _checkInside(path);
    await proxy.createLink(path, target);
  }
}
