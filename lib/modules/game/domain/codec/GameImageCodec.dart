//
//
// import "dart:async";
// import "dart:convert";
// import "dart:io";
// import "dart:typed_data";
// import "package:crypto/crypto.dart";
// import "package:encrypt/encrypt.dart" as encrypt;
//
//
// class Key{
//   final Uint8List bytes;
//
//   const Key._(this.bytes);
//
//   factory Key.fromBytes(List<int> bytes){
//     return Key._(Uint8List.fromList(bytes));
//   }
//
//   /// 密钥派生函数：SHA1(UTF-16LE(seed)) + "_PAPER_GAMES"
//   factory Key.fromUid(String uid){
//     // UTF-16LE 编码
//     final Uint8List seedBytes = Uint8List(uid.length * 2);
//     for(int i = 0; i < uid.length; i++){
//       final code = uid.codeUnitAt(i);
//       seedBytes[i * 2] = code & 0xFF;
//       seedBytes[i * 2 + 1] = (code >> 8) & 0xFF;
//     }
//
//     // SHA1 哈希
//     final List<int> sha1Hash = sha1.convert(seedBytes).bytes;
//
//     // 添加后缀
//     final Uint8List suffix = ascii.encode("_PAPER_GAMES");
//     final Uint8List key = Uint8List(sha1Hash.length + suffix.length);
//     key.setRange(0, sha1Hash.length, sha1Hash);
//     key.setRange(sha1Hash.length, key.length, suffix);
//
//     return Key._(key);
//   }
// }
//
//
// abstract class GameImageDataProvider{
//   const GameImageDataProvider();
//
//   FutureOr<Uint8List> get bytes;
//
// // static FutureOr<Uint8List> extr(FutureOr<Uint8List> raw){
// //
// // }
// }
//
// class GameImageEncryptedData extends GameImageDataProvider{
//   @override
//   final Uint8List bytes;
//
//   const GameImageEncryptedData(this.bytes);
// }
//
// class GameImageBytes extends GameImageDataProvider{
//   final Uint8List imageBytes;
//
//   const GameImageBytes(this.imageBytes);
//
//   @override
//   FutureOr<Uint8List> get bytes => throw UnimplementedError();
// }
//
// class GameImageFile extends GameImageDataProvider{
//   final File file;
//
//   const GameImageFile(this.file);
//
//   @override
//   Future<Uint8List> get bytes{
//     return file.readAsBytes();
//   }
// }
//
//
//
//
//
// abstract class GameImageDataReceiver{
//   const GameImageDataReceiver();
//
//   FutureOr<Uint8List> get imageBytes;
//
//
// }
//
//
// enum GameImageCodecException{
//   lackFFD9,
//   notJson,
// }
//
// abstract class GameImageCodec{
//   static Future<dynamic> decode(GameImageDataProvider provider, Key key) async{
//     final Uint8List bytes = await provider.bytes;
//
//     // 尝试解析数据（ Base64 文本）
//     final base64Text = utf8.decode(bytes, allowMalformed: true).trim();
//     if(base64Text == "Invaild Params") return null;
//     final Uint8List encrypted = base64.decode(base64Text);
//
//     // AES-256-ECB 解密
//     final encrypt.Key encKey = encrypt.Key(key.bytes);
//     final encrypt.Encrypter aesCipher = encrypt.Encrypter(
//       encrypt.AES(encKey, mode: encrypt.AESMode.ecb, padding: null),
//     );
//     final List<int> decryptedBytes = aesCipher.decryptBytes(
//       encrypt.Encrypted(encrypted),
//     );
//
//     // 解码为 UTF-8 文本
//     final String decryptedText = utf8.decode(decryptedBytes, allowMalformed: true);
//
//     // 提取 JSON 对象
//     final startIdx = decryptedText.indexOf("{");
//     if(startIdx == -1) throw GameImageCodecException.notJson;
//
//     // 匹配大括号找到 JSON 结束位置
//     int braceCount = 0;
//     int endIdx = 0;
//     for(int i = startIdx; i < decryptedText.length; i++){
//       if(decryptedText[i] == "{"){
//         braceCount++;
//       }else if(decryptedText[i] == "}"){
//         braceCount--;
//         if(braceCount == 0){
//           endIdx = i;
//           break;
//         }
//       }
//     }
//     if(endIdx == 0) throw GameImageCodecException.notJson;
//
//     final String jsonStr = decryptedText.substring(startIdx, endIdx + 1);
//
//     return GameJsonCodec.decode(jsonStr);
//   }
// }
//
//
//
//
//
//
//
