
part of "runner.dart";


class PluginJSRunner extends PluginRunner{
  final PluginJSRuntime _runtime;

  const PluginJSRunner._({required super.reader, required this._runtime});

  @override
  Future<List<Game>> searchGame(String uniqueId, NGeneralFileSystem fsHandler){
    return PluginJSBridge.searchGame(_runtime, uniqueId, fsHandler);
  }

  @override
  Future<Game?> getGameByPath(String uniqueId, NGeneralFileSystem fsHandler, String path){
    return PluginJSBridge.getGameByPath(_runtime, uniqueId, fsHandler, path);
  }

  @override
  Future<TextRule> getGameName(Game game){
    return PluginJSBridge.getGameName(_runtime, game);
  }

  @override
  Future<IconRule?> getGameIcon(Game game){
    return PluginJSBridge.getGameIcon(_runtime, game);
  }

  @override
  Future<List<String>> searchAccount(NGeneralFileSystem fsHandler, Game game){
    return PluginJSBridge.searchAccount(_runtime, fsHandler, game);
  }

  @override
  Future<TextRule?> getAccountName(NGeneralFileSystem fsHandler, Game game, String account){
    return PluginJSBridge.getAccountName(_runtime, fsHandler, game, account);
  }

  @override
  Future<ImageRule?> getAccountAvatar(NGeneralFileSystem fsHandler, Game game, String account){
    return PluginJSBridge.getAccountAvatar(_runtime, fsHandler, game, account);
  }

  @override
  void dispose(){
    _runtime.dispose();
  }
}