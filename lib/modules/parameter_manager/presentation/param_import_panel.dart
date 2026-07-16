
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

import "package:flutter/material.dart";
import "dart:io";

import "package:path/path.dart" as p;


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