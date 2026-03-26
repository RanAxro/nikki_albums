

import "../data/info.dart";
import "uid.dart";

import "package:flutter/material.dart";

abstract class Game extends ChangeNotifier{
  Map<String, dynamic> toJson();

  final String installPath;

  Game({
    required this.installPath,
  });


  String get logoAssetName;

  AssetImage get logoImage;

  String get name;

  // GameShortcut? get shortcut;


  Uid? _selectedUid;
}