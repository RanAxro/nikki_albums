
part of "runner.dart";


class PluginJSRunner extends PluginRunner{
  final PluginJSRuntime _runtime;

  const PluginJSRunner._({required super.reader, required this._runtime});

  @override
  Future<List<Game>> searchGame(String id){
    return PluginJSBridge.searchGame(_runtime, id);
  }

  @override
  void dispose(){
    _runtime.dispose();
  }
}