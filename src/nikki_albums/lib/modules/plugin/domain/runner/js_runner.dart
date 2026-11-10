
part of "runner.dart";


class PluginJSRunner extends PluginRunner{
  final PluginJSRuntime _runtime;

  const PluginJSRunner._({required super.reader, required this._runtime});

  @override
  Future<List<DeviceGame>> searchDeviceGame(String uniqueId, NGeneralFileSystem fsHandler){
    return PluginJSBridge.searchDeviceGame(_runtime, uniqueId, fsHandler);
  }

  @override
  Future<PickedDeviceGameResult> notifyPickDeviceGame(String uniqueId, NGeneralFileSystem fsHandler, String name){
    return PluginJSBridge.notifyPickDeviceGame(_runtime, uniqueId, fsHandler, name);
  }

  @override
  Future<TextRule> getDeviceGameName(DeviceGame deviceGame){
    return PluginJSBridge.getDeviceGameName(_runtime, deviceGame);
  }

  @override
  Future<IconRule?> getDeviceGameIcon(DeviceGame deviceGame){
    return PluginJSBridge.getDeviceGameIcon(_runtime, deviceGame);
  }

  @override
  Future<List<String>> searchAccount(NGeneralFileSystem fsHandler, DeviceGame deviceGame){
    return PluginJSBridge.searchAccount(_runtime, fsHandler, deviceGame);
  }

  @override
  Future<TextRule?> getAccountName(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String account){
    return PluginJSBridge.getAccountName(_runtime, fsHandler, deviceGame, account);
  }

  @override
  Future<ImageRule?> getAccountAvatar(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String account){
    return PluginJSBridge.getAccountAvatar(_runtime, fsHandler, deviceGame, account);
  }

  @override
  void dispose(){
    _runtime.dispose();
  }
}