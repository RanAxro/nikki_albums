
import "hot_update_debug.dart";
import "app_state_debug.dart";
import "nuan5_decryption_debug.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";


final PageController controller = PageController(initialPage: 0);

class DebugPanel extends StatelessWidget{
  const DebugPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: listSpacing,
      children: [
        SizedBox(
          width: sideBarExpandWidth,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return ListenableBuilder(
                listenable: controller,
                builder: (BuildContext context, Widget? child){
                  return AppRadioStack(
                    direction: Axis.vertical,
                    selectedIndex: controller.page?.toInt() ?? 0,
                    children: [
                      AppButton.smallText(
                        width: constraints.maxWidth,
                        height: smallButtonSize,
                        onClick: () {
                          controller.jumpToPage(0);
                        },
                        child: AppText("HotUpdate"),
                      ),
                      AppButton.smallText(
                        width: constraints.maxWidth,
                        height: smallButtonSize,
                        onClick: () {
                          controller.jumpToPage(1);
                        },
                        child: AppText("AppState", isTranslate: false),
                      ),
                      AppButton.smallText(
                        width: constraints.maxWidth,
                        height: smallButtonSize,
                        onClick: () {
                          controller.jumpToPage(2);
                        },
                        child: AppText("nuan5_decryption", isTranslate: false),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),

        AppDivider(direction: Axis.vertical),

        Expanded(
          child: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HotUpdateDebug(),
              AppStateDebug(),
              Nuan5DecryptionDebug(),
            ],
          ),
        ),
      ],
    );
  }
}