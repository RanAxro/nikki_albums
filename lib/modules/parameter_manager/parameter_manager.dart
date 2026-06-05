
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

final ContentItem item = ContentItem(
  name: "parameter_manager",
  icon: AppIcon("parameter_manager", height: mediumButtonContentSize),
  page: const ParameterManager(),
);

class ParameterManager extends StatefulWidget{
  const ParameterManager({super.key});

  @override
  State<ParameterManager> createState() => _ParameterManagerState();
}

class _ParameterManagerState extends State<ParameterManager>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        SizedBox(
          height: topBarHeight,
          child: AppFloatingIndicatorButtonGroup(
            child: Row(
              children: [
                AppButton.smallText(
                  child: AppText("相机参数"),
                ),
                AppButton.smallText(
                  child: AppText("分享码"),
                ),
                AppButton.smallText(
                  child: AppText("家园码"),
                ),
              ].map((Widget widget) => AppFloatingIndicatorButtonTarget(child: widget)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}