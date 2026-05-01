part of "../../lib/game.dart";

abstract class GameSerDe{
  static Map<String, dynamic>? serialize(Game? source){
    if(source == null) return null;

    return {
      "name": source.name,
      "launcher": GameLauncherSerDe.serialize(source.launcher),
      "installPath": source.installPath,
    };
  }

  Game? deserialize(dynamic source){
    if(source is! Map) return null;

    if(source case {
      "name": String? name,
      "launcher": Map? launcher,
      "installPath": String installPath,
    }){
      return Game(
        name: name,
        launcher: GameLauncherSerDe.deserialize(launcher),
        installPath: installPath,
      );
    }

    return null;
  }
}