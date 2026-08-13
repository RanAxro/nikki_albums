import "game_fs_proxy.dart";

/// 基于 adb shell 命令的实现。
///
/// TODO(adb-shell)：未实现。
///
/// 计划映射（posix 路径）：
/// - adb shell ls / stat 用于存在性与类型判断；
/// - adb pull 用于 readAsBytes（经临时文件）；
/// - adb push 用于 writeAsBytes；
/// - adb shell mkdir -p / rm -rf / mv / cp -r 用于目录与修改操作；
/// - adb shell ln -s / readlink 用于链接操作。
abstract class AdbShellFSProxy extends GameFSProxy{
  const AdbShellFSProxy(super.installPath);
}
