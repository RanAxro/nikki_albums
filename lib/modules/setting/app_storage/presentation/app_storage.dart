
import "../domain/fix_app_assets.dart";
import "package:nikki_albums/modules/app_base/model/state.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";


class AppStorage extends StatelessWidget{
  const AppStorage({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        spacing: listSpacing,
        children: [

          /// TODO 清理应用缓存
          // StatefulBuilder(
          //   builder: (BuildContext context, void Function(void Function()) setState){
          //     return Row(
          //       spacing: listSpacing,
          //       children: [
          //         Expanded(
          //           child: AppText.tr("应用缓存"),
          //         ),
          //
          //         AppText("2GB"),
          //
          //         AppButton.smallIcon(
          //           child: AppIcon("refresh"),
          //         ),
          //
          //       ],
          //     );
          //   },
          // ),
          //
          // AppButton.smallText(
          //   isTransparent: false,
          //   child: AppText.tr("清理缓存"),
          // ),


          ValueListenableBuilder(
            valueListenable: AppState.sfxPath,
            builder: (BuildContext context, String? sfxPath, Widget? child){
              return AppButton.smallText(
                isTransparent: false,
                onClick: () async{
                  final bool? value = await showAppDialog<bool?>(
                    context: context,
                    builder: (BuildContext context){
                      return AppConfirmDialog(
                        title: "fix_app_assets",
                        message: context.tr("fix_app_assets_message"),
                      );
                    },
                  );

                  if(value == true){
                    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
                    if(context.mounted){
                      showProgressBar(context: context, valueListenable: progress);
                    }

                    try{
                      await fixAppAssets();
                    }catch(e){
                      if(context.mounted){
                        AppToast.showMessage(
                          context: context,
                          duration: const Duration(hours: 1),
                          message: "${context.tr("fix_app_assets_failed")}\n$e",
                          state: false,
                        );
                      }
                    }finally{
                      progress.value = 1;
                    }
                  }
                },
                child: AppText.tr("fix_app_assets"),
              );
            },
          ),

        ],
      ),
    );
  }
}