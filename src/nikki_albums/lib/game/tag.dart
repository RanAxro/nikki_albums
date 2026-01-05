import "uid.dart";
import "album_manager.dart";
import "image.dart";
import "package:nikkialbums/pages/album/album.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/api/path.dart";
import "package:nikkialbums/api/ini.dart";

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

typedef TagBoxType = List<Map<String, dynamic>>;
class Tag extends ChangeNotifier{
  final Path tagPath;
  TagBoxType? _tagBox;

  Tag(Path installPath) : tagPath = installPath + locateToTag{
    init();
  }


  Future<void> init() async{
    try{
      if(!await tagPath.file.exists()){
        _tagBox = [];
      }else{
        _tagBox = List<Map<String, dynamic>>.from(jsonDecode(await tagPath.file.readAsString()));
      }
    }catch(e){
      _tagBox = [];
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