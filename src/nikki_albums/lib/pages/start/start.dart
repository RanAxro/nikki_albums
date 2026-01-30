

import "test_permission.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/game/selector.dart";
import "package:nikkialbums/game/uid.dart";
import "package:nikkialbums/pages/file_transfer/file_transfer.dart";
import "package:nikkialbums/nikkias/nikkias.dart";
import "package:nikkialbums/ui/frame.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/utils/path.dart";
import "package:nikkialbums/utils/system/system.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:file_picker/file_picker.dart";


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
              spacing: listSpacing,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Image.asset("assets/logo/InfinityNikki_2.png"),
                ),
                SmallButton(
                  width: largeButtonSize,
                  colorRole: ColorRoles.background,
                  transparent: false,
                  onClick: (){
                    if(AppState.currentGame.value?.launcherPath != null){
                      (AppState.currentGame.value!.launcherPath + "launcher.exe").open();
                    }
                  },
                  child: Text(context.tr("play"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                ),
              ],
            ),
          ),

          // tool button
          ValueListenableBuilder(
            valueListenable: AppState.currentGame,
            builder: (BuildContext context, Game? game, Widget? child){
              if(game == null) return block0;

              return SizedBox(
                width: sideBarWidth,
                child: Column(
                  spacing: listSpacing,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OpenFolderButton(),
                    MoveFolderButton(),
                    BackupAlbumButton(game),
                  ],
                ),
              );
            },
          ),
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
            AppState.currentGame.value?.launcherPath.open();
          },
          child: Text(context.tr("openLauncherDirectory")),
        ),
        MenuItemButton(
          onPressed: (){
            AppState.currentGame.value?.installPath.open();
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
            if(AppState.currentGame.value == null) return;

            showDialog(
              context: context,
              builder: (BuildContext context){
                return MoveFolderDialog(game: AppState.currentGame.value!, folder: AppState.currentGame.value!.gamePlayPhotosPath);
              }
            );
          },
          child: Text(context.tr("moveAlbumResource")),
        ),
        MenuItemButton(
          onPressed: (){
            if(AppState.currentGame.value == null) return;

            showDialog(
              context: context,
              builder: (BuildContext context){
                return MoveFolderDialog(game: AppState.currentGame.value!, folder: AppState.currentGame.value!.installPath);
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
              Image.asset("assets/icon/tick.webp", height: 20, color: AppTheme.of(context)!.colorScheme.success.pressedColor),
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

          final (available, total, free) = getDiskFreeSpaceEx(Path(to));

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




class BackupAlbumButton extends StatelessWidget{
  final Game game;

  const BackupAlbumButton(this.game, {super.key});

  @override
  Widget build(BuildContext context){
    return Tooltip(
      message: context.tr("backupAllAlbum"),
      child: SmallButton(
        colorRole: ColorRoles.background,
        onClick: (){
          showDialog(
            context: context,
            builder: (BuildContext context){
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(smallBorderRadius),
                ),
                backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
                child: Container(
                  padding: const EdgeInsets.all(smallPadding),
                  constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
                  child: BackupAlbumProcessor(game),
                ),
              );
            }
          );
        },
        child: Image.asset("assets/icon/export.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
      ),
    );
  }
}

class BackupAlbumProcessor extends StatefulWidget{
  final Game game;
  const BackupAlbumProcessor(this.game, {super.key});

  @override
  State<BackupAlbumProcessor> createState() => _BackupAlbumProcessorState();
}
class _BackupAlbumProcessorState extends State<BackupAlbumProcessor>{
  final ManualValueNotifier<List<Uid>> processedUid = ManualValueNotifier<List<Uid>>([]);
  bool init = false;

  Future<void> startExport(BuildContext context) async{
    final String? location = await FilePicker.platform.getDirectoryPath(
      dialogTitle: context.tr("saveBackupFileTo"),
      lockParentWindow: true,
    );
    if(location == null) return;

    if(context.mounted){
      Navigator.of(context).pop();
    }

    final Path root = Path(location);
    final String filename = "${DateTime.now().millisecondsSinceEpoch}.$nikkiasExtension";
    final Path savePath = root + filename;

    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
    String? errorMessage;

    if(context.mounted){
      showProgressBar(
        context: context,
        barrierDismissible: false,
        autoClose: false,
        valueListenable: progress,
        completedBuilder: (BuildContext context, void Function() close){
          return Column(
            spacing: listSpacing,
            mainAxisSize: MainAxisSize.min,
            children: [
              errorMessage == null ?
              Text(filename, style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.onColor)) :
              Text(context.tr("backupFailed"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),
              if(errorMessage != null)
                SelectableText(errorMessage, style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),

              if(errorMessage == null)
                SmallButton(
                  width: null,
                  colorRole: ColorRoles.background,
                  transparent: false,
                  onClick: (){
                    Explorer.openFile(savePath.file);
                  },
                  child: Text(context.tr("openDirectory"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                ),
              if(errorMessage == null)
                SmallButton(
                  width: null,
                  colorRole: ColorRoles.background,
                  transparent: false,
                  onClick: (){
                    sendToNetwork(context, savePath);
                  },
                  child: Text(context.tr("sendBackupToNetwork"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                ),
              SmallButton(
                width: null,
                colorRole: ColorRoles.background,
                transparent: false,
                onClick: close,
                child: Text(context.tr("close"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
              ),
            ],
          );
        }
      );
    }

    final AlbumBackupNikkiasManifest manifest = AlbumBackupNikkiasManifest(launcherChannel: widget.game.launcherChannel);

    try{
      final AlbumBackupNikkiasCodec codec = AlbumBackupNikkiasCodec(manifest, savePath.file, widget.game.installPath);
      codec.uidWhitelist = processedUid.value.map((Uid uid) => uid.value).toList();
      await codec.encode((double encodeProgress) => progress.value = encodeProgress);
    }catch(e){
      errorMessage = e.toString();
    }finally{
      progress.value = 1;
    }
  }

  void sendToNetwork(BuildContext context, Path filePath){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
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
              children: [
                Expanded(child: block0),
                SendFileBuilder(
                  files: [filePath.file],
                  archives: [File(""), filePath.file],
                  downloadArchiveButtonText: ["", context.tr("downloadNikkias")],
                  waitingBuilder: (BuildContext context, Widget indicator){
                    return Column(
                      children: [
                        Text(context.tr("activatingNetwork"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                        indicator,
                      ],
                    );
                  },
                  errorBuilder: (BuildContext context){
                    return Text(context.tr("activatingNetworkFailed"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor));
                  },
                  builder: (BuildContext context, TransmissionInfo info){
                    return UdpBroadcastBuilder(
                      info: info,
                      builder: (BuildContext context){
                        return Column(
                          spacing: listSpacing,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.tr("useSameNetworkDevice"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                            Text(info.code, style: TextStyle(fontSize: 48, fontWeight: FontWeight.w500, color: AppTheme.of(context)!.colorScheme.background.onColor)),
                            Container(
                              color: Colors.white,
                              child: QrImageView(
                                data: info.v4AccessLink,
                                version: QrVersions.auto,
                                size: 200,
                              ),
                            ),
                            Column(
                              children: [
                                Text(context.tr("downloadLink"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                                SelectableText(info.v4AccessLink, style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Expanded(child: block0),

                SmallButton(
                  width: null,
                  colorRole: ColorRoles.background,
                  transparent: false,
                  onClick: (){
                    Navigator.of(context).pop();
                  },
                  child: Text(context.tr("stopSharing"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                ),
              ],
            ),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Column(
      spacing: listSpacing,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.tr("backupAllAlbum"), style: TextStyle(fontSize: 16, color: AppTheme.of(context)!.colorScheme.background.onColor)),

        Padding(
          padding: const EdgeInsets.only(left: smallPadding),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(context.tr("uidToBeBackup"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
          ),
        ),

        UidSelectorBuilder(
          widget.game,
          builder: (BuildContext context, Future<List<Uid>> uidList){
            return RFutureBuilder(
              future: uidList,
              builder: (BuildContext context, List<Uid> uidList){
                if(!init){
                  processedUid.value = [...uidList];
                }
                init = true;

                final List<Widget> children = <Widget>[];

                for(final Uid uid in uidList){
                  children.add(
                    ManualValueNotifierBuilder(
                      valueListenable: processedUid,
                      builder: (BuildContext context, List<Uid> processedUidList, Widget? child){
                        late final Widget tickBox;

                        if(processedUidList.contains(uid)){
                          tickBox = Container(
                            decoration: BoxDecoration(
                              color: AppTheme.of(context)!.colorScheme.success.pressedColor,
                              border: Border.all(
                                color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(0.5 * smallButtonContentSize),
                            ),
                            child: Image.asset("assets/icon/tick.webp", color: AppTheme.of(context)!.colorScheme.background.color),
                          );
                        }else{
                          tickBox = Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(0.5 * smallButtonContentSize),
                            ),
                          );
                        }

                        return SmallButton(
                          padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                          width: null,
                          height: mediumButtonSize,
                          colorRole: ColorRoles.background,
                          onClick: (){
                            if(processedUidList.contains(uid)){
                              processedUid.value.remove(uid);
                            }else{
                              processedUid.value.add(uid);
                            }
                            processedUid.notify();
                          },
                          child: Row(
                            spacing: listSpacing,
                            children: [
                              SizedBox(
                                width: smallButtonContentSize,
                                height: smallButtonContentSize,
                                child: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.all(Radius.circular(0.5 * smallButtonContentSize)),
                                  child: tickBox,
                                ),
                              ),
                              Text("${uid.value} ( ${uid.name} )", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                            ],
                          ),
                        );
                      },
                    )
                  );
                }

                return Column(
                  children: children,
                );
              },
            );
          },
        ),

        Row(
          spacing: listSpacing,
          mainAxisSize: MainAxisSize.max,
          children: [
            /// cancel button
            Expanded(
              child: SmallButton(
                width: null,
                colorRole: ColorRoles.background,
                transparent: false,
                onClick: () => Navigator.of(context).pop(),
                child: Text(context.tr("cancel"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
              ),
            ),
            /// save button
            Expanded(
              child: SmallButton(
                width: null,
                colorRole: ColorRoles.highlight,
                transparent: false,
                onClick: (){
                  startExport(context);
                },
                child: Text(context.tr("startBackupAllAlbum"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.highlight.onColor)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose(){
    processedUid.dispose();
    super.dispose();
  }
}








// Future<void> createLink() async {
//   // 目标目录 -> 链接目录
//   final target = r'E:\game\InfinityNikki\InfinityNikki Launcher\InfinityNikki';
//   final link   = r'E:\work\nikki_albums_file\textimages\InfinityNikki';
//
//   // 因为 mklink 是 cmd 的内置命令，所以用 cmd /c 包一下
//   final result = await Process.run(
//     'cmd',
//     ['/c', 'mklink', '/D', link, target],
//   );
//
//
//   print(result.stdout);
//   print(result.stderr);
// }