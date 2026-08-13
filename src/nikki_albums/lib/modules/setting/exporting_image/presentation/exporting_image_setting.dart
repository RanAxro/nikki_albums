
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/utils/ffmpeg_manager.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:file_picker/file_picker.dart";


class ExportingImageSetting extends StatelessWidget{
  const ExportingImageSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(smallPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.tr("livePhotoExportFormat"),
          block10H,

          AppText.tr("livePhotoExportFormat_description", fontSize: 12),
          block10H,

          ValueListenableBuilder(
            valueListenable: AppState.livePhotoExportFormat,
            builder: (BuildContext context, String format, Widget? child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRadioOption(context, "none", format),
                  _buildRadioOption(context, "apple", format),
                  _buildRadioOption(context, "google", format),
                ],
              );
            },
          ),

          block20H,
          AppDivider(),
          block20H,

          AppText.tr("exporting_image_setting.export_to_a_fixed_dir"),

          block10H,

          ValueListenableBuilder(
            valueListenable: AppState.exportingImageDirs,
            builder: (BuildContext context, Map dirs, Widget? child){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: listSpacing,
                children: [
                  AppButton.smallText(
                    isTransparent: false,
                    onClick: (){
                      showAppDialog(
                        context: context,
                        builder: (BuildContext context){
                          return ExportingImageDirDialog();
                        }
                      );
                    },
                    child: AppText.tr("exporting_image_setting.add"),
                  ),

                  ...dirs.keys.whereType<String>().map((String key){
                    return AppButton.smallText(
                      toolTip: dirs[key],
                      isTranslate: false,
                      isTransparent: false,
                      onClick: () async{
                        final bool? value = await showAppDialog<bool?>(
                          context: context,
                          builder: (BuildContext context){
                            return AppConfirmDialog(
                              message: context.tr("exporting_image_setting.deleteX", args: [key]),
                            );
                          }
                        );

                        if(value == true){
                          dirs.remove(key);
                          AppState.exportingImageDirs.value = {...dirs};
                        }
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: AppText(key),
                          ),

                          AppIcon("delete"),
                        ],
                      ),
                    );
                  }),

                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(BuildContext context, String value, String current) {
    final bool selected = value == current;
    return AppFloatingIndicatorButtonTarget(
      child: IntrinsicWidth(
        child: AppButton.smallText(
          onClick: () async {
            if (Platform.isWindows && value == "apple") {
              final success = await FFmpegManager.checkAndDownload(context);
              if (success) {
                AppState.livePhotoExportFormat.value = value;
              }
            } else {
              AppState.livePhotoExportFormat.value = value;
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: listSpacing,
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 20,
                color: AppTheme.of(context)!.colorScheme.background.onColor,
              ),
              AppText.tr("livePhotoExportFormat_$value"),
            ],
          ),
        ),
      ),
    );
  }
}


class ExportingImageDirDialog extends StatelessWidget{
  ExportingImageDirDialog({
    super.key,
  });

  final ValueNotifier<String?> name = ValueNotifier<String?>(null);
  final ValueNotifier<String?> dirPath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> errorInfo = ValueNotifier<String?>(null);

  void verify(){
    if(name.value == null){
      errorInfo.value = "exporting_image_setting.name_is_empty";
    }else if(AppState.exportingImageDirs.value.containsKey(name.value)){
      errorInfo.value = "exporting_image_setting.name_already_exists";
    }else{
      errorInfo.value = null;
    }
  }

  @override
  Widget build(BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
        child: Column(
          spacing: smallPadding,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///
            Row(
              spacing: smallPadding,
              children: [
                Expanded(
                  child: AppTextFiled(
                    controller: TextEditingController(),
                    labelText: "exporting_image_setting.name",
                    onChanged: (String input){
                      name.value = input;
                      verify();
                    },
                  ),
                ),
              ],
            ),

            ValueListenableBuilder(
              valueListenable: errorInfo,
              builder: (BuildContext context, String? info, Widget? child){
                return info == null ? block0 : Text(context.tr(info),
                  style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor),
                );
              },
            ),

            ValueListenableBuilder(
              valueListenable: dirPath,
              builder: (BuildContext context, String? path, Widget? child){
                return AppButton.smallText(
                  height: mediumButtonSize,
                  isTransparent: false,
                  onClick: () async{
                    final String? selected = await FilePicker.platform.getDirectoryPath(
                      dialogTitle: context.tr("exporting_image_setting.select_dir"),
                    );

                    if(selected != null){
                      dirPath.value = selected;
                    }
                  },
                  child: path == null ? AppText.tr("exporting_image_setting.select_dir") : AppText(path),
                );
              },
            ),

            block20H,

            /// cancel
            AppButton.smallText(
              colorRole: ColorRole.background,
              isTransparent: false,
              onClick: (){
                Navigator.of(context).pop();
              },
              child: AppText.tr("cancel"),
            ),

            /// save
            MultiValueListenableBuilder(
              listenables: [name, dirPath],
              builder: (BuildContext context, Widget? child){
                return AppButton.smallText(
                  colorRole: ColorRole.highlight,
                  isTransparent: false,
                  onClick: (){
                    verify();

                    if(errorInfo.value == null){
                      AppState.exportingImageDirs.value = {
                        name.value: dirPath.value,
                        ...AppState.exportingImageDirs.value,
                      };
                      Navigator.of(context).pop();
                    }
                  },
                  usable: name.value != null && dirPath.value != null,
                  child: AppText.tr("save"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}