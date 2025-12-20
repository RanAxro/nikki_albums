import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/game/game.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";


class EditCustomGame extends StatelessWidget{
  const EditCustomGame({super.key});

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: AppState.customGame,
      builder: (BuildContext context, List<Game> customGame, Widget? child){
        return SmoothPointerScroll(
          builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
            return ListView.builder(
              controller: controller,
              physics: physics,
              itemCount: customGame.length,
              itemBuilder: (BuildContext context, int index){
                final Game game = customGame[index];

                return SmallButton(
                  padding: const EdgeInsets.all(smallPadding),
                  width: null,
                  height: null,
                  colorRole: ColorRoles.background,
                  transparent: false,
                  onClick: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return DeleteCustomGameDialog(game);
                      }
                    );
                  },
                  child: Column(
                    spacing: smallPadding,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${context.tr("account")}: ${game.name}", style: TextStyle(fontSize: 20, color: AppTheme.of(context)!.colorScheme.background.onColor)),
                      Text("${context.tr("launcherDir")} ${game.launcherPath.path}", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                      Text("${context.tr("installDir")} ${game.installPath.path}", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class DeleteCustomGameDialog extends StatelessWidget{
  final Game toDeleteGame;

  const DeleteCustomGameDialog(this.toDeleteGame, {super.key});

  void _delete(){
    /// remove from custom game
    AppState.customGame.value = [...AppState.customGame.value..remove(toDeleteGame)];

    /// current game
    if(toDeleteGame == AppState.currentGame.value) AppState.currentGame.value = null;

    /// shortcut
    AppState.gameShortcuts.value = {...AppState.gameShortcuts.value..removeWhere((GameShortcut shortcut) => shortcut.isFrom(toDeleteGame))};
  }

  @override
  Widget build(BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        width: smallDialogMaxWidth,
        child: Column(
          spacing: listSpacing,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.tr("deleteAccount"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            SmallButton(
              width: null,
              colorRole: ColorRoles.background,
              transparent: false,
              onClick: (){
                _delete();
                Navigator.of(context).pop();
              },
              child: Text(context.tr("delete"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ),
            SmallButton(
              width: null,
              colorRole: ColorRoles.background,
              transparent: false,
              onClick: (){
                Navigator.of(context).pop();
              },
              child: Text(context.tr("cancel"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ),
          ],
        ),
      ),
    );
  }
}