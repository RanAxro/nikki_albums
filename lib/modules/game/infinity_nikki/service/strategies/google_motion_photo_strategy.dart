import 'dart:io';
import 'package:path/path.dart' as p;
import 'export_strategy_base.dart';

/// 谷歌 Motion Photo 导出策略 (纯 Dart 字节拼接合成单文件)
class GoogleMotionPhotoStrategy implements LivePhotoExportStrategy {
  @override
  Future<void> export({
    required File coverImage,
    required File sourceVideo,
    required String outputPath,
  }) async {
    final videoBytes = await sourceVideo.readAsBytes();
    final videoSize = videoBytes.length;

    // 1. 构造 XMP 元数据
    // 谷歌 Motion Photo 核心 XMP，标明这是微视频且视频内容的偏移量
    // MicroVideoOffset 表示从文件末尾往前倒推的字节数，恰好等于视频的完整大小
    final xmpString = '''<?xpacket begin="﻿" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 5.1.2">
  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <rdf:Description rdf:about=""
        xmlns:GCamera="http://ns.google.com/photos/1.0/camera/"
      GCamera:MicroVideo="1"
      GCamera:MicroVideoVersion="1"
      GCamera:MicroVideoOffset="$videoSize"
      GCamera:MicroVideoPresentationTimestampUs="${videoSize ~/ 2}"/>
  </rdf:RDF>
</x:xmpmeta>
<?xpacket end="w"?>''';

    final xmpBytes = xmpString.codeUnits;
    
    // 2. 构造 APP1 Segment
    // namespace identifier: "http://ns.adobe.com/xap/1.0/\0" (29 bytes)
    final namespaceStr = "http://ns.adobe.com/xap/1.0/\u0000";
    final namespaceBytes = namespaceStr.codeUnits;
    
    // APP1 length: 2 (for length itself) + 29 (namespace) + xmpBytes.length
    final segmentLength = 2 + namespaceBytes.length + xmpBytes.length;
    
    final app1Header = [
      0xFF, 0xE1, // APP1 marker
      (segmentLength >> 8) & 0xFF, // Length High
      segmentLength & 0xFF, // Length Low
    ];
    
    final app1Segment = <int>[
      ...app1Header,
      ...namespaceBytes,
      ...xmpBytes,
    ];

    // 3. 读取原始封面图片
    final imageBytes = await coverImage.readAsBytes();
    
    // 4. 将 APP1 注入到 JPEG 头部 (通常在 0xFF 0xD8 之后)
    // 检查是否为有效 JPEG
    if (imageBytes.length < 2 || imageBytes[0] != 0xFF || imageBytes[1] != 0xD8) {
      throw FormatException('Cover image is not a valid JPEG.');
    }
    
    final resultBytes = <int>[];
    resultBytes.add(0xFF);
    resultBytes.add(0xD8); // SOI
    
    // 插入 XMP APP1
    resultBytes.addAll(app1Segment);
    
    // 拷贝原始图片剩余部分
    resultBytes.addAll(imageBytes.sublist(2));
    
    // 5. 将视频数据追加到末尾
    resultBytes.addAll(videoBytes);
    
    // 6. 写入到 outputPath
    final String outFilePath = p.join(outputPath, '${p.basenameWithoutExtension(sourceVideo.path)}.jpg');
    final outputFile = File(outFilePath);
    await outputFile.writeAsBytes(resultBytes);
  }
}
