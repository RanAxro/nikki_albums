
abstract class PluginException implements Exception{
  final String message;
  const PluginException(this.message);
}

class InvalidPluginException extends PluginException{
  const InvalidPluginException() : super("无效的插件");
}

class FailedReadFileException extends PluginException{
  final String position;
  final String target;

  const FailedReadFileException(this.position, this.target) : super("无法读取插件内的文件");
}

class PermissionDeniedException extends PluginException{
  final String target;

  const PermissionDeniedException(this.target) : super("权限不足");
}

class InjectionFailedException extends PluginException{
  final String scriptType;
  final String error;

  const InjectionFailedException(this.scriptType, this.error) : super("接口注入失败");

  @override
  String toString() => error;
}

class PluginScriptMalfunctionedException extends PluginException{
  final String scriptType;
  final String? script;
  final String error;

  const PluginScriptMalfunctionedException({required this.scriptType, this.script, required this.error}) : super("脚本运行异常");

  @override
  String toString() => error;
}