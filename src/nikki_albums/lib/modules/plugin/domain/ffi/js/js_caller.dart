
import "../../runtime/js_runtime.dart";

import "dart:convert";

import "package:quickjs_engine/js_eval_result.dart";


abstract final class PluginJSCaller{
  static Future<JsEvalResult> searchDeviceGame(PluginJSRuntime runtime, String uuid, String uniqueId, String fsHandlerId){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchDeviceGame(fsHandler);
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> notifyPickDeviceGame(PluginJSRuntime runtime, String uuid, String uniqueId, String fsHandlerId, String name){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].onPickDeviceGame(fsHandler, ${jsonEncode(name)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static JsEvalResult getDeviceGameName(PluginJSRuntime runtime, String uuid, String obtainedDeviceGameJson){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getDeviceGameName(ObtainedDeviceGame.from($obtainedDeviceGameJson)));
    ''');
  }

  static JsEvalResult getDeviceGameIcon(PluginJSRuntime runtime, String uuid, String obtainedDeviceGameJson){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getDeviceGameIcon(ObtainedDeviceGame.from($obtainedDeviceGameJson)));
    ''');
  }

  static Future<JsEvalResult> searchAccount(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchAccount(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson));
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAccountName(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAccountName(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAccountAvatar(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        let res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAccountAvatar(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)});
        res.fs_handler_id = res.fs_handler && res.fs_handler._handlerId;
        res.fs_handler = undefined;
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> notifyAddCustomAccount(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].onAddCustomAccount(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> searchAlbum(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String? account){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].searchAlbum(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static JsEvalResult getAlbumCategory(PluginJSRuntime runtime, String uuid, String obtainedDeviceGameJson, String? account, String albumType){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumCategory(ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}));
    ''');
  }

  static JsEvalResult getAlbumCategoryName(PluginJSRuntime runtime, String uuid, String obtainedDeviceGameJson, String? account, String category){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumCategoryName(ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(category)}));
    ''');
  }

  static JsEvalResult getAlbumName(PluginJSRuntime runtime, String uuid, String obtainedDeviceGameJson, String? account, String albumType){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumName(ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}));
    ''');
  }

  static JsEvalResult getAlbumDescription(PluginJSRuntime runtime, String uuid, String obtainedDeviceGameJson, String? account, String albumType){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumDescription(ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}));
    ''');
  }

  static JsEvalResult getAlbumIcon(PluginJSRuntime runtime, String uuid, String obtainedDeviceGameJson, String? account, String albumType){
    return runtime.evaluateSync('''
      JSON.stringify(globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumIcon(ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}));
    ''');
  }

  static Future<JsEvalResult> getAlbumPath(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String? account, String albumType){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumPath(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaIfFile(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String? account, String albumType, String filePath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaIfFile(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}, ${jsonEncode(filePath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaIfDir(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String? account, String albumType, String dirPath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaIfDir(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}, ${jsonEncode(dirPath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaCoverIfFile(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String? account, String albumType, String filePath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaCoverIfFile(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}, ${jsonEncode(filePath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaCoverIfDir(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String? account, String albumType, String dirPath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaCoverIfDir(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}, ${jsonEncode(dirPath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaThumbnailIfFile(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String? account, String albumType, String filePath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaThumbnailIfFile(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}, ${jsonEncode(filePath)});
        return JSON.stringify(res);
      })();
    ''');
  }

  static Future<JsEvalResult> getAlbumMediaThumbnailIfDir(PluginJSRuntime runtime, String uuid, String fsHandlerId, String obtainedDeviceGameJson, String? account, String albumType, String dirPath){
    return runtime.evaluate('''
      (async () => {
        let fsHandler = new FileSystemHandler(${jsonEncode(fsHandlerId)});
        const res = await globalThis.__apiBridge.game[${jsonEncode(uuid)}].getAlbumMediaThumbnailIfDir(fsHandler, ObtainedDeviceGame.from($obtainedDeviceGameJson), ${jsonEncode(account)}, ${jsonEncode(albumType)}, ${jsonEncode(dirPath)});
        return JSON.stringify(res);
      })();
    ''');
  }
}