
import "dart:convert";
import "dart:io";
import "dart:typed_data";


Future<bool> exists(String path) async{
  final FileSystemEntityType type = await FileSystemEntity.type(path);
  const Set<FileSystemEntityType> test = {.file, .directory, .link};
  return test.contains(type);
}

Future<bool> isFile(String path){
  return FileSystemEntity.isFile(path);
}

Future<bool> isDir(String path){
  return FileSystemEntity.isDirectory(path);
}

Future<bool> isLink(String path){
  return FileSystemEntity.isLink(path);
}

Future<bool> identical(String path1, String path2){
  return FileSystemEntity.identical(path1, path2);
}

Future<Map<String, dynamic>> stat(String path) async{
  const String changedKeyToken = "changed";
  const String modifiedKeyToken = "modified";
  const String accessedKeyToken = "accessed";
  const String isFileKeyToken = "isFile";
  const String isDirKeyToken = "isDir";
  const String isLinkKeyToken = "isLink";
  const String modeKeyToken = "mode";
  const String sizeKeyToken = "size";
  final FileStat stat = await FileStat.stat(path);
  return {
    changedKeyToken: stat.changed,
    modifiedKeyToken: stat.modified,
    accessedKeyToken: stat.accessed,
    isFileKeyToken: stat.type == FileSystemEntityType.file,
    isDirKeyToken: stat.type == FileSystemEntityType.directory,
    isLinkKeyToken: stat.type == FileSystemEntityType.link,
    modeKeyToken: stat.mode,
    sizeKeyToken: stat.size,
  };
}

Future<Map<String, List<String>>> list(String path, [bool recursive = false, bool followLinks = true]) async{
  const String filesKeyToken = "files";
  const String dirsKeyToken = "dirs";
  const String linksKeyToken = "links";
  final Map<String, List<String>> res = {
    filesKeyToken: [],
    dirsKeyToken: [],
    linksKeyToken: [],
  };
  await for(final FileSystemEntity entity in Directory(path).list(recursive: recursive, followLinks: followLinks)){
    if(entity is File){
      res[filesKeyToken]!.add(entity.path);
    }else if(entity is Directory){
      res[dirsKeyToken]!.add(entity.path);
    }else if(entity is Link){
      res[linksKeyToken]!.add(entity.path);
    }
  }
  return res;
}

Future<String> readString(String path, [String encoding = "utf-8"]){
  final Encoding? enc = Encoding.getByName(encoding);
  if(enc == null){
    throw Exception("Invalid encoding");
  }
  return File(path).readAsString(encoding: enc);
}

Future<List<String>> readLines(String path, [String encoding = "utf-8"]){
  final Encoding? enc = Encoding.getByName(encoding);
  if(enc == null){
    throw Exception("Invalid encoding");
  }
  return File(path).readAsLines(encoding: enc);
}

Future<Uint8List> readBytes(String path){
  return File(path).readAsBytes();
}