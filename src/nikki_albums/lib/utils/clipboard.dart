
import "path.dart";

import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "dart:async";
import "dart:io";

import "package:super_clipboard/super_clipboard.dart";

Future<void> copyTextToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

Future<bool> copyFilesToClipboard(List<Path> paths) async {
  final items = <DataWriterItem>[];

  for (final path in paths) {
    final uri = Uri.file(path.path);
    final item = DataWriterItem();
    item.add(Formats.fileUri(uri));
    items.add(item);
  }

  final clipboard = SystemClipboard.instance;

  if (clipboard == null) return false;

  await SystemClipboard.instance!.write(items);

  return true;
}

Future<String?> readTextFromClipboard() async{
  final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

  if(data != null && data.text != null){
    return data.text;
  }else{
    return null;
  }
}

Future<List<Path>> readFilesFromClipboard() async {
  final List<Path> res = [];

  final clipboard = SystemClipboard.instance;
  if (clipboard == null) return res;

  final ClipboardReader reader = await clipboard.read();

  for (final item in reader.items) {
    if (item.canProvide(Formats.fileUri)) {
      final Uri? uri = await item.readValue(Formats.fileUri);
      if (uri == null) continue;

      final Path path = Path(uri.toFilePath());
      if (await path.file.exists()) res.add(path);
    }
  }
  return res;
}



Future<Uint8List?> readImageFromClipboard({String? savePath}) async{
  final SystemClipboard? clipboard = SystemClipboard.instance;
  if(clipboard == null) return null;

  final ClipboardReader reader = await clipboard.read();

  final List<SimpleFileFormat> formats = [
    Formats.png,
    Formats.jpeg,
    Formats.bmp,
    Formats.tiff,
    Formats.gif,
  ];

  for(final SimpleFileFormat format in formats){
    if(!reader.canProvide(format)) continue;

    final Completer completer = Completer<Uint8List?>();

    reader.getFile(format, (file) async{
      try{
        final bytes = await file.readAll();
        completer.complete(bytes);
      }catch(e){
        completer.complete(null);
      }
    });

    // 超时保护，防止回调不触发导致永久挂起
    Future.delayed(const Duration(seconds: 5), (){
      if(!completer.isCompleted) completer.complete(null);
    });

    final Uint8List? imageBytes = await completer.future;

    if(imageBytes != null && savePath != null){
      try{
        await File(savePath).writeAsBytes(imageBytes);
      }catch(e){
        debugPrint("保存图片失败: $e");
      }
    }

    return imageBytes;
  }

  return null;
}