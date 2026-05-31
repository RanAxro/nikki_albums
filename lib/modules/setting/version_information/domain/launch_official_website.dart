import "package:nikki_albums/info.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

import "package:url_launcher/url_launcher.dart";

Future<void> launchOfficialWebsite({BuildContext? context}) async{
  final uri = Uri.parse("https://$officialWebsite");

  late bool launchState;

  try{
    if(await canLaunchUrl(uri)){
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      launchState = true;
    }else{
      launchState = false;
    }
  }catch(e){
    launchState = false;
  }

  if(launchState) return;

  final BuildContext? context = frameKey.currentContext;
  if(context != null && context.mounted){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
          child: Container(
            padding: const EdgeInsets.all(smallPadding),
            width: smallDialogMaxWidth,
            child: SelectableText(
              officialWebsite,
              style: TextStyle(
                color: AppTheme.of(context)!.colorScheme.background.onColor,
              ),
            ),
          ),
        );
      },
    );
  }
}