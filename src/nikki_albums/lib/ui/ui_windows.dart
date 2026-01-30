import "frame.dart";

import "package:nikkialbums/nikkias/nikkias.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/utils/system/system.dart";
import "package:nikkialbums/utils/path.dart";

import "package:flutter/material.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";
import "package:desktop_drop/desktop_drop.dart";


class WindowsFrame extends StatelessWidget{
  const WindowsFrame({super.key});

  @override
  Widget build(BuildContext context){
    return DropTarget(
      onDragDone: (DropDoneDetails details){
        final Path path = Path(details.files.first.path);
        parseNikkiasFile(context, path.file);
        /// TODO 将窗口提前
      },
      child: WindowBorder(
        color: Theme.of(context).colorScheme.secondary,
        width: 1,
        child: Column(
          children: [
            const WindowTitleBar(),
            Expanded(
              child: Content(controller: pages),
            ),
          ],
        ),
      ),
    );
  }
}


class WindowTitleBar extends StatelessWidget{
  const WindowTitleBar({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      height: windowTitleBarHeight,
      color: AppTheme.of(context)!.colorScheme.secondary.color,
      child: Stack(
        children: [
          Positioned.fill(
            child: MoveWindow(),
          ),
          Row(
            children: [
              // Icon
              IgnorePointer(
                ignoring: true,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: sideBarWidth,
                  height: windowTitleBarHeight,
                  child: Image.asset("assets/logo/nikkialbums.webp"),
                ),
              ),

              const AccountButton(),

              const GameShortcutBar(),

              /// top window button
              SmallSwitch(
                colorRole: ColorRoles.secondary,
                onChange: (bool value){
                  doTopWindow(value);
                },
                child: Image.asset("assets/icon/top.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onColor),
              ),
              block5W,

              /// minimize window button
              SmallButton(
                width: windowTitleBarHeight + 10,
                height: windowTitleBarHeight,
                borderRadius: 0,
                colorRole: ColorRoles.secondary,
                onClick: (){
                  appWindow.minimize();
                },
                child: Image.asset("assets/icon/minimize.webp", height: 14, color: AppTheme.of(context)!.colorScheme.secondary.onColor),
              ),

              /// maximizeOrRestore button
              ValueListenableBuilder(
                valueListenable: AppState.isUseMaximizeOrRestoreButton,
                builder: (BuildContext context, bool isUseMaximizeOrRestoreButton, Widget? child){
                  return SmallButton(
                    width: isUseMaximizeOrRestoreButton ? windowTitleBarHeight + 10 : 0,
                    height: windowTitleBarHeight,
                    borderRadius: 0,
                    colorRole: ColorRoles.secondary,
                    onClick: (){
                      appWindow.maximizeOrRestore();
                    },
                    child: Image.asset("assets/icon/maximizeOrRestore.webp", height: 16, color: AppTheme.of(context)!.colorScheme.secondary.onColor),
                  );
                },
              ),

              /// close window button
              SmallButton(
                width: windowTitleBarHeight + 10,
                height: windowTitleBarHeight,
                borderRadius: 0,
                colorRole: ColorRoles.error,
                onClick: closeApp,
                child: Image.asset("assets/icon/cross.webp", height: 14, color: AppTheme.of(context)!.colorScheme.error.onColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}