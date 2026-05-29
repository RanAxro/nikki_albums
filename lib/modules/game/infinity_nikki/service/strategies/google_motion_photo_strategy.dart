import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'export_strategy_base.dart';

/// 谷歌 Motion Photo 导出策略 (纯 Dart 字节拼接合成单文件)
/// 使用 Motion Photo v2 格式 (Container:Directory XMP + 视频直接追加)
class GoogleMotionPhotoStrategy implements LivePhotoExportStrategy {
  static final _xmpNsBytes = utf8.encode("http://ns.adobe.com/xap/1.0/\x00");

  @override
  Future<void> export({
    required File coverImage,
    required File sourceVideo,
    required String outputPath,
  }) async {
    final videoBytes = await sourceVideo.readAsBytes();
    final imageBytes = await coverImage.readAsBytes();

    if (imageBytes.length < 2 || imageBytes[0] != 0xFF || imageBytes[1] != 0xD8) {
      throw FormatException('Cover image is not a valid JPEG.');
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

    // Strip existing XMP
    final strippedImage = _stripExistingXmp(imageBytes);

    // Assemble: SOI + XMP APP1 + original segments + video
    final out = BytesBuilder(copy: false);
    out.add([0xFF, 0xD8]);
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
}
