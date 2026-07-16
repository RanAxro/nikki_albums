
import "code_parser.dart";
import "../presentation/param_import_panel.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/modules/nuan5_params/domain/equality.dart";
import "package:nikki_albums/src/rust/nuan5_params/decode.dart";
import "package:nikki_albums/modules/game/game.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/info.dart";

import "package:flutter/material.dart";

import "package:path/path.dart" as p;



Future<(String?, CameraParams)?> showCameraParamsImportInputPanel({required BuildContext context}) async{
  final Nuan5DatabaseReaderV1? reader = await Nuan5Data.init();

  if(context.mounted){
    return showAppDialog<(String?, CameraParams)?>(
      context: context,
      builder: (BuildContext context){
        return AppDialog(
          maxWidth: 600,
          useIntrinsicHeight: false,
          child: CameraParamsImportInputPanel(
            onCancel: Navigator.of(context).pop,
            onFinish: (String? code, CameraParams cameraParams){
              Navigator.of(context).pop((code, cameraParams));
            },
            reader: reader,
          ),
        );
      }
    );
  }else{
    return null;
  }
}

void goToCameraParamsImportAlbumNikkiPhotos(){
  contentController.index = 1;
  AppState.currentGame.value?.selectedAlbum = AlbumType.NikkiPhotos_HighQuality;
}

void goToCameraParamsImportAlbumClockInPhoto(){
  contentController.index = 1;
  AppState.currentGame.value?.selectedAlbum = AlbumType.ClockInPhoto;
}

Future<String?> showClothDiyShareCodeImportHistoryPanel({required BuildContext context}) async{
  final Nuan5DatabaseReaderV1? reader = await Nuan5Data.init();

  if(context.mounted){
    return showAppDialog<String?>(
      context: context,
      builder: (BuildContext context){
        return AppDialog(
          maxWidth: 900,
          useIntrinsicHeight: false,
          child: ClothDiyShareCodeImportHistoryPanel(
            onCancel: Navigator.of(context).pop,
            onFinish: Navigator.of(context).pop,
            reader: reader,
          ),
        );
      }
    );
  }

  return null;
}

Future<String?> tryGetClothDiyShareCode({required ClothDiyParams params, required Game game, required String uid}) async{
  final String historyPath = p.join(game.installPath.path, "X6Game", "Saved", "ShareCode", "${uid}diy_history_sharecode.json");

  final List<String> shareCodeList = [];
  try{
    final ClothDiyParam? clothDiyParam = await clothDiyDeFile(paramType: ClothDiyParamType.diyHistoryShareCode, path: historyPath);
    clothDiyParam?.whenOrNull(
      diyHistoryShareCode: (List<DiyHistoryShareCodeParams> box){
        shareCodeList.addAll(box.map((DiyHistoryShareCodeParams item) => item.shareCode));
      },
    );
  }catch(e){
    return null;
  }

  for(final String shareCode in shareCodeList){
    final ClothDiyParams? currentParams = await tryDeClothDiyShareCode(shareCode);

    if(currentParams != null && params.equals(currentParams)){
      return shareCode;
    }
  }

  return null;
}

void goToClothDiyShareCodeImportAlbumDIY(){
  contentController.index = 1;
  AppState.currentGame.value?.selectedAlbum = AlbumType.DIY;
}

Future<(String, String?)?> showClothDiyShareCodeImportQrCodePanel({required BuildContext context}) async{
  return showAppDialog<(String, String?)?>(
    context: context,
    builder: (BuildContext context){
      return AppDialog(
        title: "",
        isTranslate: false,
        maxWidth: 900,
        useIntrinsicHeight: false,
        child: ClothDiyShareCodeImportQrCodePanel(
          onFinish: (String shareCode, String? path){
            Navigator.of(context).pop((shareCode, path));
          },
        ),
      );
    },
  );
}