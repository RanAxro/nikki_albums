
export "reader/reader.dart";

import "reader/reader.dart";
import "package:nikki_albums/modules/plugin/model/exception.dart";
import "package:nikki_albums/gen/rust/archive/zip/zip_archive.dart";


import "dart:io";


class Plugin{
  final FileSystemEntity position;

  Plugin(this.position);


  PluginReader? _reader;

  PluginReader? get reader => _reader;

  Future<PluginReader> read() async{
    if(position is File){
      try{
        final ZipArchive zipArchive = await ZipArchive.openExisting(path: position.path);
        return _reader = ArchivePluginReader(zipArchive);
      }catch(_){
        throw InvalidPluginException();
      }
    }else if(position is Directory){
      return _reader = DirectoryPluginReader(position as Directory);
    }else{
      throw InvalidPluginException();
    }
  }
}