import "path.dart";

import "package:super_clipboard/super_clipboard.dart";

Future<bool> copyFilesToClipboard(List<Path> paths) async{
  final items = <DataWriterItem>[];

  for(final path in paths){
    final uri = Uri.file(path.path);
    final item = DataWriterItem();
    item.add(Formats.fileUri(uri));
    items.add(item);
  }

  final clipboard = SystemClipboard.instance;

  if(clipboard == null) return false;

  await SystemClipboard.instance!.write(items);

  return true;
}



Future<List<Path>> readFilesFromClipboard() async{
  final List<Path> res = [];

  final clipboard = SystemClipboard.instance;
  if(clipboard == null) return res;

  final ClipboardReader reader = await clipboard.read();

  for(final item in reader.items){
    if(item.canProvide(Formats.fileUri)){
      final Uri? uri = await item.readValue(Formats.fileUri);
      if(uri == null) continue;

      final Path path = Path(uri.toFilePath());
      if(await path.file.exists()) res.add(path);
    }
  }
  return res;
}