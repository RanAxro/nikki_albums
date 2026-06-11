
import "package:nikki_albums/modules/hot_update/domain/check_app_hot_updates.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";



class HotUpdateDebug extends StatelessWidget{
  const HotUpdateDebug({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        children: [

          AppButton.smallText(
            onClick: () async{
              print("running...");
              await checkAppHotUpdates();
              print("ok");
            },
            isTranslate: false,
            child: AppText("hot update"),
          ),

        ].map((Widget widget) => AppFloatingIndicatorButtonTarget(child: widget)).toList(),
      ),
    );
  }
}