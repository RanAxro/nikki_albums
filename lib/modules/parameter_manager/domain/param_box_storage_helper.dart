
import "dart:io";
import "dart:typed_data";

import "package:msgpack_dart/msgpack_dart.dart" as msgpack;
import "package:path/path.dart" as p;

import "../model/param_box.dart";
import "../model/param_item.dart";


abstract final class ParamBoxStorageHelper{
  static File _getManifestFile(Directory directory){
    return File(p.join(directory.path, "manifest"));
  }

  static ParamBox? deParamBox(Uint8List bytes){
    final dynamic data = msgpack.deserialize(bytes);
    return ParamBox.fromMsgpackMap(data);
  }
  static Uint8List serParamBox(ParamBox paramBox){
    final Map<int, dynamic> data = paramBox.toMsgpackMap();
    return msgpack.serialize(data);
  }

  static Future<void> mergeParamBoxStorage(Directory src1, Directory src2, Directory dst) async{
    final ParamBox? box1 = await _checkCanMergeParamBoxStorage(src1, src2, dst);
    if(box1 == null){
      return;
    }

    final ParamBox? box2 = await _checkCanMergeParamBoxStorage(src2, src1, dst);
    if(box2 == null){
      return;
    }


    final List<ParamItem> mergedItems = [];
    final Map<String, ParamItem> map2 = Map.fromEntries(box2.item.map((item) => MapEntry(item.uuid, item)));
    for(final ParamItem item1 in box1.item){
      final String uuid = item1.uuid;
      if(map2.containsKey(uuid)){
        final ParamItem item2 = map2[uuid]!;
        if(item1.modifiedTime >= item2.modifiedTime){
          mergedItems.add(item1);
          await _safeCopyItemImage(src1, dst, item1.image);
        }else{
          mergedItems.add(item2);
          await _safeCopyItemImage(src2, dst, item2.image);
        }
        map2.remove(uuid);
      }else{
        mergedItems.add(item1);
        await _safeCopyItemImage(src1, dst, item1.image);
      }
    }
    for(final ParamItem item2 in map2.values){
      mergedItems.add(item2);
      await _safeCopyItemImage(src2, dst, item2.image);
    }

    final ParamBox mergedBox = ParamBox(
      set: mergeParamSet(box1.set, box2.set),
      tag: mergeParamTag(box1.tag, box2.tag),
      item: mergedItems,
    );

    final File manifest = _getManifestFile(dst);
    if(!(await manifest.exists())){
      await manifest.create(recursive: true);
    }
    await manifest.writeAsBytes(serParamBox(mergedBox));
  }
  static Future<ParamBox?> _checkCanMergeParamBoxStorage(Directory test, Directory another, Directory dst) async{
    final File manifest = _getManifestFile(test);
    if(await manifest.exists()){
      final ParamBox? boxOrNull = deParamBox(await manifest.readAsBytes());
      if(boxOrNull == null){
        await _copyDirectory(another, dst);
        return null;
      }else{
        return boxOrNull;
      }
    }else{
      await _copyDirectory(another, dst);
      return null;
    }
  }
  static Future<bool> _safeCopyItemImage(Directory src, Directory dst, String? uuid) async{
    if(p.equals(src.path, dst.path)){
      return true;
    }
    if(uuid != null){
      try{
        final String target = getImagePath(dst, uuid);
        final Directory targetParentDir = File(target).parent;
        if(!await targetParentDir.exists()){
          await targetParentDir.create(recursive: true);
        }
        await File(getImagePath(src, uuid)).copy(target);
        return true;
      }catch(e){
        print(e);
        return false;
      }
    }
    return false;
  }

  /// 文件后缀名不影响图片查看器识别, 这里统一使用 .png 后缀
  static String getImagePath(Directory directory, String uuid){
    return p.join(directory.path, "image", "$uuid.png");
  }

  static ParamBox mergeParamBox(ParamBox box1, ParamBox box2){
    return ParamBox(
      set: mergeParamSet(box1.set, box2.set),
      tag: mergeParamTag(box1.tag, box2.tag),
      item: mergeParamItems(box1.item, box2.item),
    );
  }

  static List<ParamSet> mergeParamSet(List<ParamSet> set1, List<ParamSet> set2){
    final List<ParamSet> res = [];
    final Map<String, ParamSet> map2 = Map.fromEntries(set2.map((setItem) => MapEntry(setItem.uuid, setItem)));
    for(final ParamSet setItem1 in set1){
      map2.remove(setItem1.uuid);
      res.add(setItem1);
    }
    res.addAll(map2.values);
    return res;
  }

  static List<ParamTag> mergeParamTag(List<ParamTag> tag1, List<ParamTag> tag2){
    final List<ParamTag> res = [];
    final Map<String, ParamTag> map2 = Map.fromEntries(tag2.map((tagItem) => MapEntry(tagItem.uuid, tagItem)));
    for(final ParamTag tagItem1 in tag1){
      map2.remove(tagItem1.uuid);
      res.add(tagItem1);
    }
    res.addAll(map2.values);
    return res;
  }

  static List<ParamItem> mergeParamItems(List<ParamItem> items1, List<ParamItem> items2){
    final List<ParamItem> res = [];
    final Map<String, ParamItem> map2 = Map.fromEntries(items2.map((item) => MapEntry(item.uuid, item)));
    for(final ParamItem item1 in items1){
      final String uuid = item1.uuid;
      if(map2.containsKey(uuid)){
        final ParamItem item2 = map2[uuid]!;
        if(item1.modifiedTime >= item2.modifiedTime){
          res.add(item1);
        }else{
          res.add(item2);
        }
        map2.remove(uuid);
      }else{
        res.add(item1);
      }
    }
    res.addAll(map2.values);
    return res;
  }
}

Future<void> _copyDirectory(Directory source, Directory destination) async{
  if(p.equals(source.path, destination.path)){
    return;
  }

  if(!await destination.exists()){
    await destination.create(recursive: true);
  }

  await for(final entity in source.list(recursive: false)){
    final newPath = p.join(destination.path, p.basename(entity.path));

    if(entity is File){
      await entity.copy(newPath);
    }else if (entity is Directory){
      await _copyDirectory(entity, Directory(newPath));
    }
  }
}