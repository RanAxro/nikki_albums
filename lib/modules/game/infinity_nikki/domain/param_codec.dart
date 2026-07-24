
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/src/rust/nuan5_params/decode.dart";
import "package:nikki_albums/src/rust/nuan5_params/decrypt.dart";

import "package:flutter/foundation.dart";
import "dart:convert";
import "dart:io";

import "package:path/path.dart" as p;


abstract class InfinityNikkiParamCodec{
  static final Map<String, MediaCustomData?> _cache = {};

  static bool hasCache(String path) => _cache.containsKey(path);

  static MediaCustomData? fromCache(String path) => _cache[path];

  static void setCache(String path, MediaCustomData? data) => _cache[path] = data;

  static Future<void> _debugOutputData(String path, String? uid) async{
    if(kDebugMode && AppState.debugNuan5DecryptionOutput.value != null){
      try{
        if(uid == null){
          return;
        }

        final MediaKey key = MediaKey.fromStr(uid);
        final flag = base64Decode(AppState.debugNuan5DecryptionFlag.value!);
        final CustomData d = await mediaDecodeFileUnchecked(flag: flag, path: path, key: key);

        d.whenOrNull(
          valid: (Uint8List valid) async{
            final String output = p.join(AppState.debugNuan5DecryptionOutput.value!, "decrypted.json");
            await File(output).writeAsBytes(valid);
          },
        );
      }catch(e, s){
        debugPrintStack(stackTrace: s);
      }
    }
  }

  static Future<MediaCustomData?> decodeFileUnchecked(MediaParamType paramType, String path, {String? uid, bool cache = false}) async{
    _debugOutputData(path, uid);

    if(cache && hasCache(path)){
      return fromCache(path);
    }

    final MediaKey key = uid == null ? MediaKey.cameraParam() : MediaKey.fromStr(uid);

    final MediaCustomData result = await mediaDeFileUnchecked(
      paramType: paramType,
      path: path,
      key: key,
    );

    if(cache){
      setCache(path, result);
    }

    return result;
  }

  static MediaCustomData? decodeFileUncheckedSync(MediaParamType paramType, String path, {String? uid, bool cache = false}){
    _debugOutputData(path, uid);

    if(cache && hasCache(path)){
      return fromCache(path);
    }

    final MediaKey key = uid == null ? MediaKey.cameraParam() : MediaKey.fromStr(uid);

    final MediaCustomData result = mediaDeFileUncheckedSync(
      paramType: paramType,
      path: path,
      key: key,
    );

    if(cache){
      setCache(path, result);
    }

    return result;
  }

  static Future<void> decodeFilesUncheckedStream(MediaParamType paramType, List<String> paths, {String? uid, bool cache = true, void Function(String, MediaCustomData?)? callback}) async{
    List<String> needDecodePaths = [];
    if(cache){
      for(final String path in paths){
        if(hasCache(path)){
          callback?.call(path, fromCache(path));
        }else{
          needDecodePaths.add(path);
        }
      }
    }else{
      needDecodePaths = paths;
    }

    final MediaKey key = uid == null ? MediaKey.cameraParam() : MediaKey.fromStr(uid);

    final Stream<MediaCustomDataResult> stream = mediaDeFilesUnchecked(paramType: paramType, paths: needDecodePaths, key: key);
    await for(final MediaCustomDataResult single in stream){
      final String path = needDecodePaths[single.index.toInt()];
      final MediaCustomData? data = single.data;

      callback?.call(path, data);

      if(cache){
        setCache(path, data);
      }
    }
  }
}