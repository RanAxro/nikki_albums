import "../model/launcher_channel.dart";
import "package:nikki_albums/modules/app_base/model/platform.dart";

abstract class InfinityNikkiLauncher{
  final LauncherChannel channel;

  const InfinityNikkiLauncher({
    required this.channel,
  });

  String get path;

  Platform get platform;

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is InfinityNikkiLauncher && runtimeType == other.runtimeType &&
      channel == other.channel;

  @override
  int get hashCode => channel.hashCode;

  @override
  String toString() => "GameLauncher -> $channel";
}

class InfinityNikkiWindowsLauncher extends InfinityNikkiLauncher{
  @override
  final String path;

  const InfinityNikkiWindowsLauncher({
    required super.channel,
    required this.path,
  });

  @override
  Platform get platform => Platform.windows;

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is InfinityNikkiWindowsLauncher && runtimeType == other.runtimeType &&
      channel == other.channel &&
      path == other.path;

  @override
  int get hashCode => Object.hash(channel, path);

  @override
  String toString() => "WindowsGameLauncher -> channel: $channel, path: $path";
}

class InfinityNikkiAndroidLauncher extends InfinityNikkiLauncher{
  final String packageName;

  const InfinityNikkiAndroidLauncher({
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
    identical(this, other) || other is InfinityNikkiAndroidLauncher && runtimeType == other.runtimeType &&
      channel == other.channel &&
      packageName == other.packageName;

  @override
  int get hashCode => Object.hash(channel, packageName);

  @override
  String toString() => "AndroidGameLauncher -> channel: $channel, packageName: $packageName";
}