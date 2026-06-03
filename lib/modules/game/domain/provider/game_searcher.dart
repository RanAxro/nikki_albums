import 'dart:io';
import '../../model/launcher_channel.dart';
import 'package:nikki_albums/modules/game/lib/game.dart';
import 'windows_search_strategy.dart';
import 'macos_search_strategy.dart';

abstract class GameSearcher {
  static Future<List<Game>> findByInfoInWindows() async {
    final strategy = WindowsSearchStrategy();
    final Set<LauncherChannel> finished = <LauncherChannel>{};
    return await strategy.find(finished);
  }

  static Future<List<Game>> findByInfoInMacOS() async {
    final strategy = MacOsSearchStrategy();
    final Set<LauncherChannel> finished = <LauncherChannel>{};
    return await strategy.find(finished);
  }

  static Future<List<Game>> find() async {
    if (Platform.isWindows) {
      return await findByInfoInWindows();
    } else if (Platform.isMacOS) {
      return await findByInfoInMacOS();
    }
    // Add other platforms if needed
    return [];
  }
}
