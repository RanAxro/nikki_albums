import "package:nikki_albums/modules/setting/error_log/domain/log_manager.dart";


/// 兼容旧调用入口：所有 `AppLog.write(form, error)` 调用统一委托到新 `AppLogger.error`。
abstract class AppLog {
  static Future<void> write(String form, String error) async {
    await AppLogger.error(form, error);
  }
}
