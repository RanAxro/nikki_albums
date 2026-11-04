class PluginEventHandler{
  final String Function() onRequestPluginUuid;
  final void Function(String uniqueId) onRegisterGame;

  const PluginEventHandler({
    required this.onRequestPluginUuid,
    required this.onRegisterGame,
  });
}