
import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";

import "package:path/path.dart" as p;


class AlbumItem{
  final NGeneralFileSystem fsHandler;
  final bool immutable;
  final String path;
  final String mediaPath;
  final String? coverPath;
  final String? thumbnailPath;

  /// [immutable] 对于同一个路径 [path], [mediaPath] 所在的文件内容是否会改变
  /// [path] 该 item 所在的文件路径
  /// [mediaPath] 媒体文件所在的路径, 相对于 [path]
  /// [coverPath] 媒体封面图像文件所在的路径, 相对于 [path]
  /// [thumbnailPath] 媒体封面缩略图图像文件所在的路径, 相对于 [path]
  AlbumItem({
    required this.fsHandler,
    this.immutable = true,
    required this.path,
    required this.mediaPath,
    this.coverPath,
    this.thumbnailPath,
  });

  void update(){

  }

  Future<NGFileStat> stat(){
    return fsHandler.stat(path);
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is AlbumItem && runtimeType == other.runtimeType &&
    fsHandler == other.fsHandler &&
    immutable == other.immutable &&
    p.equals(path, other.path) &&
    p.equals(mediaPath, other.mediaPath) &&
    p.equals(coverPath ?? "", other.coverPath ?? "") &&
    p.equals(thumbnailPath ?? "", other.thumbnailPath ?? "");

  @override
  int get hashCode => fsHandler.hashCode ^ immutable.hashCode ^ path.hashCode ^ mediaPath.hashCode ^ coverPath.hashCode ^ thumbnailPath.hashCode;
}