

import "package:nikkialbums/modules/album/domain/album_controller.dart";
import "package:nikkialbums/modules/frame/frame.dart";
import "package:nikkialbums/widgets/app/component.dart";
import "package:nikkialbums/widgets/common/component.dart";

import "package:flutter/material.dart";

final ContentItem item = ContentItem(
  name: "creation",
  icon: AppIcon("creation", height: mediumButtonContentSize),
  page: const Creation(),
);






class Creation extends StatefulWidget{
  const Creation({super.key});

  @override
  State<StatefulWidget> createState() => _CreationState();
}
class _CreationState extends State<Creation>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: [

      ],
    );
  }
}


class ToolBar extends StatelessWidget{
  final AlbumController controller;

  const ToolBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context){
    return block0;
  }
}















