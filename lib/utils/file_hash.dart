import "dart:io";
import "dart:typed_data";

import "package:crypto/crypto.dart";

Future<Digest> calculateFileHash(File file, {Hash? algorithm}) async {
  final Uint8List bytes = await file.readAsBytes();
  final Digest digest = (algorithm ?? sha256).convert(bytes);
  return digest;
}

Digest calculateFileHashSync(File file, {Hash? algorithm}) {
  final Uint8List bytes = file.readAsBytesSync();
  final Digest digest = (algorithm ?? sha256).convert(bytes);
  return digest;
}

Future<String> calculateFileHashString(File file, {Hash? algorithm}) async {
  final Digest digest = await calculateFileHash(file, algorithm: algorithm);
  return digest.toString();
}

String calculateFileHashStringSync(File file, {Hash? algorithm}) {
  return calculateFileHashSync(file, algorithm: algorithm).toString();
}

Digest calculateBytesHash(Uint8List bytes, {Hash? algorithm}) {
  final Digest digest = (algorithm ?? sha256).convert(bytes);
  return digest;
}

String calculateBytesHashString(Uint8List bytes, {Hash? algorithm}) {
  return calculateBytesHash(bytes, algorithm: algorithm).toString();
}

Future<Digest> calculateFileHashStream(File file, {Hash? algorithm}) async {
  final Stream<List<int>> stream = file.openRead();
  final Digest digest = await (algorithm ?? sha256).bind(stream).first;
  return digest;
}

Future<String> calculateFileHashStreamString(
  File file, {
  Hash? algorithm,
}) async {
  final Digest digest = await calculateFileHashStream(
    file,
    algorithm: algorithm,
  );
  return digest.toString();
}
