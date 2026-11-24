
import "media_item_view.dart";
import "../../domain/item.dart";
import "package:nikki_albums/ui/common/common.dart";

import "package:flutter/widgets.dart";

import "package:flutter_riverpod/flutter_riverpod.dart";


class UnsupportedItemView<T extends MediaItem> extends MediaItemView<T>{
  const UnsupportedItemView({
    super.key,
    required super.item,
    super.heroTag,
    super.thumbnail,
  });

  @override
  Widget buildMedia(BuildContext context, WidgetRef ref, T item){
    return nil;
  }
}
