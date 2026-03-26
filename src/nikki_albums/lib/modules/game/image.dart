
export "image_addition.dart";


import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:nikkialbums/modules/game/codec.dart";

import "image_addition.dart";
import "uid.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/utils/path.dart";






final Map<String, Field> _imageAdditionList = {};

void printAddition(BuildContext context, String path){
  final a = _imageAdditionList[path];

  String tre(Field f, [int level = 0]){
    String res = "${"  " * level}${f.isTranslateKey ? context.tr(f.stringKey, args: f.keyArgs) : f.key}";
    if(f.value != null){
      res = "$res : ${f.isTranslateValue ? context.tr(f.stringValue, args: f.valueArgs) : f.stringValue}";
    }
    if(f.children.isNotEmpty){
      for(final c in f.children){
        res = "$res\n${tre(c, level + 1)}";
      }
    }
    return res;
  }

  print(a == null ? null : tre(a));
}



enum ImageSource{
  game,
  backup,
  other,
}

class ImageItem{
  final int id;
  final ImageSource source;
  final Path path;
  final DateTime time;

  ImageItem({
    required this.source,
    required this.path,
    DateTime? time,
  }) :
    id = path.hashCode,
    time = time ?? path.stat.modified;

  String get name => path.name;

  bool isObtainedAddition(){
    return _imageAdditionList.containsKey(path.path);
  }

  Future<Field> getAddition(String? uid, AlbumType? albumType) async{
    if(uid == null || albumType == null) return InvaildParamsAddition();

    if(_imageAdditionList.containsKey(path.path)){
      return _imageAdditionList[path.path]!;
    }

    final dynamic json = await GameImageCodec.decodeFile(path.path, uid);

    switch(albumType){
      case AlbumType.NikkiPhotos_HighQuality || AlbumType.Collage_HighQuality:
        _imageAdditionList[path.path] = NikkiPhotoAddition.fromGameJson(nikkiPhotoJson: json);
        break;
      case AlbumType.Collage_CollagePhoto:
        _imageAdditionList[path.path] = CollageAddition.fromGameJson(collageJson: json);
        break;
      case AlbumType.ClockInPhoto:
        _imageAdditionList[path.path] = ExpeditionAddition.fromGameJson(expeditionJson: json);
        break;
      case AlbumType.DIY:
        _imageAdditionList[path.path] = DIYPhotoAddition.fromGameJson(DIYPhotoJson: json);
        break;
      default:
        _imageAdditionList[path.path] = InvaildParamsAddition();
        break;
    }

    return _imageAdditionList[path.path]!;
  }

  Field getAdditionSync(String? uid, AlbumType? albumType){
    if(uid == null || albumType == null) return InvaildParamsAddition();

    if(_imageAdditionList.containsKey(path.path)){
      return _imageAdditionList[path.path]!;
    }

    try{
      final dynamic json = GameImageCodec.decodeFileSync(path.path, uid);

      switch(albumType){
        case AlbumType.NikkiPhotos_HighQuality || AlbumType.Collage_CollagePhoto:
          _imageAdditionList[path.path] = NikkiPhotoAddition.fromGameJson(nikkiPhotoJson: json);
          break;
        case AlbumType.Collage_HighQuality:
          _imageAdditionList[path.path] = CollageAddition.fromGameJson(collageJson: json);
          break;
        case AlbumType.ClockInPhoto:
          _imageAdditionList[path.path] = ExpeditionAddition.fromGameJson(expeditionJson: json);
          break;
        case AlbumType.DIY:
          _imageAdditionList[path.path] = DIYPhotoAddition.fromGameJson(DIYPhotoJson: json);
          break;
        default:
          _imageAdditionList[path.path] = InvaildParamsAddition();
          break;
      }
    }catch(e){
      _imageAdditionList[path.path] = InvaildParamsAddition();
    }

    return _imageAdditionList[path.path]!;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ImageItem && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}

mixin AlbumPath{
  bool isAllowBackup(AlbumType type) => albumsInfoMap[type]!.locateInBackup != null;

  Path? getAlbumPath(Path installPath, AlbumType type, {Uid? uid, ImageSource source = ImageSource.game}){
    if(source == ImageSource.backup && !isAllowBackup(type)) return null;

    final AlbumsInfoItem info = albumsInfoMap[type]!;

    final String locate = source == ImageSource.game ? info.locateInGame : info.locateInBackup!;

    if(info.isRequireUid){
      if(uid == null) return null;

      return installPath + locate.replaceAll(r"$uid$", uid.value);
    }

    return installPath + locate;
  }
}






