
import "../model/tree_node.dart";
import "../model/enumeration.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/nikki_photo_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/clock_in_photo_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/collage_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/utils/clipboard.dart";

import "package:flutter/material.dart" hide ColorSwatch;

import "package:easy_localization/easy_localization.dart";


String trText(String key, {String category = "media_params"}){
  final String complete = "infinity_nikki.$category.$key";
  
  /// 使用trExit 后，无法使用回退语言
  // return trExists(complete) ? tr(complete) : key;
  return tr(complete) == complete ? key : tr(complete);
}

String trBool(bool key, {int index = 1, String category = "media_params"}){
  final String complete = "infinity_nikki.$category.${key}_$index";

  /// 使用trExit 后，无法使用回退语言
  // return trExists(complete) ? tr(complete) : key.toString();
  return tr(complete) == complete ? key.toString() : tr(complete);
}

Color convertColor((double, double, double, double) color){
  return Color.fromARGB(
    (255 * color.$4).toInt(),
    (255 * color.$1).toInt(),
    (255 * color.$2).toInt(),
    (255 * color.$3).toInt(),
  );
}

TreeNode genNikkiPhotoParams(NikkiPhotoParams params){
  return TreeNode(
    title: trText("nikki_photo_params"),
    initiallyExpanded: true,
    children: [
      genPhotographyParams(params.photography),
      if(params.camera != null)
        genCameraParams(params.camera!),
      if(params.nikki != null)
        genNikkiParams(params.nikki!),
      if(params.momo != null)
        genMomoHiddenState(params.momo!),
    ],
  );
}

TreeNode genClockInPhotoParams(ClockInPhotoParams params){
  return TreeNode(
    title: trText("clock_in_photo_params"),
    initiallyExpanded: true,
    children: [
      TreeNode(
        title: trText("expedition"),
        message: trText(params.tag.toString(), category: "expedition"),
      ),
      genPhotographyParams(params.photography),
      if(params.camera != null)
        genCameraParams(params.camera!),
      if(params.nikki != null)
        genNikkiParams(params.nikki!),
      if(params.momo != null)
        genMomoHiddenState(params.momo!),
    ],
  );
}

TreeNode genCollageParams(CollageParams params){
  return TreeNode(
    title: trText("collage_params"),
    initiallyExpanded: true,
    children: [
      TreeNode(
        title: trText("template_id"),
        message: trText(params.templateId.toString(), category: "template_id"),
      ),
      ...params.regionPictures.map((RegionPicture regionPicture){
        return TreeNode(
          title: trText("zone"),
          message: params.regionPictures.indexOf(regionPicture).toString(),
          children: [
            TreeNode(
              title: trText("loc"),
              message: regionPicture.position.toString(),
            ),
            TreeNode(
              title: trText("rot"),
              message: regionPicture.rotation.toStringAsFixed(1),
            ),
            TreeNode(
              title: trText("scale"),
              message: regionPicture.scale.toStringAsFixed(1),
            ),
            TreeNode(
              title: trText("image_id"),
              message: regionPicture.imageId,
            ),
            genNikkiPhotoParams(regionPicture.oriCustomData),
          ],
        );
      }),
    ],
  );
}

TreeNode genDiyParams(ClothDiyParams params){
  return TreeNode(
    title: trText("diy_params"),
    initiallyExpanded: true,
    children: [
      TreeNode(
        title: trText("pose"),
        message: trText(params.poseId.toString(), category: "pose"),
      ),
      TreeNode(
        title: trText("dressing"),
        initiallyExpanded: true,
        children: params.clothes.map(genClothParams),
      ),
    ],
  );
}

TreeNode genPhotographyParams(PhotographyParams params){
  return TreeNode(
    title: trText("photography_params"),
    children: [
      params.edit.when(
        enabled: (EditPhotoParams editPhotoParams){
          return TreeNode(
            title: trText("edit"),
            children: [
              TreeNode(
                title: trText("has_sticker"),
                message: trBool(editPhotoParams.hasSticker),
              ),
              TreeNode(
                title: trText("has_text"),
                message: trBool(editPhotoParams.hasText),
              ),
            ],
          );
        },
        disabled: (){
          return TreeNode(
            title: trText("edit"),
            message: trBool(false),
          );
        },
      ),

      if(params.date != null)
        TreeNode(
          title: trText("date"),
          message: params.date!.day.toString(),
        ),

      if(params.time != null)
        TreeNode(
          title: trText("time"),
          message: "${params.time!.hour} : ${params.time!.min} : ${params.time!.sec.toInt()}",
        ),

      if(params.location != null)
        TreeNode(
          title: trText("location"),
          icon: Builder(
            builder: (BuildContext context){
              return Icon(Icons.map, color: AppColorScheme.of(context).byRole(ColorRole.of(context)).onEnabledColor);
            },
          ),
          /// TODO
          tooltip: trText("click_to_view_map", category: "common"),
          message: trText("location_m"),
          onClick: (BuildContext context){
            AppToast.showMessage(
              context: frameKey.currentContext!,
              message: trText("lack_data", category: "common"),
              state: false,
            );
          },
        ),

      if(params.weather != null)
        TreeNode(
          title: trText("weather.name"),
          message: trText("weather.${Weather.fromFlag(params.weather).name}"),
        ),

      TreeNode(
        title: trText("photo_wall"),
        message: params.photoWall.isEmpty ? trBool(false, index: 2) : null,
        initiallyExpanded: true,
        children: params.photoWall.map((id){
          return TreeNode(
            title: trText(id.toString(), category: "photo_wall"),
          );
        }),
      ),

      TreeNode(
        title: trText("task"),
        message: params.task.isEmpty ? trBool(false, index: 2) : null,
        initiallyExpanded: true,
        children: params.task.map((TaskParams taskParams){
          return taskParams.when(
            puzzle: (int puzzle){
              return TreeNode(
                title: trText("puzzle"),
                message: trText(puzzle.toString(), category: "puzzle"),
              );
            },
            risk: (Map<int, bool> risk){
              return TreeNode(
                title: trText("risk"),
                message: risk.isEmpty ? trBool(false) : null,
                initiallyExpanded: true,
                children: risk.keys.map((int id){
                  return TreeNode(
                    title: trText(id.toString(), category: "risk"),
                    message: trBool(risk[id]!, index: 3),
                  );
                }),
              );
            },
            interactive: (Map<int, bool> interactive){
              return TreeNode(
                title: trText("interactive"),
                message: interactive.isEmpty ? trBool(false) : null,
                initiallyExpanded: true,
                children: interactive.keys.map((int id){
                  return TreeNode(
                    title: trText(id.toString(), category: "interactive"),
                    message: trBool(interactive[id]!, index: 3),
                  );
                }),
              );
            },
          );
        }),
      ),

    ],
  );
}

TreeNode genCameraParams(RichCameraParams params){
  return TreeNode(
    title: trText("camera_params"),
    initiallyExpanded: true,
    children: [
      TreeNode(
        tooltip: trText("click_to_copy_param", category: "common"),
        title: trText("momo_camera_params"),
        icon: Builder(
          builder: (BuildContext context){
            return Icon(Icons.copy, color: AppColorScheme.of(context).byRole(ColorRole.of(context)).onEnabledColor);
          },
        ),
        message: params.params,
        onClick: (BuildContext context) async{
          try{
            await copyTextToClipboard(params.params);
            AppToast.showMessage(
              context: frameKey.currentContext!,
              message: tr("pa_copy_successful"),
            );
          }catch(e){
            AppToast.showMessage(
              context: frameKey.currentContext!,
              message: tr("pa_copy_failed"),
              state: false,
            );
          }
        }
      ),
      TreeNode(
        title: trText("portrait_mode"),
        message: trBool(params.portraitMode, index: 4),
      ),
      TreeNode(
        title: trText("zoom"),
        message: "${params.zoom.toStringAsFixed(1)}x",
      ),
      TreeNode(
        title: trText("focal_length"),
        message: params.focalLength.toStringAsFixed(0),
      ),
      TreeNode(
        title: trText("rotation"),
        message: params.rotation.toStringAsFixed(0),
      ),
      TreeNode(
        title: trText("aperture_section.name"),
        message: trText("aperture_section.${ApertureSection.fromFlag(params.apertureSection).name}"),
      ),
      TreeNode(
        title: trText("vignette_intensity"),
        message: "${(params.vignetteIntensity * 100).toInt()}%",
      ),
      TreeNode(
        title: trText("bloom_intensity"),
        message: "${(params.bloomIntensity * 100).toInt()}%",
      ),
      TreeNode(
        title: trText("bloom_threshold"),
        message: params.bloomThreshold.toStringAsFixed(1),
      ),
      TreeNode(
        title: trText("brightness"),
        message: "${(params.brightness * 100).toInt()}%",
      ),
      TreeNode(
        title: trText("exposure"),
        message: params.exposure.toStringAsFixed(1),
      ),
      TreeNode(
        title: trText("contrast"),
        message: "${(params.contrast * 100).toInt()}%",
      ),
      TreeNode(
        title: trText("saturation"),
        message: params.saturation.toStringAsFixed(1),
      ),
      TreeNode(
        title: trText("vibrance"),
        message: params.vibrance.toStringAsFixed(1),
      ),
      TreeNode(
        title: trText("highlights"),
        message: params.highlights.toStringAsFixed(1),
      ),
      TreeNode(
        title: trText("shadows"),
        message: params.shadows.toStringAsFixed(1),
      ),
      ...params.light.when(
        some: (String id, double strength){
          return [
            TreeNode(
              title: trText("light"),
              message: trText(id, category: "light"),
            ),
            TreeNode(
              title: trText("light_strength"),
              message: "${(strength * 100).toInt()}%",
            ),
          ];
        },
        none: (){
          return [
            TreeNode(
              title: trText("light"),
              message: trBool(false, index: 2),
            ),
          ];
        }
      ),
      ...params.filter.when(
        some: (String id, double strength){
          return [
            TreeNode(
              title: trText("filter"),
              message: trText(id, category: "filter"),
            ),
            TreeNode(
              title: trText("filter_strength"),
              message: "${(strength * 100).toInt()}%",
            ),
          ];
        },
        none: (){
          return [
            TreeNode(
              title: trText("filter"),
              message: trBool(false, index: 2),
            ),
          ];
        }
      ),
      TreeNode(
        title: trText("pose"),
        message: trText(params.pose.toString(), category: "pose"),
      ),
      TreeNode(
        title: trText("framed_moment"),
        message: trText(params.framedMoment.toString(), category: "framed_moment"),
      ),

      if(params.momo != null)
        ...params.momo!.when(
          enable: (){
            return [
              TreeNode(
                title: trText("momo_hidden"),
                message: trBool(true, index: 4),
              ),
            ];
          },
          disable: (
            int momoPose,
            double horizontal,
            double distance,
            double height,
            double rotateMomo,
            bool autoGroundSnap,
            bool floatingEffect,
            bool poseWithNikki,
          ){
            return [
              TreeNode(
                title: trText("momo_hidden"),
                message: trBool(false, index: 4),
              ),
              TreeNode(
                title: trText("momo_pose"),
                message: trText(momoPose.toString(), category: "momo_pose"),
              ),
              TreeNode(
                title: trText("horizontal"),
                message: horizontal.toStringAsFixed(0),
              ),
              TreeNode(
                title: trText("distance"),
                message: distance.toStringAsFixed(0),
              ),
              TreeNode(
                title: trText("height"),
                message: height.toStringAsFixed(0),
              ),
              TreeNode(
                title: trText("rotate_momo"),
                message: rotateMomo.toStringAsFixed(0),
              ),
              TreeNode(
                title: trText("auto_ground_snap"),
                message: trBool(autoGroundSnap, index: 4),
              ),
              TreeNode(
                title: trText("floating_effect"),
                message: trBool(floatingEffect, index: 4),
              ),
              TreeNode(
                title: trText("pose_with_nikki"),
                message: trBool(poseWithNikki, index: 4),
              ),
            ];
          }
        ),
    ]
  );
}

TreeNode genNikkiParams(NikkiParams params){
  return TreeNode(
    title: trText("nikki_params"),
    initiallyExpanded: true,
    children: [
      TreeNode(
        title: trText("giant_state"),
        message: trBool(params.giantState, index: 4)
      ),
      TreeNode(
        title: trText("hidden"),
        message: trBool(params.giantState, index: 4)
      ),
      TreeNode(
        title: trText("dressing"),
        initiallyExpanded: true,
        children:[
          ...params.dressing.clothes.map(genClothParams),

          TreeNode(
            title: trText("eureka"),
            message: params.dressing.eureka.isEmpty ? trBool(false, index: 2) : null,
            children: params.dressing.eureka.map((eureka){
              return TreeNode(
                title: "eureka_attachment_point.${EurekaAttachmentPoint.fromFlag(eureka.attachmentPoint).name}",
                message: trText(eureka.id.toString(), category: "eureka"),
                children: [
                  TreeNode(
                    title: "outfit",
                    message: trText(eureka.outfit.toString(), category: "eureka_outfit"),
                  ),
                  TreeNode(
                    title: "level",
                    message: eureka.level.toString(),
                  ),
                  TreeNode(
                    title: "color",
                    message: eureka.color.toString(),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
      if(params.weapon != null)
        TreeNode(
          title: trText("weapon"),
          message: trText(params.weapon!.id.toString(), category: "weapon"),
          children: [
            TreeNode(
              title: trText("slot_type"),
              message: trText(params.weapon!.slotType, category: "slot_type"),
            ),
            if(params.weapon!.state != null)
              TreeNode(
                title: trText("weapon_state"),
                message: params.weapon!.state!,
              ),
          ],
        ),

      TreeNode(
        title: trText("interactions"),
        message: params.interactions.isEmpty ? trBool(false, index: 2) : null,
        children: params.interactions.map((ObjectParams objectParams){
          return TreeNode(
            title: trText(objectParams.id.toString(), category: "interactions"),
            children: [
              TreeNode(
                title: trText("loc"),
                message: objectParams.loc.toString(),
              ),
              TreeNode(
                title: trText("rot"),
                message: objectParams.rot.toString(),
              ),
              TreeNode(
                title: trText("scale"),
                message: objectParams.scale.toString(),
              ),
            ],
          );
        }),
      ),
      TreeNode(
        title: trText("mount"),
        message: params.mount == null ? trBool(false, index: 2) : trText(params.mount!.id.toString(), category: "mount"),
        children: params.mount == null ? const [] :[
          TreeNode(
            title: trText("loc"),
            message: params.mount!.loc.toString(),
          ),
          TreeNode(
            title: trText("rot"),
            message: params.mount!.rot.toString(),
          ),
          TreeNode(
            title: trText("scale"),
            message: params.mount!.scale.toString(),
          ),
        ],
      ),
      TreeNode(
        title: trText("carrier"),
        message: params.carrier == null ? trBool(false, index: 2) : trText(params.carrier!.id.toString(), category: "carrier"),
        children: params.carrier == null ? const [] :[
          TreeNode(
            title: trText("loc"),
            message: params.carrier!.loc.toString(),
          ),
          TreeNode(
            title: trText("rot"),
            message: params.carrier!.rot.toString(),
          ),
          TreeNode(
            title: trText("scale"),
            message: params.carrier!.scale.toString(),
          ),
        ],
      ),
      TreeNode(
        title: trText("loc"),
        message: params.loc.toString(),
      ),
      TreeNode(
        title: trText("rot"),
        message: params.rot.toString(),
      ),
      TreeNode(
        title: trText("scale"),
        message: params.scale.toString(),
      ),

    ],
  );
}

TreeNode genClothParams(ClothParams params){
  return TreeNode(
    title: trText("cloth_type.${ClothType.fromFlag(params.cloth.clothType).name}"),
    message: trText(params.cloth.id.toString(), category: "cloth"),
    children: [
      if(params.cloth.outfit != null)
        TreeNode(
          title: trText("outfit"),
          message: trText(params.cloth.outfit.toString(), category: "cloth_outfit"),
        ),
      TreeNode(
        title: trText("nikki_cloth_state.name"),
        message: trText("nikki_cloth_state.${NikkiClothState.fromFlag(params.cloth.state).name}"),
      ),
      TreeNode(
        title: trText("diy"),
        message: params.diy == null ? trBool(false, index: 2) : null,
        initiallyExpanded: true,
        children: params.diy == null ? const [] : [
          if(params.diy!.outfitDye.isNotEmpty)
            TreeNode(
              title: trText("outfit_dye"),
              children: params.diy!.outfitDye.map((OutfitDyeData outfitDyeData){
                return outfitDyeData.when(
                  hair: (OutfitDyeHairData outfitDyeHairData){
                    return TreeNode(
                      title: trText("diy_zone"),
                      message: "${outfitDyeHairData.targetGroupId}-${outfitDyeHairData.featureTag}",
                      children: [
                        TreeNode(
                          title: trText("color_1"),
                          icon: ColoredBox(color: convertColor(outfitDyeHairData.color0.color)),
                          children: genColorGrid(outfitDyeHairData.color0.colorGrid),
                        ),
                        if(outfitDyeHairData.color1 != null)
                          TreeNode(
                            title: trText("color_2"),
                            icon: ColoredBox(color: convertColor(outfitDyeHairData.color1!.color)),
                            children: genColorGrid(outfitDyeHairData.color1!.colorGrid),
                          ),

                        TreeNode(
                          title: trText("glossiness"),
                          message: (1 - outfitDyeHairData.roughness).toStringAsFixed(1),
                        ),
                        TreeNode(
                          title: trText("roughness"),
                          message: outfitDyeHairData.roughness.toStringAsFixed(1),
                        ),
                        TreeNode(
                          title: trText("color_mode"),
                          message: outfitDyeHairData.colorMode.toString(),
                        ),
                      ],
                    );
                  },
                  general: (OutfitDyeGeneralData outfitDyeGeneralData){
                    return TreeNode(
                      title: trText("diy_zone"),
                      message: "${outfitDyeGeneralData.targetGroupId}-${outfitDyeGeneralData.featureTag}",
                      children: [
                        TreeNode(
                          title: trText("color"),
                          icon: ColoredBox(color: convertColor(outfitDyeGeneralData.color.color)),
                          children: genColorGrid(outfitDyeGeneralData.color.colorGrid),
                        ),
                      ],
                    );
                  }
                );
              }),
            ),

          if(params.diy!.specialEffect.isNotEmpty)
            TreeNode(
              title: trText("special_effect"),
              children: params.diy!.specialEffect.map((SpecialEffectData specialEffectData){
                return TreeNode(
                  title: trText("diy_zone"),
                  message: "${specialEffectData.targetGroupId}-${specialEffectData.featureTag}",
                  children: [
                    TreeNode(
                      title: trText("color"),
                      children: genColorGrid(specialEffectData.colorGrid),
                    ),
                    TreeNode(
                      title: trText("cover_diy_color"),
                      message: trBool(specialEffectData.coverDiyColor, index: 5),
                    ),
                  ],
                );
              }),
            ),

          if(params.diy!.patternCreation.isNotEmpty)
            TreeNode(
              title: trText("pattern_creation"),
              children: params.diy!.patternCreation.map((PatternCreationData patternCreation){
                return TreeNode(
                  title: trText("diy_zone"),
                  message: "${patternCreation.targetGroupId}-${patternCreation.featureTag}",
                  children: [
                    TreeNode(
                      title: trText("texture"),
                      message: trText(patternCreation.textureId.toString(), category: "pattern_creation_texture"),
                    ),
                    TreeNode(
                      title: trText("override_pattern_a"),
                      message: trBool(patternCreation.overridePatternA, index: 6),
                    ),
                    TreeNode(
                      title: trText("tiling"),
                      message: patternCreation.tiling.toStringAsFixed(1),
                    ),
                  ],
                );
              }),
            ),
        ]
      ),
    ],
  );
}

TreeNode genMomoHiddenState(MomoHiddenState params){
  return params.when(
    enabled: (){
      return TreeNode(
        title: trText("momo_hidden_state"),
        message: trBool(true, index: 4),
      );
    },
    disabled: (MomoParams momoParams){
      return TreeNode(
        title: trText("momo_params"),
        children: [
          ...momoParams.clothes.map((ClothParams clothParams){
            return TreeNode(
              title: trText(clothParams.cloth.id.toString(), category: "cloth"),
            );
          }),
          TreeNode(
            title: trText("loc"),
            message: momoParams.loc.toString(),
          ),
          TreeNode(
            title: trText("rot"),
            message: momoParams.rot.toString(),
          ),
          TreeNode(
            title: trText("scale"),
            message: momoParams.scale.toString(),
          ),
        ],
      );
    },
  );
}

Iterable<TreeNode> genColorGrid(int grid){
  return [
    TreeNode(
      title: trText("color_palette.name"),
      message: trText("color_palette.${ColorPalette.fromFlag(grid == -1 ? 0 : 1 + grid ~/ 8)}"),
    ),
    if(grid != -1)
      TreeNode(
        title: trText("color_swatch.name"),
        message: trText("color_swatch.${ColorSwatch.fromFlag(1 + grid % 8)}"),
      ),
  ];
}








