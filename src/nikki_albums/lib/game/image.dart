import "uid.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/utils/path.dart";

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
    time =  time ?? path.stat.modified;

  String get name => path.name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ImageItem && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}
// class ImageItem implements Comparable<ImageItem>{
//   final int id;
//   final ImageSource source;
//   final Path path;
//   final DateTime time;
//
//   ImageItem({
//     required this.source,
//     required this.path,
//     DateTime? time,
//   }) :
//         id = path.hashCode,
//         time =  time ?? path.stat.modified;
//
//   String get name => path.name;
//
//   @override
//   int compareTo(ImageItem other){
//     int cmp = other.time.compareTo(time);
//     if(cmp == 0){
//       return other.id.compareTo(id);
//     }
//     return cmp;
//   }
//
//   @override
//   bool operator ==(Object other) => identical(this, other) || other is ImageItem && runtimeType == other.runtimeType && path == other.path;
//
//   @override
//   int get hashCode => path.hashCode;
// }


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