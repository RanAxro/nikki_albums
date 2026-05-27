import 'dart:io' as io;
import 'package:path/path.dart' as p;

import '../../model/launcher_channel.dart';
import 'package:nikki_albums/modules/game/lib/launcher.dart';
import 'package:nikki_albums/modules/game/lib/game.dart';
import 'package:nikki_albums/utils/common/platform.dart' as app_platform;
import 'game_search_strategy.dart';

class MacOsSearchStrategy implements GameSearchStrategy {
  @override
  Future<List<Game>> find(Set<LauncherChannel> finished) async {
    final List<Game> gameList = <Game>[];
    final String? home = io.Platform.environment['HOME'];
    if (home == null) return gameList;

    final containerPath = p.join(home, 'Library', 'Containers');
    final containerDir = io.Directory(containerPath);
    if (!await containerDir.exists()) return gameList;

    final List<io.FileSystemEntity> entities = await containerDir.list().toList();

    for (final io.FileSystemEntity entity in entities) {
      if (entity is! io.Directory) continue;
      final dirName = p.basename(entity.path);
      // Match com.infoldgames.infinitynikki with optional language suffix (e.g. "en", "jp", etc.)
      if (!dirName.startsWith('com.infoldgames.infinitynikki')) continue;

      final installPath = p.join(entity.path, 'Data', 'Library', 'Application Support', 'Epic');
      final x6GameDir = io.Directory(p.join(installPath, 'X6Game'));
      if (!await x6GameDir.exists()) continue;

      // On macOS, use 'paper' channel for all variants since the module's
      // LauncherChannel enum doesn't distinguish global vs CN
      final channel = LauncherChannel.paper;

      if (finished.contains(channel)) continue;
      finished.add(channel);

      gameList.add(Game(
        launcher: MacOsGameLauncher(
          channel: channel,
          path: entity.path,
        ),
        installPath: installPath,
      ));
    }

    return gameList;
  }
}

class MacOsGameLauncher extends GameLauncher {
  @override
  final String path;

  const MacOsGameLauncher({
    required super.channel,
    required this.path,
  });

  @override
  app_platform.Platform get platform => app_platform.Platform.macOs;
}
