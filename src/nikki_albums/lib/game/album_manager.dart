
import "uid.dart";
import "image.dart";
import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/utils/path.dart";
import "package:nikkialbums/utils/Image.dart";
import "package:nikkialbums/utils/quiet_watcher.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:async";
import "dart:collection";
import "dart:convert";


typedef ProcessedAlbumType = SplayTreeMap<DateTime, SplayTreeSet<ImageItem>>;

class AlbumManager extends ChangeNotifier with AlbumPath{

  static Map<String, dynamic>? toJsonMap(AlbumManager? albumManager){
    if(albumManager == null) return null;

    return {
      "type": albumManager.type.name,
      "installPath": albumManager.installPath.path,
      "uid": Uid.toJsonMap(albumManager.uid),
    };
  }

  static AlbumManager? from(dynamic map){
    if(map is String) map = jsonDecode(map);
    if(map is! Map) return null;

    final AlbumType type = AlbumType.from(map["type"]);
    final Path? installPath = Path.from(map["installPath"]);
    final Uid? uid = Uid.from(map["uid"]);

    if(installPath == null || uid == null) return null;

    return AlbumManager(
      type: type,
      installPath: installPath,
      uid: uid,
    );
  }


  final AlbumType type;
  final Path installPath;
  final Uid? uid;

  AlbumManager({
    required this.type,
    required this.installPath,
    this.uid,
  }){
    _init();
  }

  Path? get gameAlbumPath => getAlbumPath(installPath, type, uid: uid, source: ImageSource.game);

  Path? get backupAlbumPath => getAlbumPath(installPath, type, uid: uid, source: ImageSource.backup);

  Future<void> _init() async{
    if(!albumsInfoMap[type]!.supportedPlatforms.canRunPlatform) return;

    _images = getImages();
    if(gameAlbumPath != null) _gameAlbumWatcher = await _generateWatcher(gameAlbumPath!);
    if(backupAlbumPath != null) _backupAlbumWatcher = await _generateWatcher(backupAlbumPath!);
  }

  Future<void> refresh() async{
    _gameAlbumWatcher?.cancel();
    _backupAlbumWatcher?.cancel();
    _init();
  }


  /// ---------- images ---------- ///

  Future<Set<ImageItem>> _images = Future.value({});

  QuietDirectoryWatcher? _gameAlbumWatcher;
  QuietDirectoryWatcher? _backupAlbumWatcher;

  Future<Set<ImageItem>> get images => _images;

  /// Traverse all the image files in the directory
  /// [albumPath] album directory path
  /// [depth] The depth of the folder to be traversed. If this is a negative number, this will be traversed to the end
  ///
  /// 遍历目录下的所有图像文件
  /// [albumPath] 需要遍历的目录
  /// [depth] 遍历的文件夹深度. 如果这是负数, 将遍历完所有的子目录
  Future<List<ImageItem>> _traverseAlbum(ImageSource source, Path albumPath, {int depth = 1}) async{
    final List<ImageItem> res = <ImageItem>[];

    if(depth == 0) return res;

    if(await albumPath.typeAsync != FileSystemEntityType.directory) return res;

    final List<FileSystemEntity> entities = await albumPath.directory.list(recursive: false).toList();

    for(FileSystemEntity entity in entities){
      final Path entityPath = Path(entity.path);

      if(entity is Directory){
        res.addAll(await _traverseAlbum(source, entityPath, depth: depth - 1));
      }else if(entity is File){
        if(!isImageExtension(entityPath)) continue;

        final DateTime time = (await entityPath.cacheStatAsync).modified;

        res.add(ImageItem(source: source, path: entityPath, time: time));
      }
    }

    return res;
  }

  Future<Set<ImageItem>> getImages() async{
    final Set<ImageItem> res = <ImageItem>{};

    final Path? path = gameAlbumPath;
    final Path? backupPath = backupAlbumPath;

    if(path != null){
      res.addAll(await _traverseAlbum(ImageSource.game, path, depth: 10));
    }
    if(backupPath != null){
      res.addAll(await _traverseAlbum(ImageSource.backup, backupPath, depth: 10));
    }

    return res;
  }

  Future<QuietDirectoryWatcher> _generateWatcher(Path albumPath) async{
    if(!await albumPath.directory.exists()){
      await albumPath.directory.create(recursive: true);
    }

    final QuietDirectoryWatcher albumWatcher = QuietDirectoryWatcher(
      path: albumPath,
      listener: (){
        _images = getImages();
        /// 确保拿到值后再通知, 减少ui等待时间
        _images.then((_){
          _safeNotifyListeners();
        });
      }
    );

    return albumWatcher;
  }


  /// ---------- selected images ---------- ///

  final Set<ImageItem> _selectedImages = {};
  Notifier whenSelectedImagesChange = Notifier();

  Set<ImageItem> get selectedImages => _selectedImages;

  void selectImage(ImageItem item){
    if(_selectedImages.contains(item)) return;

    _selectedImages.add(item);

    _safeNotifySelected();
  }

  Future<void> selectAllImage() async{
    _selectedImages.addAll(await _images);

    _safeNotifySelected();
  }

  void deselectImage(ImageItem item){
    if(!_selectedImages.contains(item)) return;

    _selectedImages.remove(item);

    _safeNotifySelected();
  }

  void deselectAllImage(){
    if(_selectedImages.isEmpty) return;

    _selectedImages.clear();

    _safeNotifySelected();
  }

  void invertImage(ImageItem item){
    if(_selectedImages.contains(item)){
      deselectImage(item);
    }else{
      selectImage(item);
    }
  }

  Future<void> invertAllImage() async{
    for(ImageItem item in await _images){
      if(_selectedImages.contains(item)){
        _selectedImages.remove(item);
      }else{
        _selectedImages.add(item);
      }
    }

    _safeNotifySelected();
  }


  /// ---------- processed albums ---------- ///

  SortOrder _sortOrder = SortOrder.descending;

  final Set<Filtration> _filtration = {...Filtration.values};

  SortOrder get sortOrder => _sortOrder;
  set sortOrder(SortOrder order){
    if(_sortOrder == order) return;

    _sortOrder = order;
    notifyListeners();
  }

  bool isFilter(Filtration filtration) => _filtration.contains(filtration);
  void filter(Filtration filtration){
    _filtration.add(filtration);
    notifyListeners();
  }
  void unfilter(Filtration filtration){
    _filtration.remove(filtration);
    notifyListeners();
  }

  bool _filterItem(ImageItem item){
    for(Filtration filtration in _filtration){
      switch(filtration){
        case Filtration.inGame:
          if(item.source == ImageSource.game) return true;
          break;
        case Filtration.outOfGame:
          if(item.source == ImageSource.backup) return true;
          break;
      }
    }
    return false;
  }

  Future<ProcessedAlbumType> process() async{
    final Set<ImageItem> images = await this.images;

    final ProcessedAlbumType res =  SplayTreeMap(AlbumComparison.headerBy(_sortOrder));

    for(final ImageItem image in images){
      if(_filterItem(image)){
        final day = DateTime(image.time.year, image.time.month, image.time.day);
        (res[day] ??= SplayTreeSet<ImageItem>(AlbumComparison.itemBy(_sortOrder))).add(image);
      }
    }

    return res;
  }

  SplayTreeSet<ImageItem> sortImages(Set<ImageItem> images){
    return SplayTreeSet<ImageItem>(AlbumComparison.itemBy(_sortOrder))..addAll(images);
  }


  /// ---------- class ---------- ///

  bool _disposed = false;

  void _safeNotifyListeners(){
    if(!_disposed){
      notifyListeners();
    }
  }
  void _safeNotifySelected(){
    if(!_disposed){
      whenSelectedImagesChange.notify();
    }
  }

  @override
  void dispose(){
    _disposed = true;
    _gameAlbumWatcher?.cancel();
    _backupAlbumWatcher?.cancel();
    super.dispose();
  }

  @override
  String toString() => type.toString();
}





enum SortOrder{
  ascending,
  descending,
}
enum Filtration{
  inGame,
  outOfGame,
}

abstract class AlbumComparison{

  static int Function(DateTime a, DateTime b) headerBy(SortOrder order){
    return switch(order){
      SortOrder.ascending => _headerAscendingSort,
      SortOrder.descending => _headerDescendingSort,
    };
  }
  static int _headerAscendingSort(DateTime a, DateTime b) => a.compareTo(b);
  static int _headerDescendingSort(DateTime a, DateTime b) => b.compareTo(a);


  static int Function(ImageItem a, ImageItem b) itemBy(SortOrder order){
    return switch(order){
      SortOrder.ascending => _itemAscendingSort,
      SortOrder.descending => _itemDescendingSort,
    };
  }
  static int _itemAscendingSort(ImageItem a, ImageItem b){
    final cmp = a.time.compareTo(b.time);
    return cmp != 0 ? cmp : a.id.compareTo(b.id);
  }
  static int _itemDescendingSort(ImageItem a, ImageItem b){
    final cmp = b.time.compareTo(a.time);
    return cmp != 0 ? cmp : b.id.compareTo(a.id);
  }
}