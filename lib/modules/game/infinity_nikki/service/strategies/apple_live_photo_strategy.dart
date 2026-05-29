import 'dart:io';
import 'export_strategy_base.dart';

/// 苹果 Live Photo 导出策略 (调用 AVFoundation/ImageIO 等原生能力)
class AppleLivePhotoStrategy implements LivePhotoExportStrategy {
  @override
  Future<void> export({
    required File coverImage,
    required File sourceVideo,
    required String outputPath,
  }) async {
    // TODO: 实现 macOS 原生 Method Channel 调用
    // 包含: VideoRemuxer, LivePhotoMetadataPatcher, PhotosLibraryImporter
    throw UnimplementedError('AppleLivePhotoStrategy is not implemented yet.');
  }
}
