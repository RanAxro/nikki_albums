import "frame.dart";

import "package:nikkialbums/info.dart";
import "package:nikkialbums/modules/app_base/state.dart";
import "package:nikkialbums/widgets/app/component.dart";
import "package:nikkialbums/widgets/common/component.dart";
import "package:nikkialbums/utils/system/system.dart";
import "package:nikkialbums/utils/path.dart";

import "dart:io";
import "package:flutter/material.dart";

import "package:file_picker/file_picker.dart";
import "package:easy_localization/easy_localization.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";



class AndroidFrame extends StatelessWidget{
  const AndroidFrame({super.key});

  @override
  Widget build(BuildContext context){

    // requestAllFilesAccess();

    return ColoredBox(
      color: AppTheme.of(context)!.colorScheme.background.color,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: androidTitleBarHeight,
              child: AndroidTitleBar(),
            ),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  // te();
                },
                child: Container(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class AndroidTitleBar extends StatelessWidget{
  const AndroidTitleBar({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      height: topBarHeight,
      color: AppTheme.of(context)!.colorScheme.secondary.color,
      child: Row(
        children: [
          const AccountButton(),
        ],
      ),
    );
  }
}