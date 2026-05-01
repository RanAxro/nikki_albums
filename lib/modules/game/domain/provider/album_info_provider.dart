import "../../model/album_type.dart";
import "../../model/album_info.dart";

abstract class AlbumInfoProvider{
  static AlbumInfo byType(AlbumType type){
    return albumInfos[type]!;
  }

  static bool queryIsRequireUid(AlbumType type){
    return byType(type).isRequireUid;
  }
}