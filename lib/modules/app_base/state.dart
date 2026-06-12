import "dart:async";

import "package:window_manager/window_manager.dart";
import "package:nikki_albums/modules/nikkias/nikkias.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/utils/path.dart";
import "package:nikki_albums/modules/game/uid.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/modules/game/game.dart";

import "package:flutter/material.dart";

import "dart:convert";
import "dart:io";

final GlobalKey ancestor = GlobalKey();
final GlobalKey frameKey = GlobalKey();

final ContentController contentController = ContentController(1);

abstract class AppState {
  /// common
  static final ValueNotifier<bool> isAgreeAgreement = _createStateValue<bool>(false); // 用户是否同意软件使用协议
  static final ValueNotifier<bool> isInitialStartup = _createStateValue<bool>(true); // 是否首次启动软件
  static final ValueNotifier<String?> sfxPath = ValueNotifier<String?>(null); // sfx 路径
  static final ValueNotifier<String?> nikkiasToBeParsed = ValueNotifier<String?>(null); // 需要解析的 nikkias 文件路径
  /// app common
  static final ValueNotifier<String> lang = _createStateValue<String>("zh-CN");
  static final ValueNotifier<int> theme = _createStateValue<int>(0xFFEEEEEE); // theme 0xFFEEEEEE

  static final ValueNotifier<bool> isThemeFollowSystem = _createStateValue<bool>(true);
  static final ValueNotifier<int> animationDuration = _createStateValue<int>(100);

  /// frame
  static final ValueNotifier<Game?> currentGame = _createStateValue<Game?>(null);
  static final ValueNotifier<List<Game>> customGame = _createStateValue<List<Game>>([]);
  static final ValueNotifier<Set<UidNote>> uidNotes = _createStateValue<Set<UidNote>>({});
  static final ValueNotifier<Set<GameShortcut>> gameShortcuts = _createStateValue<Set<GameShortcut>>({});

  /// album
  static final ValueNotifier<int> albumColumn = _createStateValue<int>(7);
  static final ValueNotifier<bool> isShowImageCustomData = _createStateValue<bool>(true);
  static final ValueNotifier<double?> imageCustomDataWidgetSize = _createStateValue<double?>(null);

  /// creation
  static final ValueNotifier<String?> creationDirectoryPath = _createStateValue<String?>(null);

  /// only windows
  static final ValueNotifier<bool> isUseMaximizeOrRestoreButton = _createStateValue<bool>(true);
  static final ValueNotifier<bool> needFileAssociationHelper = _createStateValue<bool>(true);

  /// live photo export format: "none", "apple", "google"
  static final ValueNotifier<String> livePhotoExportFormat = _createStateValue<String>(Platform.isMacOS ? "apple" : "none");
  static final ValueNotifier<Map> exportingImageDirs = _createStateValue<Map>({});

  /// debug
  static final ValueNotifier<String?> debugNuan5DecryptionOutput = _createStateValue<String?>(null);
  static final ValueNotifier<String?> debugNuan5DecryptionInput = _createStateValue<String?>(null);
  static final ValueNotifier<String?> debugNuan5DecryptionKey = _createStateValue<String?>(null);
  static final ValueNotifier<String?> debugNuan5DecryptionFlag = _createStateValue<String?>(null);
  static final ValueNotifier<String?> debugNuan5DecryptionCameraParams = _createStateValue<String?>(null);
  static final ValueNotifier<String?> debugNuan5DecryptionShareCode = _createStateValue<String?>(null);

  static ValueNotifier<T> _createStateValue<T>(T initValue) {
    final ValueNotifier<T> vn = ValueNotifier<T>(initValue);
    vn.addListener(() {
      save();
    });
    return vn;
  }

  static Future<void> read() async {
    final Path config = (await getAppDataDirectoryPath()) + "config3.json";
    late final Map jsonMap;

    try {
      if (!await config.file.exists()) {
        save();
        return;
      }

      jsonMap = jsonDecode(await config.file.readAsString());
    } catch (e) {
      writeError("AppState.read", e.toString());
      return;
    }

    /// 辅助函数
    assign<T>(String key, Function(T value) callback) {
      if (jsonMap.containsKey(key) && jsonMap[key] is T) callback(jsonMap[key]);
    }

    assign<bool>(
      "isAgreeAgreement",
      (bool value) => isAgreeAgreement.value = value,
    );
    assign<bool>("isInitialStartup", (bool value) => isInitialStartup.value = value);
    assign<String>("lang", (String value) => lang.value = value);
    assign<int>("theme", (int value) => theme.value = value);
    assign<bool>(
      "isThemeFollowSystem",
      (bool value) => isThemeFollowSystem.value = value,
    );
    assign<int>(
      "animationDuration",
      (int value) => animationDuration.value = value,
    );
    assign<Map>(
      "currentGame",
      (Map value) => currentGame.value = Game.from(value),
    );
    assign<List>("customGame", (List value) {
      final List<Game> res = <Game>[];
      for (dynamic map in value) {
        final Game? game = Game.from(map);
        if (game != null) res.add(game);
      }
      customGame.value = res;
      // customGame.value = value.map((gameMap) => Game.fromMap(gameMap)).where((Game? game) => game != null).toList() as List<Game>
    });
    assign<List>("uidNotes", (List value) {
      final Set<UidNote> res = {};
      for (dynamic map in value) {
        final UidNote? uidNote = UidNote.from(map);
        if (uidNote != null) res.add(uidNote);
      }
      uidNotes.value = res;
    });
    assign<List>("gameShortcuts", (List value) {
      final Set<GameShortcut> res = {};
      for (dynamic map in value) {
        final GameShortcut? shortcut = GameShortcut.from(map);
        if (shortcut != null) res.add(shortcut);
      }
      gameShortcuts.value = res;
    });
    assign<int>("albumColumn", (int value) => albumColumn.value = value);
    assign<bool>(
      "isShowImageCustomData",
      (bool value) => isShowImageCustomData.value = value,
    );
    assign<double?>(
      "imageCustomDataWidgetSize",
      (double? value) => imageCustomDataWidgetSize.value = value,
    );
    assign<String?>(
      "creationDirectoryPath",
      (String? value) => creationDirectoryPath.value = value,
    );
    assign<bool>(
      "isUseMaximizeOrRestoreButton",
      (bool value) => isUseMaximizeOrRestoreButton.value = value,
    );
    assign<bool>(
      "needFileAssociationHelper",
      (bool value) => needFileAssociationHelper.value = value,
    );
    assign<String>(
      "livePhotoExportFormat",
      (String value) => livePhotoExportFormat.value = value,
    );
    assign<Map>(
      "exportingImageDirs",
      (Map value) => exportingImageDirs.value = value,
    );

    assign<String?>("debugNuan5DecryptionOutput", (String? value) => debugNuan5DecryptionOutput.value = value);
    assign<String?>("debugNuan5DecryptionInput", (String? value) => debugNuan5DecryptionInput.value = value);
    assign<String?>("debugNuan5DecryptionKey", (String? value) => debugNuan5DecryptionKey.value = value);
    assign<String?>("debugNuan5DecryptionFlag", (String? value) => debugNuan5DecryptionFlag.value = value);
    assign<String?>("debugNuan5DecryptionCameraParams", (String? value) => debugNuan5DecryptionCameraParams.value = value);
    assign<String?>("debugNuan5DecryptionShareCode", (String? value) => debugNuan5DecryptionShareCode.value = value);
  }

  static Future<void> save() async {
    final Path config = (await getAppDataDirectoryPath()) + "config3.json";
    if (!await config.file.exists()) {
      config.file.create(recursive: true);
    }

    final Map jsonMap = {
      "isAgreeAgreement": isAgreeAgreement.value,
      "isInitialStartup": isInitialStartup.value,
      "lang": lang.value,
      "theme": theme.value,
      "isThemeFollowSystem": isThemeFollowSystem.value,
      "animationDuration": animationDuration.value,
      "currentGame": Game.toJsonMap(currentGame.value),
      "customGame": customGame.value
          .map((Game game) => Game.toJsonMap(game))
          .toList(),
      "uidNotes": uidNotes.value
          .map((UidNote uidNote) => UidNote.toJsonMap(uidNote))
          .toList(),
      "gameShortcuts": gameShortcuts.value
          .map((GameShortcut shortcut) => GameShortcut.toJsonMap(shortcut))
          .toList(),
      "albumColumn": albumColumn.value,
      "isShowImageCustomData": isShowImageCustomData.value,
      "imageCustomDataWidgetSize": imageCustomDataWidgetSize.value,
      "creationDirectoryPath": creationDirectoryPath.value,
      "isUseMaximizeOrRestoreButton": isUseMaximizeOrRestoreButton.value,
      "needFileAssociationHelper": needFileAssociationHelper.value,
      "livePhotoExportFormat": livePhotoExportFormat.value,
      "exportingImageDirs": exportingImageDirs.value,

      "debugNuan5DecryptionOutput": debugNuan5DecryptionOutput.value,
      "debugNuan5DecryptionInput": debugNuan5DecryptionInput.value,
      "debugNuan5DecryptionKey": debugNuan5DecryptionKey.value,
      "debugNuan5DecryptionFlag": debugNuan5DecryptionFlag.value,
      "debugNuan5DecryptionCameraParams": debugNuan5DecryptionCameraParams.value,
      "debugNuan5DecryptionShareCode": debugNuan5DecryptionShareCode.value,
    };

    try {
      // 编码并写入配置
      final String json = jsonEncode(jsonMap);
      await config.file.writeAsString(json);
    } catch (e) {
      writeError("AppState.save", e.toString());
    }
  }

  static Future<void> writeError(String form, String error) async {
    try {
      final Path log = (await getAppDataDirectoryPath()) + "log.txt";
      if (!await log.file.exists()) {
        log.file.create(recursive: true);
      }
      log.file.writeAsString(
        "\n$form : $error",
        mode: FileMode.append,
        flush: true,
      );
    } on FileSystemException catch (e) {
      final errno = e.osError?.errorCode;
      switch (errno) {
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
    } catch (e) {
      print("写入失败: $e");
    }
  }
}

Future<void> initApp() async {
  await AppState.read();

  // Auto-detect system language on first launch
  if (AppState.isInitialStartup.value) {
    final systemLocale = Platform.localeName; // e.g. "en_US", "zh-Hans_CN", "ja_JP"
    final supported = {
      'zh': 'zh-CN',
      'en': 'en-US',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'id': 'id-ID',
      'it': 'it-IT',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'pt': 'pt-BR',
      'es': 'es-ES',
      'th': 'th-TH',
    };
    final lang = systemLocale.split(RegExp(r'[_\-]')).first.toLowerCase();
    if (lang == 'zh' && (systemLocale.contains('Hant') || systemLocale.contains('TW') || systemLocale.contains('HK') || systemLocale.contains('MO'))) {
      AppState.lang.value = 'zh-TW';
    } else if (supported.containsKey(lang)) {
      AppState.lang.value = supported[lang]!;
    }
  }

  // Auto-detect game on first launch if no game is saved
  await autoDetectGame();

  Nikkias.init();
}

Future<void> autoDetectGame() async {
  if (AppState.currentGame.value == null) {
    try {
      final games = await FindGame.find();
      if (games.isNotEmpty) {
        final game = games.first;
        final uids = await game.findUid();
        if (uids.isNotEmpty) {
          game.selectedUid = uids.first;
        }
        AppState.currentGame.value = game;
      }
    } catch (_) {}
  }
}

final List<FutureOr<void> Function()> _runBeforeCloseApp = [];
void onCloseApp(FutureOr<void> Function() fn) {
  _runBeforeCloseApp.add(fn);
}

Future<void> closeApp() async {
  for (final fn in _runBeforeCloseApp) {
    await fn();
  }

  await AppState.save();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.close();
  } else {
    exit(0);
  }
}
