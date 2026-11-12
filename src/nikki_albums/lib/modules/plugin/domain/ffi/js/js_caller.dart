
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

  static Future<JsEvalResult> searchAlbum(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String? account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchAlbum(fsHandler, $deviceGameJson, ${jsonEncode(account)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static JsEvalResult getAlbumCategoryName(PluginJSRuntime runtime, String uuid, String deviceGameJson, String? account, String category){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumCategoryName($deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}));
    ''');
  }

  static JsEvalResult getAlbumName(PluginJSRuntime runtime, String uuid, String deviceGameJson, String? account, String category, String albumType){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumName($deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)}));
    ''');
  }

  static JsEvalResult getAlbumDescription(PluginJSRuntime runtime, String uuid, String deviceGameJson, String? account, String category, String albumType){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumDescription($deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)}));
    ''');
  }

  static JsEvalResult getAlbumIcon(PluginJSRuntime runtime, String uuid, String deviceGameJson, String? account, String category, String albumType){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumIcon($deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)}));
    ''');
  }

  static Future<JsEvalResult> getAlbumPath(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String? account, String category, String albumType){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumPath(fsHandler, $deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaIfFile(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String? account, String category, String albumType, String filePath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaIfFile(fsHandler, $deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)}, ${jsonEncode(filePath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaIfDir(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String? account, String category, String albumType, String dirPath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaIfDir(fsHandler, $deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)}, ${jsonEncode(dirPath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaCoverIfFile(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String? account, String category, String albumType, String filePath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaCoverIfFile(fsHandler, $deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)}, ${jsonEncode(filePath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaCoverIfDir(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String? account, String category, String albumType, String dirPath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaCoverIfDir(fsHandler, $deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)}, ${jsonEncode(dirPath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaThumbnailIfFile(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String? account, String category, String albumType, String filePath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaThumbnailIfFile(fsHandler, $deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)}, ${jsonEncode(filePath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaThumbnailIfDir(PluginJSRuntime runtime, String uuid, String fsHandlerId, String deviceGameJson, String? account, String category, String albumType, String dirPath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaThumbnailIfDir(fsHandler, $deviceGameJson, ${jsonEncode(account)}, ${jsonEncode(category)}, ${jsonEncode(albumType)}, ${jsonEncode(dirPath)});
        return JSON.stringify(res);
      })();
    ''');
  }
}