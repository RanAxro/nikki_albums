
import "js_caller.dart";
import "../../api/file_system.dart";
import "../../runtime/js_runtime.dart";
import "../../../model/exception.dart";
import "package:nikki_albums/modules/config_helper/domain/config_helper.dart";
import "package:nikki_albums/gen/rust/config/game.dart";
import "package:nikki_albums/gen/rust/config/rules/icon_rule.dart";
import "package:nikki_albums/gen/rust/config/rules/text_rule.dart";
import "package:nikki_albums/gen/rust/config/rules/image_rule.dart" as rust;
import "package:nikki_albums/modules/config_helper/model/image_rule.dart";
import "package:nikki_albums/modules/plugin/model/game_helper.dart";

import "dart:convert";

import "package:quickjs_engine/quickjs_engine.dart";


abstract final class PluginJSBridge{
  static Future<List<Game>> searchGame(PluginJSRuntime runtime, String uniqueId, NGeneralFileSystem fsHandler) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(uniqueId);
    final JsEvalResult result = await PluginJSCaller.searchGame(runtime, uuid, uniqueId, fsHandlerId);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return Game.fromVecJson(json: result.stringResult);
  }

  static Future<Game?> getGameByPath(PluginJSRuntime runtime, String uniqueId, NGeneralFileSystem fsHandler, String path) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(uniqueId);
    final JsEvalResult result = await PluginJSCaller.getGameByPath(runtime, uuid, uniqueId, fsHandlerId, path);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    if(result.stringResult == "null"){
      return null;
    }
    return Game.fromJson(json: result.stringResult);
  }

  static Future<TextRule> getGameName(PluginJSRuntime runtime, Game game) async{
    final String uuid = GameHelper.getUuidByUniqueId(game.uniqueId);
    final String gameJson = game.toJson();
    final JsEvalResult result = await PluginJSCaller.getGameName(runtime, uuid, gameJson);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return TextRule.fromJson(json: result.stringResult);
  }

  static Future<IconRule?> getGameIcon(PluginJSRuntime runtime, Game game) async{
    final String uuid = GameHelper.getUuidByUniqueId(game.uniqueId);
    final String gameJson = game.toJson();
    final JsEvalResult result = await PluginJSCaller.getGameIcon(runtime, uuid, gameJson);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    if(result.stringResult == "null"){
      return null;
    }
    return IconRule.fromJson(json: result.stringResult);
  }

  static Future<List<String>> searchAccount(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, Game game) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(game.uniqueId);
    final String gameJson = game.toJson();
    final JsEvalResult result = await PluginJSCaller.searchAccount(runtime, uuid, fsHandlerId, gameJson);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return List<String>.from(jsonDecode(result.stringResult));
  }

  static Future<TextRule?> getAccountName(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, Game game, String account) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(game.uniqueId);
    final String gameJson = game.toJson();
    final JsEvalResult result = await PluginJSCaller.getAccountName(runtime, uuid, fsHandlerId, gameJson, account);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    if(result.stringResult == "null"){
      return null;
    }
    return TextRule.fromJson(json: result.stringResult);
  }

  static Future<ImageRule?> getAccountAvatar(PluginJSRuntime runtime, NGeneralFileSystem fsHandler, Game game, String account) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final String uuid = GameHelper.getUuidByUniqueId(game.uniqueId);
    final String gameJson = game.toJson();
    final JsEvalResult result = await PluginJSCaller.getAccountAvatar(runtime, uuid, fsHandlerId, gameJson, account);
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

  static Future<List<String>> searchAlbum(PluginJSRuntime runtime, String uuid, Game game, String? account) async{
    final String gameJson = game.toJson();
    final JsEvalResult result = await PluginJSCaller.searchAlbum(runtime, uuid, gameJson, account);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return List<String>.from(jsonDecode(result.stringResult));
  }
}