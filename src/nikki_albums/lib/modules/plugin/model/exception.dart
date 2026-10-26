
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

  const FailedReadFileException(this.position, this.target) : super("无法读取文件");
}