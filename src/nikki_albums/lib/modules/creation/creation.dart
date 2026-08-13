import "package:nikki_albums/modules/album/domain/album_controller.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

final ContentItem item = ContentItem(
  name: "creation",
  icon: AppIcon("creation", height: mediumButtonContentSize),
  page: const Creation(),
);

class Creation extends StatefulWidget {
  const Creation({super.key});

  @override
  State<StatefulWidget> createState() => _CreationState();
}

class _CreationState extends State<Creation> {
  @override
  Widget build(BuildContext context) {
    return Column(children: []);
  }
}

class ToolBar extends StatelessWidget {
  final AlbumController controller;

  const ToolBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return block0;
  }
}
