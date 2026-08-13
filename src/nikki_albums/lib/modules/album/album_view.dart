import "package:nikki_albums/modules/game/album_manager.dart";
import "package:nikki_albums/modules/game/game.dart";

import "package:flutter/material.dart";

class AlbumView extends StatefulWidget {
  final ProcessedAlbumType album;
  final SliverGridDelegate? gridDelegate;
  final EdgeInsetsGeometry? padding;
  final double headerHeight;
  final Widget Function(BuildContext context, String title) headerBuilder;
  final Widget Function(BuildContext context, ImageItem item) itemBuilder;
  final ScrollController? controller;
  final ScrollPhysics? physics;

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
  });

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // 把 SplayTreeMap 拍平成两个 List，方便后面用 SliverList 懒加载
    final sections = <_Section>[];
    widget.album.forEach((date, set) {
      if (set.isNotEmpty) sections.add(_Section(date, set.toList()));
    });

    return CustomScrollView(
      controller: controller,
      physics: widget.physics,
      slivers: sections.map((sec) => _buildSection(sec)).toList(),
    );
  }

  Widget _buildSection(_Section sec) {
    return SliverMainAxisGroup(
      slivers: [
        // 日期 header
        SliverPersistentHeader(
          pinned: true,
          delegate: _HeaderDelegate(
            title: _formatDate(sec.date),
            headerHeight: widget.headerHeight,
            headerBuilder: widget.headerBuilder,
          ),
        ),
        // 图片网格（懒加载）
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverGrid(
            gridDelegate:
                widget.gridDelegate ??
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
            delegate: SliverChildBuilderDelegate(
              (ctx, idx) => widget.itemBuilder(ctx, sec.items[idx]),
              childCount: sec.items.length,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) =>
      "${dt.year} - ${dt.month.toString().padLeft(2, "0")} - ${dt.day.toString().padLeft(2, "0")}";

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }
}

/// 内部数据封装
class _Section {
  final DateTime date;
  final List<ImageItem> items;
  _Section(this.date, this.items);
}

/// 简单的 header delegate
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double headerHeight;
  final Widget Function(BuildContext context, String title) headerBuilder;
  const _HeaderDelegate({
    required this.title,
    required this.headerHeight,
    required this.headerBuilder,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return headerBuilder(context, title);
  }

  @override
  double get maxExtent => headerHeight;
  @override
  double get minExtent => headerHeight;
  @override
  bool shouldRebuild(covariant _HeaderDelegate old) => true;
}
