
import "../../runtime/js_runtime.dart";

import "dart:convert";

import "package:quickjs_engine/js_eval_result.dart";


abstract final class PluginJSCaller{
  static Future<JsEvalResult> searchGame(PluginJSRuntime runtime, String uuid, String uniqueId, String fsHandlerId){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchGame(fsHandler);
        res.forEach(g => { g.unique_id = ${jsonEncode(uniqueId)}; });
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getGameByPath(PluginJSRuntime runtime, String uuid, String uniqueId, String fsHandlerId, String path){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getGameByPath(fsHandler, ${jsonEncode(path)});
        if(res){
          res.unique_id = ${jsonEncode(uniqueId)};
        }
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getGameName(PluginJSRuntime runtime, String uuid, String gameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getGameName($gameJson)
      ))();
    ''');
  }

  static Future<JsEvalResult> getGameIcon(PluginJSRuntime runtime, String uuid, String gameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getGameIcon($gameJson)
      ))();
    ''');
  }

  static Future<JsEvalResult> searchAccount(PluginJSRuntime runtime, String uuid, String fsHandlerId, String gameJson){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchAccount(fsHandler, $gameJson);
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAccountName(PluginJSRuntime runtime, String uuid, String fsHandlerId, String gameJson, String account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAccountName(fsHandler, $gameJson, ${jsonEncode(account)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAccountAvatar(PluginJSRuntime runtime, String uuid, String fsHandlerId, String gameJson, String account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        let res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAccountAvatar(fsHandler, $gameJson, ${jsonEncode(account)});
        res.fs_handler_id = res.fs_handler && res.fs_handler._handlerId;
        res.fs_handler = undefined;
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> searchAlbum(PluginJSRuntime runtime, String uuid, String gameJson, String? account){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchAlbum(
          ${jsonEncode(gameJson)},
          ${jsonEncode(account)}
        )
      ))();
    ''');
  }
}