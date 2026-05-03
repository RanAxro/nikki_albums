export "image_addition.dart";

import "package:easy_localization/easy_localization.dart";
import "package:nikki_albums/modules/game/codec.dart";

import "image_addition.dart";
import "uid.dart";
import "package:nikki_albums/info.dart";
import "package:nikki_albums/utils/path.dart";

final Map<String, Field> _imageAdditionList = {};

void printAddition(String path){
  final a = _imageAdditionList[path];

  String tre(Field f, [int level = 0]){
    String res = "${"  " * level}${f.isTranslateKey ? tr(f.stringKey, args: f.keyArgs) : f.key}";
    if(f.value != null){
      res = "$res : ${f.isTranslateValue ? tr(f.stringValue, args: f.valueArgs) : f.stringValue}";
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


abstract class ImageAddition{
  static Field toField(AlbumType albumType, dynamic json){
    switch(albumType){
      case AlbumType.NikkiPhotos_HighQuality || AlbumType.Collage_CollagePhoto:
        return NikkiPhotoAddition.fromGameJson(
          nikkiPhotoJson: json,
        );
      case AlbumType.Collage_HighQuality:
        return CollageAddition.fromGameJson(
          collageJson: json,
        );
      case AlbumType.ClockInPhoto:
        return ExpeditionAddition.fromGameJson(
          expeditionJson: json,
        );
      case AlbumType.DIY:
        return DIYPhotoAddition.fromGameJson(
          DIYPhotoJson: json,
        );
      default:
        return const InvaildParamsAddition();
    }
  }

  static Field fileSync(AlbumType albumType, String path, String uid){
    // if(!kDebugMode){
    //   if(_imageAdditionList.containsKey(path)){
    //     return _imageAdditionList[path]!;
    //   }
    // }

    if(_imageAdditionList.containsKey(path)){
      return _imageAdditionList[path]!;
    }

    try{
      final dynamic json = GameImageCodec.decodeFileSync(path, uid);

      _imageAdditionList[path] = toField(albumType, json);
    }catch(e){
      _imageAdditionList[path] = const InvaildParamsAddition();
    }

    return _imageAdditionList[path]!;
  }

  static Future<Field> file(AlbumType albumType, String path, String uid) async{
    // if(!kDebugMode){
    //   if(_imageAdditionList.containsKey(path)){
    //     return _imageAdditionList[path]!;
    //   }
    // }

    if(_imageAdditionList.containsKey(path)){
      return _imageAdditionList[path]!;
    }

    try{
      final dynamic json = await GameImageCodec.decodeFile(path, uid);

      _imageAdditionList[path] = toField(albumType, json);
    }catch(e){
      _imageAdditionList[path] = const InvaildParamsAddition();
    }

    return _imageAdditionList[path]!;
  }

  static Future<List<Field>> files(AlbumType albumType, List<String> paths, String uid, {void Function(int, int)? onProgress}) async{
    final List<String> need = [];

    for(final String path in paths){
      if(_imageAdditionList.containsKey(path)){
        continue;
      }

      need.add(path);
    }

    try{
      final List<dynamic> jsons = await GameImageCodec.decodeFiles(need, uid, onProgress: (c, t) => onProgress?.call(c, t + 1));

      for(int i = 0; i < need.length; i++){
        _imageAdditionList[need[i]] = toField(albumType, jsons[i]);
      }

      onProgress?.call(1, 1);
    }catch(e){
      for(int i = 0; i < need.length; i++){
        _imageAdditionList[need[i]] = const InvaildParamsAddition();
      }
    }finally{
      onProgress?.call(1, 1);
    }

    final List<Field> res = [];
    for(final String path in paths){
      res.add(_imageAdditionList[path]!);
    }

    return res;
  }
}


enum ImageSource{
  game,
  backup,
  other
}

class ImageItem {
  final int id;
  final ImageSource source;
  final Path path;
  final DateTime time;
  final bool isVideo;
  final String? cover;

  ImageItem({required this.source, required this.path, DateTime? time, required this.isVideo, this.cover})
    : id = path.hashCode,
      time = time ?? path.stat.modified;

  String get name => path.name;

  bool isObtainedAddition(){
    return _imageAdditionList.containsKey(path.path);
  }

  Field getAdditionSync(String? uid, AlbumType? albumType){
    if(uid == null || albumType == null) return InvaildParamsAddition();

    return ImageAddition.fileSync(albumType, path.path, uid);
  }

  Future<Field> getAddition(String? uid, AlbumType? albumType) async{
    if(uid == null || albumType == null) return InvaildParamsAddition();

    return await ImageAddition.file(albumType, path.path, uid);
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is ImageItem &&
      runtimeType == other.runtimeType &&
      path == other.path;

  @override
  int get hashCode => path.hashCode;
}

mixin AlbumPath {
  bool isAllowBackup(AlbumType type) =>
      albumsInfoMap[type]!.locateInBackup != null;

  Path? getAlbumPath(
    Path installPath,
    AlbumType type, {
    Uid? uid,
    ImageSource source = ImageSource.game,
  }) {
    if (source == ImageSource.backup && !isAllowBackup(type)) return null;

    final AlbumsInfoItem info = albumsInfoMap[type]!;

    final String locate = source == ImageSource.game
        ? info.locateInGame
        : info.locateInBackup!;

    if (info.isRequireUid) {
      if (uid == null) return null;

      return installPath + locate.replaceAll(r"$uid$", uid.value);
    }

    return installPath + locate;
  }
}
