import 'dart:io';
import '../path.dart';

abstract class SystemServices {
  /// 获取屏幕大小
  (int, int) getScreenSize();

  /// 是否置顶window窗口
  void doTopWindow(bool isTop, {int? hwnd});

  void toForeground();

  List<int> getAllWindowHandle();

  Path? getDesktopPath();

  /// 返回  (剩余可用字节, 总字节, 空闲字节)  单位 Byte
  (int, int, int) getDiskFreeSpaceEx(Path path);

  Future<bool> runCommandAsAdmin(List<String> commands);

  Future<int> compress(List<Path> paths, Path to, [void Function(double)? onProcess]);

  Future<int> decompress(Path zipPath, Path to);

  Future<int> playBk2Video(Path video);

  Future<String?> getUserName();

  void openExplorer();

  void openFileInExplorer(File file);

  void openDirInExplorer(Directory dir);
}

class SystemFactory {
  static SystemServices? _instance;

  static void register(SystemServices instance) {
    _instance = instance;
  }

  static SystemServices get instance {
    if (_instance == null) {
      throw Exception("SystemServices is not registered for this platform");
    }
    return _instance!;
  }
}
