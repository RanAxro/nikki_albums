part of "../lib/launcher.dart";


abstract class GameLauncher{
  final LauncherChannel channel;

  const GameLauncher({
    required this.channel,
  });

  String get path;

  Platform get platform;

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is GameLauncher && runtimeType == other.runtimeType &&
      channel == other.channel;

  @override
  int get hashCode => channel.hashCode;

  @override
  String toString() => "GameLauncher -> $channel";
}

class WindowsGameLauncher extends GameLauncher{
  @override
  final String path;

  const WindowsGameLauncher({
    required super.channel,
    required this.path,
  });

  @override
  Platform get platform => Platform.windows;

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is WindowsGameLauncher && runtimeType == other.runtimeType &&
      channel == other.channel &&
      path == other.path;

  @override
  int get hashCode => Object.hash(channel, path);

  @override
  String toString() => "WindowsGameLauncher -> channel: $channel, path: $path";
}

class AndroidGameLauncher extends GameLauncher{
  final String packageName;

  const AndroidGameLauncher({
    required super.channel,
    required this.packageName,
  });

  @override
  // TODO: implement path
  String get path => throw UnimplementedError();

  @override
  Platform get platform => Platform.android;

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is AndroidGameLauncher && runtimeType == other.runtimeType &&
      channel == other.channel &&
      packageName == other.packageName;

  @override
  int get hashCode => Object.hash(channel, packageName);

  @override
  String toString() => "AndroidGameLauncher -> channel: $channel, packageName: $packageName";
}