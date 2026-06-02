import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
    final String assetIdentifier = const Uuid().v4().toUpperCase();
    final String baseName = p.basenameWithoutExtension(sourceVideo.path);
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

      // 3. Try to import to Photos Library (best effort)
      try {
        await _channel.invokeMethod('importLivePhoto', {
          'coverPath': outImagePath,
          'videoPath': outVideoPath,
        });
      } on PlatformException {
        // Ignored
      }
      return;
    }

    if (Platform.isWindows) {
      // 1. Remux Video and Inject QuickTime UUID via FFmpeg
      final List<String> args = [
        '-y',
        '-i', sourceVideo.path,
        '-c', 'copy',
        '-movflags', 'use_metadata_tags',
        '-metadata', 'com.apple.quicktime.content.identifier=$assetIdentifier',
        outVideoPath
      ];
      // Note: FFmpegManager must be imported and checkAndDownload must be called before this strategy
      final result = await Process.run(
        p.join((await getApplicationSupportDirectory()).path, 'bin', 'ffmpeg.exe'),
        args,
      );
      if (result.exitCode != 0) {
        throw Exception("FFmpeg Live Photo Remux Failed: ${result.stderr}");
      }

      // 2. Inject XMP UUID to Image
      final imageBytes = await coverImage.readAsBytes();
      if (imageBytes.length < 2 || imageBytes[0] != 0xFF || imageBytes[1] != 0xD8) {
        throw FormatException('Cover image is not a valid JPEG.');
      }

      final xmp = '<?xpacket begin="\u{FEFF}" id="W5M0MpCehiHzreSzNTczkc9d"?>\n'
          '<x:xmpmeta xmlns:x="adobe:ns:meta/">\n'
          ' <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">\n'
          '  <rdf:Description rdf:about="" xmlns:apple="http://ns.apple.com/apple/1.0/" apple:AssetIdentifier="$assetIdentifier"/>\n'
          ' </rdf:RDF>\n'
          '</x:xmpmeta>\n'
          '<?xpacket end="w"?>';
      
      final xmpPayload = utf8.encode('http://ns.adobe.com/xap/1.0/\x00$xmp');
      
      final outBytes = BytesBuilder();
      outBytes.add(imageBytes.sublist(0, 2)); // SOI
      
      // APP1 Marker for XMP
      outBytes.addByte(0xFF);
      outBytes.addByte(0xE1);
      final length = xmpPayload.length + 2;
      outBytes.addByte((length >> 8) & 0xFF);
      outBytes.addByte(length & 0xFF);
      outBytes.add(xmpPayload);
      
      outBytes.add(imageBytes.sublist(2)); // Remaining JPEG
      
      await File(outImagePath).writeAsBytes(outBytes.toBytes());
      return;
    }

    throw UnsupportedError('Apple Live Photo export is not supported on this platform');
  }
}
