
import "../model/param_item.dart";
import "../model/param_box.dart";
import "../model/param_type.dart";
import "package:nikki_albums/modules/album/album.dart";
import "package:nikki_albums/utils/system/system.dart";

import "package:flutter/foundation.dart";
import "dart:io";

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

  List<ParamItem> get itemList => _box.item.where((ParamItem item) => !item.delete).toList();

  List<ParamItem> getSortedItemList([int Function(ParamItem, ParamItem)? compare]){
    final List<ParamItem> list = itemList;
    list.sort(compare ?? (a, b) => a.createdTime.compareTo(b.createdTime));
    return list;
  }

  String _generateAvailableUuid(){
    final Set<String> unusable = _box.item.map((ParamItem item) => item.uuid).toSet();
    unusable.addAll(_box.tag.map((ParamTag tag) => tag.uuid));
    unusable.addAll(_box.set.map((ParamSet set) => set.uuid));

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

  Future<bool> deleteImage(String uuid) async{
    final String imagePath = getImagePath(uuid);
    final File imageFile = File(imagePath);
    try{
      if(await imageFile.exists()){
        await imageFile.delete();
      }
      return true;
    }catch(e){
      return false;
    }
  }


  ParamItem? getItem(String uuid){
    for(final ParamItem item in _box.item){
      if(uuid == item.uuid){
        return item;
      }
    }
    return null;
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

  Future<void> setItem(String uuid, ParamItemCreation creation) async{
    final ParamItem? item = getItem(uuid);
    if(item == null) return;

    final int time = DateTime.timestamp().millisecondsSinceEpoch;

    item.modifiedTime = time;
    item.top = creation.top;
    item.title = creation.title;
    item.description = creation.description;
    item.tag = creation.tag;
    item.set = creation.set;
    if(creation.cover == null){
      item.originImagePath = null;
      item.image = null;
      await deleteImage(uuid);
    }else{
      if(creation.cover!.path != getImagePath(uuid)){
        bool hasImage = false;
        if(creation.cover != null){
          hasImage = await addImage(uuid, creation.cover!.path);
        }

        item.originImagePath = creation.cover!.path;
        item.image = hasImage ? uuid : null;
      }
    }

    notifyListeners();
  }


  List<ParamTag> get tagList => _box.tag;

  ParamTag? getTag(String uuid){
    for(final ParamTag tag in _box.tag){
      if(uuid == tag.uuid){
        return tag;
      }
    }
    return null;
  }

  List<ParamItem> getTagItems(String uuid){
    return _box.item.where((ParamItem item) => !item.delete && item.tag.contains(uuid)).toList();
  }

  void createTag(String name, int color, ParamType? specifiedType){
    _box.tag.add(ParamTag(
      uuid: _generateAvailableUuid(),
      name: name,
      color: color,
      specifiedType: specifiedType,
    ));

    notifyListeners();
  }

  void setTag(String uuid, {String? name, int? color}){
    final ParamTag? tag = getTag(uuid);

    if(name != null) tag?.name != null;
    if(color != null) tag?.color != null;

    notifyListeners();
  }

  bool deleteTag(String uuid){
    final ParamTag? tag = getTag(uuid);
    final bool result = _box.tag.remove(tag);

    for(final ParamItem item in _box.item){
      item.tag.remove(uuid);
    }

    notifyListeners();
    return tag != null && result;
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