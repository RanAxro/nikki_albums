
import "package:nikki_albums/modules/album/album.dart";

import "../model/param_item.dart";
import "../model/param_box.dart";
import "package:nikki_albums/utils/system/system.dart";

import "dart:io";
import "package:flutter/foundation.dart";

import "package:path/path.dart" as p;
import "package:uuid/v4.dart";
import "package:msgpack_dart/msgpack_dart.dart" as msgpack;
import "package:dio/dio.dart";


Future<String?> downloadImage(String url) async{
  try{
    final String savePath = p.join((await getTempPath()).path, "NetworkImage");
    final Dio dio = Dio();
    final Response response = await dio.download(url, savePath);
    if(response.statusCode == 200){
      return savePath;
    }else{
      return null;
    }
  }catch(e){
    return null;
  }
}

class ParamBoxManager extends ChangeNotifier{
  static ParamBoxManager? _defaultParamBox;

  static Future<String> getDefaultParamBoxPath() async{
    final String basePath = (await getAppDataDirectoryPath()).path;
    return p.join(basePath, "ParamBox");
  }

  static Future<ParamBoxManager> getDefaultParamBox() async{
    _defaultParamBox ??= ParamBoxManager(Directory(await getDefaultParamBoxPath()));

    return _defaultParamBox!;
  }


  final Directory directory;
  final File manifestFile;

  ParamBoxManager(this.directory) : manifestFile = File(p.join(directory.path, "manifest"));

  late final ParamBox _box;

  bool isInit = false;

  Future<void> init() async{
    if(await manifestFile.exists()){
      final Uint8List bytes = await manifestFile.readAsBytes();
      final dynamic data = msgpack.deserialize(bytes);
      final ParamBox? boxOr = ParamBox.fromMsgpackMap(data);
      if(boxOr == null){
        return;
      }
      _box = boxOr;
    }else{
      _box = ParamBox(set: [], tag: [], item: []);
    }
    isInit = true;
  }

  Future<void> save() async{
    final Map<int, dynamic> data = _box.toMsgpackMap();
    final Uint8List bytes = msgpack.serialize(data);

    final String filename = UuidV4().generate();
    final String filePath = p.join(directory.path, filename);
    final File saveFile = File(filePath);
    await saveFile.create(recursive: true);
    await saveFile.writeAsBytes(bytes);

    await saveFile.rename(manifestFile.path);
  }

  List<ParamItem> get items => _box.item.where((ParamItem item) => !item.delete).toList();

  String _generateAvailableUuid(){
    final Set<String> unusable = _box.item.map((ParamItem item) => item.uuid).toSet();
    while(true){
      final String uuid = UuidV4().generate();
      if(!unusable.contains(uuid)){
        return uuid;
      }
    }
  }

  /// 文件后缀名不影响图片查看器识别, 这里统一使用 .png 后缀
  String getImagePath(String uuid) => p.join(directory.path, "image", "$uuid.png");

  Future<bool> addImage(String uuid, String source) async{
    final String targetPath = getImagePath(uuid);
    final File targetFile = File(targetPath);

    late final File sourceFile;

    if(source.startsWith("http://") || source.startsWith("https://")){
      final String? sourcePath = await downloadImage(source);
      if(sourcePath == null){
        return false;
      }
      sourceFile = File(sourcePath);
    }else{
      sourceFile = File(source);
    }
    try{
      if(!await targetFile.exists()){
        await targetFile.create(recursive: true);
      }
      if(await sourceFile.exists()){
        await sourceFile.copy(targetPath);
        return true;
      }else{
        return false;
      }
    }catch(e, s){
      if(kDebugMode){
        print(e);
        debugPrintStack(stackTrace: s);
      }
      return false;
    }
  }

  Future<void> createItem(ParamItemCreation creation) async{
    final String uuid = _generateAvailableUuid();
    final int time = DateTime.timestamp().millisecondsSinceEpoch;

    bool hasImage = false;
    if(creation.cover != null){
      hasImage = await addImage(uuid, creation.cover!.path);
    }

    _box.item.add(ParamItem(
      uuid: uuid,
      delete: false,
      type: creation.type,
      value: creation.value,
      createdTime: time,
      modifiedTime: time,
      top: creation.top,
      title: creation.title,
      description: creation.description,
      tag: creation.tag,
      set: creation.set,
      originImagePath: creation.cover?.path,
      image: hasImage ? uuid : null,
    ));

    notifyListeners();
  }

  bool deleteItem(String uuid){
    for(final item in _box.item){
      if(item.uuid == uuid){
        item.delete = true;

        notifyListeners();
        return true;
      }
    }

    notifyListeners();
    return false;
  }
}