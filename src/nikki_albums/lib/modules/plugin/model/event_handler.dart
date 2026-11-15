import "package:nikki_albums/gen/rust/config/game.dart";

class PluginEventHandler{
  final String Function() onRequestPluginUuid;
  final void Function(GameRegistry gameRegistry) onRegisterGame;
  final void Function(Map<String, String> localeAndPathMap) onRegisterLoc;
  final void Function(Map<String, String> localeAndPathMap) onRegisterGlobalLoc;

  const PluginEventHandler({
    required this.onRequestPluginUuid,
    required this.onRegisterLoc,
    required this.onRegisterGlobalLoc,
    required this.onRegisterGame,
  });
}