

import "dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart";

import "package:flutter/material.dart";


enum AppStateItem{
  isAgreeAgreement,
  sfxPath,
  nikkiasToBeParsed,
  lang,
  theme,
  animationScale,
  albumColumn,
  isShowImageCustomData,
  imageCustomDataWidgetSize,
  isUseMaximizeOrRestoreButton,
}

class AppStateSnapshot{
  final bool isAgreeAgreement;
  final String? sfxPath;
  final String? nikkiasToBeParsed;
  final String lang;
  final int theme;
  final double animationScale;
  // final Game? currentGame;
  // final List<Game> customGame;
  // final Set<UidNote> uidNotes;
  // final Set<GameShortcut> gameShortcuts;
  final int albumColumn;
  final bool isShowImageCustomData;
  final double? imageCustomDataWidgetSize;
  // final String? creationDirectoryPath;
  final bool isUseMaximizeOrRestoreButton;
  // final bool needFileAssociationHelper;

  const AppStateSnapshot({
    required this.isAgreeAgreement,
    required this.sfxPath,
    required this.nikkiasToBeParsed,
    required this.lang,
    required this.theme,
    required this.animationScale,
    required this.albumColumn,
    required this.isShowImageCustomData,
    required this.imageCustomDataWidgetSize,
    // required this.creationDirectoryPath,
    required this.isUseMaximizeOrRestoreButton,
    // required this.needFileAssociationHelper,
  });
}



abstract class AppState{
  static final ValueNotifier<bool> isAgreeAgreement = _buildNotifier<bool>(false);
  static final ValueNotifier<String?> sfxPath = _buildNotifier<String?>(null);
  static final ValueNotifier<String?> nikkiasToBeParsed = _buildNotifier<String?>(null);
  static final ValueNotifier<String> lang = _buildNotifier<String>("zh-CN");
  static final ValueNotifier<int> theme = _buildNotifier<int>(0xFFEEEEEE);
  static final ValueNotifier<double> animationScale = _buildNotifier<double>(1);
  // final ValueNotifier<Game?> currentGame;
  // final ValueNotifier<List<Game>> customGame;
  // final ValueNotifier<Set<UidNote>> uidNotes;
  // final ValueNotifier<Set<GameShortcut>> gameShortcuts;
  static final ValueNotifier<int> albumColumn = _buildNotifier<int>(4);
  static final ValueNotifier<bool> isShowImageCustomData = _buildNotifier<bool>(false);
  static final ValueNotifier<double?> imageCustomDataWidgetSize = _buildNotifier<double?>(null);
  static final ValueNotifier<bool> isUseMaximizeOrRestoreButton = _buildNotifier<bool>(true);

  // const AppState({
  //   // required this.isAgreeAgreement,
  //   required this.sfxPath,
  //   required this.nikkiasToBeParsed,
  //   required this.lang,
  //   required this.theme,
  //   required this.animationScale,
  //   required this.albumColumn,
  //   required this.isShowImageCustomData,
  //   required this.imageCustomDataWidgetSize,
  //   // required this.creationDirectoryPath,
  //   required this.isUseMaximizeOrRestoreButton,
  //   // required this.needFileAssociationHelper,
  // });

  static final List<Function()> _listener = <Function()>[];

  static ValueNotifier<T> _buildNotifier<T>(T value){
    final ValueNotifier<T> notifier = ValueNotifier<T>(value);

    notifier.addListener((){
      for(final Function() listener in _listener){
        listener.call();
      }
    });

    return notifier;
  }

  static void addListener(Function() listener){
    return _listener.add(listener);
  }

  static bool removeListener(Function() listener){
    return _listener.remove(listener);
  }

  static AppStateSnapshot getSnapshot(){
    return AppStateSnapshot(
      isAgreeAgreement: isAgreeAgreement.value,
      sfxPath: sfxPath.value,
      nikkiasToBeParsed: nikkiasToBeParsed.value,
      lang: lang.value,
      theme: theme.value,
      animationScale: animationScale.value,
      albumColumn: albumColumn.value,
      isShowImageCustomData: isShowImageCustomData.value,
      imageCustomDataWidgetSize: imageCustomDataWidgetSize.value,
      isUseMaximizeOrRestoreButton: isUseMaximizeOrRestoreButton.value,
    );
  }
}


// abstract class AppState{
//   /// common
//   static final ValueNotifier<bool> isAgreeAgreement = _createStateValue<bool>(
//     false,
//   ); // 用户是否同意软件使用协议
//   static final ValueNotifier<String?> sfxPath = ValueNotifier<String?>(
//     null,
//   ); // sfx 路径
//   static final ValueNotifier<String?> nikkiasToBeParsed =
//   ValueNotifier<String?>(null); // 需要解析的 nikkias 文件路径
//   /// app common
//   static final ValueNotifier<String> lang = _createStateValue<String>("zh-CN");
//   static final ValueNotifier<int> theme = _createStateValue<int>(
//     0xFFEEEEEE,
//   ); // theme 0xFFEEEEEE
//   static final ValueNotifier<int> animationDuration = _createStateValue<int>(
//     100,
//   );
//
//   /// frame
//   static final ValueNotifier<Game?> currentGame = _createStateValue<Game?>(
//     null,
//   );
//   static final ValueNotifier<List<Game>> customGame =
//   _createStateValue<List<Game>>([]);
//   static final ValueNotifier<Set<UidNote>> uidNotes =
//   _createStateValue<Set<UidNote>>({});
//   static final ValueNotifier<Set<GameShortcut>> gameShortcuts =
//   _createStateValue<Set<GameShortcut>>({});
//
//   /// album
//   static final ValueNotifier<int> albumColumn = _createStateValue<int>(4);
//   static final ValueNotifier<bool> isShowImageCustomData =
//   _createStateValue<bool>(false);
//   static final ValueNotifier<double?> imageCustomDataWidgetSize =
//   _createStateValue<double?>(null);
//
//   /// creation
//   static final ValueNotifier<String?> creationDirectoryPath =
//   _createStateValue<String?>(null);
//
//   /// only windows
//   static final ValueNotifier<bool> isUseMaximizeOrRestoreButton =
//   _createStateValue<bool>(true);
//   static final ValueNotifier<bool> needFileAssociationHelper =
//   _createStateValue<bool>(true);
//
//   static ValueNotifier<T> _createStateValue<T>(T initValue) {
//     final ValueNotifier<T> vn = ValueNotifier<T>(initValue);
//     vn.addListener(() {
//       save();
//     });
//     return vn;
//   }
//
//   static Future<void> read() async {
//     final Path config = (await getAppDataDirectoryPath()) + "config3.json";
//     late final Map jsonMap;
//
//     try {
//       if (!await config.file.exists()) {
//         save();
//         return;
//       }
//
//       jsonMap = jsonDecode(await config.file.readAsString());
//     } catch (e) {
//       writeError("AppState.read", e.toString());
//       return;
//     }
//
//     /// 辅助函数
//     assign<T>(String key, Function(T value) callback) {
//       if (jsonMap.containsKey(key) && jsonMap[key] is T) callback(jsonMap[key]);
//     }
//
//     assign<bool>(
//       "isAgreeAgreement",
//           (bool value) => isAgreeAgreement.value = value,
//     );
//     assign<String>("lang", (String value) => lang.value = value);
//     assign<int>("theme", (int value) => theme.value = value);
//     assign<int>(
//       "animationDuration",
//           (int value) => animationDuration.value = value,
//     );
//     assign<Map>(
//       "currentGame",
//           (Map value) => currentGame.value = Game.from(value),
//     );
//     assign<List>("customGame", (List value) {
//       final List<Game> res = <Game>[];
//       for (dynamic map in value) {
//         final Game? game = Game.from(map);
//         if (game != null) res.add(game);
//       }
//       customGame.value = res;
//       // customGame.value = value.map((gameMap) => Game.fromMap(gameMap)).where((Game? game) => game != null).toList() as List<Game>
//     });
//     assign<List>("uidNotes", (List value) {
//       final Set<UidNote> res = {};
//       for (dynamic map in value) {
//         final UidNote? uidNote = UidNote.from(map);
//         if (uidNote != null) res.add(uidNote);
//       }
//       uidNotes.value = res;
//     });
//     assign<List>("gameShortcuts", (List value) {
//       final Set<GameShortcut> res = {};
//       for (dynamic map in value) {
//         final GameShortcut? shortcut = GameShortcut.from(map);
//         if (shortcut != null) res.add(shortcut);
//       }
//       gameShortcuts.value = res;
//     });
//     assign<int>("albumColumn", (int value) => albumColumn.value = value);
//     assign<bool>(
//       "isShowImageCustomData",
//           (bool value) => isShowImageCustomData.value = value,
//     );
//     assign<double?>(
//       "imageCustomDataWidgetSize",
//           (double? value) => imageCustomDataWidgetSize.value = value,
//     );
//     assign<String?>(
//       "creationDirectoryPath",
//           (String? value) => creationDirectoryPath.value = value,
//     );
//     assign<bool>(
//       "isUseMaximizeOrRestoreButton",
//           (bool value) => isUseMaximizeOrRestoreButton.value = value,
//     );
//     assign<bool>(
//       "needFileAssociationHelper",
//           (bool value) => needFileAssociationHelper.value = value,
//     );
//   }
//
//   static Future<void> save() async {
//     final Path config = (await getAppDataDirectoryPath()) + "config3.json";
//     if (!await config.file.exists()) {
//       config.file.create(recursive: true);
//     }
//
//     final Map jsonMap = {
//       "isAgreeAgreement": isAgreeAgreement.value,
//       "lang": lang.value,
//       "theme": theme.value,
//       "animationDuration": animationDuration.value,
//       "currentGame": Game.toJsonMap(currentGame.value),
//       "customGame": customGame.value
//           .map((Game game) => Game.toJsonMap(game))
//           .toList(),
//       "uidNotes": uidNotes.value
//           .map((UidNote uidNote) => UidNote.toJsonMap(uidNote))
//           .toList(),
//       "gameShortcuts": gameShortcuts.value
//           .map((GameShortcut shortcut) => GameShortcut.toJsonMap(shortcut))
//           .toList(),
//       "albumColumn": albumColumn.value,
//       "isShowImageCustomData": isShowImageCustomData.value,
//       "imageCustomDataWidgetSize": imageCustomDataWidgetSize.value,
//       "creationDirectoryPath": creationDirectoryPath.value,
//       "isUseMaximizeOrRestoreButton": isUseMaximizeOrRestoreButton.value,
//       "needFileAssociationHelper": needFileAssociationHelper.value,
//     };
//
//     try {
//       // 编码并写入配置
//       final String json = jsonEncode(jsonMap);
//       await config.file.writeAsString(json);
//     } catch (e) {
//       writeError("AppState.save", e.toString());
//     }
//   }
//
//   static Future<void> writeError(String form, String error) async {
//     try {
//       final Path log = (await getAppDataDirectoryPath()) + "log.txt";
//       if (!await log.file.exists()) {
//         log.file.create(recursive: true);
//       }
//       log.file.writeAsString(
//         "\n$form : $error",
//         mode: FileMode.append,
//         flush: true,
//       );
//     } on FileSystemException catch (e) {
//       final errno = e.osError?.errorCode;
//       switch (errno) {
//         case 13:
//           print("权限被拒（Android 6+ 没动态申请存储权限，或 iOS 沙盒外路径）");
//           break;
//         case 28:
//           print("磁盘已满");
//           break;
//         case 16 || 32:
//           print("进程被占用");
//           break;
//       }
//     } catch (e) {
//       print("写入失败: $e");
//     }
//   }
// }