
import "../../model/event_handler.dart";


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

String registerGame(Map<String, String> info, PluginEventHandler eventHandler){
  if(!info.containsKey("uuid")){
    throw Exception("Field missing: uuid");
  }
  final String pluginUuid = eventHandler.onRequestPluginUuid();
  final String uniqueId = "$pluginUuid|${info["uuid"]}";
  eventHandler.onRegisterGame(uniqueId);
  return uniqueId;
}

