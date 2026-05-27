
import "package:nikki_albums/src/rust/serde_config/de.dart";
import "package:nikki_albums/src/rust/serde_config/structs/plugin_info.dart";
import "package:nikki_albums/src/rust/serde_config/structs/game_config.dart";

import "../model/plugin_data.dart";

import "dart:io";

import "package:path_provider/path_provider.dart";
import "package:path/path.dart" as p;

Future<Directory> getPluginParentDirectory() async{
  if(Platform.isWindows || Platform.isLinux){
    return File(Platform.resolvedExecutable).parent;
  }else{
    return getApplicationSupportDirectory();
  }
}

Future<Directory> getPluginDirectory() async{
  final Directory dir = await getPluginParentDirectory();

  return Directory(p.join(dir.path, "plugins"));
}


Future<PluginData?> loadPlugin(Directory pluginPath) async{
  bool enable = true;
  File? pluginInfoFile;
  Directory? langDir;
  Directory? iconDir;
  Directory? gameConfigDir;

  await for(final FileSystemEntity entity in pluginPath.list()){
    if(entity is File){
      // disable.txt
      if(p.basename(entity.path) == "disable.txt"){
        enable = false;
      }
      // plugin.json
      if(p.basename(entity.path) == "plugin.json"){
        pluginInfoFile = entity;
      }
    }else if(entity is Directory){
      // lang
      if(p.basename(entity.path) == "lang"){
        langDir = entity;
      }
      // icon
      else if(p.basename(entity.path) == "icon"){
        iconDir = entity;
      }
      // game_config
      else if(p.basename(entity.path) == "game_config"){
        gameConfigDir = entity;
      }
    }
  }

  if(pluginInfoFile == null){
    return null;
  }

  final PluginInfo pluginInfo = await decodePluginInfoFile(path: pluginInfoFile.path);

  final Map<String, String> langPathList = {};
  final Map<String, String> iconPathList = {};
  final List<GameConfig> gameConfigList = [];

  if(langDir != null){
    await for(final FileSystemEntity entity in langDir.list()){
      if(entity is! File) continue;

      langPathList[p.basenameWithoutExtension(entity.path)] = entity.path;
    }
  }

  if(iconDir != null){
    await for(final FileSystemEntity entity in iconDir.list()){
      if(entity is! File) continue;

      iconPathList[p.basename(entity.path)] = entity.path;
    }
  }

  if(gameConfigDir != null){
    await for(final FileSystemEntity entity in gameConfigDir.list()){
      if(entity is! File) continue;

      final GameConfig gameConfig = await decodeGameConfigFile(path: entity.path);

      gameConfigList.add(gameConfig);
    }
  }

  return PluginData(
    enable: enable,
    info: pluginInfo,
    langPathList: langPathList,
    iconPathList: iconPathList,
    gameConfigList: gameConfigList,
    themeList: [],
  );
}