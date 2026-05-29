import 'dart:io';

/// 导出策略基类
abstract class LivePhotoExportStrategy {
  /// 执行导出逻辑
  /// [coverImage] 游戏原始生成的静态封面图（一般为 .jpeg）
  /// [sourceVideo] 游戏原始生成的短视频（一般为 .Mp4）
  /// [outputPath] 可选的输出目录路径（用于需要写入文件的策略，如 MotionPhoto）
  Future<void> export({
    required File coverImage,
    required File sourceVideo,
    required String outputPath,
  });
}
