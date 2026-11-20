
import "package:animated_reorderable_list/animated_reorderable_list.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../domain/item.dart";

import "package:flutter/material.dart";



class AlbumViewBuilder extends ConsumerWidget{
  final SliverGridDelegate gridDelegate;
  final List<MediaItem> items;
  final Widget Function(BuildContext, MediaItem) builder;

  const AlbumViewBuilder({
    super.key,
    required this.gridDelegate,
    required this.items,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return AnimatedGridView(
      sliverGridDelegate: gridDelegate,
      enterTransition: [FadeIn(), ScaleIn()],
      exitTransition: [FadeIn(), ScaleIn()],
      isSameItem: (a, b) => a.path == b.path,
      items: items,
      itemBuilder: (BuildContext context, int index){
        final MediaItem item = items[index];
        return SizedBox.expand(
          key: ValueKey(item.path),
          child: builder(context, item),
        );
      },
    );
  }
}
