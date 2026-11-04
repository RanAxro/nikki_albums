
import "../../runtime/js_runtime.dart";

import "dart:convert";

import "package:quickjs_engine/js_eval_result.dart";


abstract final class PluginJSCaller{
  static Future<JsEvalResult> searchGame(PluginJSRuntime runtime, String uniqueId, String fsHandlerId){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uniqueId)}].searchGame(fsHandler);
        res.forEach(g => { g.unique_id = ${jsonEncode(uniqueId)}; });
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getGameIcon(PluginJSRuntime runtime, String uniqueId, String gameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uniqueId)}].getGameIcon(${jsonEncode(gameJson)})
      ))();
    ''');
  }

  static Future<JsEvalResult> searchAccount(PluginJSRuntime runtime, String uniqueId, String gameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uniqueId)}].searchAccount(${jsonEncode(gameJson)})
      ))();
    ''');
  }

  static Future<JsEvalResult> getAccountName(PluginJSRuntime runtime, String uniqueId, String gameJson, String account){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uniqueId)}].getAccountName(
          ${jsonEncode(gameJson)},
          ${jsonEncode(account)}
        )
      ))();
    ''');
  }

  static Future<JsEvalResult> getAccountAvatar(PluginJSRuntime runtime, String uniqueId, String gameJson, String account){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uniqueId)}].getAccountAvatar(
          ${jsonEncode(gameJson)},
          ${jsonEncode(account)}
        )
      ))();
    ''');
  }

  static Future<JsEvalResult> searchAlbum(PluginJSRuntime runtime, String uniqueId, String gameJson, String? account){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uniqueId)}].searchAlbum(
          ${jsonEncode(gameJson)},
          ${jsonEncode(account)}
        )
      ))();
    ''');
  }
}