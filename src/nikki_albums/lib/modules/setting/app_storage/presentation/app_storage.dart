
import "package:nikki_albums/modules/parameter_manager/presentation/parameter_manager.dart";

import "../domain/fix_app_assets.dart";
import "package:nikki_albums/modules/parameter_manager/domain/param_box_manager.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/utils/io.dart";
import "package:nikki_albums/utils/native_file_picker.dart";
import "package:nikki_albums/utils/system/system.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:path/path.dart" as p;


class AppStorage extends StatelessWidget{
  const AppStorage({
    super.key,
  });

  Future<void> changeParamBoxPath(BuildContext context, String oldPath, String newPath) async{
    if(p.basename(newPath) != "ParamBox"){
      newPath = p.join(newPath, "ParamBox");
    }
    if(p.equals(oldPath, newPath)){
      return;
    }
    final Directory newDir = Directory(newPath);

    final ValueNotifier<double?> progress = ValueNotifier(null);
    if(context.mounted){
      showProgressBar(
        context: context,
        barrierDismissible: true,
        valueListenable: progress,
      );
    }

    try{
      await copyDirectory(oldPath, newPath);
      AppState.customParamBoxPath.value = newPath;
    }catch(e){
      try{
        if(await newDir.exists()){
          await newDir.delete(recursive: true);
        }
      }catch(e){
        debugPrint(e.toString());
      }
      progress.value = 1;
      progress.dispose();
      if(context.mounted){
        AppToast.showMessage(context: context, message: "${context.tr("app_storage.parameter_manager.copy_data_failed")}\n$e", state: false);
      }
      return;
    }

    try{
      await Directory(oldPath).delete(recursive: true);
    }catch(e){
      debugPrint(e.toString());
    }
    progress.value = 1;
    progress.dispose();
    if(context.mounted){
      AppToast.showMessage(context: context, message: context.tr("app_storage.parameter_manager.change_data_successfully"));
    }
  }

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
                        title: "app_storage.fix_app_assets",
                        message: context.tr("app_storage.fix_app_assets_message"),
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
                          message: "${context.tr("app_storage.fix_app_assets_failed")}\n$e",
                          state: false,
                        );
                      }
                    }finally{
                      progress.value = 1;
                    }
                  }
                },
                child: AppText.tr("app_storage.fix_app_assets"),
              );
            },
          ),

          /// Parameter Manager
          AppDivider(),

          Align(
            alignment: Alignment.centerLeft,
            child: AppText.tr("app_storage.parameter_manager.name"),
          ),

          GlobalParamBoxManagerBuilder(
            builder: (BuildContext context, ParamBoxManager globalManager){
              return Row(
                spacing: listSpacing,
                children: [
                  Expanded(
                    child: AppButton.smallText(
                      toolTip: "app_storage.parameter_manager.open_data_dir",
                      onClick: (){
                        Explorer.openDir(Directory(globalManager.directory.path));
                      },
                      child: Row(
                        spacing: listSpacing,
                        children: [
                          AppText.tr("app_storage.parameter_manager.data_dir"),
                          AppText(globalManager.directory.path, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                  AppDropdown(
                    childrenBuilder: (BuildContext _, MenuController controller){
                      return [
                        AppButton.smallText(
                          onClick: () async{
                            controller.close();
                            await changeParamBoxPath(context, globalManager.directory.path, await GlobalParamBoxManagerBuilder.getDefaultParamBoxPath());
                          },
                          child: AppText.tr("app_storage.parameter_manager.default_data_dir"),
                        ),
                        AppButton.smallText(
                          onClick: () async{
                            controller.close();
                            String? newPath = await NativeFilePicker.getDirectoryPath(
                              dialogTitle: "app_storage.parameter_manager.select_data_dir",
                              lockParentWindow: true,
                            );

                            if(newPath == null){
                              return;
                            }

                            await changeParamBoxPath(context, globalManager.directory.path, newPath);
                          },
                          child: AppText.tr("app_storage.parameter_manager.custom_data_dir"),
                        ),
                      ];
                    },
                    builder: (BuildContext context, MenuController controller, Widget? child){
                      return AppButton.smallIcon(
                        toolTip: "app_storage.parameter_manager.change_data_dir",
                        onClick: controller.isOpen ? controller.close : controller.open,
                        child: AppIcon("folder"),
                      );
                    },
                  ),
                ],
              );
            },
          ),

        ],
      ),
    );
  }
}