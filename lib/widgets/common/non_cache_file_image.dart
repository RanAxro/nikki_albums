
import "package:flutter/material.dart";
import "dart:io";
import "dart:ui";
import "dart:typed_data";


class NonCacheFileImage extends ImageProvider<NonCacheFileImage>{
  final File file;

  NonCacheFileImage(this.file);

  @override
  Future<NonCacheFileImage> obtainKey(ImageConfiguration configuration) async => this;

  @override
  ImageStreamCompleter loadImage(NonCacheFileImage key, ImageDecoderCallback decode){
    return OneFrameImageStreamCompleter(
      _loadAsync(key, decode),
    );
  }

  Future<ImageInfo> _loadAsync(NonCacheFileImage key, ImageDecoderCallback decode) async{
    final Uint8List bytes = await file.readAsBytes();
    final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(bytes);
    final Codec codec = await decode(buffer);
    final FrameInfo frame = await codec.getNextFrame();
    return ImageInfo(image: frame.image);
  }

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => file.path.hashCode;
}