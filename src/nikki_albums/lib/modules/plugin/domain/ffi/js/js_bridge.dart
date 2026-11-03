
import "js_caller.dart";
import "../../runtime/js_runtime.dart";
import "../../../model/exception.dart";
import "package:nikki_albums/gen/rust/config/game.dart";
import "package:nikki_albums/modules/plugin/domain/api/file_system.dart";

import "dart:convert";

import "package:quickjs_engine/quickjs_engine.dart";


abstract final class PluginJSBridge{
  static Future<List<Game>> searchGame(PluginJSRuntime runtime, String id, NGeneralFileSystem fsHandler) async{
    final String fsHandlerId = PluginFileSystemHandler.add(fsHandler);
    final JsEvalResult result = await PluginJSCaller.searchGame(runtime, id, fsHandlerId);
    PluginFileSystemHandler.remove(fsHandlerId);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return Game.fromVecJson(json: result.stringResult);
  }

  static Future<List<String>> searchAccount(PluginJSRuntime runtime, String id, Game game) async{
    final String gameJson = game.toJson();
    final JsEvalResult result = await PluginJSCaller.searchAccount(runtime, id, gameJson);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return List<String>.from(jsonDecode(result.stringResult));
  }

  static Future<List<String>> searchAlbum(PluginJSRuntime runtime, String id, Game game, String? account) async{
    final String gameJson = game.toJson();
    final JsEvalResult result = await PluginJSCaller.searchAlbum(runtime, id, gameJson, account);
    if(result.isError){
      throw PluginScriptMalfunctionedException(scriptType: "JS", error: result.stringResult);
    }
    return List<String>.from(jsonDecode(result.stringResult));
  }
}