// import "package:nikkialbums/state.dart";
// import "package:nikkialbums/info.dart";
// import "package:nikkialbums/api/path.dart";
//
// import "package:flutter/material.dart";
// import "dart:io";
//
// import "package:watcher/watcher.dart";
//
//
// class AlbumManager{
//   final Path installPath;
//
//   DirectoryWatcher installPathWatcher;
//
//   AlbumManager({
//     required this.installPath
//   }){
//     installPathWatcher = DirectoryWatcher(installPath.path, pollingDelay: const Duration(milliseconds: 500));
//
//     installPathWatcher.events.listen((WatchEvent event){
//       event;
//     });
//   }
// }