import "albumView.dart";
import "albumPreviewer.dart";
import "sendFile.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/frame.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/tutorial/tutorial.dart";
import "package:nikkialbums/api/path.dart";
import "package:nikkialbums/api/Image.dart";
import "package:nikkialbums/api/clipboard.dart";

import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import "dart:ui" hide Path;

import "package:easy_localization/easy_localization.dart";
import "package:file_picker/file_picker.dart";
import 'package:desktop_drop/desktop_drop.dart';


final ContentItem item = ContentItem(
  expectedPosition: 2,
  name: "album",
  icon: AssetImage("assets/icon/album.webp"),
  page: const Album(),
);

void init(){
  pages.addItem(item);
}


class AlbumValuePool extends InheritedWidget{
  final ValueNotifier<bool> isPrimaryMouseDown = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isShowTimeHeader = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isViewGameAlbum = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isViewBackupAlbum = ValueNotifier<bool>(true);

  AlbumValuePool({super.key, required super.child});

  @override
  bool updateShouldNotify(AlbumValuePool oldWidget){
    return false;
  }

  static AlbumValuePool? of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<AlbumValuePool>();
  }
}
class Album extends StatelessWidget{
  const Album({super.key});

  @override
  Widget build(BuildContext context){
    return AlbumValuePool(
      child: Stack(
        children: [
          AlbumExhibition(),
          ToolBar(),
        ],
      ),
    );
  }
}

class ToolBar extends StatefulWidget{
  const ToolBar({super.key});

  void _refresh(Game game){
    game.refresh();
  }

  void _layoutMinus(){
    if(AppState.albumColumn.value > 1) AppState.albumColumn.value--;
  }

  void _layoutPlus(){
    AppState.albumColumn.value++;
  }

  void _deselect(Game game){
    game.deselectAllImage();
  }

  void _selectAll(Game game){
    game.selectAllImage();
  }

  void _invertSelect(Game game){
    game.invertAllImage();
  }

  void _viewSelect(BuildContext context, Game game){
    showDialog(
      context: context,
      builder: (BuildContext context) => SelectionViewerDialog(game: game),
    );
  }

  void _remove(BuildContext context, Game game){
    final ValueNotifier<double> progress = ValueNotifier(0);
    int errorNum = 0;

    showProgressBar(
      context: context,
      valueListenable: progress,
      autoClose: false,
      completedBuilder: (BuildContext context, void Function() close){
        if(errorNum == 0){
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
            )
          ],
        );
      }
    );

    game.backupSelectedImages(
      onProgress: (double currentProgress){
        progress.value = currentProgress;
      },
      onError: (Set items){
        errorNum = items.length;
      }
    );
  }

  void _insert(BuildContext context, Game game){
    final ValueNotifier<double> progress = ValueNotifier(0);
    int errorNum = 0;

    showProgressBar(
      context: context,
      valueListenable: progress,
      autoClose: false,
      completedBuilder: (BuildContext context, void Function() close){
        if(errorNum == 0){
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
            )
          ],
        );
      }
    );

    game.restoreSelectedImages(
      onProgress: (double currentProgress){
        progress.value = currentProgress;
      },
      onError: (Set items){
        errorNum = items.length;
      }
    );
  }

  void _delete(BuildContext context, Game game){
    showDialog(
      context: context,
      builder: (BuildContext context) => DeleteImagesDialog(game: game),
    );
  }

  void _import(BuildContext context, Game game){
    showDialog(
      context: context,
      builder: (BuildContext context) => ImportImagesDialog(),
    );
  }

  @override
  State<ToolBar> createState() => _ToolBarState();
}
class _ToolBarState extends State<ToolBar>{

  Widget _gameListener(Game game, Widget Function(bool isExistSelectedImage, bool isAllowBackup) builder){
    return ListenableBuilder(
      listenable: game,
      builder: (BuildContext context, Widget? child){
        final bool isAllowBackup = game.selectedAlbum != null && game.isAllowBackup(game.selectedAlbum!);

        return NotifierBuilder(
          listenable: game.whenSelectedImagesChange,
          builder: (BuildContext context, Widget? child){
            final bool isExistSelectedImage = game.selectedImages.isNotEmpty;

            return builder(isExistSelectedImage, isAllowBackup);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){

    final Widget toolButtons = ValueListenableBuilder(
      valueListenable: AppState.currentGame,
      builder: (BuildContext context, Game? game, Widget? child){
        if(game == null) return block0;

        return Row(
          children: [
            /// 刷新
            Tooltip(
              message: context.tr("refresh"),
              child: SmallButton(
                colorRole: ColorRoles.secondary,
                onClick: (){
                  widget._refresh(game);
                },
                child: Image.asset("assets/icon/refresh.webp", height: 18, color: AppTheme.of(context)!.colorScheme.secondary.onEnabledColor),
              ),
            ),

            /// 筛选
            const FiltrationButton(),

            SmallVerticalDivider(color: AppTheme.of(context)!.colorScheme.secondary.pressedColor),

            /// 减少列数
            Tooltip(
              message: context.tr("layout_minus"),
              child: SmallButton(
                colorRole: ColorRoles.secondary,
                onClick: widget._layoutMinus,
                child: Image.asset("assets/icon/layout_minus.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onEnabledColor),
              ),
            ),
            /// 增加列数
            Tooltip(
              message: context.tr("layout_plus"),
              child: SmallButton(
                colorRole: ColorRoles.secondary,
                onClick: widget._layoutPlus,
                child: Image.asset("assets/icon/layout_plus.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onEnabledColor),
              ),
            ),

            SmallVerticalDivider(color: AppTheme.of(context)!.colorScheme.secondary.pressedColor),

            /// 取消选择
            Tooltip(
              message: context.tr("deselect"),
              child: SmallButton(
                colorRole: ColorRoles.secondary,
                onClick: (){
                  widget._deselect(game);
                },
                child: Image.asset("assets/icon/deselect.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onEnabledColor),
              ),
            ),
            /// 全选
            Tooltip(
              message: context.tr("selectAll"),
              child: SmallButton(
                colorRole: ColorRoles.secondary,
                onClick: (){
                  widget._selectAll(game);
                },
                child: Image.asset("assets/icon/selectAll.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onEnabledColor),
              ),
            ),
            /// 反选
            Tooltip(
              message: context.tr("invertSelect"),
              child: SmallButton(
                colorRole: ColorRoles.secondary,
                onClick: (){
                  widget._invertSelect(game);
                },
                child: Image.asset("assets/icon/invert.webp", height: 16, color: AppTheme.of(context)!.colorScheme.secondary.onEnabledColor),
              ),
            ),
            /// 查看选中
            _gameListener(game, (bool isExistSelectedImage, bool isAllowBackup){
              final bool usable = isExistSelectedImage;
              final Color color = usable ? AppTheme.of(context)!.colorScheme.secondary.onEnabledColor : AppTheme.of(context)!.colorScheme.secondary.onDisabledColor;

              return Tooltip(
                message: usable ? context.tr("viewSelect") : "",
                child: SmallButton(
                  colorRole: ColorRoles.secondary,
                  onClick: (){
                    widget._viewSelect(context, game);
                  },
                  usable: usable,
                  child: Image.asset("assets/icon/view.webp", height: 18, color: color),
                ),
              );
            }),

            SmallVerticalDivider(color: AppTheme.of(context)!.colorScheme.secondary.pressedColor),

            /// 移出
            _gameListener(game, (bool isExistSelectedImage, bool isAllowBackup){
              final usable = isExistSelectedImage && isAllowBackup;
              final Color color = usable ? AppTheme.of(context)!.colorScheme.secondary.onEnabledColor : AppTheme.of(context)!.colorScheme.secondary.onDisabledColor;

              return Tooltip(
                message: usable ? context.tr("remove") : "",
                child: SmallButton(
                  colorRole: ColorRoles.secondary,
                  onClick: (){
                    widget._remove(context, game);
                  },
                  usable: usable,
                  child: Image.asset("assets/icon/remove.webp", height: 20, color: color),
                ),
              );
            }),
            /// 移入
            _gameListener(game, (bool isExistSelectedImage, bool isAllowBackup){
              final usable = isExistSelectedImage && isAllowBackup;
              final Color color = usable ? AppTheme.of(context)!.colorScheme.secondary.onEnabledColor : AppTheme.of(context)!.colorScheme.secondary.onDisabledColor;

              return Tooltip(
                message: usable ? context.tr("insert") : "",
                child: SmallButton(
                  colorRole: ColorRoles.secondary,
                  onClick: (){
                    widget._insert(context, game);
                  },
                  usable: usable,
                  child: Image.asset("assets/icon/insert.webp", height: 16, color: color),
                ),
              );
            }),
            /// 删除
            _gameListener(game, (bool isExistSelectedImage, bool isAllowBackup){
              final usable = isExistSelectedImage;
              final Color color = usable ? AppTheme.of(context)!.colorScheme.secondary.onEnabledColor : AppTheme.of(context)!.colorScheme.secondary.onDisabledColor;

              return Tooltip(
                message: usable ? context.tr("delete") : "",
                child: SmallButton(
                  colorRole: ColorRoles.secondary,
                  onClick: (){
                    widget._delete(context, game);
                  },
                  usable: usable,
                  child: Image.asset("assets/icon/delete.webp", height: 20, color: color),
                ),
              );
            }),

            SmallVerticalDivider(color: AppTheme.of(context)!.colorScheme.secondary.pressedColor),

            /// 导出
            _gameListener(game, (bool isExistSelectedImage, bool isAllowBackup){
              return ExportImagesButton(usable: isExistSelectedImage, images: game.selectedImages.toList(growable: false));
            }),

            /// 导入
            Tooltip(
              message: context.tr("import"),
              child: SmallButton(
                colorRole: ColorRoles.secondary,
                onClick: (){
                  widget._import(context, game);
                },
                child: Image.asset("assets/icon/import.webp", height: 18, color: AppTheme.of(context)!.colorScheme.secondary.onColor),
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
        );
      },
    );

    final Widget toolBox = Row(
      spacing: listSpacing,
      children: [
        AlbumButton(),

        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SmoothPointerScroll(
              builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbar scrollbar){
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
              color: AppTheme.of(context)!.colorScheme.secondary.color.withAlpha(0x99),
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


class AlbumButton extends StatelessWidget{
  const AlbumButton({super.key});

  void _openAlbumFolder(){
    AppState.currentGame.value?.gameAlbumPath?.open();
  }

  @override
  Widget build(BuildContext context){
    Widget menu = ValueListenableBuilder<Game?>(
      valueListenable: AppState.currentGame,
      builder: (BuildContext context, Game? game, Widget? child){
        final List<Widget> menuChildren = <Widget>[];

        if(game != null){
          final List<AlbumType> gameAlbum = game.accessibleAlbum;

          for(AlbumType type in gameAlbum){
            final AlbumsInfoItem info = albumsInfoMap[type]!;
            if(info.visible){
              menuChildren.add(MenuItemButton(
                onPressed: (){
                  game.selectedAlbum = type;
                },
                child: Text(context.tr(info.name), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
              ));
            }
          }
        }

        return MenuAnchor(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
          ),
          builder: (BuildContext context, MenuController controller, Widget? child){
            late final Widget text;

            if(game == null){
              text = Text(context.tr("currentGameIsNull"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor));
            }else{
              if(game.selectedAlbum == null){
                text = Text(context.tr("selectedAlbumIsNull"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor));
              }else{
                text = ListenableBuilder(
                  listenable: game,
                  builder: (BuildContext context, Widget? child){
                    return Text(context.tr(albumsInfoMap[game.selectedAlbum!]!.name), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor));
                  },
                );
              }
            }

            return GestureDetector(
              onSecondaryTap: (){
                _openAlbumFolder();
              },
              child: SmallButton(
                padding: const EdgeInsets.all(6),
                width: null,
                colorRole: ColorRoles.secondary,
                onClick: (){
                  controller.isOpen ? controller.close() : controller.open();
                },
                usable: game != null,
                child: text,
              ),
            );
          },
          menuChildren: menuChildren,
        );
      },
    );

    return menu;
  }
}


class AlbumExhibition extends StatefulWidget{
  const AlbumExhibition({super.key});

  @override
  State<AlbumExhibition> createState() => _AlbumExhibitionState();
}
class _AlbumExhibitionState extends State<AlbumExhibition>{

  Widget generateViewWithHeader(Game game, AlbumVarType album, int column){
    return SmoothPointerScroll(
      builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbar scrollbar){
        return Container(
          padding: EdgeInsets.only(top: topBarHeight),
          color: AppTheme.of(context)!.colorScheme.background.color,
          child: AlbumView(
            data: album,
            controller: controller,
            physics: physics,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: column,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            headerHeight: topBarHeight,
            headerBuilder: (BuildContext context, String title){
              return Container(
                alignment: Alignment.centerLeft,
                color: AppTheme.of(context)!.colorScheme.background.color,
                padding: const EdgeInsets.only(left: listSpacing),
                height: topBarHeight,
                child: Text(title, style: TextStyle(fontSize: 16, color: AppTheme.of(context)!.colorScheme.background.onColor)),
              );
            },
            itemBuilder: (BuildContext context, ImageItem item){
              return Exhibit(game, item);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: AppState.currentGame,
      builder: (BuildContext context, Game? game, Widget? child){
        if(game == null) return block0;

        return ListenableBuilder(
          listenable: game,
          builder: (BuildContext context, Widget? child){
            return RFutureBuilder(
              future: game.album,
              builder: (BuildContext context, AlbumVarType originAlbum){
                return MultiValueListenableBuilder(
                  listenables: [AlbumValuePool.of(context)!.isViewGameAlbum, AlbumValuePool.of(context)!.isViewBackupAlbum],
                  builder: (BuildContext context, List<Object?> values){
                    final bool isViewGameAlbum = values[0] as bool;
                    final bool isViewBackupAlbum = values[1] as bool;
                    final AlbumVarType album = Game.filterAlbum(originAlbum, (ImageItem item) =>
                      (isViewGameAlbum && item.source == ImageSource.game) ||
                      (isViewBackupAlbum && item.source == ImageSource.backup)
                    );
                    return Listener(
                      // 鼠标键按下
                      onPointerDown: (e){
                        if(e.kind == PointerDeviceKind.mouse && e.buttons == kPrimaryMouseButton){
                          AlbumValuePool.of(context)!.isPrimaryMouseDown.value = true;
                        }
                      },
                      // 鼠标键松开
                      onPointerUp: (e){
                        if(e.kind == PointerDeviceKind.mouse){
                          AlbumValuePool.of(context)!.isPrimaryMouseDown.value = false;
                        }
                      },
                      child: MultiValueListenableBuilder(
                        listenables: [AlbumValuePool.of(context)!.isShowTimeHeader, AppState.albumColumn],
                        builder: (BuildContext context, List<Object?> values){
                          final bool isShowTimeHeader = values[0] as bool;
                          final int column = values[1] as int;

                          if(isShowTimeHeader){
                            return generateViewWithHeader(game, album, column);
                          }
                          return GridAlbum(game: game, images: Game.flattenAlbum(album).toList(), aspectRatio: 1 / 1);
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


class GridAlbum extends StatelessWidget{
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
  Widget build(BuildContext context){
    return ValueListenableBuilder<int>(
      valueListenable: AppState.albumColumn,
      builder: (BuildContext context, int column, Widget? child){
        return SmoothPointerScroll(
          builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbar scrollbar){
            return Row(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(listSpacing, topBarHeight, listSpacing, 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: column,  // 列数
                      mainAxisSpacing: 16 / column,  // 上下间距
                      crossAxisSpacing: 16 / column,  // 左右间距
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: images.length,
                    controller: controller,
                    physics: physics,
                    itemBuilder: (context, index){
                      return KeepAliveWrapper(
                        child: Exhibit(game, images[index]),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: topBarHeight),
                  width: 10,
                  child: scrollbar,
                )
              ],
            );
          },
        );
      }
    );
  }
}



class Exhibit extends StatefulWidget{
  final Game game;
  final ImageItem imageItem;
  const Exhibit(
    this.game,
    this.imageItem,
    {super.key}
  );

  @override
  State<Exhibit> createState() => _ExhibitState();
}
class _ExhibitState extends State<Exhibit>{
  @override
  Widget build(BuildContext context){
    return RFutureBuilder(
      future: ImageThumbnail.fromCache(id: widget.imageItem.name, imagePath: widget.imageItem.path, targetWidth: 720),
      builder: (context, image){
        final Widget exhibit = NotifierBuilder(
          listenable: widget.game.whenSelectedImagesChange,
          builder: (BuildContext context, Widget? child){
            final bool isSelected = widget.game.selectedImages.contains(widget.imageItem);
            return Stack(
              children: [
                Positioned.fill(
                  child: RawImage(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
                if(isSelected)
                  Positioned.fill(
                    child: ColoredBox(color: Color(0x66000000)),
                  ),
                if(isSelected)
                  Positioned(
                    left: smallPadding,
                    top: smallPadding,
                    width: smallButtonContentSize,
                    height: smallButtonContentSize,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.all(Radius.circular(0.5 * smallButtonContentSize)),
                      child: Container(
                        color: AppTheme.of(context)!.colorScheme.secondary.onColor,
                        child: Image.asset("assets/icon/tick.webp", color: AppTheme.of(context)!.colorScheme.secondary.color),
                      ),
                    ),
                  ),
              ],
            );
          },
        );

        return ValueListenableBuilder(
          valueListenable: AlbumValuePool.of(context)!.isPrimaryMouseDown,
          builder: (BuildContext context, bool isPrimaryMouseDown, Widget? child){
            return MouseRegion(
              onEnter: (_){
                // 长按多选
                if(isPrimaryMouseDown) widget.game.invertImage(widget.imageItem);
              },
              child: Listener(
                onPointerDown: (e){
                  if(e.kind == PointerDeviceKind.mouse && e.buttons == kPrimaryMouseButton){
                    widget.game.invertImage(widget.imageItem);
                  }
                  if(e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton){
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return RFutureBuilder(
                          future: widget.game.album,
                          builder: (BuildContext context, AlbumVarType album){
                            final List<ImageItem> images = Game.flattenAlbum(album).toList();
                            return ImageViewerDialog(images: images, initImage: widget.imageItem);
                          },
                        );
                      }
                    );
                  }
                },
                child: exhibit,
              ),
            );
          },
        );
      },
    );
  }
}





class FiltrationButton extends StatelessWidget{
  const FiltrationButton({
    super.key,
  });

  Widget _buttonBuilder(valueListenable, String text){
    return ValueListenableBuilder<bool>(
      valueListenable: valueListenable,
      builder: (BuildContext context, bool value, Widget? child){
        final Color color = value ? AppTheme.of(context)!.colorScheme.background.onColor : AppTheme.of(context)!.colorScheme.background.onColor.withAlpha(0);

        return MenuItemButton(
          onPressed: () async{
            valueListenable.value = !valueListenable.value;
          },
          child: Row(
            spacing: listSpacing,
            children: [
              Image.asset("assets/icon/tick.webp", height: 16, color: color),
              Text(text, style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child){
        return Tooltip(
          message: context.tr("filter"),
          child: SmallButton(
            colorRole: ColorRoles.secondary,
            onClick: (){
              controller.isOpen ? controller.close() : controller.open();
            },
            child: Image.asset("assets/icon/filtration.webp", height: 20, color: AppTheme.of(context)!.colorScheme.secondary.onEnabledColor),
          ),
        );
      },
      menuChildren: [
        _buttonBuilder(AlbumValuePool.of(context)!.isViewGameAlbum, context.tr("in-game")),
        _buttonBuilder(AlbumValuePool.of(context)!.isViewBackupAlbum, context.tr("out-of-game")),
      ],
    );
  }
}




class SelectionViewerDialog extends StatelessWidget{
  final Game game;
  const SelectionViewerDialog({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context){
    final List<ImageItem> images = game.selectedImages.toList(growable: false);

    final Widget topBar = Container(
      margin: const EdgeInsets.symmetric(horizontal: smallPadding),
      height: topBarHeight,
      child: Row(
        children: [
          Expanded(
            child: NotifierBuilder(
              listenable: game.whenSelectedImagesChange,
              builder: (BuildContext context, Widget? child){
                return Text(context.plural("xImageSelected", game.selectedImages.length), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor));
              },
            ),
          ),
          SmallButton(
            onClick: (){
              Navigator.of(context).pop();
            },
            child: Image.asset("assets/icon/cross.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
          )
        ],
      ),
    );

    final Widget viewer = AlbumPreviewer(
      images: images,
      onDelete: (ImageItem item){
        game.deselectImage(item);
        if(game.selectedImages.isEmpty) Navigator.of(context).pop();
      },
      builder: (BuildContext context, ImageItem item){
        return RFutureBuilder(
          future: ImageThumbnail.fromCache(id: item.name, imagePath: item.path, targetWidth: 720),
          builder: (context, image){
            return Listener(
              onPointerDown: (e){
                if(e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return ImageViewerDialog(images: images, initImage: item);
                    }
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Column(
        children: [
          topBar,
          Expanded(
            child: viewer,
          )
        ],
      ),
    );
  }
}



class DeleteImagesDialog extends StatelessWidget{
  final Game game;
  final ManualValueNotifier<Map<AlbumType, bool>> chainDeletion;

  DeleteImagesDialog({
    super.key,
    required this.game,
  }) :
    chainDeletion = ManualValueNotifier(Map.from(albumsInfoMap[game.selectedAlbum]?.chainDeletion ?? {}));

  void _cancel(BuildContext context){
    Navigator.of(context).pop();
  }

  void _delete(BuildContext context){
    Navigator.of(context).pop();

    final ValueNotifier<double> progress = ValueNotifier(0);
    int errorNum = 0;

    showProgressBar(
      context: context,
      valueListenable: progress,
      autoClose: false,
      completedBuilder: (BuildContext context, void Function() close){
        if(errorNum == 0){
          WidgetsBinding.instance.addPostFrameCallback((_) => close());
          return block0;
        }

        return Column(
          spacing: listSpacing,
          children: [
            Text(context.plural("XImageFailedToBeProcessed", errorNum), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
            const FailToCopyFileSystemEntry(),
            SmallButton(
              width: null,
              onClick: close,
              child: Text(context.tr("ok"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
            )
          ],
        );
      }
    );

    game.deleteSelectedImages(
      chainDeletion.value,
      onProgress: (double currentProgress){
        progress.value = currentProgress;
      },
      onError: (Set items){
        errorNum = items.length;
      }
    );
  }

  @override
  Widget build(BuildContext context){

    final List<Widget> options = <Widget>[];

    for(AlbumType type in chainDeletion.value.keys){
      options.add(
        ManualValueNotifierBuilder(
          valueListenable: chainDeletion,
          builder: (BuildContext context, Map<AlbumType, bool> chain, Widget? child){
            late final Widget tickBox;

            if(chain[type]!){
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
              onClick: (){
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
                      borderRadius: BorderRadiusGeometry.all(Radius.circular(0.5 * smallButtonContentSize)),
                      child: tickBox,
                    ),
                  ),
                  Text("${context.tr(albumsInfoMap[type]!.name)} ( ${albumsInfoMap[type]!.type} )"),
                ],
              ),
            );
          },
        )
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
            Text(context.plural("deleteXImage", game.selectedImages.length), style: TextStyle(fontSize: 20, color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
            Container(
              padding: const EdgeInsets.all(smallPadding),
              alignment: Alignment.centerLeft,
              child: Text(context.tr("deleteSameImage"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
            ),

            ...options,

            Row(
              children: [
                Expanded(
                  child: SmallButton(
                    width: null,
                    colorRole: ColorRoles.background,
                    onClick: (){
                      _delete(context);
                    },
                    child: Text(context.tr("delete"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
                  ),
                ),
                Expanded(
                  child: SmallButton(
                    width: null,
                    colorRole: ColorRoles.background,
                    onClick: (){
                      _cancel(context);
                    },
                    child: Text(context.tr("cancel"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
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



class ExportImagesButton extends StatelessWidget{
  final bool usable;
  final List<ImageItem> images;

  const ExportImagesButton({
    super.key,
    required this.usable,
    required this.images,
  });

  @override
  Widget build(BuildContext context){
    final Color color = usable ? AppTheme.of(context)!.colorScheme.secondary.onEnabledColor : AppTheme.of(context)!.colorScheme.secondary.onDisabledColor;

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppTheme.of(context)!.colorScheme.background.color),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child){
        return Tooltip(
          message: usable ? context.tr("export") : "",
          child: SmallButton(
            colorRole: ColorRoles.secondary,
            onClick: (){
              controller.isOpen ? controller.close() : controller.open();
            },
            usable: usable,
            child: Image.asset("assets/icon/export.webp", height: 18, color: color),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () async{
            final List<Path> paths = images.map((item) => item.path).toList(growable: false);

            await copyFilesToClipboard(paths);
          },
          child: Text(context.tr("exportToClipboard"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
        ),
        MenuItemButton(
          onPressed: () async{
            final String? location = await FilePicker.platform.getDirectoryPath(
              dialogTitle: context.plural("exportXImage", images.length),
              lockParentWindow: true,
            );

            /// TODO 进度条
            if(location == null) return;

            final Path root = Path(location);

            /// TODO完善

            for(ImageItem item in images){
              final Path destination = root + item.path.name;
              item.path.file.copy(destination.path);
            }
          },
          child: Text(context.tr("exportToLocal"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
        ),
        MenuItemButton(
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context){
                return ExportNetworkDialog(images: images);
              }
            );
          },
          child: Text(context.tr("exportToNetwork"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
        ),
      ],
    );
  }
}



class ImportImagesDialog extends StatelessWidget{
  final ValueNotifier<bool> isDrag = ValueNotifier<bool>(false);
  final ManualValueNotifier<List<ImageItem>> images = ManualValueNotifier<List<ImageItem>>([]);

  ImportImagesDialog({super.key});

  Future<void> _pickFiles(BuildContext context) async{
    final FilePickerResult? location = await FilePicker.platform.pickFiles(
      dialogTitle: context.tr("importImageTo"),
      lockParentWindow: true,
      type: FileType.image,
      allowedExtensions: imageExtension.toList(growable: false),
      allowMultiple: true,
    );

    if(location != null){
      images.value.clear();
      for(String? pathStr in location.paths){
        if(pathStr == null || !isImageExtension(Path(pathStr))) continue;

        images.value.add(ImageItem(
          source: ImageSource.other,
          path: Path(pathStr),
          time: DateTime.now(),
        ));
      }

      images.notify();

      _createAlbumPreviewer(context);
    }
  }

  void _dragDone(BuildContext context, DropDoneDetails details){
    images.value = details.files
      .map((DropItem item) => Path(item.path))
      .where(isImageExtension)
      .map((Path path) => ImageItem(source: ImageSource.other, path: path, time: DateTime.now()))
      .toList();
    images.notify();

    _createAlbumPreviewer(context);
  }

  Future<void> _paste(BuildContext context) async{
    images.value = (await readFilesFromClipboard())
      .where(isImageExtension)
      .map((path) => ImageItem(source: ImageSource.other, path: path, time: DateTime.now()))
      .toList();
    images.notify();

    _createAlbumPreviewer(context);
  }

  void _cancel(BuildContext context){
    Navigator.of(context).pop();
  }

  void _import(BuildContext context){
    Navigator.of(context).pop();

    if(AppState.currentGame.value == null) return;
    final Game game = AppState.currentGame.value!;

    final ValueNotifier<double> progress = ValueNotifier(0);
    int errorNum = 0;

    showProgressBar(
      context: context,
      valueListenable: progress,
      autoClose: false,
      completedBuilder: (BuildContext context, void Function() close){
        if(errorNum == 0){
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
              onClick: close,
              child: Text(context.tr("ok")),
            )
          ],
        );
      }
    );

    game.importImages(
      images.value,
      onProgress: (double currentProgress){
        progress.value = currentProgress;
      },
      onError: (Set items){
        errorNum = items.length;
      }
    );
  }

  void _createAlbumPreviewer(BuildContext context){
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context){

        final Widget buttons = Row(
          children: [
            Expanded(
              child: SmallButton(
                width: null,
                colorRole: ColorRoles.background,
                onClick: (){
                  _cancel(context);
                },
                child: Text(context.tr("cancel")),
              ),
            ),
            Expanded(
              child: SmallButton(
                width: null,
                colorRole: ColorRoles.background,
                onClick: (){
                  _import(context);
                },
                child: Text(context.tr("save")),
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
                  builder: (BuildContext context, List<ImageItem> value, Widget? child){
                    return Text("${context.plural("importXImage", images.value.length)} ${context.tr(albumsInfoMap[AppState.currentGame.value?.selectedAlbum]!.name)}");
                  },
                ),
                Expanded(
                  child: AlbumPreviewer(
                    images: images.value,
                    onDelete: (ImageItem item){
                      images.value.remove(item);
                      images.notify();
                    },
                    builder: (BuildContext context, ImageItem item){
                      return RFutureBuilder(
                        future: ImageThumbnail.fromCache(id: item.name, imagePath: item.path, targetWidth: 720),
                        builder: (context, image){
                          return Listener(
                            onPointerDown: (e){
                              if(e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return ImageViewerDialog(images: images.value, initImage: item);
                                  }
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
      }
    );
  }

  @override
  Widget build(BuildContext context){

    final Widget ui = ValueListenableBuilder(
      valueListenable: isDrag,
      builder: (BuildContext context, bool isDrag, Widget? child){
        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDrag ? AppTheme.of(context)!.colorScheme.background.enabledColor : AppTheme.of(context)!.colorScheme.background.disabledColor,
            border: Border.all(
              color: isDrag ? AppTheme.of(context)!.colorScheme.secondary.hoveredColor : AppTheme.of(context)!.colorScheme.secondary.pressedColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          child: Column(
            spacing: bigPadding,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.tr("left-clickToSelectImage"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
              Text(context.tr("dragImageHere"), style: TextStyle(fontSize: 24, color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
              Text(context.tr("right-clickToPasteImage"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.secondary.onColor)),
            ],
          ),
        );
      },
    );

    final Widget processor = DropTarget(
      onDragEntered: (DropEventDetails details){
        isDrag.value = true;
      },
      onDragExited: (DropEventDetails details){
        isDrag.value = false;
      },
      onDragDone: (DropDoneDetails details){
        _dragDone(context, details);
      },
      child: GestureDetector(
        onTap: (){
          _pickFiles(context);
        },
        onSecondaryTap: () async{
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
        padding: const EdgeInsets.fromLTRB(bigPadding, 0, bigPadding, bigPadding),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: smallPadding),
              height: topBarHeight,
              child: Row(
                children: [
                  Expanded(
                    child: Text("${context.tr("importImageTo")} ${context.tr(albumsInfoMap[AppState.currentGame.value?.selectedAlbum]!.name)}", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ),
                  SmallButton(
                    onClick: (){
                      Navigator.of(context).pop();
                    },
                    child: Image.asset("assets/icon/cross.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
                  )
                ],
              ),
            ),
            Expanded(
              child: processor,
            ),
          ],
        ),
      ),
    );
  }
}



class ImageViewerDialog extends StatelessWidget{
  final List<ImageItem> images;
  final ImageItem initImage;
  final ImageViewerController controller = ImageViewerController();

  ImageViewerDialog({
    super.key,
    required this.images,
    required this.initImage,
  });

  @override
  Widget build(BuildContext context){

    final Widget toolButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: context.tr("close"),
          child: SmallButton(
            onClick: (){
              Navigator.of(context).pop();
            },
            child: Image.asset("assets/icon/cross.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        ),

        Tooltip(
          message: context.tr("reset"),
          child: SmallButton(
            onClick: (){
              controller.reset();
            },
            child: Image.asset("assets/icon/refresh.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        ),

        Tooltip(
          message: context.tr("horizontalFlip"),
          child: SmallButton(
            onClick: (){
              controller.horizontalFlip();
            },
            child: Image.asset("assets/icon/horizontalFlip.webp", height: 16, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        ),
        Tooltip(
          message: context.tr("verticalFlip"),
          child: SmallButton(
            onClick: (){
              controller.verticalFlip();
            },
            child: Image.asset("assets/icon/verticalFlip.webp", height: 16, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        ),

        Tooltip(
          message: context.tr("rotateLeft90"),
          child: SmallButton(
            onClick: (){
              controller.rotateLeft90();
            },
            child: Image.asset("assets/icon/rotateLeft90.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        ),
        Tooltip(
          message: context.tr("rotateRight90"),
          child: SmallButton(
            onClick: (){
              controller.rotateRight90();
            },
            child: Image.asset("assets/icon/rotateRight90.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        ),

        Tooltip(
          message: context.tr("toPreviousImage"),
          child: SmallButton(
            onClick: (){
              controller.toPreviousImage();
            },
            child: Image.asset("assets/icon/back.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        ),
        Tooltip(
          message: context.tr("toNextImage"),
          child: SmallButton(
            onClick: (){
              controller.toNextImage();
            },
            child: Image.asset("assets/icon/forward.webp", height: 20, color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),
        ),
      ],
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Listener(
        onPointerDown: (e){
          if(e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton){
            Navigator.of(context).pop();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ImageViewer(
                controller: controller,
                imageCount: images.length,
                initIndex: images.indexOf(initImage),
                imageBuilder: (BuildContext context, int index){
                  return Image.file(images[index].path.file, fit: BoxFit.contain);
                },
              ),
            ),
            SizedBox(
              height: topBarHeight,
              child: toolButtons,
            ),
          ],
        ),
      ),
    );
  }
}