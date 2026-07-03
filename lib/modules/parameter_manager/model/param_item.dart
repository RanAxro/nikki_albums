
import "param_type.dart";

class ParamItem{
  final String uuid;
  bool delete;
  final ParamType type;
  final ParamSubType? subType;
  final String value;
  final int time;
  String? title;
  String? description;
  List<String> tag;
  String? set;
  String? originImagePath;
  String? image;
  String? cacheParams;

  ParamItem({
    required this.uuid,
    this.delete = false,
    required this.type,
    required this.subType,
    required this.value,
    required this.time,
    this.title,
    this.description,
    required this.tag,
    this.set,
    this.originImagePath,
    this.image,
    this.cacheParams,
  });


  Map<String, dynamic> toMap() => {
    "uuid": uuid,
    "delete": delete,
    "type": type.toValue(),
    "sub_type": subType?.toValue(),
    "value": value,
    "time": time,
    "title": title,
    "description": description,
    "tag": tag,
    "set": set,
    "origin_image_path": originImagePath,
    "image": image,
    "cache_params": cacheParams,
  };

  static ParamItem? fromMap(Map<dynamic, dynamic> map){
    try{
      return ParamItem(
        uuid: map["uuid"] as String,
        delete: map["delete"] is bool ? map["delete"] : false,
        type: ParamType.fromValue(map["type"]) as ParamType,
        subType: ParamSubType.fromValue(map["sub_type"]),
        value: map["value"] as String,
        time: map["time"] as int,
        title: map["title"] is String? ? map["title"] : null,
        description: map["description"] is String? ? map["description"] : null,
        tag: map["tag"] is List ? (map["tag"] as List).whereType<String>().toList() : [],
        set: map["set"] is String? ? map["set"] : null,
        originImagePath: map["origin_image_path"] is String? ? map["origin_image_path"] : null,
        image: map["image"] is String? ? map["image"] : null,
        cacheParams: map["cache_params"] is String? ? map["cache_params"] : null,
      );
    }catch(e){
      return null;
    }
  }

  Map<int, dynamic> toMsgpackMap() => {
    1: uuid,
    2: delete,
    3: type.toValue(),
    4: subType?.toValue(),
    5: value,
    6: time,
    if(title != null) 7: title,
    if(description != null) 8: description,
    9: tag,
    if(set != null) 10: set,
    if(originImagePath != null) 11: originImagePath,
    if(image != null) 12: image,
    if(cacheParams != null) 13: cacheParams,
  };

  static ParamItem? fromMsgpackMap(Map<dynamic, dynamic> map){
    try{
      return ParamItem(
        uuid: map[1] as String,
        delete: map[2] is bool ? map[2] : false,
        type: ParamType.fromValue(map[3]) as ParamType,
        subType: ParamSubType.fromValue(map[4]),
        value: map[5] as String,
        time: map[6] as int,
        title: map[7] is String? ? map[7] : null,
        description: map[8] is String? ? map[8] : null,
        tag: map[9] is List ? (map[9] as List).whereType<String>().toList() : [],
        set: map[10] is String? ? map[10] : null,
        originImagePath: map[11] is String? ? map[11] : null,
        image: map[12] is String? ? map[12] : null,
        cacheParams: map[13] is String? ? map[13] : null,
      );
    }catch(e){
      return null;
    }
  }
}