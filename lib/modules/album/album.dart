import "package:multi_split_view/multi_split_view.dart";
import "package:nikki_albums/modules/album/mp4_to_gif.dart";

import "package:nikki_albums/modules/game/field_tree.dart";
import "package:nikki_albums/modules/image_edit/presentation/image_editor.dart";
import "album_view.dart";
import "album_previewer.dart";
import "package:nikki_albums/modules/file_transfer/file_transfer.dart";
import "package:nikki_albums/info.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/modules/game/game.dart";
import "package:nikki_albums/modules/game/album_manager.dart";
import "package:nikki_albums/modules/nikkias/nikkias.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";
import "package:nikki_albums/modules/tutorial/tutorial.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/utils/path.dart";
import "package:nikki_albums/utils/Image.dart";
import "package:nikki_albums/utils/clipboard.dart";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/gestures.dart";
import "dart:ui" hide Path;

import "package:easy_localization/easy_localization.dart";
import "package:file_picker/file_picker.dart";
import "package:desktop_drop/desktop_drop.dart";
import "package:media_kit/media_kit.dart";
import "package:media_kit_video/media_kit_video.dart";

final ContentItem item = ContentItem(
  name: "album",
  icon: AppIcon("album", height: mediumButtonContentSize),
  page: const Album(key: ValueKey("album")),
);

// final ContentItem item = ContentItem(
//   expectedPosition: 2,
//   name: "album",
//   icon: AssetImage("assets/icon/album.webp"),
//   page: const Album(),
// );
//
// void init(){
//   routes.addItem(item);
// }

class AlbumValuePool extends InheritedWidget {
  final ValueNotifier<bool> isPrimaryMouseDown = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isDragScrollbar = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isShowTimeHeader = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isPressTag = ValueNotifier<bool>(false);

  AlbumValuePool({super.key, required super.child});

  @override
  bool updateShouldNotify(AlbumValuePool oldWidget) => false;

  static AlbumValuePool of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AlbumValuePool>()
        as AlbumValuePool;
  }
}

class Album extends StatelessWidget {
  const Album({super.key});

  @override
  Widget build(BuildContext context) {
    return AlbumValuePool(
      child: Stack(children: [AlbumExhibition(), ToolBar()]),
    );
  }
}

/// ---------- top bar ---------- ///

class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  void _refresh(Game game) {
    game.refresh();
  }

  void _layoutMinus() {
    if (AppState.albumColumn.value > 1) AppState.albumColumn.value--;
  }

  void _layoutPlus() {
    AppState.albumColumn.value++;
  }

  void _deselect(Game game) {
    game.album.deselectAllImage();
  }

  void _selectAll(Game game) {
    game.album.selectAllImage();
  }

  void _invertSelect(Game game) {
    game.album.invertAllImage();
  }

  void _viewSelect(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SelectionViewerDialog(game: game),
    );
  }

  void _remove(BuildContext context, Game game) {
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
            Text(context.plural("XImageFailedToBeProcessed", errorNum)),
            const FailToCopyFileSystemEntry(),
            SmallButton(
              width: null,
              onClick: close,
              child: Text(context.tr("ok")),
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

  void _insert(BuildContext context, Game game) {
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
            Text(context.plural("XImageFailedToBeProcessed", errorNum)),
            const FailToCopyFileSystemEntry(),
            SmallButton(
              width: null,
              onClick: close,
              child: Text(context.tr("ok")),
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

  void _delete(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) => DeleteImagesDialog(game: game),
    );
  }

  void _import(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ImportImagesDialog(game),
    );
  }

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  void refresh(Game game) {
    game.refresh();
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
            Text(context.plural("XImageFailedToBeProcessed", errorNum)),
            const FailToCopyFileSystemEntry(),
            SmallButton(
              width: null,
              onClick: close,
              child: Text(context.tr("ok")),
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
            Text(context.plural("XImageFailedToBeProcessed", errorNum)),
            const FailToCopyFileSystemEntry(),
            SmallButton(
              width: null,
              onClick: close,
              child: Text(context.tr("ok")),
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
                isTranslate: false,
              );
            }),

            AppButtonStack(
              divider: [3, 2, 4, 3],
              children: [
                /// 刷新
                AppRawButton(
                  toolTip: "refresh",
                  onClick: () {
                    widget._refresh(game);
                  },
                  child: AppIcon("refresh", height: 18),
                ),

                /// 筛选
                FiltrationButton(game: game),

                /// 排序
                ListenableBuilder(
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
                        final String icon =
                            "assets/icon/${game.album.sortOrder.name}.webp";

                        return Tooltip(
                          message: text,
                          child: SmallButton(
                            colorRole: ColorRole.secondary,
                            onClick: () {
                              if (game.album.sortOrder ==
                                  SortOrder.descending) {
                                game.album.sortOrder = SortOrder.ascending;
                              } else {
                                game.album.sortOrder = SortOrder.descending;
                              }
                            },
                            child: Image.asset(
                              icon,
                              height: 20,
                              color: AppTheme.of(
                                context,
                              )!.colorScheme.secondary.onEnabledColor,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                /// 减少列数
                AppRawButton(
                  toolTip: "pa_layout_minus",
                  onClick: layoutMinus,
                  child: AppIcon("layout_minus", height: 20),
                ),

                /// 增加列数
                AppRawButton(
                  toolTip: "pa_layout_plus",
                  onClick: layoutPlus,
                  child: AppIcon("layout_plus", height: 20),
                ),

                /// 取消选择
                AppRawButton(
                  toolTip: "deselect",
                  onClick: () {
                    deselect(game);
                  },
                  child: AppIcon("deselect", height: 20),
                ),

                /// 全选
                AppRawButton(
                  toolTip: "select_all",
                  onClick: () {
                    selectAll(game);
                  },
                  child: AppIcon("select_all", height: 20),
                ),

                /// 反选
                AppRawButton(
                  toolTip: "invert_select",
                  onClick: () {
                    invertSelect(game);
                  },
                  child: AppIcon("invert", height: 16),
                ),

                /// 查看选中
                gameListenerBuilder(game, (
                  bool isExistSelectedImage,
                  bool isAllowBackup,
                ) {
                  final bool usable = isExistSelectedImage;

                  return AppRawButton(
                    toolTip: usable ? "viewSelect" : "",
                    onClick: () {
                      viewSelect(context, game);
                    },
                    usable: (game.selectedAlbum == AlbumType.Video || game.selectedAlbum == AlbumType.ExternalVideo) ? false : usable,
                    child: AppIcon("view", height: 18),
                  );
                }),

                /// 移出
                gameListenerBuilder(game, (
                  bool isExistSelectedImage,
                  bool isAllowBackup,
                ) {
                  final usable = isExistSelectedImage && isAllowBackup;

                  return AppRawButton(
                    toolTip: usable ? "remove" : "",
                    onClick: () {
                      moveOutside(context, game);
                    },
                    usable: usable,
                    child: AppIcon("remove", height: 20),
                  );
                }),

                /// 移入
                gameListenerBuilder(game, (
                  bool isExistSelectedImage,
                  bool isAllowBackup,
                ) {
                  final usable = isExistSelectedImage && isAllowBackup;

                  return AppRawButton(
                    toolTip: usable ? "insert" : "",
                    onClick: () {
                      moveInside(context, game);
                    },
                    usable: usable,
                    child: AppIcon("insert", height: 16),
                  );
                }),

                /// 删除
                gameListenerBuilder(game, (
                  bool isExistSelectedImage,
                  bool isAllowBackup,
                ) {
                  final usable = isExistSelectedImage;

                  return AppRawButton(
                    toolTip: usable ? "delete" : "",
                    onClick: () {
                      delete(context, game);
                    },
                    usable: usable,
                    child: AppIcon("delete", height: 20),
                  );
                }),

                /// 导出
                gameListenerBuilder(game, (
                  bool isExistSelectedImage,
                  bool isAllowBackup,
                ) {
                  return ExportImagesButton(
                    usable: isExistSelectedImage,
                    images: game.album.selectedImages.toList(growable: false),
                  );
                }),

                /// 导入
                AppRawButton(
                  toolTip: "import",
                  onClick: () {
                    import(context, game);
                  },
                  usable: game.selectedAlbum != AlbumType.Video,
                  child: AppIcon("import", height: 18),
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
            ),
          ],
        );
      },
    );

    /// TODO 多tab
    final Widget toolBox = Row(
      spacing: listSpacing,
      children: [
        AlbumButton(),

        /// tag button
        ValueListenableBuilder(
          valueListenable: AppState.currentGame,
          builder: (BuildContext context, Game? game, Widget? child) {
            if (game == null) return block0;

            return SmallButton(
              onClick: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TagListDialog(game);
                  },
                );
              },
              child: Image.asset(
                "assets/icon/tag.webp",
                height: 16,
                color: AppTheme.of(context)!
                    .colorScheme
                    .secondary
                    .onEnabledColor
                    .withValues(alpha: iconWeakeningRate),
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

        final List<AppRawButton> children = <AppRawButton>[];

        for (AlbumType type in game.accessibleAlbumType) {
          final AlbumsInfoItem info = albumsInfoMap[type]!;
          if (info.visible) {
            children.add(
              AppRawButton(
                padding: const EdgeInsets.all(smallPadding),
                onClick: () {
                  game.selectedAlbum = type;
                },
                child: Row(
                  children: [
                    block5W,
                    AppIcon("album/${info.type}", height: 18),
                    block15W,
                    AppText(info.name),
                  ],
                ),
              ),
            );
          }
        }

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
                        AppText(albumsInfoMap[game.selectedAlbum]!.name),
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
          children: children,
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
          return Center(
            child: Text(
              context.tr("currentGameIsNull"),
              style: TextStyle(
                color: AppTheme.of(context)!.colorScheme.background.onColor,
              ),
            ),
          );
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
    scrollbarController.addListener(onDrag);
  }

  @override
  Widget build(BuildContext context) {
    return SmoothPointerScroll(
      scrollbarController: scrollbarController,
      builder:
          (
            BuildContext context,
            ScrollController controller,
            ScrollPhysics physics,
            IndependentScrollbarController scrollbarController,
          ) {
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
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.of(
                                context,
                              )!.colorScheme.background.onColor,
                            ),
                          ),
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

  @override
  Widget build(BuildContext context){
    return RFutureBuilder(
      future: Future((){
        if(widget.imageItem.cover == null){
          return MediaThumbnail.fromCache(
            id: widget.imageItem.name,
            imagePath: widget.imageItem.path,
            targetWidth: 720,
            isVideo: widget.imageItem.isVideo,
          );
        }else{
          return MediaThumbnail.fromCache(
            id: widget.imageItem.cover!,
            imagePath: Path(widget.imageItem.cover!),
            targetWidth: 720,
            isVideo: false,
          );
        }
      }),
      builder: (context, image) {
        final Widget exhibit = NotifierBuilder(
          listenable: widget.game.album.whenSelectedImagesChange,
          builder: (BuildContext context, Widget? child) {
            final bool isSelected = widget.game.album.selectedImages.contains(
              widget.imageItem,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: RawImage(image: image, fit: BoxFit.cover),
                ),
                if (isSelected)
                  Positioned.fill(child: ColoredBox(color: Color(0x66000000))),

                if (isSelected)
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
          onPointerDown: (e) {
            if (e.kind == PointerDeviceKind.mouse &&
                e.buttons == kPrimaryMouseButton) {
              widget.game.album.invertImage(widget.imageItem);
            }
            if (e.kind == PointerDeviceKind.mouse &&
                e.buttons == kSecondaryMouseButton) {
              showAppDialog(
                context: context,
                builder: (BuildContext context) {
                  return RFutureBuilder(
                    future: widget.game.album.images,
                    builder: (BuildContext context, Set<ImageItem> images) {
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
          builder:
              (
                BuildContext context,
                void Function(void Function()) setButtonState,
              ) {
                return MouseRegion(
                  onEnter: (_) {
                    final bool isPrimaryMouseDown = AlbumValuePool.of(
                      context,
                    ).isPrimaryMouseDown.value;
                    final bool isDragScrollbar = AlbumValuePool.of(
                      context,
                    ).isDragScrollbar.value;
                    final bool isPressTag = AlbumValuePool.of(
                      context,
                    ).isPressTag.value;
                    // 长按多选
                    if (isPrimaryMouseDown && !isDragScrollbar && !isPressTag)
                      widget.game.album.invertImage(widget.imageItem);

                    setButtonState(() {
                      isHover = true;
                    });
                  },
                  onHover: (_) {
                    setButtonState(() {
                      isHover = true;
                    });
                  },
                  onExit: (_) {
                    setButtonState(() {
                      isHover = false;
                    });
                  },
                  child: Stack(
                    children: [
                      groundLayout,

                      if(widget.game.selectedAlbum != AlbumType.Video && widget.game.selectedAlbum != AlbumType.ExternalVideo)
                        _generateTagButton(context, isHover),
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
                      Text(
                        tag ?? context.tr("defaultTag"),
                        style: TextStyle(
                          color: AppTheme.of(
                            context,
                          )!.colorScheme.background.onColor,
                        ),
                      ),
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
                  child: Text(
                    context.tr("addCustomTag"),
                    style: TextStyle(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.background.onColor,
                    ),
                  ),
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
                  child: RTextFiled(
                    controller: TextEditingController()..text = tag.value,
                    labelText: context.tr("tagName"),
                    colorRole: ColorRole.background,
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
            SmallButton(
              width: null,
              height: mediumButtonSize,
              colorRole: ColorRole.background,
              transparent: false,
              onClick: () {
                Navigator.of(context).pop();
              },
              child: Text(
                context.tr("cancel"),
                style: TextStyle(
                  color: AppTheme.of(context)!.colorScheme.background.onColor,
                ),
              ),
            ),

            /// save
            SmallButton(
              width: null,
              height: mediumButtonSize,
              colorRole: ColorRole.background,
              transparent: false,
              onClick: () {
                verify();

                if (errorInfo.value == null) {
                  Navigator.of(context).pop((tag.value, color.value));
                }
              },
              child: Text(
                context.tr("save"),
                style: TextStyle(
                  color: AppTheme.of(context)!.colorScheme.background.onColor,
                ),
              ),
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
                Text(
                  context.tr("deleteXTag", args: [tag]),
                  style: TextStyle(
                    color: AppTheme.of(context)!.colorScheme.background.onColor,
                  ),
                ),

                /// cancel
                SmallButton(
                  padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                  width: null,
                  height: mediumButtonSize,
                  colorRole: ColorRole.background,
                  transparent: false,
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    context.tr("cancel"),
                    style: TextStyle(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.background.onColor,
                    ),
                  ),
                ),

                /// delete
                SmallButton(
                  padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                  width: null,
                  height: mediumButtonSize,
                  colorRole: ColorRole.background,
                  transparent: false,
                  onClick: () {
                    game.tag.delete(tag);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    context.tr("delete"),
                    style: TextStyle(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.background.onColor,
                    ),
                  ),
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
                return SmallButton(
                  padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                  width: null,
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

                                    Text(
                                      tag ?? context.tr("defaultTag"),
                                      style: TextStyle(
                                        color: AppTheme.of(
                                          context,
                                        )!.colorScheme.background.onColor,
                                      ),
                                    ),

                                    Expanded(child: block0),

                                    SmallButton(
                                      onClick: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Image.asset(
                                        "assets/icon/cross.webp",
                                        height: 20,
                                        color: AppTheme.of(
                                          context,
                                        )!.colorScheme.background.onColor,
                                      ),
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
                      Expanded(
                        child: Text(
                          tag ?? context.tr("defaultTag"),
                          style: TextStyle(
                            color: AppTheme.of(
                              context,
                            )!.colorScheme.background.onColor,
                          ),
                        ),
                      ),

                      /// edit tag
                      if (tag != null)
                        Tooltip(
                          message: context.tr("edit"),
                          child: SmallButton(
                            colorRole: ColorRole.primary,
                            onClick: () {
                              _editTag(context, tag);
                            },
                            child: Image.asset(
                              "assets/icon/edit.webp",
                              height: 20,
                              color: AppTheme.of(
                                context,
                              )!.colorScheme.primary.onColor,
                            ),
                          ),
                        ),

                      /// delete tag
                      if (tag != null)
                        Tooltip(
                          message: context.tr("delete"),
                          child: SmallButton(
                            colorRole: ColorRole.primary,
                            onClick: () {
                              _deleteTag(context, tag);
                            },
                            child: Image.asset(
                              "assets/icon/delete.webp",
                              height: 20,
                              color: AppTheme.of(
                                context,
                              )!.colorScheme.primary.onColor,
                            ),
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

                Expanded(
                  child: Text(
                    context.tr("manageTags"),
                    style: TextStyle(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.background.onColor,
                    ),
                  ),
                ),

                SmallButton(
                  colorRole: ColorRole.background,
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    "assets/icon/cross.webp",
                    height: 20,
                    color: AppTheme.of(context)!.colorScheme.background.onColor,
                  ),
                ),
              ],
            ),

            tagButtons,

            /// add tag
            SmallButton(
              padding: const EdgeInsets.symmetric(horizontal: smallPadding),
              width: null,
              height: mediumButtonSize,
              colorRole: ColorRole.background,
              transparent: false,
              onClick: () {
                _addTag(context);
              },
              child: Text(
                context.tr("addCustomTag"),
                style: TextStyle(
                  color: AppTheme.of(context)!.colorScheme.background.onColor,
                ),
              ),
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
    final Widget toolButtons = AppButtonStack(
      divider: game == null ? const [1, 4, 2] : const [1, 4, 2, 2],
      children: [
        // Tooltip(
        //   richMessage: TextSpan(
        //     children: [
        //       TextSpan(text: context.tr("close")),
        //       // WidgetSpan(
        //       //   child: Text(
        //       //     "\u{f06a}\u{f07a}",
        //       //     style: TextStyle(
        //       //       fontFamily: "RanAppKey",
        //       //       fontSize: 16,
        //       //     ),
        //       //   ),
        //       //   alignment: PlaceholderAlignment.middle,
        //       //   baseline: TextBaseline.alphabetic,
        //       // ),
        //       TextSpan(
        //         text: "\u{f06a}\u{f07a}",
        //         style: TextStyle(fontFamily: "RanAppKey", fontSize: 20),
        //       ),
        //     ],
        //   ),
        //   child: AppRawButton(
        //     // toolTip: context.tr("close") + getKeyboardCharacter([LogicalKeyboardKey.escape]),
        //     isTranslate: false,
        //     onClick: () {
        //       Navigator.of(context).pop();
        //     },
        //     child: AppIcon("cross", height: 20),
        //   ),
        // ),

        AppRawButton(
          toolTip: "reset",
          onClick: controller.reset,
          child: AppIcon("refresh", height: 20),
        ),
        AppRawButton(
          toolTip: "pa_horizontal_flip",
          onClick: controller.horizontalFlip,
          child: AppIcon("horizontal_flip", height: 18),
        ),

        AppRawButton(
          toolTip: "pa_vertical_flip",
          onClick: controller.verticalFlip,
          child: AppIcon("vertical_flip", height: 18),
        ),

        AppRawButton(
          toolTip: "pa_rotate_left_90",
          onClick: controller.rotateLeft90,
          child: AppIcon("rotate_left_90", height: 20),
        ),

        AppRawButton(
          toolTip: "pa_rotate_right_90",
          onClick: controller.rotateRight90,
          child: AppIcon("rotate_right_90", height: 20),
        ),

        AppRawButton(
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

        AppRawButton(
          toolTip:
              context.tr("pa_to_previous_image") +
              getKeyboardCharacter([LogicalKeyboardKey.arrowLeft]),
          isTranslate: false,
          onClick: controller.toPreviousImage,
          child: AppIcon("back", height: 20),
        ),

        AppRawButton(
          toolTip:
              context.tr("pa_to_next_image") +
              getKeyboardCharacter([LogicalKeyboardKey.arrowRight]),
          isTranslate: false,
          onClick: controller.toNextImage,
          child: AppIcon("forward", height: 20),
        ),

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
                              child: SmallButton(
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
                        final bool isSelected = game!.album.selectedImages
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
                              getKeyboardCharacter([LogicalKeyboardKey.space]),
                          child: SmallButton(
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
      ],
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
                                builder: (BuildContext context, Widget? child) {
                                  return LayoutBuilder(
                                    builder:
                                        (
                                          BuildContext context,
                                          BoxConstraints constraint,
                                        ) {
                                          AppState
                                                  .imageCustomDataWidgetSize
                                                  .value =
                                              constraint.maxWidth;

                                          late final Field rootField;

                                          if (controller.isAttach) {
                                            rootField = images[controller.index]
                                                .getAdditionSync(
                                                  game?.selectedUid?.value,
                                                  game?.selectedAlbum,
                                                );
                                          } else {
                                            rootField = initImage
                                                .getAdditionSync(
                                                  game?.selectedUid?.value,
                                                  game?.selectedAlbum,
                                                );
                                          }

                                          return FieldTree(
                                            root: rootField,
                                            config: FieldTreeConfiguration(
                                              onFieldTap: (Field field) async {
                                                if (field.key ==
                                                    "ia_camera_params") {
                                                  bool isError = false;

                                                  try {
                                                    await copyTextToClipboard(
                                                      field.value.toString(),
                                                    );
                                                  } catch (e) {
                                                    isError = true;
                                                  }

                                                  if (context.mounted) {
                                                    AppToast.showMessage(
                                                      context: context,
                                                      message: context.tr(
                                                        isError
                                                            ? "pa_copy_failed"
                                                            : "pa_copy_successful",
                                                      ),
                                                      state: !isError,
                                                    );
                                                  }
                                                } else if (field.key ==
                                                        "ia_photo_region" ||
                                                    field.key ==
                                                        "ia_possible_photo_region") {
                                                  final (
                                                    GamePhotoRegion
                                                    photoRegionInfo,
                                                    num x,
                                                    num y,
                                                    num z,
                                                  ) = field.value;

                                                  final (
                                                    int px,
                                                    int py,
                                                  ) = photoRegionInfo.map
                                                      .coordToPixel((x, y));

                                                  showAppDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AppDialog(
                                                        title: photoRegionInfo
                                                            .stringData,
                                                        child: GestureDetector(
                                                          onSecondaryTap: () {
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                          child: AppMapViewer(
                                                            assetName:
                                                                photoRegionInfo
                                                                    .map
                                                                    .assetName,
                                                            imageSize: Size(
                                                              photoRegionInfo
                                                                  .map
                                                                  .mapSize
                                                                  .$1
                                                                  .toDouble(),
                                                              photoRegionInfo
                                                                  .map
                                                                  .mapSize
                                                                  .$2
                                                                  .toDouble(),
                                                            ),
                                                            markerPixel: Offset(
                                                              px.toDouble(),
                                                              py.toDouble(),
                                                            ),
                                                            maxScale: 28,
                                                            initScale: 2,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            ),
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
            SizedBox(height: topBarHeight, child: toolButtons),
          ],
        ),
      ),
    );
  }
}


class VideoViewerDialog extends StatefulWidget{
  final Game? game;
  final ImageItem video;

  const VideoViewerDialog({
    super.key,
    this.game,
    required this.video,
  });

  @override
  State<VideoViewerDialog> createState() => _VideoViewerDialogState();
}
class _VideoViewerDialogState extends State<VideoViewerDialog>{
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.video.path.path));
  }

  @override
  void dispose(){
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Listener(
      onPointerDown: (e) async{
        if(e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton){
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
                    onClick: (){
                      Navigator.of(context).pop();
                    },
                    child: AppIcon("cross"),
                  ),

                  Expanded(child: block0),

                  AppButton.smallText(
                    onClick: (){
                      showAppDialog(
                        isBarrier: true,
                        context: context,
                        builder: (BuildContext context){
                          return VideoToGifPanel(
                            videoPath: widget.video.path.path,
                          );
                        }
                      );
                    },
                    child: Row(
                      spacing: listSpacing,
                      children: [
                        AppIcon("forward"),
                        AppText("导出gif动图"),
                      ],
                    ),
                  )
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

            final Color color = AppTheme.of(
              context,
            )!.colorScheme.background.onColor.withAlpha(isFilter ? 255 : 0);

            return AppButton(
              useConfiguration: false,
              borderRadius: 0,
              padding: const EdgeInsets.symmetric(horizontal: smallPadding),
              width: null,
              height: mediumButtonSize,
              onClick: () async {
                if (isFilter) {
                  game.album.unfilter(filtration);
                } else {

                  /// onlyDailyTask
                  if(filtration == Filtration.onlyDailyTask){
                    final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
                    bool cancel = false;

                    if(context.mounted){
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
                            child: AppText("cancel"),
                          );
                        },
                      );
                    }

                    final Set<ImageItem> images = await game.album.images;


                    if(game.selectedUid?.value != null && images.isNotEmpty){
                      await ImageAddition.files(
                        AlbumType.NikkiPhotos_HighQuality,
                        images.map((ImageItem item) => item.path.path).toList(),
                        game.selectedUid!.value,
                        onProgress: (c, t){
                          progress.value = (c / t).clamp(0, 1);
                        }
                      );

                      progress.value = 1;
                    }

                    game.album.filter(filtration);

                  }else{
                    game.album.filter(filtration);
                  }
                }
              },
              child: Row(
                spacing: listSpacing,
                children: [
                  Image.asset(
                    "assets/icon/tick.webp",
                    height: 16,
                    color: color,
                  ),
                  Text(
                    context.tr(filtration.name),
                    style: TextStyle(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.secondary.onColor,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  // Widget _buttonBuilder(valueListenable, String text){
  //   return ValueListenableBuilder<bool>(
  //     valueListenable: valueListenable,
  //     common: (BuildContext context, bool value, Widget? child){
  //       final Color color = value ? AppTheme.of(context)!.colorScheme.background.onColor : AppTheme.of(context)!.colorScheme.background.onColor.withAlpha(0);
  //
  //       return MenuItemButton(
  //         onPressed: () async{
  //           valueListenable.value = !valueListenable.value;
  //         },
  //         child: Row(
  //           spacing: listSpacing,
  //           children: [
  //             Image.asset("assets/icon/tick.webp", height: 16, color: color),
  //             Text(text, style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: game,
      builder: (BuildContext context, Widget? child) {
        return MenuAnchor(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(
              AppTheme.of(context)!.colorScheme.background.color,
            ),
          ),
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
                return Tooltip(
                  message: context.tr("filter"),
                  child: SmallButton(
                    colorRole: ColorRole.secondary,
                    onClick: () {
                      controller.isOpen
                          ? controller.close()
                          : controller.open();
                    },
                    child: Image.asset(
                      "assets/icon/filtration.webp",
                      height: 20,
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.secondary.onEnabledColor,
                    ),
                  ),
                );
              },
          // menuChildren: Filtration.values.map((Filtration filtration) => _buttonBuilder(filtration)).toList(growable: false),
          menuChildren: [
            _buttonBuilder(Filtration.inGame),
            _buttonBuilder(Filtration.outOfGame),
            if (game.selectedAlbum == AlbumType.NikkiPhotos_HighQuality)
              _buttonBuilder(Filtration.onlyDailyTask),
          ],
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
                return Text(
                  context.plural(
                    "xImageSelected",
                    game.album.selectedImages.length,
                  ),
                  style: TextStyle(
                    color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                  ),
                );
              },
            ),
          ),
          SmallButton(
            onClick: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              "assets/icon/cross.webp",
              height: 20,
              color: AppTheme.of(context)!.colorScheme.background.onColor,
            ),
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
            id: item.name,
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
            Text(
              context.plural("XImageFailedToBeProcessed", errorNum),
              style: TextStyle(
                color: AppTheme.of(context)!.colorScheme.secondary.onColor,
              ),
            ),
            const FailToCopyFileSystemEntry(),
            SmallButton(
              width: null,
              onClick: close,
              child: Text(
                context.tr("ok"),
                style: TextStyle(
                  color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                ),
              ),
            ),
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

                return SmallButton(
                  padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                  width: null,
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
                      Text(
                        "${context.tr(albumsInfoMap[type]!.name)} ( ${albumsInfoMap[type]!.type} )",
                        style: TextStyle(
                          color: AppTheme.of(
                            context,
                          )!.colorScheme.background.onColor,
                        ),
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
            Text(
              context.plural("deleteXImage", game.album.selectedImages.length),
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.of(context)!.colorScheme.secondary.onColor,
              ),
            ),

            options.isEmpty
                ? block20H
                : Container(
                    padding: const EdgeInsets.all(smallPadding),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.tr("deleteSameImage"),
                      style: TextStyle(
                        color: AppTheme.of(
                          context,
                        )!.colorScheme.secondary.onColor,
                      ),
                    ),
                  ),

            ...options,

            Row(
              children: [
                Expanded(
                  child: SmallButton(
                    width: null,
                    colorRole: ColorRole.background,
                    transparent: false,
                    onClick: () {
                      _delete(context);
                    },
                    child: Text(
                      context.tr("moveToRecycleBin"),
                      style: TextStyle(
                        color: AppTheme.of(
                          context,
                        )!.colorScheme.secondary.onColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SmallButton(
                    width: null,
                    colorRole: ColorRole.highlight,
                    transparent: false,
                    onClick: () {
                      _cancel(context);
                    },
                    child: Text(
                      context.tr("cancel"),
                      style: TextStyle(
                        color: AppTheme.of(
                          context,
                        )!.colorScheme.highlight.onColor,
                      ),
                    ),
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
    final Color color = usable
        ? AppTheme.of(context)!.colorScheme.secondary.onEnabledColor
        : AppTheme.of(context)!.colorScheme.secondary.onDisabledColor;

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          AppTheme.of(context)!.colorScheme.background.color,
        ),
      ),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return Tooltip(
              message: usable ? context.tr("export") : "",
              child: SmallButton(
                colorRole: ColorRole.secondary,
                onClick: () {
                  controller.isOpen ? controller.close() : controller.open();
                },
                usable: usable,
                child: Image.asset(
                  "assets/icon/export.webp",
                  height: 18,
                  color: color,
                ),
              ),
            );
          },
      menuChildren: [
        /// copy images to clipboard
        MenuItemButton(
          onPressed: () async {
            final List<Path> paths = images
                .map((item) => item.path)
                .toList(growable: false);

            final ValueNotifier<double?> progress = ValueNotifier<double?>(
              null,
            );
            bool isError = false;

            // showProgressBar(
            //   context: context,
            //   barrierDismissible: false,
            //   autoClose: false,
            //   valueListenable: progress,
            //   completedBuilder: (BuildContext context, void Function() close){
            //     return Column(
            //       spacing: listSpacing,
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         if(isError)
            //           Text(context.plural("XImageFailedToBeProcessed", paths.length), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),
            //         SmallButton(
            //           width: null,
            //           colorRole: ColorRole.background,
            //           transparent: false,
            //           onClick: close,
            //           child: Text(context.tr("close"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            //         ),
            //       ],
            //     );
            //   }
            // );

            AppToast.showMessage(context: context, message: "复制中");

            try {
              await copyFilesToClipboard(paths);
            } catch (e) {
              isError = true;
            } finally {
              progress.value = 1;
            }

            if (context.mounted) {
              AppToast.showMessage(
                context: context,
                message: context.tr(
                  isError ? "pa_copy_failed" : "pa_copy_successful",
                ),
                state: !isError,
              );
            }
          },
          child: Text(
            context.tr("exportToClipboard"),
            style: TextStyle(
              color: AppTheme.of(context)!.colorScheme.secondary.onColor,
            ),
          ),
        ),

        /// export images to native device
        MenuItemButton(
          onPressed: () async {
            final String? location = await FilePicker.platform.getDirectoryPath(
              dialogTitle: context.plural("exportXImage", images.length),
              lockParentWindow: true,
            );
            if (location == null) return;

            final Path root = Path(location);

            final ValueNotifier<double?> progress = ValueNotifier<double?>(
              null,
            );
            final int total = images.length;
            int current = 0;
            int errorNum = 0;

            if (context.mounted) {
              showProgressBar(
                context: context,
                barrierDismissible: false,
                autoClose: false,
                valueListenable: progress,
                completedBuilder:
                    (BuildContext context, void Function() close) {
                      return Column(
                        spacing: listSpacing,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (errorNum != 0)
                            Text(
                              context.plural(
                                "XImageFailedToBeProcessed",
                                errorNum,
                              ),
                              style: TextStyle(
                                color: AppTheme.of(
                                  context,
                                )!.colorScheme.error.pressedColor,
                              ),
                            ),
                          SmallButton(
                            width: null,
                            colorRole: ColorRole.background,
                            transparent: false,
                            onClick: close,
                            child: Text(
                              context.tr("close"),
                              style: TextStyle(
                                color: AppTheme.of(
                                  context,
                                )!.colorScheme.background.onColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
              );
            }

            for (ImageItem item in images) {
              try {
                final Path destination = root + item.path.name;
                await item.path.file.copy(destination.path);
              } catch (e) {
                errorNum++;
              } finally {
                current++;
                progress.value = current / total;
              }
            }
            progress.value = 1;
          },
          child: Text(
            context.tr("exportToLocal"),
            style: TextStyle(
              color: AppTheme.of(context)!.colorScheme.secondary.onColor,
            ),
          ),
        ),

        /// export images to network device
        MenuItemButton(
          onPressed: () {
            if (AppState.currentGame.value != null) {
              exportImageToNetwork(context, AppState.currentGame.value!);
            }

            // showDialog(
            //   barrierDismissible: false,
            //   context: context,
            //   builder: (BuildContext context){
            //     return ExportNetworkDialog(images: images);
            //   }
            // );
          },
          child: Text(
            context.tr("exportToNetwork"),
            style: TextStyle(
              color: AppTheme.of(context)!.colorScheme.secondary.onColor,
            ),
          ),
        ),

        /// encode and export nikkias file to native device
        MenuItemButton(
          onPressed: () async {
            if (AppState.currentGame.value == null) return;
            final Game game = AppState.currentGame.value!;

            final String? location = await FilePicker.platform.getDirectoryPath(
              dialogTitle: context.tr("exportNikkiasFile"),
              lockParentWindow: true,
            );
            if (location == null) return;

            final Path root = Path(location);
            final String filename =
                "${DateTime.now().millisecondsSinceEpoch}.$nikkiasExtension";
            final Path savePath = root + filename;

            final ValueNotifier<double?> progress = ValueNotifier<double?>(
              null,
            );
            bool isError = false;

            if (context.mounted) {
              showProgressBar(
                context: context,
                barrierDismissible: false,
                autoClose: false,
                valueListenable: progress,
                completedBuilder:
                    (BuildContext context, void Function() close) {
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
                                    color: AppTheme.of(
                                      context,
                                    )!.colorScheme.error.onColor,
                                  ),
                                ),
                          SmallButton(
                            width: null,
                            colorRole: ColorRole.background,
                            transparent: false,
                            onClick: close,
                            child: Text(
                              context.tr("close"),
                              style: TextStyle(
                                color: AppTheme.of(
                                  context,
                                )!.colorScheme.background.onColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
              );
            }

            final ImageTransferNikkiasManifest manifest =
                ImageTransferNikkiasManifest(
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
          },
          child: Text(
            context.tr("exportNikkiasToLocal"),
            style: TextStyle(
              color: AppTheme.of(context)!.colorScheme.secondary.onColor,
            ),
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
      type: FileType.image,
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
              Text(context.plural("XImageFailedToBeProcessed", errorNum)),
              const FailToCopyFileSystemEntry(),
              SmallButton(
                width: null,
                colorRole: ColorRole.background,
                onClick: close,
                child: Text(context.tr("ok")),
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
                child: SmallButton(
                  width: null,
                  colorRole: ColorRole.background,
                  onClick: () {
                    _cancel(context);
                  },
                  child: Text(
                    context.tr("cancel"),
                    style: TextStyle(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.background.onColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SmallButton(
                  width: null,
                  colorRole: ColorRole.highlight,
                  transparent: false,
                  onClick: () {
                    _import(context);
                  },
                  child: Text(
                    context.tr("import"),
                    style: TextStyle(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.highlight.onColor,
                    ),
                  ),
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
                          return Text(
                            "${context.plural("importXImage", images.value.length)} ${context.tr(albumsInfoMap[AppState.currentGame.value?.selectedAlbum]!.name)}",
                            style: TextStyle(
                              color: AppTheme.of(
                                context,
                              )!.colorScheme.background.onColor,
                            ),
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
                            id: item.name,
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
              Text(
                context.tr("left-clickToSelectImage"),
                style: TextStyle(
                  color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                ),
              ),
              Text(
                context.tr("dragImageHere"),
                style: TextStyle(
                  fontSize: 24,
                  color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                ),
              ),
              Text(
                context.tr("right-clickToPasteImage"),
                style: TextStyle(
                  color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                ),
              ),
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
                    child: Text(
                      "${context.tr("importImageTo")} ${context.tr(albumsInfoMap[AppState.currentGame.value?.selectedAlbum]!.name)}",
                      style: TextStyle(
                        color: AppTheme.of(
                          context,
                        )!.colorScheme.background.onColor,
                      ),
                    ),
                  ),
                  SmallButton(
                    colorRole: ColorRole.background,
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      "assets/icon/cross.webp",
                      height: 20,
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.background.onColor,
                    ),
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
