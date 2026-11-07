
part of "runner.dart";


class PluginJSRunner extends PluginRunner{
  final PluginJSRuntime _runtime;

  const PluginJSRunner._({required super.reader, required this._runtime});

  @override
  Future<List<Game>> searchGame(String uuid, NGeneralFileSystem fsHandler){
    return PluginJSBridge.searchGame(_runtime, uuid, fsHandler);
  }

  @override
  void dispose(){
    _runtime.dispose();
  }
}