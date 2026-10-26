
import "reader.dart";
import "package:nikki_albums/gen/rust/archive/zip/zip_archive.dart";

import "dart:typed_data";


class ArchivePluginReader extends PluginReader{
  final ZipArchive _archive;

  const ArchivePluginReader(this._archive);

  @override
  Future<PluginInfo> readInfo() async{
    final Uint8List bytes = await _archive.readByName(name: infoFileName);
    return PluginInfo.fromJsonBytes(json: bytes);
  }

  @override
  Future<bool> existFile(String filename){
    return _archive.contains(name: filename);
  }

  @override
  Future<Uint8List> readFile(String filename){
    return _archive.readByName(name: filename);
  }
}