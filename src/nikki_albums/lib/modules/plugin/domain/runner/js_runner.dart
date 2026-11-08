
part of "runner.dart";


class PluginJSRunner extends PluginRunner{
  final PluginJSRuntime _runtime;

  const PluginJSRunner._({required super.reader, required this._runtime});

  @override
  Future<List<Game>> searchGame(String uniqueId, NGeneralFileSystem fsHandler){
    return PluginJSBridge.searchGame(_runtime, uniqueId, fsHandler);
  }

  @override
  Future<TextRule> getGameName(Game game){
    return PluginJSBridge.getGameName(_runtime, game);
  }

  @override
  Future<IconRule> getGameIcon(Game game){
    return PluginJSBridge.getGameIcon(_runtime, game);
  }

  @override
  Future<List<String>> searchAccount(NGeneralFileSystem fsHandler, Game game) {
    return PluginJSBridge.searchAccount(_runtime, fsHandler, game);
  }

  @override
  void dispose(){
    _runtime.dispose();
  }
}