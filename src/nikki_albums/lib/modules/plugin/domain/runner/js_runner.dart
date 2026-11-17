
import "runner.dart";
import "../runtime/js_runtime.dart";
import "../ffi/js/js_bridge.dart";
import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";
import "package:nikki_albums/modules/config_helper/model/image_rule.dart";
import "package:nikki_albums/gen/rust/config/plugin.dart";
import "package:nikki_albums/gen/rust/config/game.dart";
import "package:nikki_albums/gen/rust/config/rules/text_rule.dart";
import "package:nikki_albums/gen/rust/config/rules/icon_rule.dart";


class PluginJSRunner extends PluginRunner{
  final PluginJSRuntime _runtime;

  const PluginJSRunner({required super.reader, required this._runtime});

  @override
  Future<List<DeviceGame>> searchDeviceGame(String uniqueId, NGeneralFileSystem fsHandler){
    return PluginJSBridge.searchDeviceGame(_runtime, uniqueId, fsHandler);
  }

  @override
  Future<PickedDeviceGameResult> notifyPickDeviceGame(String uniqueId, NGeneralFileSystem fsHandler, String name){
    return PluginJSBridge.notifyPickDeviceGame(_runtime, uniqueId, fsHandler, name);
  }

  @override
  TextRule getDeviceGameName(DeviceGame deviceGame){
    return PluginJSBridge.getDeviceGameName(_runtime, deviceGame);
  }

  @override
  IconRule? getDeviceGameIcon(DeviceGame deviceGame){
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
  Future<List<String>> searchAlbum(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account){
    return PluginJSBridge.searchAlbum(_runtime, fsHandler, deviceGame, account);
  }

  @override
  String getAlbumCategory(DeviceGame deviceGame, String? account, String albumType){
    return PluginJSBridge.getAlbumCategory(_runtime, deviceGame, account, albumType);
  }

  @override
  TextRule getAlbumCategoryName(DeviceGame deviceGame, String? account, String category){
    return PluginJSBridge.getAlbumCategoryName(_runtime, deviceGame, account, category);
  }

  @override
  TextRule getAlbumName(DeviceGame deviceGame, String? account, String albumType){
    return PluginJSBridge.getAlbumName(_runtime, deviceGame, account, albumType);
  }

  @override
  TextRule? getAlbumDescription(DeviceGame deviceGame, String? account, String albumType){
    return PluginJSBridge.getAlbumDescription(_runtime, deviceGame, account, albumType);
  }

  @override
  IconRule? getAlbumIcon(DeviceGame deviceGame, String? account, String albumType){
    return PluginJSBridge.getAlbumIcon(_runtime, deviceGame, account, albumType);
  }

  @override
  Future<String> getAlbumPath(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String albumType){
    return PluginJSBridge.getAlbumPath(_runtime, fsHandler, deviceGame, account, albumType);
  }

  @override
  Future<String?> getAlbumMediaIfFile(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String albumType, String filePath){
    return PluginJSBridge.getAlbumMediaIfFile(_runtime, fsHandler, deviceGame, account, albumType, filePath);
  }

  @override
  Future<String?> getAlbumMediaIfDir(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String albumType, String dirPath){
    return PluginJSBridge.getAlbumMediaIfDir(_runtime, fsHandler, deviceGame, account, albumType, dirPath);
  }

  @override
  Future<String?> getAlbumMediaCoverIfFile(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String albumType, String filePath){
    return PluginJSBridge.getAlbumMediaCoverIfFile(_runtime, fsHandler, deviceGame, account, albumType, filePath);
  }

  @override
  Future<String?> getAlbumMediaCoverIfDir(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String albumType, String dirPath){
    return PluginJSBridge.getAlbumMediaCoverIfDir(_runtime, fsHandler, deviceGame, account, albumType, dirPath);
  }

  @override
  Future<String?> getAlbumMediaThumbnailIfFile(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String albumType, String filePath){
    return PluginJSBridge.getAlbumMediaThumbnailIfFile(_runtime, fsHandler, deviceGame, account, albumType, filePath);
  }

  @override
  Future<String?> getAlbumMediaThumbnailIfDir(NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String albumType, String dirPath){
    return PluginJSBridge.getAlbumMediaThumbnailIfDir(_runtime, fsHandler, deviceGame, account, albumType, dirPath);
  }

  @override
  void dispose(){
    _runtime.dispose();
  }
}