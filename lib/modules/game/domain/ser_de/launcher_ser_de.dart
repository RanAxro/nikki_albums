part of "../../lib/launcher.dart";


abstract class GameLauncherSerDe{
  static Map<String, dynamic>? serialize(GameLauncher? source){
    if(source == null) return null;

    return switch(source.platform){
      Platform.windows => WindowsGameLauncherSerDe.serialize(source as WindowsGameLauncher),
      Platform.android => AndroidGameLauncherSerDe.serialize(source as AndroidGameLauncher),
      _ => null,
    };
  }

  static GameLauncher? deserialize(dynamic source){
    if(source is! Map) return null;

    if(source case {
      "platform": int platformBit,
    }){
      return switch(Platform(platformBit)){
        Platform.windows => WindowsGameLauncherSerDe.deserialize(source),
        Platform.android => AndroidGameLauncherSerDe.deserialize(source),
        _ => null,
      };
    }

    return null;
  }
}


abstract class WindowsGameLauncherSerDe{
  static Map<String, dynamic>? serialize(WindowsGameLauncher? source){
    if(source == null) return null;

    return {
      "platform": source.platform.bit,
      "channel": source.channel.to(),
      "path": source.path,
    };
  }

  static WindowsGameLauncher? deserialize(dynamic source){
    if(source is! Map) return null;

    if(source case {
      "platform": int platformBit,
      "channel": String channel,
      "path": String path,
    }){
      if(Platform(platformBit) != Platform.windows){
        return null;
      }

      return WindowsGameLauncher(channel: LauncherChannel.from(channel), path: path);
    }

    return null;
  }
}


abstract class AndroidGameLauncherSerDe{
  static Map<String, dynamic>? serialize(AndroidGameLauncher? source){
    if(source == null) return null;

    return {
      "platform": source.platform.bit,
      "channel": source.channel.to(),
      "packageName": source.packageName,
    };
  }

  static AndroidGameLauncher? deserialize(dynamic source){
    if(source is! Map) return null;

    if(source case {
      "platform": int platformBit,
      "channel": String channel,
      "packageName": String packageName,
    }){
      if(Platform(platformBit) != Platform.android){
        return null;
      }

      return AndroidGameLauncher(channel: LauncherChannel.from(channel), packageName: packageName);
    }

    return null;
  }
}