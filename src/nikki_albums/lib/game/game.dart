import "dart:convert";

import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/pages/album/album.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/api/path.dart";
import "package:nikkialbums/api/ini.dart";
import "package:nikkialbums/api/Image.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:collection";
import "dart:async";

import "package:win32_registry/win32_registry.dart";
import "package:watcher/watcher.dart";


typedef AlbumVarType = SplayTreeMap<DateTime, SplayTreeSet<ImageItem>>;

enum ImageSource{
  game,
  backup,
  other,
}
class ImageItem implements Comparable<ImageItem>{
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
  int compareTo(ImageItem other){
    int cmp = other.time.compareTo(time);
    if(cmp == 0){
      return other.id.compareTo(id);
    }
    return cmp;
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is ImageItem && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}

class Game extends ChangeNotifier{
  static List<Game>? cacheGameList;
  static Future<List<Game>> find() async{
    final List<Game> gameList = <Game>[];
    final Set<LauncherChannel> finishList = <LauncherChannel>{};

    for(Map<String, dynamic> data in gameWindowsRegistryPaths){
      // 去重
      if(finishList.contains(data["channel"])) continue;

      // 读注册表
      late final String? value;
      try{
        final key = Registry.openPath(
          data["hive"],
          path: data["path"],
          desiredAccessRights: AccessRights.readOnly,
        );
        value = key.getStringValue(data["key"]);
        key.close();
      }catch(e){
/// @ 1
        AppState.writeError("game.Game.static.find.@1", e.toString());
        value = null;
      }

      // 读不到值则退出当前循环
      if(value == null) continue;

      // launcher路径
      final Path launcherPath = Path(value) + data["locateToLauncher"];
      // 判断launcher文件夹是否存在
      bool isLauncherExist = await launcherPath.typeAsync == FileSystemEntityType.directory;

      // 找install路径
      Path installPath = launcherPath + data["locateToInstall"];
      // 判断install文件夹是否存在
      bool isInstallExist = await installPath.typeAsync == FileSystemEntityType.directory;

      // paper版本需再去 C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini 找
      if(isInstallExist == false && data["channel"] == LauncherChannel.paper){
        // 获取用户名
        final username = Platform.environment["USERNAME"] ?? Platform.environment["username"] ?? Platform.environment["UserName"];
        if(username == null) continue;

        // 获取配置文件
        final Path ini = Path(gameWindowsAppDataPath.replaceAll(r"$username$", username));
        // 若配置文件不存在, 则退出当前循环
        if(await ini.typeAsync != FileSystemEntityType.file) continue;
        // 读取配置文件的 Download.gameDir值
        late final String iniText;
        try{
          iniText = await ini.file.readAsString();
        }catch(e){
/// @ 2
          AppState.writeError("game.Game.static.find.@2", e.toString());
          continue;
        }
        // 解析ini
        late final Map<String, Map<String, String>> jsonMap;
        try{
          jsonMap = parseIni(iniText);
        }catch(e){
/// @ 3
          AppState.writeError("game.Game.static.find.@3", e.toString());
          continue;
        }
        if(jsonMap["Download"] is Map && jsonMap["Download"]!["gameDir"] is String){
          // 判断install是否存在
          installPath = Path(jsonMap["Download"]!["gameDir"]!);
          isInstallExist = await installPath.typeAsync == FileSystemEntityType.directory;
        }
      }

      // 成功获取到install路径
      if(isInstallExist){
        finishList.add(data["channel"]);
        gameList.add(
          Game(
            launcherChannel: data["channel"],
            launcherPath: launcherPath,
            installPath: installPath,
          )
        );
      }
    }

    cacheGameList = gameList;
    return gameList;
  }

  static Map<String, String?>? toMap(Game? game){
    if(game == null) return null;

    return {
      "launcherChannel": game.launcherChannel.name,
      "launcherPath": game.launcherPath?.path,
      "launcherName": game.launcherName,
      "installPath": game.installPath?.path,
      "uid": game._selectedUid,
    };
  }

  static Game? fromMap(dynamic map){
    if(map is String) map = jsonDecode(map);
    if(map is! Map) return null;

    final Game res = Game(
      launcherChannel: map.containsKey("launcherChannel") && map["launcherChannel"] is String ? LauncherChannel.fromName(map["launcherChannel"]!) : LauncherChannel.unknown,
      launcherPath: map.containsKey("launcherPath") && map["launcherPath"] is String? ? Path(map["launcherPath"]!) : null,
      launcherName: map["launcherName"] is String? ? map["launcherName"] : null,
      installPath: map.containsKey("installPath") && map["installPath"] is String ? Path(map["installPath"]!) : null,
    );
    if(map.containsKey("uid")) res.selectedUid = map["uid"] is String? ? map["uid"] : null;
    return res;
  }

  static int _albumMapSort(DateTime a, DateTime b) => b.compareTo(a);

  Future moveAndLinkGameInstallTo(Path toDirectory) async{

  }
  Future moveAndLinkGameAlbumTo(Path toDirectory) async{

  }

  final LauncherChannel launcherChannel;
  Path? launcherPath;
  String? launcherName;
  Path? _installPath;

  String? _selectedUid;
  Future<Path?> _avatar = Future<Path?>.value(null);
  Future<FileImage?> _avatarImage = Future<FileImage?>.value(null);

  AlbumType? _selectedAlbum;
  Future<AlbumVarType> album = Future<AlbumVarType>.value(SplayTreeMap(_albumMapSort));
  Set<ImageItem> _selectedImages = SplayTreeSet<ImageItem>();
  Notifier whenSelectedImagesChange = Notifier();

  final Set<String> _albumWatcherNotificationBlacklist = {};
  DirectoryWatcher? _gameAlbumWatcher;
  StreamSubscription<WatchEvent>? _gameAlbumWatcherStream;
  DirectoryWatcher? _backupAlbumWatcher;
  StreamSubscription<WatchEvent>? _backupAlbumWatcherStream;
  
  Game({
    this.launcherChannel = LauncherChannel.unknown,
    this.launcherPath,
    this.launcherName,
    Path? installPath,
  }) :
    _installPath = installPath;


  void reset(){
    _selectedUid = null;
    _avatar = Future<Path?>.value(null);
    _avatarImage = Future<FileImage?>.value(null);
    _selectedAlbum = null;
    album = Future<AlbumVarType>.value(SplayTreeMap(_albumMapSort));
  }

  Path? get installPath => _installPath;

  set installPath(Path? newPath){
    _installPath = newPath;
    reset();
  }

  Path? get gamePlayPhotosPath{
    if(installPath == null) return null;
    return installPath! + locateToGamePlayPhotos;
  }

  bool get _isProhibitSet => _installPath == null;

  String get logoAssetName => "assets/logo/${launcherChannel.name}.png";

  AssetImage get logoImage => AssetImage(logoAssetName);

  String get name{
    if(launcherChannel == LauncherChannel.unknown){
      return launcherName ?? "";
    }
    return launcherChannel.name;
  }

  /// ////////////////
  /// uid

  // List<String> uidList = <String>[];

  /// TODO redo use new function [getAlbumPath]
  Future<List<String>> findUid() async{
    if(installPath == null) return [];

    final Set<String> uidList = {};

    for(AlbumsInfoItem info in albumsInfoMap.values){
      if(!info.isRequireUid) continue;

      final Path root = installPath! + info.locateInGame.split(r"$uid$").first;
      try{
        // 判断文件夹合法性
        if(root.type != FileSystemEntityType.directory) continue;

        final List<FileSystemEntity> entities = await root.directory.list(recursive: false).toList();

        for(FileSystemEntity entity in entities){
          String uid = entity.path.split(Path.symbol).last;
          // 去重并且判断是否为6-12位数字格式
          if(RegExp(r"^\d{6,12}$").hasMatch(uid)) uidList.add(uid);
        }
      }catch(e){
/// @ 1
        AppState.writeError("game.Game.findUid.@1", e.toString());
        continue;
      }
    }
    // this.uidList = uidList.toList(growable: false);
    return uidList.toList(growable: false);
  }

  String? get selectedUid => _selectedUid;

  /// [_selectUid] depends on [_installPath]
  /// if [_installPath] is null, [_selectUid] can not be set
  set selectedUid(String? newUid){
    if(_isProhibitSet) return;

    if(newUid == _selectedUid) return;
    _selectedUid = newUid;
    updateAvatar();
    selectedAlbum = defaultAlbum;

    notifyListeners();
  }

  // Future<void> setUidThenWaitAvatarUpdated(String? newUid) async{
  //   if(_isProhibitSet) return;
  //
  //   if(newUid == _selectUid) return;
  //   _selectUid = newUid;
  //   _avatar = null;
  //   _selectAlbum = defaultAlbum;
  //
  //   notifyListeners();
  //   await updateAvatar();
  // }

  /// ////////////////
  /// avatar

  /// 从"CustomAvatar"找最新的头像图像
  ///
  /// find the latest player avatar from game album "CustomAvatar"
  Future<Path?> findAvatarByUid(String uid) async{
    if(installPath == null) return null;

    final Directory avatarDir = (installPath! + albumsInfoMap[AlbumType.CustomAvatar]!.locateInGame.replaceAll(r"$uid$", uid)).directory;

    if(!(await avatarDir.exists())) return null;

    final List<FileSystemEntity> entities = await avatarDir
      .list(recursive: false)
      .where((entity) => entity is File && isImageExtension(Path(entity.path)))
      .toList();

    if(entities.isEmpty) return null;

    final List<Path> avatarList = entities.map((entity) => Path(entity.path)).toList();

    for(Path item in avatarList){
      await item.statAsync;
    }

    avatarList.sort((a, b) => b.cacheStat.modified.compareTo(a.cacheStat.modified));

    return avatarList.first;
  }

  void updateAvatar(){
    if(_selectedUid == null){
      _avatar = Future<Path?>.value(null);
      _avatarImage = Future<FileImage?>.value(null);
    }else{
      _avatar = findAvatarByUid(_selectedUid!);
      _avatarImage = Future(() async{
        final Path avatarPath = await _avatar as Path;
        return FileImage(avatarPath.file);
      });
    }
  }

  Future<Path?> get avatar => _avatar;

  Future<FileImage?> get avatarImage => _avatarImage;

  /// ////////////////
  ///
  /// album

  static AlbumVarType filterAlbum(AlbumVarType album, bool Function(ImageItem currentItem) isRetain){
    final AlbumVarType res = SplayTreeMap(_albumMapSort);

    for(MapEntry<DateTime, SplayTreeSet<ImageItem>> it in album.entries){
      final SplayTreeSet<ImageItem> images = SplayTreeSet();

      for(ImageItem item in it.value){
        if(isRetain(item)) images.add(item);
      }

      if(images.isNotEmpty) res[it.key] = images;
    }

    return res;
  }

  AlbumType get defaultAlbum => _selectedUid == null ? AlbumType.ScreenShot : AlbumType.NikkiPhotos_HighQuality;

  AlbumType? get selectedAlbum => _selectedAlbum;

  set selectedAlbum(AlbumType? newType){
    if(_isProhibitSet) return;

    if(_selectedAlbum == newType) return;

    _selectedAlbum = newType;
    updateAlbum();

    notifyListeners();
  }

  List<AlbumType> get accessibleAlbum{
    final List<AlbumType> res = <AlbumType>[];

    if(installPath == null) return res;

    for(MapEntry<AlbumType, AlbumsInfoItem> item in albumsInfoMap.entries){
      if(item.value.isRequireUid && _selectedUid == null) continue;
      res.add(item.key);
    }

    return res;
  }

  bool isAllowBackup(AlbumType type) => albumsInfoMap[type]!.locateInBackup != null;

  Path? getAlbumPath(AlbumType type, {String? uid, ImageSource source = ImageSource.game}){
    if(installPath == null) return null;

    if(source == ImageSource.backup && !isAllowBackup(type)) return null;

    final AlbumsInfoItem info = albumsInfoMap[type]!;

    final String locate = source == ImageSource.game ? info.locateInGame : info.locateInBackup!;

    if(info.isRequireUid){
      if(uid == null) return null;

      return installPath! + locate.replaceAll(r"$uid$", uid);
    }

    return installPath! + locate;
  }

  Path? get gameAlbumPath => _selectedAlbum == null ? null : getAlbumPath(_selectedAlbum!, uid: _selectedUid, source: ImageSource.game);

  Path? get backupAlbumPath => _selectedAlbum == null ? null : getAlbumPath(_selectedAlbum!, uid: _selectedUid, source: ImageSource.backup);

  /// Traverse all the image files in the directory
  /// [albumPath] album directory path
  /// [depth] The depth of the folder to be traversed. If this is a negative number, this will be traversed to the end
  ///
  /// 遍历目录下的所有图像文件
  /// [albumPath] 需要遍历的目录
  /// [depth] 遍历的文件夹深度. 如果这是负数, 将遍历完所有的子目录
  Future<List<ImageItem>> traverseAlbum(ImageSource source, Path albumPath, {int depth = 1}) async{
    final List<ImageItem> res = <ImageItem>[];

    if(depth == 0) return res;

    if(await albumPath.typeAsync != FileSystemEntityType.directory) return res;

    final List<FileSystemEntity> entities = await albumPath.directory.list(recursive: false).toList();

    for(FileSystemEntity entity in entities){
      final Path entityPath = Path(entity.path);

      if(entity is Directory){
        res.addAll(await traverseAlbum(source, entityPath, depth: depth - 1));
      }else if(entity is File){
        if(!isImageExtension(entityPath)) continue;

        final DateTime time = (await entityPath.cacheStatAsync).modified;

        res.add(ImageItem(source: source, path: entityPath, time: time));
      }
    }

    return res;
  }

  Future<AlbumVarType> initAlbum() async{
    final AlbumVarType res = SplayTreeMap(_albumMapSort);

    final Path? path = gameAlbumPath;
    final Path? backupPath = backupAlbumPath;

    final List<ImageItem> imageList = <ImageItem>[];

    if(path != null){
      imageList.addAll(await traverseAlbum(ImageSource.game, path, depth: 10));
    }
    if(backupPath != null){
      imageList.addAll(await traverseAlbum(ImageSource.backup, backupPath, depth: 10));
    }

    for(final image in imageList){
      final day = DateTime(image.time.year, image.time.month, image.time.day);
      (res[day] ??= SplayTreeSet<ImageItem>()).add(image);
    }

    return res;
  }

  Future<void> _insertItemToAlbum(Path itemPath, ImageSource source) async{
    final DateTime time = (await itemPath.cacheStatAsync).modified;
    final ImageItem item = ImageItem(source: source, path: itemPath, time: time);

    final AlbumVarType album = await this.album;
    final day = DateTime(item.time.year, item.time.month, item.time.day);
    (album[day] ??= SplayTreeSet<ImageItem>()).add(item);
  }

  Future<void> _removeItemFromAlbum(Path itemPath, ImageSource source) async{
    final AlbumVarType album = await this.album;
    album.forEach((_, list){
      list.removeWhere((ImageItem item){
        if(item.path == itemPath && item.source == source) return true;
        return false;
        /// 大喵这么写一定有他的道理  -- 暖暖
        momoCry(555);
      });
    });
  }

  Future<(DirectoryWatcher?, StreamSubscription<WatchEvent>?)> _generateWatcher(Path? albumPath, ImageSource source) async{
    if(albumPath == null) return (null, null);

    if(!await albumPath.directory.exists()){
      await albumPath.directory.create(recursive: true);
    }

    final DirectoryWatcher albumWatcher = DirectoryWatcher(albumPath.path);
    final StreamSubscription<WatchEvent> albumWatcherStream = albumWatcher.events.listen((event){
      final Path path = Path(event.path);
      if(event.type == ChangeType.ADD){
        _insertItemToAlbum(path, source);
      }else if(event.type == ChangeType.REMOVE){
        _removeItemFromAlbum(path, source);
      }

      if(!_albumWatcherNotificationBlacklist.contains(path.name)) notifyListeners();
    });

    return (albumWatcher, albumWatcherStream);
  }

  Future<void> updateAlbum() async{
    album = initAlbum();
    _selectedImages.clear();

    final Path? gameAlbum = gameAlbumPath;
    _gameAlbumWatcherStream?.cancel();
    final (DirectoryWatcher? gameWatcher, StreamSubscription<WatchEvent>? gameStream) = await _generateWatcher(gameAlbum, ImageSource.game);
    _gameAlbumWatcher = gameWatcher;
    _gameAlbumWatcherStream = gameStream;

    final Path? backupAlbum = backupAlbumPath;
    _backupAlbumWatcherStream?.cancel();
    final (DirectoryWatcher? backupWatcher, StreamSubscription<WatchEvent>? backupStream) = await _generateWatcher(backupAlbum, ImageSource.backup);
    _gameAlbumWatcher = backupWatcher;
    _gameAlbumWatcherStream = backupStream;
  }

  /// ////////////////
  ///
  /// image

  static SplayTreeSet<ImageItem> flattenAlbum(AlbumVarType targetAlbum){
    final SplayTreeSet<ImageItem> flat = SplayTreeSet<ImageItem>();

    for(SplayTreeSet<ImageItem> set in targetAlbum.values){
      flat.addAll(set);
    }
    return flat;
  }

  Set<ImageItem> get selectedImages => _selectedImages;

  void refresh(){
    updateAlbum();
    notifyListeners();
  }

  void selectImage(ImageItem item){
    if(_selectedImages.contains(item)) return;

    _selectedImages.add(item);
    whenSelectedImagesChange.notify();
  }

  Future<void> selectAllImage() async{
    _selectedImages = flattenAlbum(await album);

    whenSelectedImagesChange.notify();
  }

  void deselectImage(ImageItem item){
    if(!_selectedImages.contains(item)) return;

    _selectedImages.remove(item);
    whenSelectedImagesChange.notify();
  }

  void deselectAllImage(){
    if(_selectedImages.isEmpty) return;

    _selectedImages.clear();
    whenSelectedImagesChange.notify();
  }

  void invertImage(ImageItem item){
    if(_selectedImages.contains(item)){
      deselectImage(item);
    }else{
      selectImage(item);
    }
  }

  Future<void> invertAllImage() async{
    final SplayTreeSet<ImageItem> allImage = flattenAlbum(await album);

    for(ImageItem item in allImage){
      if(_selectedImages.contains(item)){
        _selectedImages.remove(item);
      }else{
        _selectedImages.add(item);
      }
    }

    whenSelectedImagesChange.notify();
  }

  Future<void> backupSelectedImages({void Function(double progress)? onProgress, void Function(Set<ImageItem> errorImages)? onError}) async{
    if(_selectedImages.isEmpty) return onProgress?.call(1);

    final Path? backupPath = backupAlbumPath;
    if(backupPath == null) return;

    int currentProgress = 0;
    final int all = _selectedImages.length;

    final Set<ImageItem> toRemove = {};
    final Set<ImageItem> errorImages = {};

    for(ImageItem item in _selectedImages){
      try{
        if(item.source == ImageSource.game){
          _albumWatcherNotificationBlacklist.add(item.name);
          await item.path.file.rename((backupPath + item.name).path);
          toRemove.add(item);
        }
      }catch(e){
        errorImages.add(item);
      }finally{
        onProgress?.call(++currentProgress / all);
      }
    }

    _selectedImages.removeAll(toRemove);
    _albumWatcherNotificationBlacklist.clear();
    onError?.call(errorImages);
    /// 延迟通知, 也许能解决通知时UI拿到的是旧的Album (100ms是进度条对话框关闭的动画时间) --大喵
    await Future.delayed(const Duration(milliseconds: 100), notifyListeners);
  }

  Future<void> restoreSelectedImages({void Function(double progress)? onProgress, void Function(Set<ImageItem> errorImages)? onError}) async{
    if(_selectedImages.isEmpty) return onProgress?.call(1);

    final Path? gamePath = gameAlbumPath;
    if(gamePath == null) return;

    int currentProgress = 0;
    final int all = _selectedImages.length;

    final Set<ImageItem> toRemove = {};
    final Set<ImageItem> errorImages = {};

    for(ImageItem item in _selectedImages){
      try{
        if(item.source == ImageSource.backup){
          _albumWatcherNotificationBlacklist.add(item.name);
          await item.path.file.rename((gamePath + item.name).path);
          toRemove.add(item);
        }
      }catch(e){
        errorImages.add(item);
      }finally{
        onProgress?.call(++currentProgress / all);
      }
    }

    _selectedImages.removeAll(toRemove);
    _albumWatcherNotificationBlacklist.clear();
    onError?.call(errorImages);
    await Future.delayed(const Duration(milliseconds: 100), notifyListeners);
  }

  Future<void> deleteSelectedImages(Map<AlbumType, bool> chainDeletion, {void Function(double progress)? onProgress, void Function(Set<ImageItem> errorImages)? onError}) async{
    if(_selectedImages.isEmpty) return onProgress?.call(1);

    final Set<ImageItem> toRemove = {};
    final Set<ImageItem> errorImages = {};

    int currentProgress = 0;
    final int all = _selectedImages.length;

    for(ImageItem item in _selectedImages){
      try{
        _albumWatcherNotificationBlacklist.add(item.name);
        await item.path.file.delete();
        toRemove.add(item);

        for(final chain in chainDeletion.entries){
          if(!chain.value) continue;

          final Path? gameAlbumPath = getAlbumPath(chain.key, uid: _selectedUid, source: ImageSource.game);
          if(gameAlbumPath != null){
            final File imageFile = (gameAlbumPath + item.name).file;
            if(await imageFile.exists()) await imageFile.delete();
          }
          final Path? backupAlbumPath = getAlbumPath(chain.key, uid: _selectedUid, source: ImageSource.backup);
          if(backupAlbumPath != null){
            final File imageFile = (backupAlbumPath + item.name).file;
            if(await imageFile.exists()) await imageFile.delete();
          }
        }
      }catch(e){
        errorImages.add(item);
      }finally{
        onProgress?.call(++currentProgress / all);
      }
    }

    _selectedImages.removeAll(toRemove);
    _albumWatcherNotificationBlacklist.clear();
    onError?.call(errorImages);
    await Future.delayed(const Duration(milliseconds: 100), notifyListeners);
  }

  Future<void> importImages(List<ImageItem> images, {void Function(double progress)? onProgress, void Function(Set<ImageItem> errorImages)? onError}) async{
    if(images.isEmpty) return onProgress?.call(1);

    final Path? gamePath = gameAlbumPath;
    if(gamePath == null) return;

    int currentProgress = 0;
    final int all = images.length;

    final Set<ImageItem> toRemove = {};
    final Set<ImageItem> errorImages = {};

    for(ImageItem item in images){
      try{
        if(item.source == ImageSource.other){
          _albumWatcherNotificationBlacklist.add(item.name);
          await item.path.file.copy((gamePath + item.name).path);
          toRemove.add(item);
        }
      }catch(e){
        errorImages.add(item);
      }finally{
        onProgress?.call(++currentProgress / all);
      }
    }

    _albumWatcherNotificationBlacklist.clear();
    onError?.call(errorImages);
    await Future.delayed(const Duration(milliseconds: 100), notifyListeners);
  }
}



/// 验证文件是否属于InfinityNikki
/// 若是，返回根目录，否则返回null

/// $launcher$
///     | launcher.exe
///     | uninst.exe
///     | $launcherVersion$
///         | xstarter.exe
///     | InfinityNikki ($install$)
///         | InfinityNikki.exe
Future<Map<String, Path?>> locateByExePath(Path exePath) async{
  final Map<String, Path?> res = {};

  if(Platform.isWindows){
    const keys = {
      "launcher.exe": 1,  //启动器, 位于根目录
      "uninst.exe": 1,  //删除, 位于根目录
      "xstarter.exe": 2,  //启动器, 位于启动器根目录
      "InfinityNikki.exe": 2,  //游戏, 位于游戏根目录
    };

    if(!keys.containsKey(exePath.name)) return res;

    final Path launcherPath = exePath.cut(keys[exePath.name]!);
    res["launcherPath"] = launcherPath;

    final Path installPath = launcherPath + "/InfinityNikki";
    if(await installPath.directory.exists()) res["installPath"] = installPath;

  }else if(Platform.isAndroid){

  }
  return res;
}

int momoCry(int w) => w <= 0 ? momoCry(w--) : 1206;