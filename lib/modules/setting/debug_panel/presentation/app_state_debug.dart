
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";



class AppStateDebug extends StatelessWidget{
  const AppStateDebug({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: AppState.isAgreeAgreement,
            builder: (BuildContext context, bool isAgreeAgreement, Widget? child){
              return AppSwitchButton(
                value: isAgreeAgreement,
                onChanged: (value){
                  AppState.isAgreeAgreement.value = value;
                },
                child: AppText("isAgreeAgreement", isTranslate: false),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.isInitialStartup,
            builder: (BuildContext context, bool isInitialStartup, Widget? child){
              return AppSwitchButton(
                value: isInitialStartup,
                onChanged: (value){
                  AppState.isInitialStartup.value = value;
                },
                child: AppText("isInitialStartup", isTranslate: false),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.sfxPath,
            builder: (BuildContext context, String? sfxPath, Widget? child){
              return AppButton.smallText(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("sfxPath", isTranslate: false),
                    ),
                    AppText(sfxPath.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.nikkiasToBeParsed,
            builder: (BuildContext context, String? nikkiasToBeParsed, Widget? child){
              return AppButton.smallText(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("nikkiasToBeParsed", isTranslate: false),
                    ),
                    AppText(nikkiasToBeParsed.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.lang,
            builder: (BuildContext context, String lang, Widget? child){
              return AppButton.smallText(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("lang", isTranslate: false),
                    ),
                    AppText(lang.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.theme,
            builder: (BuildContext context, int theme, Widget? child){
              return AppButton.smallText(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("theme", isTranslate: false),
                    ),
                    AppText(theme.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.isThemeFollowSystem,
            builder: (BuildContext context, bool isThemeFollowSystem, Widget? child){
              return AppSwitchButton(
                value: isThemeFollowSystem,
                onChanged: (value){
                  AppState.isThemeFollowSystem.value = value;
                },
                child: AppText("isThemeFollowSystem", isTranslate: false),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.animationDuration,
            builder: (BuildContext context, int animationDuration, Widget? child){
              return AppButton.smallText(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("animationDuration", isTranslate: false),
                    ),
                    AppText(animationDuration.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.albumColumn,
            builder: (BuildContext context, int albumColumn, Widget? child){
              return AppButton.smallText(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("albumColumn", isTranslate: false),
                    ),
                    AppText(albumColumn.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.isShowImageCustomData,
            builder: (BuildContext context, bool isShowImageCustomData, Widget? child){
              return AppSwitchButton(
                value: isShowImageCustomData,
                onChanged: (value){
                  AppState.isShowImageCustomData.value = value;
                },
                child: AppText("isShowImageCustomData", isTranslate: false),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.imageCustomDataWidgetSize,
            builder: (BuildContext context, double? imageCustomDataWidgetSize, Widget? child){
              return AppButton.smallText(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("imageCustomDataWidgetSize", isTranslate: false),
                    ),
                    AppText(imageCustomDataWidgetSize.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.creationDirectoryPath,
            builder: (BuildContext context, String? creationDirectoryPath, Widget? child){
              return AppButton.smallText(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("creationDirectoryPath", isTranslate: false),
                    ),
                    AppText(creationDirectoryPath.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.isUseMaximizeOrRestoreButton,
            builder: (BuildContext context, bool isUseMaximizeOrRestoreButton, Widget? child){
              return AppSwitchButton(
                value: isUseMaximizeOrRestoreButton,
                onChanged: (value){
                  AppState.isUseMaximizeOrRestoreButton.value = value;
                },
                child: AppText("isUseMaximizeOrRestoreButton", isTranslate: false),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.needFileAssociationHelper,
            builder: (BuildContext context, bool needFileAssociationHelper, Widget? child){
              return AppSwitchButton(
                value: needFileAssociationHelper,
                onChanged: (value){
                  AppState.needFileAssociationHelper.value = value;
                },
                child: AppText("needFileAssociationHelper", isTranslate: false),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.livePhotoExportFormat,
            builder: (BuildContext context, String livePhotoExportFormat, Widget? child){
              return AppButton.smallText(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("livePhotoExportFormat", isTranslate: false),
                    ),
                    AppText(livePhotoExportFormat.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

        ].map((Widget widget) => AppFloatingIndicatorButtonTarget(child: widget)).toList(),
      ),
    );
  }
}