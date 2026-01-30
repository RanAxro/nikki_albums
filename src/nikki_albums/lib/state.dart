import "dart:async";

import "package:bitsdojo_window/bitsdojo_window.dart";
import "package:nikkialbums/nikkias/nikkias.dart";
import "package:nikkialbums/utils/system/system.dart";
import "package:nikkialbums/utils/path.dart";
import "package:nikkialbums/game/uid.dart";
import "package:nikkialbums/ui/frame.dart";
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/pages/album/album.dart" as album_page;
import "package:nikkialbums/pages/start/start.dart" as start_page;
import "package:nikkialbums/pages/resource/resource.dart" as resource_page;
import "package:nikkialbums/pages/file_transfer/file_transfer.dart" as file_transfer_page;
import "package:nikkialbums/pages/recycle_bin/recycle_bin.dart" as recycle_bin;

import "package:flutter/material.dart";

import "dart:convert";
import "dart:io";

final GlobalKey ancestor = GlobalKey();
final GlobalKey frameKey = GlobalKey();

final ContentController pages = ContentController();

abstract class AppState{
  /// common
  static final ValueNotifier<bool> isAgreeAgreement =  _createStateValue<bool>(false);  // 用户是否同意软件使用协议
  static final ValueNotifier<String?> sfxPath =  ValueNotifier<String?>(null);  // sfx 路径
  static final ValueNotifier<String?> nikkiasToBeParsed =  ValueNotifier<String?>(null);  // 需要解析的 nikkias 文件路径
  /// ui common
  static final ValueNotifier<String> lang =  _createStateValue<String>("zh-CN");
  static final ValueNotifier<int> theme =  _createStateValue<int>(0xFFEEEEEE);  // theme 0xFFEEEEEE
  static final ValueNotifier<int> animationDuration =  _createStateValue<int>(100);
  /// frame
  static final ValueNotifier<Game?> currentGame = _createStateValue<Game?>(null);
  static final ValueNotifier<List<Game>> customGame = _createStateValue<List<Game>>([]);
  static final ValueNotifier<Set<UidNote>> uidNotes = _createStateValue<Set<UidNote>>({});
  static final ValueNotifier<Set<GameShortcut>> gameShortcuts = _createStateValue<Set<GameShortcut>>({});
  /// album
  static final ValueNotifier<int> albumColumn = _createStateValue<int>(4);
  /// only windows
  static final ValueNotifier<bool> isUseMaximizeOrRestoreButton = _createStateValue<bool>(true);
  static final ValueNotifier<bool> needFileAssociationHelper = _createStateValue<bool>(true);


  static ValueNotifier<T> _createStateValue<T>(T initValue){
    final ValueNotifier<T> vn = ValueNotifier<T>(initValue);
    vn.addListener((){
      save();
    });
    return vn;
  }

  static Future<void> read() async{
    final Path config = (await getAppDataDirectoryPath()) + "config3.json";
    late final Map jsonMap;

    try{
      if(!await config.file.exists()){
        save();
        return;
      }

      jsonMap = jsonDecode(await config.file.readAsString());
    }catch(e){
      writeError("AppState.read", e.toString());
      return;
    }

    /// 辅助函数
    assign<T>(String key, Function(T value) callback){
      if(jsonMap.containsKey(key) && jsonMap[key] is T) callback(jsonMap[key]);
    }

    assign<bool>("isAgreeAgreement", (bool value) => isAgreeAgreement.value = value);
    assign<String>("lang", (String value) => lang.value = value);
    assign<int>("theme", (int value) => theme.value = value);
    assign<int>("animationDuration", (int value) => animationDuration.value = value);
    assign<Map>("currentGame", (Map value) => currentGame.value = Game.from(value));
    assign<List>("customGame", (List value){
      final List<Game> res = <Game>[];
      for(dynamic map in value){
        final Game? game = Game.from(map);
        if(game != null) res.add(game);
      }
      customGame.value = res;
      // customGame.value = value.map((gameMap) => Game.fromMap(gameMap)).where((Game? game) => game != null).toList() as List<Game>
    });
    assign<List>("uidNotes", (List value){
      final Set<UidNote> res = {};
      for(dynamic map in value){
        final UidNote? uidNote = UidNote.from(map);
        if(uidNote != null) res.add(uidNote);
      }
      uidNotes.value = res;
    });
    assign<List>("gameShortcuts", (List value){
      final Set<GameShortcut> res = {};
      for(dynamic map in value){
        final GameShortcut? shortcut = GameShortcut.from(map);
        if(shortcut != null) res.add(shortcut);
      }
      gameShortcuts.value = res;
    });
    assign<int>("albumColumn", (int value) => albumColumn.value = value);
    assign<bool>("isUseMaximizeOrRestoreButton", (bool value) => isUseMaximizeOrRestoreButton.value = value);
    assign<bool>("needFileAssociationHelper", (bool value) => needFileAssociationHelper.value = value);
  }

  static Future<void> save() async{
    final Path config = (await getAppDataDirectoryPath()) + "config3.json";
    if(!await config.file.exists()){
      config.file.create(recursive: true);
    }

    final Map jsonMap = {
      "isAgreeAgreement": isAgreeAgreement.value,
      "lang": lang.value,
      "theme": theme.value,
      "animationDuration": animationDuration.value,
      "currentGame": Game.toJsonMap(currentGame.value),
      "customGame": customGame.value.map((Game game) => Game.toJsonMap(game)).toList(),
      "uidNotes": uidNotes.value.map((UidNote uidNote) => UidNote.toJsonMap(uidNote)).toList(),
      "gameShortcuts": gameShortcuts.value.map((GameShortcut shortcut) => GameShortcut.toJsonMap(shortcut)).toList(),
      "albumColumn": albumColumn.value,
      "isUseMaximizeOrRestoreButton": isUseMaximizeOrRestoreButton.value,
      "needFileAssociationHelper": needFileAssociationHelper.value,
    };

    try{
      // 编码并写入配置
      final String json = jsonEncode(jsonMap);
      await config.file.writeAsString(json);
    }catch(e){
      writeError("AppState.save", e.toString());
    }
  }

  static Future<void> writeError(String form, String error) async{
    try{
      final Path log = (await getAppDataDirectoryPath()) + "log.txt";
      if(!await log.file.exists()){
        log.file.create(recursive: true);
      }
      log.file.writeAsString("\n$form : $error", mode: FileMode.append, flush: true);
    }on FileSystemException catch(e){
      final errno = e.osError?.errorCode;
      switch(errno){
        case 13:
          print("权限被拒（Android 6+ 没动态申请存储权限，或 iOS 沙盒外路径）");
          break;
        case 28:
          print("磁盘已满");
          break;
        case 16 || 32:
          print("进程被占用");
          break;
      }
    }catch(e){
      print("写入失败: $e");
    }
  }
}

Future<void> initApp() async{
  album_page.init();
  start_page.init();
  file_transfer_page.init();
  resource_page.init();
  recycle_bin.init();

  await AppState.read();

  Nikkias.init();
}


final List<FutureOr<void> Function()> _runBeforeCloseApp = [];
void onCloseApp(FutureOr<void> Function() fn){
  _runBeforeCloseApp.add(fn);
}
Future<void> closeApp() async{
  for(final fn in _runBeforeCloseApp){
    await fn();
  }

  await AppState.save();
  if(Platform.isWindows){
    appWindow.close();
  }

  exit(0);
}



