
import "../domain/param_item_edit_controller.dart";
import "../model/param_item.dart";
import "../model/param_type.dart";
import "../domain/camera_params_edit_controller.dart";
import "../presentation/camera_params_edit_panel.dart";
import "../presentation/cloth_diy_params_panel.dart";
import "../presentation/rich_building_params_panel.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/building_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/utils/clipboard.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:typed_data";

import "package:easy_localization/easy_localization.dart";
import "package:path/path.dart" as p;
import "package:desktop_drop/desktop_drop.dart";
import "package:file_picker/file_picker.dart";
import "package:dio/dio.dart";


class ParamItemEditPanel extends StatefulWidget{
  final ParamItemEditController controller;
  final void Function()? onCancel;
  final void Function(ParamItemCreation)? onFinished;

  const ParamItemEditPanel({
    super.key,
    required this.controller,
    this.onCancel,
    this.onFinished,
  });

  @override
  State<ParamItemEditPanel> createState() => _ParamItemEditPanelState();
}

class _ParamItemEditPanelState extends State<ParamItemEditPanel>{
  late final ParamItemEditController controller;
  Nuan5DatabaseReaderV1? reader;

  Future<void> initReader() async{
    controller = widget.controller;
    reader = await Nuan5Data.init();
    setState((){

    });
  }

  Future<String?> downloadImage(String url) async{
    try{
      final String savePath = p.join((await getTempPath()).path, "NetworkImage");
      final Dio dio = Dio();
      final Response response = await dio.download(url, savePath);
      if(response.statusCode == 200){
        return savePath;
      }else{
        return null;
      }
    }catch(e){
      return null;
    }
  }

  @override
  void initState(){
    super.initState();
    initReader();
  }

  @override
  void dispose(){

    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Row(
      spacing: listSpacing,
      children: [
        SizedBox(
          width: 600,
          child: Column(
            spacing: listSpacing,
            children: [
              Row(
                spacing: listSpacing,
                children: [
                  Expanded(
                    child: AppTextFiled(
                      controller: controller.nameTextController,
                      labelText: "parameter_manager.name",
                    ),
                  ),
                  AppButton.smallIcon(
                    toolTip: "parameter_manager.paste",
                    onClick: () async{
                      final String? text = await readTextFromClipboard();
                      if(text != null){
                        controller.nameTextController.text = text;
                      }
                    },
                    child: Icon(Icons.paste),
                  ),
                ],
              ),

              AppFloatingIndicatorButtonGroup(
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextFiled(
                        controller: controller.codeTextController,
                        labelText: "parameter_manager.param_or_code",
                      ),
                    ),
                    AppFloatingIndicatorButtonTarget(
                      child: AppButton.smallIcon(
                        toolTip: "parameter_manager.copy",
                        onClick: () async{
                          final String text = controller.codeTextController.text;

                          try{
                            await copyTextToClipboard(text);
                            if(context.mounted){
                              AppToast.showMessage(context: context, message: context.tr("parameter_manager.copy_successful"));
                            }
                          }catch(e){
                            if(context.mounted){
                              AppToast.showMessage(context: context, message: "${context.tr("parameter_manager.copy_failed")}\n$e", state: false);
                            }
                          }
                        },
                        child: Icon(Icons.copy),
                      ),
                    ),
                    AppFloatingIndicatorButtonTarget(
                      child: AppButton.smallIcon(
                        toolTip: "parameter_manager.paste",
                        onClick: () async{
                          final String? text = await readTextFromClipboard();
                          if(text != null){
                            controller.codeTextController.text = text;
                          }
                        },
                        child: Icon(Icons.paste),
                      ),
                    ),
                    AppFloatingIndicatorButtonTarget(
                      child: AppButton.smallIcon(
                        toolTip: "parameter_manager.clear",
                        onClick: () async{
                          controller.codeTextController.text = "";
                        },
                        child: AppIcon("cross"),
                      ),
                    ),
                  ],
                ),
              ),

              ListenableBuilder(
                listenable: controller,
                builder: (BuildContext context, Widget? child){
                  return AppRadioStack(
                    selectedIndex: [
                      ParamType.camera,
                      ParamType.cloth,
                      ParamType.home,
                    ].indexOf(controller.paramType),
                    children: [
                      AppButton.smallText(
                        onClick: (){
                          controller.setParamType(ParamType.camera);
                        },
                        child: AppText.tr("parameter_manager.camera"),
                      ),
                      AppButton.smallText(
                        onClick: (){
                          controller.setParamType(ParamType.cloth);
                        },
                        child: AppText.tr("parameter_manager.cloth"),
                      ),
                      AppButton.smallText(
                        onClick: (){
                          controller.setParamType(ParamType.home);
                        },
                        child: AppText.tr("parameter_manager.home"),
                      ),
                    ],
                  );
                },
              ),

              /// TODO 标签功能
              // AppText.tr("parameter_manager.tag"),

              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: bigPadding),
                      child: AppText.tr("parameter_manager.cover"),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        height: 300,
                        child: ValueListenableBuilder(
                          valueListenable: controller.cover,
                          builder: (BuildContext context, ParamItemCover? cover, Widget? child){
                            if(cover == null){
                              return ImageImportListener(
                                onSelected: (ParamItemCover newCover){
                                  controller.cover.value = newCover;
                                },
                              );
                            }

                            return IntrinsicWidth(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Builder(
                                      builder: (BuildContext context){
                                        if(cover is NativeParamItemCover){
                                          return Image.file(File(cover.path));
                                        }
                                        if(cover is NetworkParamItemCover){
                                          return Image.network(cover.path);
                                        }
                                        return block0;
                                      },
                                    ),
                                  ),

                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: AppButton.smallIcon(
                                      borderRadius: 10,
                                      width: 20,
                                      height: 20,
                                      isTransparent: false,
                                      colorRole: ColorRole.highlight,
                                      onClick: (){
                                        controller.cover.value = null;
                                      },
                                      child: AppIcon("cross"),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: AppButton.smallText(
                      isTransparent: false,
                      onClick: (){
                        widget.onCancel?.call();
                      },
                      child: AppText.tr("parameter_manager.cancel"),
                    ),
                  ),
                  Expanded(
                    child: AppButton.smallText(
                      colorRole: ColorRole.highlight,
                      isTransparent: false,
                      onClick: () async{
                        widget.onFinished?.call(ParamItemCreation(
                          type: controller.paramType,
                          value: controller.codeTextController.text,
                          title: controller.nameTextController.text == "" ? null : controller.nameTextController.text,
                          cover: controller.cover.value,
                        ));
                      },
                      child: AppText.tr("parameter_manager.save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),


        Expanded(
          child: ListenableBuilder(
            listenable: controller,
            builder: (BuildContext context, Widget? child){
              final dynamic param = controller.param;

              if(param is CameraParams){
                return CameraParamsEditPanel(
                  controller: CameraParamsEditController(
                    cameraParams: param,
                    allowEdit: false,
                  ),
                  reader: reader,
                );
              }

              if(param is ClothDiyParams){
                return ClothDiyParamsPanel(
                  shareCode: controller.code,
                  clothDiyParams: param,
                  reader: reader,
                );
              }

              if(param is RichBuildingParams){
                return RichBuildingParamsPanel(
                  shareCode: controller.code,
                  richBuildingParams: param,
                  reader: reader,
                );
              }

              return Center(
                child: AppText.tr("parameter_manager.invalid_param"),
              );

            },
          ),
        ),
      ],
    );
  }
}



class ImageImportListener extends StatelessWidget{
  final void Function(ParamItemCover cover) onSelected;

  ImageImportListener({
    super.key,
    required this.onSelected,
  });

  static const List<String> allowExtension = [".png", ".jpg", ".jpeg", ".webp"];

  final ValueNotifier<bool> isDrag = ValueNotifier<bool>(false);

  Future<void> _pickFiles(BuildContext context) async {
    final FilePickerResult? location = await FilePicker.platform.pickFiles(
      dialogTitle: context.tr("parameter_manager.select_cover"),
      lockParentWindow: true,
      type: FileType.image,
      allowMultiple: false,
    );

    if(location != null){
      final String? path = location.paths.firstOrNull;
      if(path != null && allowExtension.contains(p.extension(path))){
        onSelected.call(NativeParamItemCover(path: path, isCache: false));
      }
    }
  }

  void _dragDone(BuildContext context, DropDoneDetails details){
    final String? path = details.files.firstOrNull?.path;

    if(path != null && allowExtension.contains(p.extension(path))){
      onSelected.call(NativeParamItemCover(path: path, isCache: false));
    }
  }

  Future<void> _paste(BuildContext context) async{
    final String tempPath = p.join((await getTempPath()).path, "ClipboardImage");
    final Uint8List? imageBytes = await readImageFromClipboard(savePath: tempPath);

    if(imageBytes == null){
      final String? path = (await readFilesFromClipboard()).firstOrNull?.path;

      if(path != null && allowExtension.contains(p.extension(path))){
        onSelected.call(NativeParamItemCover(path: path, isCache: false));
      }
    }else{
      onSelected.call(NativeParamItemCover(path: tempPath, isCache: true));
    }
  }

  @override
  Widget build(BuildContext context){
    final Widget ui = ValueListenableBuilder(
      valueListenable: isDrag,
      builder: (BuildContext context, bool isDrag, Widget? child){
        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDrag ? AppTheme.of(context)!.colorScheme.background.enabledColor : AppTheme.of(context)!.colorScheme.background.disabledColor,
            border: Border.all(
              color: isDrag ? AppTheme.of(context)!.colorScheme.secondary.hoveredColor : AppTheme.of(context)!.colorScheme.secondary.pressedColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          child: Column(
            spacing: bigPadding,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.tr("left-clickToSelectImage"),
              AppText.tr("dragImageHere"),
              AppText.tr("right-clickToPasteImage"),
            ],
          ),
        );
      },
    );

    final Widget processor = DropTarget(
      onDragEntered: (DropEventDetails details){
        isDrag.value = true;
      },
      onDragExited: (DropEventDetails details){
        isDrag.value = false;
      },
      onDragDone: (DropDoneDetails details){
        _dragDone(context, details);
      },
      child: GestureDetector(
        onTap: (){
          _pickFiles(context);
        },
        onSecondaryTap: () async{
          _paste(context);
        },
        child: ui,
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          bigPadding,
          0,
          bigPadding,
          bigPadding,
        ),
        child: processor,
      ),
    );
  }
}



