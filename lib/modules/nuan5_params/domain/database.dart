export "package:nikki_albums/src/rust/nuan5_database/reader_v1.dart";

import "package:nikki_albums/modules/hot_update/domain/hot_update_service.dart";
import "package:nikki_albums/src/rust/nuan5_database/reader_v1.dart";

import "dart:io";
import "package:path/path.dart" as p;


abstract class Nuan5Data{
  static Nuan5DatabaseReaderV1? _reader;

  static Future<String> getV1DatabasePath() async{
    return p.join(await getHotUpdateAssetsPath("nuan5_database"), "v1.db");
  }

  static Future<bool> exist() async{
    final String path = await getV1DatabasePath();
    return File(path).exists();
  }

  static Future<Nuan5DatabaseReaderV1?> init() async{
    if(_reader != null){
      return _reader;
    }

    final Nuan5DatabaseReaderV1 reader = Nuan5DatabaseReaderV1();
    final bool isOpen = await reader.open(path: await getV1DatabasePath());

    if(isOpen){
      _reader = reader;
    }

    return reader;
  }

  static Future<Nuan5DatabaseReaderV1?> reInit() async{
    await _reader?.close();
    _reader = null;

    return init();
  }

  static bool get isInit => _reader != null;

  static Nuan5DatabaseReaderV1? get reader => _reader;
}