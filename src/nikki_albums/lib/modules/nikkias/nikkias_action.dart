import "nikkias.dart";
import "package:nikki_albums/info.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/modules/game/game.dart";
import "package:nikki_albums/modules/game/selector.dart";
import "package:nikki_albums/modules/game/uid.dart";
import "package:nikki_albums/utils/path.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:nikki_albums/utils/native_file_picker.dart";

Future<void> parseNikkiasFile(BuildContext context, File file) async{
  final manifest = await getNikkiasManifest(file);

  if(manifest == null){
    if(context.mounted){
      AppToast.showMessage(context: context, message: context.tr("not_nikkias"), state: false);
    }
  }else{
    if(context.mounted){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(smallBorderRadius),
            ),
            backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
            child: Container(
              padding: const EdgeInsets.all(smallPadding),
              width: smallCardMaxWidth,
              child: NikkiasAction(manifest: manifest, nikkiasFile: file),
            ),
          );
        },
      );
    }
  }

}

class NikkiasAction extends StatelessWidget {
  final NikkiasManifest manifest;
  final File nikkiasFile;

  const NikkiasAction({
    super.key,
    required this.manifest,
    required this.nikkiasFile,
  });

  @override
  Widget build(BuildContext context) {
    final Path nikkiasPath = Path(nikkiasFile.path);

    return Column(
      spacing: listSpacing,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: AppText.tr("nikkiasFile"),
        ),

        Align(
          alignment: Alignment.centerLeft,
          child: AppText.tr(nikkiasPath.subName, fontSize: 24),
        ),

        block10H,

        Builder(
          builder: (BuildContext context) {
            switch (manifest.type) {
              case NikkiasType.albumBackup:
                return Row(
                  spacing: listSpacing,
                  children: [
                    AppText("-"),
                    AppText(manifest.launcherChannel.name),
                  ],
                );
              case NikkiasType.imageTransfer:
                return Row(
                  spacing: listSpacing,
                  children: [
                    AppText("-"),
                    AppText(manifest.launcherChannel.name,),
                    AppText("-"),
                    AppText((manifest as ImageTransferNikkiasManifest).uid),
                    AppText("-",),
                    AppText.tr(albumsInfoMap[(manifest as ImageTransferNikkiasManifest).albumType]!.name),
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
              child: AppButton.smallText(
                colorRole: ColorRole.background,
                onClick: () {
                  Navigator.of(context).pop();
                },
                child: AppText.tr("cancel"),
              ),
            ),

            Expanded(
              child: _SaveAsButton(
                manifest: manifest,
                nikkiasFile: nikkiasFile,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImportButton extends StatelessWidget {
  final NikkiasManifest manifest;
  final File nikkiasFile;

  const _ImportButton({required this.manifest, required this.nikkiasFile});

  Future<void> import(BuildContext context, Game game) async {
    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);

    showProgressBar(context: context, valueListenable: progress);

    try {
      switch (manifest.type) {
        case NikkiasType.albumBackup:
          await AlbumBackupNikkiasCodec(
            manifest as AlbumBackupNikkiasManifest,
            nikkiasFile,
            game.installPath,
          ).decode((double decodeProgress) => progress.value = decodeProgress);
          break;
        case NikkiasType.imageTransfer:
          await ImageTransferNikkiasCodec(
            manifest as ImageTransferNikkiasManifest,
            nikkiasFile,
            game.installPath,
          ).decode((double decodeProgress) => progress.value = decodeProgress);
          break;
        case NikkiasType.other:
          break;
      }
    } finally {
      progress.value = 1;
    }

    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (manifest.type == NikkiasType.other) return block0;

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          AppTheme.of(context)!.colorScheme.background.color,
        ),
      ),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return AppButton.smallText(
              colorRole: ColorRole.highlight,
              isTransparent: false,
              onClick: () async {
                controller.isOpen ? controller.close() : controller.open();
              },
              child: AppText.tr("import"),
            );
          },
      menuChildren: [
        Builder(
          builder: (BuildContext _) {
            if (manifest.launcherChannel == LauncherChannel.unknown) {
              return block0;
            }

            return RFutureBuilder(
              future: FindGame.find(),
              builder: (BuildContext _, List<Game> gameList) {
                for (final Game game in gameList) {
                  /// game.launcherChannel must not = LauncherChannel.unknown
                  if (game.launcherChannel == manifest.launcherChannel) {
                    return MenuItemButton(
                      onPressed: () {
                        import(context, game);
                      },
                      child: Row(
                        spacing: listSpacing,
                        children: [
                          AppText.tr("importTo"),
                          Image(
                            image: game.logoImage,
                            height: smallButtonContentSize,
                          ),
                          AppText(game.launcherChannel.name),
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
          onSelected: (Game game, Uid? uid) {
            import(context, game);
          },
        ).submenuButton(
          context: context,
          child: AppText.tr("importToOther"),
        ),
      ],
    );
  }
}

class _SaveAsButton extends StatelessWidget {
  final NikkiasManifest manifest;
  final File nikkiasFile;

  const _SaveAsButton({required this.manifest, required this.nikkiasFile});

  Future<void> saveRawFile(BuildContext context) async {
    final Path nikkiasPath = Path(nikkiasFile.path);

    final String? location = await NativeFilePicker.getDirectoryPath(
      dialogTitle: context.tr("saveAs"),
      lockParentWindow: true,
    );

    if (location != null) {
      final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
      if (context.mounted) {
        showProgressBar(context: context, valueListenable: progress);
      }

      final Path savePath = Path(location) + nikkiasPath.name;
      try {
        if (await savePath.file.exists()) await savePath.file.delete();

        await nikkiasFile.copy(savePath.path);
      } finally {
        progress.value = 1;
      }

      if (context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> saveDecodedFile(BuildContext context) async {
    final String? location = await NativeFilePicker.getDirectoryPath(
      dialogTitle: context.tr("saveAs"),
      lockParentWindow: true,
    );

    if (location != null) {
      final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
      if (context.mounted) {
        showProgressBar(context: context, valueListenable: progress);
      }

      await NikkiasCodec.decompress(
        nikkiasFile,
        Directory(location),
        (double decompressProgress) => progress.value = decompressProgress,
      );

      if (context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          AppTheme.of(context)!.colorScheme.background.color,
        ),
      ),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return AppButton.smallText(
              colorRole: ColorRole.background,
              isTransparent: false,
              onClick: () async {
                controller.isOpen ? controller.close() : controller.open();
              },
              child: AppText.tr("saveAs"),
            );
          },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            saveRawFile(context);
          },
          child: AppText.tr("saveDirectly"),
        ),

        MenuItemButton(
          onPressed: () {
            saveDecodedFile(context);
          },
          child: AppText.tr("saveDecoded"),
        ),
      ],
    );
  }
}
