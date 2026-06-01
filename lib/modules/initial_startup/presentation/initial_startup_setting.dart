
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/modules/setting/setting.dart";

import "package:flutter/material.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:window_manager/window_manager.dart";

class InitialStartupSetting extends StatelessWidget{
  const InitialStartupSetting({super.key});

  @override
  Widget build(BuildContext context){
    return AppBackground(
      colorRole: ColorRole.background,
      child: GestureDetector(
        onSecondaryTap: closeApp,
        child: Stack(
          children: [
            Positioned.fill(child: DragToMoveArea(child: Container())),

            Align(
              alignment: Alignment.center,
              child: SmoothPointerScroll(
                builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarCotroller){
                  return SingleChildScrollView(
                    controller: controller,
                    physics: physics,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          spacing: 20,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/logo/nikkialbums.webp", height: 100),

                            AppText("welcome", fontSize: 40),
                          ],
                        ),

                        SizedBox(height: 40),

                        IntrinsicWidth(
                          child: ChangeLanguage(
                            builder: (BuildContext context, MenuController controller, Widget? child){
                              return AppButton.smallText(
                                padding: const EdgeInsets.symmetric(horizontal: bigPadding),
                                width: null,
                                height: 50,
                                colorRole: ColorRole.background,
                                isTransparent: false,
                                onClick: (){
                                  controller.isOpen ? controller.close() : controller.open();
                                },
                                child: Row(
                                  spacing: listSpacing,
                                  children: [
                                    AppIcon("language", height: 24),
                                    AppText("language", fontSize: 16),
                                    AppText("lang", fontSize: 16),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 120),

                        IntrinsicWidth(
                          child: AppButton.smallText(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            width: null,
                            height: 50,
                            colorRole: ColorRole.highlight,
                            isTransparent: false,
                            onClick: (){
                              AppState.isInitialStartup.value = false;
                            },
                            child: Row(
                              spacing: listSpacing,
                              children: [
                                Icon(Icons.arrow_right_alt_sharp, color: AppColorScheme.of(context).highlight.onEnabledColor),
                                AppText("start", fontSize: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}