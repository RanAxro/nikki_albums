import 'dart:io';
import 'strategies/export_strategy_base.dart';
import 'strategies/apple_live_photo_strategy.dart';
import 'strategies/google_motion_photo_strategy.dart';

enum ExportFormat { appleLivePhoto, googleMotionPhoto }

/// 导出服务入口 (统一调用器)
class LivePhotoExportService {
  late final Map<ExportFormat, LivePhotoExportStrategy> _strategies;

  LivePhotoExportService() {
    _strategies = {
      ExportFormat.appleLivePhoto: AppleLivePhotoStrategy(),
      ExportFormat.googleMotionPhoto: GoogleMotionPhotoStrategy(),
    };
  }

  /// 导出照片
  /// [format] 导出的目标格式
  Future<void> export({
    required ExportFormat format,
    required File coverImage,
    required File sourceVideo,
    required String outputPath,
    String? customBaseName,
  }) async {
    final strategy = _strategies[format];
    if (strategy == null) {
      throw UnsupportedError('Export format $format is not supported.');
    }
    await strategy.export(
      coverImage: coverImage,
      sourceVideo: sourceVideo,
      outputPath: outputPath,
      customBaseName: customBaseName,
    );
  }
}
