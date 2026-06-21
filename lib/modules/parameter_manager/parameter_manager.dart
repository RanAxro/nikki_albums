
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";


final ContentItem item = ContentItem(
  name: "parameter_manager",
  icon: AppIcon("parameter_manager", height: mediumButtonContentSize),
  page: const ParameterManager(),
);

class ParameterManager extends StatefulWidget{
  final int initPage;

  const ParameterManager({
    super.key,
    this.initPage = 0,
  });

  @override
  State<ParameterManager> createState() => _ParameterManagerState();
}

class _ParameterManagerState extends State<ParameterManager>{
  final ValueNotifier<int> page = ValueNotifier<int>(0);

  @override
  void initState(){
    super.initState();
    page.value = widget.initPage;
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        AppBackground(
          colorRole: ColorRole.secondary,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: smallPadding),
            height: topBarHeight,
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
        ),


      ],
    );
  }
}