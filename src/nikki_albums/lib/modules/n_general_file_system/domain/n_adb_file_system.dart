
import "n_general_file_system.dart";
import "package:nikki_albums/gen/rust/adb/adb_device.dart";
import "package:nikki_albums/gen/rust/adb/model.dart" as adb;

import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:path/path.dart" as p;
import "package:watcher/watcher.dart";


class NAdbFileSystem extends NGeneralFileSystem{
  static NAdbFileSystem connect(AdbServerDevice device, String root){
    return NAdbFileSystem._(device, root);
  }

  final AdbServerDevice device;
  final String root;

  const NAdbFileSystem._(this.device, this.root);

  String _getRealPath(String path){
    if(root.isEmpty){
      return path;
    }
    path = p.posix.join(root, path);
    if(p.posix.isWithin(root, path) || p.posix.equals(root, path)){
      return path;
    }
    throw Exception("The file does not exist");
  }

  @override
  String? get path => root;

  @override
  String get name => p.posix.basename(root);

  @override
  NAdbFileSystem at(String path){
    return NAdbFileSystem._(device, _getRealPath(path));
  }

  int _getTypeFromMode(int mode){
    /// ((mode >> 13) & 0b111)
    return (mode >> 13) & 7;
  }

  Future<bool> _exists(String path, adb.FileStat? stat) async{
    if(stat == null){
      return false;
    }
    final int type = _getTypeFromMode(stat.perms.toInt());
    const Set<int> test = {
      2, // 0b010 Directory
      4, // 0b100 File
      5, // 0b101 Symlink
    };
    return test.contains(type);
  }

  @override
  Future<bool> exists(String path) async{
    final adb.FileStat? stat = await device.fileStat(path: _getRealPath(path));
    return _exists(path, stat);
  }

  @override
  Future<bool> isFile(String path) async{
    final adb.FileStat? stat = await device.fileStat(path: _getRealPath(path));
    if(stat == null){
      return false;
    }
    return _getTypeFromMode(stat.perms.toInt()) == 4;
  }

  @override
  Future<bool> isDir(String path) async{
    final adb.FileStat? stat = await device.fileStat(path: _getRealPath(path));
    if(stat == null){
      return false;
    }
    return _getTypeFromMode(stat.perms.toInt()) == 2;
  }

  @override
  Future<bool> isLink(String path) async{
    final adb.FileStat? stat = await device.fileStat(path: _getRealPath(path));
    if(stat == null){
      return false;
    }
    return _getTypeFromMode(stat.perms.toInt()) == 5;
  }

  @override
  Future<bool> identical(String path1, String path2){
    return FileSystemEntity.identical(_getRealPath(path1), _getRealPath(path2));
  }

  @override
  Future<NGFileStat> stat(String path) async{
    final adb.FileStat? stat = await device.fileStat(path: _getRealPath(path));
    if(!(await _exists(path, stat))){
      throw PathNotFoundException(path, OSError("", 2));
    }

    final int type = _getTypeFromMode(stat!.perms.toInt());
    return NGFileStat(
      changed: DateTime.fromMillisecondsSinceEpoch(stat.ctime),
      modified: DateTime.fromMillisecondsSinceEpoch(stat.mtime),
      accessed: DateTime.fromMillisecondsSinceEpoch(stat.atime),
      isFile: type == 4,
      isDir: type == 2,
      isLink: type == 5,
      mode: stat.perms.toInt(),
      size: stat.size.toInt(),
    );
  }

  @override
  Future<NGDirList> list(String path, [bool recursive = false, bool followLinks = true]) async{
    final String realPath = _getRealPath(path);
    final adb.DirList dirList = await device.list(path: _getRealPath(path));

    return NGDirList(
      files: dirList.fileNames.map((name) => p.posix.relative(p.posix.join(realPath, name), from: root)).toList(growable: false),
      dirs: dirList.dirNames.map((name) => p.posix.relative(p.posix.join(realPath, name), from: root)).toList(growable: false),
      links: dirList.linkNames.map((name) => p.posix.relative(p.posix.join(realPath, name), from: root)).toList(growable: false),
    );
  }

  @override
  Future<String> readString(String path, [Encoding encoding = utf8]){
    return readBytes(path).then(encoding.decode);
  }

  @override
  Future<List<String>> readLines(String path, [Encoding encoding = utf8]){
    return readString(path, encoding).then(const LineSplitter().convert);
  }

  @override
  Future<Uint8List> readBytes(String path){
    return device.readFile(path: _getRealPath(path));
  }

  @override
  Stream<FileEvent> watch(String path){
    /// TODO
    final DirectoryWatcher watcher = DirectoryWatcher(_getRealPath(path));
    return watcher.events.map((WatchEvent event){
      final FileEventType type = switch(event.type){
        ChangeType.ADD => FileEventType.add,
        ChangeType.REMOVE => FileEventType.remove,
        _ => FileEventType.modify,
      };
      return FileEvent(type, p.relative(event.path, from: root));
    });
  }
}