
import "package:file_picker/file_picker.dart";
import "package:nikki_albums/modules/nikkias/nikkias.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";

class NikkiasSetting extends StatelessWidget{
  const NikkiasSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: smallCardMaxWidth,
        child: Column(
          spacing: listSpacing,
          children: [
            AppButton.smallText(
              height: mediumButtonSize,
              isTransparent: false,
              onClick: () async{
                final FilePickerResult? location = await FilePicker.platform.pickFiles(
                  dialogTitle: context.tr("selectNikkiasFile"),
                  lockParentWindow: true,
                  type: FileType.custom,
                  allowedExtensions: [nikkiasExtension],
                  allowMultiple: false,
                );

                if(location != null){
                  final String? pathStr = location.paths.firstOrNull;
                  if(pathStr == null) return;

                  if(context.mounted){
                    parseNikkiasFile(context, File(pathStr));
                  }
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: listSpacing,
                children: [
                  Icon(Icons.file_open_outlined, size: 20, color: AppColorScheme.of(context).background.onByState(ColorState.of(context))),
                  AppText("open_nikkias_file"),
                ],
              ),
            ),

            block20H,
            AppText("drag_nikkias_file_here"),
            block20H,

            if(Platform.isWindows)
              AppButton.smallText(
                height: mediumButtonSize,
                isTransparent: false,
                onClick: () async{
                  if(Platform.isWindows){
                    await Nikkias.registerFileAssociationWindows();

                    if(context.mounted){
                      AppToast.showMessage(
                        context: context,
                        message: context.tr("association_successful"),
                      );
                    }
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: listSpacing,
                  children: [
                    Icon(Icons.attach_file_outlined, size: 20, color: AppColorScheme.of(context).background.onByState(ColorState.of(context))),
                    AppText("register_nikkias_file_association"),
                  ],
                ),
              ),

            if(Platform.isWindows)
              AppButton.smallText(
                height: mediumButtonSize,
                isTransparent: false,
                onClick: () async{
                  if(Platform.isWindows){
                    await Nikkias.unRegisterFileAssociationWindows();

                    if(context.mounted){
                      AppToast.showMessage(
                        context: context,
                        message: context.tr("association_cancelled_successfully"),
                      );
                    }
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: listSpacing,
                  children: [
                    Icon(Icons.clear, size: 20, color: AppColorScheme.of(context).background.onByState(ColorState.of(context))),
                    AppText("unregister_nikkias_file_association"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}