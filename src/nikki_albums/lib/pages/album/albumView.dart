import "package:nikkialbums/game/game.dart";

import "package:flutter/material.dart";
import "dart:collection";

class AlbumView extends StatelessWidget{
  final AlbumVarType album;
  final SliverGridDelegate? gridDelegate;
  final EdgeInsetsGeometry? padding;
  final double headerHeight;
  final Widget Function(BuildContext context, String title) headerBuilder;
  final Widget Function(BuildContext context, ImageItem item) itemBuilder;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool isReverse;

  const AlbumView({
    super.key,
    required this.album,
    this.gridDelegate,
    this.padding,
    this.headerHeight = 40,
    required this.headerBuilder,
    required this.itemBuilder,
    this.controller,
    this.physics,
    this.isReverse = true,
  });

  @override
  Widget build(BuildContext context){
    final data = isReverse ? album : Map.fromEntries(
      album.entries.toList().reversed.map((e) {
        // SplayTreeSet 也支持逆序迭代器
        final reversedSet = LinkedHashSet<ImageItem>.of(e.value.toList().reversed);
        return MapEntry(e.key, reversedSet as Set<ImageItem>);
      }),
    );


    // 把 SplayTreeMap 拍平成两个 List，方便后面用 SliverList 懒加载
    final sections = <_Section>[];
    data.forEach((date, set){
      if(set.isNotEmpty) sections.add(_Section(date, set.toList()));
    });

    return CustomScrollView(
      controller: controller,
      physics: physics,
      slivers: sections.map((sec) => _buildSection(sec)).toList(),
    );
  }

  Widget _buildSection(_Section sec){
    return SliverMainAxisGroup(
      slivers: [
        // 日期 header
        SliverPersistentHeader(
          pinned: true,
          delegate: _HeaderDelegate(title: _formatDate(sec.date), headerHeight: headerHeight, headerBuilder: headerBuilder),
        ),
        // 图片网格（懒加载）
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: SliverGrid(
            gridDelegate: gridDelegate ?? const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (ctx, idx) => itemBuilder(ctx, sec.items[idx]),
              childCount: sec.items.length,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) => "${dt.year} - ${dt.month.toString().padLeft(2, "0")} - ${dt.day.toString().padLeft(2, "0")}";
}

/// 内部数据封装
class _Section{
  final DateTime date;
  final List<ImageItem> items;
  _Section(this.date, this.items);
}

/// 简单的 header delegate
class _HeaderDelegate extends SliverPersistentHeaderDelegate{
  final String title;
  final double headerHeight;
  final Widget Function(BuildContext context, String title) headerBuilder;
  const _HeaderDelegate({required this.title, required this.headerHeight, required this.headerBuilder});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent){
    return headerBuilder(context, title);
  }

  @override
  double get maxExtent => headerHeight;
  @override
  double get minExtent => headerHeight;
  @override
  bool shouldRebuild(covariant _HeaderDelegate old) => title != old.title;
}