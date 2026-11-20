
import "dart:async";
import "dart:typed_data";
import "dart:ui" as ui;

import "package:mime/mime.dart";
import "package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart";


class ThumbnailCache{
  ThumbnailCache();

  /// 2GB
  int _maxCacheSize = 2 * 1024 * 1024 * 1024;
  int _currentSize = 0;
  final Map<Object, Future<ui.Image>> _cache = {};

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
  static void setMaxCacheSize(int size) => _cache.setMaxCacheSize(size);


  static Future<ui.Image> from({required FutureOr<Uint8List> Function() getBytes, int? targetWidth, int? targetHeight}) async{
    final bytes = await getBytes();
    final String? mimeType = lookupMimeType("", headerBytes: bytes);
    if(ImageThumbnail.supportedImageMimeType.contains(mimeType)){
      return ImageThumbnail.from(getBytes: () => bytes, targetWidth: targetWidth, targetHeight: targetHeight);
    }
    if(VideoThumbnail.supportedVideoMimeType.contains(mimeType)){
      return VideoThumbnail.from(getBytes: () => bytes, targetWidth: targetWidth, targetHeight: targetHeight);
    }
    throw Exception("无法获取缩略图 mime: $mimeType");
  }

  static Future<ui.Image> fromCache({required Object id, required FutureOr<Uint8List> Function() getBytes, int? targetWidth, int? targetHeight}){
    final Future<ui.Image>? cache = _cache.getCache(id);
    if(cache != null){
      return cache;
    }

    final Future<ui.Image> image = from(getBytes: getBytes, targetWidth: targetWidth, targetHeight: targetHeight);

    _cache.setCache(id, image);
    return image;
  }
}

abstract class ImageThumbnail{
  static const Set<String> supportedImageMimeType = {
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
    if(cache != null) return cache;

    final Future<ui.Image> image = from(getBytes: getBytes, targetWidth: targetWidth, targetHeight: targetHeight);

    Thumbnail._cache.setCache(id, image);
    return image;
  }

  static Future<ui.Image>? findCache(Object id){
    return Thumbnail._cache.getCache(id);
  }
}


abstract class VideoThumbnail{
  static const Set<String> supportedVideoMimeType = {
    "video/mp4",
  };

  static final FcNativeVideoThumbnail _plugin = FcNativeVideoThumbnail();

  static Future<ui.Image> from({required FutureOr<Uint8List> Function() getBytes, int? targetWidth, int? targetHeight}) async{
    // TODO VideoThumbnail
    throw UnimplementedError();
  }

  static Future<ui.Image> fromCache({required Object id, required FutureOr<Uint8List> Function() getBytes, int? targetWidth, int? targetHeight}){
    final Future<ui.Image>? cache = Thumbnail._cache.getCache(id);
    if(cache != null) return cache;

    final Future<ui.Image> image = from(getBytes: getBytes, targetWidth: targetWidth, targetHeight: targetHeight);

    Thumbnail._cache.setCache(id, image);
    return image;
  }

  static Future<ui.Image>? findCache(Object id){
    return Thumbnail._cache.getCache(id);
  }
}