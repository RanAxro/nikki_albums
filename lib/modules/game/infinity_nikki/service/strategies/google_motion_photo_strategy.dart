import 'dart:io';
import 'export_strategy_base.dart';

/// 谷歌 Motion Photo 导出策略 (纯 Dart 字节拼接合成单文件)
class GoogleMotionPhotoStrategy implements LivePhotoExportStrategy {
  @override
  Future<void> export({
    required File coverImage,
    required File sourceVideo,
    required String outputPath,
  }) async {
    // TODO: 实现 XMP 注入与视频字节拼接合成
    throw UnimplementedError('GoogleMotionPhotoStrategy is not implemented yet.');
  }
}
