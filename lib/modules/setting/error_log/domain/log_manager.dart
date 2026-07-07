import "dart:io";

import "package:nikki_albums/utils/path.dart";
import "package:nikki_albums/modules/app_base/domain/work_path_provider.dart";


/// 日志级别
enum LogLevel {
  info,
  warning,
  error,
  crash;

  String get label {
    switch (this) {
      case LogLevel.info:
        return "INFO";
      case LogLevel.warning:
        return "WARNING";
      case LogLevel.error:
        return "ERROR";
      case LogLevel.crash:
        return "CRASH";
    }
  }
}

/// 单条日志记录
class LogEntry {
  final DateTime time;
  final LogLevel level;
  final String source;
  final String message;
  final String? stackTrace;

  const LogEntry({
    required this.time,
    required this.level,
    required this.source,
    required this.message,
    this.stackTrace,
  });

  /// 序列化为单条日志文本块（头部单行 + 可选多行 stackTrace）
  String toLine() {
    final String timestamp =
        "${time.year.toString().padLeft(4, "0")}-"
        "${time.month.toString().padLeft(2, "0")}-"
        "${time.day.toString().padLeft(2, "0")} "
        "${time.hour.toString().padLeft(2, "0")}:"
        "${time.minute.toString().padLeft(2, "0")}:"
        "${time.second.toString().padLeft(2, "0")}."
        "${time.millisecond.toString().padLeft(3, "0")}";

    final StringBuffer buffer = StringBuffer();
    buffer.write("[$timestamp] [${level.label}] [$source] $message");
    if (stackTrace != null && stackTrace!.isNotEmpty) {
      buffer.write("\n");
      buffer.write(stackTrace);
    }
    return buffer.toString();
  }
}

/// 单个日志文件的管理器：负责追加、滚动、读取、清空
class LogFileManager {
  final String filename;

  /// 单文件大小上限，超过后滚动到 `.1` 备份
  static const int maxFileSize = 2 * 1024 * 1024;

  LogFileManager(this.filename);

  Future<Path> _filePath() async {
    return (await getAppDataDirectoryPath(create: true)) + "logs" + filename;
  }

  /// 日志所在目录，用于「打开日志目录」功能
  Future<Path> directoryPath() async {
    return (await getAppDataDirectoryPath(create: true)) + "logs";
  }

  /// 追加一条日志。失败时 print 提示，不向上抛（避免日志故障影响业务）。
  Future<bool> append(LogEntry entry) async {
    try {
      final Path path = await _filePath();
      final File file = path.file;

      if (!await file.exists()) {
        await file.create(recursive: true);
      }

      // 大小超过阈值时滚动：把当前文件改名为 .1（覆盖已有 .1）
      if (await file.length() > maxFileSize) {
        await _rotate(path);
        // 旋转后文件已被重命名走，需要重新创建
        if (!await file.exists()) {
          await file.create(recursive: true);
        }
      }

      await file.writeAsString(
        "${entry.toLine()}\n",
        mode: FileMode.append,
        flush: true,
      );
      return true;
    } on FileSystemException catch (e) {
      print("[LogFileManager] 写入失败 ($filename): ${e.message}");
      return false;
    } catch (e) {
      print("[LogFileManager] 未知错误 ($filename): $e");
      return false;
    }
  }

  /// 滚动：将 `<filename>` 重命名为 `<filename>.1`，覆盖旧备份
  Future<void> _rotate(Path path) async {
    try {
      final Path backup = Path("${path.path}.1");
      if (await backup.file.exists()) {
        await backup.file.delete();
      }
      await path.file.rename(backup.path);
    } catch (e) {
      // 旋转失败不影响主流程，最差情况是文件继续增长
      print("[LogFileManager] 旋转失败 ($filename): $e");
    }
  }

  /// 读取全部日志内容。文件不存在返回空字符串。
  Future<String> read() async {
    try {
      final Path path = await _filePath();
      if (!await path.file.exists()) {
        return "";
      }
      return await path.file.readAsString();
    } catch (e) {
      print("[LogFileManager] 读取失败 ($filename): $e");
      return "";
    }
  }

  /// 当前日志文件大小（字节）。文件不存在返回 0。
  Future<int> fileSize() async {
    try {
      final Path path = await _filePath();
      if (!await path.file.exists()) {
        return 0;
      }
      return await path.file.length();
    } catch (e) {
      return 0;
    }
  }

  /// 清空日志文件。同时删除 `.1` 备份。
  Future<void> clear() async {
    try {
      final Path path = await _filePath();
      if (await path.file.exists()) {
        await path.file.delete();
      }
      final Path backup = Path("${path.path}.1");
      if (await backup.file.exists()) {
        await backup.file.delete();
      }
    } catch (e) {
      print("[LogFileManager] 清空失败 ($filename): $e");
    }
  }
}

/// 全局日志接口
abstract class AppLogger {
  static final LogFileManager errorLog = LogFileManager("error.log");
  static final LogFileManager crashLog = LogFileManager("crash.log");

  static Future<void> _record(
    LogFileManager manager,
    LogLevel level,
    String source,
    String message, [
    String? stackTrace,
  ]) async {
    await manager.append(LogEntry(
      time: DateTime.now(),
      level: level,
      source: source,
      message: message,
      stackTrace: stackTrace,
    ));
  }

  /// 信息级日志（业务运行关键节点，如启动完成、热更新成功）
  static Future<void> info(String source, String message) {
    return _record(errorLog, LogLevel.info, source, message);
  }

  /// 警告级日志（可恢复的异常或非预期状态）
  static Future<void> warning(String source, String message) {
    return _record(errorLog, LogLevel.warning, source, message);
  }

  /// 错误级日志（业务侧 try/catch 捕获的异常）
  static Future<void> error(String source, String message, [String? stackTrace]) {
    return _record(errorLog, LogLevel.error, source, message, stackTrace);
  }

  /// 崩溃级日志（框架/Zone/Isolate 捕获的未处理异常）
  static Future<void> crash(String source, String message, [String? stackTrace]) {
    return _record(crashLog, LogLevel.crash, source, message, stackTrace);
  }
}
