
import "package:flutter/services.dart";
import "dart:convert";
import "dart:ui";

import "package:easy_localization/easy_localization.dart";
import "package:nikki_albums/utils/json.dart";
import "package:path/path.dart" as p;


class AppLocalizationAssetLoader extends AssetLoader{
  // <uuid, <locale, loc>>
  static Map<String, Map<String, Map<String, dynamic>>> pluginRegisterLoc = {};
  static Map<String, Map<String, Map<String, dynamic>>> pluginRegisterGlobalLoc = {};

  const AppLocalizationAssetLoader();

  String getLocalePath(String basePath, Locale locale){
    String path = p.posix.join(basePath, locale.toStringWithSeparator(separator: "-"));
    path = p.setExtension(path, ".json");
    return path;
  }

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async{
    final String localePath = getLocalePath(path, locale);
    EasyLocalization.logger.debug("Load $locale asset from $path");
    final Map<String, dynamic> baseLoc = jsonDecode(await rootBundle.loadString(localePath));

    final String localeStr = locale.toStringWithSeparator(separator: "-");
    baseLoc["__plugin"] = <String, dynamic>{};
    (baseLoc["__plugin"] as Map<String, dynamic>).addAll(pluginRegisterLoc.map((k, v) => MapEntry(k, v[localeStr])));
    mergeMultipleMapsInPlace(baseLoc, pluginRegisterGlobalLoc.values.map((l) => l[localeStr] ?? {}));

    return baseLoc;
  }
}