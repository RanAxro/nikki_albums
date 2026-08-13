import 'dart:io';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:nikki_albums/utils/ffmpeg_manager.dart';
import 'package:nikki_albums/utils/exiftool_manager.dart';
import 'export_strategy_base.dart';

/// 苹果 Live Photo 导出策略 (调用 AVFoundation/ImageIO 等原生能力)
class AppleLivePhotoStrategy implements LivePhotoExportStrategy {
  static const MethodChannel _channel = MethodChannel(
    'com.ranaxro.nikki.nikkiAlbums/live_photo',
  );

  @override
  Future<void> export({
    required File coverImage,
    required File sourceVideo,
    required String outputPath,
    String? customBaseName,
  }) async {
    final String assetIdentifier = const Uuid().v4().toUpperCase();
    final String baseName =
        customBaseName ?? p.basenameWithoutExtension(sourceVideo.path);
    final String outVideoPath = p.join(outputPath, '$baseName.mov');
    final String outImagePath = p.join(outputPath, '$baseName.jpg');

    if (Platform.isMacOS) {
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

      // Removed automatic import to Photos Library, as this strategy is used for Local/Clipboard exports.
      // Photo Library importing is handled separately in AlbumHandler.exportToPhotoLibrary.
      return;
    }

    if (Platform.isWindows) {
      // 1. Remux Video: Output with .mov container format
      final List<String> args = [
        '-y',
        '-i',
        sourceVideo.path,
        '-map',
        '0',
        '-c',
        'copy',
        '-f',
        'mov',
        outVideoPath,
      ];
      final result = await FFmpegManager.execute(args);
      if (result.exitCode != 0) {
        throw Exception("FFmpeg Live Photo Remux Failed: ${result.stderr}");
      }

      // 2. Prepare Cover Image
      final imageBytes = await coverImage.readAsBytes();
      if (imageBytes.length < 2 ||
          imageBytes[0] != 0xFF ||
          imageBytes[1] != 0xD8) {
        throw FormatException('Cover image is not a valid JPEG.');
      }
      // write the image directly first
      await File(outImagePath).writeAsBytes(imageBytes);

      // 3. Inject Apple MakerNote and QuickTime UUID using ExifTool
      await ExifToolManager.writeLivePhotoIdentifier(
        outImagePath,
        outVideoPath,
        assetIdentifier,
      );
      return;
    }

    throw UnsupportedError(
      'Apple Live Photo export is not supported on this platform',
    );
  }
}
