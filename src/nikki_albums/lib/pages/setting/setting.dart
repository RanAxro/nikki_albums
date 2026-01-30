import "personalization.dart";
import "edit_custom_game.dart";
import "versionInformation.dart";

import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/component/component.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";




class SettingDialog extends StatelessWidget{
  final PageController controller = PageController(initialPage: 0);

  SettingDialog({super.key});

  @override
  Widget build(BuildContext context){

    final Widget content = Row(
      spacing: listSpacing,
      children: [
        SizedBox(
          width: sideBarExpandWidth,
          child: SmoothPointerScroll(
            builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
              return ListView(
                controller: scrollController,
                physics: physics,
                children: [
                  SmallButton(
                    colorRole: ColorRoles.background,
                    onClick: (){
                      controller.jumpToPage(0);
                    },
                    child: Text(context.tr("personalization"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ),
                  block5H,
                  SmallButton(
                    colorRole: ColorRoles.background,
                    onClick: (){
                      controller.jumpToPage(1);
                    },
                    child: Text(context.tr("accountManagement"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ),
                  block5H,
                  SmallButton(
                    colorRole: ColorRoles.background,
                    onClick: (){
                      controller.jumpToPage(2);
                    },
                    child: Text(context.tr("versionInformation"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ),
                ],
              );
            },
          ),
        ),

        SmallVerticalDivider(
          color: AppTheme.of(context)!.colorScheme.background.hoveredColor,
        ),

        Expanded(
          child: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const Personalization(),
              const EditCustomGame(),
              const VersionInformation(),
            ],
          ),
        ),
      ],
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
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
                    child: Text(context.tr("setting"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ),

                  const ChangeLanguage(),

                  SmallButton(
                    colorRole: ColorRoles.background,
                    onClick: (){
                      Navigator.of(context).pop();
                    },
                    child: Image.asset("assets/icon/cross.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
                  )
                ],
              ),
            ),
            Expanded(
              child: content,
            ),
          ],
        ),
      )
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
            child: Text(context.tr("theme"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
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
                  child: ClipOval(
                    child: Container(
                      color: Color(color),
                    ),
                  ),
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
  const ChangeLanguage({super.key});

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
          child: Text("简体中文", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
        ),
        MenuItemButton(
          onPressed: (){
            AppState.lang.value = "en-US";
          },
          child: Text("English", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
        )
      ],
      builder: (BuildContext context, MenuController controller, Widget? child){
        return SmallButton(
          padding: const EdgeInsets.symmetric(horizontal: smallPadding),
          width: null,
          colorRole: ColorRoles.background,
          onClick: (){
            controller.isOpen ? controller.close() : controller.open();
          },
          child: Row(
            spacing: listSpacing,
            children: [
              Image.asset("assets/icon/language.webp", height: 16, color: AppTheme.of(context)!.colorScheme.background.onColor),
              Text(context.tr("language"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
              Text(context.tr("lang"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor))
            ],
          ),
        );
      },
    );
  }
}