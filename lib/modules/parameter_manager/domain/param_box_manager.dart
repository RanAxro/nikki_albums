

import "../model/param_box.dart";

import "dart:io";
import "dart:typed_data";

import "package:path/path.dart" as p;
import "package:uuid/v4.dart";
import "package:msgpack_dart/msgpack_dart.dart" as msgpack;


class ParamBoxManager{
  final File file;

  ParamBoxManager(this.file);

  late final ParamBox _box;

  Future<void> init() async{
    if(await file.exists()){
      final Uint8List bytes = await file.readAsBytes();
      final dynamic data = msgpack.deserialize(bytes);
      _box = ParamBox.fromMsgpackMap(data) as ParamBox;
    }else{
      _box = ParamBox(set: [], tag: [], item: []);
    }
  }

  Future<void> save() async{
    final Map<int, dynamic> data = _box.toMsgpackMap();
    final Uint8List bytes = msgpack.serialize(data);

    final String filename = UuidV4().generate();
    final String filePath = p.join(file.parent.path, filename);
    final File saveFile = File(filePath);
    await saveFile.writeAsBytes(bytes);

    await saveFile.rename(file.path);
  }
}