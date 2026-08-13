import "game_fs_proxy.dart";

/// 基于 shizuku 文件系统的实现。
///
/// TODO(shizuku)：未实现。
///
/// 计划映射（posix 路径）：
/// - 通过 shizuku 以 shell 权限执行 stat / ls / 文件操作（无需 adb）；
/// - 一次性读写经 shizuku binder API 完成。
abstract class ShizukuFSProxy extends GameFSProxy{
  const ShizukuFSProxy(super.installPath);
}
