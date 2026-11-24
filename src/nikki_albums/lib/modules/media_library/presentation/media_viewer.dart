
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:nikki_albums/utils/extension.dart";

import "../domain/item.dart";
import "../domain/media_viewer_controller.dart";

import "package:flutter/widgets.dart";
import "dart:ui" as ui;

import "package:go_router/go_router.dart";
import "package:forui/forui.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "media_item_view/media_item_view.dart";


class MediaViewerRouteExtra<T extends MediaItem>{
  final MediaViewerController<T> controller;
  final String Function(MediaItem)? heroTag;
  final ui.Image? Function(MediaItem)? thumbnail;

  const MediaViewerRouteExtra({
    required this.controller,
    this.heroTag,
    this.thumbnail,
  });
}

class MediaViewer<T extends MediaItem> extends StatelessWidget{
  final MediaViewerController<T> controller;
  final String Function(T)? heroTag;
  final ui.Image? Function(T)? thumbnail;

  const MediaViewer({
    super.key,
    required this.controller,
    this.heroTag,
    this.thumbnail,
  });

  factory byRouteExtra(MediaViewerRouteExtra<T> extra){
    return MediaViewer<T>(
      controller: extra.controller,
      heroTag: extra.heroTag,
      thumbnail: extra.thumbnail,
    );
  }

  @override
  Widget build(BuildContext context){
    return ColoredBox(
      color: context.theme.colors.background,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onSecondaryTap: (){
              context.pop();
            },
            child: ListenableBuilder(
              listenable: controller,
              builder: (BuildContext context, Widget? child){
                return MediaItemView.byExtension(
                  item: controller.currentItem,
                  heroTag: controller.currentItem.let<String?>((T item) => heroTag?.call(item)),
                  thumbnail: controller.currentItem.let<ui.Image?>((T item) => thumbnail?.call(item)),
                );
              },
            ),
          ),

          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 60,
            child: HookBuilder(
              builder: (BuildContext context){
                final ValueNotifier<bool> hovered = useState(false);
                return MouseRegion(
                  onEnter: (_){
                    hovered.value = true;
                  },
                  onExit: (_){
                    hovered.value = false;
                  },
                  onHover: (_){
                    hovered.value = true;
                  },
                  child: GestureDetector(
                    onTap: (){
                      controller.previous();
                    },
                    child: AnimatedOpacity(
                      opacity: hovered.value ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: .blur(sigmaX: 10, sigmaY: 10),
                          child: Center(
                            child: Icon(FLucideIcons.arrowLeft),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            width: 60,
            child: HookBuilder(
              builder: (BuildContext context){
                final ValueNotifier<bool> hovered = useState(false);
                return MouseRegion(
                  onEnter: (_){
                    hovered.value = true;
                  },
                  onExit: (_){
                    hovered.value = false;
                  },
                  onHover: (_){
                    hovered.value = true;
                  },
                  child: GestureDetector(
                    onTap: (){
                      controller.next();
                    },
                    child: AnimatedOpacity(
                      opacity: hovered.value ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: .blur(sigmaX: 10, sigmaY: 10),
                          child: Center(
                            child: Icon(FLucideIcons.arrowRight),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class MediaItemView<T extends MediaItem> extends ConsumerWidget{
//   final MediaViewerController<T> controller;
//   final String Function(MediaItem)? heroTag;
//   final ui.Image? Function(MediaItem)? thumbnail;
//
//   const MediaItemView({
//     super.key,
//     required this.controller,
//     this.heroTag,
//     this.thumbnail,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref){
//     return ListenableBuilder(
//       listenable: controller,
//       builder: (BuildContext context, Widget? child){
//         if(controller.currentItem == null){
//           return SizedBox(
//             child: Text("null"),
//           );
//         }
//
//         final T item = controller.currentItem!;
//         final ui.Image? thumbnailImage = thumbnail?.call(item);
//         final Widget child = FutureBuilder<ui.Image>(
//           future: item.getMedia(),
//           builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot){
//             return Stack(
//               children: <Widget>[
//                 if(thumbnail != null)
//                   Positioned.fill(
//                     child: RawImage(image: thumbnailImage, fit: .contain),
//                   ),
//                 if(snapshot.data != null)
//                   Positioned.fill(
//                     child: RawImage(image: snapshot.data!, fit: .contain),
//                   ),
//               ],
//             );
//           },
//         );
//         if(heroTag == null){
//           return child;
//         }
//         return Hero(
//           tag: heroTag!.call(item),
//           child: child,
//         );
//       },
//     );
//   }
// }