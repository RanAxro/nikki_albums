
import "../../runtime/js_runtime.dart";

import "dart:convert";

import "package:quickjs_engine/js_eval_result.dart";


abstract final class PluginJSCaller{
  static Future<JsEvalResult> searchDeviceGame(PluginJSRuntime runtime, String uuid, String uniqueId, String fsHandlerId){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchDeviceGame(fsHandler);
        res.forEach(g => { g.unique_id = ${jsonEncode(uniqueId)}; });
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> notifyPickDeviceGame(PluginJSRuntime runtime, String uuid, String uniqueId, String fsHandlerId, String name){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].onPickDeviceGame(fsHandler, ${jsonEncode(name)});
        if(res.Ok){
          res.Ok.unique_id = ${jsonEncode(uniqueId)};
        }
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getDeviceGameName(PluginJSRuntime runtime, String uuid, String deviceGameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getDeviceGameName($deviceGameJson)
      ))();
    ''');
  }

  static Future<JsEvalResult> getDeviceGameIcon(PluginJSRuntime runtime, String uuid, String deviceGameJson){
    return runtime.evaluate('''
      (async () => JSON.stringify(
        await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getDeviceGameIcon($deviceGameJson)
      ))();
    ''');
  }

  static Future<JsEvalResult> searchAccount(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchAccount(fsHandler, $deviceGameJson);
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAccountName(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAccountName(fsHandler, $deviceGameJson, ${jsonEncode(account)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAccountAvatar(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        let res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAccountAvatar(fsHandler, $deviceGameJson, ${jsonEncode(account)});
        res.fs_handler_id = res.fs_handler && res.fs_handler._handlerId;
        res.fs_handler = undefined;
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> notifyAddCustomAccount(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].onAddCustomAccount(fsHandler, $deviceGameJson, ${jsonEncode(account)});
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