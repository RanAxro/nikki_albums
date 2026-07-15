
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";

import "../presentation/param_import_panel.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";



Future<(String?, CameraParams)?> showCameraParamsImportInputPanel({required BuildContext context}) async{
  final Nuan5DatabaseReaderV1? reader = await Nuan5Data.init();

  if(context.mounted){
    return showAppDialog<(String?, CameraParams)?>(
      context: context,
      builder: (BuildContext context){
        return AppDialog(
          maxWidth: 700,
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

void goToCameraParamsImportAlbum(){
  contentController.index = 1;
}