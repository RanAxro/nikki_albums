
import "package:file_picker/file_picker.dart";
import "package:nikki_albums/modules/app_base/domain/lang_asset_loader.dart";
import "package:nikki_albums/modules/hot_update/domain/check_app_hot_updates.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";
import "dart:io";


class HotUpdateDebug extends StatelessWidget{
  const HotUpdateDebug({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        children: [

          AppButton.smallText(
            onClick: () async{
              print("running...");
              await checkAppHotUpdates();
              print("ok");
            },
            isTranslate: false,
            child: AppText("check hot update"),
          ),

          AppButton.smallText(
            onClick: () async{
              final FilePickerResult? result = await FilePicker.platform.pickFiles();
              if(result == null) return;

              final String? path = result.paths.firstOrNull;
              if(path == null) return;

              LangFileAesUtil.encryptFile(path, "$path.enc");
              Explorer.openFile(File("$path.enc"));
              print("encrypted in $path.enc");
            },
            isTranslate: false,
            child: AppText("encrypt a file"),
          ),

        ].map((Widget widget) => AppFloatingIndicatorButtonTarget(child: widget)).toList(),
      ),
    );
  }
}