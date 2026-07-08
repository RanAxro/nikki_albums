
import "package:nikki_albums/src/rust/nuan5_database/reader_v1.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";

import "../domain/camera_params_edit_controller.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/modules/nuan5_params/domain/selector_handler.dart";
import "package:nikki_albums/modules/nuan5_params/presentation/selector.dart";
import "package:nikki_albums/modules/nuan5_params/model/enumeration.dart";
import "package:nikki_albums/src/rust/nuan5_database/model.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/nikki_photo_params.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";


class CameraParamsEditPanel extends StatelessWidget{
  final CameraParamsEditController controller;

  const CameraParamsEditPanel({
    super.key,
    required this.controller,
  });

  Widget _buildSwitchCard({
    required BuildContext context,
    required Widget text,
    required bool Function() getValue,
    void Function(bool)? onChanged,
  }){
    return Container(
      padding: const EdgeInsets.all(smallPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(smallBorderRadius),
        color: AppColorScheme.of(context).byRole(ColorRole.of(context)).enabledColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: text,
          ),
          ListenableBuilder(
            listenable: controller,
            builder: (BuildContext context, Widget? child){
              return AppSwitchButton(
                value: getValue(),
                onChanged: onChanged,
                usable: controller.allowEdit,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliderCard({
    required BuildContext context,
    required Widget text,
    double min = 0,
    double max = 1,
    int? divisions,
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
                        onChangeEnd: controller.allowEdit ? onChanged?.call : null,
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

  // Widget _buildDropdownCard({
  //   required BuildContext context,
  //   required Widget text,
  //   required bool Function() getValue,
  //   void Function(bool)? onChanged,
  // }){
  //   return Container(
  //     padding: const EdgeInsets.all(smallPadding),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(smallBorderRadius),
  //       color: AppColorScheme.of(context).byRole(ColorRole.of(context)).enabledColor,
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: text,
  //         ),
  //         ListenableBuilder(
  //           listenable: controller,
  //           builder: (BuildContext context, Widget? child){
  //             return AppDropdown(
  //               childrenBuilder: (BuildContext context, MenuController menuController){
  //
  //               },
  //               // value: getValue(),
  //               // onChanged: onChanged,
  //               // usable: controller.allowEdit,
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context){
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

              Container(
                padding: const EdgeInsets.all(smallPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(smallBorderRadius),
                  color: AppColorScheme.of(context).byRole(ColorRole.of(context)).enabledColor,
                ),
                child: AppButton.smallText(
                  onClick: (){
                    showAppDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AppDialog(
                          child: Selector(
                            title: AppText.tr("infinity_nikki.media_params.light.name"),
                            handler: LightSelectorHandler(),
                            initValue: controller.cameraParams.light.whenOrNull(some: (id, _) => id),
                            onChanged: (int? id) async{
                              await Nuan5Data.init();

                              if(id == null){
                                controller.cameraParams = controller.cameraParams.copyWith(
                                  light: LightParams.none(),
                                );
                              }else{
                                final res = await Nuan5Data.reader?.get_(category: Nuan5DatabaseCategory.light, ids: [id]);
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
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText.tr("infinity_nikki.media_params.light.name"),
                      ),
                      ListenableBuilder(
                        listenable: controller,
                        builder: (BuildContext context, Widget? child){
                          return AppText(controller.cameraParams.light.whenOrNull(
                            some: (id, strength){
                              return id.toString();
                            },
                          ) ?? "无");
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(smallPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(smallBorderRadius),
                  color: AppColorScheme.of(context).byRole(ColorRole.of(context)).enabledColor,
                ),
                child: AppButton.smallText(
                  onClick: (){
                    showAppDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AppDialog(
                          child: Selector(
                            title: AppText.tr("infinity_nikki.media_params.filter.name"),
                            handler: FilterSelectorHandler(),
                            initValue: controller.cameraParams.filter.whenOrNull(some: (id, _) => id),
                            onChanged: (int? id) async{
                              await Nuan5Data.init();

                              if(id == null){
                                controller.cameraParams = controller.cameraParams.copyWith(
                                  filter: FilterParams.none(),
                                );
                              }else{
                                final res = await Nuan5Data.reader?.get_(category: Nuan5DatabaseCategory.filter, ids: [id]);
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
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText.tr("infinity_nikki.media_params.filter.name"),
                      ),
                      ListenableBuilder(
                        listenable: controller,
                        builder: (BuildContext context, Widget? child){
                          return AppText(controller.cameraParams.filter.whenOrNull(
                            some: (id, strength){
                              return id.toString();
                            },
                          ) ?? "无");
                        },
                      ),
                    ],
                  ),
                ),
              ),

              _buildSwitchCard(
                context: context,
                text: AppText.tr("infinity_nikki.media_params.momo_hidden"),
                getValue: () => controller.cameraParams.momo?.when(enable: () => true, disable: (_, _, _, _, _, _, _, _) => false) ?? true,
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

                  return controller.cameraParams.momo!.when(
                    enable: (){
                      return block0;
                    },
                    disable: (
                      momoPose,
                      horizontal,
                      distance,
                      height,
                      rotateMomo,
                      autoGroundSnap,
                      floatingEffect,
                      poseWithNikki,
                    ){
                      return Column(
                        spacing: listSpacing,
                        children: [
                          _buildSliderCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.horizontal"),
                            min: -400,
                            max: 400,
                            getValue: () => horizontal,
                            getDisplay: (double horizontal) => horizontal.toStringAsFixed(0),
                            onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(horizontal: newValue)),
                          ),
                          _buildSliderCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.distance"),
                            min: -400,
                            max: 400,
                            getValue: () => distance,
                            getDisplay: (double distance) => distance.toStringAsFixed(0),
                            onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(distance: newValue)),
                          ),
                          _buildSliderCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.height"),
                            min: -400,
                            max: 400,
                            getValue: () => height,
                            getDisplay: (double height) => height.toStringAsFixed(0),
                            onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(height: newValue)),
                          ),
                          _buildSliderCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.rotate_momo"),
                            min: -180,
                            max: 180,
                            getValue: () => rotateMomo,
                            getDisplay: (double rotateMomo) => rotateMomo.toStringAsFixed(0),
                            onChanged: (double newValue) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(rotateMomo: newValue)),
                          ),
                          _buildSwitchCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.auto_ground_snap"),
                            getValue: () => autoGroundSnap,
                            onChanged: (bool value) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(autoGroundSnap: value)),
                          ),
                          _buildSwitchCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.floating_effect"),
                            getValue: () => floatingEffect,
                            onChanged: (bool value) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(floatingEffect: value)),
                          ),
                          _buildSwitchCard(
                            context: context,
                            text: AppText.tr("infinity_nikki.media_params.pose_with_nikki"),
                            getValue: () => poseWithNikki,
                            onChanged: (bool value) => controller.cameraParams = controller.cameraParams.copyWithMomo(momo: (controller.cameraParams.momo ?? defaultCameraParamsMomo).copyWithDisable(poseWithNikki: value)),
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