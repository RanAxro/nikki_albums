
export "package:nikki_albums/src/rust/config/common/file_reader_config.dart";

import "package:nikki_albums/src/rust/config/common/file_reader_config.dart";

import "dart:convert";
import "dart:io";

import "package:ini/ini.dart" as ini;


abstract final class FileReaderConfigHelper{
  static Future<Map<String, dynamic>?> resolveFromConfig(FileReaderConfig config){
    return switch(config.fileType){
      FileType.json => readJson(config.path, config.keys),
      FileType.ini => readIni(config.path, config.keys),
    };
  }

  static Future<Map<String, dynamic>?> readJson(String path, Map<String, String> keys) async{
    late final dynamic jsonConfig;
    try{
      final String jsonString = await File(path).readAsString();
      jsonConfig = jsonDecode(jsonString);
    }catch(e){
      return null;
    }

    final Map<String, dynamic> res = {};
    for(final MapEntry<String, String> entity in keys.entries){
      final String id = entity.key;
      final String key = entity.value;

      if(key.isEmpty){
        res[id] = jsonConfig;
        continue;
      }

      final List<String> parts = key.split(".");
      dynamic current = jsonConfig;
      bool found = true;

      for(final String part in parts){
        if(current is Map){
          // Map 访问
          if(!current.containsKey(part)){
            found = false;
            break;
          }
          current = current[part];
        }else if(current is List){
          // List 索引访问
          final int? index = int.tryParse(part);
          if(index == null || index < 0 || index >= current.length){
            found = false;
            break;
          }
          current = current[index];
        }else{
          // 既不是 Map 也不是 List，路径未走完但无法继续深入
          found = false;
          break;
        }
      }

      if(found){
        res[id] = current;
      }
    }

    return res;
  }

  static Future<Map<String, dynamic>?> readIni(String path, Map<String, String> keys) async{
    late final ini.Config iniConfig;
    try{
      final List<String >iniLines = await File(path).readAsLines();
      iniConfig = ini.Config.fromStrings(iniLines);
    }catch(e){
      return null;
    }

    final Map<String, dynamic> res = {};
    for(final MapEntry<String, String> entity in keys.entries){
      final String id = entity.key;
      final String key = entity.value;

      final List<String> parts = key.split(".");
      if(parts.length < 2){
        continue;
      }

      final String section = parts[0];
      // 支持 option 名本身包含点，如 "section.some.key" -> section="section", option="some.key"
      final String option = parts.sublist(1).join(".");

      final String? value = iniConfig.get(section, option);
      if(value != null){
        res[id] = value;
      }
    }

    return res;
  }
}