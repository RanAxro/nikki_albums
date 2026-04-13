import "../../model/album_type.dart";
import "../../model/album_info.dart";
import "../../model/exception/album_path_provider_exception.dart";

import "package:path/path.dart" as p;


abstract class AlbumPathProvider{
  static String forGame(String installPath, AlbumType type, [String? uid]){
    final AlbumInfo albumInfo = albumInfos[type]!;

    if(albumInfo.isRequireUid && uid == null){
      throw AlbumPathProviderException(AlbumPathProviderExceptionEnum.lackUid, type);
    }

    String path = albumInfo.locateInGame;

    if(albumInfo.isRequireUid){
      path = path.replaceAll(r"$uid$", uid!);
    }

    return p.join(installPath, path);
  }

  static String? forBackup(String installPath, AlbumType type, [String? uid]){
    final AlbumInfo albumInfo = albumInfos[type]!;

    if(albumInfo.isRequireUid && uid == null){
      throw AlbumPathProviderException(AlbumPathProviderExceptionEnum.lackUid, type);
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

  static String forRecycleBin(String installPath, AlbumType type, String msSinceEpoch, [String? uid]){
    final AlbumInfo albumInfo = albumInfos[type]!;

    if(albumInfo.isRequireUid && uid == null){
      throw AlbumPathProviderException(AlbumPathProviderExceptionEnum.lackUid, type);
    }

    String path = albumInfo.locateInRecycleBin;

    path = path.replaceAll(r"$msSinceEpoch$", msSinceEpoch);

    if(albumInfo.isRequireUid){
      path = path.replaceAll(r"$uid$", uid!);
    }

    return p.join(installPath, path);
  }
}