
import "../../runtime/js_runtime.dart";

import "dart:convert";

import "package:quickjs_engine/js_eval_result.dart";


abstract final class PluginJSCaller{
  static Future<JsEvalResult> searchGame(PluginJSRuntime runtime, String uuid, String fsHandlerId){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchGame(fsHandler);
        res.forEach(g => { g.unique_id = ${jsonEncode(uuid)}; });
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getGameIcon(PluginJSRuntime runtime, String uuid, String gameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getGameIcon(${jsonEncode(gameJson)})
      ))();
    ''');
  }

  static Future<JsEvalResult> searchAccount(PluginJSRuntime runtime, String uuid, String gameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchAccount(${jsonEncode(gameJson)})
      ))();
    ''');
  }

  static Future<JsEvalResult> getAccountName(PluginJSRuntime runtime, String uuid, String gameJson, String account){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAccountName(
          ${jsonEncode(gameJson)},
          ${jsonEncode(account)}
        )
      ))();
    ''');
  }

  static Future<JsEvalResult> getAccountAvatar(PluginJSRuntime runtime, String uuid, String gameJson, String account){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAccountAvatar(
          ${jsonEncode(gameJson)},
          ${jsonEncode(account)}
        )
      ))();
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