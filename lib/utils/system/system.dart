import 'dart:io';

import '../path.dart';
import 'system_service.dart';
import 'package:path_provider/path_provider.dart';

export 'system_service.dart';
export 'system_service.dart';

Future<Path> getAppDataDirectoryPath() async {
  final Directory directory = await getApplicationDocumentsDirectory();

  final Path appDataDirectoryPath = Path(directory.path) + "Nikki Albums";

  if (!await appDataDirectoryPath.directory.exists()) {
    appDataDirectoryPath.directory.create(recursive: true);
  }

  return appDataDirectoryPath;
}

Future<Path> getTempPath() async {
  final Path appDataDirectoryPath = await getAppDataDirectoryPath();

  final Path tempDirectoryPath = appDataDirectoryPath + "temp";

  if (!await tempDirectoryPath.directory.exists()) {
    tempDirectoryPath.directory.create(recursive: true);
  }

  return tempDirectoryPath;
}

Path getBinPath() {
  return Path(Platform.resolvedExecutable).cut(1) +
      "/data/flutter_assets/assets/bin";
}

Path getWebPath() {
  return Path(Platform.resolvedExecutable).cut(1) +
      "/data/flutter_assets/assets/web";
}

Future<void> compress(
  List<Path> paths,
  Path to, [
  void Function(double)? onProcess,
]) async {
  await SystemFactory.instance.compress(paths, to, onProcess);
}

Future<void> decompress(
  Path zipPath,
  Path to, [
  void Function(double)? onProcess,
]) async {
  await SystemFactory.instance.decompress(zipPath, to);
  onProcess?.call(1);
}

// Wrapper for existing global functions to maintain compatibility

(int, int) getWindowsScreenSize() => SystemFactory.instance.getScreenSize();

void doTopWindow(bool isTop, {int? hwnd}) =>
    SystemFactory.instance.doTopWindow(isTop, hwnd: hwnd);

void toForeground() => SystemFactory.instance.toForeground();

List<int> getAllWindowHandle() => SystemFactory.instance.getAllWindowHandle();

Path? getWindowsDesktopPath() => SystemFactory.instance.getDesktopPath();

(int, int, int) getDiskFreeSpaceEx(Path path) =>
    SystemFactory.instance.getDiskFreeSpaceEx(path);

Future<bool> runWindowsCommandAsAdmin(List<String> commands) =>
    SystemFactory.instance.runCommandAsAdmin(commands);

class Explorer {
  static void open() => SystemFactory.instance.openExplorer();
  static void openFile(File file) =>
      SystemFactory.instance.openFileInExplorer(file);
  static void openDir(Directory dir) =>
      SystemFactory.instance.openDirInExplorer(dir);
}
