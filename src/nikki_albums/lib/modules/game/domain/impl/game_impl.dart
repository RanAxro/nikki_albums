
part of "../../lib/game.dart";


extension on Game{
  Future<List<Uid>> getUids() => UidSearcher.findByGame(this);
}