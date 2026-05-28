import '../../model/launcher_channel.dart';
import '../../model/infinity_nikki_info.dart';
import 'package:nikki_albums/modules/game/lib/game.dart';

abstract class GameSearchStrategy {
  Future<List<Game>> find(Set<LauncherChannel> finished);
}
