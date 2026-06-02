import "package:flutter/foundation.dart";

import "personalization.dart";
import "edit_custom_game.dart";
import "live_photo_settings.dart";
import "nikkias_setting/presentation/nikkias_setting.dart";
import "version_information/presentation/version_information.dart";
import "debug_panel/presentation/debug_panel.dart";

import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";

import "dart:io";
import "package:flutter/material.dart";

class SettingDialog extends StatelessWidget{
  final int initialPage;
  final PageController controller;

  SettingDialog({
    super.key,
    this.initialPage = 0,
  }) :
    controller = PageController(initialPage: initialPage);

  @override
  Widget build(BuildContext context){
    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: listSpacing,
      children: [
        SizedBox(
          width: sideBarExpandWidth,
          child: SmoothPointerScroll(
            builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics, IndependentScrollbarController scrollbarController) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  return ListenableBuilder(
                    listenable: controller,
                    builder: (BuildContext context, Widget? child){
                      return AppRadioStack(
                        direction: Axis.vertical,
                        buttonWidth: constraints.maxWidth,
                        buttonHeight: smallButtonSize,
                        selectedIndex: controller.page?.toInt() ?? initialPage,
                        children: [
                          AppRawButton(
                            width: constraints.maxWidth,
                            height: smallButtonSize,
                            onClick: () {
                              controller.jumpToPage(0);
                            },
                            child: AppText("personalization"),
                          ),
                          if(Platform.isWindows)
                          AppRawButton(
                            width: constraints.maxWidth,
                            height: smallButtonSize,
                            onClick: () {
                              controller.jumpToPage(1);
                            },
                            child: AppText("accountManagement"),
                          ),
                          AppRawButton(
                            width: constraints.maxWidth,
                            height: smallButtonSize,
                            onClick: () {
                              controller.jumpToPage(Platform.isWindows ? 2 : 1);
                            },
                            child: AppText("livePhotoSettings"),
                          ),
                          AppRawButton(
                            width: constraints.maxWidth,
                            height: smallButtonSize,
                            onClick: () {
                              controller.jumpToPage(Platform.isWindows ? 3 : 2);
                            },
                            child: AppText("nikkias_setting"),
                          ),
                          AppRawButton(
                            width: constraints.maxWidth,
                            height: smallButtonSize,
                            onClick: () {
                              controller.jumpToPage(Platform.isWindows ? 4 : 3);
                            },
                            child: AppText("version_information"),
                          ),
                          if(kDebugMode)
                            AppRawButton(
                              width: constraints.maxWidth,
                              height: smallButtonSize,
                              onClick: () {
                                controller.jumpToPage(Platform.isWindows ? 5 : 3);
                              },
                              child: AppText("Debug Panel", isTranslate: false),
                            ),
                        ],
                      );
                    },
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
              const Personalization(),
              if(Platform.isWindows) const EditCustomGame(),
              const LivePhotoSettings(),
              const NikkiasSetting(),
              const VersionInformation(),
              if(kDebugMode) const DebugPanel(),
            ].map((Widget page){
              return FadeIn(
                offsetBegin: Offset.zero,
                opacityBegin: 0.0,
                child: page,
              );
            }).toList(),
          ),
        ),
      ],
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(smallBorderRadius)),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          return Container(
            padding: const EdgeInsets.all(smallPadding),
            width: constraints.maxWidth - 88,
            child: Column(
              spacing: bigListSpacing,
              children: [
                SizedBox(
                  height: topBarHeight,
                  child: Row(
                    spacing: bigListSpacing,
                    children: [
                      block10W,
                      Expanded(
                        child: AppText("setting", fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      const ChangeLanguage(),

                      AppButton.smallIcon(
                        colorRole: ColorRole.background,
                        onClick: () {
                          Navigator.of(context).pop();
                        },
                        child: AppIcon("cross", height: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(child: content),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChangeTheme extends StatelessWidget{
  const ChangeTheme({super.key});

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: smallCardMaxHeight,
      child: Row(
        spacing: bigListSpacing,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: AppText("theme"),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: smallButtonContentSize,
                mainAxisSpacing: listSpacing,
                crossAxisSpacing: listSpacing,
                childAspectRatio: 1 / 1,
              ),
              itemCount: AppColorScheme.table.length,
              itemBuilder: (BuildContext context, int index){
                final int color = AppColorScheme.table.keys.toList(growable: false)[index];
                return GestureDetector(
                  onTap: (){
                    AppState.theme.value = color;
                  },
                  child: ClipOval(child: Container(color: Color(color))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeLanguage extends StatelessWidget{
  final Widget Function(BuildContext context, MenuController controller, Widget? child)? builder;

  const ChangeLanguage({
    super.key,
    this.builder,
  });

  @override
  Widget build(BuildContext context){
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: (){
            AppState.lang.value = "zh-CN";
          },
          child: AppText("简体中文", isTranslate: false),
        ),
        MenuItemButton(
          onPressed: (){
            AppState.lang.value = "en-US";
          },
          child: AppText("English", isTranslate: false),
        ),
      ],
      builder: builder ?? (BuildContext context, MenuController controller, Widget? child){
        return SmallButton(
          padding: const EdgeInsets.symmetric(horizontal: smallPadding),
          width: null,
          colorRole: ColorRole.background,
          onClick: (){
            controller.isOpen ? controller.close() : controller.open();
          },
          child: Row(
            spacing: listSpacing,
            children: [
              AppIcon("language", height: 16),
              AppText("language"),
              AppText("lang"),
            ],
          ),
        );
      },
    );
  }
}
