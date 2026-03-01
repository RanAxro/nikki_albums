import "path.dart";

import "dart:ui" as ui;
import "dart:typed_data";
import "dart:async";
import "package:flutter/material.dart";


const Set<String> imageExtension = {"png", "jpeg", "jpg", "webp", "gif", "bmp", "wbmp", "ico"};
const Map<String, String> imageFileType = {
  "png": "image/png",
  "jpeg": "image/jpeg",
  "jpg": "image/jpeg",
};

bool isImageExtension(Path imagePath){
  return imageExtension.contains(imagePath.extension.toLowerCase());
}

String? getImageFileType(Path imagePath){
  return imageFileType[imagePath.extension.toLowerCase()];
}

/// 获取缩略图
///
/// [originalImageProvider]: 原始的图片提供者，例如 AssetImage, NetworkImage。
/// [targetWidth]: 目标宽度。如果为 null，则不限制宽度。
/// [targetHeight]: 目标高度。如果为 null，则不限制高度。
/// [outputFormat]: 输出的字节数据格式。可以是 ui.ImageByteFormat.png (默认，压缩后PNG)
///                 或 ui.ImageByteFormat.rawRgba (原始RGBA像素数据)。
///
/// 返回一个包含图片数据的 Uint8List，如果失败则返回 null。
Future<Uint8List?> getResizedImageData({
  required ImageProvider originalImageProvider,
  int? targetWidth,
  int? targetHeight,
  ui.ImageByteFormat outputFormat = ui.ImageByteFormat.png, // 默认输出PNG格式
})async{
  // 1. 创建 ResizeImage 实例
  final ResizeImage resizedImage = ResizeImage(
    originalImageProvider,
    width: targetWidth,
    height: targetHeight,
  );

  // 2. 解析 ImageProvider 为 ImageStream
  final ImageStream stream = resizedImage.resolve(ImageConfiguration.empty);

  final Completer<ui.Image> completer = Completer();
  late ImageStreamListener listener;

  listener = ImageStreamListener(
    (ImageInfo info, bool synchronousCall){
      // 3. 当 ImageStream 发出 ImageInfo 时，完成 Completer
      completer.complete(info.image);
      // 4. 完成后，移除监听器以防止内存泄漏
      stream.removeListener(listener);
    },
    onError: (dynamic exception, StackTrace? stackTrace){
      completer.completeError(exception, stackTrace);
      stream.removeListener(listener);
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stackTrace,
          library: "image_data_util",
          context: ErrorDescription("while loading resized image"),
        ),
      );
    },
  );

  stream.addListener(listener);

  try{
    // 5. 等待 ui.Image 对象加载完成
    final ui.Image image = await completer.future;

    // 6. 从 ui.Image 获取 ByteData
    //    - ui.ImageByteFormat.png: 会将图片重新编码为 PNG 格式的字节数据
    //    - ui.ImageByteFormat.rawRgba: 提供原始的 RGBA 8888 像素数据
    final ByteData? byteData = await image.toByteData(format: outputFormat);

    // 7. 释放 ui.Image 资源
    image.dispose();

    if(byteData != null){
      // 8. 将 ByteData 转换为 Uint8List
      return byteData.buffer.asUint8List();
    }
  }catch(e){
    // writeErrorLog("utils.getResizedImageData : getting resized image data: $e");
  }
  return null;
}





abstract class ImageThumbnail{
  static const int maxCache = 500;
  static final Map<String, ui.Image> _imageCache = {};

  static Future<ui.Image?> from({
    required ImageProvider imageProvider,
    int? targetWidth,
    int? targetHeight,
  }) async{

    // 创建 ResizeImage 实例
    final ResizeImage resizedImage = ResizeImage(
      imageProvider,
      width: targetWidth,
      height: targetHeight,
    );

    // ImageProvider 为 ImageStream
    final ImageStream stream = resizedImage.resolve(ImageConfiguration.empty);

    final Completer<ui.Image> completer = Completer();
    late ImageStreamListener listener;

    listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall){
        // ImageStream 发出 ImageInfo 时，完成 Completer
        completer.complete(info.image);
        // 完成后，移除监听器以防止内存泄漏
        stream.removeListener(listener);
      },
      onError: (dynamic exception, StackTrace? stackTrace){
        completer.completeError(exception, stackTrace);
        stream.removeListener(listener);
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: exception,
            stack: stackTrace,
            library: "image_data_util",
            context: ErrorDescription("while loading resized image"),
          ),
        );
      },
    );

    stream.addListener(listener);

    try{
      // 等待 ui.Image 对象加载完成
      final ui.Image image = await completer.future;
      return image;
    }catch(e){
      return null;
    }
  }


  static Future<ui.Image?> fromCache({
    required String id,
    Path? imagePath,
    int? targetWidth,
    int? targetHeight,
  }) async{
    if(_imageCache.containsKey(id)) return _imageCache[id];

    if(imagePath == null) return null;

    if(! await imagePath.file.exists()) return null;

    final ui.Image? image = await from(
      imageProvider: FileImage(imagePath.file),
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );

    if(image == null) return null;

    _imageCache[id] = image;

    return image;
  }

  static ui.Image? findCache(String id){
    if(_imageCache.containsKey(id)) return _imageCache[id];

    return null;
  }
}
