export "n_native_file_system.dart";

import "dart:convert";
import "dart:io";
import "dart:typed_data";


class NGFileStat{
  final DateTime changed;
  final DateTime modified;
  final DateTime accessed;
  final bool isFile;
  final bool isDir;
  final bool isLink;
  final int mode;
  final int size;

  const NGFileStat({
    required this.changed,
    required this.modified,
    required this.accessed,
    required this.isFile,
    required this.isDir,
    required this.isLink,
    required this.mode,
    required this.size,
  });
}

class NGDirList{
  final List<String> files;
  final List<String> dirs;
  final List<String> links;

  const NGDirList({required this.files, required this.dirs, required this.links});
}

class FileEvent{
  final FileEventType type;
  final String path;

  const FileEvent(this.type, this.path);

  @override
  String toString() => "FileEvent: $type $path";
}
enum FileEventType{
  add,
  remove,
  modify,
}

abstract class NGeneralFileSystem{
  const NGeneralFileSystem();

  String? get path;

  String get name;

  NGeneralFileSystem at(String path);

  Future<bool> exists(String path);

  Future<bool> isFile(String path);

  Future<bool> isDir(String path);

  Future<bool> isLink(String path);

  Future<bool> identical(String path1, String path2);

  Future<NGFileStat> stat(String path);

  Future<NGDirList> list(String path, [bool recursive = false, bool followLinks = true]);

  Future<String> readString(String path, [Encoding encoding = utf8]);

  Future<List<String>> readLines(String path, [Encoding encoding = utf8]);

  Future<Uint8List> readBytes(String path);

  Stream<FileEvent> watch(String path);

  Future<FileSystemEntity> native(String path);
}