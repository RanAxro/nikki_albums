
import "../app_registry.dart";
import "package:nikki_albums/utils/json.dart";

import "package:flutter/services.dart";
import "dart:convert";
import "dart:ui";

import "package:easy_localization/easy_localization.dart";
import "package:path/path.dart" as p;


class AppLangAssetLoader extends AssetLoader{
  const AppLangAssetLoader();

  String getLocalePath(String basePath, String path, Locale locale){
    return p.posix.join(basePath, path, "${locale.toStringWithSeparator(separator: "-")}.json");
  }

  Future<Map<String, dynamic>> getLangJson(String basePath, String path, Locale locale) async{
    try{
      final String localePath = getLocalePath(basePath, path, locale);
      return json.decode(await rootBundle.loadString(localePath));
    }catch(e){
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

    mergeMultipleMapsInPlace(baseLang, overlaysLang);

    EasyLocalization.logger.debug("Load asset from $basePath");
    return baseLang;
  }
}
