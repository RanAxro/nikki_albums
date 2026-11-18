
import "item.dart";
import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";

import "package:flutter/widgets.dart";
import "dart:async";

import "package:path/path.dart" as p;


class AlbumItemProvider extends ChangeNotifier{
  final NGeneralFileSystem fsHandler;
  final FutureOr<String> albumPath;
  final bool immutableMedia;
  final FutureOr<String> Function(String path) getMediaPath;
  final FutureOr<String?> Function(String path)? getCoverPath;
  final FutureOr<String?> Function(String path)? getThumbnailPath;

  /// [albumPath] 相册文件夹的路径
  /// [immutableMedia] 该相册的同名媒体文件是否会变更
  AlbumItemProvider({
    required this.fsHandler,
    this.albumPath = "",
    this.immutableMedia = true,
    required this.getMediaPath,
    this.getCoverPath,
    this.getThumbnailPath,
  }){
    _init();
  }

  StreamSubscription<FileEvent>? _subscription;
  final Map<int, AlbumItem> _items = {};
  List<AlbumItem> get items => List.unmodifiable(_items.values);

  bool _isInit = false;
  bool get isInit => _isInit;
  Future<void> _init() async{
    final List<String> files = await fsHandler.list(await albumPath).then((v) => v.files);
    for(final String file in files){
      final AlbumItem item = await _generateItem(file);
      _items[p.hash(item.path)] = item;
    }
    _subscription = fsHandler.watch(await albumPath).listen(_eventHandler);
    _isInit = true;
    _notify();
  }

  void _eventHandler(FileEvent event) async{
    switch(event.type){
      case FileEventType.modify:
        final AlbumItem? item = findItemByPath(event.path);
        if(item != null){
          item.update();
          break;
        }
        // media 不存在时则添加, 进入下方语句
      case FileEventType.add:
        final AlbumItem item = await _generateItem(event.path);
        _items[p.hash(item.path)] = item;
        _notify();
        break;
      case FileEventType.remove:
        _items.remove(p.hash(event.path));
        _notify();
        break;
    }
  }

  Future<AlbumItem> _generateItem(String path) async{
    return AlbumItem(
      fsHandler: fsHandler,
      immutable: immutableMedia,
      path: path,
      mediaPath: await getMediaPath(path),
      coverPath: await getCoverPath?.call(path),
      thumbnailPath: await getThumbnailPath?.call(path),
    );
  }

  void _notify(){
    /// TODO 防抖+节流
    notifyListeners();
  }

  AlbumItem? findItemByPath(String path){
    return _items[p.hash(path)];
  }

  @override
  void dispose(){
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}