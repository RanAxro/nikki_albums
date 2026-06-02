
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
                    buttonWidth: constraints.maxWidth,
                    buttonHeight: smallButtonSize,
                    selectedIndex: controller.page?.toInt() ?? 0,
                    children: [
                      AppRawButton(
                        width: constraints.maxWidth,
                        height: smallButtonSize,
                        onClick: () {
                          controller.jumpToPage(0);
                        },
                        child: AppText("AppState", isTranslate: false),
                      ),
                      AppRawButton(
                        width: constraints.maxWidth,
                        height: smallButtonSize,
                        onClick: () {
                          controller.jumpToPage(1);
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

        SmallVerticalDivider(color: AppTheme.of(context)!.colorScheme.background.hoveredColor),

        Expanded(
          child: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              block0,
              block0,
            ],
          ),
        ),
      ],
    );
  }
}