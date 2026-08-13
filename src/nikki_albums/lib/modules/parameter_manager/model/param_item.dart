
import "param_type.dart";

import "package:flutter/foundation.dart";


abstract class ParamItemCover{
  final String path;

  const ParamItemCover({required this.path});
}

class NativeParamItemCover extends ParamItemCover{
  final bool isCache;

  const NativeParamItemCover({required super.path, required this.isCache});
}

class NetworkParamItemCover extends ParamItemCover{
  const NetworkParamItemCover({required super.path});
}

class ParamItemCreation{
  final ParamType type;
  final String value;
  final bool top;
  final String? title;
  final String? description;
  final List<String> tag;
  final String? set;
  final ParamItemCover? cover;

  const ParamItemCreation({
    required this.type,
    required this.value,
    this.top = false,
    this.title,
    this.description,
    this.tag = const [],
    this.set,
    this.cover,
  });
}

class ParamItem{
  final String uuid;
  bool delete;
  final ParamType type;
  final String value;
  final int createdTime;
  int modifiedTime;
  bool top;
  String? title;
  String? description;
  List<String> tag;
  String? set;
  String? originImagePath;
  String? image;

  ParamItem({
    required this.uuid,
    this.delete = false,
    required this.type,
    required this.value,
    required this.createdTime,
    required this.modifiedTime,
    this.top = false,
    this.title,
    this.description,
    required this.tag,
    this.set,
    this.originImagePath,
    this.image,
  });


  Map<String, dynamic> toMap() => {
    "uuid": uuid,
    "delete": delete,
    "type": type.toValue(),
    "value": value,
    "created_time": createdTime,
    "modified_time": modifiedTime,
    "top": top,
    "title": title,
    "description": description,
    "tag": tag,
    "set": set,
    "origin_image_path": originImagePath,
    "image": image,
  };

  static ParamItem? fromMap(dynamic map){
    if(map is! Map){
      return null;
    }

    try{
      return ParamItem(
        uuid: map["uuid"] as String,
        delete: map["delete"] is bool ? map["delete"] : false,
        type: ParamType.fromValue(map["type"]) as ParamType,
        value: map["value"] as String,
        createdTime: map["created_time"] as int,
        modifiedTime: map["modified_time"] as int,
        top: map["top"] is bool ? map["top"] : false,
        title: map["title"] is String? ? map["title"] : null,
        description: map["description"] is String? ? map["description"] : null,
        tag: map["tag"] is List ? (map["tag"] as List).whereType<String>().toList() : [],
        set: map["set"] is String? ? map["set"] : null,
        originImagePath: map["origin_image_path"] is String? ? map["origin_image_path"] : null,
        image: map["image"] is String? ? map["image"] : null,
      );
    }catch(e){
      return null;
    }
  }

  Map<int, dynamic> toMsgpackMap() => {
    1: uuid,
    2: delete,
    3: type.toValue(),
    4: value,
    5: createdTime,
    6: modifiedTime,
    7: top,
    if(title != null) 8: title,
    if(description != null) 9: description,
    10: tag,
    if(set != null) 11: set,
    if(originImagePath != null) 12: originImagePath,
    if(image != null) 13: image,
  };

  static ParamItem? fromMsgpackMap(dynamic map){
    if(map is! Map){
      return null;
    }

    try{
      return ParamItem(
        uuid: map[1] as String,
        delete: map[2] is bool ? map[2] : false,
        type: ParamType.fromValue(map[3]) as ParamType,
        value: map[4] as String,
        createdTime: map[5] as int,
        modifiedTime: map[6] as int,
        top: map[7] is bool ? map[7] : false,
        title: map[8] is String? ? map[8] : null,
        description: map[9] is String? ? map[9] : null,
        tag: map[10] is List ? (map[10] as List).whereType<String>().toList() : [],
        set: map[11] is String? ? map[11] : null,
        originImagePath: map[12] is String? ? map[12] : null,
        image: map[13] is String? ? map[13] : null,
      );
    }catch(e, s){
      if(kDebugMode){
        print(e);
        debugPrintStack(stackTrace: s);
      }
      return null;
    }
  }
}