
import "../../runtime/js_runtime.dart";

import "package:quickjs_engine/js_eval_result.dart";


abstract final class PluginJSCaller{
  static Future<JsEvalResult> searchGame(PluginJSRuntime runtime, String id){
    return runtime.evaluate('''
      let res = globalThis.__apiBridge.game["$id"].searchGame();
      res.forEach(g => { g.ownership = "$id"; });
      JSON.stringify(res);
    ''');
  }

  static Future<JsEvalResult> getGameIcon(PluginJSRuntime runtime, String id, String gameJson){
    return runtime.evaluate('''
      JSON.stringify(globalThis.__apiBridge.game["$id"].getGameIcon("$gameJson"));
    ''');
  }

  static Future<JsEvalResult> searchAccount(PluginJSRuntime runtime, String id, String gameJson){
    return runtime.evaluate('''
      JSON.stringify(globalThis.__apiBridge.game["$id"].searchAccount("$gameJson"));
    ''');
  }

  static Future<JsEvalResult> getAccountName(PluginJSRuntime runtime, String id, String gameJson, String account){
    return runtime.evaluate('''
      JSON.stringify(globalThis.__apiBridge.game["$id"].getAccountName("$gameJson", "$account"));
    ''');
  }

  static Future<JsEvalResult> getAccountAvatar(PluginJSRuntime runtime, String id, String gameJson, String account){
    return runtime.evaluate('''
      JSON.stringify(globalThis.__apiBridge.game["$id"].getAccountAvatar("$gameJson", "$account"));
    ''');
  }

  static Future<JsEvalResult> searchAlbum(PluginJSRuntime runtime, String id, String gameJson, String? account){
    return runtime.evaluate('''
      JSON.stringify(globalThis.__apiBridge.game["$id"].searchAlbum("$gameJson", "$account"));
    ''');
  }
}