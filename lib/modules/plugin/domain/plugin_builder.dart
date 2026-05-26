
import "dart:convert";

import "../model/plugin_builder_config.dart";
import "package:nikki_albums/src/rust/serde_config/se.dart";
import "package:nikki_albums/src/rust/serde_config/structs/game_config.dart";

import "dart:io";
import "dart:typed_data";

import "package:path/path.dart" as p;


void buildPlugin(PluginBuilderConfig config, Directory output) async{

  if(config.info.id == "") return;

  final String pluginPath = p.join(output.path, config.info.id);
  final Directory pluginDir = Directory(pluginPath);

  if(await pluginDir.exists()){
    await pluginDir.delete(recursive: true);
  }
  await pluginDir.create(recursive: true);

  final Uint8List infoBytes = await serializePluginInfo(value: config.info, pretty: true);
  await File(p.join(pluginPath, "plugin.json")).create(recursive: true);
  await File(p.join(pluginPath, "plugin.json")).writeAsBytes(infoBytes);

  for(final MapEntry<String, dynamic> langEntry in config.languageList.entries){
    final String jsonStr = jsonEncode(langEntry.value);
    await File(p.join(pluginPath, "lang", "${langEntry.key}.json")).create(recursive: true);
    await File(p.join(pluginPath, "lang", "${langEntry.key}.json")).writeAsString(jsonStr);
  }

  for(final String icon in config.iconList){

  }

  for(final GameConfig gameConfig in config.gameConfigList){
    final Uint8List gameConfigBytes = await serializeGameConfig(value: gameConfig, pretty: true);
    await File(p.join(pluginPath, "game_config", "${gameConfig.id}.json")).create(recursive: true);
    await File(p.join(pluginPath, "game_config", "${gameConfig.id}.json")).writeAsBytes(gameConfigBytes);
  }
}