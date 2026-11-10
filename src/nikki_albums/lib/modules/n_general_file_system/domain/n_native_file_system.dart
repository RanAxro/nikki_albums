
import "n_general_file_system.dart";

import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:path/path.dart" as p;


class NNativeFileSystem extends NGeneralFileSystem{
  static NNativeFileSystem connect(String root){
    return NNativeFileSystem._(root);
  }

  final String root;

  const NNativeFileSystem._(this.root);

  String _getRealPath(String path){
    if(root.isEmpty){
      return path;
    }
    path = p.join(root, path);
    if(p.isWithin(root, path) || p.equals(root, path)){
      return path;
    }
    throw Exception("The file does not exist");
  }

  @override
  String? get path => root;

  @override
  String get name => p.basename(root);

  @override
  Future<bool> exists(String path) async{
    final FileSystemEntityType type = await FileSystemEntity.type(_getRealPath(path));
    const Set<FileSystemEntityType> test = {.file, .directory, .link};
    return test.contains(type);
  }

  @override
  Future<bool> isFile(String path){
    return FileSystemEntity.isFile(_getRealPath(path));
  }

  @override
  Future<bool> isDir(String path){
    return FileSystemEntity.isDirectory(_getRealPath(path));
  }

  @override
  Future<bool> isLink(String path){
    return FileSystemEntity.isLink(_getRealPath(path));
  }

  @override
  Future<bool> identical(String path1, String path2){
    return FileSystemEntity.identical(_getRealPath(path1), _getRealPath(path2));
  }

  @override
  Future<NGFileStat> stat(String path) async{
    final FileStat stat = await FileStat.stat(_getRealPath(path));
    return NGFileStat(
      changed: stat.changed,
      modified: stat.modified,
      accessed: stat.accessed,
      isFile: stat.type == FileSystemEntityType.file,
      isDir: stat.type == FileSystemEntityType.directory,
      isLink: stat.type == FileSystemEntityType.link,
      mode: stat.mode,
      size: stat.size,
    );
  }

  @override
  Future<NGDirList> list(String path, [bool recursive = false, bool followLinks = true]) async{
    final NGDirList res = NGDirList(files: [], dirs: [], links: []);
    await for(final FileSystemEntity entity in Directory(_getRealPath(path)).list(recursive: recursive, followLinks: followLinks)){
      if(entity is File){
        res.files.add(p.relative(entity.path, from: root));
      }else if(entity is Directory){
        res.dirs.add(p.relative(entity.path, from: root));
      }else if(entity is Link){
        res.links.add(p.relative(entity.path, from: root));
      }
    }
    return res;
  }

  @override
  Future<String> readString(String path, [Encoding encoding = utf8]){
    return File(_getRealPath(path)).readAsString(encoding: encoding);
  }

  @override
  Future<List<String>> readLines(String path, [Encoding encoding = utf8]){
    return File(_getRealPath(path)).readAsLines(encoding: encoding);
  }

  @override
  Future<Uint8List> readBytes(String path){
    return File(_getRealPath(path)).readAsBytes();
  }
}