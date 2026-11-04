export "reader/reader.dart";
export "runner/runner.dart";
export "../model/event_handler.dart";

import "runner/runner.dart";
import "reader/reader.dart";
import "../model/event_handler.dart";
import "../model/exception.dart";
import "package:nikki_albums/gen/rust/archive/zip/zip_archive.dart";

import "dart:io";

import "package:path/path.dart" as p;


class Plugin{
  final FileSystemEntity position;

  Plugin(this.position);


  Future<PluginReader> getReader() async{
    if(position is File){
      try{
        final ZipArchive zipArchive = await ZipArchive.openExisting(path: position.path);
        return ArchivePluginReader(zipArchive);
      }catch(_){
        throw InvalidPluginException();
      }
    }else if(position is Directory){
      return DirectoryPluginReader(position as Directory);
    }else{
      throw InvalidPluginException();
    }
  }

  Future<PluginRunner> getRunner(PluginEventHandler eventHandler, [PluginReader? reader]) async{
    return PluginRunner.init(
      reader: reader ?? await getReader(),
      permission: {},
      eventHandler: eventHandler,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Plugin && runtimeType == other.runtimeType &&
    p.equals(position.path, other.position.path);

  @override
  int get hashCode => p.hash(position.path);
}