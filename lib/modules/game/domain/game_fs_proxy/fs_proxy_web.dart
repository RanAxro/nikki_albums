import "game_fs_proxy.dart";

/// 基于 web File System Access API 的实现。
///
/// TODO(web-fs-access)：未实现。
///
/// 计划映射：
/// - 根句柄来自 showDirectoryPicker()（或持久化的安装路径）；
/// - getFileHandle / getDirectoryHandle 用于 exists / type / entity；
/// - getFile() + text() / arrayBuffer() 用于 readAsBytes；
/// - FileSystemWritableFileStream 用于 writeAsBytes；
/// - entries() 用于 list；
/// - download 由浏览器处理，忽略 savePath。
///
/// web 没有符号链接，createLink 应抛 GameFSErrorType.unsupported 错误。
abstract class WebFSProxy extends GameFSProxy{
  const WebFSProxy(super.installPath);
}
