
import "item.dart";
import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";

import "package:flutter/widgets.dart";
import "dart:async";

import "package:path/path.dart" as p;
import "package:flutter_hooks/flutter_hooks.dart";



abstract class MediaItemProvider<T extends MediaItem> extends ChangeNotifier{
  MediaItemProvider();

  List<T> get items;
  int get length;

  bool get isInit;
  Future<void> ensureInitialization();

  @protected
  @visibleForTesting
  void notify(){
    /// TODO 防抖+节流
    notifyListeners();
  }
}


NDirMediaItemProvider useNDirMediaItemProvider({
  required NGeneralFileSystem fsHandler,
  FutureOr<String> libraryPath = "",
  bool immutableMedia = true,
  required FutureOr<String> Function(String path) getMediaPath,
  FutureOr<String?> Function(String path)? getCoverPath,
  FutureOr<String?> Function(String path)? getThumbnailPath,
}){
  final NDirMediaItemProvider provider = useMemoized(
    () => NDirMediaItemProvider(
      fsHandler: fsHandler,
      libraryPath: libraryPath,
      immutableMedia: immutableMedia,
      getMediaPath: getMediaPath,
      getCoverPath: getCoverPath,
      getThumbnailPath: getThumbnailPath,
    ),
    <Object?>[fsHandler, libraryPath, immutableMedia, getMediaPath, getCoverPath, getThumbnailPath],
  );

  useEffect(() => provider.dispose, <Object?>[provider]);

  return provider;
}

class NDirMediaItemProvider extends MediaItemProvider<MediaItem>{
  final NGeneralFileSystem fsHandler;
  final FutureOr<String> libraryPath;
  final bool immutableMedia;
  final FutureOr<String> Function(String path) getMediaPath;
  final FutureOr<String?> Function(String path)? getCoverPath;
  final FutureOr<String?> Function(String path)? getThumbnailPath;

  /// [libraryPath] 相册文件夹的路径
  /// [immutableMedia] 该相册的同名媒体文件是否会变更
  NDirMediaItemProvider({
    required this.fsHandler,
    this.libraryPath = "",
    this.immutableMedia = true,
    required this.getMediaPath,
    this.getCoverPath,
    this.getThumbnailPath,
  }){
    _initFuture = _init();
  }

  StreamSubscription<FileEvent>? _subscription;
  final Map<int, MediaItem> _items = {};
  @override
  List<MediaItem> get items => List.unmodifiable(_items.values);
  @override
  int get length => _items.length;

  bool _isInit = false;
  late Future<void> _initFuture;

  @override
  bool get isInit => _isInit;

  @override
  Future<void> ensureInitialization(){
    return _initFuture;
  }

  Future<void> _init() async{
    final List<String> files = await fsHandler.list(await libraryPath).then((NGDirList v) => v.files);
    for(final String file in files){
      final MediaItem item = await _generateItem(file);
      _items[p.hash(item.path)] = item;
    }
    _subscription = fsHandler.watch(await libraryPath).listen(_eventHandler);
    _isInit = true;
    notify();
  }

  void _eventHandler(FileEvent event) async{
    switch(event.type){
      case FileEventType.modify:
        final MediaItem? item = findItemByPath(event.path);
        if(item != null){
          item.update();
          break;
        }
    // media 不存在时则添加, 进入下方语句
      case FileEventType.add:
        final MediaItem item = await _generateItem(event.path);
        _items[p.hash(item.path)] = item;
        notify();
        break;
      case FileEventType.remove:
        _items.remove(p.hash(event.path));
        notify();
        break;
    }
  }

  Future<MediaItem> _generateItem(String path) async{
    return MediaItem(
      fsHandler: fsHandler,
      immutable: immutableMedia,
      path: path,
      mediaPath: await getMediaPath(path),
      coverPath: await getCoverPath?.call(path),
      thumbnailPath: await getThumbnailPath?.call(path),
    );
  }

  MediaItem? findItemByPath(String path){
    return _items[p.hash(path)];
  }

  @override
  void dispose(){
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}