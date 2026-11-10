
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
    print(AddedCustomAccountResult.fromJson(json: result.stringResult));
    return AddedCustomAccountResult.fromJson(json: result.stringResult);
  }

  static Future<List<String>> searchAlbum(PluginJSRuntime runtime, String uuid, DeviceGame deviceGame, String? account) async{
    final String gameJson = deviceGame.toJson();
    final JsEvalResult result = await PluginJSCaller.searchAlbum(runtime, uuid, gameJson, account);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return List<String>.from(jsonDecode(result.stringResult));
  }
}