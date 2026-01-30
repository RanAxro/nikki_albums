export "image.dart";

import "package:nikkialbums/utils/system/system.dart";
import "package:win32/win32.dart";

import "uid.dart";
import "album_manager.dart";
import "image.dart";
import "tag.dart";
import "package:nikkialbums/pages/album/album.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/utils/path.dart";
import "package:nikkialbums/utils/ini.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:async";
import "dart:convert";

import "package:win32_registry/win32_registry.dart";
import 'package:device_apps/device_apps.dart';


class GameShortcut{
  static Map<String, dynamic>? toJsonMap(GameShortcut? shortcut){
    if(shortcut == null) return null;

    return {
      "launcherChannel": shortcut.launcherChannel.name,
      "launcherPath": shortcut.launcherPath.path,
      "launcherName": shortcut.launcherName,
      "installPath": shortcut.installPath.path,
      "uid": Uid.toJsonMap(shortcut.selectedUid),
    };
  }

  static GameShortcut? from(dynamic map){
    if(map is String) map = jsonDecode(map);
    if(map is! Map) return null;

    final LauncherChannel launcherChannel = LauncherChannel.from(map["launcherChannel"]);
    final Path? launcherPath = Path.from(map["launcherPath"]);
    final dynamic launcherName = map["launcherName"];
    final Path? installPath = Path.from(map["installPath"]);
    final Uid? uid = Uid.from(map["uid"]);

    if(launcherPath == null || installPath == null || uid == null) return null;

    return GameShortcut(
      launcherChannel: launcherChannel,
      launcherPath: launcherPath,
      launcherName: launcherName is String ? launcherName : null,
      installPath: installPath,
      selectedUid: uid,
    );
  }

  final LauncherChannel launcherChannel;
  final Path launcherPath;
  final String? launcherName;
  final Path installPath;
  final Uid selectedUid;

  const GameShortcut({
    required this.launcherChannel,
    required this.launcherPath,
    this.launcherName,
    required this.installPath,
    required this.selectedUid
  });

  Game get game => Game(
    launcherChannel: launcherChannel,
    launcherPath: launcherPath,
    launcherName: launcherName,
    installPath: installPath,
    uid: selectedUid,
  );

  bool isFrom(Game game){
    return launcherChannel == game.launcherChannel &&
      launcherPath == game.launcherPath &&
      launcherName == game.launcherName &&
      installPath == game.installPath;
  }

  bool get isNailed => AppState.gameShortcuts.value.contains(this);

  void add(){
    AppState.gameShortcuts.value = {...AppState.gameShortcuts.value..add(this)};
  }
  void remove(){
    AppState.gameShortcuts.value = {...AppState.gameShortcuts.value..remove(this)};
  }


  /// ---------- class ---------- ///

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is GameShortcut && runtimeType == other.runtimeType &&
    launcherChannel == other.launcherChannel && launcherPath == other.launcherPath && launcherName == other.launcherName && installPath == other.installPath && selectedUid == other.selectedUid;

  @override
  int get hashCode => Object.hash(launcherChannel, launcherPath, launcherName, installPath, selectedUid);

  @override
  String toString() => "GameShortcut $launcherName $selectedUid";
}



class Game extends ChangeNotifier with AlbumPath{
  static List<Game>? cacheGameList;


//   static Future<List<Game>> find() async{
//     final List<Game> gameList = <Game>[];
//     final Set<LauncherChannel> finishList = <LauncherChannel>{};
//
//     for(Map<String, dynamic> data in gameWindowsRegistryPaths){
//       // 去重
//       if(finishList.contains(data["channel"])) continue;
//
//       // 读注册表
//       late final String? value;
//       try{
//         final key = Registry.openPath(
//           data["hive"],
//           path: data["path"],
//           desiredAccessRights: AccessRights.readOnly,
//         );
//         value = key.getStringValue(data["key"]);
//         key.close();
//       }catch(e){
// /// @ 1
//         AppState.writeError("game.Game.static.find.@1", e.toString());
//         value = null;
//       }
//
//       // 读不到值则退出当前循环
//       if(value == null) continue;
//
//       // launcher路径
//       final Path launcherPath = Path(value) + data["locateToLauncher"];
//       // 判断launcher文件夹是否存在
//       bool isLauncherExist = await launcherPath.typeAsync == FileSystemEntityType.directory;
//
//       // 找install路径
//       Path installPath = launcherPath + data["locateToInstall"];
//       // 判断install文件夹是否存在
//       bool isInstallExist = await installPath.typeAsync == FileSystemEntityType.directory;
//
//       // paper版本需再去 C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini 找
//       if(isInstallExist == false && data["channel"] == LauncherChannel.paper){
//         // 获取用户名
//         final username = Platform.environment["USERNAME"] ?? Platform.environment["username"] ?? Platform.environment["UserName"];
//         if(username == null) continue;
//
//         // 获取配置文件
//         final Path ini = Path(gameWindowsAppDataPath.replaceAll(r"$username$", username));
//         // 若配置文件不存在, 则退出当前循环
//         if(await ini.typeAsync != FileSystemEntityType.file) continue;
//         // 读取配置文件的 Download.gameDir值
//         late final String iniText;
//         try{
//           iniText = await ini.file.readAsString();
//         }catch(e){
// /// @ 2
//           AppState.writeError("game.Game.static.find.@2", e.toString());
//           continue;
//         }
//         // 解析ini
//         late final Map<String, Map<String, String>> jsonMap;
//         try{
//           jsonMap = parseIni(iniText);
//         }catch(e){
// /// @ 3
//           AppState.writeError("game.Game.static.find.@3", e.toString());
//           continue;
//         }
//         if(jsonMap["Download"] is Map && jsonMap["Download"]!["gameDir"] is String){
//           // 判断install是否存在
//           installPath = Path(jsonMap["Download"]!["gameDir"]!);
//           isInstallExist = await installPath.typeAsync == FileSystemEntityType.directory;
//         }
//       }
//
//       // 成功获取到install路径
//       if(isInstallExist){
//         finishList.add(data["channel"]);
//         gameList.add(
//           Game(
//             launcherChannel: data["channel"],
//             launcherPath: launcherPath,
//             installPath: installPath,
//           )
//         );
//       }
//     }
//
//     cacheGameList = gameList;
//     return gameList;
//   }

  static Map<String, dynamic>? toJsonMap(Game? game){
    if(game == null) return null;

    return {
      "launcherChannel": game.launcherChannel.name,
      "launcherPath": game.launcherPath.path,
      "launcherName": game.launcherName,
      "installPath": game.installPath.path,
      "uid": Uid.toJsonMap(game.selectedUid),
    };
  }

  static Game? from(dynamic map){
    if(map is String) map = jsonDecode(map);
    if(map is! Map) return null;

    final LauncherChannel launcherChannel = LauncherChannel.from(map["launcherChannel"]);
    final Path? launcherPath = Path.from(map["launcherPath"]);
    final dynamic launcherName = map["launcherName"];
    final Path? installPath = Path.from(map["installPath"]);
    final Uid? uid = Uid.from(map["uid"]);

    if(launcherPath == null || installPath == null) return null;

    return Game(
      launcherChannel: launcherChannel,
      launcherPath: launcherPath,
      launcherName: launcherName is String ? launcherName : null,
      installPath: installPath,
      uid: uid,
    );
  }

  // Future moveAndLinkGameInstallTo(Path toDirectory) async{
  //
  // }
  // Future moveAndLinkGameAlbumTo(Path toDirectory) async{
  //
  // }

  final LauncherChannel launcherChannel;
  Path _launcherPath;
  String? launcherName;
  Path _installPath;
  
  Game({
    this.launcherChannel = LauncherChannel.unknown,
    required Path launcherPath,
    this.launcherName,
    required Path installPath,
    Uid? uid,
  }) :
    _launcherPath = launcherPath,
    _installPath = installPath,
    _album = AlbumManager(type: defaultAlbumTypeWithoutUid, installPath: installPath),
    tag = Tag(installPath)
  {
    selectedUid = uid;
  }

  Path get launcherPath => _launcherPath;
  Path get installPath => _installPath;

  set installPath(Path newPath){
    _installPath = newPath;
    selectedUid = null;

    notifyListeners();
  }

  Path get gamePlayPhotosPath => installPath + locateToGamePlayPhotos;

  String get logoAssetName => "assets/logo/${launcherChannel.name}.png";

  AssetImage get logoImage => AssetImage(logoAssetName);

  String get name{
    if(launcherChannel == LauncherChannel.unknown){
      return launcherName ?? "";
    }
    return launcherChannel.name;
  }

  GameShortcut? get shortcut => selectedUid == null ? null : GameShortcut(
    launcherChannel: launcherChannel,
    launcherPath: launcherPath,
    launcherName: launcherName,
    installPath: installPath,
    selectedUid: selectedUid!,
  );


  /// ---------- tag ---------- ///

  final Tag tag;


  /// ---------- uid ---------- ///

  Uid? _selectedUid;

  /// TODO redo use new function [getAlbumPath]
  Future<List<Uid>> findUid() async{
    final Set<Uid> uidList = {};

    for(AlbumsInfoItem info in albumsInfoMap.values){
      if(!info.isRequireUid) continue;

      final Path root = installPath + info.locateInGame.split(r"$uid$").first;
      try{
        // 判断文件夹合法性
        if(FileSystemEntityType.directory != await root.typeAsync) continue;

        final List<FileSystemEntity> entities = await root.directory.list(recursive: false).toList();

        for(FileSystemEntity entity in entities){
          String uidValue = entity.path.split(Path.symbol).last;
          // 去重并且判断是否为6-12位数字格式
          if(RegExp(r"^\d{6,12}$").hasMatch(uidValue)) uidList.add(Uid(value: uidValue, installPath: _installPath));
        }

      }catch(e){
/// @ 1
        AppState.writeError("game.Game.findUid.@1", e.toString());
        continue;
      }
    }
    return uidList.toList(growable: false);
  }

  Uid? get selectedUid => _selectedUid;

  set selectedUid(Uid? newUid){
    if(newUid == _selectedUid) return;

    _selectedUid = newUid;
    selectedAlbum = defaultAlbumType;

    /// 不需要 notifyListeners, 当 set selectedAlbum 时, 他会通知
    // notifyListeners();
  }


  /// ---------- album ---------- ///

  AlbumManager _album;

  AlbumType get defaultAlbumType => _selectedUid == null ? defaultAlbumTypeWithoutUid : defaultAlbumTypeWithUid;

  AlbumManager get album => _album;

  AlbumType get selectedAlbum => _album.type;

  set selectedAlbum(AlbumType newType){
    if(selectedAlbum == newType) return;

    _album.dispose();
    _album = AlbumManager(
      type: newType,
      installPath: _installPath,
      uid: _selectedUid,
    );

    notifyListeners();
  }

  List<AlbumType> get accessibleAlbumType{
    final List<AlbumType> res = <AlbumType>[];

    for(MapEntry<AlbumType, AlbumsInfoItem> item in albumsInfoMap.entries){
      if(item.value.isRequireUid && _selectedUid == null) continue;
      if(!item.value.supportedPlatforms.canRunPlatform) continue;
      res.add(item.key);
    }

    return res;
  }

  void refresh() async{
    _album.refresh();

    /// 确保拿到值后再通知, 减少ui等待时间
    await _album.images;
    notifyListeners();
  }

  Future<void> backupSelectedImages({void Function(double progress)? onProgress, void Function(Set<ImageItem> errorImages)? onError}) async{
    if(_album.selectedImages.isEmpty) return onProgress?.call(1);

    final Path? backupPath = _album.backupAlbumPath;
    if(backupPath == null) return;

    int currentProgress = 0;
    final int all = _album.selectedImages.length;

    final Set<ImageItem> toRemove = {};
    final Set<ImageItem> errorImages = {};

    for(ImageItem item in _album.selectedImages){
      try{
        if(item.source == ImageSource.game){
          await item.path.file.rename((backupPath + item.name).path);
          toRemove.add(item);
        }
      }catch(e){
        errorImages.add(item);
      }finally{
        onProgress?.call(++currentProgress / all);
      }
    }

    _album.selectedImages.removeAll(toRemove);
    onError?.call(errorImages);
  }

  Future<void> restoreSelectedImages({void Function(double progress)? onProgress, void Function(Set<ImageItem> errorImages)? onError}) async{
    if(_album.selectedImages.isEmpty) return onProgress?.call(1);

    final Path? gamePath = _album.gameAlbumPath;
    if(gamePath == null) return;

    int currentProgress = 0;
    final int all = _album.selectedImages.length;

    final Set<ImageItem> toRemove = {};
    final Set<ImageItem> errorImages = {};

    for(ImageItem item in _album.selectedImages){
      try{
        if(item.source == ImageSource.backup){
          await item.path.file.rename((gamePath + item.name).path);
          toRemove.add(item);
        }
      }catch(e){
        errorImages.add(item);
      }finally{
        onProgress?.call(++currentProgress / all);
      }
    }

    _album.selectedImages.removeAll(toRemove);
    onError?.call(errorImages);
  }

  // Future<void> deleteSelectedImages(Map<AlbumType, bool> chainDeletion, {void Function(double progress)? onProgress, void Function(Set<ImageItem> errorImages)? onError}) async{
  //   if(_album.selectedImages.isEmpty) return onProgress?.call(1);
  //
  //   final Set<ImageItem> toRemove = {};
  //
  //   final Set<ImageItem> errorImages = {};
  //
  //   int currentProgress = 0;
  //   final int all = _album.selectedImages.length;
  //
  //   for(ImageItem item in _album.selectedImages){
  //     try{
  //       await item.path.file.delete();
  //       toRemove.add(item);
  //
  //       for(final chain in chainDeletion.entries){
  //         if(!chain.value) continue;
  //         if(!albumsInfoMap[chain.key]!.supportedPlatforms.canRunPlatform) continue;
  //
  //         final Path? gameAlbumPath = getAlbumPath(installPath, chain.key, uid: _selectedUid, source: ImageSource.game);
  //         if(gameAlbumPath != null){
  //           final File imageFile = (gameAlbumPath + item.name).file;
  //           if(await imageFile.exists()) await imageFile.delete();
  //         }
  //         final Path? backupAlbumPath = getAlbumPath(installPath, chain.key, uid: _selectedUid, source: ImageSource.backup);
  //         if(backupAlbumPath != null){
  //           final File imageFile = (backupAlbumPath + item.name).file;
  //           if(await imageFile.exists()) await imageFile.delete();
  //         }
  //       }
  //     }catch(e){
  //       errorImages.add(item);
  //     }finally{
  //       onProgress?.call(++currentProgress / all);
  //     }
  //   }
  //
  //   _album.selectedImages.removeAll(toRemove);
  //   onError?.call(errorImages);
  // }

  Future<void> recycleSelectedImages(Map<AlbumType, bool> chainDeletion, {void Function(double progress)? onProgress, void Function(Set<ImageItem> errorImages)? onError}) async{
    if(_album.selectedImages.isEmpty) return onProgress?.call(1);

    final AlbumType albumType = selectedAlbum;
    final String msSinceEpoch = DateTime.now().millisecondsSinceEpoch.toString();
    final String? uid = selectedUid?.value;

    final Set<ImageItem> toRemove = {};
    final Set<ImageItem> errorImages = {};

    int current = 0;
    final int total = _album.selectedImages.length;

    for(ImageItem item in _album.selectedImages){

      final bool itemRes = await _recycleOrDeleteImage(item.path, msSinceEpoch, albumType, uid, false);
      toRemove.add(item);
      if(!itemRes) errorImages.add(item);

      for(final MapEntry<AlbumType, bool> chain in chainDeletion.entries){
        if(!chain.value) continue;
        if(!albumsInfoMap[chain.key]!.supportedPlatforms.canRunPlatform) continue;

        final Path? gameAlbumPath = getAlbumPath(installPath, chain.key, uid: _selectedUid, source: ImageSource.game);
        if(gameAlbumPath != null){
          final File imageFile = (gameAlbumPath + item.name).file;
          if(await imageFile.exists()){
            await _recycleOrDeleteImage(Path(imageFile.path), msSinceEpoch, chain.key, uid, false);
          }
        }
        final Path? backupAlbumPath = getAlbumPath(installPath, chain.key, uid: _selectedUid, source: ImageSource.backup);
        if(backupAlbumPath != null){
          final File imageFile = (backupAlbumPath + item.name).file;
          if(await imageFile.exists()){
            await _recycleOrDeleteImage(Path(imageFile.path), msSinceEpoch, chain.key, uid, false);
          }
        }
      }

      onProgress?.call(current++ / total);
    }

    onProgress?.call(1);

    _album.selectedImages.removeAll(toRemove);
    onError?.call(errorImages);
  }

  Future<bool> _recycleOrDeleteImage(Path imagePath, String msSinceEpoch, AlbumType albumType, [String? uid, bool delete = true]) async{
    bool isRecycle = false;
    if(albumsInfoMap[albumType]!.isRequireUid && uid == null){
      isRecycle = false;
    }else{
      String recycleRelativePath = albumsInfoMap[albumType]!.locateInRecycleBin.replaceAll(r"$msSinceEpoch$", msSinceEpoch);
      if(albumsInfoMap[albumType]!.isRequireUid) recycleRelativePath = recycleRelativePath.replaceAll(r"$uid$", uid!);
      final Path recycleAbsolutePath = installPath + recycleRelativePath;
      final Path imageRecyclePath = recycleAbsolutePath + imagePath.name;

      try{
        if(!await recycleAbsolutePath.directory.exists()){
          await recycleAbsolutePath.directory.create(recursive: true);
        }

        await imagePath.file.rename(imageRecyclePath.path);
        isRecycle = true;
      }catch(e){
        isRecycle = false;
      }
    }

    if(isRecycle == true){
      return true;
    }
    if(isRecycle == false && delete == true){
      try{
        await imagePath.file.delete();
        return true;
      }catch(e){
        return false;
      }
    }

    return false;
  }

  Future<void> importImages(List<ImageItem> images, {void Function(double progress)? onProgress, void Function(Set<ImageItem> errorImages)? onError}) async{
    if(images.isEmpty) return onProgress?.call(1);

    final Path? gamePath = _album.gameAlbumPath;
    if(gamePath == null) return;

    int currentProgress = 0;
    final int all = images.length;

    final Set<ImageItem> toRemove = {};
    final Set<ImageItem> errorImages = {};

    for(ImageItem item in images){
      try{
        if(item.source == ImageSource.other){
          await item.path.file.copy((gamePath + item.name).path);
          toRemove.add(item);
        }
      }catch(e){
        errorImages.add(item);
      }finally{
        onProgress?.call(++currentProgress / all);
      }
    }

    onError?.call(errorImages);
  }


  /// ---------- class ---------- ///

  @override
  String toString() => "Game $launcherName";
}

extension FindGame on Game{

  static Future<List<Game>> find() async{
    if(Platform.isWindows){
      return findInWindows();
    }
    else if(Platform.isAndroid){
      return findInAndroid();
    }
    else{
      return <Game>[];
    }
  }


  static Future<List<Game>> findInWindows() async{
    final List<Game> gameList = <Game>[];
    final Set<LauncherChannel> finishList = <LauncherChannel>{};

    for(final InfinityNikkiInfo info in infinityNikkiInfos){

      for(final WindowsRegistryInfo registryInfo in info.locateByWindowsRegistry){

        // 去重
        if(finishList.contains(info.channel)) continue;

        // 读注册表
        late final String? value;
        try{
          final key = Registry.openPath(
            registryInfo.hive,
            path: registryInfo.path,
            desiredAccessRights: AccessRights.readOnly,
          );
          value = key.getStringValue(registryInfo.key);
          key.close();
        }on WindowsException catch(e){
          // 键值/路径不存在 ERROR_FILE_NOT_FOUND == 2
          if(e.hr == ERROR_FILE_NOT_FOUND){
            value = null;
          }else{
            /// @ 1
            AppState.writeError("game.Game.static.find.@1", e.toString());
            value = null;
          }
        }

        // 读不到值则退出当前循环
        if(value == null) continue;

        // launcher路径
        final Path launcherPath = Path(value) + registryInfo.locateToLauncher;
        // 判断launcher文件夹是否存在
        bool isLauncherExist = await launcherPath.typeAsync == FileSystemEntityType.directory;
        if(!isLauncherExist) continue;

        // 找install路径
        Path installPath = launcherPath + registryInfo.locateToInstall;
        // 判断install文件夹是否存在
        bool isInstallExist = await installPath.typeAsync == FileSystemEntityType.directory;

        // 若找不到install文件玩则去 config.ini 找
        if(isInstallExist == false && registryInfo.configPath != null){
          // 获取用户名
          final username = await getWindowsUserName();
          if(username == null) continue;

          // 获取配置文件
          final Path ini = Path(registryInfo.configPath!.replaceAll(r"$username$", username));
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
          finishList.add(info.channel);
          gameList.add(
            Game(
              launcherChannel: info.channel,
              launcherPath: launcherPath,
              installPath: installPath,
            )
          );
        }
      }
    }

    Game.cacheGameList = gameList;
    return gameList;
  }


  static Future<List<Game>> findInAndroid() async{
    final List<Game> gameList = <Game>[];
    final Set<LauncherChannel> finishList = <LauncherChannel>{};

    for(final InfinityNikkiInfo info in infinityNikkiInfos){


      for(final AndroidApplicationIdInfo applicationIdInfo in info.locateByAndroidApplicationId){

        // 去重
        if(finishList.contains(info.channel)) continue;

        // 包名
        final Path launcherPath = Path(applicationIdInfo.applicationId);
        // 判断应用是否安装
        bool isLauncherExist = await DeviceApps.isAppInstalled(launcherPath.path);
        if(!isLauncherExist) continue;


        // 找install路径
        final Path? dataDir = await getAndroidDataDir(launcherPath);
        if(dataDir == null) continue;

        Path installPath = dataDir + applicationIdInfo.locateToInstall;
        // 判断install文件夹是否存在
        bool isInstallExist = await installPath.typeAsync == FileSystemEntityType.directory;
        isInstallExist = true;

        // 成功获取到install路径
        if(isInstallExist){
          finishList.add(info.channel);
          gameList.add(
            Game(
              launcherChannel: info.channel,
              launcherPath: launcherPath,
              installPath: installPath,
            )
          );
        }
      }
    }

    return gameList;
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