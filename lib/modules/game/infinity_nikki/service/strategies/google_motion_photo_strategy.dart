import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'export_strategy_base.dart';

class _Size {
  final int width;
  final int height;
  _Size(this.width, this.height);
}

/// 谷歌 Motion Photo 导出策略 (纯 Dart 字节拼接合成单文件)
/// 使用 Motion Photo v2 格式 (Container:Directory XMP + 视频直接追加)
class GoogleMotionPhotoStrategy implements LivePhotoExportStrategy {
  static final _xmpNsBytes = utf8.encode("http://ns.adobe.com/xap/1.0/\x00");
  static const MethodChannel _channel = MethodChannel('com.ranaxro.nikki.nikkiAlbums/live_photo');

  @override
  Future<void> export({
    required File coverImage,
    required File sourceVideo,
    required String outputPath,
  }) async {
    final imageBytes = await coverImage.readAsBytes();

    if (imageBytes.length < 2 || imageBytes[0] != 0xFF || imageBytes[1] != 0xD8) {
      throw FormatException('Cover image is not a valid JPEG.');
    }

    Uint8List videoBytes;

    if (Platform.isMacOS) {
      final imgSize = _getJpegSize(imageBytes);
      // Only normalize if the dimensions exceed iOS hardware decoding safe limits
      if (imgSize.width > 3840 || imgSize.height > 2160) {
        // Create a temporary path for the normalized video
        final tempNormVideoPath = p.join(outputPath, '.temp_norm_video_${DateTime.now().millisecondsSinceEpoch}.mp4');
        
        try {
          await _channel.invokeMethod('normalizeVideo', {
            'inputPath': sourceVideo.path,
            'outputPath': tempNormVideoPath,
          });
          
          final normVideo = File(tempNormVideoPath);
          if (await normVideo.exists()) {
            videoBytes = await normVideo.readAsBytes();
            await normVideo.delete();
          } else {
            videoBytes = await sourceVideo.readAsBytes();
          }
        } catch (e) {
          debugPrint('Warning: Video normalization failed: $e');
          videoBytes = await sourceVideo.readAsBytes();
        }
      } else {
        // Safe dimensions, bypass normalization overhead
        videoBytes = await sourceVideo.readAsBytes();
      }
    } else {
      // Windows/Linux/etc: just use raw video for now
      videoBytes = await sourceVideo.readAsBytes();
    }

    final videoSize = videoBytes.length;

    final xmp = '<?xpacket begin="\u{FEFF}" id="W5M0MpCehiHzreSzNTczkc9d"?>'
        '<x:xmpmeta xmlns:x="adobe:ns:meta/">'
        '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">'
        '<rdf:Description rdf:about=""'
        ' xmlns:GCamera="http://ns.google.com/photos/1.0/camera/"'
        ' xmlns:Container="http://ns.google.com/photos/1.0/container/"'
        ' xmlns:Item="http://ns.google.com/photos/1.0/container/item/"'
        ' GCamera:MotionPhoto="1"'
        ' GCamera:MotionPhotoVersion="1"'
        ' GCamera:MotionPhotoPresentationTimestampUs="-1">'
        '<Container:Directory>'
        '<rdf:Seq>'
        '<rdf:li rdf:parseType="Resource">'
        '<Container:Item'
        ' Item:Mime="image/jpeg"'
        ' Item:Semantic="Primary"'
        ' Item:Length="0"'
        ' Item:Padding="0"/>'
        '</rdf:li>'
        '<rdf:li rdf:parseType="Resource">'
        '<Container:Item'
        ' Item:Mime="video/mp4"'
        ' Item:Semantic="MotionPhoto"'
        ' Item:Length="$videoSize"'
        ' Item:Padding="0"/>'
        '</rdf:li>'
        '</rdf:Seq>'
        '</Container:Directory>'
        '</rdf:Description>'
        '</rdf:RDF>'
        '</x:xmpmeta>'
        '<?xpacket end="w"?>';

    final xmpBytes = utf8.encode(xmp);

    // APP1 segment
    final segLen = 2 + _xmpNsBytes.length + xmpBytes.length;
    final app1 = BytesBuilder(copy: false);
    app1.add([0xFF, 0xE1, (segLen >> 8) & 0xFF, segLen & 0xFF]);
    app1.add(_xmpNsBytes);
    app1.add(xmpBytes);

    // Strip existing XMP only
    final strippedImage = _stripExistingXmp(imageBytes);

    // Static EXIF APP1 segment containing UserComment: oplus_8388608
    final exifApp1 = Uint8List.fromList([
      0xFF, 0xE1, // APP1 marker
      0x00, 0x4A, // Length: 74 bytes
      0x45, 0x78, 0x69, 0x66, 0x00, 0x00, // "Exif\0\0"
      0x4D, 0x4D, 0x00, 0x2A, // TIFF Header (Big Endian)
      0x00, 0x00, 0x00, 0x08, // Offset to 0th IFD
      0x00, 0x01, // 0th IFD: 1 entry
      0x87, 0x69, 0x00, 0x04, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x1A,
      0x00, 0x00, 0x00, 0x00, // Next IFD: none
      0x00, 0x01, // Exif IFD: 1 entry
      0x92, 0x86, 0x00, 0x07, 0x00, 0x00, 0x00, 0x15, 0x00, 0x00, 0x00, 0x2C,
      0x00, 0x00, 0x00, 0x00, // Next IFD: none
      0x41, 0x53, 0x43, 0x49, 0x49, 0x00, 0x00, 0x00, // "ASCII\0\0\0"
      0x6F, 0x70, 0x6C, 0x75, 0x73, 0x5F, 0x38, 0x33, 0x38, 0x38, 0x36, 0x30, 0x38, // "oplus_8388608"
      0x00 // Padding for even TIFF alignment
    ]);

    // Assemble: SOI + EXIF APP1 + XMP APP1 + original segments + video
    // Same pattern as main, but with EXIF prepended before XMP.
    final out = BytesBuilder(copy: false);
    out.add([0xFF, 0xD8]);
    out.add(exifApp1);
    out.add(app1.takeBytes());
    out.add(strippedImage);
    out.add(videoBytes);

    final outFilePath = p.join(outputPath, '${p.basenameWithoutExtension(sourceVideo.path)}.jpg');
    await File(outFilePath).writeAsBytes(out.takeBytes());
  }

  Uint8List _stripExistingXmp(Uint8List jpeg) {
    int pos = 2;
    final result = BytesBuilder(copy: false);
    while (pos < jpeg.length - 1) {
      if (jpeg[pos] != 0xFF) {
        result.add(jpeg.sublist(pos));
        break;
      }
      final marker = jpeg[pos + 1];
      if (marker == 0xDA) {
        result.add(jpeg.sublist(pos));
        break;
      }
      if (marker == 0xD8 || marker == 0xD9 || (marker >= 0xD0 && marker <= 0xD7) || marker == 0x01) {
        result.add([0xFF, marker]);
        pos += 2;
        continue;
      }
      if (pos + 3 >= jpeg.length) {
        result.add(jpeg.sublist(pos));
        break;
      }
      final segLength = (jpeg[pos + 2] << 8) | jpeg[pos + 3];
      final segEnd = pos + 2 + segLength;
      if (marker == 0xE1 && _isXmpSegment(jpeg, pos + 4, segEnd)) {
        pos = segEnd;
        continue;
      }
      result.add(jpeg.sublist(pos, segEnd.clamp(pos, jpeg.length)));
      pos = segEnd;
    }
    return result.takeBytes();
  }

  bool _isXmpSegment(Uint8List data, int start, int end) {
    if (end - start < _xmpNsBytes.length) return false;
    for (int i = 0; i < _xmpNsBytes.length; i++) {
      if (start + i >= data.length || data[start + i] != _xmpNsBytes[i]) return false;
    }
    return true;
  }

  _Size _getJpegSize(Uint8List bytes) {
    int i = 2; // skip FFD8
    while (i < bytes.length - 1) {
      if (bytes[i] == 0xFF) {
        final marker = bytes[i + 1];
        if (marker == 0xC0 || marker == 0xC2) { // SOF0 or SOF2
          if (i + 8 < bytes.length) {
            int height = (bytes[i + 5] << 8) | bytes[i + 6];
            int width = (bytes[i + 7] << 8) | bytes[i + 8];
            return _Size(width, height);
          }
        } else if (marker == 0xD8 || marker == 0xD9 || marker == 0xFF || (marker >= 0xD0 && marker <= 0xD7) || marker == 0x01) {
          i += 2;
        } else {
          int length = (bytes[i + 2] << 8) | bytes[i + 3];
          i += length + 2;
        }
      } else {
        i++;
      }
    }
    return _Size(0, 0);
  }
}

