
import "../plugin_helper.dart";
import "../../model/event_handler.dart";
import "package:nikki_albums/gen/rust/config/game.dart";

import "dart:convert";


void registerLoc(Map<String, String> localeAndPathMap, PluginEventHandler eventHandler){
  eventHandler.onRegisterLoc(localeAndPathMap);
}

void registerGlobalLoc(Map<String, String> localeAndPathMap, PluginEventHandler eventHandler){
  eventHandler.onRegisterGlobalLoc(localeAndPathMap);
}

void registerGame(Map info, PluginEventHandler eventHandler){
  final GameRegistry gameRegistry = GameRegistry.fromJson(json: jsonEncode(info));
  PluginHelper.isValidUuidOrThrow(gameRegistry.uuid);
  final String ownership = eventHandler.onRequestPluginUuid();
  eventHandler.onRegisterGame(gameRegistry.copyWith(ownership: ownership));
}

