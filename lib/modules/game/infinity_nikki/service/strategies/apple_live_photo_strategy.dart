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
    required String outputPath, // 可选，对于 Live Photo，我们可以导出到临时目录然后再导入相册
  }) async {
    final String assetIdentifier = const Uuid().v4().toUpperCase();
    
    // 生成临时路径
    final tempDir = Directory.systemTemp;
    final String tempVideoPath = p.join(tempDir.path, '${assetIdentifier}.mov');
    final String tempImagePath = p.join(tempDir.path, '${assetIdentifier}.jpg'); // Live Photo 要求 jpg 格式

    try {
      // 1. Remux Video and Inject UUID
      await _channel.invokeMethod('remuxMp4ToMov', {
        'inputPath': sourceVideo.path,
        'outputPath': tempVideoPath,
        'assetIdentifier': assetIdentifier,
      });

      // 2. Inject UUID to Image Metadata
      await _channel.invokeMethod('injectImageMetadata', {
        'inputPath': coverImage.path,
        'outputPath': tempImagePath,
        'assetIdentifier': assetIdentifier,
      });

      // 3. Import to Photos Library
      await _channel.invokeMethod('importLivePhoto', {
        'coverPath': tempImagePath,
        'videoPath': tempVideoPath,
      });
    } finally {
      // 清理临时文件
      final tempVideoFile = File(tempVideoPath);
      if (await tempVideoFile.exists()) {
        await tempVideoFile.delete();
      }
      final tempImageFile = File(tempImagePath);
      if (await tempImageFile.exists()) {
        await tempImageFile.delete();
      }
    }
  }
}
