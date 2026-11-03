
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

Future<bool> isDirectory(String path){
  return FileSystemEntity.isDirectory(path);
}

Future<bool> isLink(String path){
  return FileSystemEntity.isLink(path);
}

Future<bool> identical(String path1, String path2){
  return FileSystemEntity.identical(path1, path2);
}

Future<FileStat> stat(String path){
  return FileStat.stat(path);
}

Future<Map<String, List<String>>> list(String path, [bool recursive = false, bool followLinks = true]) async{
  final Map<String, List<String>> res = {};
  await for(final FileSystemEntity entity in Directory(path).list(recursive: recursive, followLinks: followLinks)){
    if(entity is File){
      (res["files"] ??= []).add(entity.path);
    }else if(entity is Directory){
      (res["dirs"] ??= []).add(entity.path);
    }else if(entity is Link){
      (res["links"] ??= []).add(entity.path);
    }
  }
  return res;
}

Future<String> readString(String path, [String encoding = "utf8"]){
  final Encoding? enc = Encoding.getByName(encoding);
  if(enc == null){
    throw Exception("Invalid encoding");
  }
  return File(path).readAsString(encoding: enc);
}

Future<List<String>> readLines(String path, [String encoding = "utf8"]){
  final Encoding? enc = Encoding.getByName(encoding);
  if(enc == null){
    throw Exception("Invalid encoding");
  }
  return File(path).readAsLines(encoding: enc);
}

Future<Uint8List> readBytes(String path){
  return File(path).readAsBytes();
}