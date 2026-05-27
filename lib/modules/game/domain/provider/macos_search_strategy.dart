import 'dart:io';
import 'package:path/path.dart' as p;

import '../../model/launcher_channel.dart';
import '../../model/infinity_nikki_info.dart';
import 'package:nikki_albums/modules/game/lib/launcher.dart';
import 'package:nikki_albums/modules/game/lib/game.dart';
import 'game_search_strategy.dart';

class MacOsSearchStrategy implements GameSearchStrategy {
  @override
  Future<List<Game>> find(Set<LauncherChannel> finished) async {
    final List<Game> gameList = <Game>[];
    final String? home = Platform.environment['HOME'];
    if (home == null) return gameList;

    // Check containers
    final containerPath = p.join(home, 'Library', 'Containers');
    final containerDir = Directory(containerPath);
    if (!await containerDir.exists()) return gameList;

    final List<FileSystemEntity> entities = await containerDir.list().toList();

    for(final InfinityNikkiInfo info in infinityNikkiInfos) {
      if(finished.contains(info.channel)) continue;

      for (final FileSystemEntity entity in entities) {
        if (entity is Directory) {
          final dirName = p.basename(entity.path);
          if (dirName.startsWith('com.infoldgames.infinitynikki')) {
            final installPath = p.join(entity.path, 'Data', 'Library', 'Application Support', 'Epic');
            final installDir = Directory(installPath);
            
            if (await installDir.exists()) {
              final x6GameDir = Directory(p.join(installPath, 'X6Game'));
              if (await x6GameDir.exists()) {
                finished.add(info.channel);
                gameList.add(Game(
                  // Launcher doesn't really apply in the same way, but we can provide a dummy or point to the app bundle
                  launcher: MacOsGameLauncher(
                    channel: info.channel,
                    path: entity.path,
                  ),
                  installPath: installPath,
                ));
              }
            }
          }
        }
      }
    }

    return gameList;
  }
}

class MacOsGameLauncher extends Launcher {
  MacOsGameLauncher({
    required super.channel,
    required super.path,
  });

  @override
  Future<void> run() async {
    // Basic implementation to launch the app bundle if needed
    Process.run('open', [path]);
  }
}
