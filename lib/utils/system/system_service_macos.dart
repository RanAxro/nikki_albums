import 'dart:io';
import 'package:archive/archive_io.dart';
import '../path.dart';
import 'system_service.dart';

class MacOsSystemServices implements SystemServices {
  @override
  (int, int) getScreenSize() {
    // Basic stub, can be implemented using bitsdojo_window or window_manager if needed
    return (1920, 1080);
  }

  @override
  void doTopWindow(bool isTop, {int? hwnd}) {
    // Not implemented for macOS yet
  }

  @override
  void toForeground() {
    // Not implemented for macOS yet
  }

  @override
  List<int> getAllWindowHandle() {
    return [];
  }

  @override
  Path? getDesktopPath() {
    final home = Platform.environment['HOME'];
    if (home != null) {
      return '$home/Desktop';
    }
    return null;
  }

  @override
  (int, int, int) getDiskFreeSpaceEx(Path path) {
    // Stub implementation, accurate values would require FFI or a package like disk_space
    // Returning dummy values for now to prevent crashes
    const int gigabyte = 1024 * 1024 * 1024;
    return (10 * gigabyte, 100 * gigabyte, 10 * gigabyte);
  }

  @override
  Future<bool> runCommandAsAdmin(List<String> commands) async {
    return false; // Stub
  }

  @override
  Future<int> compress(List<Path> paths, Path to, [void Function(double)? onProcess]) async {
    try {
      final encoder = ZipFileEncoder();
      encoder.create(to);
      for (final path in paths) {
        final stat = FileStat.statSync(path);
        if (stat.type == FileSystemEntityType.directory) {
          encoder.addDirectory(Directory(path));
        } else if (stat.type == FileSystemEntityType.file) {
          encoder.addFile(File(path));
        }
      }
      encoder.close();
      return 0;
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<int> decompress(Path zipPath, Path to) async {
    try {
      final bytes = File(zipPath).readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('$to/$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory('$to/$filename').createSync(recursive: true);
        }
      }
      return 0;
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<int> playBk2Video(Path video) async {
    // Not implemented
    return -1;
  }

  @override
  Future<String?> getUserName() async {
    return Platform.environment['USER'];
  }

  @override
  void openExplorer() {
    Process.run('open', ['.']);
  }

  @override
  void openFileInExplorer(File file) {
    Process.run('open', ['-R', file.path]);
  }

  @override
  void openDirInExplorer(Directory dir) {
    Process.run('open', [dir.path]);
  }
}
