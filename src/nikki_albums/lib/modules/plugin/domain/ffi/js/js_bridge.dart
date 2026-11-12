
import "js_caller.dart";
import "../../api/file_system.dart";
import "../../runtime/js_runtime.dart";
import "../../../model/exception.dart";
import "package:nikki_albums/modules/config_helper/domain/config_helper.dart";
import "package:nikki_albums/modules/config_helper/model/image_rule.dart";
import "package:nikki_albums/modules/plugin/model/game_helper.dart";
import "package:nikki_albums/gen/rust/config/game.dart";
import "package:nikki_albums/gen/rust/config/rules/icon_rule.dart";
import "package:nikki_albums/gen/rust/config/rules/text_rule.dart";
import "package:nikki_albums/gen/rust/config/rules/image_rule.dart" as rust;
import "package:nikki_albums/gen/rust/config/plugin.dart";

import "dart:convert";

import "package:quickjs_engine/quickjs_engine.dart";


abstract final class PluginJSBridge{
  static Future<List<DeviceGame>> searchDeviceGame(PluginJSRuntime runtime, String uniqueId, NGeneralFileSystem fsHandler) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(uniqueId);
    final JsEvalResult result = await PluginJSCaller.searchDeviceGame(runtime, uuid, uniqueId, fsHandlerId);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return DeviceGame.fromVecJson(json: result.stringResult);
  }

  static Future<PickedDeviceGameResult> notifyPickDeviceGame(PluginJSRuntime runtime, String uniqueId, NGeneralFileSystem fsHandler, String name) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(uniqueId);
    final JsEvalResult result = await PluginJSCaller.notifyPickDeviceGame(runtime, uuid, uniqueId, fsHandlerId, name);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return PickedDeviceGameResult.fromJson(json: result.stringResult);
  }

  static Future<TextRule> getDeviceGameName(PluginJSRuntime runtime, DeviceGame deviceGame) async{
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getDeviceGameName(runtime, uuid, deviceGameJson);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return TextRule.fromJson(json: result.stringResult);
  }

  static Future<IconRule?> getDeviceGameIcon(PluginJSRuntime runtime, DeviceGame deviceGame) async{
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getDeviceGameIcon(runtime, uuid, deviceGameJson);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    if(result.stringResult == "null"){
      return null;
    }
    return IconRule.fromJson(json: result.stringResult);
  }

  static Future<List<String>> searchAccount(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.searchAccount(runtime, uuid, fsHandlerId, deviceGameJson);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return List<String>.from(jsonDecode(result.stringResult));
  }

  static Future<TextRule?> getAccountName(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String account) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getAccountName(runtime, uuid, fsHandlerId, deviceGameJson, account);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    if(result.stringResult == "null"){
      return null;
    }
    return TextRule.fromJson(json: result.stringResult);
  }

  static Future<ImageRule?> getAccountAvatar(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String account) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getAccountAvatar(runtime, uuid, fsHandlerId, deviceGameJson, account);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    if(result.stringResult == "null"){
      return null;
    }
    final rust.ImageRule rustImageRule = rust.ImageRule.fromJson(json: result.stringResult);
    final ImageRule imageRule = ImageRuleHelper.convertToDart(rustImageRule, onGetNGFS: (_) => fsHandler);
    return imageRule;
  }

  static Future<AddedCustomAccountResult> notifyAddCustomAccount(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String account) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.notifyAddCustomAccount(runtime, uuid, fsHandlerId, deviceGameJson, account);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return AddedCustomAccountResult.fromJson(json: result.stringResult);
  }

  static Future<Map<String, List<String>>> searchAlbum(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.searchAlbum(runtime, uuid, fsHandlerId, deviceGameJson, account);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return (jsonDecode(result.stringResult) as Map).map((k, v) => MapEntry(k as String, List<String>.from(v as List)));
  }

  static TextRule getAlbumCategoryName(PluginJSRuntime runtime, DeviceGame deviceGame, String? account, String category){
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = PluginJSCaller.getAlbumCategoryName(runtime, uuid, deviceGameJson, account, category);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return TextRule.fromJson(json: result.stringResult);
  }

  static TextRule getAlbumName(PluginJSRuntime runtime, DeviceGame deviceGame, String? account, String category, String albumType){
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = PluginJSCaller.getAlbumName(runtime, uuid, deviceGameJson, account, category, albumType);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return TextRule.fromJson(json: result.stringResult);
  }

  static TextRule? getAlbumDescription(PluginJSRuntime runtime, DeviceGame deviceGame, String? account, String category, String albumType){
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = PluginJSCaller.getAlbumDescription(runtime, uuid, deviceGameJson, account, category, albumType);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    if(result.stringResult == "null"){
      return null;
    }
    return TextRule.fromJson(json: result.stringResult);
  }

  static IconRule? getAlbumIcon(PluginJSRuntime runtime, DeviceGame deviceGame, String? account, String category, String albumType){
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = PluginJSCaller.getAlbumIcon(runtime, uuid, deviceGameJson, account, category, albumType);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    if(result.stringResult == "null"){
      return null;
    }
    return IconRule.fromJson(json: result.stringResult);
  }

  static Future<String> getAlbumPath(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getAlbumPath(runtime, uuid, fsHandlerId, deviceGameJson, account, category, albumType);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return jsonDecode(result.stringResult);
  }

  static Future<String?> getAlbumMediaIfFile(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String filePath) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getAlbumMediaIfFile(runtime, uuid, fsHandlerId, deviceGameJson, account, category, albumType, filePath);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return jsonDecode(result.stringResult);
  }

  static Future<String?> getAlbumMediaIfDir(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String dirPath) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getAlbumMediaIfDir(runtime, uuid, fsHandlerId, deviceGameJson, account, category, albumType, dirPath);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return jsonDecode(result.stringResult);
  }

  static Future<String?> getAlbumMediaCoverIfFile(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String filePath) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getAlbumMediaCoverIfFile(runtime, uuid, fsHandlerId, deviceGameJson, account, category, albumType, filePath);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return jsonDecode(result.stringResult);
  }

  static Future<String?> getAlbumMediaCoverIfDir(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String dirPath) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getAlbumMediaCoverIfDir(runtime, uuid, fsHandlerId, deviceGameJson, account, category, albumType, dirPath);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return jsonDecode(result.stringResult);
  }

  static Future<String?> getAlbumMediaThumbnailIfFile(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String filePath) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getAlbumMediaThumbnailIfFile(runtime, uuid, fsHandlerId, deviceGameJson, account, category, albumType, filePath);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return jsonDecode(result.stringResult);
  }

  static Future<String?> getAlbumMediaThumbnailIfDir(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, DeviceGame deviceGame, String? account, String category, String albumType, String dirPath) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(deviceGame.uniqueId);
    final String deviceGameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.getAlbumMediaThumbnailIfDir(runtime, uuid, fsHandlerId, deviceGameJson, account, category, albumType, dirPath);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return jsonDecode(result.stringResult);
  }
}