import "../model/album_type.dart";
import "../model/album_info.dart";
import "../model/exception.dart";

import "package:path/path.dart" as p;


AlbumInfo queryAlbumInfo(AlbumType type){
  return albumInfos[type]!;
}

bool queryIsRequireUid(AlbumType type){
  return queryAlbumInfo(type).isRequireUid;
}

String queryPathForGame(AlbumType type, String installPath, [String? uid]){
  final AlbumInfo albumInfo = queryAlbumInfo(type);

  if(albumInfo.isRequireUid && uid == null){
    throw QueryAlbumInfoException(type, QueryAlbumInfoErrorCode.lackUid);
  }

  String path = albumInfo.locateInGame;

  if(albumInfo.isRequireUid){
    path = path.replaceAll(r"$uid$", uid!);
  }

  return p.join(installPath, path);
}

String? queryPathForBackup(AlbumType type, String installPath, [String? uid]){
  final AlbumInfo albumInfo = albumInfos[type]!;

  if(albumInfo.isRequireUid && uid == null){
    throw QueryAlbumInfoException(type, QueryAlbumInfoErrorCode.lackUid);
  }

  if(albumInfo.locateInBackup == null){
    return null;
  }

  String path = albumInfo.locateInBackup!;

  if(albumInfo.isRequireUid){
    path = path.replaceAll(r"$uid$", uid!);
  }

  return p.join(installPath, path);
}

String queryPathForRecycleBin(AlbumType type, String msSinceEpoch, String installPath, [String? uid]){
  final AlbumInfo albumInfo = albumInfos[type]!;

  if(albumInfo.isRequireUid && uid == null){
    throw QueryAlbumInfoException(type, QueryAlbumInfoErrorCode.lackUid);
  }

  String path = albumInfo.locateInRecycleBin;

  path = path.replaceAll(r"$msSinceEpoch$", msSinceEpoch);

  if(albumInfo.isRequireUid){
    path = path.replaceAll(r"$uid$", uid!);
  }

  return p.join(installPath, path);
}
