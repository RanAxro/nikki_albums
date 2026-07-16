
import "dart:convert";

import "package:nikki_albums/utils/system/system.dart";

import "cloth_diy_params_panel.dart";
import "camera_params_edit_panel.dart";
import "../domain/camera_params_edit_controller.dart";
import "../domain/code_parser.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/decode.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/modules/game/game.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/utils/clipboard.dart";
import "package:nikki_albums/utils/qr_code.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:typed_data";

import "package:path/path.dart" as p;
import "package:desktop_drop/desktop_drop.dart";
import "package:easy_localization/easy_localization.dart";
import "package:file_picker/file_picker.dart";


class CameraParamsImportInputPanel extends StatefulWidget{
  final void Function()? onCancel;
  final void Function(String?, CameraParams)? onFinish;
  final Nuan5DatabaseReaderV1? reader;

  const CameraParamsImportInputPanel({
    super.key,
    this.onCancel,
    this.onFinish,
    this.reader,
  });

  @override
  State<CameraParamsImportInputPanel> createState() => _CameraParamsImportInputPanelState();
}

class _CameraParamsImportInputPanelState extends State<CameraParamsImportInputPanel>{
  final CameraParamsEditController controller = CameraParamsEditController();

  @override
  Widget build(BuildContext context){
    return Column(
      spacing: bigPadding,
      children: [
        Expanded(
          child: SmoothPointerScroll(
            builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
              return SingleChildScrollView(
                controller: scrollController,
                physics: physics,
                child: CameraParamsEditPanel(
                  controller: controller,
                  reader: widget.reader,
                ),
              );
            },
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
                onClick: (){
                  widget.onFinish?.call(controller.cameraParamString, controller.cameraParams);
                },
                child: AppText.tr("parameter_manager.finish"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class ClothDiyShareCodeImportHistoryPanel extends StatefulWidget{
  final void Function()? onCancel;
  final void Function(String)? onFinish;
  final Nuan5DatabaseReaderV1? reader;

  const ClothDiyShareCodeImportHistoryPanel({
    super.key,
    this.onCancel,
    this.onFinish,
    this.reader,
  });

  @override
  State<ClothDiyShareCodeImportHistoryPanel> createState() => _ClothDiyShareCodeImportHistoryPanelState();
}

class _ClothDiyShareCodeImportHistoryPanelState extends State<ClothDiyShareCodeImportHistoryPanel>{
  final Map<String, List<String>> shareCodeMap = {};
  final ValueNotifier<String?> currentUid = ValueNotifier(null);
  final ValueNotifier<String?> selectedShareCode = ValueNotifier(null);

  Future<void> init() async{
    if(AppState.currentGame.value != null){
      final Game game = AppState.currentGame.value!;
      final String historyDirPath = p.join(game.installPath.path, "X6Game", "Saved", "ShareCode");
      final Directory historyDir = Directory(historyDirPath);

      final RegExp regex = RegExp(r"^\d{9}diy_history_sharecode\.json$");
      await for(final FileSystemEntity entity in historyDir.list()){
        if(entity is! File){
          continue;
        }

        final String filename = p.basename(entity.path);
        if(!regex.hasMatch(filename)){
          continue;
        }

        final String uid = filename.substring(0, 9);
        try{
          final ClothDiyParam? clothDiyParam = await clothDiyDeFile(paramType: ClothDiyParamType.diyHistoryShareCode, path: entity.path);
          clothDiyParam?.whenOrNull(
            diyHistoryShareCode: (List<DiyHistoryShareCodeParams> box){
              shareCodeMap[uid] = box.map((DiyHistoryShareCodeParams item) => item.shareCode).toList();
            },
          );
        }catch(e){
          continue;
        }
      }

      setState((){
        currentUid.value = shareCodeMap.keys.firstOrNull;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context){
    if(AppState.currentGame.value == null){
      return Center(
        child: AppText.tr("parameter_manager.to_select_game"),
      );
    }

    return ValueListenableBuilder(
      valueListenable: currentUid,
      builder: (BuildContext context, String? uid, Widget? child){
        if(uid == null){
          return Center(
            child: AppText.tr("parameter_manager.find_no_uid"),
          );
        }

        final List<String> shareCodeList = shareCodeMap[uid] ?? const [];

        return Column(
          spacing: bigPadding,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                spacing: listSpacing,
                children: [
                  block5W,

                  AppText("uid"),

                  IntrinsicWidth(
                    child: AppDropdown(
                      childrenBuilder: (BuildContext context, MenuController controller){
                        return shareCodeMap.keys.map((String targetUid){
                          return AppButton.smallText(
                            onClick: (){
                              currentUid.value = targetUid;
                              controller.close();
                            },
                            child: AppText(targetUid),
                          );
                        }).toList();
                      },
                      builder: (BuildContext context, MenuController controller, Widget? child){
                        return AppButton.smallText(
                          isTransparent: false,
                          onClick: (){
                            controller.isOpen ? controller.close() : controller.open();
                          },
                          child: AppText(uid),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Row(
                spacing: listSpacing,
                children: [
                  Container(
                    width: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(smallBorderRadius),
                      color: AppColorScheme.of(context).background.enabledColor
                    ),
                    child: SmoothPointerScroll(
                      builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
                        return SingleChildScrollView(
                          controller: controller,
                          physics: physics,
                          child: AppFloatingIndicatorButtonGroup(
                            child: Column(
                              children: shareCodeList.map((String shareCode){
                                return ValueListenableBuilder(
                                  valueListenable: selectedShareCode,
                                  builder: (BuildContext context, String? selected, Widget? child){
                                    return AppFloatingIndicatorButtonTarget(
                                      child: AppSwitch.smallText(
                                        value: selected == shareCode,
                                        onChanged: (bool value){
                                          if(selectedShareCode.value == shareCode){
                                            selectedShareCode.value = null;
                                          }else{
                                            selectedShareCode.value = shareCode;
                                          }
                                        },
                                        child: AppText(shareCode),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: selectedShareCode,
                      builder: (BuildContext context, String? selected, Widget? child){
                        if(selected == null){
                          return Center(
                            child: AppText.tr("parameter_manager.preview"),
                          );
                        }

                        return RFutureBuilder(
                          future: tryDeClothDiyShareCode(selected),
                          builder: (BuildContext context, ClothDiyParams? clothDiyParams){
                            if(clothDiyParams == null){
                              return Center(
                                child: AppText.tr("parameter_manager.invalid_param"),
                              );
                            }

                            return ClothDiyParamsPanel(
                              shareCode: selected,
                              clothDiyParams: clothDiyParams,
                              reader: widget.reader,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Row(
              spacing: listSpacing,
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
                  child: ValueListenableBuilder(
                    valueListenable: selectedShareCode,
                    builder: (BuildContext context, String? shareCode, Widget? child){
                      return AppButton.smallText(
                        colorRole: ColorRole.highlight,
                        isTransparent: false,
                        onClick: (){
                          if(shareCode != null){
                            widget.onFinish?.call(shareCode);
                          }
                        },
                        usable: shareCode != null,
                        child: AppText.tr("parameter_manager.confirm"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}


class ClothDiyShareCodeImportQrCodePanel extends StatefulWidget{
  final void Function(String shareCode, String? path)? onFinish;

  const ClothDiyShareCodeImportQrCodePanel({
    super.key,
    this.onFinish,
  });

  @override
  State<ClothDiyShareCodeImportQrCodePanel> createState() => _ClothDiyShareCodeImportQrCodePanelState();
}

class _ClothDiyShareCodeImportQrCodePanelState extends State<ClothDiyShareCodeImportQrCodePanel>{
  static const List<String> allowExtension = [".png", ".jpg", ".jpeg", ".webp"];

  final ValueNotifier<bool> isDrag = ValueNotifier<bool>(false);

  Future<Uint8List?> _pickFiles() async {
    final FilePickerResult? location = await FilePicker.platform.pickFiles(
      dialogTitle: context.tr("parameter_manager.select_qr_code_image"),
      lockParentWindow: true,
      type: FileType.image,
      allowMultiple: false,
    );

    if(location != null){
      final String? path = location.paths.firstOrNull;
      if(path != null && allowExtension.contains(p.extension(path))){
        final File file = File(path);
        return await file.readAsBytes();
      }
    }

    return null;
  }

  Future<Uint8List?> _dragDone(DropDoneDetails details) async{
    final String? path = details.files.firstOrNull?.path;

    if(path != null && allowExtension.contains(p.extension(path))){
      final File file = File(path);
      return await file.readAsBytes();
    }

    return null;
  }

  Future<Uint8List?> _paste() async{
    final Uint8List? imageBytes = await readImageFromClipboard();

    if(imageBytes == null){
      final String? path = (await readFilesFromClipboard()).firstOrNull?.path;

      if(path != null && allowExtension.contains(p.extension(path))){
        final File file = File(path);
        return await file.readAsBytes();
      }
    }else{
      return imageBytes;
    }

    return null;
  }

  Future<void> _decode(BuildContext context, Uint8List bytes) async{
    final String? text = await decodeQRCode(bytes);

    if(text == null){
      if(context.mounted){
        AppToast.showMessage(context: context, message: context.tr("parameter_manager.find_no_qr_code"), state: false);
      }
    }else{
      final ClothDiyParam? clothDiyParam = await deClothDiyParam(paramType: ClothDiyParamType.qrCode, bytes: utf8.encode(text));
      final String? shareCode = clothDiyParam?.whenOrNull(
        qrCode: (ClothDiyQrCodeParams clothDiyQrCodeParams){
          return clothDiyQrCodeParams.shareCode;
        },
      );

      if(shareCode == null){
        if(context.mounted){
          AppToast.showMessage(context: context, message: context.tr("parameter_manager.invalid_qr_code"), state: false);
        }
      }else{
        widget.onFinish?.call(shareCode, await _saveImage(bytes));
      }
    }
  }

  Future<String?> _saveImage(Uint8List bytes) async{
    final String tempPath = p.join((await getTempPath()).path, "QrCode");
    final File tempFile = File(tempPath);

    try{
      if(!await tempFile.exists()){
        await tempFile.create(recursive: true);
      }
      await tempFile.writeAsBytes(bytes);

      return tempPath;
    }catch(e){
      return null;
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
              AppText.tr("parameter_manager.drag_qr_code_image_here", fontSize: 28),

              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: bigPadding,
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
      onDragDone: (DropDoneDetails details) async{
        final Uint8List? bytes = await _dragDone(details);
        if(context.mounted && bytes != null){
          _decode(context, bytes);
        }
      },
      child: GestureDetector(
        onTap: () async{
          final Uint8List? bytes = await _pickFiles();
          if(context.mounted && bytes != null){
            _decode(context, bytes);
          }
        },
        onSecondaryTap: () async{
          final Uint8List? bytes = await _paste();
          if(context.mounted && bytes != null){
            _decode(context, bytes);
          }
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
