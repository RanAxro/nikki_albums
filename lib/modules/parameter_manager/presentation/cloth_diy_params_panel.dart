
import "package:nikki_albums/modules/nuan5_params/domain/config.dart";
import "package:nikki_albums/modules/nuan5_params/model/cloth_diy.dart";
import "package:nikki_albums/modules/nuan5_params/model/enumeration.dart";
import "package:nikki_albums/modules/nuan5_params/domain/cloth_diy_handler.dart";
import "package:nikki_albums/modules/nuan5_params/domain/tree_node_generator.dart";
import "package:nikki_albums/src/rust/nuan5_params/decrypt.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/nikki_photo_params.dart";
import "package:nikki_albums/utils/clipboard.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart" hide ColorSwatch;
import "dart:collection";

import "package:easy_localization/easy_localization.dart";
import "package:super_tooltip/super_tooltip.dart";


class _TableRowBox{
  final int? zone;
  final TableRow child;

  const _TableRowBox({
    required this.zone,
    required this.child,
  });
}

class ClothDiyParamsPanel extends StatelessWidget{
  final String shareCode;
  final ClothDiyParams clothDiyParams;
  final Nuan5Config? config;

  const ClothDiyParamsPanel({
    super.key,
    required this.shareCode,
    required this.clothDiyParams,
    required this.config,
  });

  final ClothDiyHandler handler = const ClothDiyHandler();

  static const Map<int, TableColumnWidth> _outfitDyeTableColumnWidth = {
    0: IntrinsicColumnWidth(),
    1: IntrinsicColumnWidth(),
    2: FlexColumnWidth(),
    3: FlexColumnWidth(),
    4: IntrinsicColumnWidth(),
  };

  static const Map<int, TableColumnWidth> _specialEffectTableColumnWidth = {
    0: IntrinsicColumnWidth(),
    1: IntrinsicColumnWidth(),
    2: FlexColumnWidth(),
    3: FlexColumnWidth(),
    4: FlexColumnWidth(),
  };

  static const Map<int, TableColumnWidth> _patternCreationColumnWidth = {
    0: IntrinsicColumnWidth(),
    1: IntrinsicColumnWidth(),
    2: FlexColumnWidth(),
    3: IntrinsicColumnWidth(),
    4: FlexColumnWidth(),
  };

  Widget _buildColorCopyText(Color? color){
    if(color == null){
      return block0;
    }

    return Builder(
      builder: (BuildContext context){
        return AppButton(
          toolTip: "infinity_nikki.common.click_to_copy",
          onClick: () async{
            final String rgbHex = "#${color.toARGB32().toRadixString(16).padLeft(8, "0").substring(2).toUpperCase()}";
            try{
              await copyTextToClipboard(rgbHex);
              if(context.mounted){
                AppToast.showMessage(context: context, message: "${context.tr("pa_copy_successful")}: $rgbHex");
              }
            }catch(e){
              if(context.mounted){
                AppToast.showMessage(context: context, message: context.tr("pa_copy_failed"), state: false);
              }
            }
          },
          child: AppText("#${color.toARGB32().toRadixString(16).padLeft(8, "0").toUpperCase()}"),
        );
      },
    );
  }

  _TableRowBox _buildOutfitDyeTable({
    required int id,
    required int featureTag,
    required int targetGroupId,
    required DyeColorParams colorParams,
    int? colorMode,
    double? roughness,
  }){
    final int palette = handler.getColorPalette(colorParams.colorGrid);
    final int? swatch = handler.getColorSwatch(colorParams.colorGrid);
    final String? serialNumberStr = config == null ? null : handler.getColorPaletteSerialNumberStr(config!, id, palette);
    final int? zone = config == null ? null : handler.getDyeZone(config!, id, featureTag, targetGroupId);
    final (double, double, double, double)? rgbaColor = config == null ? null : handler.getSwatchRGBAColor(config!, colorParams.colorGrid);
    final Color color = rgbaColor == null ? convertColor(colorParams.color) : convertColor(rgbaColor);

    return _TableRowBox(
      zone: zone,
      child: TableRow(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
            width: 20,
            height: 20,
          ),

          AppText(trText("diy_zone") + (zone?.toString() ?? "$featureTag - $targetGroupId")),

          AppText("${serialNumberStr ?? "  "} ${trText(palette.toString(), category: "diy_color_palette")}"),

          swatch == null ?
            _buildColorCopyText(color) :
            AppText(trText("color_swatch.${ColorSwatch.fromFlag(swatch).name}")),

          if(roughness != null)
            colorMode == null ?
              AppText("") :
              Tooltip(
                message: trText("glossiness"),
                child: AppText((1 - roughness).toStringAsFixed(1)),
              ),

        ].map((Widget widget) => Padding(
          padding: const EdgeInsets.all(tinyPadding),
          child: widget,
        )).toList(),
      ),
    );
  }

  _TableRowBox _buildSpecialEffectTable({
    required int id,
    required SpecialEffectData specialEffectData,
  }){
    final int palette = handler.getColorPalette(specialEffectData.colorGrid);
    final int? swatch = handler.getColorSwatch(specialEffectData.colorGrid);
    final String? serialNumberStr = config == null ? null : handler.getColorPaletteSerialNumberStr(config!, id, palette);
    final int? zone = config == null ? null : handler.getDyeZone(config!, id, specialEffectData.featureTag, specialEffectData.targetGroupId);
    final (double, double, double, double)? rgbaColor = config == null ? null : handler.getSwatchRGBAColor(config!, specialEffectData.colorGrid);
    final Color? color = rgbaColor == null ? null : convertColor(rgbaColor);

    return _TableRowBox(
      zone: zone,
      child: TableRow(
        children: [
          AppIcon("sparkle", color: color, width: 20, height: 20),

          AppText(trText("diy_zone") + (zone?.toString() ?? "${specialEffectData.featureTag} - ${specialEffectData.targetGroupId}")),

          AppText("${serialNumberStr ?? "  "} ${trText(palette.toString(), category: "diy_color_palette")}"),

          swatch == null ?
            _buildColorCopyText(color) :
            AppText(trText("color_swatch.${ColorSwatch.fromFlag(swatch).name}")),

          AppText(trBool(specialEffectData.coverDiyColor, index: 5)),

        ].map((Widget widget) => Padding(
          padding: const EdgeInsets.all(tinyPadding),
          child: widget,
        )).toList(),
      ),
    );
  }

  _TableRowBox _buildPatternCreationTable({
    required int id,
    required PatternCreationData patternCreationData,
  }){
    final int? zone = config == null ? null : handler.getDyeZone(config!, id, patternCreationData.featureTag, patternCreationData.targetGroupId);

    return _TableRowBox(
      zone: zone,
      child: TableRow(
        children: [
          AppCachedNetworkImage(
            imageUrl: config?.getImageUrl(config?.networkImage?.diyPattern, patternCreationData.textureId) ?? "",
            cacheKey: patternCreationData.textureId.toString(),
            width: 40,
            height: 40,
          ),

          AppText(trText("diy_zone") + (zone?.toString() ?? "${patternCreationData.featureTag} - ${patternCreationData.targetGroupId}")),

          AppText(trText(patternCreationData.textureId.toString(), category: "cloth_diy_pattern")),
          Tooltip(
            message: trText("tiling"),
            child: AppText(patternCreationData.tiling.toString()),
          ),
          AppText(trBool(patternCreationData.overridePatternA, index: 6)),

        ].map((Widget widget) => Padding(
          padding: const EdgeInsets.all(tinyPadding),
          child: widget,
        )).toList(),
      ),
    );
  }

  List<TableRow> _buildOutfitDye(int id, List<OutfitDyeData> outfitDye){
    final SplayTreeMap<int, TableRow> children = SplayTreeMap();
    final List<TableRow> noZoneChildren = [];

    for(final OutfitDyeData outfitDyeData in outfitDye){
      final _TableRowBox box = outfitDyeData.when(
        hair: (OutfitDyeHairData outfitDyeHairData){
          return _buildOutfitDyeTable(
            id: id,
            featureTag: outfitDyeHairData.featureTag,
            targetGroupId: outfitDyeHairData.targetGroupId,
            colorParams: outfitDyeHairData.color0,
            colorMode: outfitDyeHairData.colorMode,
            roughness: outfitDyeHairData.roughness,
          );
        },
        general: (OutfitDyeGeneralData outfitDyeGeneralData){
          return _buildOutfitDyeTable(
            id: id,
            featureTag: outfitDyeGeneralData.featureTag,
            targetGroupId: outfitDyeGeneralData.targetGroupId,
            colorParams: outfitDyeGeneralData.color,
          );
        },
      );

      if(box.zone == null){
        noZoneChildren.add(box.child);
      }else{
        children[box.zone!] = box.child;
      }
    }

    return children.values.toList()..addAll(noZoneChildren);
  }

  List<TableRow> _buildSpecialEffect(int id, List<SpecialEffectData> specialEffect){
    final SplayTreeMap<int, TableRow> children = SplayTreeMap();
    final List<TableRow> noZoneChildren = [];

    for(final SpecialEffectData specialEffectData in specialEffect){
      final _TableRowBox box = _buildSpecialEffectTable(
        id: id,
        specialEffectData: specialEffectData,
      );

      if(box.zone == null){
        noZoneChildren.add(box.child);
      }else{
        children[box.zone!] = box.child;
      }
    }

    return children.values.toList()..addAll(noZoneChildren);
  }

  List<TableRow> _buildPatternCreation(int id, List<PatternCreationData> patternCreation){
    final SplayTreeMap<int, TableRow> children = SplayTreeMap();
    final List<TableRow> noZoneChildren = [];

    for(final PatternCreationData patternCreationData in patternCreation){
      final _TableRowBox box = _buildPatternCreationTable(
        id: id,
        patternCreationData: patternCreationData,
      );

      if(box.zone == null){
        noZoneChildren.add(box.child);
      }else{
        children[box.zone!] = box.child;
      }
    }

    return children.values.toList()..addAll(noZoneChildren);
  }

  @override
  Widget build(BuildContext context){
    final List<ClothParams> clothParamsList = handler.getSortedCloth(clothDiyParams.clothes);

    return AppFloatingIndicatorButtonGroup(
      child: SmoothPointerScroll(
        builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
          final GridView gridView = GridView.builder(
            controller: scrollController,
            physics: physics,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 128,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 128 / (128 + 36),
            ),
            itemCount: clothParamsList.length,
            itemBuilder: (BuildContext context, int index){
              final ClothParams clothParams = clothParamsList.elementAt(index);
              final int? outfit = clothParams.cloth.outfit;

              final DyeCondition? condition = config == null ? null : handler.getClothDyeCondition(config!, clothParams);

              return AppFloatingIndicatorButtonTarget(
                child: AppSuperTooltip(
                  width: 300,
                  direction: TooltipDirection.auto,
                  content: Column(
                    spacing: listSpacing,
                    children: [
                      if(outfit != null)
                        Center(
                          child: SizedBox(
                            width: 150,
                            child: AspectRatio(
                              aspectRatio: 2 / 3,
                              child: AppCachedNetworkImage(
                                imageUrl: config?.getImageUrl(config?.networkImage?.clothOutfit, outfit) ?? "",
                                cacheKey: outfit.toString(),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                      if(outfit != null)
                        Row(
                          spacing: listSpacing,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.tr("infinity_nikki.media_params.outfit", fontWeight: FontWeight.bold),
                            AppText(trText(outfit.toString(), category: "cloth_outfit"), softWrap: false),
                          ],
                        ),

                      Row(
                        spacing: listSpacing,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(trText("cloth_diy_data.condition"), fontWeight: FontWeight.bold),
                          AppText(trText((condition?.name).toString(), category: "dye_condition"), softWrap: false),
                        ],
                      ),

                      if(clothParams.effectHidden != null)
                        Row(
                          spacing: listSpacing,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(trText("cloth_diy_data.effect"), fontWeight: FontWeight.bold),
                            AppText(trBool(!clothParams.effectHidden!, index: 7), softWrap: false),
                          ],
                        ),

                      AppDivider(),

                      if(clothParams.diy != null)
                        Expanded(
                          child: AppTab(
                            children: [
                              if(clothParams.diy!.outfitDye.isNotEmpty)
                                (
                                  nav: AppButton.smallText(
                                    child: AppText(trText("outfit_dye")),
                                  ),
                                  page: SmoothPointerScroll(
                                    builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
                                      return SingleChildScrollView(
                                        controller: controller,
                                        physics: physics,
                                        child: Table(
                                          border: TableBorder.all(
                                            color: AppColorScheme.of(context).byRole(ColorRole.of(context)).hoveredColor,
                                          ),
                                          columnWidths: _outfitDyeTableColumnWidth,
                                          children: _buildOutfitDye(clothParams.cloth.id, clothParams.diy!.outfitDye),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              if(clothParams.diy!.specialEffect.isNotEmpty)
                                (
                                  nav: AppButton.smallText(
                                    child: AppText(trText("special_effect")),
                                  ),
                                  page: SmoothPointerScroll(
                                    builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
                                      return SingleChildScrollView(
                                        controller: controller,
                                        physics: physics,
                                        child: Table(
                                          border: TableBorder.all(
                                            color: AppColorScheme.of(context).byRole(ColorRole.of(context)).hoveredColor,
                                          ),
                                          columnWidths: _specialEffectTableColumnWidth,
                                          children: _buildSpecialEffect(clothParams.cloth.id, clothParams.diy!.specialEffect),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              if(clothParams.diy!.patternCreation.isNotEmpty)
                                (
                                  nav: AppButton.smallText(
                                    child: AppText(trText("pattern_creation")),
                                  ),
                                  page: SmoothPointerScroll(
                                    builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
                                      return SingleChildScrollView(
                                        controller: controller,
                                        physics: physics,
                                        child: Table(
                                          border: TableBorder.all(
                                            color: AppColorScheme.of(context).byRole(ColorRole.of(context)).hoveredColor,
                                          ),
                                          columnWidths: _patternCreationColumnWidth,
                                          children: _buildPatternCreation(clothParams.cloth.id, clothParams.diy!.patternCreation),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  child: AppButton(
                    borderRadius: smallBorderRadius,
                    isTransparent: false,
                    child: Column(
                      spacing: listSpacing,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: AppCachedNetworkImage(
                            imageUrl: config?.getImageUrl(config?.networkImage?.cloth, clothParams.cloth.id) ?? "",
                            cacheKey: clothParams.cloth.id.toString(),
                          ),
                        ),

                        AppText(trText(clothParams.cloth.id.toString(), category: "cloth"), softWrap: false),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

          final DyeCondition? condition = config == null ? null : handler.getDyeCondition(config!, clothDiyParams.clothes);
          final EffectScheme? effectScheme = handler.getEffectScheme(clothParamsList);
          return Column(
            spacing: listSpacing,
            children: [
              Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                border: TableBorder.all(
                  color: AppColorScheme.of(context).byRole(ColorRole.of(context)).hoveredColor,
                ),
                children: [
                  TableRow(
                    children: [
                      AppText(trText("cloth_diy_data.time")),
                      AppText(DateTime.fromMillisecondsSinceEpoch(ClothDiyShareCode.fromCodeStr(shareCode).timestamp()).toString()),
                    ],
                  ),
                  TableRow(
                    children: [
                      AppText(trText("cloth_diy_data.condition")),
                      AppText(trText((condition?.name).toString(), category: "dye_condition")),
                    ],
                  ),
                  if(effectScheme != null)
                    TableRow(
                      children: [
                        AppText(trText("cloth_diy_data.effect_scheme")),
                        AppText(trText((effectScheme.name).toString(), category: "effect_scheme")),
                      ],
                    ),
                ].map((TableRow tableRow) => TableRow(
                  children: tableRow.children.map((child) => Padding(
                    padding: const EdgeInsets.all(smallPadding),
                    child: child,
                  )).toList(),
                )).toList(),
              ),

              Expanded(
                child: gridView,
              ),
            ],
          );
        },
      ),
    );
  }
}