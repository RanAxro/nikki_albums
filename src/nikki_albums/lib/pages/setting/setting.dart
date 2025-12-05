import "package:nikkialbums/info.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/component/component.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";


class SettingDialog extends StatelessWidget{
  const SettingDialog({super.key});

  @override
  Widget build(BuildContext context){

    List<Widget> buttons = [
      Text("${context.tr("version")}: $version", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),

      SmallDivider(color: AppTheme.of(context)!.colorScheme.background.onColor),

      const ChangeTheme(),

      SmallDivider(color: AppTheme.of(context)!.colorScheme.background.onColor),

      const ChangeLanguage(),

      SmallDivider(color: AppTheme.of(context)!.colorScheme.background.onColor),

      SelectableText(context.tr("info"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
        child: SmoothPointerScroll(
          builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbar scrollbar){
            return SingleChildScrollView(
              controller: controller,
              physics: physics,
              scrollDirection: Axis.vertical,
              child: Column(
                spacing: listSpacing,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(context.tr("setting"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                      ),
                      SmallButton(
                        onClick: (){
                          Navigator.of(context).pop();
                        },
                        child: Image.asset("assets/icon/cross.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
                      )
                    ],
                  ),
                  ...buttons,
                ],
              ),
            );
          },
        ),
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
    return Row(
      spacing: bigListSpacing,
      children: [
        Text(context.tr("language"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
        MenuAnchor(
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
              width: null,
              onClick: (){
                controller.isOpen ? controller.close() : controller.open();
              },
              child: Text(context.tr("lang"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            );
          },
        ),
      ],
    );
  }
}