import "dart:typed_data";

import "package:path/path.dart" as p;

import "game_fs_entity.dart";

export "game_fs_entity.dart";
export "game_fs_exception.dart";

/// 抽象游戏文件系统代理。
///
/// 统一封装以下后端：
/// 1. dart:io 文件接口（File / Directory / Link）；
/// 2. web File System Access API；
/// 3. adb shell；
/// 4. shizuku 文件系统。
///
/// 仅提供一次性读写，无流式接口。
/// 所有路径均为相对 [installPath] 的相对路径，用 package:path 处理。
/// 错误统一通过 [GameFSException] 抛出，以 [GameFSErrorType] 区分类型。
abstract class GameFSProxy{
  /// 游戏安装根路径。
  final String installPath;

  const GameFSProxy(this.installPath);

  /// 后端路径上下文（posix / windows / url）。
  ///
  /// 返回的路径都属于该上下文，调用方应使用它处理路径。
  p.Context get pathContext => p.posix;

  /// 将相对路径解析为相对 [installPath] 的绝对路径并规范化。
  String resolve(String path) => pathContext.normalize(pathContext.join(installPath, path));

  /// 路径是否存在。
  Future<bool> exists(String path);

  /// 路径类型，不存在时返回 [GameFSEntityType.notFound]。
  ///
  /// 链接不跟随，直接返回 [GameFSEntityType.link]。
  Future<GameFSEntityType> type(String path);

  /// 路径对应的实体，不存在时返回 null。
  Future<GameFSEntity?> entity(String path);

  /// 列出目录子项（一次性返回全部）。
  Future<List<GameFSEntity>> list(String path, {bool recursive = false});

  /// 创建目录。
  Future<void> createDirectory(String path, {bool recursive = false});

  /// 一次性读取整个文件。
  Future<Uint8List> readAsBytes(String path);

  /// 一次性写入整个文件。
  ///
  /// [create]: 文件或父目录不存在时自动创建。
  /// [overwrite]: 文件已存在时是否覆盖。
  Future<void> writeAsBytes(
    String path,
    Uint8List bytes, {
    bool create = true,
    bool overwrite = true,
  });

  /// 文件字节长度。
  Future<int> length(String path);

  /// 创建空文件。
  ///
  /// [recursive]: 自动创建父目录。
  /// [exclusive]: 文件已存在时抛异常。
  Future<void> createFile(
    String path, {
    bool recursive = true,
    bool exclusive = false,
  });

  /// 删除路径，非空目录需 [recursive]。
  Future<void> delete(String path, {bool recursive = false});

  /// 重命名 / 移动，[to] 为相对 [installPath] 的相对路径。
  Future<void> rename(String from, String to);

  /// 复制（文件 / 目录），[to] 为相对 [installPath] 的相对路径。
  Future<void> copy(String from, String to);

  /// 下载到本地。
  ///
  /// [savePath] 为绝对路径：web 上忽略该参数，由浏览器处理下载；
  /// 其他平台直接复制文件或递归复制文件夹到 [savePath]（此时必填）。
  Future<void> download(String path, {String? savePath});

  /// 读取符号链接目标。
  Future<String> readLinkTarget(String path);

  /// 创建符号链接，[target] 相对链接所在目录或为绝对路径。
  ///
  /// 不支持链接的后端应抛 [GameFSErrorType.unsupported] 错误。
  Future<void> createLink(String path, String target);
}
