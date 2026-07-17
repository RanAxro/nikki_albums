
import "package:nikki_albums/modules/nuan5_params/domain/tree_node_generator.dart";

import "../domain/camera_params_edit_controller.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/modules/nuan5_params/domain/selector_handler.dart";
import "package:nikki_albums/modules/nuan5_params/presentation/selector.dart";
import "package:nikki_albums/modules/nuan5_params/model/enumeration.dart";
import "package:nikki_albums/src/rust/nuan5_database/model.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/nikki_photo_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";


class CameraParamsEditPanel extends StatefulWidget{
  final CameraParamsEditController controller;
  final void Function(CameraParamsEditController)? onChanged;
  final Nuan5DatabaseReaderV1? reader;

  const CameraParamsEditPanel({
    super.key,
    required this.controller,
    this.onChanged,
    this.reader,
  });

  @override
  State<CameraParamsEditPanel> createState() => _CameraParamsEditPanelState();
}
class _CameraParamsEditPanelState extends State<CameraParamsEditPanel>{
  late CameraParamsEditController controller;

  void listener(){
    widget.onChanged?.call(controller);
  }

  @override
  void initState(){
    super.initState();
    controller = widget.controller;
    controller.addListener(listener);
  }

  @override
  void dispose(){
    controller.removeListener(listener);
    super.dispose();
  }


  final LightSelectorHandler lightSelectorHandler = const LightSelectorHandler();
  final FilterSelectorHandler filterSelectorHandler = const FilterSelectorHandler();
  final MomoPoseSelectorHandler momoPoseSelectorHandler = const MomoPoseSelectorHandler();

  Widget _buildSwitchCard({
    required BuildContext context,
    required Widget text,
    required bool Function() getValue,
    void Function(bool)? onChanged,
  }){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: smallPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(smallBorderRadius),
        color: AppColorScheme.of(context).byRole(ColorRole.of(context)).enabledColor,
      ),
      child: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child){
          return IgnorePointer(
            ignoring: !controller.allowEdit,
            child: AppSwitchButton(
              value: getValue(),
              onChanged: onChanged,
              child: text,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliderCard({
    required BuildContext context,
    required Widget text,
    double min = 0,
    double max = 1,
    int? divisions,
    bool usable = true,
    required double Function() getValue,
    String Function(double)? getDisplay,
    void Function(double)? onChanged,
  }){
    return Container(
      padding: const EdgeInsets.all(smallPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(smallBorderRadius),
        color: AppColorScheme.of(context).byRole(ColorRole.of(context)).enabledColor,
      ),
      child: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child){
          double value = getValue();

          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState){
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: text,
                      ),
                      AppText(getDisplay?.call(value) ?? value.toString()),
                    ],
                  ),
                  SizedBox(
                    height: smallButtonSize,
                    child: Center(
                      child: IgnorePointer(
                        ignoring: !usable || !controller.allowEdit,
                        child: AppSlider(
                          padding: const EdgeInsets.all(0),
                          min: min,
                          max: max,
                          divisions: divisions,
                          value: value,
                          onChanged: (newValue){
                            setState((){
                              value = newValue;
                            });
                          },
                          onChangeEnd: onChanged?.call,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSelectorCard<T>({
    required BuildContext context,
    required Widget text,
    Object? Function()? getValue,
    required String Function() getDisplay,
    required SelectorHandler selectorHandler,
    void Function(int?)? onChanged,
    required T? Function() isBuildZone,
    Widget Function(T)? zoneBuilder,
    String? Function(T)? getImageUrl,
    String? Function(T)? getCacheKey,
  }){
    void buildSelector(){
      showAppDialog(
        context: context,
        builder: (BuildContext context){
          return AppDialog(
            child: SizedBox(
              width: 700,
              height: 400,
              child: Column(
                spacing: listSpacing,
                children: [
                  Row(
                    children: [
                      block5W,

                      text,

                      Expanded(
                        child: Center(
                          child: ListenableBuilder(
                            listenable: controller,
                            builder: (BuildContext context, Widget? child){
                              return AppText(getDisplay());
                            },
                          ),
                        ),
                      ),

                      AppButton.smallIcon(
                        onClick: (){
                          Navigator.of(context).pop();
                        },
                        child: AppIcon("cross", height: 20),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Selector(
                      title: AppText.tr("infinity_nikki.media_params.light.name"),
                      handler: selectorHandler,
                      initValue: getValue?.call(),
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Container(
      padding: const EdgeInsets.all(smallPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(smallBorderRadius),
        color: AppColorScheme.of(context).byRole(ColorRole.of(context)).enabledColor,
      ),
      child: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child){
          final T? buildArgs = isBuildZone();

          return IgnorePointer(
            ignoring: !controller.allowEdit,
            child: Column(
              spacing: listSpacing,
              children: [
                AppButton.smallText(
                  onClick: buildSelector,
                  child: Row(
                    children: [
                      Expanded(child: text),
                      AppText(getDisplay()),
                    ],
                  ),
                ),

                if(buildArgs != null)
                  Builder(
                    builder: (BuildContext context){
                      final String? imageUrl = getImageUrl?.call(buildArgs);

                      return SizedBox(
                        height: 80,
                        child: Row(
                          children: [
                            block10W,

                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(child: block0),

                                  ?zoneBuilder?.call(buildArgs),
                                ],
                              ),
                            ),

                            imageUrl == null ? block0 : AppButton(
                              onClick: buildSelector,
                              child: AppCachedNetworkImage(
                                imageUrl: imageUrl,
                                cacheKey: getCacheKey?.call(buildArgs),
                                errorWidget: selectorHandler.imageErrorWidget,
                              ),
                            ),

                          ],
                        ),
                      );
                    },
                  ),

              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final Nuan5DatabaseReaderV1? reader = widget.reader;

    return SmoothPointerScroll(
      builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
        return SingleChildScrollView(
          controller: scrollController,
          physics: physics,
          child: Column(
            spacing: listSpacing,
            children: [
              _buildSwitchCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.portrait_mode"),
                getValue: () => controller.cameraParams.portraitMode,
                onChanged: (bool newValue) => controller.cameraParams = controller.cameraParams.copyWith(portraitMode: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.zoom"),
                min: 0.5,
                max: 4.0,
                getValue: () => 3.2,
                getDisplay: (double zoom) => "${zoom.toStringAsFixed(1)}x",
                onChanged: (double newValue){
                  
                },
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.focal_length"),
                getValue: () => controller.cameraParams.cameraFocalLength,
                getDisplay: (double focalLength) => (10 + focalLength * 45).toStringAsFixed(0),
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(cameraFocalLength: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.aperture_section.name"),
                min: 1,
                max: 15,
                getValue: () => controller.cameraParams.apertureSection.toDouble(),
                getDisplay: (double apertureSection) => tr("infinity_nikki.media_params.aperture_section.${ApertureSection.fromFlag(apertureSection.toInt()).name}"),
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(apertureSection: newValue.toInt()),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.vignette_intensity"),
                getValue: () => controller.cameraParams.vignetteIntensity,
                getDisplay: (double vignetteIntensity) => "${(vignetteIntensity * 100).toInt()}%",
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(vignetteIntensity: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.bloom_intensity"),
                getValue: () => controller.cameraParams.bloomIntensity,
                getDisplay: (double bloomIntensity) => "${(bloomIntensity * 100).toInt()}%",
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(bloomIntensity: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.bloom_threshold"),
                min: -1,
                getValue: () => controller.cameraParams.bloomThreshold,
                getDisplay: (double bloomThreshold) => bloomThreshold.toStringAsFixed(1),
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(bloomThreshold: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.brightness"),
                getValue: () => controller.cameraParams.brightness,
                getDisplay: (double brightness) => "${(brightness * 100).toInt()}%",
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(brightness: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.exposure"),
                min: -1,
                getValue: () => controller.cameraParams.exposure,
                getDisplay: (double exposure) => exposure.toStringAsFixed(1),
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(exposure: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.contrast"),
                getValue: () => controller.cameraParams.contrast,
                getDisplay: (double contrast) => "${(contrast * 100).toInt()}%",
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(contrast: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.saturation"),
                min: -1,
                getValue: () => controller.cameraParams.saturation,
                getDisplay: (double saturation) => saturation.toStringAsFixed(1),
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(saturation: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.vibrance"),
                min: -1,
                getValue: () => controller.cameraParams.vibrance,
                getDisplay: (double vibrance) => vibrance.toStringAsFixed(1),
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(vibrance: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.highlights"),
                min: -1,
                getValue: () => controller.cameraParams.highlights,
                getDisplay: (double highlights) => highlights.toStringAsFixed(1),
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(highlights: newValue),
              ),
              _buildSliderCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.shadows"),
                min: -1,
                getValue: () => controller.cameraParams.shadows,
                getDisplay: (double shadows) => shadows.toStringAsFixed(1),
                onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(shadows: newValue),
              ),

              _buildSelectorCard<LightParams_Some>(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.light.name"),
                getValue: () => controller.cameraParams.light.whenOrNull(some: (id, _) => id),
                getDisplay: (){
                  return controller.cameraParams.light.whenOrNull(
                    some: (paramId, strength){
                      final int? id = reader == null ? null : lightSelectorHandler.getInitValue(reader, paramId);
                      return id == null ? null : lightSelectorHandler.getValueText(id);
                    },
                  ) ?? trBool(false, index: 2);
                },
                selectorHandler: lightSelectorHandler,
                onChanged: (int? id) async{
                  if(id == null){
                    controller.cameraParams = controller.cameraParams.copyWith(
                      light: LightParams.none(),
                    );
                  }else{
                    final res = await reader?.get_(category: Nuan5DatabaseCategory.light, ids: [id]);
                    final String? paramId = res?[id]?.whenOrNull(
                      light: (lightData) => lightData.paramId,
                    );

                    if(paramId == null){
                      controller.cameraParams = controller.cameraParams.copyWith(
                        light: LightParams.none(),
                      );
                    }else{
                      controller.cameraParams = controller.cameraParams.copyWith(
                        light: LightParams.some(id: paramId, strength: 0.5),
                      );
                    }
                  }
                },
                isBuildZone: () => controller.cameraParams.light.mapOrNull(some: (LightParams_Some some) => some),
                zoneBuilder: (LightParams_Some lightSome){
                  return _buildSliderCard(
                    context: context,
                    text: AppText.tr("infinity_nikki.media_params.light_strength"),
                    getValue: () => lightSome.strength,
                    getDisplay: (double contrast) => "${(contrast * 100).toInt()}%",
                    onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(light: LightParams.some(id: lightSome.id, strength: newValue)),
                  );
                },
                getImageUrl: (LightParams_Some lightSome){
                  if(reader == null) return null;
                  final int? id = lightSelectorHandler.getInitValue(reader, lightSome.id);
                  return id == null ? null : lightSelectorHandler.getValueImageUrl(reader, id);
                },
                getCacheKey: (LightParams_Some lightSome){
                  if(reader == null) return null;
                  return lightSelectorHandler.getInitValue(reader, lightSome.id)?.toString();
                },
              ),

              _buildSelectorCard<FilterParams_Some>(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.filter.name"),
                getValue: () => controller.cameraParams.filter.whenOrNull(some: (id, _) => id),
                getDisplay: (){
                  return controller.cameraParams.filter.whenOrNull(
                    some: (paramId, strength){
                      final int? id = reader == null ? null : filterSelectorHandler.getInitValue(reader, paramId);
                      return id == null ? null : filterSelectorHandler.getValueText(id);
                    },
                  ) ?? trBool(false, index: 2);
                },
                selectorHandler: filterSelectorHandler,
                onChanged: (int? id) async{
                  if(id == null){
                    controller.cameraParams = controller.cameraParams.copyWith(
                      filter: FilterParams.none(),
                    );
                  }else{
                    final res = await reader?.get_(category: Nuan5DatabaseCategory.filter, ids: [id]);
                    final String? paramId = res?[id]?.whenOrNull(
                      filter: (filterData) => filterData.paramId,
                    );

                    if(paramId == null){
                      controller.cameraParams = controller.cameraParams.copyWith(
                        filter: FilterParams.none(),
                      );
                    }else{
                      controller.cameraParams = controller.cameraParams.copyWith(
                        filter: FilterParams.some(id: paramId, strength: 1),
                      );
                    }
                  }
                },
                isBuildZone: () => controller.cameraParams.filter.mapOrNull(some: (FilterParams_Some some) => some),
                zoneBuilder: (FilterParams_Some filterSome){
                  return _buildSliderCard(
                    context: context,
                    text: AppText.tr("infinity_nikki.media_params.filter_strength"),
                    getValue: () => filterSome.strength,
                    getDisplay: (double contrast) => "${(contrast * 100).toInt()}%",
                    onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWith(filter: FilterParams.some(id: filterSome.id, strength: newValue)),
                  );
                },
                getImageUrl: (FilterParams_Some filterSome){
                  if(reader == null) return null;
                  final int? id = filterSelectorHandler.getInitValue(reader, filterSome.id);
                  return id == null ? null : filterSelectorHandler.getValueImageUrl(reader, id);
                },
                getCacheKey: (FilterParams_Some filterSome){
                  if(reader == null) return null;
                  return filterSelectorHandler.getInitValue(reader, filterSome.id)?.toString();
                },
              ),

              _buildSwitchCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.momo_hidden"),
                getValue: () => controller.cameraParams.momo?.map(enable: (_) => true, disable: (_) => false) ?? true,
                onChanged: (bool value){
                  if(value){
                    controller.cameraParams = controller.cameraParams.copyWithMomo(
                      momo: CameraParamsMomoHidden.enable(),
                    );
                  }else{
                    controller.cameraParams = controller.cameraParams.copyWithMomo(
                      momo: defaultCameraParamsMomo,
                    );
                  }
                },
              ),

              ListenableBuilder(
                listenable: controller,
                builder: (BuildContext context, Widget? child){
                  if(controller.cameraParams.momo == null){
                    return block0;
                  }

                  return controller.cameraParams.momo!.map(
                    enable: (_){
                      return block0;
                    },
                    disable: (CameraParamsMomoHidden_Disable momoHiddenDisable){
                      return Column(
                        spacing: listSpacing,
                        children: [
                          _buildSelectorCard<int>(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.momo_pose"),
                            getValue: () => momoHiddenDisable.momoPose,
                            getDisplay: () => momoPoseSelectorHandler.getValueText(momoHiddenDisable.momoPose),
                            selectorHandler: momoPoseSelectorHandler,
                            onChanged: (int? id) async{
                              controller.cameraParams = controller.cameraParams.copyWithMomo(
                                momo: momoHiddenDisable.copyWithDisable(momoPose: id ?? 0),
                              );
                            },
                            isBuildZone: () => momoHiddenDisable.momoPose == 0 ? null : momoHiddenDisable.momoPose,
                            zoneBuilder: (int momoPose){
                              return _buildSliderCard(
                                context: context,
                                text: AppText(""),
                                getValue: () => 0,
                                getDisplay: (double time) => "$time s",
                                usable: false,
                              );
                            },
                            getImageUrl: (int momoPose){
                              if(reader == null) return null;
                              return momoPoseSelectorHandler.getValueImageUrl(reader, momoPose);
                            },
                            getCacheKey: (int momoPose) => momoPose.toString(),
                          ),
                          _buildSwitchCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.pose_with_nikki"),
                            getValue: () => momoHiddenDisable.poseWithNikki,
                            onChanged: (bool value) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(poseWithNikki: value)),
                          ),
                          _buildSliderCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.horizontal"),
                            min: -400,
                            max: 400,
                            getValue: () => momoHiddenDisable.horizontal,
                            getDisplay: (double horizontal) => horizontal.toStringAsFixed(0),
                            onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(horizontal: newValue)),
                          ),
                          _buildSliderCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.distance"),
                            min: -400,
                            max: 400,
                            getValue: () => momoHiddenDisable.distance,
                            getDisplay: (double distance) => distance.toStringAsFixed(0),
                            onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(distance: newValue)),
                          ),
                          _buildSliderCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.height"),
                            min: -400,
                            max: 400,
                            getValue: () => momoHiddenDisable.height,
                            getDisplay: (double height) => height.toStringAsFixed(0),
                            onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(height: newValue)),
                          ),
                          _buildSliderCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.rotate_momo"),
                            min: -180,
                            max: 180,
                            getValue: () => momoHiddenDisable.rotateMomo,
                            getDisplay: (double rotateMomo) => rotateMomo.toStringAsFixed(0),
                            onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(rotateMomo: newValue)),
                          ),
                          _buildSwitchCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.auto_ground_snap"),
                            getValue: () => momoHiddenDisable.autoGroundSnap,
                            onChanged: (bool value) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(autoGroundSnap: value)),
                          ),
                          _buildSwitchCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.floating_effect"),
                            getValue: () => momoHiddenDisable.floatingEffect,
                            onChanged: (bool value) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(floatingEffect: value)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              const SizedBox(
                height: 100,
              ),
            ],
          ),
        );
      },
    );
  }
}