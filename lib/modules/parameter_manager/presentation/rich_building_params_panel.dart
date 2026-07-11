
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/modules/nuan5_params/domain/tree_node_generator.dart";
import "package:nikki_albums/src/rust/nuan5_params/decrypt.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/building_params.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";

import "package:flutter/material.dart";
import "package:url_launcher/url_launcher_string.dart";


class RichBuildingParamsPanel extends StatelessWidget{
  final String shareCode;
  final RichBuildingParams richBuildingParams;
  final Nuan5DatabaseReaderV1? reader;

  const RichBuildingParamsPanel({
    super.key,
    required this.shareCode,
    required this.richBuildingParams,
    required this.reader,
  });

  @override
  Widget build(BuildContext context){
    return SmoothPointerScroll(
      builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
        return SingleChildScrollView(
          child: Column(
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
                      AppText(trText("home_build_data.cover_image")),

                      if(richBuildingParams.coverImage == null)
                        AppText(trBool(false, index: 2)),

                      if(richBuildingParams.coverImage != null)
                        Image.network(richBuildingParams.coverImage!, width: 200),
                    ],
                  ),

                  TableRow(
                    children: [
                      AppText(trText("home_build_data.name")),
                      AppText(richBuildingParams.name),
                    ],
                  ),

                  TableRow(
                    children: [
                      AppText(trText("home_build_data.version")),
                      AppText(richBuildingParams.version),
                    ],
                  ),

                  TableRow(
                    children: [
                      AppText(trText("home_build_data.furniture_count")),
                      AppText(richBuildingParams.furnitureCount.toString()),
                    ],
                  ),

                  TableRow(
                    children: [
                      AppText(trText("home_build_data.server")),
                      AppText(trText(HomeBuildShareCode.fromCodeStr(shareCode).server().toString(), category: "share_code_server")),
                    ],
                  ),
                ].map((TableRow tableRow) => TableRow(
                  children: tableRow.children.map((child) => Padding(
                    padding: const EdgeInsets.all(smallPadding),
                    child: child,
                  )).toList(),
                )).toList(),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: IntrinsicWidth(
                  child: AppButton(
                    toolTip: trText("home_build_data.open_building_momo"),
                    isTranslate: false,
                    borderRadius: smallBorderRadius,
                    padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                    height: mediumButtonSize,
                    isTransparent: false,
                    onClick: () async{
                      final String url = "https://infinitymomo.com?schemeCode=$shareCode";

                      if(await canLaunchUrlString(url)){
                        launchUrlString(url);
                      }else{
                        AppToast.showMessage(
                          context: context,
                          message: "",
                        );
                      }
                    },
                    child: Row(
                      spacing: listSpacing,
                      children: [
                        AppIcon("building_momo", width: 30, height: 30, isDye: false),
                        AppText(trText("home_build_data.visualization")),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}