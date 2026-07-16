
import "../domain/code_parser.dart";
import "../domain/param_box_manager.dart";
import "../domain/param_import.dart";
import "../domain/param_item_edit_controller.dart";
import "../model/param_box.dart";
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
import "package:nikki_albums/utils/color/utils.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:typed_data";

import "package:easy_localization/easy_localization.dart";
import "package:path/path.dart" as p;
import "package:desktop_drop/desktop_drop.dart";
import "package:file_picker/file_picker.dart";


class ParamItemEditPanel extends StatefulWidget{
  final ParamBoxManager manager;
  final ParamItemEditController? controller;
  final void Function()? onCancel;
  final void Function(ParamItemCreation)? onFinish;
  final List<String> initTag;
  final bool createMode;

  const ParamItemEditPanel({
    super.key,
    required this.manager,
    this.controller,
    this.onCancel,
    this.onFinish,
    this.initTag = const [],
    this.createMode = true,
  });

  @override
  State<ParamItemEditPanel> createState() => _ParamItemEditPanelState();
}

class _ParamItemEditPanelState extends State<ParamItemEditPanel>{
  late final ParamItemEditController controller;
  late final ManualValueNotifier<List<String>> tagList;
  Nuan5DatabaseReaderV1? reader;

  Future<void> initReader() async{
    reader = await Nuan5Data.init();
    setState((){

    });
  }

  @override
  void initState(){
    super.initState();
    controller = widget.controller ?? ParamItemEditController();
    tagList = ManualValueNotifier(List.of(widget.initTag));
    initReader();
  }

  @override
  void dispose(){
    if(widget.controller == null){
      controller.dispose();
    }
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
                      child: IgnorePointer(
                        ignoring: !widget.createMode,
                        child: AppTextFiled(
                          controller: controller.codeTextController,
                          labelText: "parameter_manager.param_or_code",
                        ),
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
                    if(widget.createMode)
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
                    if(widget.createMode)
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

              IgnorePointer(
                ignoring: !widget.createMode,
                child: ListenableBuilder(
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
              ),

              /// Tag
              ListenableBuilder(
                listenable: controller,
                builder: (BuildContext context, Widget? child){
                  return ManualValueNotifierBuilder(
                    valueListenable: tagList,
                    builder: (BuildContext context, List<String> allTag, Widget? child){
                      final List<Widget> tagChildren = [];

                      for(final String uuid in allTag){
                        final ParamTag? tag = widget.manager.getTag(uuid);
                        if(tag == null){
                          continue;
                        }

                        tagChildren.add(Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                          constraints: BoxConstraints(
                            minWidth: smallButtonSize,
                          ),
                          height: smallButtonContentSize + smallPadding,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.5 * (smallButtonContentSize + smallPadding)),
                            color: Color(tag.color),
                          ),
                          child: AppText(tag.name, color: getContrastColor(Color(tag.color))),
                        ));
                      }

                      return AppButton.smallText(
                        isTransparent: false,
                        height: mediumButtonSize,
                        onClick: (){
                          showAppDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AppDialog(
                                maxWidth: 400,
                                maxHeight: 600,
                                useIntrinsicHeight: false,
                                child: TagSelector(
                                  manager: widget.manager,
                                  initTagList: List.of(tagList.value),
                                  onAdd: (){
                                    showAppDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AppDialog(
                                          maxWidth: 400,
                                          maxHeight: 240,
                                          useIntrinsicHeight: false,
                                          child: TagCreator(
                                            onCancel: Navigator.of(context).pop,
                                            onFinish: (String name, int color) async{
                                              Navigator.of(context).pop();

                                              widget.manager.createTag(name, color, null);
                                              await widget.manager.save();
                                            },
                                          ),
                                        );
                                      }
                                    );
                                  },
                                  onFinish: (List<String> selectedTag){
                                    Navigator.of(context).pop();
                                    tagList.value = selectedTag;
                                    tagList.notify();
                                  },
                                ),
                              );
                            }
                          );
                        },
                        child: Row(
                          spacing: listSpacing,
                          children: [
                            AppText.tr("parameter_manager.tag"),

                            ...tagChildren,
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

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
                                      child: AppIcon("cross", height: 16),
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
                        if(isValidParam(controller.param)){
                          widget.onFinish?.call(ParamItemCreation(
                            type: controller.paramType,
                            value: controller.codeTextController.text,
                            title: controller.nameTextController.text == "" ? null : controller.nameTextController.text,
                            tag: tagList.value,
                            cover: controller.cover.value,
                          ));
                        }else{
                          AppToast.showMessage(context: context, message: context.tr("parameter_manager.invalid_param"), state: false);
                        }
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: bigPadding,
                  children: [
                    AppText.tr("parameter_manager.invalid_param"),

                    if(widget.createMode && controller.paramType == ParamType.camera)
                      ...[
                        IntrinsicWidth(
                          child: AppButton.smallText(
                            colorRole: ColorRole.highlight,
                            isTransparent: false,
                            onClick: () async{
                              final (String?, CameraParams)? result = await showCameraParamsImportInputPanel(context: context);

                              if(result?.$1 != null){
                                controller.codeTextController.text = result!.$1!;
                              }
                            },
                            child: AppText.tr("parameter_manager.camera_params_import_input"),
                          ),
                        ),
                        IntrinsicWidth(
                          child: AppButton.smallText(
                            colorRole: ColorRole.highlight,
                            isTransparent: false,
                            onClick: (){
                              Navigator.of(context).pop();
                              goToCameraParamsImportAlbumNikkiPhotos();
                            },
                            child: AppText.tr("parameter_manager.camera_params_import_album_nikki_photos"),
                          ),
                        ),
                        IntrinsicWidth(
                          child: AppButton.smallText(
                            colorRole: ColorRole.highlight,
                            isTransparent: false,
                            onClick: (){
                              Navigator.of(context).pop();
                              goToCameraParamsImportAlbumClockInPhoto();
                            },
                            child: AppText.tr("parameter_manager.camera_params_import_album_clock_in_photo"),
                          ),
                        ),
                      ],

                    if(widget.createMode && controller.paramType == ParamType.cloth)
                      ...[
                        IntrinsicWidth(
                          child: AppButton.smallText(
                            colorRole: ColorRole.highlight,
                            isTransparent: false,
                            onClick: () async{
                              final String? result = await showClothDiyShareCodeImportHistoryPanel(context: context);

                              if(result != null){
                                controller.codeTextController.text = result;
                              }
                            },
                            child: AppText.tr("parameter_manager.cloth_diy_share_code_import_history"),
                          ),
                        ),
                        IntrinsicWidth(
                          child: AppButton.smallText(
                            colorRole: ColorRole.highlight,
                            isTransparent: false,
                            onClick: (){
                              Navigator.of(context).pop();
                              goToClothDiyShareCodeImportAlbumDIY();
                            },
                            child: AppText.tr("parameter_manager.cloth_diy_share_code_import_album_diy"),
                          ),
                        ),
                        IntrinsicWidth(
                          child: AppButton.smallText(
                            colorRole: ColorRole.highlight,
                            isTransparent: false,
                            onClick: () async{
                              final (String, String?)? result = await showClothDiyShareCodeImportQrCodePanel(context: context);

                              if(result != null){
                                controller.codeTextController.text = result.$1;
                                if(result.$2 != null){
                                  controller.cover.value = NativeParamItemCover(path: result.$2!, isCache: true);
                                }
                              }
                            },
                            child: AppText.tr("parameter_manager.cloth_diy_share_code_import_qr_code"),
                          ),
                        ),
                      ],
                  ],
                ),
              );

            },
          ),
        ),
      ],
    );
  }
}




class TagSelector extends StatefulWidget{
  final ParamBoxManager manager;
  final List<String> initTagList;
  final void Function()? onAdd;
  final void Function(List<String>)? onFinish;

  const TagSelector({
    super.key,
    required this.manager,
    this.initTagList = const [],
    this.onAdd,
    this.onFinish,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}
class _TagSelectorState extends State<TagSelector>{
  final ManualValueNotifier<Map<String, bool>> tagSelectedState = ManualValueNotifier({});

  @override
  void initState(){
    super.initState();
    for(final String uuid in widget.initTagList){
      tagSelectedState.value[uuid] = true;
    }
  }

  @override
  void dispose(){
    tagSelectedState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Row(
          children: [
            AppText.tr("parameter_manager.tag"),

            Expanded(child: block0),

            AppButton.smallIcon(
              onClick: widget.onAdd,
              child: Icon(Icons.add),
            ),
          ],
        ),

        Expanded(
          child: SmoothPointerScroll(
            builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarConrtoller){
              return SingleChildScrollView(
                controller: controller,
                physics: physics,
                child: ListenableBuilder(
                  listenable: widget.manager,
                  builder: (BuildContext context, Widget? child){
                    return ManualValueNotifierBuilder(
                      valueListenable: tagSelectedState,
                      builder: (BuildContext context, Map<String, bool> tagState, Widget? child){
                        return Column(
                          spacing: listSpacing,
                          children: [
                            for(final ParamTag tag in widget.manager.tagList)
                              AppSwitch.smallText(
                                isTransparent: false,
                                value: tagState[tag.uuid] ?? false,
                                onChanged: (bool value){
                                  tagState[tag.uuid] = !(tagState[tag.uuid] ?? false);
                                  tagSelectedState.notify();
                                },
                                child: Row(
                                  spacing: listSpacing,
                                  children: [
                                    SizedBox(
                                      width: smallButtonSize,
                                      height: smallButtonSize,
                                      child: Center(
                                        child: AppIcon("tick", opacity: tagState[tag.uuid] ?? false ? 1 : 0),
                                      ),
                                    ),
                                    AppIcon("tag_fill", color: Color(tag.color)),
                                    Expanded(child: AppText(tag.name)),
                                    AppButton.smallIcon(
                                      toolTip: "parameter_manager.delete",
                                      onClick: () async{
                                        final bool? result = await showAppDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AppConfirmDialog(
                                              message: context.tr("parameter_manager.delete_tag", args: [tag.name]),
                                              isTranslateMessage: false,
                                            );
                                          },
                                        );

                                        if(result == true){
                                          widget.manager.deleteTag(tag.uuid);
                                        }
                                      },
                                      child: AppIcon("delete"),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),

        AppButton.smallText(
          colorRole: ColorRole.highlight,
          isTransparent: false,
          onClick: (){
            final List<String> res = [];
            for(final entity in tagSelectedState.value.entries){
              if(entity.value){
                res.add(entity.key);
              }
            }

            widget.onFinish?.call(res);
          },
          child: AppText.tr("parameter_manager.finish"),
        ),
      ],
    );
  }
}


class TagCreator extends StatefulWidget{
  final void Function()? onCancel;
  final void Function(String name, int color)? onFinish;

  const TagCreator({
    super.key,
    this.onCancel,
    this.onFinish,
  });

  @override
  State<TagCreator> createState() => _TagCreatorState();
}
class _TagCreatorState extends State<TagCreator>{
  static const List<Color> _swatches = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  final TextEditingController nameTextController = TextEditingController();
  final ValueNotifier<Color> color = ValueNotifier(Colors.orange);

  @override
  void dispose(){
    nameTextController.dispose();
    color.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      spacing: listSpacing,
      children: [
        Row(
          spacing: listSpacing,
          children: [
            ValueListenableBuilder(
              valueListenable: color,
              builder: (BuildContext context, Color currentColor, Widget? child){
                return AppIcon("tag_fill", height: 20, color: currentColor);
              },
            ),

            Expanded(
              child: AppTextFiled(
                labelText: "parameter_manager.name",
                controller: nameTextController,
              ),
            ),
          ],
        ),

        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxHeight: smallCardMaxHeight),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: smallButtonContentSize,
                  mainAxisSpacing: listSpacing,
                  crossAxisSpacing: listSpacing,
                  childAspectRatio: 1 / 1,
                ),
                itemCount: _swatches.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: (){
                      color.value = _swatches[index];
                    },
                    child: ClipOval(child: Container(color: _swatches[index])),
                  );
                },
              ),
            ),
          ),
        ),

        Row(
          children: [
            Expanded(
              child: AppButton.smallText(
                isTransparent: false,
                onClick: widget.onCancel?.call,
                child: AppText.tr("parameter_manager.cancel"),
              ),
            ),
            Expanded(
              child: AppButton.smallText(
                colorRole: ColorRole.highlight,
                isTransparent: false,
                onClick: (){
                  widget.onFinish?.call(nameTextController.text, color.value.toARGB32());
                },
                child: AppText.tr("parameter_manager.save"),
              ),
            ),
          ],
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
              AppText.tr("parameter_manager.drag_cover_image_here", fontSize: 24),
              Row(
                spacing: bigPadding,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.tr("parameter_manager.left_click_select"),
                  AppText.tr("parameter_manager.right_click_paste"),
                ],
              ),
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
        padding: const EdgeInsets.fromLTRB(bigPadding, 0, bigPadding, bigPadding),
        child: processor,
      ),
    );
  }
}



