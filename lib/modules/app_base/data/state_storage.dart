
import "dart:convert";
import "dart:io";

import "../domain/work_path_provider.dart";
import "../model/state.dart";

import "package:path/path.dart" as p;

abstract class AppStateStorage{


  // Future<AppStateSnapshot> load() async{
  //   final String appConfigFilePath = await getAppConfigFilePath();
  //
  //   final File appConfigFile = File(appConfigFilePath);
  //
  //   if(await appConfigFile.exists()){
  //
  //   }else{
  //     // return
  //   }
  // }

  Future<void> save(AppStateSnapshot state) async{

  }
}


abstract class AppStateSerDe{
  String serialize(AppStateSnapshot source){
    return jsonEncode({
      "isAgreeAgreement": source.isAgreeAgreement,
      "lang": source.lang,
      "theme": source.theme,
      "animationScale": source.animationScale,
      // "currentGame": source.currentGame,
      // "customGame": source.customGame,
      // "uidNotes": source.uidNotes,
      // "gameShortcuts": source.gameShortcuts,
      "albumColumn": source.albumColumn,
      "isShowImageCustomData": source.isShowImageCustomData,
      "imageCustomDataWidgetSize": source.imageCustomDataWidgetSize,
      "isUseMaximizeOrRestoreButton": source.isUseMaximizeOrRestoreButton,
    });
  }

  // AppStateSnapshot deserialize(String source){
  //
  // }
}

// class AppStateSnapshot{
//   final bool isAgreeAgreement;
//   final String? sfxPath;
//   final String? nikkiasToBeParsed;
//   final String lang;
//   final int theme;
//   final double animationScale;
//   // final Game? currentGame;
//   // final List<Game> customGame;
//   // final Set<UidNote> uidNotes;
//   // final Set<GameShortcut> gameShortcuts;
//   final int albumColumn;
//   final bool isShowImageCustomData;
//   final double? imageCustomDataWidgetSize;
//   // final String? creationDirectoryPath;
//   final bool isUseMaximizeOrRestoreButton;
//   // final bool needFileAssociationHelper;
//
//   const AppStateSnapshot({
//     required this.isAgreeAgreement,
//     required this.sfxPath,
//     required this.nikkiasToBeParsed,
//     required this.lang,
//     required this.theme,
//     required this.animationScale,
//     required this.albumColumn,
//     required this.isShowImageCustomData,
//     required this.imageCustomDataWidgetSize,
//     // required this.creationDirectoryPath,
//     required this.isUseMaximizeOrRestoreButton,
//     // required this.needFileAssociationHelper,
//   });
// }