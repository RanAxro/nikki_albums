
part of "runner.dart";


class PluginJSRunner extends PluginRunner{
  final PluginJSRuntime _runtime;

  const PluginJSRunner._({required super.reader, required this._runtime});

  @override
  Future<List<Game>> searchGame(String id, NGeneralFileSystem fsHandler){
    return PluginJSBridge.searchGame(_runtime, id, fsHandler);
  }

  @override
  void dispose(){
    _runtime.dispose();
  }
}