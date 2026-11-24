
export "image_item_view.dart";
export "video_item_view.dart";
export "unsupported_item_view.dart";

import "image_item_view.dart";
import "video_item_view.dart";
import "unsupported_item_view.dart";
import "../../domain/item.dart";
import "../../domain/thumbnail.dart";
import "package:nikki_albums/ui/common/common.dart";
import "package:nikki_albums/utils/extension.dart";

import "package:flutter/widgets.dart";
import "dart:ui" as ui;

import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:mime/mime.dart";


abstract class MediaItemView<T extends MediaItem> extends HookConsumerWidget{
  static MediaItemView<T> byExtension<T extends MediaItem>({
    Key? key,
    required T? item,
    String? heroTag,
    ui.Image? thumbnail,
  }){
    final String? mimeType = item.let<String?>((T item) => lookupMimeType(item.path));
    if(ImageThumbnail.supportedImageMimeType.contains(mimeType)){
      return ImageItemView<T>(
        item: item,
        heroTag: heroTag,
        thumbnail: thumbnail,
      );
    }
    if(VideoThumbnail.supportedVideoMimeType.contains(mimeType)){
      return VideoItemView<T>(
        item: item,
        heroTag: heroTag,
        thumbnail: thumbnail,
      );
    }

    return UnsupportedItemView<T>(
      item: item,
      heroTag: heroTag,
      thumbnail: thumbnail,
    );
  }


  final T? item;
  final String? heroTag;
  final ui.Image? thumbnail;

  const MediaItemView({
    super.key,
    required this.item,
    this.heroTag,
    this.thumbnail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref){
    if(item == null){
      return Text("null");
    }

    final Widget child = Stack(
      children: <Widget>[
        Positioned.fill(
          child: buildThumbnail(context, ref, item!),
        ),
        if(useCover && item!.coverPath != null)
          Positioned.fill(
            child: buildCover(context, ref, item!),
          ),
        Positioned.fill(
          child: buildMedia(context, ref, item!),
        ),
      ],
    );
    if(heroTag == null){
      return child;
    }
    return Hero(
      tag: heroTag!,
      child: child,
    );
  }

  bool get useCover => false;

  Widget buildMedia(BuildContext context, WidgetRef ref, T item);

  Widget buildThumbnail(BuildContext context, WidgetRef ref, T item){
    if(thumbnail != null){
      return RawImage(image: thumbnail, fit: BoxFit.contain);
    }
    return FutureBuilder<ui.Image>(
      future: item.getThumbnail(targetWidth: 720),
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot){
        if(snapshot.hasData){
          return RawImage(image: snapshot.data!, fit: BoxFit.contain);
        }
        return nil;
      },
    );
  }

  Widget buildCover(BuildContext context, WidgetRef ref, T item){
    return FutureBuilder<ui.Image?>(
      future: item.getCover(),
      builder: (BuildContext context, AsyncSnapshot<ui.Image?> snapshot){
        if(snapshot.hasData){
          return RawImage(image: snapshot.data!, fit: BoxFit.contain);
        }
        return nil;
      },
    );
  }
}