import "package:nikki_albums/modules/game/lib/game.dart";
import "../model/album_type.dart";

class GameSession {
  final Game game;

  GameSession(this.game);

  AlbumType type = AlbumType.ScreenShot;
}
