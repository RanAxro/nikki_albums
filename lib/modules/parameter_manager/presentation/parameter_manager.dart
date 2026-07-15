
import "package:nikki_albums/modules/parameter_manager/domain/code_parser.dart";
import "package:nikki_albums/modules/parameter_manager/presentation/rich_building_params_panel.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/building_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/utils/clipboard.dart";

import "../domain/camera_params_edit_controller.dart";
import "../domain/param_item_edit_controller.dart";
import "../model/param_item.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/modules/parameter_manager/domain/param_box_manager.dart";
import "package:nikki_albums/modules/parameter_manager/presentation/param_item_edit_panel.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";

import "camera_params_edit_panel.dart";
import "cloth_diy_params_panel.dart";


final ContentItem item = ContentItem(
  name: "parameter_manager",
  icon: AppIcon("parameter_manager", height: mediumButtonContentSize),
  page: const ParameterManager(),
);

class ParameterManager extends StatefulWidget{
  final int initPage;
  final ParamBoxManager? initManager;

  const ParameterManager({
    super.key,
    this.initPage = 0,
    this.initManager,
  });

  @override
  State<ParameterManager> createState() => _ParameterManagerState();
}

class _ParameterManagerState extends State<ParameterManager>{
  final ValueNotifier<int> page = ValueNotifier<int>(0);
  late final PageController controller;
  bool? isInit;
  late final ParamBoxManager manager;

  Future<void> init() async{
    if(widget.initManager != null){
      manager = widget.initManager!;
    }else{
      manager = await ParamBoxManager.getDefaultParamBox();
    }

    if(!manager.isInit){
      await manager.init();
    }

    setState((){
      isInit = manager.isInit;
    });
  }

  @override
  void initState(){
    super.initState();
    page.value = widget.initPage;
    controller = PageController(initialPage: widget.initPage);
    init();
  }

  @override
  Widget build(BuildContext context){
    if(isInit == null){
      return Center(
        child: AppText("..."),
      );
    }

    if(isInit == false){
      return Center(
        child: AppText("error"),
      );
    }

    return Column(
      children: [
        AppBackground(
          colorRole: ColorRole.secondary,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: smallPadding),
            height: topBarHeight,
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: page,
                    builder: (BuildContext context, int currentPage, Widget? child){
                      return AppRadioStack(
                        direction: Axis.horizontal,
                        selectedIndex: currentPage,
                        children: [
                          AppButton.smallText(
                            onClick: (){
                              page.value = 0;
                              controller.animateToPage(0, duration: animationTime, curve: animationCurve);
                            },
                            child: Row(
                              spacing: listSpacing,
                              children: [
                                AppIcon("camera"),
                                AppText.tr("parameter_manager.camera"),
                              ],
                            ),
                          ),
                          AppButton.smallText(
                            onClick: (){
                              page.value = 1;
                              controller.animateToPage(1, duration: animationTime, curve: animationCurve);
                            },
                            child: Row(
                              spacing: listSpacing,
                              children: [
                                AppIcon("cloth"),
                                AppText.tr("parameter_manager.cloth"),
                              ],
                            ),
                          ),
                          AppButton.smallText(
                            onClick: (){
                              page.value = 2;
                              controller.animateToPage(2, duration: animationTime, curve: animationCurve);
                            },
                            child: Row(
                              spacing: listSpacing,
                              children: [
                                AppIcon("home"),
                                AppText.tr("parameter_manager.home"),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                AppButton.smallText(
                  onClick: (){
                    showAppDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AppDialog(
                          useIntrinsicHeight: false,
                          child: ParamItemEditPanel(
                            controller: ParamItemEditController(),
                            onCancel: (){
                              Navigator.of(context).pop();
                            },
                            onFinished: (ParamItemCreation creation) async{
                              AppToast.showMessage(context: context, message: context.tr("parameter_manager.on_save"));
                              try{
                                await manager.createItem(creation);
                                await manager.save();
                                AppToast.showMessage(context: context, message: context.tr("parameter_manager.save_successful"));
                              }catch(e){
                                AppToast.showMessage(context: context, message: "${context.tr("parameter_manager.save_failed")}\n$e");
                              }finally{
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: AppText.tr("parameter_manager.add"),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: AppBackground(
            colorRole: ColorRole.background,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return ListenableBuilder(
                  listenable: manager,
                  builder: (BuildContext context, Widget? child){
                    return WaterfallGallery(
                      items: manager.items.where((item) => item.type.value == index).toList(),
                      manager: manager,
                      onDelete: (String uuid) async{
                        manager.deleteItem(uuid);
                        await manager.save();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class WaterfallGallery extends StatelessWidget{
  final List<ParamItem> items;
  final ParamBoxManager? manager;
  final void Function(String uuid)? onDelete;

  const WaterfallGallery({
    super.key,
    required this.items,
    this.manager,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context, constraints){
        // ========== 自适应列数 ==========
        // 每个 item 最大宽度 300，根据屏幕宽度计算列数
        const double maxItemWidth = 300;
        final int crossAxisCount = (constraints.maxWidth / maxItemWidth).ceil();

        return MasonryGridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.all(8),
          // ========== 懒加载 ==========
          // 只构建视口内 + 上下各 3 屏范围的 item
          cacheExtent: constraints.maxHeight * 3,
          itemCount: items.length,
          itemBuilder: (context, index){
            print(index);
            final ParamItem item = items[index];

            return AppButton(
              padding: const EdgeInsets.all(smallPadding),
              borderRadius: smallBorderRadius,
              colorRole: ColorRole.primary,
              isTransparent: false,
              onClick: () async{
                final dynamic param = tryDeByType(item.type, item.value);

                final Nuan5DatabaseReaderV1? reader = await Nuan5Data.init();

                showAppDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AppDialog(
                      maxWidth: 500,
                      useIntrinsicHeight: false,
                      child: Column(
                        spacing: bigPadding,
                        children: [
                          Expanded(
                            child: Builder(
                              builder: (BuildContext context){
                                if(param is CameraParams){
                                  return CameraParamsEditPanel(
                                    key: Key("CameraParamsEditPanel1"),
                                    controller: CameraParamsEditController(cameraParams: param, allowEdit: false),
                                    reader: reader,
                                  );
                                }
                                if(param is ClothDiyParams){
                                  return ClothDiyParamsPanel(
                                    shareCode: item.value,
                                    clothDiyParams: param,
                                    reader: reader,
                                  );
                                }
                                if(param is RichBuildingParams){
                                  return RichBuildingParamsPanel(
                                    shareCode: item.value,
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

                          Row(
                            spacing: listSpacing,
                            children: [
                              AppButton.smallIcon(
                                onClick: (){
                                  onDelete?.call(item.uuid);
                                  Navigator.of(context).pop();
                                },
                                child: AppIcon("delete"),
                              ),

                              Expanded(
                                child: AppButton.smallText(
                                  isTransparent: false,
                                  onClick: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: AppText.tr("parameter_manager.close"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Column(
                spacing: listSpacing,
                children: [
                  AppText(item.title ?? ""),

                  if(manager != null && item.image != null)
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(smallBorderRadius),
                      child: Image.file(File(manager!.getImagePath(item.image!))),
                    ),

                  AppButton.smallText(
                    toolTip: "parameter_manager.click_to_copy",
                    colorRole: ColorRole.secondary,
                    isTransparent: false,
                    onClick: () async{
                      try{
                        await copyTextToClipboard(item.value);
                        if(context.mounted){
                          AppToast.showMessage(context: context, message: context.tr("parameter_manager.copy_successful"));
                        }
                      }catch(e){
                        if(context.mounted){
                          AppToast.showMessage(context: context, message: "${context.tr("parameter_manager.copy_failed")}\n$e", state: false);
                        }
                      }
                    },
                    child: AppText(item.value, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
