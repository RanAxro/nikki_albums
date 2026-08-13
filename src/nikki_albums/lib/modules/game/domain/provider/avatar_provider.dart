
import "album_path_provider.dart";
import "../../model/album_type.dart";
import "package:nikki_albums/modules/game/lib/uid.dart";

import "dart:io";

import "package:path/path.dart" as p;

abstract class AvatarProvider{
  static Future<String?> byUid(Uid uid) async{
    final String avatarAlbumPath = AlbumPathProvider.forGame(uid.installPath, AlbumType.CustomAvatar, uid.value);
    final Directory avatarAlbumDir = Directory(avatarAlbumPath);

    if(!(await avatarAlbumDir.exists())){
      return null;
    }

    (String, DateTime)? avatar;
    await for(final FileSystemEntity entity in avatarAlbumDir.list(recursive: false)){
      if(entity is! File || p.extension(entity.path) != ".jpeg"){
        continue;
      }

      if(avatar == null){
        avatar = (entity.path, (await entity.stat()).modified);
      }else{
        final DateTime thisDateTime = (await entity.stat()).modified;

        if(thisDateTime.isAfter(avatar.$2)){
          avatar = (entity.path, thisDateTime);
        }
      }
    }

    return avatar?.$1;
  }
}