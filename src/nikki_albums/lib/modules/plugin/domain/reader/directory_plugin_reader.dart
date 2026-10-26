
import "reader.dart";
import "../../model/exception.dart";

import "dart:io";
import "dart:typed_data";

import "package:path/path.dart" as p;


class DirectoryPluginReader extends PluginReader{
  final Directory _directory;

  const DirectoryPluginReader(this._directory);

  @override
  Future<PluginInfo> readInfo() async{
    final String infoPath = p.join(_directory.path, infoFileName);
    final File infoFile = File(infoPath);
    final Uint8List bytes = await infoFile.readAsBytes();
    return PluginInfo.fromJsonBytes(json: bytes);
  }

  @override
  Future<bool> existFile(String filename) async{
    final target = p.normalize(p.join(_directory.path, filename));
    if(!p.isWithin(_directory.path, target)){
      return false;
    }

    return File(target).exists();
  }

  @override
  Future<Uint8List> readFile(String filename) async{
    final target = p.normalize(p.join(_directory.path, filename));
    if(!p.isWithin(_directory.path, target)){
      throw FailedReadFileException(_directory.path, filename);
    }

    return File(target).readAsBytes();
  }
}