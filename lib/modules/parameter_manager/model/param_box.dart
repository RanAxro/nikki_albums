
import "param_type.dart";
import "param_item.dart";

import "package:flutter/foundation.dart";


class ParamBox{
  final List<ParamSet> set;
  final List<ParamTag> tag;
  final List<ParamItem> item;

  ParamBox({
    required this.set,
    required this.tag,
    required this.item,
  });


  Map<String, dynamic> toMap() => {
    "set": set.map((ParamSet set) => set.toMap()).toList(),
    "tag": tag.map((ParamTag tag) => tag.toMap()).toList(),
    "item": item.map((ParamItem item) => item.toMap()).toList(),
  };

  static ParamBox? fromMap(Map<dynamic, dynamic> map){
    try{
      return ParamBox(
        set: (map["set"] as List).map(ParamSet.fromMap).nonNulls.toList(),
        tag: (map["tag"] as List).map(ParamTag.fromMap).nonNulls.toList(),
        item: (map["item"] as List).map(ParamItem.fromMap).nonNulls.toList() ,
      );
    }catch(e){
      return null;
    }
  }

  Map<int, dynamic> toMsgpackMap() => {
    1: set.map((ParamSet set) => set.toMsgpackMap()).toList(),
    2: tag.map((ParamTag tag) => tag.toMsgpackMap()).toList(),
    3: item.map((ParamItem item) => item.toMsgpackMap()).toList(),
  };

  static ParamBox? fromMsgpackMap(Map<dynamic, dynamic> map){
    try{
      return ParamBox(
        set: (map[1] as List).map(ParamSet.fromMsgpackMap).nonNulls.toList(),
        tag: (map[2] as List).map(ParamTag.fromMsgpackMap).nonNulls.toList(),
        item: (map[3] as List).map(ParamItem.fromMsgpackMap).nonNulls.toList(),
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

class ParamSet{
  final String uuid;
  String name;
  final List<ParamType> allowType;
  final List<ParamSet> children;

  ParamSet({
    required this.uuid,
    required this.name,
    required this.allowType,
    required this.children,
  });


  Map<String, dynamic> toMap() => {
    "uuid": uuid,
    "name": name,
    "allow_type": allowType.map((ParamType type) => type.toValue()).toList(),
    "children": children.map((ParamSet set) => set.toMap()).toList(),
  };

  static ParamSet? fromMap(dynamic map){
    if(map is! Map){
      return null;
    }

    try{
      return ParamSet(
        uuid: map["uuid"] as String,
        name: map["name"] as String,
        allowType: (map["allow_type"] as List).map(ParamType.fromValue).toList() as List<ParamType>,
        children: map["children"] is List ? (map["children"] as List<Map>).map(ParamSet.fromMap).toList() as List<ParamSet> : [],
      );
    }catch(e){
      return null;
    }
  }

  Map<int, dynamic> toMsgpackMap() => {
    1: uuid,
    2: name,
    3: allowType.map((ParamType type) => type.toValue()).toList(),
    if(children.isNotEmpty) 4: children.map((ParamSet set) => set.toMsgpackMap()).toList(),
  };

  static ParamSet? fromMsgpackMap(dynamic map){
    if(map is! Map){
      return null;
    }

    try{
      return ParamSet(
        uuid: map[1] as String,
        name: map[2] as String,
        allowType: (map[3] as List).map(ParamType.fromValue).toList() as List<ParamType>,
        children: map[4] is List ? (map[4] as List<Map>).map(ParamSet.fromMsgpackMap).toList() as List<ParamSet> : [],
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

class ParamTag{
  final String uuid;
  String name;

  ParamTag({
    required this.uuid,
    required this.name,
  });


  Map<String, dynamic> toMap() => {
    "uuid": uuid,
    "name": name,
  };

  static ParamTag? fromMap(dynamic map){
    if(map is! Map){
      return null;
    }

    try{
      return ParamTag(
        uuid: map["uuid"] as String,
        name: map["name"] as String,
      );
    }catch(e){
      return null;
    }
  }

  Map<int, dynamic> toMsgpackMap() => {
    1: uuid,
    2: name,
  };

  static ParamTag? fromMsgpackMap(dynamic map){
    if(map is! Map){
      return null;
    }

    try{
      return ParamTag(
        uuid: map[1] as String,
        name: map[2] as String,
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