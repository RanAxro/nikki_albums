
import "../../runtime/js_runtime.dart";

import "dart:convert";

import "package:quickjs_engine/js_eval_result.dart";


abstract final class PluginJSCaller{
  static Future<JsEvalResult> searchGame(PluginJSRuntime runtime, String id, String fsHandlerId){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(id)}].searchGame(fsHandler);
        res.forEach(g => { g.ownership = ${jsonEncode(id)}; });
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getGameIcon(PluginJSRuntime runtime, String id, String gameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(id)}].getGameIcon(${jsonEncode(gameJson)})
      ))();
    ''');
  }

  static Future<JsEvalResult> searchAccount(PluginJSRuntime runtime, String id, String gameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(id)}].searchAccount(${jsonEncode(gameJson)})
      ))();
    ''');
  }

  static Future<JsEvalResult> getAccountName(PluginJSRuntime runtime, String id, String gameJson, String account){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(id)}].getAccountName(
          ${jsonEncode(gameJson)},
          ${jsonEncode(account)}
        )
      ))();
    ''');
  }

  static Future<JsEvalResult> getAccountAvatar(PluginJSRuntime runtime, String id, String gameJson, String account){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(id)}].getAccountAvatar(
          ${jsonEncode(gameJson)},
          ${jsonEncode(account)}
        )
      ))();
    ''');
  }

  static Future<JsEvalResult> searchAlbum(PluginJSRuntime runtime, String id, String gameJson, String? account){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(id)}].searchAlbum(
          ${jsonEncode(gameJson)},
          ${jsonEncode(account)}
        )
      ))();
    ''');
  }
}