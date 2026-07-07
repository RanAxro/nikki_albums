
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/modules/nuan5_params/model/image.dart";
import "package:nikki_albums/src/rust/nuan5_database/model.dart";
import "package:nikki_albums/src/rust/nuan5_database/reader_v1.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";
import "dart:typed_data";

import "package:cached_network_image/cached_network_image.dart";


class LightSelector extends StatefulWidget{
  final Object? initId;
  final void Function(int?)? onChanged;

  const LightSelector({
    super.key,
    this.initId,
    this.onChanged,
  });

  @override
  State<LightSelector> createState() => _LightSelectorState();
}

class _LightSelectorState extends State<LightSelector>{
  bool? isInit;
  late final Nuan5DatabaseReaderV1 reader;
  // lightTypeData的key 是无序的, 需要使用 lightType 来储存顺序
  late final List<int> lightType;
  late final Map<int, Nuan5LightType?> lightTypeData;
  late final Map<int, Nuan5Light?> lightData;
  final ValueNotifier<int?> selectedId = ValueNotifier(null);

  late final PageController pageController;

  Future<void> initData() async{
    final Nuan5DatabaseReaderV1? readerV1 = await Nuan5Data.init();

    if(readerV1 == null){
      isInit = false;
      return;
    }

    reader = readerV1;

    lightType = await reader.list(category: Nuan5DatabaseCategory.lightType, from: BigInt.zero, max: -1);
    final Map<int, Nuan5DatabaseItem> rawLightTypeData = await reader.get_(category: Nuan5DatabaseCategory.lightType, ids: lightType);

    lightTypeData = rawLightTypeData.map<int, Nuan5LightType?>((int id, Nuan5DatabaseItem item){
      final Nuan5LightType? lightTypeData = item.whenOrNull(
        lightType: (Nuan5LightType d) => d,
      );

      return MapEntry(id, lightTypeData);
    });

    final Int32List light = await reader.list(category: Nuan5DatabaseCategory.light, from: BigInt.zero, max: -1);
    final Map<int, Nuan5DatabaseItem> rawLightData = await reader.get_(category: Nuan5DatabaseCategory.light, ids: light);

    lightData = rawLightData.map<int, Nuan5Light?>((int id, Nuan5DatabaseItem item){
      return MapEntry(id, item.whenOrNull(
        light: (Nuan5Light d) => d,
      ));
    });

    setState((){
      initSelectedId();
      initPageController();
      isInit = true;
    });
  }

  void initSelectedId(){
    if(widget.initId == null){
      selectedId.value = null;
      return;
    }

    if(widget.initId is int){
      selectedId.value = widget.initId as int;
    }else if(widget.initId is String){
      for(final MapEntry<int, Nuan5Light?> entry in lightData.entries){
        if(widget.initId == entry.value?.stringId || widget.initId == entry.value?.paramId){
          selectedId.value = entry.key;
          return;
        }
      }
    }else{
      selectedId.value = null;
    }
  }

  void initPageController(){
    if(selectedId.value == null){
      pageController = PageController(initialPage: 0);
      return;
    }

    for(final MapEntry<int, Nuan5LightType?> entry in lightTypeData.entries){
      if(entry.value?.light.contains(selectedId.value) == true){
        final int page = lightType.indexOf(entry.key);
        pageController = PageController(initialPage: page.clamp(0, lightType.length));

        return;
      }
    }

    pageController = PageController(initialPage: 0);
  }

  @override
  void initState(){
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context){
    if(isInit != true){
      return AppText("error");
    }

    Widget child = Row(
      spacing: listSpacing,
      children: [
        SizedBox(
          width: 160,
          child: AppNavBuilder<int>(
            initValue: pageController.initialPage,
            builder: (BuildContext context, int value, void Function(int) change){
              return AppRadioStack(
                selectedIndex: value,
                direction: Axis.vertical,
                children: [
                  for(final (int index, int typeId) in lightType.indexed)
                    AppButton.smallText(
                      onClick: (){
                        change(index);
                        pageController.animateToPage(index, duration: animationTime, curve: animationCurve);
                      },
                      child: AppText(typeId.toString()),
                    ),
                ],
              );
            },
          ),
        ),

        Expanded(
          child: AppFloatingIndicatorButtonGroup(
            child: PageView.builder(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int page){
                final Int32List lights = lightTypeData[lightType.elementAt(page)]?.light ?? Int32List(0);
                final Map<int, Nuan5DatabaseItem> rawLightData = reader.getSync(category: Nuan5DatabaseCategory.light, ids: lights);

                return SmoothPointerScroll(
                  builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
                    return GridView.builder(
                      controller: controller,
                      physics: physics,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 128,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 128 / (128 + 36),
                      ),
                      itemCount: lights.length,
                      itemBuilder: (BuildContext context, int index){
                        final int id = lights[index];
                        final Nuan5Light? lightData = rawLightData[id]?.whenOrNull(
                          light: (Nuan5Light d) => d,
                        );

                        return AppFloatingIndicatorButtonTarget(
                          child: ValueListenableBuilder(
                            valueListenable: selectedId,
                            builder: (BuildContext context, int? selected, Widget? child){
                              return AppSwitch(
                                padding: const EdgeInsets.all(smallPadding),
                                borderRadius: smallBorderRadius,
                                value: selected == id,
                                onChanged: (_){
                                  if(selected == id){
                                    selectedId.value = null;
                                  }else{
                                    selectedId.value = id;
                                  }
                                  widget.onChanged?.call(id);
                                  print(lightData?.paramId);
                                },
                                child: Column(
                                  spacing: listSpacing,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: lightData == null ?
                                        Center(
                                          child: AppText("?"),
                                        ) :
                                        CachedNetworkImage(
                                          imageUrl: Nuan5Image.light(id),
                                          fadeInDuration: animationTime,
                                          fadeOutDuration: animationTime,
                                          cacheKey: id.toString(),
                                        ),
                                    ),

                                    AppText(id.toString(), softWrap: false),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
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

    return SizedBox(
      width: 700,
      height: 400,
      child: Column(
        spacing: listSpacing,
        children: [
          Row(
            children: [
              block5W,

              AppText.tr("infinity_nikki.media_params.light.name"),

              Expanded(child: block0),

              AppButton.smallIcon(
                child: AppIcon("cross", height: 20,),
              ),
            ],
          ),

          Expanded(child: child),
        ],
      ),
    );
  }
}