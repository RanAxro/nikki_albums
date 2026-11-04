
part of "runner.dart";


class PluginJSRunner extends PluginRunner{
  final PluginJSRuntime _runtime;

  const PluginJSRunner._({required super.reader, required this._runtime});

  @override
  Future<List<Game>> searchGame(String uniqueId, NGeneralFileSystem fsHandler){
    return PluginJSBridge.searchGame(_runtime, uniqueId, fsHandler);
  }

  @override
  void dispose(){
    _runtime.dispose();
  }
}