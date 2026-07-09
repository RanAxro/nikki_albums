
import "package:nikki_albums/modules/nuan5_params/domain/selector_handler.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/src/rust/nuan5_database/reader_v1.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

import "package:cached_network_image/cached_network_image.dart";


class Selector extends StatefulWidget{
  final SelectorHandler handler;
  final Object? initValue;
  final void Function(int?)? onChanged;
  final Widget? title;

  const Selector({
    super.key,
    required this.handler,
    this.initValue,
    this.onChanged,
    this.title,
  });

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector>{
  bool? isInit;
  late final Nuan5DatabaseReaderV1 reader;
  late final List<int> allType;
  final ValueNotifier<int?> selectedId = ValueNotifier(null);

  late final PageController pageController;

  Future<void> initData() async{
    final Nuan5DatabaseReaderV1? readerV1 = await Nuan5Data.init();

    if(readerV1 == null){
      isInit = false;
      return;
    }

    reader = readerV1;

    allType = widget.handler.getType(reader);
    selectedId.value = widget.handler.getInitValue(reader, widget.initValue);

    setState((){
      initPageController();
      isInit = true;
    });
  }

  void initPageController(){
    if(selectedId.value == null){
      pageController = PageController(initialPage: 0);
    }else{
      final int? initType = widget.handler.getValueType(reader, selectedId.value!);

      if(initType == null){
        pageController = PageController(initialPage: 0);
      }else{
        final int page = allType.indexOf(initType);
        pageController = PageController(initialPage: page.clamp(0, allType.length));
      }
    }
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
          width: allType.isEmpty ? 0 : 160,
          child: allType.isEmpty ? block0 : AppNavBuilder<int>(
            initValue: pageController.initialPage,
            builder: (BuildContext context, int value, void Function(int) change){
              return AppRadioStack(
                selectedIndex: value,
                direction: Axis.vertical,
                children: [
                  for(final (int index, int typeId) in allType.indexed)
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
                final List<int> allValue = widget.handler.getValue(reader, allType.isEmpty ? null : allType.elementAt(page));

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
                      itemCount: allValue.length,
                      itemBuilder: (BuildContext context, int index){
                        final int id = allValue[index];

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
                                  widget.onChanged?.call(selectedId.value);
                                },
                                child: Column(
                                  spacing: listSpacing,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.handler.getValueImageUrl(reader, id),
                                        cacheKey: id.toString(),
                                        fadeInDuration: animationTime,
                                        fadeOutDuration: animationTime,
                                        errorWidget: (BuildContext context, String url, Object error){
                                          return Center(
                                            child: AppText("?"),
                                          );
                                        },
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

              ?widget.title,

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