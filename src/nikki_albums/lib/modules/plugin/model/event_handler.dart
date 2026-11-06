import "package:nikki_albums/gen/rust/config/game.dart";

class PluginEventHandler{
  final String Function() onRequestPluginUuid;
  final void Function(GameRegistry gameRegistry) onRegisterGame;

  const PluginEventHandler({
    required this.onRequestPluginUuid,
    required this.onRegisterGame,
  });
}