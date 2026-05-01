part of "../lib/game.dart";

class Game{
  final String? name;
  final GameLauncher? launcher;
  final String installPath;

  const Game({
    this.name,
    this.launcher,
    required this.installPath,
  });

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is Game && runtimeType == other.runtimeType &&
      name == other.name &&
      launcher == other.launcher &&
      installPath == other.installPath;

  @override
  int get hashCode => Object.hash(name, launcher, installPath);

  @override
  String toString() => "Game -> name: $name, path: $installPath";
}