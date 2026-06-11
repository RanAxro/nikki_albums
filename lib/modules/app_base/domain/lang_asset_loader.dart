
import "package:flutter/foundation.dart";

import "../app_registry.dart";
import "package:nikki_albums/utils/json.dart";
import "package:nikki_albums/modules/hot_update/domain/hot_update_service.dart";

import "package:flutter/services.dart";
import "dart:convert";
import "dart:ui";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:path/path.dart" as p;
import 'package:encrypt/encrypt.dart' as encrypt;


const String _green = '\x1B[32m';
const String _reset = '\x1B[0m';

class LangFileAesUtil{
  static final _key = encrypt.Key.fromUtf8("D122401AEA30AFE6DE23566BABAF2569");
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));

  static Future<void> encryptFile(String inputPath, String outputPath) async{
    final File file = File(inputPath);
    final Uint8List bytes = await file.readAsBytes();

    // 生成随机 IV
    final encrypt.IV iv = encrypt.IV.fromSecureRandom(16);

    // 加密
    final encrypt.Encrypted encrypted = _encrypter.encryptBytes(bytes, iv: iv);

    // 写入文件：IV(16字节) + 密文
    final File output = File(outputPath);
    await output.writeAsBytes([...iv.bytes, ...encrypted.bytes]);
  }

  static Future<List<int>> decryptFile(String inputPath) async{
    final File file = File(inputPath);
    final Uint8List bytes = await file.readAsBytes();

    final encrypt.IV iv = encrypt.IV(Uint8List.fromList(bytes.sublist(0, 16)));
    final encrypt.Encrypted encrypted = encrypt.Encrypted(Uint8List.fromList(bytes.sublist(16)));

    final List<int> decrypted = _encrypter.decryptBytes(encrypted, iv: iv);

    return decrypted;
  }
}



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

  Future<Map<String, dynamic>> getHotUpdateLangJson(String id, Locale locale) async{
    try{
      final String localePath = getLocalePath(await getHotUpdateAssetsPath(id), "", locale);
      final List<int> decrypted = await LangFileAesUtil.decryptFile(localePath);
      final String jsonString = utf8.decode(decrypted);
      final Map<String, dynamic> langJson = json.decode(jsonString);

      if(kDebugMode){
        print("$_green HotUpdate Lang Loading Completed: $localePath $_reset");
      }

      return langJson;
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

    for(final String id in AppRegistry.hotUpdateLangId){
      overlaysLang.add(await getHotUpdateLangJson(id, locale));
    }

    mergeMultipleMapsInPlace(baseLang, overlaysLang);

    EasyLocalization.logger.debug("Load asset from $basePath");
    return baseLang;
  }
}
