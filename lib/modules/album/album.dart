

import "album_view.dart";
import "album_previewer.dart";
import "package:nikki_albums/info.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/modules/game/game.dart";
import "package:nikki_albums/modules/game/album_manager.dart";
import "package:nikki_albums/modules/game/infinity_nikki/service/live_photo_export_service.dart";
import "package:nikki_albums/modules/game/infinity_nikki/domain/param_codec.dart";
import "package:nikki_albums/modules/nuan5_params/model/tree_node.dart";
import "package:nikki_albums/modules/album/mp4_to_gif.dart";
import 'package:nikki_albums/utils/ffmpeg_manager.dart';
import 'package:nikki_albums/utils/exiftool_manager.dart';
import "package:nikki_albums/modules/image_edit/presentation/image_editor.dart";
import "package:nikki_albums/modules/setting/setting.dart";
import "package:nikki_albums/modules/file_transfer/file_transfer.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/modules/nikkias/nikkias.dart";
import "package:nikki_albums/modules/tutorial/tutorial.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/utils/path.dart";
import "package:nikki_albums/utils/Image.dart";
import "package:nikki_albums/utils/clipboard.dart";
import "package:nikki_albums/src/rust/nuan5_params/decode.dart";
import "package:nikki_albums/modules/nuan5_params/presentation/media_params_tree.dart";
import "package:nikki_albums/modules/parameter_manager/domain/param_box_manager.dart";
import "package:nikki_albums/modules/parameter_manager/domain/param_import.dart";
import "package:nikki_albums/modules/parameter_manager/domain/param_item_edit_controller.dart";
import "package:nikki_albums/modules/parameter_manager/model/param_item.dart";
import "package:nikki_albums/modules/parameter_manager/presentation/param_item_edit_panel.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/clock_in_photo_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/nikki_photo_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/gestures.dart";
import "dart:io";
import "dart:ui" hide Path;

import "package:multi_split_view/multi_split_view.dart";
import "package:easy_localization/easy_localization.dart";
import "package:file_picker/file_picker.dart";
import "package:nikki_albums/utils/native_file_picker.dart";
import "package:desktop_drop/desktop_drop.dart";
import "package:uuid/uuid.dart";
import "package:media_kit/media_kit.dart";
import "package:media_kit_video/media_kit_video.dart";
import "package:path/path.dart" as p;

final ContentItem item = ContentItem(
  name: "album",
  icon: AppIcon("album", height: mediumButtonContentSize),
  page: const Album(key: ValueKey("album")),
);

class AlbumValuePool extends InheritedWidget {
  final AlbumHandler handler = AlbumHandler();
  final ValueNotifier<bool> isPrimaryMouseDown = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isDragScrollbar = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isShowTimeHeader = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isPressTag = ValueNotifier<bool>(false);
  final Map<AlbumType, double> offset = {};

  AlbumValuePool({super.key, required super.child});

  @override
  bool updateShouldNotify(AlbumValuePool oldWidget) => false;

  static AlbumValuePool of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AlbumValuePool>()
        as AlbumValuePool;
  }
}

class AlbumHandler {
  const AlbumHandler();

  void refresh(Game game) {
    game.refresh();
  }

  void changeSortOrder(Game game) {
    if (game.album.sortOrder == SortOrder.descending) {
      game.album.sortOrder = SortOrder.ascending;
    } else {
      game.album.sortOrder = SortOrder.descending;
    }
  }

  void layoutMinus() {
    if (AppState.albumColumn.value > 1) AppState.albumColumn.value--;
  }

  void layoutPlus() {
    AppState.albumColumn.value++;
  }

  void deselect(Game game) {
    game.album.deselectAllImage();
  }

  void selectAll(Game game) {
    game.album.selectAllImage();
  }

  void invertSelect(Game game) {
    game.album.invertAllImage();
  }

  void viewSelect(BuildContext context, Game game) {
    showAppDialog(
      context: context,
      builder: (BuildContext context) => SelectionViewerDialog(game: game),
    );
  }

  void moveOutside(BuildContext context, Game game) {
    final ValueNotifier<double> progress = ValueNotifier(0);
    int errorNum = 0;

    showProgressBar(
      context: context,
      valueListenable: progress,
      autoClose: false,
      completedBuilder: (BuildContext context, void Function() close) {
        if (errorNum == 0) {
          close();
          return block0;
        }

        return Column(
          spacing: listSpacing,
          children: [
            AppText(context.plural("XImageFailedToBeProcessed", errorNum)),
            const FailToCopyFileSystemEntry(),
            AppButton.smallText(
              width: null,
              onClick: close,
              child: AppText.tr("ok"),
            ),
          ],
        );
      },
    );

    game.backupSelectedImages(
      onProgress: (double currentProgress) {
        progress.value = currentProgress;
      },
      onError: (Set items) {
        errorNum = items.length;
      },
    );
  }

  void moveInside(BuildContext context, Game game) {
    final ValueNotifier<double> progress = ValueNotifier(0);
    int errorNum = 0;

    showProgressBar(
      context: context,
      valueListenable: progress,
      autoClose: false,
      completedBuilder: (BuildContext context, void Function() close) {
        if (errorNum == 0) {
          close();
          return block0;
        }

        return Column(
          spacing: listSpacing,
          children: [
            AppText(context.plural("XImageFailedToBeProcessed", errorNum)),
            const FailToCopyFileSystemEntry(),
            AppButton.smallText(
              width: null,
              onClick: close,
              child: AppText.tr("ok"),
            ),
          ],
        );
      },
    );

    game.restoreSelectedImages(
      onProgress: (double currentProgress) {
        progress.value = currentProgress;
      },
      onError: (Set items) {
        errorNum = items.length;
      },
    );
  }

  void delete(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) => DeleteImagesDialog(game: game),
    );
  }

  void import(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ImportImagesDialog(game),
    );
  }

  /// copy images to clipboard
  Future<void> copy(BuildContext context, List<ImageItem> images) async {
    final String liveFormat = AppState.livePhotoExportFormat.value;
    final bool isVideoAlbum =
        AppState.currentGame.value?.selectedAlbum == AlbumType.Video;

    if (Platform.isWindows && isVideoAlbum && liveFormat == "apple") {
      if (!await FFmpegManager.checkAndDownload(context)) {
        return;
      }
    }

    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
    bool isError = false;

    if (context.mounted) {
      AppToast.showMessage(context: context, message: context.tr("pa_on_copy"));
    }

    try {
      if (isVideoAlbum && liveFormat != "none") {
        // Convert to live photo format in temp dir, then copy
        final Directory tempDir = Directory(
          p.join(Directory.systemTemp.path, "nikki_albums_live_photo_temp"),
        );
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
        await tempDir.create(recursive: true);

        final LivePhotoExportService exporter = LivePhotoExportService();
        final Set<Path> outputPaths = {};

        for (final ImageItem item in images) {
          if (item.cover != null && await File(item.cover!).exists()) {
            await exporter.export(
              format: liveFormat == "apple"
                  ? ExportFormat.appleLivePhoto
                  : ExportFormat.googleMotionPhoto,
              coverImage: File(item.cover!),
              sourceVideo: item.path.file,
              outputPath: tempDir.path,
            );
            // Collect output files
            await for (final FileSystemEntity entity in tempDir.list()) {
              if (entity is File) {
                outputPaths.add(Path(entity.path));
              }
            }
          } else {
            outputPaths.add(item.path);
          }
        }
        await copyFilesToClipboard(outputPaths.toList());
      } else {
        final List<Path> paths = images
            .map((item) => item.path)
            .toList(growable: false);
        await copyFilesToClipboard(paths);
      }
    } catch (e) {
      isError = true;
    } finally {
      progress.value = 1;
    }

    if (context.mounted) {
      AppToast.showMessage(
        context: context,
        message: context.tr(isError ? "pa_copy_failed" : "pa_copy_successful"),
        state: !isError,
      );
    }
  }

  /// export images to native device
  Future<void> exportToLocal(BuildContext context, List<ImageItem> images, {String? savePath}) async{
    final String liveFormat = AppState.livePhotoExportFormat.value;
    final bool isVideoAlbum =
        AppState.currentGame.value?.selectedAlbum == AlbumType.Video;

    if (Platform.isWindows && isVideoAlbum && liveFormat == "apple") {
      if (!await FFmpegManager.checkAndDownload(context)) {
        return;
      }
    }

    late final String? location;
    if(savePath != null){
      location = savePath;
    }else{
      if(context.mounted){
        location = await NativeFilePicker.getDirectoryPath(
          dialogTitle: context.plural("exportXImage", images.length),
          lockParentWindow: true,
        );
      }else{
        location = null;
      }
    }
    if (location == null) return;

    final Path root = Path(location);

    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
    final int total = images.length;
    int current = 0;
    int errorNum = 0;
    List<String> errors = [];

    if (context.mounted) {
      showProgressBar(
        context: context,
        barrierDismissible: false,
        autoClose: false,
        valueListenable: progress,
        completedBuilder: (BuildContext context, void Function() close) {
          return Column(
            spacing: listSpacing,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (errorNum != 0) ...[
                AppText(context.plural("XImageFailedToBeProcessed", errorNum)),
                Text(
                  errors.take(3).join('\n'),
                  style: TextStyle(
                    color: AppTheme.of(context)!.colorScheme.error.color,
                    fontSize: 12,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              AppButton.smallText(
                width: null,
                colorRole: ColorRole.background,
                isTranslate: false,
                onClick: close,
                child: AppText.tr("close"),
              ),
            ],
          );
        },
      );
    }

    final bool useIosNaming =
        Platform.isWindows && isVideoAlbum && liveFormat == "apple";

    final List<ImageItem> sortedImages = List<ImageItem>.from(images)
      ..sort((a, b) {
        final int timeComp = a.time.compareTo(b.time);
        if (timeComp != 0) return timeComp;
        return a.name.compareTo(b.name);
      });

    final Set<int> occupiedNumbers = {};
    if (useIosNaming) {
      try {
        final Directory dir = Directory(root.path);
        if (await dir.exists()) {
          final RegExp imgPattern = RegExp(
            r'^IMG_(\d{4})\.',
            caseSensitive: false,
          );
          await for (final FileSystemEntity entity in dir.list()) {
            if (entity is File) {
              final String name = p.basename(entity.path);
              final Match? match = imgPattern.firstMatch(name);
              if (match != null) {
                final int? val = int.tryParse(match.group(1)!);
                if (val != null) {
                  occupiedNumbers.add(val);
                }
              }
            }
          }
        }
      } catch (_) {}
    }

    for (final ImageItem item in sortedImages) {
      try {
        String? customBaseName;
        if (useIosNaming) {
          final RegExp microsecondPattern = RegExp(r'_(\d{6})$');
          final String originalBaseName = p.basenameWithoutExtension(
            item.path.path,
          );
          final Match? match = microsecondPattern.firstMatch(originalBaseName);
          int microseconds;
          if (match != null) {
            microseconds =
                int.tryParse(match.group(1)!) ??
                item.time.microsecondsSinceEpoch;
          } else {
            microseconds = item.time.microsecondsSinceEpoch;
          }
          int baseNumber = microseconds % 10000;
          if (baseNumber < 0) baseNumber = -baseNumber;
          if (baseNumber == 0) baseNumber = 1;

          int seqNum = baseNumber;
          while (occupiedNumbers.contains(seqNum)) {
            seqNum = (seqNum % 9999) + 1;
          }
          occupiedNumbers.add(seqNum);
          customBaseName = 'IMG_${seqNum.toString().padLeft(4, '0')}';
        }

        if (isVideoAlbum && liveFormat != "none" && item.cover != null) {
          final File coverFile = File(item.cover!);
          if (await coverFile.exists()) {
            final LivePhotoExportService exporter = LivePhotoExportService();
            await exporter.export(
              format: liveFormat == "apple"
                  ? ExportFormat.appleLivePhoto
                  : ExportFormat.googleMotionPhoto,
              coverImage: coverFile,
              sourceVideo: item.path.file,
              outputPath: root.path,
              customBaseName: customBaseName,
            );
          } else {
            final String ext = item.path.extension;
            final String outName = customBaseName != null
                ? '$customBaseName.${ext.toLowerCase()}'
                : item.path.name;
            final Path destination = root + outName;
            await item.path.file.copy(destination.path);
          }
        } else {
          final String ext = item.path.extension;
          final String outName = customBaseName != null
              ? '$customBaseName.${ext.toLowerCase()}'
              : item.path.name;
          final Path destination = root + outName;
          await item.path.file.copy(destination.path);
        }
      } catch (e) {
        errorNum++;
        errors.add(e.toString());
      } finally {
        current++;
        progress.value = current / total;
      }
    }
    progress.value = 1;
    if (errors.isNotEmpty) {
      try {
        final File logFile = File('${root.path}/export_debug.log');
        await logFile.writeAsString(
          '--- Export Errors ---\n\n${errors.join('\n\n')}',
        );
      } catch (_) {}
    }
  }

  /// export images to network device
  void exportToNetwork(BuildContext context) {
    if (AppState.currentGame.value != null) {
      exportImageToNetwork(context, AppState.currentGame.value!);
    }
  }

  /// export to macOS Photo Library (only for Video album on macOS)
  Future<void> exportToPhotoLibrary(
    BuildContext context,
    List<ImageItem> images,
  ) async {
    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
    final int total = images.length;
    int current = 0;
    int errorNum = 0;

    if (context.mounted) {
      showProgressBar(
        context: context,
        barrierDismissible: false,
        autoClose: false,
        valueListenable: progress,
        completedBuilder: (BuildContext context, void Function() close) {
          return Column(
            spacing: listSpacing,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (errorNum != 0)
                Text(
                  context.plural("XImageFailedToBeProcessed", errorNum),
                  style: TextStyle(
                    color: AppTheme.of(context)!.colorScheme.error.pressedColor,
                  ),
                ),
              AppButton.smallText(
                width: null,
                colorRole: ColorRole.background,
                isTransparent: false,
                onClick: close,
                child: AppText.tr("close"),
              ),
            ],
          );
        },
      );
    }

    final bool isVideoAlbum =
        AppState.currentGame.value?.selectedAlbum == AlbumType.Video;
    final String liveFormat = AppState.livePhotoExportFormat.value;
    const channel = MethodChannel("com.ranaxro.nikki.nikkiAlbums/live_photo");

    final List<String> allFilesToImport = [];

    for (final ImageItem item in images) {
      try {
        if (isVideoAlbum &&
            liveFormat == "apple" &&
            item.cover != null &&
            await File(item.cover!).exists()) {
          final String assetIdentifier = const Uuid().v4().toUpperCase();
          final tempDir = await Directory.systemTemp.createTemp(
            "nikki_livephoto_",
          );
          final String baseName = item.path.subName;
          final String tempVideo = "${tempDir.path}/$baseName.mov";
          final String tempImage = "${tempDir.path}/$baseName.jpg";

          await channel.invokeMethod("remuxMp4ToMov", {
            "inputPath": item.path.path,
            "outputPath": tempVideo,
            "assetIdentifier": assetIdentifier,
          });
          await channel.invokeMethod("injectImageMetadata", {
            "inputPath": item.cover!,
            "outputPath": tempImage,
            "assetIdentifier": assetIdentifier,
          });
          allFilesToImport.add(tempImage);
          allFilesToImport.add(tempVideo);
        } else {
          allFilesToImport.add(item.path.path);
        }
      } catch (e) {
        errorNum++;
      } finally {
        current++;
        progress.value = current / total;
      }
    }

    // Import all files at once via NSSharingService
    if (allFilesToImport.isNotEmpty) {
      try {
        await channel.invokeMethod("importBatchToPhotoLibrary", {
          "filePaths": allFilesToImport,
        });
      } catch (e) {
        errorNum++;
      }
    }
    progress.value = 1;
  }

  /// encode and export nikkias file to native device
  Future<void> exportNikkiasToLocal(
    BuildContext context,
    List<ImageItem> images,
  ) async {
    if (AppState.currentGame.value == null) return;
    final Game game = AppState.currentGame.value!;

    final String? location = await NativeFilePicker.getDirectoryPath(
      dialogTitle: context.tr("exportNikkiasFile"),
      lockParentWindow: true,
    );
    if (location == null) return;

    final Path root = Path(location);
    final String filename =
        "${DateTime.now().millisecondsSinceEpoch}.$nikkiasExtension";
    final Path savePath = root + filename;

    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
    bool isError = false;

    if (context.mounted) {
      showProgressBar(
        context: context,
        barrierDismissible: false,
        autoClose: false,
        valueListenable: progress,
        completedBuilder: (BuildContext context, void Function() close) {
          return Column(
            spacing: listSpacing,
            mainAxisSize: MainAxisSize.min,
            children: [
              isError
                  ? Text(
                      context.plural(
                        "XImageFailedToBeProcessed",
                        images.length,
                      ),
                      style: TextStyle(
                        color: AppTheme.of(
                          context,
                        )!.colorScheme.error.pressedColor,
                      ),
                    )
                  : Text(
                      filename,
                      style: TextStyle(
                        color: AppTheme.of(context)!.colorScheme.error.onColor,
                      ),
                    ),
              AppButton.smallText(
                width: null,
                colorRole: ColorRole.background,
                isTransparent: false,
                onClick: close,
                child: AppText.tr("close"),
              ),
            ],
          );
        },
      );
    }

    final ImageTransferNikkiasManifest manifest = ImageTransferNikkiasManifest(
      launcherChannel: game.launcherChannel,
      uid: game.selectedUid?.value ?? "",
      albumType: game.selectedAlbum,
    );
    try {
      final ImageTransferNikkiasCodec codec = ImageTransferNikkiasCodec(
        manifest,
        savePath.file,
        game.installPath,
      );
      codec.filenameWhitelist = game.album.selectedImages
          .map((ImageItem item) => item.name)
          .toList();
      await codec.encode(
        (double encodeProgress) => progress.value = encodeProgress,
      );
    } catch (e) {
      isError = true;
    } finally {
      progress.value = 1;
      Explorer.openFile(savePath.file);
    }
  }

  /// export option
  void openExportSetting(BuildContext context){
    SettingDialog.show(context, initialPage: SettingPage.exportingImageSetting);
  }

  static AlbumHandler of(BuildContext context) {
    return AlbumValuePool.of(context).handler;
  }
}

class Album extends StatelessWidget {
  const Album({super.key});

  @override
  Widget build(BuildContext context) {
    return AlbumValuePool(
      child: Builder(
        builder: (BuildContext context) {
          return CallbackShortcuts(
            bindings: {
              /// 刷新
              const SingleActivator(LogicalKeyboardKey.f5): () {
                if (AppState.currentGame.value != null) {
                  AlbumHandler.of(context).refresh(AppState.currentGame.value!);
                }
              },

              /// 增加列数
              const SingleActivator(LogicalKeyboardKey.equal): () {
                if (AppState.currentGame.value != null) {
                  AlbumHandler.of(context).layoutPlus();
                }
              },

              /// 减少列数
              const SingleActivator(LogicalKeyboardKey.minus): () {
                if (AppState.currentGame.value != null) {
                  AlbumHandler.of(context).layoutMinus();
                }
              },

              /// 反选
              const SingleActivator(
                LogicalKeyboardKey.keyD,
                control: true,
              ): () {
                if (AppState.currentGame.value != null) {
                  AlbumHandler.of(
                    context,
                  ).deselect(AppState.currentGame.value!);
                }
              },
              const SingleActivator(LogicalKeyboardKey.keyD, meta: true): () {
                if (Platform.isMacOS) {
                  if (AppState.currentGame.value != null) {
                    AlbumHandler.of(
                      context,
                    ).deselect(AppState.currentGame.value!);
                  }
                }
              },

              /// 全选
              const SingleActivator(
                LogicalKeyboardKey.keyA,
                control: true,
              ): () {
                if (AppState.currentGame.value != null) {
                  AlbumHandler.of(
                    context,
                  ).selectAll(AppState.currentGame.value!);
                }
              },
              const SingleActivator(LogicalKeyboardKey.keyA, meta: true): () {
                if (Platform.isMacOS) {
                  if (AppState.currentGame.value != null) {
                    AlbumHandler.of(
                      context,
                    ).selectAll(AppState.currentGame.value!);
                  }
                }
              },

              /// 查看选中
              const SingleActivator(LogicalKeyboardKey.keyV): () {
                if (AppState.currentGame.value != null) {
                  AlbumHandler.of(
                    context,
                  ).viewSelect(context, AppState.currentGame.value!);
                }
              },

              /// 移出
              const SingleActivator(
                LogicalKeyboardKey.keyO,
                control: true,
              ): () {
                if (AppState.currentGame.value != null &&
                    AppState.currentGame.value!.album.backupAlbumPath != null &&
                    AppState
                        .currentGame
                        .value!
                        .album
                        .selectedImages
                        .isNotEmpty) {
                  AlbumHandler.of(
                    context,
                  ).moveOutside(context, AppState.currentGame.value!);
                }
              },
              const SingleActivator(LogicalKeyboardKey.keyO, meta: true): () {
                if (Platform.isMacOS) {
                  if (AppState.currentGame.value != null &&
                      AppState.currentGame.value!.album.backupAlbumPath !=
                          null &&
                      AppState
                          .currentGame
                          .value!
                          .album
                          .selectedImages
                          .isNotEmpty) {
                    AlbumHandler.of(
                      context,
                    ).moveOutside(context, AppState.currentGame.value!);
                  }
                }
              },

              /// 移入
              const SingleActivator(
                LogicalKeyboardKey.keyI,
                control: true,
              ): () {
                if (AppState.currentGame.value != null &&
                    AppState.currentGame.value!.album.backupAlbumPath != null &&
                    AppState
                        .currentGame
                        .value!
                        .album
                        .selectedImages
                        .isNotEmpty) {
                  AlbumHandler.of(
                    context,
                  ).moveInside(context, AppState.currentGame.value!);
                }
              },
              const SingleActivator(LogicalKeyboardKey.keyI, meta: true): () {
                if (Platform.isMacOS) {
                  if (AppState.currentGame.value != null &&
                      AppState.currentGame.value!.album.backupAlbumPath !=
                          null &&
                      AppState
                          .currentGame
                          .value!
                          .album
                          .selectedImages
                          .isNotEmpty) {
                    AlbumHandler.of(
                      context,
                    ).moveInside(context, AppState.currentGame.value!);
                  }
                }
              },

              /// 删除
              const SingleActivator(LogicalKeyboardKey.delete): () {
                if (AppState.currentGame.value != null &&
                    AppState
                        .currentGame
                        .value!
                        .album
                        .selectedImages
                        .isNotEmpty) {
                  AlbumHandler.of(
                    context,
                  ).delete(context, AppState.currentGame.value!);
                }
              },

              /// 导出到剪贴板
              const SingleActivator(
                LogicalKeyboardKey.keyC,
                control: true,
              ): () {
                if (AppState.currentGame.value != null &&
                    AppState
                        .currentGame
                        .value!
                        .album
                        .selectedImages
                        .isNotEmpty) {
                  AlbumHandler.of(context).copy(
                    context,
                    AppState.currentGame.value!.album.selectedImages.toList(),
                  );
                }
              },
              const SingleActivator(LogicalKeyboardKey.keyC, meta: true): () {
                if (Platform.isMacOS) {
                  if (AppState.currentGame.value != null &&
                      AppState
                          .currentGame
                          .value!
                          .album
                          .selectedImages
                          .isNotEmpty) {
                    AlbumHandler.of(context).copy(
                      context,
                      AppState.currentGame.value!.album.selectedImages.toList(),
                    );
                  }
                }
              },

              /// 导出到本地
              const SingleActivator(
                LogicalKeyboardKey.keyS,
                control: true,
              ): () {
                if (AppState.currentGame.value != null &&
                    AppState
                        .currentGame
                        .value!
                        .album
                        .selectedImages
                        .isNotEmpty) {
                  AlbumHandler.of(context).exportToLocal(
                    context,
                    AppState.currentGame.value!.album.selectedImages.toList(),
                  );
                }
              },
              const SingleActivator(LogicalKeyboardKey.keyS, meta: true): () {
                if (Platform.isMacOS) {
                  if (AppState.currentGame.value != null &&
                      AppState
                          .currentGame
                          .value!
                          .album
                          .selectedImages
                          .isNotEmpty) {
                    AlbumHandler.of(context).exportToLocal(
                      context,
                      AppState.currentGame.value!.album.selectedImages.toList(),
                    );
                  }
                }
              },

              /// 导出到网络
              const SingleActivator(
                LogicalKeyboardKey.keyW,
                control: true,
              ): () {
                if (AppState.currentGame.value != null &&
                    AppState
                        .currentGame
                        .value!
                        .album
                        .selectedImages
                        .isNotEmpty) {
                  AlbumHandler.of(context).exportToNetwork(context);
                }
              },
              const SingleActivator(LogicalKeyboardKey.keyW, meta: true): () {
                if (Platform.isMacOS) {
                  if (AppState.currentGame.value != null &&
                      AppState
                          .currentGame
                          .value!
                          .album
                          .selectedImages
                          .isNotEmpty) {
                    AlbumHandler.of(context).exportToNetwork(context);
                  }
                }
              },
            },
            child: Focus(
              autofocus: true,
              child: Stack(children: [AlbumExhibition(), ToolBar()]),
            ),
          );
        },
      ),
    );
  }
}

/// ---------- top bar ---------- ///

class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  Widget gameListenerBuilder(
    Game game,
    Widget Function(bool isExistSelectedImage, bool isAllowBackup) builder,
  ) {
    return ListenableBuilder(
      listenable: game,
      builder: (BuildContext context, Widget? child) {
        final bool isAllowBackup = game.isAllowBackup(game.selectedAlbum);

        return ListenableBuilder(
          listenable: game.album,
          builder: (BuildContext context, Widget? child) {
            return NotifierBuilder(
              listenable: game.album.whenSelectedImagesChange,
              builder: (BuildContext context, Widget? child) {
                final bool isExistSelectedImage =
                    game.album.selectedImages.isNotEmpty;

                return builder(isExistSelectedImage, isAllowBackup);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget toolButtons = ValueListenableBuilder(
      valueListenable: AppState.currentGame,
      builder: (BuildContext context, Game? game, Widget? child) {
        if (game == null) return block0;

        return Row(
          children: [
            gameListenerBuilder(game, (
              bool isExistSelectedImage,
              bool isAllowBackup,
            ) {
              if (!isExistSelectedImage) return block0;

              return AppText(
                context.plural(
                  "pa_select_X_image",
                  game.album.selectedImages.length,
                ),
              );
            }),

            ...[
              /// 刷新
              AppFloatingIndicatorButtonTarget(
                child: AppButton.smallIcon(
                  toolTip: "refresh",
                  toolTipShortcut: [LogicalKeyboardKey.f5],
                  onClick: () {
                    AlbumHandler.of(context).refresh(game);
                  },
                  child: AppIcon("refresh", height: 18),
                ),
              ),

              /// 筛选
              AppFloatingIndicatorButtonTarget(
                child: FiltrationButton(game: game),
              ),

              /// 排序
              AppFloatingIndicatorButtonTarget(
                child: ListenableBuilder(
                  listenable: game,
                  builder: (BuildContext context, Widget? child) {
                    return ListenableBuilder(
                      listenable: game.album,
                      builder: (BuildContext context, Widget? child) {
                        final String text = context.tr(
                          (game.album.sortOrder == SortOrder.ascending
                                  ? SortOrder.descending
                                  : SortOrder.ascending)
                              .name,
                        );
                        final String icon = game.album.sortOrder.name;

                        return Tooltip(
                          message: text,
                          child: AppButton.smallIcon(
                            colorRole: ColorRole.secondary,
                            onClick: () {
                              AlbumHandler.of(context).changeSortOrder(game);
                            },
                            child: AppIcon(icon, height: 20),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              AppDivider(direction: Axis.vertical),

              /// 减少列数
              AppFloatingIndicatorButtonTarget(
                child: AppButton.smallIcon(
                  toolTip: "pa_layout_minus",
                  toolTipShortcut: [LogicalKeyboardKey.minus],
                  onClick: AlbumHandler.of(context).layoutMinus,
                  child: AppIcon("layout_minus", height: 20),
                ),
              ),

              /// 增加列数
              AppFloatingIndicatorButtonTarget(
                child: AppButton.smallIcon(
                  toolTip: "pa_layout_plus",
                  toolTipShortcut: [LogicalKeyboardKey.add],
                  onClick: AlbumHandler.of(context).layoutPlus,
                  child: AppIcon("layout_plus", height: 20),
                ),
              ),

              AppDivider(direction: Axis.vertical),

              /// 取消选择
              AppFloatingIndicatorButtonTarget(
                child: AppButton.smallIcon(
                  toolTip: "deselect",
                  toolTipShortcut: [
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.keyD,
                  ],
                  onClick: () {
                    AlbumHandler.of(context).deselect(game);
                  },
                  child: AppIcon("deselect", height: 20),
                ),
              ),

              /// 全选
              AppFloatingIndicatorButtonTarget(
                child: AppButton.smallIcon(
                  toolTip: "select_all",
                  toolTipShortcut: [
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.keyA,
                  ],
                  onClick: () {
                    AlbumHandler.of(context).selectAll(game);
                  },
                  child: AppIcon("select_all", height: 20),
                ),
              ),

              /// 反选
              AppFloatingIndicatorButtonTarget(
                child: AppButton.smallIcon(
                  toolTip: "invert_select",
                  onClick: () {
                    AlbumHandler.of(context).invertSelect(game);
                  },
                  child: AppIcon("invert", height: 16),
                ),
              ),

              /// 查看选中
              gameListenerBuilder(game, (
                bool isExistSelectedImage,
                bool isAllowBackup,
              ) {
                final bool usable = isExistSelectedImage;

                return AppFloatingIndicatorButtonTarget(
                  isTarget: usable,
                  child: AppButton.smallIcon(
                    toolTip: usable ? "viewSelect" : "",
                    toolTipShortcut: [LogicalKeyboardKey.keyV],
                    onClick: () {
                      AlbumHandler.of(context).viewSelect(context, game);
                    },
                    usable:
                        (game.selectedAlbum == AlbumType.Video ||
                            game.selectedAlbum == AlbumType.ExternalVideo)
                        ? false
                        : usable,
                    child: AppIcon("view", height: 18),
                  ),
                );
              }),

              AppDivider(direction: Axis.vertical),

              /// 移出
              gameListenerBuilder(game, (
                bool isExistSelectedImage,
                bool isAllowBackup,
              ) {
                final bool usable = isExistSelectedImage && isAllowBackup;

                return AppFloatingIndicatorButtonTarget(
                  isTarget: usable,
                  child: AppButton.smallIcon(
                    toolTip: usable ? "remove" : "",
                    toolTipShortcut: [
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.keyO,
                    ],
                    onClick: () {
                      AlbumHandler.of(context).moveOutside(context, game);
                    },
                    usable: usable,
                    child: AppIcon("remove", height: 20),
                  ),
                );
              }),

              /// 移入
              gameListenerBuilder(game, (
                bool isExistSelectedImage,
                bool isAllowBackup,
              ) {
                final bool usable = isExistSelectedImage && isAllowBackup;

                return AppFloatingIndicatorButtonTarget(
                  isTarget: usable,
                  child: AppButton.smallIcon(
                    toolTip: usable ? "insert" : "",
                    toolTipShortcut: [
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.keyI,
                    ],
                    onClick: () {
                      AlbumHandler.of(context).moveInside(context, game);
                    },
                    usable: usable,
                    child: AppIcon("insert", height: 16),
                  ),
                );
              }),

              /// 删除
              gameListenerBuilder(game, (
                bool isExistSelectedImage,
                bool isAllowBackup,
              ) {
                final bool usable = isExistSelectedImage;

                return AppFloatingIndicatorButtonTarget(
                  isTarget: isExistSelectedImage,
                  child: AppButton.smallIcon(
                    toolTip: usable ? "delete" : "",
                    toolTipShortcut: [LogicalKeyboardKey.delete],
                    onClick: () {
                      AlbumHandler.of(context).delete(context, game);
                    },
                    usable: usable,
                    child: AppIcon("delete", height: 20),
                  ),
                );
              }),

              AppDivider(direction: Axis.vertical),

              /// 导出
              gameListenerBuilder(game, (
                bool isExistSelectedImage,
                bool isAllowBackup,
              ) {
                return AppFloatingIndicatorButtonTarget(
                  isTarget: isExistSelectedImage,
                  child: ExportImagesButton(
                    usable: isExistSelectedImage,
                    images: game.album.selectedImages.toList(growable: false),
                  ),
                );
              }),

              /// 导入
              AppFloatingIndicatorButtonTarget(
                child: AppButton.smallIcon(
                  toolTip: "import",
                  onClick: () {
                    AlbumHandler.of(context).import(context, game);
                  },
                  usable: game.selectedAlbum != AlbumType.Video,
                  child: AppIcon("import", height: 18),
                ),
              ),

              // DragItemWidget(
              //   dragItemProvider: (_) async => createFilesDragItem(AppState.currentGame.value!.selectedImages.toList().map((ImageItem item) => item.path).toList()),
              //   allowedOperations: () => [DropOperation.copy],
              //   child: SmallButton(
              //     onClick: (){
              //       print(AppState.currentGame.value!.selectedImages.toList().map((ImageItem item) => item.path).toList().length);
              //     },
              //     child: Text("drag"),
              //   ),
              // ),
            ],
          ],
        );
      },
    );

    /// TODO 多tab
    final Widget toolBox = AppFloatingIndicatorButtonGroup(
      child: Row(
        spacing: listSpacing,
        children: [
          AppFloatingIndicatorButtonTarget(child: AlbumButton()),

          /// tag button
          ValueListenableBuilder(
            valueListenable: AppState.currentGame,
            builder: (BuildContext context, Game? game, Widget? child) {
              if (game == null) return block0;

              return AppFloatingIndicatorButtonTarget(
                child: AppButton.smallIcon(
                  onClick: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return TagListDialog(game);
                      },
                    );
                  },
                  child: AppIcon("tag", height: 16),
                ),
              );
            },
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SmoothPointerScroll(
                builder:
                    (
                      BuildContext context,
                      ScrollController controller,
                      ScrollPhysics physics,
                      IndependentScrollbarController scrollbarController,
                    ) {
                      return SingleChildScrollView(
                        controller: controller,
                        physics: physics,
                        scrollDirection: Axis.horizontal,
                        child: toolButtons,
                      );
                    },
              ),
            ),
          ),
        ],
      ),
    );

    // back
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      height: topBarHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: AppTheme.of(
                context,
              )!.colorScheme.secondary.color.withAlpha(0x99),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: listSpacing),
                child: toolBox,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlbumButton extends StatelessWidget {
  const AlbumButton({super.key});

  void _openAlbumFolder() {
    AppState.currentGame.value?.album.gameAlbumPath?.open();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Game?>(
      valueListenable: AppState.currentGame,
      builder: (BuildContext context, Game? game, Widget? child) {
        if (game == null) return block0;

        return AppDropdown(
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
                final Widget buttonContent = ListenableBuilder(
                  listenable: game,
                  builder: (BuildContext context, Widget? child) {
                    return Row(
                      spacing: listSpacing,
                      children: [
                        AppIcon("album/${game.selectedAlbum.name}", height: 18),
                        AppText.tr(albumsInfoMap[game.selectedAlbum]!.name),
                      ],
                    );
                  },
                );

                return GestureDetector(
                  onSecondaryTap: () {
                    _openAlbumFolder();
                  },
                  child: AppButton.smallIcon(
                    padding: const EdgeInsets.all(6),
                    width: null,
                    constraints: const BoxConstraints(minWidth: bigButtonSize),
                    colorRole: ColorRole.secondary,
                    onClick: () {
                      controller.isOpen
                          ? controller.close()
                          : controller.open();
                    },
                    child: buttonContent,
                  ),
                );
              },
          childrenBuilder: (BuildContext context, MenuController controller) {
            final List<Widget> children = <Widget>[];

            for (AlbumType type in game.accessibleAlbumType) {
              final AlbumsInfoItem info = albumsInfoMap[type]!;
              if (info.visible) {
                children.add(
                  AppFloatingIndicatorButtonTarget(
                    child: AppButton.smallText(
                      padding: const EdgeInsets.all(smallPadding),
                      height: mediumButtonSize,
                      onClick: () {
                        game.selectedAlbum = type;
                        controller.close();
                      },
                      child: Row(
                        children: [
                          block5W,
                          AppIcon("album/${info.type}", height: 18),
                          block15W,
                          AppText.tr(info.name),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }

            return children;
          },
        );
      },
    );
  }
}

/// ---------- exhibition ---------- ///

class AlbumExhibition extends StatelessWidget {
  const AlbumExhibition({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.currentGame,
      builder: (BuildContext context, Game? game, Widget? child) {
        if (game == null) {
          return Center(child: AppText.tr("currentGameIsNull"));
        }

        return ListenableBuilder(
          listenable: game,
          builder: (BuildContext context, Widget? child) {
            return ListenableBuilder(
              listenable: game.album,
              builder: (BuildContext context, Widget? child) {
                return RFutureBuilder(
                  future: game.album.process(),
                  builder: (BuildContext context, ProcessedAlbumType album) {
                    return Listener(
                      // 鼠标键按下
                      onPointerDown: (e) {
                        if (e.kind == PointerDeviceKind.mouse &&
                            e.buttons == kPrimaryMouseButton) {
                          AlbumValuePool.of(context).isPrimaryMouseDown.value =
                              true;
                        }
                      },
                      // 鼠标键松开
                      onPointerUp: (e) {
                        if (e.kind == PointerDeviceKind.mouse) {
                          AlbumValuePool.of(context).isPrimaryMouseDown.value =
                              false;
                        }
                      },
                      child: MultiValueListenableBuilder(
                        listenables: [
                          AlbumValuePool.of(context).isShowTimeHeader,
                          AppState.albumColumn,
                        ],
                        builder: (BuildContext context, Widget? child) {
                          final bool isShowTimeHeader = AlbumValuePool.of(
                            context,
                          ).isShowTimeHeader.value;
                          final int column = AppState.albumColumn.value;

                          if (isShowTimeHeader) {
                            return AlbumExhibitionWithHeader(
                              game: game,
                              album: album,
                              column: column,
                            );
                          }
                          return GridAlbum(
                            game: game,
                            images: [],
                            aspectRatio: 1 / 1,
                          );
                          // return GridAlbum(game: game, images: Game.flattenAlbum(album).toList(), aspectRatio: 1 / 1);
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class AlbumExhibitionWithHeader extends StatefulWidget {
  final Game game;
  final ProcessedAlbumType album;
  final int column;

  const AlbumExhibitionWithHeader({
    super.key,
    required this.game,
    required this.album,
    required this.column,
  });

  @override
  State<AlbumExhibitionWithHeader> createState() =>
      _AlbumExhibitionWithHeaderState();
}

class _AlbumExhibitionWithHeaderState extends State<AlbumExhibitionWithHeader> {
  final IndependentScrollbarController scrollbarController =
      IndependentScrollbarController();

  void onDrag() {
    AlbumValuePool.of(context).isDragScrollbar.value =
        scrollbarController.isDrag;
  }

  @override
  void initState() {
    super.initState();
    FFmpegManager.init();
    scrollbarController.addListener(onDrag);
  }

  @override
  Widget build(BuildContext context) {
    return SmoothPointerScroll(
      initialScrollOffset:
          AlbumValuePool.of(context).offset[widget.game.selectedAlbum] ?? 0,
      scrollbarController: scrollbarController,
      builder:
          (
            BuildContext context,
            ScrollController controller,
            ScrollPhysics physics,
            IndependentScrollbarController scrollbarController,
          ) {
            controller.addListener(() {
              if (controller.hasClients) {
                AlbumValuePool.of(context).offset[widget.game.selectedAlbum] =
                    controller.offset;
              }
            });

            return Padding(
              padding: EdgeInsets.only(top: topBarHeight),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: scrollbarThickness + 2 * safeMargin,
                    ),
                    color: AppTheme.of(context)!.colorScheme.background.color,
                    child: AlbumView(
                      album: widget.album,
                      controller: controller,
                      physics: physics,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.column,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      headerHeight: topBarHeight,
                      headerBuilder: (BuildContext context, String title) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          color: AppTheme.of(
                            context,
                          )!.colorScheme.background.color,
                          padding: const EdgeInsets.only(left: listSpacing),
                          height: topBarHeight,
                          child: AppText(title),
                        );
                      },
                      itemBuilder: (BuildContext context, ImageItem item) {
                        return Exhibit(widget.game, item);
                      },
                    ),
                  ),

                  /// scrollbar
                  Positioned(
                    top: 0,
                    right: safeMargin,
                    bottom: 0,
                    width: scrollbarThickness,
                    child: IndependentScrollbar(
                      controller: scrollbarController,
                      thickness: scrollbarThickness,
                      thumbRadius: Radius.circular(5),
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.secondary.onColor.withAlpha(100),
                      hoveredColor: AppTheme.of(
                        context,
                      )!.colorScheme.secondary.onColor.withAlpha(125),
                      pressedColor: AppTheme.of(
                        context,
                      )!.colorScheme.secondary.onColor.withAlpha(150),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }

  @override
  void dispose() {
    scrollbarController.removeListener(onDrag);
    super.dispose();
  }
}

class GridAlbum extends StatelessWidget {
  final Game game;
  final List<ImageItem> images;
  final double aspectRatio;
  const GridAlbum({
    super.key,
    required this.game,
    required this.images,
    required this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppState.albumColumn,
      builder: (BuildContext context, int column, Widget? child) {
        return SmoothPointerScroll(
          builder:
              (
                BuildContext context,
                ScrollController controller,
                ScrollPhysics physics,
                IndependentScrollbarController scrollbarController,
              ) {
                return Row(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.fromLTRB(
                          listSpacing,
                          topBarHeight,
                          listSpacing,
                          10,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: column, // 列数
                          mainAxisSpacing: 16 / column, // 上下间距
                          crossAxisSpacing: 16 / column, // 左右间距
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: images.length,
                        controller: controller,
                        physics: physics,
                        itemBuilder: (context, index) {
                          return KeepAliveWrapper(
                            child: Exhibit(game, images[index]),
                          );
                        },
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: topBarHeight),
                    //   width: 10,
                    //   child: scrollbar,
                    // )
                  ],
                );
              },
        );
      },
    );
  }
}

class Exhibit extends StatefulWidget {
  final Game game;
  final ImageItem imageItem;
  const Exhibit(this.game, this.imageItem, {super.key});

  @override
  State<Exhibit> createState() => _ExhibitState();
}

class _ExhibitState extends State<Exhibit> {
  Widget _generateTagButton(BuildContext context, bool isHover) {
    return Positioned(
      top: smallPadding,
      right: smallPadding,
      width: smallButtonContentSize + 2 * smallBorder,
      height: smallButtonContentSize + 2 * smallBorder,
      child: TagMenu(
        game: widget.game,
        value: widget.imageItem.name,
        builder:
            (
              BuildContext context,
              Color? color,
              Widget? child,
              void Function() trigger,
            ) {
              if (!isHover && color == null) return block0;

              String icon = color == null
                  ? "assets/icon/tag.webp"
                  : "assets/icon/tag_fill.webp";

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Listener(
                  onPointerDown: (_) {
                    AlbumValuePool.of(context).isPressTag.value = true;

                    trigger();
                  },
                  onPointerUp: (_) {
                    AlbumValuePool.of(context).isPressTag.value = false;
                  },
                  onPointerCancel: (_) {
                    AlbumValuePool.of(context).isPressTag.value = false;
                  },
                  child: Image.asset(icon, color: color),
                ),
              );
            },
      ),
    );
  }

  void _showParamItemEditPanel(BuildContext context, [String? initCode, ParamItemCover? initCover]){
    final ParamItemEditController controller = ParamItemEditController(
      initCode: initCode,
      initCover: initCover,
    );

    showAppDialog(
      context: context,
      builder: (BuildContext context){
        return AppDialog(
          useIntrinsicHeight: false,
          child: ParamItemEditPanel(
            controller: controller,
            onCancel: (){
              controller.dispose();
              Navigator.of(context).pop();
            },
            onFinish: (ParamItemCreation creation) async{
              final ParamBoxManager manager = await ParamBoxManager.getDefaultParamBox();
              if(!manager.isInit){
                await manager.init();
              }
              if(manager.isInit){
                if(context.mounted){
                  AppToast.showMessage(context: context, message: context.tr("parameter_manager.on_save"));
                }
                try{
                  await manager.createItem(creation);
                  await manager.save();
                  if(context.mounted){
                    AppToast.showMessage(context: context, message: context.tr("parameter_manager.save_successful"));
                  }
                }catch(e){
                  if(context.mounted){
                    AppToast.showMessage(context: context, message: "${context.tr("parameter_manager.save_failed")}\n$e");
                  }
                }finally{
                  controller.dispose();
                  if(context.mounted){
                    Navigator.of(context).pop();
                  }
                }
              }
            },
          ),
        );
      },
    );
  }

  Widget _generateParamSaverButton(BuildContext context, bool isHover){
    if(!isHover){
      return block0;
    }

    final AlbumType albumType = widget.game.selectedAlbum;
    if(albumType != AlbumType.NikkiPhotos_HighQuality && albumType != AlbumType.ClockInPhoto && albumType != AlbumType.DIY){
      return block0;
    }

    if(widget.game.selectedUid?.value == null){
      return block0;
    }

    return Positioned(
      top: smallButtonSize + smallPadding,
      right: smallPadding,
      width: smallButtonContentSize + 2 * smallBorder,
      height: smallButtonContentSize + 2 * smallBorder,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async{
            final MediaCustomData? customData = await widget.imageItem.getParam(widget.game.selectedUid!.value, widget.game.selectedAlbum);

            customData?.whenOrNull(
              valid: (MediaParam mediaParam){
                mediaParam.whenOrNull(
                  nikkiPhoto: (NikkiPhotoParams nikkiPhotoParams){
                    final String? code = nikkiPhotoParams.camera?.params;
                    if(code == null){
                      return;
                    }

                    _showParamItemEditPanel(context, code, NativeParamItemCover(
                      path: widget.imageItem.path.path,
                      isCache: false,
                    ));
                  },
                  clockInPhoto: (ClockInPhotoParams clockInPhotoParams){
                    final String? code = clockInPhotoParams.camera?.params;
                    if(code == null){
                      return;
                    }

                    _showParamItemEditPanel(context, code, NativeParamItemCover(
                      path: widget.imageItem.path.path,
                      isCache: false,
                    ));
                  },
                  diy: (ClothDiyParams clothDiyParams) async{
                    if(widget.game.selectedUid == null){
                      return;
                    }

                    final String? code = await tryGetClothDiyShareCode(
                      params: clothDiyParams,
                      game: widget.game,
                      uid: widget.game.selectedUid!.value,
                    );

                    if(context.mounted){
                      if(code == null){
                        AppToast.showMessage(
                          context: context,
                          message: "${context.tr("parameter_manager.diy_image_have_no_share_code")}\n${context.tr("parameter_manager.diy_image_have_no_share_code_tip")}",
                          state: false
                        );
                      }else{
                        _showParamItemEditPanel(context, code, NativeParamItemCover(
                          path: widget.imageItem.path.path,
                          isCache: false,
                        ));
                      }
                    }
                  },
                );
              },
            );
          },
          child: AppIcon("parameter_manager", color: AppColorScheme.of(context).highlight.onColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return RFutureBuilder(
      future: Future((){
        if(widget.imageItem.cover == null){
          return MediaThumbnail.fromCache(
            id: "${widget.imageItem.name}${widget.imageItem.time}",
            imagePath: Path(widget.imageItem.thumbnail ?? widget.imageItem.path.path),
            targetWidth: 720,
            isVideo: widget.imageItem.isVideo,
          );
        }else{
          return MediaThumbnail.fromCache(
            id: "${widget.imageItem.cover}${widget.imageItem.time}",
            imagePath: Path(widget.imageItem.thumbnail ?? widget.imageItem.cover!),
            targetWidth: 720,
            isVideo: false,
          );
        }
      }),
      builder: (context, image){
        final Widget exhibit = NotifierBuilder(
          listenable: widget.game.album.whenSelectedImagesChange,
          builder: (BuildContext context, Widget? child){
            final bool isSelected = widget.game.album.selectedImages.contains(widget.imageItem);

            return Stack(
              children: [
                Positioned.fill(
                  child: RawImage(image: image, fit: BoxFit.cover),
                ),
                if(isSelected)
                  Positioned.fill(child: ColoredBox(color: Color(0x66000000))),

                if(isSelected)
                  Positioned(
                    left: smallPadding,
                    top: smallPadding,
                    width: smallButtonContentSize + 2 * smallBorder,
                    height: smallButtonContentSize + 2 * smallBorder,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                          width: smallBorder,
                        ),
                        color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                      ),
                      child: Image.asset(
                        "assets/icon/tick.webp",
                        color: AppTheme.of(context)!.colorScheme.secondary.color,
                      ),
                    ),
                  ),
              ],
            );
          },
        );

        final Widget groundLayout = Listener(
          onPointerDown: (e){
            if(e.kind == PointerDeviceKind.mouse && e.buttons == kPrimaryMouseButton){
              widget.game.album.invertImage(widget.imageItem);
            }
            if(e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton){
              showAppDialog(
                context: context,
                builder: (BuildContext context){
                  return RFutureBuilder(
                    future: widget.game.album.images,
                    builder: (BuildContext context, Set<ImageItem> images){
                      if(widget.imageItem.isVideo){
                        return VideoViewerDialog(video: widget.imageItem);
                      }else{
                        return ImageViewerDialog(
                          game: widget.game,
                          images: widget.game.album.sortImages(images).toList(growable: false),
                          initImage: widget.imageItem,
                        );
                      }
                    },
                  );
                },
              );
            }
          },
          child: exhibit,
        );

        bool isHover = false;

        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setButtonState){
            return MouseRegion(
              onEnter: (_) {
                final bool isPrimaryMouseDown = AlbumValuePool.of(context).isPrimaryMouseDown.value;
                final bool isDragScrollbar = AlbumValuePool.of(context).isDragScrollbar.value;
                final bool isPressTag = AlbumValuePool.of(context).isPressTag.value;
                // 长按多选
                if(isPrimaryMouseDown && !isDragScrollbar && !isPressTag){
                  widget.game.album.invertImage(widget.imageItem);
                }

                setButtonState((){
                  isHover = true;
                });
              },
              onHover: (_){
                setButtonState((){
                  isHover = true;
                });
              },
              onExit: (_){
                setButtonState((){
                  isHover = false;
                });
              },
              child: Stack(
                children: [
                  groundLayout,

                  if(widget.game.selectedAlbum != AlbumType.Video && widget.game.selectedAlbum != AlbumType.ExternalVideo)
                    _generateTagButton(context, isHover),

                  _generateParamSaverButton(context, isHover),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// ---------- tag ---------- ///

class TagMenu extends StatelessWidget {
  final Game game;
  final String value;
  final Widget Function(
    BuildContext context,
    Color? tagColor,
    Widget? child,
    void Function() trigger,
  )
  builder;

  const TagMenu({
    required this.game,
    required this.value,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: game.tag,
      builder: (BuildContext context, Widget? child) {
        return MenuAnchor(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(
              AppTheme.of(context)!.colorScheme.background.color,
            ),
          ),
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
                return builder(
                  context,
                  game.tag.findTagColorBy(value),
                  child,
                  () {
                    if (controller.isOpen) {
                      game.tag.remove([value]);
                      controller.close();
                    } else {
                      if (game.tag.findTagBy(value) != false) {
                        game.tag.remove([value]);
                      } else {
                        game.tag.add(null, [value]);
                        controller.open();
                      }
                    }
                  },
                );
              },
          menuChildren:
              game.tag.tagList.map((String? tag) {
                return MenuItemButton(
                  onPressed: () {
                    game.tag.add(tag, [value]);
                  },
                  child: Row(
                    spacing: smallPadding,
                    children: [
                      Image.asset(
                        "assets/icon/tag_fill.webp",
                        height: smallButtonContentSize,
                        color: game.tag.getColor(tag),
                      ),
                      AppText(tag ?? context.tr("defaultTag")),
                    ],
                  ),
                );
              }).toList()..add(
                MenuItemButton(
                  onPressed: () async {
                    final (String tag, Color color)? res =
                        await showDialog<(String tag, Color color)>(
                          context: context,
                          builder: (BuildContext context) {
                            return EditTagDialog(tagList: game.tag.tagList);
                          },
                        );

                    if (res != null) {
                      game.tag.add(res.$1, [value]);
                      game.tag.setColor(res.$1, res.$2);
                    }
                  },
                  child: AppText.tr("addCustomTag"),
                ),
              ),
        );
      },
    );
  }
}

class EditTagDialog extends StatelessWidget {
  static const List<Color> _swatches = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  final bool check;
  final Set<String?> tagList;
  late final ValueNotifier<String> tag;
  late final ValueNotifier<Color> color;

  EditTagDialog({
    super.key,
    this.check = true,
    required this.tagList,
    (String tag, Color color)? initValue,
  }) {
    tag = ValueNotifier<String>(initValue?.$1 ?? "");
    color = ValueNotifier<Color>(initValue?.$2 ?? Colors.orange);
  }

  final ValueNotifier<String?> errorInfo = ValueNotifier<String?>(null);

  void verify() {
    if (!check) return;

    if (tagList.contains(tag.value)) {
      errorInfo.value = "tagAlreadyExists";
    } else {
      errorInfo.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
        child: Column(
          spacing: smallPadding,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///
            Row(
              spacing: smallPadding,
              children: [
                ValueListenableBuilder(
                  valueListenable: color,
                  builder:
                      (
                        BuildContext context,
                        Color selectedColor,
                        Widget? child,
                      ) {
                        return Image.asset(
                          "assets/icon/tag_fill.webp",
                          height: 30,
                          color: selectedColor,
                        );
                      },
                ),
                Expanded(
                  child: AppTextFiled(
                    controller: TextEditingController(text: tag.value),
                    labelText: "tagName",
                    onChanged: (String input) {
                      tag.value = input;
                      verify();
                    },
                  ),
                ),
              ],
            ),

            ValueListenableBuilder(
              valueListenable: errorInfo,
              builder: (BuildContext context, String? info, Widget? child) {
                return info == null
                    ? block0
                    : Text(
                        context.tr(info),
                        style: TextStyle(
                          color: AppTheme.of(
                            context,
                          )!.colorScheme.error.pressedColor,
                        ),
                      );
              },
            ),

            block20H,

            /// color selector
            Container(
              constraints: const BoxConstraints(maxHeight: smallCardMaxHeight),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: smallButtonContentSize,
                  mainAxisSpacing: listSpacing,
                  crossAxisSpacing: listSpacing,
                  childAspectRatio: 1 / 1,
                ),
                itemCount: _swatches.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      color.value = _swatches[index];
                    },
                    child: ClipOval(child: Container(color: _swatches[index])),
                  );
                },
              ),
            ),

            /// cancel
            AppButton.smallText(
              height: mediumButtonSize,
              colorRole: ColorRole.background,
              isTransparent: false,
              onClick: () {
                Navigator.of(context).pop();
              },
              child: AppText.tr("cancel"),
            ),

            /// save
            AppButton.smallText(
              height: mediumButtonSize,
              colorRole: ColorRole.background,
              isTransparent: false,
              onClick: () {
                verify();

                if (errorInfo.value == null) {
                  Navigator.of(context).pop((tag.value, color.value));
                }
              },
              child: AppText.tr("save"),
            ),
          ],
        ),
      ),
    );
  }
}

/// TODO 拖动排序
class TagListDialog extends StatelessWidget {
  final Game game;

  const TagListDialog(this.game, {super.key});

  Future<void> _editTag(BuildContext context, String tag) async {
    if (game.tag.getColor(tag) == null) return;

    final (String tag, Color color)? res =
        await showDialog<(String tag, Color color)>(
          context: context,
          builder: (BuildContext context) {
            return EditTagDialog(
              check: false,
              tagList: game.tag.tagList,
              initValue: (tag, game.tag.getColor(tag)!),
            );
          },
        );

    if (res != null) {
      game.tag.rename(tag, res.$1);
      game.tag.setColor(res.$1, res.$2);
    }
  }

  Future<void> _deleteTag(BuildContext context, String tag) async {
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
            constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
            child: Column(
              spacing: smallPadding,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(context.tr("deleteXTag", args: [tag])),

                /// cancel
                AppButton.smallText(
                  padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                  height: mediumButtonSize,
                  colorRole: ColorRole.background,
                  isTransparent: false,
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                  child: AppText.tr("cancel"),
                ),

                /// delete
                AppButton.smallText(
                  padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                  height: mediumButtonSize,
                  colorRole: ColorRole.background,
                  isTransparent: false,
                  onClick: () {
                    game.tag.delete(tag);
                    Navigator.of(context).pop();
                  },
                  child: AppText.tr("delete"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addTag(BuildContext context) async {
    final (String tag, Color color)? res =
        await showDialog<(String tag, Color color)>(
          context: context,
          builder: (BuildContext context) {
            return EditTagDialog(tagList: game.tag.tagList);
          },
        );

    if (res != null) {
      game.tag.add(res.$1, []);
      game.tag.setColor(res.$1, res.$2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget tagButtons = ListenableBuilder(
      listenable: game.tag,
      builder: (BuildContext context, Widget? child) {
        return Column(
          spacing: smallPadding,
          mainAxisSize: MainAxisSize.min,
          children: game.tag.tagList
              .map((String? tag) {
                return AppButton.smallText(
                  padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                  height: mediumButtonSize,
                  colorRole: ColorRole.background,
                  onClick: () {
                    final List<String>? values = game.tag.getValues(tag);

                    if (values == null) return;

                    Navigator.of(context).pop();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              smallBorderRadius,
                            ),
                          ),
                          backgroundColor: AppTheme.of(
                            context,
                          )!.colorScheme.background.color,
                          child: Padding(
                            padding: const EdgeInsets.all(smallPadding),
                            child: Column(
                              spacing: listSpacing,
                              children: [
                                Row(
                                  children: [
                                    block10W,

                                    AppText(tag ?? context.tr("defaultTag")),

                                    Expanded(child: block0),

                                    AppButton.smallText(
                                      onClick: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: AppIcon("cross", height: 20),
                                    ),
                                  ],
                                ),

                                Expanded(
                                  child: RFutureBuilder(
                                    future: game.album.images,
                                    builder: (BuildContext context, Set<ImageItem> images) {
                                      final List<ImageItem> processImages =
                                          images.toList()..removeWhere(
                                            (ImageItem item) =>
                                                !values.contains(item.name),
                                          );

                                      return AlbumPreviewer(
                                        images: processImages,
                                        onDelete: (ImageItem item) {
                                          game.tag.remove([item.name]);
                                        },
                                        builder: (BuildContext context, ImageItem item) {
                                          return RFutureBuilder(
                                            future: MediaThumbnail.fromCache(
                                              id: item.name,
                                              imagePath: item.path,
                                              targetWidth: 720,
                                              isVideo: item.isVideo,
                                            ),
                                            builder: (context, image) {
                                              return Listener(
                                                onPointerDown: (e) {
                                                  if (e.kind ==
                                                          PointerDeviceKind
                                                              .mouse &&
                                                      e.buttons ==
                                                          kSecondaryMouseButton) {
                                                    showDialog(
                                                      context: context,
                                                      builder:
                                                          (
                                                            BuildContext
                                                            context,
                                                          ) {
                                                            return ImageViewerDialog(
                                                              images:
                                                                  processImages,
                                                              initImage: item,
                                                            );
                                                          },
                                                    );
                                                  }
                                                },
                                                child: KeepAliveWrapper(
                                                  child: RawImage(
                                                    image: image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      /// color
                      Image.asset(
                        "assets/icon/tag_fill.webp",
                        height: 20,
                        color: game.tag.getColor(tag),
                      ),

                      block5W,

                      /// tag name
                      Expanded(child: AppText(tag ?? context.tr("defaultTag"))),

                      /// edit tag
                      if (tag != null)
                        Tooltip(
                          message: context.tr("edit"),
                          child: AppButton.smallIcon(
                            colorRole: ColorRole.primary,
                            onClick: () {
                              _editTag(context, tag);
                            },
                            child: AppIcon("edit", height: 20),
                          ),
                        ),

                      /// delete tag
                      if (tag != null)
                        Tooltip(
                          message: context.tr("delete"),
                          child: AppButton.smallIcon(
                            colorRole: ColorRole.primary,
                            onClick: () {
                              _deleteTag(context, tag);
                            },
                            child: AppIcon("delete", height: 20),
                          ),
                        ),
                    ],
                  ),
                );
              })
              .toList(growable: false),
        );
      },
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
        child: Column(
          spacing: smallPadding,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// top bar
            Row(
              spacing: bigListSpacing,
              children: [
                block5W,

                Expanded(child: AppText.tr("manageTags")),

                AppButton.smallIcon(
                  colorRole: ColorRole.background,
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                  child: AppIcon("cross", height: 20),
                ),
              ],
            ),

            tagButtons,

            /// add tag
            AppButton.smallText(
              padding: const EdgeInsets.symmetric(horizontal: smallPadding),
              width: null,
              height: mediumButtonSize,
              colorRole: ColorRole.background,
              isTransparent: false,
              onClick: () {
                _addTag(context);
              },
              child: AppText.tr("addCustomTag"),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------- image viewer ---------- ///

class ImageViewerDialog extends StatelessWidget {
  final Game? game;
  final List<ImageItem> images;
  final ImageItem initImage;
  final ImageViewerController controller = ImageViewerController();

  ImageViewerDialog({
    super.key,
    this.game,
    required this.images,
    required this.initImage,
  });

  void _invertImage() {
    if (controller.isAttach) {
      game?.album.invertImage(images[controller.index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget toolButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children:
          [
                AppButton.smallIcon(
                  toolTip: "reset",
                  onClick: controller.reset,
                  child: AppIcon("refresh", height: 20),
                ),

                AppDivider(direction: Axis.vertical),

                AppButton.smallIcon(
                  toolTip: "pa_horizontal_flip",
                  onClick: controller.horizontalFlip,
                  child: AppIcon("horizontal_flip", height: 18),
                ),

                AppButton.smallIcon(
                  toolTip: "pa_vertical_flip",
                  onClick: controller.verticalFlip,
                  child: AppIcon("vertical_flip", height: 18),
                ),

                AppButton.smallIcon(
                  toolTip: "pa_rotate_left_90",
                  onClick: controller.rotateLeft90,
                  child: AppIcon("rotate_left_90", height: 20),
                ),

                AppButton.smallIcon(
                  toolTip: "pa_rotate_right_90",
                  onClick: controller.rotateRight90,
                  child: AppIcon("rotate_right_90", height: 20),
                ),

                AppDivider(direction: Axis.vertical),

                AppButton.smallIcon(
                  toolTip: "edit",
                  onClick: () {
                    showAppDialog(
                      context: context,
                      isBarrier: true,
                      builder: (context) {
                        return AppDialog(
                          padding: const EdgeInsets.all(0),
                          useIntrinsicHeight: false,
                          child: ImageEditor(
                            imagePath: images[controller.index].path.path,
                          ),
                        );
                      },
                    );
                  },
                  child: AppIcon("edit", height: 20),
                ),

                ValueListenableBuilder(
                  valueListenable: AppState.isShowImageCustomData,
                  builder:
                      (
                        BuildContext context,
                        bool isShowImageCustomData,
                        Widget? child,
                      ) {
                        return Tooltip(
                          message: context.tr("pa_show_image_data"),
                          child: AppUncontrolledSwitch(
                            initValue: isShowImageCustomData,
                            width: smallButtonSize,
                            height: smallButtonSize,
                            onChanged: (bool value) {
                              AppState.isShowImageCustomData.value =
                                  !AppState.isShowImageCustomData.value;
                            },
                            child: AppIcon("image_custom_data", height: 22),
                          ),
                        );
                      },
                ),

                AppDivider(direction: Axis.vertical),

                AppButton.smallIcon(
                  toolTip:
                      context.tr("pa_to_previous_image") +
                      getKeyboardCharacter([LogicalKeyboardKey.arrowLeft]),
                  isTranslate: false,
                  onClick: controller.toPreviousImage,
                  child: AppIcon("back", height: 20),
                ),

                AppButton.smallIcon(
                  toolTip:
                      context.tr("pa_to_next_image") +
                      getKeyboardCharacter([LogicalKeyboardKey.arrowRight]),
                  isTranslate: false,
                  onClick: controller.toNextImage,
                  child: AppIcon("forward", height: 20),
                ),

                if (game != null) AppDivider(direction: Axis.vertical),

                if (game != null)
                  ListenableBuilder(
                    listenable: controller,
                    builder: (BuildContext context, Widget? child) {
                      return controller.isAttach
                          ? TagMenu(
                              game: game!,
                              value: images[controller.index].name,
                              builder:
                                  (
                                    BuildContext context,
                                    Color? color,
                                    Widget? child,
                                    void Function() trigger,
                                  ) {
                                    final String icon = color == null
                                        ? "assets/icon/tag.webp"
                                        : "assets/icon/tag_fill.webp";

                                    return Tooltip(
                                      message: context.tr("tag"),
                                      child: AppButton.smallIcon(
                                        onClick: trigger,
                                        child: Image.asset(
                                          icon,
                                          height: 18,
                                          color:
                                              color ??
                                              AppTheme.of(
                                                context,
                                              )!.colorScheme.background.onColor,
                                        ),
                                      ),
                                    );
                                  },
                            )
                          : AppButton.smallIcon();
                    },
                  ),

                if (game != null)
                  ListenableBuilder(
                    listenable: controller,
                    builder: (BuildContext context, Widget? child) {
                      return controller.isAttach
                          ? NotifierBuilder(
                              listenable: game!.album.whenSelectedImagesChange,
                              builder: (BuildContext context, Widget? child) {
                                final ImageItem item = images[controller.index];
                                final bool isSelected = game!
                                    .album
                                    .selectedImages
                                    .contains(item);
                                final String text = isSelected
                                    ? context.tr("deselect")
                                    : context.tr("select");
                                final String icon = isSelected
                                    ? "assets/icon/select_all.webp"
                                    : "assets/icon/notSelect.webp";
                                return Tooltip(
                                  message:
                                      text +
                                      getKeyboardCharacter([
                                        LogicalKeyboardKey.space,
                                      ]),
                                  child: AppButton.smallIcon(
                                    onClick: _invertImage,
                                    child: Image.asset(
                                      icon,
                                      height: 22,
                                      color: AppTheme.of(
                                        context,
                                      )!.colorScheme.background.onColor,
                                    ),
                                  ),
                                );
                              },
                            )
                          : AppButton.smallIcon();
                    },
                  ),
              ]
              .map(
                (Widget widget) => widget is AppDivider
                    ? widget
                    : AppFloatingIndicatorButtonTarget(child: widget),
              )
              .toList(),
    );

    return Focus(
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
                event.logicalKey == LogicalKeyboardKey.keyA)) {
          controller.toPreviousImage();
          return KeyEventResult.handled;
        }
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.arrowRight ||
                event.logicalKey == LogicalKeyboardKey.keyD)) {
          controller.toNextImage();
          return KeyEventResult.handled;
        }
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.space) {
          _invertImage();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
        ),
        backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
        child: AppFloatingIndicatorButtonGroup(
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: AppState.isShowImageCustomData,
                  builder:
                      (
                        BuildContext context,
                        bool isShowImageCustomData,
                        Widget? child,
                      ) {
                        if (!isShowImageCustomData) return child ?? block0;

                        return MultiSplitViewTheme(
                          data: MultiSplitViewThemeData(
                            dividerPainter: DividerPainters.grooved1(
                              color: AppColorScheme.of(
                                context,
                              ).byRole(ColorRole.of(context)).pressedColor,
                              highlightedColor: AppColorScheme.of(
                                context,
                              ).byRole(ColorRole.of(context)).onPressedColor,
                            ),
                          ),
                          child: MultiSplitView(
                            initialAreas: [
                              Area(data: "image"),
                              AppState.imageCustomDataWidgetSize.value == null
                                  ? Area(data: "data_panel", flex: 1)
                                  : Area(
                                      data: "data_panel",
                                      size: AppState
                                          .imageCustomDataWidgetSize
                                          .value,
                                    ),
                            ],
                            builder: (BuildContext context, Area area) {
                              if (area.data == "image") {
                                return child ?? block0;
                              } else {
                                return ListenableBuilder(
                                  listenable: controller,
                                  builder:
                                      (BuildContext context, Widget? child) {
                                        return LayoutBuilder(
                                          builder:
                                              (
                                                BuildContext context,
                                                BoxConstraints constraint,
                                              ) {
                                                AppState
                                                    .imageCustomDataWidgetSize
                                                    .value = constraint
                                                    .maxWidth;

                                                late final TreeNode? node;
                                                if (controller.isAttach) {
                                                  node =
                                                      images[controller.index]
                                                          .getParamNodeSync(
                                                            game
                                                                ?.selectedUid
                                                                ?.value,
                                                            game?.selectedAlbum,
                                                          );
                                                } else {
                                                  node = initImage
                                                      .getParamNodeSync(
                                                        game
                                                            ?.selectedUid
                                                            ?.value,
                                                        game?.selectedAlbum,
                                                      );
                                                }

                                                return TreeViewPage(
                                                  root: [?node],
                                                  useFloatingIndicatorGroup:
                                                      false,
                                                );
                                              },
                                        );
                                      },
                                );
                              }
                            },
                          ),
                        );
                      },
                  child: Listener(
                    onPointerDown: (e) {
                      /// TODO 拖拽图片时不要切换状态
                      // if(e.kind == PointerDeviceKind.mouse && e.buttons == kPrimaryMouseButton){
                      //   _invertImage();
                      // }
                      if (e.kind == PointerDeviceKind.mouse &&
                          e.buttons == kSecondaryMouseButton) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: ImageViewer(
                      controller: controller,
                      imageCount: images.length,
                      initIndex: images.indexOf(initImage),
                      imageBuilder: (BuildContext context, int index) {
                        return Image.file(
                          images[index].path.file,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: topBarHeight,
                child: Align(alignment: Alignment.center, child: toolButtons),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoViewerDialog extends StatefulWidget {
  final Game? game;
  final ImageItem video;

  const VideoViewerDialog({super.key, this.game, required this.video});

  @override
  State<VideoViewerDialog> createState() => _VideoViewerDialogState();
}

class _VideoViewerDialogState extends State<VideoViewerDialog> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.video.path.path));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) async {
        if (e.kind == PointerDeviceKind.mouse &&
            e.buttons == kSecondaryMouseButton) {
          Navigator.of(context).pop();
        }
      },
      child: Material(
        borderRadius: BorderRadiusGeometry.circular(smallBorderRadius),
        clipBehavior: Clip.antiAlias,
        color: AppColorScheme.of(context).background.color,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: smallPadding),
              height: topBarHeight,
              child: Row(
                children: [
                  AppButton.smallIcon(
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                    child: AppIcon("cross"),
                  ),

                  Expanded(child: block0),

                  AppButton.smallText(
                    onClick: () async {
                      if (Platform.isWindows) {
                        if (!await FFmpegManager.checkAndDownload(context)) {
                          return;
                        }
                        if (!await ExifToolManager.ensureInstalled()) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: AppText.tr(
                                  "ExifTool 缺失！请确保运行过打包脚本。/ ExifTool is missing from bundle.",
                                ),
                              ),
                            );
                          }
                          return;
                        }
                      }
                      if (!context.mounted) return;
                      showAppDialog(
                        isBarrier: true,
                        context: context,
                        builder: (BuildContext context) {
                          return VideoToGifPanel(
                            videoPath: widget.video.path.path,
                          );
                        },
                      );
                    },
                    child: Row(
                      spacing: listSpacing,
                      children: [AppIcon("forward"), AppText.tr("exportToGif")],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Video(
                controller: controller,
                fill: AppColorScheme.of(context).background.color,
                filterQuality: FilterQuality.high,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------- tool bar button ---------- ///

class FiltrationButton extends StatelessWidget {
  final Game game;

  const FiltrationButton({super.key, required this.game});

  Widget _buttonBuilder(Filtration filtration) {
    return ListenableBuilder(
      listenable: game,
      builder: (BuildContext context, Widget? child) {
        return ListenableBuilder(
          listenable: game.album,
          builder: (BuildContext context, Widget? child) {
            final bool isFilter = game.album.isFilter(filtration);

            return AppFloatingIndicatorButtonTarget(
              child: AppButton.smallText(
                padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                height: mediumButtonSize,
                onClick: () async {
                  if (isFilter) {
                    game.album.unfilter(filtration);
                  } else {
                    /// Only single-choice option
                    if (filtration == Filtration.onlyDailyTask ||
                        filtration == Filtration.hasCompletedTask ||
                        filtration == Filtration.hasUnfinishedTask ||
                        filtration == Filtration.onlyPuzzleTask ||
                        filtration == Filtration.onlyRiskTask ||
                        filtration == Filtration.onlyPhotoWall) {
                      final ValueNotifier<double?> progress =
                      ValueNotifier<double?>(null);
                      bool cancel = false;

                      if (context.mounted) {
                        showProgressBar(
                          context: context,
                          valueListenable: progress,
                          builder: (BuildContext context) {
                            return AppButton.smallText(
                              isTransparent: false,
                              onClick: () {
                                cancel = true;
                                Navigator.of(context).pop();
                              },
                              child: AppText.tr("cancel"),
                            );
                          },
                        );
                      }

                      final Set<ImageItem> images = await game.album.images;

                      if (game.selectedUid?.value != null && images.isNotEmpty) {
                        int count = 0;
                        final int total = images.length;

                        await InfinityNikkiParamCodec.decodeFilesUncheckedStream(
                          MediaParamType.nikkiPhoto,
                          images.map((ImageItem item) => item.path.path).toList(),
                          uid: game.selectedUid?.value,
                          callback: (String path, MediaCustomData? data) {
                            progress.value = (count++ / total).clamp(0, 1);
                          },
                        );

                        progress.value = 1;
                      }

                      if (game.album.isFilter(Filtration.onlyDailyTask)) {
                        game.album.unfilter(Filtration.onlyDailyTask);
                      }
                      if (game.album.isFilter(Filtration.hasCompletedTask)) {
                        game.album.unfilter(Filtration.hasCompletedTask);
                      }
                      if (game.album.isFilter(Filtration.hasUnfinishedTask)) {
                        game.album.unfilter(Filtration.hasUnfinishedTask);
                      }
                      if (game.album.isFilter(Filtration.onlyPuzzleTask)) {
                        game.album.unfilter(Filtration.onlyPuzzleTask);
                      }
                      if (game.album.isFilter(Filtration.onlyRiskTask)) {
                        game.album.unfilter(Filtration.onlyRiskTask);
                      }
                      if (game.album.isFilter(Filtration.onlyPhotoWall)) {
                        game.album.unfilter(Filtration.onlyPhotoWall);
                      }
                      game.album.filter(filtration);
                    } else {
                      game.album.filter(filtration);
                    }
                  }
                },
                child: Row(
                  spacing: listSpacing,
                  children: [
                    AppIcon("tick", height: 16, opacity: isFilter ? 1 : 0),
                    AppText.tr(filtration.name),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: game,
      builder: (BuildContext context, Widget? child) {
        return AppDropdown(
          builder: (BuildContext context, MenuController controller, Widget? child){
            return AppButton.smallIcon(
              toolTip: "filter",
              colorRole: ColorRole.secondary,
              onClick: (){
                controller.isOpen ? controller.close() : controller.open();
              },
              child: AppIcon("filtration", height: 20),
            );
          },
          childrenBuilder: (BuildContext context, MenuController controller){
            return [
              AppFloatingIndicatorButtonGroup(
                child: Column(
                  children: [
                    _buttonBuilder(Filtration.inGame),
                    _buttonBuilder(Filtration.outOfGame),
                    if (game.selectedAlbum == AlbumType.NikkiPhotos_HighQuality)
                      _buttonBuilder(Filtration.onlyDailyTask),
                    if (game.selectedAlbum == AlbumType.NikkiPhotos_HighQuality)
                      _buttonBuilder(Filtration.hasCompletedTask),
                    if (game.selectedAlbum == AlbumType.NikkiPhotos_HighQuality)
                      _buttonBuilder(Filtration.hasUnfinishedTask),
                    if (game.selectedAlbum == AlbumType.NikkiPhotos_HighQuality)
                      _buttonBuilder(Filtration.onlyPuzzleTask),
                    if (game.selectedAlbum == AlbumType.NikkiPhotos_HighQuality)
                      _buttonBuilder(Filtration.onlyRiskTask),
                    if (game.selectedAlbum == AlbumType.NikkiPhotos_HighQuality)
                      _buttonBuilder(Filtration.onlyPhotoWall),
                  ],
                ),
              ),
            ];
          },
        );
      },
    );
  }
}

class SelectionViewerDialog extends StatelessWidget {
  final Game game;
  const SelectionViewerDialog({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final List<ImageItem> images = game.album.selectedImages.toList(
      growable: false,
    );

    final Widget topBar = Container(
      margin: const EdgeInsets.symmetric(horizontal: smallPadding),
      height: topBarHeight,
      child: Row(
        children: [
          Expanded(
            child: NotifierBuilder(
              listenable: game.album.whenSelectedImagesChange,
              builder: (BuildContext context, Widget? child) {
                return AppText(
                  context.plural(
                    "xImageSelected",
                    game.album.selectedImages.length,
                  ),
                );
              },
            ),
          ),
          AppButton.smallIcon(
            onClick: () {
              Navigator.of(context).pop();
            },
            child: AppIcon("cross", height: 20),
          ),
        ],
      ),
    );

    final Widget viewer = AlbumPreviewer(
      images: images,
      onDelete: (ImageItem item) {
        game.album.deselectImage(item);
        if (game.album.selectedImages.isEmpty) Navigator.of(context).pop();
      },
      builder: (BuildContext context, ImageItem item) {
        return RFutureBuilder(
          future: MediaThumbnail.fromCache(
            id: "${item.name}${item.time}",
            imagePath: item.path,
            targetWidth: 720,
            isVideo: item.isVideo,
          ),
          builder: (context, image) {
            return Listener(
              onPointerDown: (e) {
                if (e.kind == PointerDeviceKind.mouse &&
                    e.buttons == kSecondaryMouseButton) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImageViewerDialog(images: images, initImage: item);
                    },
                  );
                }
              },
              child: KeepAliveWrapper(
                child: RawImage(image: image, fit: BoxFit.cover),
              ),
            );
          },
        );
      },
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Column(
        children: [
          topBar,
          Expanded(child: viewer),
        ],
      ),
    );
  }
}

class DeleteImagesDialog extends StatelessWidget {
  final Game game;
  final ManualValueNotifier<Map<AlbumType, bool>> chainDeletion;

  DeleteImagesDialog({super.key, required this.game})
    : chainDeletion = ManualValueNotifier(
        Map.from(albumsInfoMap[game.selectedAlbum]?.chainDeletion ?? {}),
      );

  void _cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _delete(BuildContext context) {
    Navigator.of(context).pop();

    final ValueNotifier<double> progress = ValueNotifier(0);
    int errorNum = 0;
    String? errorMessage;

    showProgressBar(
      context: context,
      valueListenable: progress,
      autoClose: false,
      completedBuilder: (BuildContext context, void Function() close) {
        if (errorNum == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) => close());
          return block0;
        }

        return Column(
          spacing: listSpacing,
          children: [
            AppText(context.plural("XImageFailedToBeProcessed", errorNum)),
            const FailToCopyFileSystemEntry(),
            AppButton.smallText(onClick: close, child: AppText.tr("ok")),
          ],
        );
      },
    );

    game.recycleSelectedImages(
      chainDeletion.value,
      onProgress: (double currentProgress) {
        progress.value = currentProgress;
      },
      onError: (Set items) {
        errorNum = items.length;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> options = <Widget>[];

    for (AlbumType type in chainDeletion.value.keys) {
      options.add(
        ManualValueNotifierBuilder(
          valueListenable: chainDeletion,
          builder:
              (
                BuildContext context,
                Map<AlbumType, bool> chain,
                Widget? child,
              ) {
                late final Widget tickBox;

                if (chain[type]!) {
                  tickBox = Container(
                    decoration: BoxDecoration(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.success.pressedColor,
                      border: Border.all(
                        color: AppTheme.of(
                          context,
                        )!.colorScheme.secondary.onColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(
                        0.5 * smallButtonContentSize,
                      ),
                    ),
                    child: Image.asset(
                      "assets/icon/tick.webp",
                      color: AppTheme.of(context)!.colorScheme.background.color,
                    ),
                  );
                } else {
                  tickBox = Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.of(
                          context,
                        )!.colorScheme.secondary.onColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(
                        0.5 * smallButtonContentSize,
                      ),
                    ),
                  );
                }

                return AppButton.smallText(
                  padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                  height: mediumButtonSize,
                  colorRole: ColorRole.background,
                  onClick: () {
                    chain[type] = !chain[type]!;
                    chainDeletion.notify();
                  },
                  child: Row(
                    spacing: listSpacing,
                    children: [
                      SizedBox(
                        width: smallButtonContentSize,
                        height: smallButtonContentSize,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.all(
                            Radius.circular(0.5 * smallButtonContentSize),
                          ),
                          child: tickBox,
                        ),
                      ),
                      AppText(
                        "${context.tr(albumsInfoMap[type]!.name)} ( ${albumsInfoMap[type]!.type} )",
                      ),
                    ],
                  ),
                );
              },
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        constraints: const BoxConstraints(maxWidth: smallDialogMaxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              context.plural("deleteXImage", game.album.selectedImages.length),
              fontSize: 20,
            ),

            options.isEmpty
                ? block20H
                : Container(
                    padding: const EdgeInsets.all(smallPadding),
                    alignment: Alignment.centerLeft,
                    child: AppText.tr("deleteSameImage"),
                  ),

            ...options,

            Row(
              children: [
                Expanded(
                  child: AppButton.smallText(
                    colorRole: ColorRole.background,
                    isTransparent: false,
                    onClick: () {
                      _delete(context);
                    },
                    child: AppText.tr("moveToRecycleBin"),
                  ),
                ),
                Expanded(
                  child: AppButton.smallText(
                    colorRole: ColorRole.highlight,
                    isTransparent: false,
                    onClick: () {
                      _cancel(context);
                    },
                    child: AppText.tr("cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExportImagesButton extends StatelessWidget {
  final bool usable;
  final List<ImageItem> images;

  const ExportImagesButton({
    super.key,
    required this.usable,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child){
        return AppButton.smallIcon(
          toolTip: usable ? context.tr("export") : "",
          isTranslate: false,
          colorRole: ColorRole.secondary,
          onClick: (){
            controller.isOpen ? controller.close() : controller.open();
          },
          usable: usable,
          child: AppIcon("export", height: 18),
        );
      },
      menuChildren: [
        /// copy images to clipboard
        MenuItemButton(
          onPressed: () {
            AlbumHandler.of(context).copy(context, images);
          },
          trailingIcon: AppText(
            getKeyboardCharacter([
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyC,
            ]),
            isTranslate: false,
          ),
          child: AppText.tr("exportToClipboard"),
        ),

        /// export images to native device
        MenuItemButton(
          onPressed: () {
            AlbumHandler.of(context).exportToLocal(context, images);
          },
          trailingIcon: AppText(
            getKeyboardCharacter([
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyS,
            ]),
            isTranslate: false,
          ),
          child: AppText.tr("exportToLocal"),
        ),

        /// export images to network device
        MenuItemButton(
          onPressed: () {
            AlbumHandler.of(context).exportToNetwork(context);
          },
          trailingIcon: AppText(
            getKeyboardCharacter([
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyW,
            ]),
            isTranslate: false,
          ),
          child: AppText.tr("exportToNetwork"),
        ),

        /// export to macOS Photo Library (only for Video album on macOS)
        if (Platform.isMacOS)
          MenuItemButton(
            onPressed: () {
              AlbumHandler.of(context).exportToPhotoLibrary(context, images);
            },
            child: AppText.tr("exportToPhotoLibrary"),
          ),

        /// encode and export nikkias file to native device
        MenuItemButton(
          onPressed: () {
            AlbumHandler.of(context).exportNikkiasToLocal(context, images);
          },
          child: AppText.tr("exportNikkiasToLocal"),
        ),

        ValueListenableBuilder(
          valueListenable: AppState.exportingImageDirs,
          builder: (BuildContext _, Map dirs, Widget? child){
            return Column(
              children: dirs.keys.whereType<String>().map((String key){
                return MenuItemButton(
                  onPressed: (){
                    AlbumHandler.of(context).exportToLocal(context, images, savePath: dirs[key]);
                  },
                  child: AppText(context.tr("export_toX", args: [key])),
                );
              }).toList(),
            );
          },
        ),

        /// export option
        AppButton.smallText(
          useConfiguration: false,
          borderRadius: 0,
          height: mediumButtonSize,
          onClick: () {
            AlbumHandler.of(context).openExportSetting(context);
          },
          child: Row(
            spacing: listSpacing,
            children: [
              AppIcon("setting", height: 20),
              AppText.tr("config_of_export"),
            ],
          ),
        ),
      ],
    );
  }
}

class ImportImagesDialog extends StatelessWidget {
  final Game game;

  ImportImagesDialog(this.game, {super.key});

  final ValueNotifier<bool> isDrag = ValueNotifier<bool>(false);
  final ManualValueNotifier<List<ImageItem>> images =
      ManualValueNotifier<List<ImageItem>>([]);

  Future<void> _pickFiles(BuildContext context) async {
    final FilePickerResult? location = await FilePicker.platform.pickFiles(
      dialogTitle: context.tr("importImageTo"),
      lockParentWindow: true,
      type: FileType.custom,
      allowedExtensions: imageExtension.toList(growable: false),
      allowMultiple: true,
    );

    if (location != null) {
      images.value.clear();
      for (String? pathStr in location.paths) {
        if (pathStr == null || !isImageExtension(Path(pathStr))) continue;

        images.value.add(
          ImageItem(
            source: ImageSource.other,
            path: Path(pathStr),
            time: DateTime.now(),
            isVideo: false,
          ),
        );
      }

      images.notify();

      _createAlbumPreviewer(context);
    }
  }

  void _dragDone(BuildContext context, DropDoneDetails details) {
    images.value = details.files
        .map((DropItem item) => Path(item.path))
        .where(isImageExtension)
        .map(
          (Path path) => ImageItem(
            source: ImageSource.other,
            path: path,
            time: DateTime.now(),
            isVideo: false,
          ),
        )
        .toList();
    images.notify();

    _createAlbumPreviewer(context);
  }

  Future<void> _paste(BuildContext context) async {
    images.value = (await readFilesFromClipboard())
        .where(isImageExtension)
        .map(
          (path) => ImageItem(
            source: ImageSource.other,
            path: path,
            time: DateTime.now(),
            isVideo: false,
          ),
        )
        .toList();
    images.notify();

    _createAlbumPreviewer(context);
  }

  void _cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _import(BuildContext context) {
    Navigator.of(context).pop();

    final ValueNotifier<double> progress = ValueNotifier(0);
    int errorNum = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showProgressBar(
        context: context,
        valueListenable: progress,
        autoClose: false,
        completedBuilder: (BuildContext context, void Function() close) {
          if (errorNum == 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) => close());
            return block0;
          }

          return Column(
            spacing: listSpacing,
            children: [
              AppText(context.plural("XImageFailedToBeProcessed", errorNum)),
              const FailToCopyFileSystemEntry(),
              AppButton.smallText(
                width: null,
                colorRole: ColorRole.background,
                onClick: close,
                child: AppText.tr("ok"),
              ),
            ],
          );
        },
      );
    });

    game.importImages(
      images.value,
      onProgress: (double currentProgress) {
        progress.value = currentProgress;
      },
      onError: (Set items) {
        errorNum = items.length;
      },
    );
  }

  void _createAlbumPreviewer(BuildContext context) {
    Navigator.of(context).pop();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final Widget buttons = Row(
            children: [
              Expanded(
                child: AppButton.smallText(
                  colorRole: ColorRole.background,
                  onClick: () {
                    _cancel(context);
                  },
                  child: AppText.tr("cancel"),
                ),
              ),
              Expanded(
                child: AppButton.smallText(
                  colorRole: ColorRole.highlight,
                  isTransparent: false,
                  onClick: () {
                    _import(context);
                  },
                  child: AppText.tr("import"),
                ),
              ),
            ],
          );

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(smallBorderRadius),
            ),
            backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
            child: Padding(
              padding: const EdgeInsets.all(smallPadding),
              child: Column(
                spacing: listSpacing,
                children: [
                  ManualValueNotifierBuilder(
                    valueListenable: images,
                    builder:
                        (
                          BuildContext context,
                          List<ImageItem> value,
                          Widget? child,
                        ) {
                          return AppText(
                            "${context.plural("importXImage", images.value.length)} ${context.tr(albumsInfoMap[AppState.currentGame.value?.selectedAlbum]!.name)}",
                          );
                        },
                  ),
                  Expanded(
                    child: AlbumPreviewer(
                      images: images.value,
                      onDelete: (ImageItem item) {
                        images.value.remove(item);
                        images.notify();
                      },
                      builder: (BuildContext context, ImageItem item) {
                        return RFutureBuilder(
                          future: MediaThumbnail.fromCache(
                            id: "${item.name}${item.time}",
                            imagePath: item.path,
                            targetWidth: 720,
                            isVideo: item.isVideo,
                          ),
                          builder: (context, image) {
                            return Listener(
                              onPointerDown: (e) {
                                if (e.kind == PointerDeviceKind.mouse &&
                                    e.buttons == kSecondaryMouseButton) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ImageViewerDialog(
                                        images: images.value,
                                        initImage: item,
                                      );
                                    },
                                  );
                                }
                              },
                              child: KeepAliveWrapper(
                                child: RawImage(
                                  image: image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  buttons,
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget ui = ValueListenableBuilder(
      valueListenable: isDrag,
      builder: (BuildContext context, bool isDrag, Widget? child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDrag
                ? AppTheme.of(context)!.colorScheme.background.enabledColor
                : AppTheme.of(context)!.colorScheme.background.disabledColor,
            border: Border.all(
              color: isDrag
                  ? AppTheme.of(context)!.colorScheme.secondary.hoveredColor
                  : AppTheme.of(context)!.colorScheme.secondary.pressedColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          child: Column(
            spacing: bigPadding,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.tr("left-clickToSelectImage"),
              AppText.tr("dragImageHere"),
              AppText.tr("right-clickToPasteImage"),
            ],
          ),
        );
      },
    );

    final Widget processor = DropTarget(
      onDragEntered: (DropEventDetails details) {
        isDrag.value = true;
      },
      onDragExited: (DropEventDetails details) {
        isDrag.value = false;
      },
      onDragDone: (DropDoneDetails details) {
        _dragDone(context, details);
      },
      child: GestureDetector(
        onTap: () {
          _pickFiles(context);
        },
        onSecondaryTap: () async {
          _paste(context);
        },
        child: ui,
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          bigPadding,
          0,
          bigPadding,
          bigPadding,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: smallPadding),
              height: topBarHeight,
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      "${context.tr("importImageTo")} ${context.tr(albumsInfoMap[AppState.currentGame.value?.selectedAlbum]!.name)}",
                    ),
                  ),
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
            Expanded(child: processor),
          ],
        ),
      ),
    );
  }
}
