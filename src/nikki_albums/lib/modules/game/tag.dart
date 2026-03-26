import "dart:typed_data";

import "uid.dart";
import "album_manager.dart";
import "image.dart";
import "package:nikkialbums/modules/album/album.dart";
import "package:nikkialbums/modules/app_base/state.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/utils/path.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:async";
import "dart:convert";

import "package:win32_registry/win32_registry.dart";


// [
//   {
//     "name":  if name is null, it is default tag
//     "color": 0xFFFFFFFF,
//     "tags": [
//
//     ]
//   }
// ]


abstract class TagGroup{
  final Color color;
  final Set<String> _tags;
  final Set<void Function()> _listeners = const {};

  const TagGroup({
    required this.color,
    required Set<String> tags,
    void Function()? listener,
  }) :
    _tags = tags;


  bool contains(String value) => _tags.contains(value);

  void add(String value){
    _tags.add(value);
    call();
  }

  void addAll(Set<String> values){
    _tags.addAll(values);
    call();
  }

  void remove(String value){
    _tags.remove(value);
    call();
  }

  void removeAll(Set<String> values){
    _tags.removeAll(values);
    call();
  }

  void addListener(void Function() listener){
    _listeners.add(listener);
  }

  void removeListener(void Function() listener){
    _listeners.remove(listener);
  }

  void dispose(){
    _listeners.clear();
  }

  void call(){
    for(final void Function() listener in _listeners){
      listener.call();
    }
  }
}

class PresetTagGroup extends TagGroup{
  static const Color defaultColor = Colors.orange;

  const PresetTagGroup({
    Set<String>? tags,
    super.listener,
  }) : super(
    color: defaultColor,
    tags: tags ?? const <String>{},
  );
}

class CustomTagGroup extends TagGroup{
  static const Color defaultColor = Colors.orange;

  final String name;

  const CustomTagGroup({
    required this.name,
    Color? color,
    Set<String>? tags,
    super.listener,
  }) : super(
    color: color ?? defaultColor,
    tags: tags ?? const <String>{},
  );
}

class TagBox extends ChangeNotifier{
  final PresetTagGroup _presetGroup;
  final Map<String, CustomTagGroup> _customGroups;

  TagBox._({
    PresetTagGroup? presetGroup,
    required Map<String, CustomTagGroup> customGroups,
  }) :
    _presetGroup = presetGroup ?? PresetTagGroup(),
    _customGroups = customGroups
  {
    _presetGroup.addListener(notifyListeners);
    for(final CustomTagGroup group in _customGroups.values){
      group.addListener(notifyListeners);
    }
  }

  factory TagBox(Iterable<TagGroup> groups){
    PresetTagGroup? presetGroup;
    final Map<String, CustomTagGroup> customGroups = {};

    for(final TagGroup tagGroup in groups){
      switch(tagGroup){
        case PresetTagGroup():
          presetGroup = tagGroup;
        case CustomTagGroup():
          customGroups[tagGroup.name] = tagGroup;
      }
    }

    return TagBox._(
      presetGroup: presetGroup,
      customGroups: customGroups,
    );
  }

  PresetTagGroup get getPresetTag => _presetGroup;

  bool contains(String name) => _customGroups.containsKey(name);

  CustomTagGroup? getCustomTag(String name) => _customGroups[name];

  CustomTagGroup? deleteCustomTag(String name){
    getCustomTag(name)?.dispose();
    final CustomTagGroup? deletedGroup = _customGroups.remove(name);
    notifyListeners();
    return deletedGroup;
  }

  CustomTagGroup setCustomTag(String name, {String? newName, Color? color, Set<String>? tags}){
    final CustomTagGroup? maybeGroup = getCustomTag(name);
    final String setName = newName ?? name;

    if(maybeGroup == null){
      _customGroups[setName] = CustomTagGroup(name: setName, color: color, tags: tags)..addListener(notifyListeners);
    }else{
      _customGroups[setName] = CustomTagGroup(name: setName, color: color ?? maybeGroup.color, tags: tags ?? maybeGroup._tags)..addListener(notifyListeners);

      if(name != newName){
        deleteCustomTag(name);
      }
    }

    notifyListeners();
    return _customGroups[setName]!;
  }

  @override
  void dispose(){
    _presetGroup.dispose();
    for(final CustomTagGroup group in _customGroups.values){
      group.dispose();
    }
    super.dispose();
  }
}



abstract class TagCodec{
  static TagCodec byVersion(int version) => switch(version){
    0 => const TagCodec0(),
    1 => const TagCodec1(),
    _ => const GeneralTagCodec(),
  };

  final int version;

  const TagCodec({
    required this.version,
  });

  Tag decode(Uint8List bytes);

  Uint8List encode(Tag tag);
}

class GeneralTagCodec extends TagCodec{
  const GeneralTagCodec() : super(version: -1);

  @override
  Tag decode(Uint8List bytes){
    // TODO: implement decode
    throw UnimplementedError();
  }

  @override
  Uint8List encode(Tag tag){
    // TODO: implement encode
    throw UnimplementedError();
  }
}

class TagCodec0 extends TagCodec{
  const TagCodec0() : super(version: 0);

  @override
  Tag decode(Uint8List bytes){
    // TODO: implement decode
    throw UnimplementedError();
  }

  @override
  Uint8List encode(Tag tag){
    // TODO: implement encode
    throw UnimplementedError();
  }
}

class TagCodec1 extends TagCodec{
  const TagCodec1() : super(version: 1);

  @override
  Tag decode(Uint8List bytes){
    // TODO: implement decode
    throw UnimplementedError();
  }

  @override
  Uint8List encode(Tag tag){
    // TODO: implement encode
    throw UnimplementedError();
  }
}


const t = {
  "uid": [
    {
      "isPreset": false,
      "name": "name",
      "color": 0xFFFFFFFF,
      "labeled": [
        "imageFilename",
      ]
    }
  ]
};



typedef TagBoxType = List<Map<String, dynamic>>;
class Tag extends ChangeNotifier{
  final Path tagPath;
  TagBoxType? _tagBox;

  Tag(Path installPath) : tagPath = installPath + locateToTag{
    init();
  }

  static TagBoxType defaultBox = [
    {
      "name": null,
      "color": Colors.orange.toARGB32(),
      "tags": []
    }
  ];

  Future<void> init() async{
    try{
      if(!await tagPath.file.exists()){
        _tagBox = defaultBox;
      }else{
        _tagBox = List<Map<String, dynamic>>.from(jsonDecode(await tagPath.file.readAsString()));
      }
    }catch(e){
      _tagBox = defaultBox;
      AppState.writeError("tag.read", e.toString());
    }finally{
      notifyListeners();
    }
  }

  Future<void> save() async{
    try{
      if(!await tagPath.file.exists()){
        await tagPath.file.create(recursive: true);
      }

      // 编码并写入配置
      final String json = jsonEncode(_tagBox);
      await tagPath.file.writeAsString(json);
    }catch(e){
      AppState.writeError("tag.save", e.toString());
    }
  }

  Set<String?> get tagList{
    final Set<String?> res = {};

    if(_tagBox == null) return res;

    for(final Map<String, dynamic> item in _tagBox!){
      if(item.containsKey("name") && item["name"] is String?){
        res.add(item["name"]);
      }
    }

    return res;
  }

  List<String>? getValues(String? tag){
    if(_tagBox == null) return null;

    for(final Map<String, dynamic> item in _tagBox!){
      if(item.containsKey("name") && item["name"] == tag){
        if(item["tags"] is List){
          return List<String>.from(item["tags"]);
        }
      }
    }
    return null;
  }

  void add(String? tag, Iterable<String> values){
    if(_tagBox == null) return;

    remove(values);

    for(final Map<String, dynamic> item in _tagBox!){
      if(item.containsKey("name") && item["name"] == tag){
        if(item["tags"] is List){
          for(final String value in values){
            if(!(item["tags"] as List).contains(value)) (item["tags"] as List).addAll(values);
          }
        }else{
          item["tags"] = values.toList();
        }

        notifyListeners();
        save();
        return;
      }
    }

    _tagBox!.add({
      "name": tag,
      "color": Colors.orange.toARGB32(),
      "tags": values.toList(),
    });

    notifyListeners();
    save();
  }

  void remove(Iterable<String> values){
    if(_tagBox == null) return;

    for(final Map<String, dynamic> item in _tagBox!){
      if(item.containsKey("name")){
        if(item["tags"] is List){
          (item["tags"] as List).removeWhere((item) => values.contains(item));
        }
      }
    }

    notifyListeners();
    save();
  }

  void rename(String tag, String name){
    if(_tagBox == null) return;

    if(!tagList.contains(tag) || tagList.contains(name)) return;

    for(final Map<String, dynamic> item in _tagBox!){
      if(item["name"] == tag){
        item["name"] = name;

        notifyListeners();
        save();
        return;
      }
    }
  }

  void delete(String tag){
    if(_tagBox == null) return;

    if(!tagList.contains(tag)) return;

    _tagBox!.removeWhere((item) => item.containsKey("name") && item["name"] == tag);

    notifyListeners();
    save();
  }

  Color? getColor(String? tag){
    if(_tagBox == null) return null;

    for(final Map<String, dynamic> item in _tagBox!){
      if(item.containsKey("name") && item["name"] == tag){
        if(item["color"] is int){
          return Color(item["color"]);
        }else{
          return Colors.orange;
        }
      }
    }

    return null;
  }

  void setColor(String tag, Color color){
    if(_tagBox == null) return;

    for(final Map<String, dynamic> item in _tagBox!){
      if(item.containsKey("name") && item["name"] == tag){
        item["color"] = color.toARGB32();
      }
    }

    notifyListeners();
    save();
  }

  /// 如果找到则返回 tag
  /// 否则返回 false
  dynamic findTagBy(String value){
    if(_tagBox == null) return false;

    for(final Map<String, dynamic> item in _tagBox!){
      if(!item.containsKey("name")) return false;

      if(item["tags"] is List){
        if((item["tags"] as List).contains(value)){
          return item["name"];
        }
      }
    }

    return false;
  }

  Color? findTagColorBy(String value){
    if(_tagBox == null) return null;

    for(final Map<String, dynamic> item in _tagBox!){
      if(!item.containsKey("name")) return null;

      if(item["tags"] is List && item["color"] is int){
        if((item["tags"] as List).contains(value)){
          return Color(item["color"]);
        }
      }
    }

    return null;
  }
}











