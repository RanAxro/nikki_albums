import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";

class Personalization extends StatelessWidget{
  const Personalization({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(smallPadding),
      child: Column(
        spacing: bigListSpacing,
        children: [
          const MaximizeOrRestoreButtonSwitch(),

          const ChangeTheme(),
        ],
      ),
    );
  }
}



class MaximizeOrRestoreButtonSwitch extends StatelessWidget{
  const MaximizeOrRestoreButtonSwitch({super.key});

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: AppState.isUseMaximizeOrRestoreButton,
      builder: (BuildContext context, bool isUseMaximizeOrRestoreButton, Widget? child){
        return Align(
          alignment: Alignment.centerLeft,
          child: SmallButton(
            padding: const EdgeInsets.all(smallPadding),
            colorRole: ColorRoles.background,
            transparent: false,
            width: smallDialogMaxWidth,
            height: mediumButtonSize,
            onClick: (){
              if(isUseMaximizeOrRestoreButton){
                AppState.isUseMaximizeOrRestoreButton.value = false;
              }else{
                AppState.isUseMaximizeOrRestoreButton.value = true;
              }
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("${context.tr("maximizeOrRestoreButton")}: ${isUseMaximizeOrRestoreButton ? context.tr("enable") : context.tr("disable")}", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ),
          ),
        );
      },
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