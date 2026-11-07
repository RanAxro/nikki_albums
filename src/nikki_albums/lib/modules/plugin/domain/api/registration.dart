
import "../plugin_helper.dart";
import "../../model/event_handler.dart";
import "package:nikki_albums/gen/rust/config/game.dart";

import "dart:convert";


void registerLoc(Map<String, String> localeAndPathMap){
  print("register sus $localeAndPathMap");
}

void registerGlobalLoc(Map<String, String> localeAndPathMap){

}

void registerIcon(List<String> iconPaths){
  print("register icon sus $iconPaths");

}

void registerGlobalIcon(List<String> iconPaths){

}

void registerFont(Map<String, String> fontFamilyAndPathMap){

}

void registerGlobalFont(Map<String, String> fontFamilyAndPathMap){

}

void registerGame(Map info, PluginEventHandler eventHandler){
  final GameRegistry gameRegistry = GameRegistry.fromJson(json: jsonEncode(info));
  PluginHelper.isValidUuidOrThrow(gameRegistry.uuid);
  final String ownership = eventHandler.onRequestPluginUuid();
  eventHandler.onRegisterGame(gameRegistry.copyWith(ownership: ownership));
}

