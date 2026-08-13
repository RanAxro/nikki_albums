import 'dart:io';
import '../path.dart';
import 'system_service.dart';
import 'windows.dart' as win;

class WindowsSystemServices implements SystemServices {
  @override
  (int, int) getScreenSize() => win.getWindowsScreenSize();

  @override
  void doTopWindow(bool isTop, {int? hwnd}) => win.doTopWindow(isTop, hwnd: hwnd);

  @override
  void toForeground() => win.toForeground();

  @override
  List<int> getAllWindowHandle() => win.getAllWindowHandle();

  @override
  Path? getDesktopPath() => win.getWindowsDesktopPath();

  @override
  (int, int, int) getDiskFreeSpaceEx(Path path) => win.getDiskFreeSpaceEx(path);

  @override
  Future<bool> runCommandAsAdmin(List<String> commands) => win.runWindowsCommandAsAdmin(commands);

  @override
  Future<int> compress(List<Path> paths, Path to, [void Function(double)? onProcess]) => win.compressInWindows(paths, to, onProcess);

  @override
  Future<int> decompress(Path zipPath, Path to) => win.decompressInWindows(zipPath, to);

  @override
  Future<int> playBk2Video(Path video) => win.playBk2VideoInWindows(video);

  @override
  Future<String?> getUserName() => win.getWindowsUserName();

  @override
  void openExplorer() => win.Explorer.open();

  @override
  void openFileInExplorer(File file) => win.Explorer.openFile(file);

  @override
  void openDirInExplorer(Directory dir) => win.Explorer.openDir(dir);
}
