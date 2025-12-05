import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/component/component.dart";

import "package:flutter/material.dart";

class AlbumPreviewer extends StatelessWidget{
  final List<ImageItem> images;
  final Widget Function(BuildContext context, ImageItem item) builder;
  final bool isAllowDelete;
  final void Function(ImageItem item)? onDelete;

  AlbumPreviewer({
    super.key,
    required List<ImageItem> images,
    required this.builder,
    this.isAllowDelete = true,
    this.onDelete,
  }) : images = [...images];

  @override
  Widget build(BuildContext context){
    return SmoothPointerScroll(
      builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbar scrollbar){
        return GridView.builder(
          padding: const EdgeInsets.all(1),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AppState.albumColumn.value,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1 / 1,
          ),
          itemCount: images.length,
          controller: controller,
          physics: physics,
          itemBuilder: (context, index){

            bool isHover = false;
            final ImageItem item = images[index];
            final Widget child = builder(context, item);

            return StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setButtonState){
                return MouseRegion(
                  onEnter: (e){
                    setButtonState((){
                      isHover = true;
                    });
                  },
                  onHover: (e){
                    setButtonState((){
                      isHover = true;
                    });
                  },
                  onExit: (e){
                    setButtonState((){
                      isHover = false;
                    });
                  },
                  child: Stack(
                    children: [
                      if(images.contains(item))
                        Positioned.fill(child: child),
                      if(isAllowDelete && images.contains(item) && isHover)
                        Positioned(
                          top: smallPadding,
                          right: smallPadding,
                          width: smallButtonContentSize,
                          height: smallButtonContentSize,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.all(Radius.circular(0.5 * smallButtonContentSize)),
                            child: GestureDetector(
                              onTap: (){
                                setButtonState((){
                                  if(isAllowDelete){
                                    onDelete?.call(item);
                                    images.remove(item);
                                  }
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                color: AppTheme.of(context)!.colorScheme.background.color,
                                child: Image.asset("assets/icon/cross.webp", height: smallButtonContentSize - 4, color: AppTheme.of(context)!.colorScheme.background.onColor),
                              ),
                            ),
                          ),
                        ),
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