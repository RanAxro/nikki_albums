/// 文件系统错误类型。
enum GameFSErrorType{
  /// 路径不存在。
  notFound,

  /// 目标已存在。
  alreadyExists,

  /// 权限不足。
  permissionDenied,

  /// 路径位于 installPath 之外。
  outsideInstallPath,

  /// 参数非法。
  invalidArgument,

  /// 后端不支持该操作。
  unsupported,

  /// 其他 IO 错误。
  io,
}

/// 由 [GameFSProxy] 实现抛出的异常。
///
/// 以 [type] 区分错误类型，程序内可直接 switch 判断；
/// [message] 仅为辅助说明，不用于判断类型。
class GameFSException implements Exception{
  /// 错误类型。
  final GameFSErrorType type;

  /// 错误信息（可选）。
  final String? message;

  /// 相关路径（如有）。
  final String? path;

  /// 原始后端错误（如有）。
  final Object? cause;

  const GameFSException(this.type, {this.message, this.path, this.cause});

  @override
  String toString(){
    final String location = path == null ? "" : " at '$path'";
    final String detail = message == null ? "" : ": $message";
    return "GameFSException.$type$location$detail";
  }
}
