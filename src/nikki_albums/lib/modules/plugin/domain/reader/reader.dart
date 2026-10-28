
export "directory_plugin_reader.dart";
export "archive_plugin_reader.dart";
export "package:nikki_albums/gen/rust/config/plugin.dart";


import "package:nikki_albums/gen/rust/config/plugin.dart";

import "dart:typed_data";
import "dart:convert";


abstract class PluginReader{
  const PluginReader();

  String get infoFileName => "info.json";

  Future<bool> isValid() async{
    try{
      await readInfo();
      return true;
    }catch(_){
      return false;
    }
  }

  Future<PluginInfo> readInfo();

  Future<bool> existFile(String filename);

  Future<Uint8List> readFile(String filename);

  Future<String> readFileAsString(String filename) async{
    final Uint8List bytes = await readFile(filename);
    return utf8.decode(bytes);
  }
}