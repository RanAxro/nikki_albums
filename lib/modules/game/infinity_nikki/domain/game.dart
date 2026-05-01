





import "launcher.dart";
import "../model/flag.dart";
import "../model/launcher_channel.dart";
import "../model/infinity_nikki_info.dart";
import "../model/album_type.dart";
import "../model/album_info.dart";
import "query_album_info.dart";
import "../model/exception.dart";
import "package:nikki_albums/modules/game/trait.dart";
import "package:nikki_albums/modules/app_base/data/log.dart";
import "package:nikki_albums/utils/system/windows.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:path/path.dart" as p;
import "package:ini/ini.dart";
import "package:win32_registry/win32_registry.dart";
import "package:win32/win32.dart";

abstract class InfinityNikki extends Game{
  static final GameOptionConfig _uidConfig = GameOptionConfig(
    mustBeSelected: false,
  );

  const InfinityNikki();

  InfinityNikkiFlag get flag;

  @override
  GameOptionConfig? get optionConfig => _uidConfig;

  @override
  bool get allowCustom => true;

  @override
  GameSession? addCustom(BuildContext context){
    // TODO: add custom
    return super.addCustom(context);
  }
}

class InfinityNikkiSession extends GameSession{
  final String alias;
  final LauncherChannel launcherChannel;
  final InfinityNikkiLauncher? launcher;
  final String installPath;

  InfinityNikkiSession({
    this.alias = "",
    this.launcherChannel = LauncherChannel.unknown,
    this.launcher,
    required this.installPath
  });

  Uid? _uid;


  /// find uid
  @override
  Future<List<Uid>> getOptions() async{
    final Set<Uid> uidList = {};

    for(AlbumType type in AlbumType.values){
      final AlbumInfo info = queryAlbumInfo(type);

      if(!info.isRequireUid) continue;

      final String rootPath = p.join(installPath, info.locateInGame.split(r"$uid$").first);
      final Directory rootDir = Directory(rootPath);
      try{
        // 判断文件夹合法性
        if(!(await rootDir.exists())) continue;

        await for(FileSystemEntity entity in rootDir.list(recursive: false)){
          final String uidValue = p.basename(entity.path);
          // 判断格式
          if(Uid.isUidType(uidValue)){
            uidList.add(Uid.fromValue(uidValue));
          }
        }
      }catch(e){
        AppLog.write("game.UidSearcher.findByGame", e.toString());
        continue;
      }
    }

    return uidList.toList(growable: false);
  }

  @override
  Future<ImageProvider?> getPicture() async{
    return (await _uid?.getPicture(this)) ?? (launcherChannel.logoAssetName == null ? null : AssetImage(launcherChannel.logoAssetName!));
  }

  @override
  String get name => launcherChannel == LauncherChannel.unknown ? alias : launcherChannel.nameKey;

  @override
  bool get isTranslate => launcherChannel != LauncherChannel.unknown;

  @override
  GameOption? get option => _uid;
}

class Uid extends GameOption<InfinityNikkiSession>{
  static bool isUidType(String uidValue){
    return RegExp(r"^\d{9}$").hasMatch(uidValue);
  }

  final String value;

  const Uid._(this.value);

  factory Uid.fromValue(String source){
    if(!isUidType(source)){
      throw IncorrectUidFormatException(source);
    }

    return Uid._(source);
  }

  /// find avatar
  @override
  Future<ImageProvider?> getPicture(covariant InfinityNikkiSession session) async{
    final String avatarAlbumPath = queryPathForGame(AlbumType.customAvatar, session.installPath, value);
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

    return avatar == null ? null : FileImage(File(avatar.$1));
  }

  @override
  String get name => value;
}







class InfinityNikkiWindows extends InfinityNikki{
  const InfinityNikkiWindows();

  @override
  InfinityNikkiFlag get flag => InfinityNikkiFlag.windows;

  @override
  // TODO: implement picture
  ImageProvider<Object>? get picture => AssetImage("");

  @override
  String get name => "infinity_nikki.infinity_nikki_pc";

  @override
  Future<List<InfinityNikkiSession>> getSessions() async{
    final List<InfinityNikkiSession> gameList = <InfinityNikkiSession>[];
    final Set<LauncherChannel> finished = <LauncherChannel>{};

    for(final MapEntry entry in infinityNikkiWindowsInfos.entries){
      final LauncherChannel channel = entry.key;
      final List<InfinityNikkiWindowsInfo> infos = entry.value;

      for(final InfinityNikkiWindowsInfo info in infos){
        // 去重
        if(finished.contains(channel)) continue;

        // 读注册表
        late final String? value;
        try{
          final RegistryKey key = Registry.openPath(
            info.hive,
            path: info.path,
            desiredAccessRights: AccessRights.readOnly,
          );
          value = key.getStringValue(info.key);
          key.close();
        }on WindowsException catch(e){
          // 键值/路径不存在 ERROR_FILE_NOT_FOUND == 2
          if(e.hr == ERROR_FILE_NOT_FOUND){
            value = null;
          }else{
            AppLog.write("game.GameSearcher.findByInfoInWindows.@1", e.toString());
            value = null;
          }
        }catch(e){
          AppLog.write("game.GameSearcher.findByInfoInWindows.@2", e.toString());
        }

        // 读不到值则退出当前循环
        if(value == null) continue;

        // 找launcher路径
        final String launcherPath = p.join(value, info.locateToLauncher);
        // 判断launcher文件夹是否存在
        final Directory launcherDir = Directory(launcherPath);
        final bool isLauncherExist = await launcherDir.exists();

        // 找install路径
        String installPath = p.join(launcherPath, info.locateToInstall);
        Directory installDir = Directory(installPath);
        bool isInstallExist = await installDir.exists();

        // 若找不到install文件玩则去 config.ini 找
        if(isInstallExist == false && info.configPath != null){
          // 获取用户名
          final String? username = await getWindowsUserName();
          if(username == null) continue;

          // 获取配置文件
          final String iniPath = info.configPath!.replaceAll(r"$username$", username);
          final File iniFile = File(iniPath);
          // 若配置文件不存在, 则退出当前循环
          if(!(await iniFile.exists())){
            continue;
          }

          // 读取配置文件的 Download.gameDir值
          late final List<String> iniLines;
          try{
            iniLines = await iniFile.readAsLines();
          }catch(e){
            AppLog.write("game.GameSearcher.findByInfoInWindows.@3", e.toString());
            continue;
          }
          final Config iniConfig = Config.fromStrings(iniLines);
          final String? installPathOrNull = iniConfig.get("Download", "gameDir");

          if(installPathOrNull != null){
            installPath = installPathOrNull;
            installDir = Directory(installPath);
            isInstallExist = await installDir.exists();
          }
        }

        // 成功获取到install路径
        if(isInstallExist){
          finished.add(channel);
          gameList.add(InfinityNikkiSession(
            alias: "",
            launcher: isLauncherExist ? InfinityNikkiWindowsLauncher(
              channel: channel,
              path: launcherPath,
            ) : null,
            installPath: installPath,
          ));
        }
      }
    }

    return gameList;
  }

  @override
  List<GameSession> getCustomSessions(){
    // TODO: implement getCustomSessions
    throw UnimplementedError();
  }
}

class InfinityNikkiAndroid extends InfinityNikki{
  const InfinityNikkiAndroid();

  @override
  InfinityNikkiFlag get flag => InfinityNikkiFlag.android;

  @override
  // TODO: implement picture
  ImageProvider<Object>? get picture => AssetImage("");

  @override
  String get name => "infinity_nikki.infinity_nikki";

  @override
  Future<List<GameSession>> getSessions(){
    // TODO: implement getSessions
    throw UnimplementedError();
  }

  @override
  List<GameSession> getCustomSessions(){
    // TODO: implement getCustomSessions
    throw UnimplementedError();
  }
}