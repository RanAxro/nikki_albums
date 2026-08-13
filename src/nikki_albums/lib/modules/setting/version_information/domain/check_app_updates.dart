
import "../model/update_info.dart";
import "../presentation/update_dialog.dart";
import "get_update_info.dart";
import "package:nikki_albums/info.dart";

import "package:flutter/material.dart";

Future<void> checkAppUpdates(BuildContext context) async{
  final UpdateInfo? info = await getUpdateInfo();

  if(info == null || info.platformVersion <= version) return;

  WidgetsBinding.instance.addPostFrameCallback((_){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return UpdateDialog(info: info);
      },
    );
  });
}