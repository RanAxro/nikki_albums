
import "../domain/item.dart";

import "package:flutter/widgets.dart";
import "package:flutter/gestures.dart";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:animated_reorderable_list/animated_reorderable_list.dart";


class MediaLibraryView<T extends MediaItem> extends ConsumerWidget{
  final EdgeInsetsGeometry? padding;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollBehavior? scrollBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final bool shrinkWrap;

  final SliverGridDelegate sliverGridDelegate;
  final List<T> items;
  final Object? Function(T) itemKey;
  final Widget Function(BuildContext, T) builder;

  const MediaLibraryView({
    super.key,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.restorationId,
    this.keyboardDismissBehavior,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.shrinkWrap = false,

    required this.sliverGridDelegate,
    required this.items,
    required this.itemKey,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return CustomScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      scrollBehavior: scrollBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      shrinkWrap: shrinkWrap,
      slivers: <Widget>[
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: ReorderableAnimatedListImpl<T>.grid(
            items: items,
            itemBuilder: (BuildContext context, int index){
              final T item = items[index];
              return SizedBox.expand(
                key: ValueKey<Object?>(itemKey(item)),
                child: builder(context, item),
              );
            },
            sliverGridDelegate: sliverGridDelegate,
            enterTransition: <AnimationEffect<double>>[FadeIn(), ScaleIn()],
            exitTransition: <AnimationEffect<double>>[FadeIn(), ScaleIn()],
            scrollDirection: Axis.vertical,
            isSameItem: (T a, T b) => itemKey(a) == itemKey(b),
          ),
        ),
      ],
    );
  }
}

class MediaLibraryViewWithHeader<H, T extends MediaItem> extends ConsumerWidget{
  final EdgeInsetsGeometry? padding;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollBehavior? scrollBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final bool shrinkWrap;

  final SliverGridDelegate sliverGridDelegate;
  final Map<H, List<T>> items;
  final Object? Function(T) itemKey;
  final Widget Function(BuildContext, T) builder;
  final double headerHeight;
  final Object? Function(H header) headerKey;
  final Widget Function(BuildContext context, H header) headerBuilder;

  const MediaLibraryViewWithHeader({
    super.key,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.restorationId,
    this.keyboardDismissBehavior,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.shrinkWrap = false,

    required this.sliverGridDelegate,
    required this.items,
    required this.itemKey,
    required this.builder,
    required this.headerHeight,
    required this.headerKey,
    required this.headerBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return CustomScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      scrollBehavior: scrollBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      shrinkWrap: shrinkWrap,
      slivers: <Widget>[
        for(final MapEntry<H, List<T>> entry in items.entries)
          _buildSection(entry.key, entry.value),
      ],
    );
  }

  Widget _buildSection(H header, List<T> items){
    return SliverMainAxisGroup(
      key: ValueKey<H>(header),
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: _HeaderDelegate<H>(
            headerKey: headerKey,
            header: header,
            headerHeight: headerHeight,
            headerBuilder: headerBuilder,
          ),
        ),
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: ReorderableAnimatedListImpl<T>.grid(
            items: items,
            itemBuilder: (BuildContext context, int index){
              final T item = items[index];
              return SizedBox.expand(
                key: ValueKey<Object?>(itemKey(item)),
                child: builder(context, item),
              );
            },
            sliverGridDelegate: sliverGridDelegate,
            enterTransition: <AnimationEffect<double>>[FadeIn(), ScaleIn()],
            exitTransition: <AnimationEffect<double>>[FadeIn(), ScaleIn()],
            scrollDirection: Axis.vertical,
            isSameItem: (T a, T b) => itemKey(a) == itemKey(b),
          ),
        ),
      ],
    );
  }
}

class _HeaderDelegate<H> extends SliverPersistentHeaderDelegate{
  final Object? Function(H header) headerKey;
  final H header;
  final double headerHeight;
  final Widget Function(BuildContext context, H header) headerBuilder;

  const _HeaderDelegate({
    required this.headerKey,
    required this.header,
    required this.headerHeight,
    required this.headerBuilder,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent){
    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: headerBuilder(context, header),
      ),
    );
  }

  @override
  double get maxExtent => headerHeight;

  @override
  double get minExtent => headerHeight;

  @override
  bool shouldRebuild(covariant _HeaderDelegate<H> old){
    return header != old.header ||
      headerHeight != old.headerHeight ||
      headerKey(header) != old.headerKey(header);
  }
}
