
import "package:cached_network_image/cached_network_image.dart";
import "package:nikki_albums/modules/nuan5_params/presentation/common.dart";

import "camera_params_edit_panel.dart";
import "cloth_diy_params_panel.dart";
import "rich_building_params_panel.dart";
import "param_item_edit_panel.dart";
import "../model/parameter_manager.dart";
import "../model/param_box.dart";
import "../model/param_type.dart";
import "../model/param_item.dart";
import "../domain/camera_params_edit_controller.dart";
import "../domain/param_import.dart";
import "../domain/param_item_edit_controller.dart";
import "../domain/code_parser.dart";
import "../domain/param_box_manager.dart";
import "package:nikki_albums/modules/nuan5_params/domain/config.dart";
import "package:nikki_albums/modules/nuan5_params/domain/cloth_diy_handler.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/building_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/modules/nuan5_params/domain/tree_node_generator.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/nikki_photo_params.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/widgets/common/non_cache_file_image.dart";
import "package:nikki_albums/utils/path.dart";
import "package:nikki_albums/utils/clipboard.dart";
import "package:nikki_albums/utils/color/utils.dart";
import "package:nikki_albums/utils/qr_code.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/modules/app_base/state.dart";

import "package:flutter/material.dart" hide Path;
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:path/path.dart" as p;
import "package:qr_flutter/qr_flutter.dart";


final ContentItem item = ContentItem(
  name: "parameter_manager",
  icon: AppIcon("parameter_manager", height: mediumButtonContentSize),
  page: GlobalParamBoxManagerBuilder(
    builder: (BuildContext context, ParamBoxManager manager){
      return ParameterManager(initManager: manager);
    },
  ),
);


class GlobalParamBoxManagerBuilder extends StatelessWidget{
  static ParamBoxManager? _globalParamBox;

  static Future<String> getDefaultParamBoxPath() async{
    final String basePath = (await getAppDataDirectoryPath()).path;
    return p.join(basePath, "ParamBox");
  }

  static Future<ParamBoxManager> getGlobalManager(String? customPath) async{
    final String path = customPath ?? await getDefaultParamBoxPath();

    if(_globalParamBox != null && _globalParamBox!.directory.path == path){
      return _globalParamBox!;
    }

    _globalParamBox = ParamBoxManager(Directory(path));
    return _globalParamBox!;
  }


  final Widget Function(BuildContext, ParamBoxManager) builder;

  const GlobalParamBoxManagerBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: AppState.customParamBoxPath,
      builder: (BuildContext context, String? customPath, Widget? child){
        return RFutureBuilder(
          future: getGlobalManager(customPath),
          builder: (BuildContext context, ParamBoxManager globalManager){
            return builder(context, globalManager);
          },
        );
      },
    );
  }
}

class ParameterManager extends StatefulWidget{
  final int initPage;
  final ParamBoxManager initManager;

  const ParameterManager({
    super.key,
    this.initPage = 0,
    required this.initManager,
  });

  @override
  State<ParameterManager> createState() => _ParameterManagerState();
}

class _ParameterManagerState extends State<ParameterManager>{
  final ValueNotifier<int> page = ValueNotifier<int>(0);
  final ValueNotifier<SearchConfig> searchConfig = ValueNotifier(SearchConfig.defaultConfig);
  late final PageController controller;
  bool? isInit;
  late final ParamBoxManager manager;
  Nuan5Config? config;
  final ClothDiyHandler handler = ClothDiyHandler();
  final ValueNotifier<SearchOption?> searchTip = ValueNotifier(SearchOption.tag);
  final ValueNotifier<int> updateTextField = ValueNotifier(0);

  Future<void> init() async{
    manager = widget.initManager;

    if(!manager.isInit){
      await manager.init();
    }

    try{
      config = await GlobalNuan5Config.init();
    }catch(e){
      config = null;
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
  void dispose(){
    super.dispose();
    page.dispose();
  }

  void search(BuildContext context){
    Widget child = ValueListenableBuilder(
      valueListenable: searchConfig,
      builder: (BuildContext context, SearchConfig currentSearchConfig, Widget? child){
        return Column(
          spacing: listSpacing,
          children: [
            ValueListenableBuilder(
              valueListenable: updateTextField,
              builder: (BuildContext context, int k, Widget? child){
                return AppTextFiled(
                  key: ValueKey(k),
                  autofocus: true,
                  initText: currentSearchConfig.value,
                  onChanged: (String value){
                    searchConfig.value = currentSearchConfig.copyWith(value: value);
                  },
                  labelText: "parameter_manager.search",
                );
              },
            ),

            AppFloatingIndicatorButtonGroup(
              child: Wrap(
                children: [
                  AppSwitchButton(
                    expand: false,
                    value: currentSearchConfig.searchName,
                    onChanged: (bool value){
                      searchConfig.value = currentSearchConfig.copyWith(searchName: value);
                    },
                    child: AppText.tr("parameter_manager.search_name"),
                  ),
                  GestureDetector(
                    onSecondaryTap: (){
                      searchTip.value = SearchOption.tag;
                    },
                    child: AppSwitchButton(
                      expand: false,
                      value: currentSearchConfig.searchTag,
                      onChanged: (bool value){
                        searchConfig.value = currentSearchConfig.copyWith(searchTag: value);
                        searchTip.value = value ? SearchOption.tag : null;
                      },
                      child: AppText.tr("parameter_manager.search_tag"),
                    ),
                  ),
                  GestureDetector(
                    onSecondaryTap: (){
                      searchTip.value = SearchOption.clothesName;
                    },
                    child: AppSwitchButton(
                      expand: false,
                      value: currentSearchConfig.searchClothesName,
                      onChanged: (bool value){
                        searchConfig.value = currentSearchConfig.copyWith(searchClothesName: value);
                        searchTip.value = value ? SearchOption.clothesName : null;
                      },
                      child: AppText.tr("parameter_manager.search_clothes_name"),
                    ),
                  ),
                  GestureDetector(
                    onSecondaryTap: (){
                      searchTip.value = SearchOption.outfitName;
                    },
                    child: AppSwitchButton(
                      expand: false,
                      value: currentSearchConfig.searchOutfitName,
                      onChanged: (bool value){
                        searchConfig.value = currentSearchConfig.copyWith(searchOutfitName: value);
                        searchTip.value = value ? SearchOption.outfitName : null;
                      },
                      child: AppText.tr("parameter_manager.search_outfit_name"),
                    ),
                  ),
                  GestureDetector(
                    onSecondaryTap: (){
                      searchTip.value = SearchOption.clothPropName;
                    },
                    child: AppSwitchButton(
                      expand: false,
                      value: currentSearchConfig.searchClothMajorPropName,
                      onChanged: (bool value){
                        searchConfig.value = currentSearchConfig.copyWith(searchClothMajorPropName: value);
                        searchTip.value = value ? SearchOption.clothPropName : null;
                      },
                      child: AppText.tr("parameter_manager.search_cloth_major_prop_name"),
                    ),
                  ),
                  GestureDetector(
                    onSecondaryTap: (){
                      searchTip.value = SearchOption.clothTagName;
                    },
                    child: AppSwitchButton(
                      expand: false,
                      value: currentSearchConfig.searchClothTagName,
                      onChanged: (bool value){
                        searchConfig.value = currentSearchConfig.copyWith(searchClothTagName: value);
                        searchTip.value = value ? SearchOption.clothTagName : null;
                      },
                      child: AppText.tr("parameter_manager.search_cloth_tag_name"),
                    ),
                  ),
                  GestureDetector(
                    onSecondaryTap: (){
                      searchTip.value = SearchOption.light;
                    },
                    child: AppSwitchButton(
                      expand: false,
                      value: currentSearchConfig.searchLight,
                      onChanged: (bool value){
                        searchConfig.value = currentSearchConfig.copyWith(searchLight: value);
                        searchTip.value = value ? SearchOption.light : null;
                      },
                      child: AppText.tr("parameter_manager.search_light"),
                    ),
                  ),
                  GestureDetector(
                    onSecondaryTap: (){
                      searchTip.value = SearchOption.filter;
                    },
                    child: AppSwitchButton(
                      expand: false,
                      value: currentSearchConfig.searchFilter,
                      onChanged: (bool value){
                        searchConfig.value = currentSearchConfig.copyWith(searchFilter: value);
                        searchTip.value = value ? SearchOption.filter : null;
                      },
                      child: AppText.tr("parameter_manager.search_filter"),
                    ),
                  ),
                ].map((Widget child) => AppFloatingIndicatorButtonTarget(child: IntrinsicWidth(child: child))).toList(),
              ),
            ),

            ValueListenableBuilder(
              valueListenable: searchTip,
              builder: (BuildContext context, SearchOption? option, Widget? child){
                if(option == null){
                  return block0;
                }

                return Expanded(
                  child: Column(
                    spacing: listSpacing,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: smallPadding),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AppText.tr("parameter_manager.search_tip.${option.name}", fontWeight: FontWeight.bold),
                        ),
                      ),

                      Expanded(
                        child: SearchTipGrid(
                          manager: manager,
                          config: config,
                          option: option,
                          keyword: searchConfig.value.value,
                          onSelect: (String value){
                            searchConfig.value = currentSearchConfig.copyWith(value: value);
                            updateTextField.value++;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );

    showAppDialog(
      context: context,
      builder: (BuildContext context){
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: topBarHeight + smallPadding),
            child: AppDialog(
              maxWidth: 800,
              useIntrinsicHeight: false,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Future<List<ParamItem>> getShowItem(int typeIndex) async{
    final SearchConfig currentSearchConfig = searchConfig.value;
    final Set<String> targetTag = manager.tagList
      .map((ParamTag tag) => tag.name.contains(currentSearchConfig.value) ? tag.uuid : null)
      .nonNulls.toSet();

    final List<ParamItem> res = [];

    itemLoop:
    for(final ParamItem item in manager.getSortedItemList().reversed){
      if(item.type.value != typeIndex){
        continue itemLoop;
      }
      if(currentSearchConfig.value == ""){
        res.add(item);
        continue itemLoop;
      }
      if(currentSearchConfig.searchName && item.title?.contains(currentSearchConfig.value) == true){
        res.add(item);
        continue itemLoop;
      }
      if(currentSearchConfig.searchTag && item.tag.any((String uuid) => targetTag.contains(uuid))){
        res.add(item);
        continue itemLoop;
      }
      if((currentSearchConfig.searchClothesName ||
          currentSearchConfig.searchOutfitName ||
          currentSearchConfig.searchClothMajorPropName ||
          currentSearchConfig.searchClothTagName
        ) && item.type == ParamType.cloth){
        final ClothDiyParams? params = await tryDeClothDiyShareCode(item.value);

        for(final ClothParams clothParams in params?.clothes ?? const []){
          if(currentSearchConfig.searchClothesName && trText(clothParams.cloth.id.toString(), category: "cloth").contains(currentSearchConfig.value)){
            res.add(item);
            continue itemLoop;
          }

          final int? outfit = handler.getClothOutfit(config, clothParams.cloth);
          if(outfit!= null && currentSearchConfig.searchOutfitName && trText(outfit.toString(), category: "cloth_outfit").contains(currentSearchConfig.value)){
            res.add(item);
            continue itemLoop;
          }
        }

        if(config != null && params != null){
          final int? majorProp = handler.getProps(config!, params.clothes).keys.firstOrNull;
          if(majorProp != null && currentSearchConfig.searchClothMajorPropName && trText(majorProp.toString(), category: "cloth_prop").contains(currentSearchConfig.value)){
            res.add(item);
            continue itemLoop;
          }

          final Iterable<int> tags = handler.getTags(config!, params.clothes).keys;
          if(currentSearchConfig.searchClothTagName){
            for(final int tag in tags){
              if(trText(tag.toString(), category: "cloth_tag").contains(currentSearchConfig.value)){
                res.add(item);
                continue itemLoop;
              }
            }
          }
        }
      }
      if(currentSearchConfig.searchLight && item.type == ParamType.camera){
        final CameraParams? params = await tryDeCameraParameter(item.value);
        final String? lightId = params?.light.whenOrNull(some: (id, strength) => id);

        final Nuan5Config? config = await GlobalNuan5Config.init();
        if(lightId != null && config != null){
          for(final MapEntry<int, Nuan5Light> entry in config.light.entries){
            if(lightId != entry.value.paramId && lightId != entry.value.stringId){
              continue;
            }

            if(trText(entry.key.toString(), category: "light").contains(currentSearchConfig.value)){
              res.add(item);
              continue itemLoop;
            }
          }
        }
      }
      if(currentSearchConfig.searchFilter && item.type == ParamType.camera){
        final CameraParams? params = await tryDeCameraParameter(item.value);
        final String? filterId = params?.filter.whenOrNull(some: (id, strength) => id);

        final Nuan5Config? config = await GlobalNuan5Config.init();
        if(filterId != null && config != null){
          for(final MapEntry<int, Nuan5Filter> entry in config.filter.entries){
            if(filterId != entry.value.paramId && filterId != entry.value.stringId){
              continue;
            }

            if(trText(entry.key.toString(), category: "filter").contains(currentSearchConfig.value)){
              res.add(item);
              continue itemLoop;
            }
          }
        }
      }
    }

    return res;
  }

  void add(BuildContext context, {String? code, ParamItemCover? cover, ParamType? paramType}){
    final ParamItemEditController controller = ParamItemEditController(
      initCode: code,
      initCover: cover,
      initParamType: paramType,
    );

    showAppDialog(
      context: context,
      builder: (BuildContext context){
        return AppDialog(
          useIntrinsicHeight: false,
          child: ParamItemEditPanel(
            manager: manager,
            controller: controller,
            onCancel: (){
              Navigator.of(context).pop();
              controller.dispose();
            },
            onFinish: (ParamItemCreation creation) async{
              AppToast.showMessage(context: context, message: context.tr("parameter_manager.on_save"));
              try{
                await manager.createItem(creation);
                await manager.save();
                if(context.mounted){
                  AppToast.showMessage(context: context, message: context.tr("parameter_manager.save_successful"));
                }
              }catch(e){
                if(context.mounted){
                  AppToast.showMessage(context: context, message: "${context.tr("parameter_manager.save_failed")}\n$e");
                }
              }finally{
                if(context.mounted){
                  Navigator.of(context).pop();
                }
                controller.dispose();
              }
            },
          ),
        );
      },
    );
  }

  void onDeleteItem(String uuid){
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final bool? result = await showAppDialog<bool>(
        context: context,
        builder: (BuildContext context){
          return AppConfirmDialog(
            message: "parameter_manager.delete_item",
            isTranslateMessage: true,
          );
        },
      );

      if(result == true){
        manager.deleteItem(uuid);
        await manager.save();
      }
    });
  }

  void onEditItem(String uuid){
    final ParamItem? item = manager.getItem(uuid);
    if(item == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_){
      showAppDialog(
        context: context,
        builder: (BuildContext context){
          return AppDialog(
            useIntrinsicHeight: false,
            child: ParamItemEditPanel(
              manager: manager,
              controller: ParamItemEditController(
                initName: item.title,
                initCode: item.value,
                initCover: item.image == null ? null : NativeParamItemCover(
                  path: manager.getImagePath(item.image!),
                  isCache: false,
                ),
                initParamType: item.type
              ),
              initTag: item.tag,
              createMode: false,
              onCancel: Navigator.of(context).pop,
              onFinish: (ParamItemCreation creation) async{
                manager.setItem(item.uuid, creation);
                Navigator.of(context).pop();
                await manager.save();
              },
            ),
          );
        },
      );
    });
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
                /// Nav
                ValueListenableBuilder(
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

                /// Search Button
                Expanded(
                  child: AppButton.smallText(
                    margin: const EdgeInsets.symmetric(horizontal: bigPadding),
                    colorRole: ColorRole.secondary,
                    isTransparent: false,
                    onClick: (){
                      search(context);
                    },
                    child: Row(
                      spacing: listSpacing,
                      children: [
                        Icon(Icons.search),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: searchConfig,
                            builder: (BuildContext context, SearchConfig currentSearchConfig, Widget? child){
                              if(currentSearchConfig.value == ""){
                                return AppText.tr("parameter_manager.search");
                              }
                              return Row(
                                spacing: listSpacing,
                                children: [
                                  Expanded(child: AppText(currentSearchConfig.value)),
                                  AppButton.smallIcon(
                                    onClick: (){
                                      searchConfig.value = searchConfig.value.copyWith(value: "");
                                    },
                                    child: AppIcon("cross"),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Add Button
                AppButton.smallText(
                  onClick: (){
                    add(context, paramType: [
                      ParamType.camera,
                      ParamType.cloth,
                      ParamType.home,
                    ][page.value]);
                  },
                  child: Row(
                    spacing: listSpacing,
                    children: [
                      Icon(Icons.add),
                      AppText.tr("parameter_manager.add"),
                    ],
                  ),
                ),

                /// More Method Button
                AppDropdown(
                  childrenBuilder: (BuildContext context, MenuController controller){
                    return [
                      if(page.value == 0)
                        ...[
                          AppButton.smallText(
                            height: mediumButtonSize,
                            onClick: () async{
                              final (String?, CameraParams)? result = await showCameraParamsImportInputPanel(context: context);
                              if(context.mounted && result?.$1 != null){
                                add(context, code: result?.$1);
                              }

                              controller.close();
                            },
                            child: AppText.tr("parameter_manager.camera_params_import_input"),
                          ),
                          AppButton.smallText(
                            height: mediumButtonSize,
                            onClick: (){
                              controller.close();
                              goToCameraParamsImportAlbumNikkiPhotos();
                            },
                            child: AppText.tr("parameter_manager.camera_params_import_album_nikki_photos"),
                          ),
                          AppButton.smallText(
                            height: mediumButtonSize,
                            onClick: (){
                              controller.close();
                              goToCameraParamsImportAlbumClockInPhoto();
                            },
                            child: AppText.tr("parameter_manager.camera_params_import_album_clock_in_photo"),
                          ),
                        ],

                      if(page.value == 1)
                        ...[
                          AppButton.smallText(
                            height: mediumButtonSize,
                            onClick: () async{
                              final String? result = await showClothDiyShareCodeImportHistoryPanel(context: context);
                              if(context.mounted && result != null){
                                add(context, code: result);
                              }

                              controller.close();
                            },
                            child: AppText.tr("parameter_manager.cloth_diy_share_code_import_history"),
                          ),
                          AppButton.smallText(
                            height: mediumButtonSize,
                            onClick: () async{
                              goToClothDiyShareCodeImportAlbumDIY();

                              controller.close();
                            },
                            child: AppText.tr("parameter_manager.cloth_diy_share_code_import_album_diy"),
                          ),
                          AppButton.smallText(
                            height: mediumButtonSize,
                            onClick: () async{
                              final (String, String?)? result = await showClothDiyShareCodeImportQrCodePanel(context: context);
                              if(context.mounted && result != null){
                                add(context, code: result.$1, cover: result.$2 == null ? null : NativeParamItemCover(path: result.$2!, isCache: true));
                              }

                              controller.close();
                            },
                            child: AppText.tr("parameter_manager.cloth_diy_share_code_import_qr_code"),
                          ),
                        ],
                    ];
                  },
                  builder: (BuildContext context, MenuController controller, Widget? child){
                    return AppButton.smallIcon(
                      onClick: (){
                        controller.isOpen ? controller.close() : controller.open();
                      },
                      child: Icon(Icons.arrow_drop_down_rounded),
                    );
                  },
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
                return KeepAliveWrapper(
                  child: ListenableBuilder(
                    listenable: manager,
                    builder: (BuildContext context, Widget? child){
                      return ValueListenableBuilder(
                        valueListenable: searchConfig,
                        builder: (BuildContext context, SearchConfig currentSearchConfig, Widget? child){
                          return RFutureBuilder(
                            future: getShowItem(index),
                            builder: (BuildContext context, List<ParamItem> items){
                              return WaterfallGallery(
                                items: items,
                                manager: manager,
                                onDelete: onDeleteItem,
                                onEdit: onEditItem,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
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
  final ParamBoxManager manager;
  final void Function(String uuid)? onDelete;
  final void Function(String uuid)? onEdit;

  const WaterfallGallery({
    super.key,
    required this.items,
    required this.manager,
    this.onDelete,
    this.onEdit,
  });


  Future<void> showViewerDialog(BuildContext context, ParamItem item) async{
    final dynamic param = await tryDeByType(item.type, item.value);

    final Nuan5Config? config = await GlobalNuan5Config.init();

    if(context.mounted){
      await showAppDialog(
        context: context,
        builder: (BuildContext context){
          return AppDialog(
            maxWidth: 500,
            useIntrinsicHeight: false,
            child: Column(
              spacing: bigPadding,
              children: [
                /// Param Code Bar
                AppFloatingIndicatorButtonGroup(
                  child: Row(
                    spacing: listSpacing,
                    children: [
                      block5W,
                      Expanded(
                        child: AppText(item.value, fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis, softWrap: false),
                      ),

                      AppFloatingIndicatorButtonTarget(
                        child: AppButton.smallText(
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
                          child: Row(
                            children: [
                              Icon(Icons.copy),
                              AppText.tr("parameter_manager.copy"),
                            ],
                          ),
                        ),
                      ),
                      if(param is ClothDiyParams)
                        AppFloatingIndicatorButtonTarget(
                          child: AppButton.smallText(
                            onClick: () async{
                              final String qrData = "{\"Content\":{\"Content\":\"${item.value}\"}}";

                              showAppDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AppDialog(
                                    maxWidth: 400,
                                    maxHeight: 400,
                                    useIntrinsicHeight: false,
                                    child: QrImageView(
                                      data: qrData,
                                    ),
                                  );
                                }
                              );

                              try{
                                final String tempPath = p.join((await getTempPath()).path, "QrCodeGenerate.png");
                                await saveQrToFile(qrData, tempPath);
                                final bool res = await copyFilesToClipboard([Path(tempPath)]);
                                if(context.mounted){
                                  if(res){
                                    AppToast.showMessage(context: context, message: context.tr("parameter_manager.copy_successful"));
                                  }else{
                                    AppToast.showMessage(context: context, message: context.tr("parameter_manager.copy_failed"), state: false);
                                  }
                                }
                              }catch(e){
                                if(context.mounted){
                                  AppToast.showMessage(context: context, message: "${context.tr("parameter_manager.copy_failed")}\n$e", state: false);
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.qr_code),
                                AppText.tr("parameter_manager.qr_code"),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                /// params viewer
                Expanded(
                  child: Builder(
                    builder: (BuildContext context){
                      if(param is CameraParams){
                        return CameraParamsEditPanel(
                          controller: CameraParamsEditController(cameraParams: param, allowEdit: false),
                          config: config,
                        );
                      }
                      if(param is ClothDiyParams){
                        return ClothDiyParamsPanel(
                          shareCode: item.value,
                          clothDiyParams: param,
                          config: config,
                        );
                      }
                      if(param is RichBuildingParams){
                        return RichBuildingParamsPanel(
                          shareCode: item.value,
                          richBuildingParams: param,
                          config: config,
                        );
                      }

                      return Center(
                        child: AppText.tr("parameter_manager.invalid_param"),
                      );
                    },
                  ),
                ),

                /// bottom button
                Row(
                  spacing: listSpacing,
                  children: [
                    AppButton.smallIcon(
                      toolTip: "parameter_manager.delete",
                      onClick: (){
                        Navigator.of(context).pop();
                        onDelete?.call(item.uuid);
                      },
                      child: AppIcon("delete"),
                    ),

                    AppButton.smallIcon(
                      toolTip: "parameter_manager.edit",
                      isTransparent: false,
                      onClick: (){
                        Navigator.of(context).pop();
                        onEdit?.call(item.uuid);
                      },
                      child: AppIcon("edit"),
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
    }
  }

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context, constraints){
        // ========== 自适应列数 ==========
        // 每个 item 最大宽度 300，根据屏幕宽度计算列数
        const double maxItemWidth = 300;
        final int crossAxisCount = (constraints.maxWidth / maxItemWidth).ceil();

        return SmoothPointerScroll(
          builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
            return Row(
              children: [
                Expanded(
                  child: MasonryGridView.count(
                    controller: controller,
                    physics: physics,
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    padding: const EdgeInsets.all(8),
                    // ========== 懒加载 ==========
                    // 只构建视口内 + 上下各 3 屏范围的 item
                    cacheExtent: constraints.maxHeight * 3,
                    itemCount: items.length,
                    itemBuilder: (context, index){
                      final ParamItem item = items[index];

                      return AppButton(
                        padding: const EdgeInsets.all(smallPadding),
                        borderRadius: smallBorderRadius,
                        colorRole: ColorRole.primary,
                        isTransparent: false,
                        onClick: () async{
                          showViewerDialog(context, item);
                        },
                        child: Column(
                          spacing: listSpacing,
                          children: [
                            AppText(item.title ?? ""),

                            if(item.image != null)
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(smallBorderRadius),
                                child: Image(image: NonCacheFileImage(File(manager.getImagePath(item.image!)))),
                              ),

                            if(item.tag.isNotEmpty)
                              Builder(
                                builder: (BuildContext context){
                                  final List<Widget> children = [];

                                  for(final String uuid in item.tag){
                                    final ParamTag? tag = manager.getTag(uuid);
                                    if(tag != null){
                                      children.add(IntrinsicWidth(
                                        child: Container(
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
                                        ),
                                      ));
                                    }
                                  }

                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Wrap(
                                      spacing: listSpacing,
                                      runSpacing: listSpacing,
                                      children: children,
                                    ),
                                  );
                                },
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
                  ),
                ),
                IndependentScrollbar(
                  controller: scrollbarController,
                  thickness: scrollbarThickness,
                  thumbRadius: Radius.circular(5),
                  color: AppTheme.of(
                    context,
                  )!.colorScheme.secondary.onColor.withAlpha(100),
                  hoveredColor: AppTheme.of(
                    context,
                  )!.colorScheme.secondary.onColor.withAlpha(125),
                  pressedColor: AppTheme.of(
                    context,
                  )!.colorScheme.secondary.onColor.withAlpha(150),
                ),
                SizedBox(width: safeMargin),
              ],
            );
          },
        );
      },
    );
  }
}


class SearchTipGrid extends StatefulWidget{
  final ParamBoxManager manager;
  final Nuan5Config? config;
  final SearchOption option;
  final String keyword;
  final void Function(String)? onSelect;

  const SearchTipGrid({
    super.key,
    required this.manager,
    this.config,
    required this.option,
    this.keyword = "",
    this.onSelect,
  });

  @override
  State<SearchTipGrid> createState() => _SearchTipGridState();
}
class _SearchTipGridState extends State<SearchTipGrid>{

  List<Widget> buildTagItem(){
    final List<Widget> res = [];

    for(final ParamTag tag in widget.manager.tagList){
      if(_match(tag.name, widget.keyword)){
        res.add(AppRawButton(
          onClick: (){
            widget.onSelect?.call(tag.name);
          },
          child: IntrinsicWidth(
            child: Container(
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
            ),
          ),
        ));
      }
    }

    return res;
  }

  List<Widget> buildOutfitItem(){
    final List<Widget> res = [];
    if(widget.config == null){
      return res;
    }
    final Nuan5Config config = widget.config!;

    for(final int outfit in config.clothOutfit.keys){
      final String name = trText(outfit.toString(), category: "cloth_outfit");
      if(_match(name, widget.keyword)){
        res.add(AppFloatingIndicatorButtonTarget(
          child: AppButton.smallText(
            onClick: (){
              widget.onSelect?.call(name);
            },
            child: Tooltip(
              message: name,
              child: AppText(name, overflow: TextOverflow.ellipsis),
            ),
          ),
        ));
      }
    }

    return res;
  }

  List<Widget> buildClothItem(){
    final List<Widget> res = [];
    if(widget.config == null){
      return res;
    }
    final Nuan5Config config = widget.config!;

    for(final int cloth in config.nikkiClothInfo.keys){
      final String name = trText(cloth.toString(), category: "cloth");
      if(_match(name, widget.keyword)){
        final int? clothType = config.cloth[cloth]?.clothType;

        res.add(AppFloatingIndicatorButtonTarget(
          child: AppButton.smallText(
            onClick: (){
              widget.onSelect?.call(name);
            },
            child: Row(
              spacing: listSpacing,
              children: [
                if(clothType != null)
                  Tooltip(
                    message: trText(clothType.toString(), category: "cloth_type"),
                    child: AppCachedNetworkImage(
                      imageUrl: config.getImageUrl(config.networkImage?.clothType, clothType) ?? "",
                      cacheKey: "cloth_type_$clothType",
                      width: 24,
                      height: 24,
                      color: AppColorScheme.of(context).byRole(ColorRole.of(context)).onDisabledColor,
                    ),
                  ),

                Expanded(
                  child: Tooltip(
                    message: name,
                    child: AppText(name, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    }

    return res;
  }

  List<Widget> buildClothPropItem(){
    final List<Widget> res = [];
    if(widget.config == null){
      return res;
    }
    final Nuan5Config config = widget.config!;

    for(final int prop in config.clothProp.keys){
      final String name = trText(prop.toString(), category: "cloth_prop");
      if(_match(name, widget.keyword)){
        res.add(AppRawButton(
          onClick: (){
            widget.onSelect?.call(name);
          },
          child: ClothPropText(
            propBackground: CachedNetworkImageProvider(
              config.getImageUrl(config.networkImage?.clothProp, prop) ?? "",
              cacheKey: "cloth_prop_$prop",
            ),
            propText: name,
          ),
        ));
      }
    }

    return res;
  }

  List<Widget> buildClothTagItem(){
    final List<Widget> res = [];
    if(widget.config == null){
      return res;
    }
    final Nuan5Config config = widget.config!;

    for(final MapEntry<int, Nuan5ClothTag> entry in config.clothTag.entries){
      final String name = trText(entry.key.toString(), category: "cloth_tag");
      if(_match(name, widget.keyword)){
        res.add(AppRawButton(
          onClick: (){
            widget.onSelect?.call(name);
          },
          child: ClothTagText(
            tagBackground: CachedNetworkImageProvider(
              config.getImageUrl(config.networkImage?.clothTag, entry.value.backgroundId) ?? "",
              cacheKey: "cloth_tag_${entry.value.backgroundId}",
            ),
            tagText: name,
            tagColor: entry.value.rgba,
          ),
        ));
      }
    }

    return res;
  }

  List<Widget> buildLightItem(){
    final List<Widget> res = [];
    if(widget.config == null){
      return res;
    }
    final Nuan5Config config = widget.config!;

    for(final int light in config.light.keys){
      final String name = trText(light.toString(), category: "light");
      if(_match(name, widget.keyword)){
        res.add(AppFloatingIndicatorButtonTarget(
          child: AppButton(
            borderRadius: smallBorderRadius,
            padding: const EdgeInsets.all(smallPadding),
            height: 120,
            onClick: (){
              widget.onSelect?.call(name);
            },
            child: Column(
              spacing: listSpacing,
              children: [
                AppCachedNetworkImage(
                  imageUrl: config.getImageUrl(config.networkImage?.light, light) ?? "",
                  cacheKey: light.toString(),
                  width: 80,
                ),

                Expanded(
                  child: Tooltip(
                    message: name,
                    child: AppText(name, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    }

    return res;
  }

  List<Widget> buildFilterItem(){
    final List<Widget> res = [];
    if(widget.config == null){
      return res;
    }
    final Nuan5Config config = widget.config!;

    for(final int filter in config.filter.keys){
      final String name = trText(filter.toString(), category: "filter");
      if(_match(name, widget.keyword)){
        res.add(AppFloatingIndicatorButtonTarget(
          child: AppButton(
            borderRadius: smallBorderRadius,
            padding: const EdgeInsets.all(smallPadding),
            height: 120,
            onClick: (){
              widget.onSelect?.call(name);
            },
            child: Column(
              spacing: listSpacing,
              children: [
                AppCachedNetworkImage(
                  imageUrl: config.getImageUrl(config.networkImage?.filter, filter) ?? "",
                  cacheKey: filter.toString(),
                  width: 80,
                ),

                Expanded(
                  child: Tooltip(
                    message: name,
                    child: AppText(name, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    }

    return res;
  }

  @override
  Widget build(BuildContext context){
    final double maxCrossAxisExtent = switch(widget.option){
      SearchOption.name => throw UnimplementedError(),
      SearchOption.tag => 150,
      SearchOption.clothesName => 150,
      SearchOption.outfitName => 150,
      SearchOption.clothPropName => 130,
      SearchOption.clothTagName => 100,
      SearchOption.light => 130,
      SearchOption.filter => 130,
    };

    final List<Widget> children = switch(widget.option){
      SearchOption.name => throw UnimplementedError(),
      SearchOption.tag => buildTagItem(),
      SearchOption.clothesName => buildClothItem(),
      SearchOption.outfitName => buildOutfitItem(),
      SearchOption.clothPropName => buildClothPropItem(),
      SearchOption.clothTagName => buildClothTagItem(),
      SearchOption.light => buildLightItem(),
      SearchOption.filter => buildFilterItem(),
    };

    return AppFloatingIndicatorButtonGroup(
      child: SmoothPointerScroll(
        builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
          return AlignedGridView.extent(
            controller: controller,
            physics: physics,
            maxCrossAxisExtent: maxCrossAxisExtent,
            itemCount: children.length,
            itemBuilder: (context, index){
              return children[index];
            },
          );
        },
      ),
    );
  }
}


bool _match(String source, String target){
  return source.contains(target);
}