
import "package:flutter/material.dart";
import "dart:io";
import "dart:ui" as ui;
import "dart:typed_data";

import "package:image/image.dart" as img;
import "package:zxing2/qrcode.dart";
import "package:qr_flutter/qr_flutter.dart";


Future<String?> decodeQRCode(Uint8List bytes) async{
  // 读取图片
  final img.Image? image = img.decodePng(bytes);
  if(image == null) return null;

  // 创建 LuminanceSource（zxing2 需要灰度数据）
  final LuminanceSource source = RGBLuminanceSource(
    image.width,
    image.height,
    image.convert(numChannels: 4)
      .getBytes(order: img.ChannelOrder.abgr)
      .buffer
      .asInt32List(),
  );

  // 二值化 + 解码
  final BinaryBitmap bitmap = BinaryBitmap(GlobalHistogramBinarizer(source));
  final QRCodeReader reader = QRCodeReader();

  try{
    final Result result = reader.decode(bitmap);
    return result.text;
  }on NotFoundException{
    return null; // 未识别到二维码
  }on FormatException{
    return null; // 格式错误
  }
}


Future<Uint8List> generateQrBytes({
  required String data,
  double size = 290,
  int quietZone = 2,
}) async {
  // 1. 编码
  final qrcode = Encoder.encode(data, ErrorCorrectionLevel.l);
  final matrix = qrcode.matrix!;

  // 2. 计算缩放（含边界）
  final totalModules = matrix.width + 2 * quietZone;
  final scale = (size / totalModules).floor();
  final actualSize = totalModules * scale;

  // 3. 创建画布
  final qrImage = img.Image(
    width: actualSize,
    height: actualSize,
    numChannels: 4,
  );

  // 白色背景
  img.fill(qrImage, color: img.ColorRgba8(255, 255, 255, 0xFF));

  // 黑色模块（偏移 quietZone）
  for (var y = 0; y < matrix.height; y++) {
    for (var x = 0; x < matrix.width; x++) {
      if (matrix.get(x, y) == 1) {
        img.fillRect(
          qrImage,
          x1: (x + quietZone) * scale,
          y1: (y + quietZone) * scale,
          x2: (x + quietZone) * scale + scale,
          y2: (y + quietZone) * scale + scale,
          color: img.ColorRgba8(0, 0, 0, 0xFF),
        );
      }
    }
  }

  return Uint8List.fromList(img.encodePng(qrImage));
}

/// 保存二维码到本地文件
Future<void> saveQrToFile(String data, String path) async{
  final bytes = await generateQrBytes(data: data);
  final file = File(path);
  if(!await file.exists()){
    await file.create(recursive: true);
  }
  await file.writeAsBytes(bytes);
}