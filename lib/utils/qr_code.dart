
import "dart:io";
import "dart:typed_data";

import "package:image/image.dart";
import "package:zxing2/qrcode.dart";


Future<String?> decodeQRCode(Uint8List bytes) async{
  // 读取图片
  final Image? image = decodePng(bytes);
  if(image == null) return null;

  // 创建 LuminanceSource（zxing2 需要灰度数据）
  final LuminanceSource source = RGBLuminanceSource(
    image.width,
    image.height,
    image.convert(numChannels: 4)
      .getBytes(order: ChannelOrder.abgr)
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