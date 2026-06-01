
import "../model/update_info.dart";
import "../domain/launch_official_website.dart";
import "../domain/update_service.dart";

import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";


class UpdateDialog extends StatelessWidget{
  final UpdateInfo info;
  final ValueNotifier<double> downloadProgress = ValueNotifier<double>(0);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  UpdateDialog({super.key, required this.info});

  @override
  Widget build(BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        width: smallDialogMaxWidth,
        child: Column(
          spacing: listSpacing,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText("${context.tr("checkForUpdates")}: ${info.platformVersionString} !", isTranslate: false),

            SmoothPointerScroll(
              builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
                return SingleChildScrollView(
                  controller: controller,
                  physics: physics,
                  child: AppText("${context.tr("updateMessage")}:\n ${info.platformUpdateMessage[AppState.lang.value]}", isTranslate: false),
                );
              },
            ),

            /// 错误提示
            ValueListenableBuilder(
              valueListenable: errorMessage,
              builder: (BuildContext context, String? error, Widget? child) {
                if(error == null) return block0;

                return AppText("downloadFailed");
              },
            ),
            ValueListenableBuilder(
              valueListenable: errorMessage,
              builder: (BuildContext context, String? error, Widget? child) {
                if (error == null) return block0;

                return Text(
                  error,
                  style: TextStyle(
                    color: AppTheme.of(context)!.colorScheme.error.pressedColor,
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: errorMessage,
              builder: (BuildContext context, String? error, Widget? child){
                if(error == null) return block0;

                return SmallButton(
                  width: null,
                  onClick: () {
                    launchOfficialWebsite(context: context);
                  },
                  child: AppText("toOfficialWebsite"),
                );
              },
            ),

            /// 下载按钮
            AppButton.smallText(
              width: null,
              colorRole: ColorRole.highlight,
              isTransparent: false,
              onClick: () async{
                late final Updater updater;
                if(Platform.isWindows){
                  updater = WindowsUpdater();
                }else if(Platform.isMacOS){
                  updater = MacOSUpdater();
                }else{
                  AppToast.showMessage(
                    context: context,
                    message: "The current platform does not have the \"Updater\" class implemented.",
                    state: false,
                  );
                  return;
                }

                showProgressBar(context: context, valueListenable: downloadProgress);

                updater.update(
                  info,
                  onProgress: (double progress){
                    downloadProgress.value = progress;
                  },
                  onError: (String message){
                    errorMessage.value = message;
                  }
                );
              },
              child: AppText("download"),
            ),

            /// 关闭按钮
            AppButton.smallText(
              colorRole: ColorRole.secondary,
              isTransparent: false,
              onClick: (){
                Navigator.of(context).pop();
              },
              child: AppText("close"),
            ),
          ],
        ),
      ),
    );
  }
}