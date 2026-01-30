// import "path.dart";
//
// import "dart:io";
// import "dart:typed_data";
//
// import "package:super_drag_and_drop/super_drag_and_drop.dart";
// import 'package:mime/mime.dart';
//
//
// DragItem createFilesDragItem(List<Path> paths){
//   print(paths.length);
//
//   final item = DragItem(
//     localData: paths.map((path) => path.path).toList(growable: false),
//   );
//
//   for(Path path in paths){
//     item.addVirtualFile(
//       format: Formats.jpeg,
//       provider: (sinkFactory, writeProgress) async{
//         final fileSize = await path.file.length();
//         final sink = sinkFactory(fileSize: fileSize);
//
//         sink.add(await path.file.readAsBytes());
//         sink.close();
//
//         // path.file.openRead().listen(
//         //   (List<int> chunk) => sink.add(chunk),
//         //   onError: (e) => sink.addError(e),
//         //   onDone: () => sink.close(),
//         //   cancelOnError: true,
//         // );
//       },
//     );
//   }
//   return item;
// }