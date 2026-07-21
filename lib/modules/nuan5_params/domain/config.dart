export "package:nikki_albums/src/rust/nuan5_database/model.dart";

import "package:nikki_albums/modules/hot_update/domain/hot_update_service.dart";
import "package:nikki_albums/src/rust/nuan5_database/model.dart";

import "dart:io";
import "package:path/path.dart" as p;


abstract class GlobalNuan5Config{
  static Nuan5Config? _config;

  static Future<String> getConfigPath() async{
    return p.join(await getHotUpdateAssetsPath("nuan5_database"), "v1.db");
  }

  static Future<bool> exist() async{
    final String path = await getConfigPath();
    return File(path).exists();
  }

  static Future<Nuan5Config?> init() async{
    if(_config != null){
      return _config;
    }

    final Nuan5Config? config = await Nuan5Config.tryFrom(path: await getConfigPath());

    if(config != null){
      _config = config;
    }

    return _config;
  }

  static Future<Nuan5Config?> reInit() async{
    _config = null;

    return init();
  }

  static bool get isInit => _config != null;

  static Nuan5Config? get config => _config;
}


extension Nuan5ConfigUtil on Nuan5Config{
  String? getImageUrl(Nuan5NetworkImageItem? item, dynamic value){
    if(item == null){
      return null;
    }
    return item.baseUrl.replaceAll(item.replace, value);
  }
}