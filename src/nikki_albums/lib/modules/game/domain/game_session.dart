
import "package:nikkialbums/modules/game/lib/game.dart";
import "package:nikkialbums/modules/game/lib/uid.dart";
import "../model/album_type.dart";

class GameSession{
  final Game game;

  GameSession(this.game);

  Uid? _uid;

  AlbumType type = AlbumType.ScreenShot;
}