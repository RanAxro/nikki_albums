import "dart:io";

import "test_permission.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/frame.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/api/path.dart";
import "package:nikkialbums/api/Image.dart";
import "package:nikkialbums/api/clipboard.dart";
import "package:nikkialbums/api/system/system.dart";

import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import "dart:ui" hide Path;

import "package:easy_localization/easy_localization.dart";
import "package:file_picker/file_picker.dart";
import 'package:desktop_drop/desktop_drop.dart';


final ContentItem item = ContentItem(
  expectedPosition: 1,
  name: "start",
  icon: AssetImage("assets/icon/run.webp"),
  page: const Start(),
);

void init(){
  pages.addItem(item);
}


class Start extends StatelessWidget{
  const Start({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment.center,
      color: AppTheme.of(context)!.colorScheme.background.color,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Image.asset("assets/logo/InfinityNikki_2.png"),
                ),
                SmallButton(
                  width: 160,
                  transparent: false,
                  onClick: (){
                    if(AppState.currentGame.value?.launcherPath != null){
                      (AppState.currentGame.value!.launcherPath! + "launcher.exe").open();
                    }
                  },
                  child: Text(context.tr("play")),
                ),
              ],
            ),
          ),
          SizedBox(
            width: sideBarWidth,
            child: const Column(
              spacing: listSpacing,
              mainAxisSize: MainAxisSize.min,
              children: [
                OpenFolderButton(),
                MoveFolderButton(),
              ],
            ),
          )
        ],
      ),
    );
  }
}



class OpenFolderButton extends StatelessWidget{
  const OpenFolderButton({super.key});

  @override
  Widget build(BuildContext context){
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child){
        return Tooltip(
          message: context.tr("openDirectory"),
          child: SmallButton(
            colorRole: ColorRoles.background,
            onClick: (){
              controller.isOpen ? controller.close() : controller.open();
            },
            child: Image.asset("assets/icon/folder.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: (){
            AppState.currentGame.value?.launcherPath?.open();
          },
          child: Text(context.tr("openLauncherDirectory")),
        ),
        MenuItemButton(
          onPressed: (){
            AppState.currentGame.value?.installPath?.open();
          },
          child: Text(context.tr("openInstallDirectory")),
        )
      ],
    );
  }
}




class MoveFolderButton extends StatelessWidget{
  const MoveFolderButton({super.key});

  @override
  Widget build(BuildContext context){
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child){
        return Tooltip(
          message: context.tr("moveResource"),
          child: SmallButton(
            colorRole: ColorRoles.background,
            onClick: (){
              controller.isOpen ? controller.close() : controller.open();
            },
            child: Image.asset("assets/icon/move.webp", height: 24, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: (){
            if(AppState.currentGame.value == null || AppState.currentGame.value!.gamePlayPhotosPath == null) return;

            showDialog(
              context: context,
              builder: (BuildContext context){
                return MoveFolderDialog(game: AppState.currentGame.value!, folder: AppState.currentGame.value!.gamePlayPhotosPath!);
              }
            );
          },
          child: Text(context.tr("moveAlbumResource")),
        ),
        MenuItemButton(
          onPressed: (){
            if(AppState.currentGame.value == null || AppState.currentGame.value!.installPath == null) return;

            showDialog(
              context: context,
              builder: (BuildContext context){
                return MoveFolderDialog(game: AppState.currentGame.value!, folder: AppState.currentGame.value!.installPath!);
              }
            );
          },
          child: Text(context.tr("moveInstallResource")),
        ),
      ],
    );
  }
}



class MoveFolderDialog extends StatelessWidget{
  static final int extraSpace = 1073741824;  // 1 GiB

  final Game game;
  final Path folder;
  final ValueNotifier<int?> directorySize = ValueNotifier<int?>(null);
  final ValueNotifier<int?> freeSize = ValueNotifier<int?>(null);
  final ValueNotifier<String?> destination = ValueNotifier<String?>(null);
  final ValueNotifier<bool> permission = ValueNotifier<bool>(false);
  /// error
  /// - notCheck - 未检测
  /// - destinationIsNull - 未定位目标目录
  /// - insufficientSpace - [destination] 所在的盘符空闲空间不足
  /// - existInfinityNikkiDirectory - 目标目录 [destination] 已存在 InfinityNikki 文件夹
  final ValueNotifier<String?> errorString = ValueNotifier<String?>(null);

  MoveFolderDialog({
    super.key,
    required this.game,
    required this.folder,
  });

  Future<void> _startToMove() async{
    if(destination.value == null){
      errorString.value = "destinationIsNull";
      return;
    }

    if(directorySize.value == null || freeSize.value == null || permission.value == false){
      errorString.value = "notCheck";
      return;
    }

    if(freeSize.value! <= directorySize.value! + extraSpace){
      errorString.value = "insufficientSpace";
      return;
    }

    final Path target = Path(destination.value!) + folder.name;
    if(await target.directory.exists()){
      errorString.value = "existXInDestination";
      return;
    }

    final String folderPath = folder.path;
    final String temporaryPath = folderPath + DateTime.now().millisecondsSinceEpoch.toString();
    final Path originDirectory = folder.cut(1);
    final Path toDestination = Path(destination.value!);
    final Path to = toDestination + folder.name;

    // final r = await Process.run("cmd", ["attrib", "-r", folderPath, "/s", "/d"]);
    // print(r.stdout);
    // print(r.stderr);

    // final r = await runWindowsCommandAsAdmin([["attrib", "-r", folderPath, "/s", "/d"].join(" ")]);
    // print(r);

    // await folder.directory.rename(temporaryPath);
  }

  @override
  Widget build(BuildContext context){

    final List<Widget> ui = [

      /// file size
      RFutureBuilder(
        future: folder.size(),
        waitingBuilder: (BuildContext context, Widget indicator){
          return Row(
            children: [
              indicator,
              Text("${context.tr("fileSize")}: ", style: TextStyle(fontSize: 16)),
              Text("${context.tr("calculating")}..."),
            ],
          );
        },
        builder: (BuildContext context, int size){
          WidgetsBinding.instance.addPostFrameCallback((_){
            directorySize.value = size;
          });
          return Row(
            children: [
              Image.asset("assets/icon/tick.webp", height: 20, color: AppTheme.of(context)!.colorScheme.success.pressedColor,),
              Text("${context.tr("fileSize")}: ", style: TextStyle(fontSize: 16)),
              Text("${(size / 1073741824).toStringAsFixed(2)} GiB", style: TextStyle(fontSize: 16)),
            ],
          );
          // child: Text("${(size / 1073741824).toStringAsFixed(2)} GiB ( ${(size / 1000000000).toStringAsFixed(2)} GB )", style: TextStyle(fontSize: 16)),
        },
      ),

      /// select destination
      ValueListenableBuilder(
        valueListenable: destination,
        builder: (BuildContext context, String? pathStr, Widget? child){
          return Row(
            children: [
              if(pathStr == null)
                Image.asset("assets/icon/cross.webp", height: 20, color: AppTheme.of(context)!.colorScheme.error.pressedColor),
              if(pathStr != null)
                Image.asset("assets/icon/tick.webp", height: 20, color: AppTheme.of(context)!.colorScheme.success.pressedColor),
              Text("${context.tr("moveTo")}: ", style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(pathStr ?? context.tr("toSelectFolder")),
              ),
              SmallButton(
                onClick: () async{
                  destination.value = await FilePicker.platform.getDirectoryPath(
                    lockParentWindow: true,
                  );
                },
                child: Image.asset("assets/icon/folder.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onColor),
              ),
            ],
          );
        },
      ),

      /// storage space
      MultiValueListenableBuilder(
        listenables: [destination, directorySize],
        builder: (BuildContext context, Widget? child){
          if(destination.value == null || directorySize.value == null){
            return Row(
              children: [
                Image.asset("assets/icon/cross.webp", height: 20, color: AppTheme.of(context)!.colorScheme.error.pressedColor),
                Text("${context.tr("storageSpace")}: ", style: TextStyle(fontSize: 16)),
              ],
            );
          }

          final String to =  destination.value!;
          final int need = directorySize.value!;

          final (available, total, free) = getDiskFreeSpaceEx(to);

          final bool enough = free > need + extraSpace; // need more 1 GiB

          WidgetsBinding.instance.addPostFrameCallback((_){
            freeSize.value = free;
          });

          return Row(
            children: [
              if(!enough)
                Image.asset("assets/icon/cross.webp", height: 20, color: AppTheme.of(context)!.colorScheme.error.pressedColor),
              if(enough)
                Image.asset("assets/icon/tick.webp", height: 20, color: AppTheme.of(context)!.colorScheme.success.pressedColor),
              Text("${context.tr("availableSpaceOnXDrive", args: [to.substring(0, 1)])} ${(free / 1073741824).toStringAsFixed(2)} GiB", style: TextStyle(fontSize: 16)),
            ],
          );
        },
      ),

      /// permission
      StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) reTestPermission){
          return RFutureBuilder(
            future: TestPermission.mklinkOrAdmin(folder),
            waitingBuilder: (BuildContext context, Widget indicator){
              return Row(
                children: [
                  indicator,
                  Text("${context.tr("permission")}: ", style: TextStyle(fontSize: 16)),
                  Text("${context.tr("underTest")}..."),
                ],
              );
            },
            builder: (BuildContext context, bool linkPermission){
              WidgetsBinding.instance.addPostFrameCallback((_){
                permission.value = linkPermission;
              });
              return Row(
                children: [
                  Image.asset("assets/icon/tick.webp", height: 20, color: AppTheme.of(context)!.colorScheme.success.pressedColor),
                  Text("${context.tr("permission")}: ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(linkPermission ? context.tr("normal") : context.tr("noPermission"), style: TextStyle(fontSize: 16)),
                  ),
                  Tooltip(
                    message: context.tr("retry"),
                    child: SmallButton(
                      onClick: (){
                        reTestPermission((){});
                      },
                      child: Image.asset("assets/icon/refresh.webp", height: 20, color: AppTheme.of(context)!.colorScheme.primary.onColor),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),

      /// error
      ValueListenableBuilder(
        valueListenable: errorString,
        builder: (BuildContext context, String? error, Widget? child){
          if(error == null) return block0;

          return Text(error == "existXInDestination" ? context.tr(error, args: [folder.name]) : context.tr(error), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor));
        },
      ),

      /// buttons
      MultiValueListenableBuilder(
        listenables: [directorySize, freeSize, destination, permission],
        builder: (BuildContext context, Widget? child){
          final Widget cancelButton = SmallButton(
            width: null,
            onClick: (){
              Navigator.of(context).pop();
            },
            child: Text(context.tr("cancel")),
          );

          bool isReady = directorySize.value != null && freeSize.value != null && destination.value != null;

          if(!isReady) return cancelButton;

          final int need = directorySize.value!;
          final int free = freeSize.value!;
          final bool linkPermission = permission.value;
          isReady = isReady && (free > need + extraSpace) && linkPermission;

          if(!isReady) return cancelButton;

          return Row(
            children: [
              Expanded(
                child: SmallButton(
                  width: null,
                  onClick: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
/// TODO
                        return AlertDialog(
                          content: Text("该功能不可用, 该软件没有权限去操作无限暖暖的游戏资源文件夹 \n This function is unavailable. The software does not have the permission to operate the InfinityNikki game resource folder"),
                        );
                      }
                    );
                    _startToMove();
                  },
                  child: Text(context.tr("startToMove")),
                ),
              ),
              Expanded(
                child: cancelButton,
              ),
            ],
          );
        },
      ),
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
        child: Column(
          spacing: listSpacing,
          mainAxisSize: MainAxisSize.min,
          children: ui,
        ),
      ),
    );
  }
}








Future<void> createLink() async {
  // 目标目录 -> 链接目录
  final target = r'E:\game\InfinityNikki\InfinityNikki Launcher\InfinityNikki';
  final link   = r'E:\work\nikki_albums_file\textimages\InfinityNikki';

  // 因为 mklink 是 cmd 的内置命令，所以用 cmd /c 包一下
  final result = await Process.run(
    'cmd',
    ['/c', 'mklink', '/D', link, target],
  );


  print(result.stdout);
  print(result.stderr);
}