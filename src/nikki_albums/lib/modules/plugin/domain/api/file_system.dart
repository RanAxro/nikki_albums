export "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";

import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";

import "dart:convert";
import "dart:typed_data";

import "package:uuid/v4.dart";


abstract final class PluginFileSystemHandler{
  static final Map<String, NGeneralFileSystem> _handler = {
    "": NNativeFileSystem.connect(""),
  };

  static String _getAvailableId(){
    final UuidV4 v4 = UuidV4();
    String id = "";
    do{
      id = v4.generate();
    }while(_handler.containsKey(id));
    return id;
  }

  static String add(NGeneralFileSystem handler){
    final String id = _getAvailableId();
    _handler[id] = handler;
    return id;
  }

  static NGeneralFileSystem get(String id){
    final NGeneralFileSystem? handler = _handler[id];
    if(handler == null){
      throw Exception("The FileSystemHandler does not exist");
    }
    return handler;
  }

  static NGeneralFileSystem? getOrNull(String id){
    return _handler[id];
  }

  static NGeneralFileSystem? remove(String id){
    return _handler.remove(id);
  }
}


String? path(String handlerId){
  return PluginFileSystemHandler.get(handlerId).path;
}

String name(String handlerId){
  return PluginFileSystemHandler.get(handlerId).name;
}

Future<bool> exists(String handlerId, String path){
  return PluginFileSystemHandler.get(handlerId).exists(path);
}

Future<bool> isFile(String handlerId, String path){
  return PluginFileSystemHandler.get(handlerId).isFile(path);
}

Future<bool> isDir(String handlerId, String path){
  return PluginFileSystemHandler.get(handlerId).isDir(path);
}

Future<bool> isLink(String handlerId, String path){
  return PluginFileSystemHandler.get(handlerId).isLink(path);
}

Future<bool> identical(String handlerId, String path1, String path2){
  return PluginFileSystemHandler.get(handlerId).identical(path1, path2);
}

Future<Map<String, dynamic>> stat(String handlerId, String path) async{
  const String changedKeyToken = "changed";
  const String modifiedKeyToken = "modified";
  const String accessedKeyToken = "accessed";
  const String isFileKeyToken = "isFile";
  const String isDirKeyToken = "isDir";
  const String isLinkKeyToken = "isLink";
  const String modeKeyToken = "mode";
  const String sizeKeyToken = "size";
  final NGFileStat stat = await PluginFileSystemHandler.get(handlerId).stat(path);
  return {
    changedKeyToken: stat.changed.millisecondsSinceEpoch,
    modifiedKeyToken: stat.modified.millisecondsSinceEpoch,
    accessedKeyToken: stat.accessed.millisecondsSinceEpoch,
    isFileKeyToken: stat.isFile,
    isDirKeyToken: stat.isDir,
    isLinkKeyToken: stat.isLink,
    modeKeyToken: stat.mode,
    sizeKeyToken: stat.size,
  };
}

Future<Map<String, List<String>>> list(String handlerId, String path, [bool recursive = false, bool followLinks = true]) async{
  const String filesKeyToken = "files";
  const String dirsKeyToken = "dirs";
  const String linksKeyToken = "links";
  final NGDirList dirList = await PluginFileSystemHandler.get(handlerId).list(path, recursive, followLinks);
  return {
    filesKeyToken: dirList.files,
    dirsKeyToken: dirList.dirs,
    linksKeyToken: dirList.links,
  };
}

Future<String> readString(String handlerId, String path, [String encoding = "utf-8"]){
  final Encoding? enc = Encoding.getByName(encoding);
  if(enc == null){
    throw Exception("Invalid encoding");
  }
  return PluginFileSystemHandler.get(handlerId).readString(path, enc);
}

Future<List<String>> readLines(String handlerId, String path, [String encoding = "utf-8"]){
  final Encoding? enc = Encoding.getByName(encoding);
  if(enc == null){
    throw Exception("Invalid encoding");
  }
  return PluginFileSystemHandler.get(handlerId).readLines(path, enc);
}

Future<Uint8List> readBytes(String handlerId, String path){
  return PluginFileSystemHandler.get(handlerId).readBytes(path);
}