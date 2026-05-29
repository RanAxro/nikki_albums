import 'dart:io';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'export_strategy_base.dart';

/// 苹果 Live Photo 导出策略 (调用 AVFoundation/ImageIO 等原生能力)
class AppleLivePhotoStrategy implements LivePhotoExportStrategy {
  static const MethodChannel _channel = MethodChannel('com.ranaxro.nikki.nikkiAlbums/live_photo');

  @override
  Future<void> export({
    required File coverImage,
    required File sourceVideo,
    required String outputPath,
  }) async {
    if (!Platform.isMacOS) {
      throw UnsupportedError('Apple Live Photo export is only supported on macOS');
    }
    final String assetIdentifier = const Uuid().v4().toUpperCase();
    final String baseName = p.basenameWithoutExtension(sourceVideo.path);
    
    // Output paired files to the user-selected directory
    final String outVideoPath = p.join(outputPath, '$baseName.mov');
    final String outImagePath = p.join(outputPath, '$baseName.jpg');

    // 1. Remux Video and Inject UUID
    await _channel.invokeMethod('remuxMp4ToMov', {
      'inputPath': sourceVideo.path,
      'outputPath': outVideoPath,
      'assetIdentifier': assetIdentifier,
    });

    // 2. Inject UUID to Image Metadata
    await _channel.invokeMethod('injectImageMetadata', {
      'inputPath': coverImage.path,
      'outputPath': outImagePath,
      'assetIdentifier': assetIdentifier,
    });

    // 3. Try to import to Photos Library (best effort)
    try {
      await _channel.invokeMethod('importLivePhoto', {
        'coverPath': outImagePath,
        'videoPath': outVideoPath,
      });
    } on PlatformException {
      // If Photos access is denied, the paired files are still available in outputPath
    }
  }
}
