
import "../app_registry.dart";
import "package:nikki_albums/utils/json.dart";
import "package:nikki_albums/modules/hot_update/domain/hot_update_service.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";

import "package:flutter/services.dart";
import "package:flutter/foundation.dart";
import "dart:convert";
import "dart:ui";

import "package:easy_localization/easy_localization.dart";
import "package:path/path.dart" as p;
import "package:msgpack_dart/msgpack_dart.dart" as msgpack;


const String _green = '\x1B[32m';
const String _reset = '\x1B[0m';



class AppLangAssetLoader extends AssetLoader{
  const AppLangAssetLoader();

  String getLocalePath(String basePath, String path, Locale locale, [String suffix = ".json"]){
    return p.posix.join(basePath, path, "${locale.toStringWithSeparator(separator: "-")}$suffix");
  }

  Future<Map<String, dynamic>> getLangJson(String basePath, String path, Locale locale) async{
    try{
      final String localePath = getLocalePath(basePath, path, locale);
      return json.decode(await rootBundle.loadString(localePath));
    }catch(e){
      return {};
    }
  }

  Future<Map<String, dynamic>> getHotUpdateLang(String id, Locale locale) async{
    try{
      final String localePath = getLocalePath(await getHotUpdateAssetsPath(id), "", locale, ".bin");
      
      final Uint8List? decrypted = await nuan5DataDecrypt(input: localePath);
      if(decrypted == null){
        return {};
      }

      final Map<String, dynamic> lang = Map<String, dynamic>.from(msgpack.deserialize(decrypted));
      if(kDebugMode){
        print("$_green HotUpdate Lang Loading Completed: $localePath $_reset");
      }

      return lang;
    }catch(e){
      if(kDebugMode){
        print(e);
      }
      return {};
    }
  }

  @override
  Future<Map<String, dynamic>?> load(String basePath, Locale locale) async{
    final Map<String, dynamic> baseLang = await getLangJson(basePath, "", locale);
    final List<Map<String, dynamic>> overlaysLang = [];

    for(final String path in AppRegistry.langFile){
      overlaysLang.add(await getLangJson(basePath, path, locale));
    }

    for(final String id in AppRegistry.hotUpdateLangId){
      overlaysLang.add(await getHotUpdateLang(id, locale));
    }

    mergeMultipleMapsInPlace(baseLang, overlaysLang);

    EasyLocalization.logger.debug("Load asset from $basePath");
    return baseLang;
  }
}
