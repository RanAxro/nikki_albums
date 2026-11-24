
import "media_item_view.dart";
import "../../domain/item.dart";
import "package:nikki_albums/ui/common/common.dart";

import "package:flutter/widgets.dart";
import "dart:typed_data";

import "package:flutter_riverpod/flutter_riverpod.dart";


class ImageItemView<T extends MediaItem> extends MediaItemView<T>{
  const ImageItemView({
    super.key,
    required super.item,
    super.heroTag,
    super.thumbnail,
  });

  @override
  Widget buildMedia(BuildContext context, WidgetRef ref, T item){
    return FutureBuilder<Uint8List>(
      future: item.getMediaBytes(),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot){
        if(snapshot.data != null){
          return Positioned.fill(
            child: Image.memory(snapshot.data!, fit: BoxFit.contain),
          );
        }
        return nil;
      },
    );
  }
}
