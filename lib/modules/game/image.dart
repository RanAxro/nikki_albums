
import "uid.dart";
import "package:nikki_albums/info.dart";
import "package:nikki_albums/utils/path.dart";
import "package:nikki_albums/modules/nuan5_params/model/tree_node.dart";
import "package:nikki_albums/modules/nuan5_params/domain/tree_node_generator.dart";
import "package:nikki_albums/src/rust/nuan5_media_param/decode.dart";
import "infinity_nikki/domain/param_codec.dart";

import "dart:io" show Platform;


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
  final String? thumbnail;
  final bool isVideo;
  final String? cover;

  ImageItem({required this.source, required this.path, DateTime? time, this.thumbnail, required this.isVideo, this.cover})
    : id = path.hashCode,
      time = time ?? path.stat.modified;

  String get name => path.name;

  Future<MediaCustomData?> getParam(String? uid, AlbumType? albumType){
    return InfinityNikkiParamCodec.decodeFileUnchecked(convertAlbumType(albumType ?? AlbumType.NikkiPhotos_HighQuality), path.path, uid: uid);
  }
  Future<TreeNode?> getParamNode(String? uid, AlbumType? albumType) async{
    final MediaCustomData? data = await getParam(uid, albumType);
    return convertMediaData(data);
  }

  MediaCustomData? getParamSync(String? uid, AlbumType? albumType){
    return InfinityNikkiParamCodec.decodeFileUncheckedSync(convertAlbumType(albumType ?? AlbumType.NikkiPhotos_HighQuality), path.path, uid: uid);
  }
  TreeNode? getParamNodeSync(String? uid, AlbumType? albumType){
    final MediaCustomData? data = getParamSync(uid, albumType);
    return convertMediaData(data);
  }



  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is ImageItem &&
      runtimeType == other.runtimeType &&
      path == other.path;

  @override
  int get hashCode => path.hashCode;
}


MediaParamType convertAlbumType(AlbumType albumType){
  switch(albumType){
    case AlbumType.Collage_HighQuality:
      return MediaParamType.collage;
    case AlbumType.ClockInPhoto:
      return MediaParamType.clockInPhoto;
    case AlbumType.DIY:
      return MediaParamType.diy;
    case AlbumType.NikkiPhotos_HighQuality:
      return MediaParamType.nikkiPhoto;
    default:
      return MediaParamType.nikkiPhoto;
  }
}

TreeNode? convertMediaData(MediaCustomData? data){
  return data?.whenOrNull(
    valid: (MediaParam param){
      return param.when(
        momoCameraParams: (momoCameraParams){
          return null;
        },
        nikkiPhoto: (nikkiPhoto){
          return genNikkiPhotoParams(nikkiPhoto);
        },
        clockInPhoto: (clockInPhoto){
          return genClockInPhotoParams(clockInPhoto);
        },
        collage: (collage){
          return genCollageParams(collage);
        },
        diy: (diy){
          return genDiyParams(diy);
        },
      );
    },
  );
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

    String locate = source == ImageSource.game
        ? info.locateInGame
        : info.locateInBackup!;

    // macOS path override: ScreenShot is under Saved/ on macOS
    if (Platform.isMacOS && type == AlbumType.ScreenShot && source == ImageSource.game) {
      locate = r"\X6Game\Saved\ScreenShot";
    }

    if (info.isRequireUid) {
      if (uid == null) return null;

      return installPath + locate.replaceAll(r"$uid$", uid.value);
    }

    return installPath + locate;
  }
}
