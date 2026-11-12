
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
  Future<AddedCustomAccountResult> notifyAddCustomAccount(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String account){
    return PluginJSBridge.notifyAddCustomAccount(_runtime, fsHandler, deviceGame, account);
  }

  @override
  Future<Map<String, List<String>>> searchAlbum(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account){
    return PluginJSBridge.searchAlbum(_runtime, fsHandler, deviceGame, account);
  }

  @override
  TextRule getAlbumCategoryName(DeviceGame deviceGame, String? account, String category){
    return PluginJSBridge.getAlbumCategoryName(_runtime, deviceGame, account, category);
  }

  @override
  TextRule getAlbumName(DeviceGame deviceGame, String? account, String category, String albumType){
    return PluginJSBridge.getAlbumName(_runtime, deviceGame, account, category, albumType);
  }

  @override
  TextRule? getAlbumDescription(DeviceGame deviceGame, String? account, String category, String albumType){
    return PluginJSBridge.getAlbumDescription(_runtime, deviceGame, account, category, albumType);
  }

  @override
  IconRule? getAlbumIcon(DeviceGame deviceGame, String? account, String category, String albumType){
    return PluginJSBridge.getAlbumIcon(_runtime, deviceGame, account, category, albumType);
  }

  @override
  Future<String> getAlbumPath(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType){
    return PluginJSBridge.getAlbumPath(_runtime, fsHandler, deviceGame, account, category, albumType);
  }

  @override
  Future<String?> getAlbumMediaIfFile(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String filePath){
    return PluginJSBridge.getAlbumMediaIfFile(_runtime, fsHandler, deviceGame, account, category, albumType, filePath);
  }

  @override
  Future<String?> getAlbumMediaIfDir(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String dirPath){
    return PluginJSBridge.getAlbumMediaIfDir(_runtime, fsHandler, deviceGame, account, category, albumType, dirPath);
  }

  @override
  Future<String?> getAlbumMediaCoverIfFile(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String filePath){
    return PluginJSBridge.getAlbumMediaCoverIfFile(_runtime, fsHandler, deviceGame, account, category, albumType, filePath);
  }

  @override
  Future<String?> getAlbumMediaCoverIfDir(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String dirPath){
    return PluginJSBridge.getAlbumMediaCoverIfDir(_runtime, fsHandler, deviceGame, account, category, albumType, dirPath);
  }

  @override
  Future<String?> getAlbumMediaThumbnailIfFile(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String filePath){
    return PluginJSBridge.getAlbumMediaThumbnailIfFile(_runtime, fsHandler, deviceGame, account, category, albumType, filePath);
  }

  @override
  Future<String?> getAlbumMediaThumbnailIfDir(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String dirPath){
    return PluginJSBridge.getAlbumMediaThumbnailIfDir(_runtime, fsHandler, deviceGame, account, category, albumType, dirPath);
  }

  @override
  void dispose(){
    _runtime.dispose();
  }
}