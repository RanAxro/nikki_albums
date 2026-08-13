
import "package:flutter/widgets.dart";


mixin Display{
  ImageProvider? get picture => null;
  String get name;
  bool get isTranslate => true;
}

abstract class Game with Display{
  const Game();

  GameOptionConfig? get optionConfig;

  Future<List<GameSession>> getSessions();

  List<GameSession> getCustomSessions();

  bool get allowCustom => false;

  GameSession? addCustom(BuildContext context) => null;
}

abstract class GameSession with Display{
  const GameSession();

  GameOption? get option => null;

  Future<ImageProvider?> getPicture() => Future.value(null);

  Future<List<GameOption>> getOptions() => Future.value(<GameOption>[]);
}

class GameOptionConfig<T extends GameSession>{
  final bool mustBeSelected;
  final GameOptionConfig? Function(T)? onAdd;
  final GameOptionConfig? childConfig;

  const GameOptionConfig({
    this.mustBeSelected = false,
    this.onAdd,
    this.childConfig,
  });
}

abstract class GameOption<T extends GameSession> with Display{
  const GameOption();

  GameOption? get child => null;

  Future<ImageProvider?> getPicture(T session) => Future.value(null);

  Future<List<GameOption>> getOptions(T session) => Future.value(const <GameOption>[]);
}






