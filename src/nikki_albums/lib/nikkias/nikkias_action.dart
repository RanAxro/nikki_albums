import "nikkias_manifest.dart";
import "nikkias.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/game/selector.dart";
import "package:nikkialbums/game/uid.dart";
import "package:nikkialbums/utils/path.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:file_picker/file_picker.dart";




void parseNikkiasFile(BuildContext context, File file){
  final manifest = getNikkiasManifest(file);

  if(manifest == null) return;

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
          width: smallCardMaxWidth,
          child: NikkiasAction(manifest: manifest, nikkiasFile: file),
        )
      );
    }
  );
}


class NikkiasAction extends StatelessWidget{
  final NikkiasManifest manifest;
  final File nikkiasFile;

  const NikkiasAction({
    super.key,
    required this.manifest,
    required this.nikkiasFile,
  });

  @override
  Widget build(BuildContext context){
    final Path nikkiasPath = Path(nikkiasFile.path);

    return Column(
      spacing: listSpacing,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(context.tr("nikkiasFile"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
        ),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(nikkiasPath.subName, style: TextStyle(fontSize: 24, color: AppTheme.of(context)!.colorScheme.background.onColor)),
        ),

        block10H,

        Builder(
          builder: (BuildContext context){
            switch(manifest.type){
              case NikkiasType.albumBackup:
                return Row(
                  spacing: listSpacing,
                  children: [
                    Text("-", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    Text(manifest.launcherChannel.name, style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ],
                );
              case NikkiasType.imageTransfer:
                return Row(
                  spacing: listSpacing,
                  children: [
                    Text("-", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    Text(manifest.launcherChannel.name, style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    Text("-", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    Text((manifest as ImageTransferNikkiasManifest).uid, style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    Text("-", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    Text(context.tr(albumsInfoMap[(manifest as ImageTransferNikkiasManifest).albumType]!.name), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ],
                );
              case NikkiasType.other:
                return block0;
            }
          },
        ),

        _ImportButton(manifest: manifest, nikkiasFile: nikkiasFile),

        Row(
          spacing: listSpacing,
          children: [
            Expanded(
              child: SmallButton(
                width: null,
                colorRole: ColorRoles.background,
                onClick: (){
                  Navigator.of(context).pop();
                },
                child: Text(context.tr("cancel"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
              ),
            ),

            Expanded(
              child: _SaveAsButton(manifest: manifest, nikkiasFile: nikkiasFile),
            ),
          ],
        ),
      ],
    );
  }
}



// class _ImportButton extends StatelessWidget{
//   final NikkiasManifest manifest;
//   final File nikkiasFile;
//
//   const _ImportButton({
//     required this.manifest,
//     required this.nikkiasFile,
//   });
//
//   @override
//   Widget build(BuildContext context){
//     return MenuAnchor(
//       style: MenuStyle(
//         backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
//       ),
//       builder: (BuildContext context, MenuController controller, Widget? child){
//         return SmallButton(
//           width: null,
//           colorRole: ColorRoles.highlight,
//           transparent: false,
//           onClick: () async{
//             controller.isOpen ? controller.close() : controller.open();
//           },
//           child: Text(context.tr("import"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.highlight.onColor)),
//         );
//       },
//       menuChildren: [
//         Builder(
//           builder: (BuildContext context){
//             if(manifest.launcherChannel == LauncherChannel.unknown){
//               return block0;
//             }
//
//             return RFutureBuilder(
//               future: FindGame.find(),
//               builder: (BuildContext context, List<Game> gameList){
//                 for(final Game game in gameList){
//
//                   /// game.launcherChannel must not = LauncherChannel.unknown
//                   if(game.launcherChannel == manifest.launcherChannel){
//                     return MenuItemButton(
//                       onPressed: (){
//
//                         if(manifest.type == NikkiasType.albumBackup){
//                           // AlbumBackupNikkiasCodec(manifest as AlbumBackupNikkiasManifest, nikkiasFile, Path(r"E:\work\nikki_albums_file\nikkias\c")).decode((f) => print(f));
//
//                           AlbumBackupNikkiasCodec(manifest as AlbumBackupNikkiasManifest, nikkiasFile, Path(r"E:\game\InfinityNikki\InfinityNikki Launcher\InfinityNikki")).encode((f) => print(f));
//                         }
//
//                       },
//                       child: Row(
//                         spacing: listSpacing,
//                         children: [
//                           Text(context.tr("导入到"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
//                           Image(image: game.logoImage, height: smallButtonContentSize),
//                           Text(game.launcherChannel.name, style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
//                         ],
//                       ),
//                     );
//                   }
//                 }
//
//                 return block0;
//               },
//             );
//           },
//         ),
//
//
//         AccountSelector(
//           isSelectUid: false,
//         ).submenuButton(
//           context: context,
//           child: Text(context.tr("导入到其他渠道"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor))
//         ),
//       ],
//     );
//   }
// }

class _ImportButton extends StatelessWidget{
  final NikkiasManifest manifest;
  final File nikkiasFile;

  const _ImportButton({
    required this.manifest,
    required this.nikkiasFile,
  });

  Future<void> import(BuildContext context, Game game) async{
    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);

    showProgressBar(context: context, valueListenable: progress);

    try{
      switch(manifest.type){
        case NikkiasType.albumBackup:
          await AlbumBackupNikkiasCodec(manifest as AlbumBackupNikkiasManifest, nikkiasFile, game.installPath).decode((double decodeProgress) => progress.value = decodeProgress);
          break;
        case NikkiasType.imageTransfer:
          await ImageTransferNikkiasCodec(manifest as ImageTransferNikkiasManifest, nikkiasFile, game.installPath).decode((double decodeProgress) => progress.value = decodeProgress);
          break;
        case NikkiasType.other:
          break;
      }
    }finally{
      progress.value = 1;
    }

    if(context.mounted){
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context){

    if(manifest.type == NikkiasType.other) return block0;

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child){
        return SmallButton(
          width: null,
          colorRole: ColorRoles.highlight,
          transparent: false,
          onClick: () async{
            controller.isOpen ? controller.close() : controller.open();
          },
          child: Text(context.tr("import"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.highlight.onColor)),
        );
      },
      menuChildren: [
        Builder(
          builder: (BuildContext _){
            if(manifest.launcherChannel == LauncherChannel.unknown){
              return block0;
            }

            return RFutureBuilder(
              future: FindGame.find(),
              builder: (BuildContext _, List<Game> gameList){
                for(final Game game in gameList){

                  /// game.launcherChannel must not = LauncherChannel.unknown
                  if(game.launcherChannel == manifest.launcherChannel){
                    return MenuItemButton(
                      onPressed: (){
                        import(context, game);
                      },
                      child: Row(
                        spacing: listSpacing,
                        children: [
                          Text(context.tr("importTo"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                          Image(image: game.logoImage, height: smallButtonContentSize),
                          Text(game.launcherChannel.name, style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                        ],
                      ),
                    );
                  }
                }

                return block0;
              },
            );
          },
        ),


        AccountSelector(
          isSelectUid: false,
          onSelected: (Game game, Uid? uid){
            import(context, game);
          }
        ).submenuButton(
          context: context,
          child: Text(context.tr("importToOther"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor))
        ),
      ],
    );
  }
}



class _SaveAsButton extends StatelessWidget{
  final NikkiasManifest manifest;
  final File nikkiasFile;

  const _SaveAsButton({
    required this.manifest,
    required this.nikkiasFile,
  });

  Future<void> saveRawFile(BuildContext context) async{
    final Path nikkiasPath = Path(nikkiasFile.path);

    final String? location = await FilePicker.platform.getDirectoryPath(
      dialogTitle: context.tr("saveAs"),
      lockParentWindow: true,
    );

    if(location != null){
      final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
      if(context.mounted){
        showProgressBar(context: context, valueListenable: progress);
      }

      final Path savePath = Path(location) + nikkiasPath.name;
      try{
        if(await savePath.file.exists()) await savePath.file.delete();

        await nikkiasFile.copy(savePath.path);
      }finally{
        progress.value = 1;
      }

      if(context.mounted){
        WidgetsBinding.instance.addPostFrameCallback((_){
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> saveDecodedFile(BuildContext context) async{
    final String? location = await FilePicker.platform.getDirectoryPath(
      dialogTitle: context.tr("saveAs"),
      lockParentWindow: true,
    );

    if(location != null){
      final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
      if(context.mounted){
        showProgressBar(context: context, valueListenable: progress);
      }

      await NikkiasCodec.decompress(nikkiasFile, Directory(location), (double decompressProgress) => progress.value = decompressProgress);

      if(context.mounted){
        WidgetsBinding.instance.addPostFrameCallback((_){
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child){
        return SmallButton(
          width: null,
          colorRole: ColorRoles.background,
          transparent: false,
          onClick: () async{
            controller.isOpen ? controller.close() : controller.open();
          },
          child: Text(context.tr("saveAs"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: (){
            saveRawFile(context);
          },
          child: Text(context.tr("saveDirectly"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
        ),

        MenuItemButton(
          onPressed: (){
            saveDecodedFile(context);
          },
          child: Text(context.tr("saveDecoded"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
        ),
      ],
    );
  }
}