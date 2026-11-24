
import "dart:async";
import "dart:io";
import "dart:typed_data";
import "dart:ui" as ui;

import "package:mime/mime.dart";
import "package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart";


class ThumbnailCache{
  ThumbnailCache();

  /// 2GB
  int _maxCacheSize = 2 * 1024 * 1024 * 1024;
  int _currentSize = 0;
  final Map<Object, Future<ui.Image>> _cache = <Object, Future<ui.Image>>{};

  int get maxCacheSize => _maxCacheSize;
  int get currentSize => _currentSize;

  void setMaxCacheSize(int size){
    _maxCacheSize = size;
    _check();
  }

  Future<void> _check() async{
    if(_currentSize <= _maxCacheSize){
      return;
    }
    do{
      await _deleteFirst();
    }while(_currentSize > _maxCacheSize);
  }

  Future<ui.Image>? getCache(Object id){
    final Future<ui.Image>? removed = _cache.remove(id);
    if(removed == null){
      return null;
    }
    _cache[id] = removed;
    return removed;
  }

  void setCache(Object id, Future<ui.Image> image) async{
    _currentSize += _calculateSize(await image);
    final Future<ui.Image>? removed = _cache.remove(id);
    if(removed != null){
      _currentSize -= _calculateSize(await removed);
    }
    _cache[id] = image;
    await _check();
  }

  Future<void> _deleteFirst() async{
    final Object? first = _cache.entries.firstOrNull?.key;
    if(first == null){
      return;
    }
    final Future<ui.Image>? removed = _cache.remove(first);
    if(removed != null){
      _currentSize -= _calculateSize(await removed);
    }
  }

  int _calculateSize(ui.Image image){
    /// RGBA8888
    return image.width * image.height * 4;
  }
}

abstract final class Thumbnail{
  static final ThumbnailCache _cache = ThumbnailCache();
  static int get maxCacheSize => _cache.maxCacheSize;
  static set maxCacheSize(int size) => _cache.setMaxCacheSize(size);


  static Future<ui.Image> from({FutureOr<Uint8List> Function()? getBytes, FutureOr<String> Function()? getPath, int? targetWidth, int? targetHeight}) async{
    assert(getBytes != null || getPath != null);

    final Uint8List? bytes = await getBytes?.call();
    final String? path = bytes == null ? await getPath?.call() : null;
    final String? mimeType = lookupMimeType(path ?? "", headerBytes: bytes);
    if(ImageThumbnail.supportedImageMimeType.contains(mimeType)){
      final Uint8List imageBytes = bytes ?? await File(path!).readAsBytes();
      return ImageThumbnail.from(getBytes: () => imageBytes, targetWidth: targetWidth, targetHeight: targetHeight);
    }
    if(VideoThumbnail.supportedVideoMimeType.contains(mimeType)){
      final String videoPath = path ?? await getPath!.call();
      return VideoThumbnail.from(path: videoPath, targetWidth: targetWidth, targetHeight: targetHeight);
    }
    throw Exception("无法获取缩略图 mime: $mimeType");
  }

  static Future<ui.Image> fromCache({required Object id, FutureOr<Uint8List> Function()? getBytes, FutureOr<String> Function()? getPath, int? targetWidth, int? targetHeight}){
    final Future<ui.Image>? cache = _cache.getCache(id);
    if(cache != null){
      return cache;
    }

    final Future<ui.Image> image = from(getBytes: getBytes, getPath: getPath, targetWidth: targetWidth, targetHeight: targetHeight);

    _cache.setCache(id, image);
    return image;
  }
}

abstract class ImageThumbnail{
  static const Set<String> supportedImageMimeType = <String>{
    "image/jpeg",
    "image/png",
    "image/webp",
  };

  static Future<ui.Image> from({required FutureOr<Uint8List> Function() getBytes, int? targetWidth, int? targetHeight}) async{
    final ui.Codec codec = await ui.instantiateImageCodec(await getBytes(), targetWidth: targetWidth, targetHeight: targetHeight);
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<ui.Image> fromCache({required Object id, required FutureOr<Uint8List> Function() getBytes, int? targetWidth, int? targetHeight}){
    final Future<ui.Image>? cache = findCache(id);
    if(cache != null){
      return cache;
    }

    final Future<ui.Image> image = from(getBytes: getBytes, targetWidth: targetWidth, targetHeight: targetHeight);

    Thumbnail._cache.setCache(id, image);
    return image;
  }

  static Future<ui.Image>? findCache(Object id){
    return Thumbnail._cache.getCache(id);
  }
}


abstract class VideoThumbnail{
  static const Set<String> supportedVideoMimeType = <String>{
    "video/mp4",
  };

  static final FcNativeVideoThumbnail _plugin = FcNativeVideoThumbnail();

  static Future<ui.Image> from({required String path, int? targetWidth, int? targetHeight}) async{
    final Uint8List? generated = await _plugin.saveThumbnailToBytes(
      srcFile: path,
      width: targetWidth ?? targetHeight ?? 720,
      height: targetWidth ?? targetHeight ?? 720,
      quality: 100,
    );
    if(generated == null){
      throw Exception("不支持的视频格式");
    }
    return ImageThumbnail.from(getBytes: () => generated, targetWidth: targetWidth, targetHeight: targetHeight);
  }

  static Future<ui.Image> fromCache({required Object id, required String path, int? targetWidth, int? targetHeight}){
    final Future<ui.Image>? cache = Thumbnail._cache.getCache(id);
    if(cache != null){
      return cache;
    }

    final Future<ui.Image> image = from(path: path, targetWidth: targetWidth, targetHeight: targetHeight);

    Thumbnail._cache.setCache(id, image);
    return image;
  }

  static Future<ui.Image>? findCache(Object id){
    return Thumbnail._cache.getCache(id);
  }
}