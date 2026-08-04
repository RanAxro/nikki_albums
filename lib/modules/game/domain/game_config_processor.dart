
import "game_fs_proxy/game_fs_proxy.dart";
import "package:nikki_albums/modules/config/domain/common/common.dart";
import "package:nikki_albums/src/rust/config/game_config.dart";


abstract final class GameConfigProcessor{
  static Future<List<GameInitializer>> searchWindowsGame(GameConfig config) async{
    final List<GameInitializer> res = [];

    if(config.windows == null){
      return res;
    }

    final Set<String> finishedChannel = {};
    for(final WindowsGameLocationConfig locationConfig in config.windows!.locate){
      if(finishedChannel.contains(locationConfig.channelId)){
        continue;
      }

      String? launcherPath;
      String? installPath;
      for(final WindowsGameSearcherConfig searcherConfig in locationConfig.searcher){
        switch(searcherConfig){
          case WindowsGameSearcherConfig_Registry(field0: final registrySearcherConfig):
            if(registrySearcherConfig.toLauncher == null && locationConfig.requireLauncher){
              break;
            }

            if(registrySearcherConfig.toLauncher != null){
              launcherPath = _readRegistryString(registrySearcherConfig.toLauncher!) ?? launcherPath;
            }
            installPath = _readRegistryString(registrySearcherConfig.toInstall) ?? installPath;
            break;
          case WindowsGameSearcherConfig_ConfigFile(field0: final configFileSearcherConfig):
            if(configFileSearcherConfig.toLauncher == null && locationConfig.requireLauncher){
              break;
            }

            const String launcherToken = "l", installToken = "i";
            final Map<String, dynamic>? configResult = await FileReaderConfigProcessor.withConfig(FileReaderConfig(
              path: configFileSearcherConfig.path,
              fileType: configFileSearcherConfig.configType,
              keys: {
                launcherToken: ?configFileSearcherConfig.toLauncher?.key,
                installToken: configFileSearcherConfig.toInstall.key,
              },
            ));

            if(configFileSearcherConfig.toLauncher != null){
              launcherPath = configResult?[launcherToken] ?? configFileSearcherConfig.toLauncher?.failed ?? launcherPath;
            }
            installPath = configResult?[installToken] ?? configFileSearcherConfig.toInstall.failed ?? installPath;
            break;
        }

        if(launcherPath != null && installPath != null){
          finishedChannel.add(locationConfig.channelId);
          res.add(GameInitializer(
            config: config,
            channelId: locationConfig.channelId,
            launcherPath: launcherPath,
            installPath: installPath,
          ));
          break;
        }
      }

      // 等价条件 > (launcherPath == null && !locationConfig.requireLauncher || launcherPath != null) && installPath != null
      if(!locationConfig.requireLauncher && installPath != null){
        finishedChannel.add(locationConfig.channelId);
        res.add(GameInitializer(
          config: config,
          channelId: locationConfig.channelId,
          installPath: installPath,
        ));
      }
    }

    return res;
  }

  static String? _readRegistryString(WindowsGameRegistryLocationConfig config){
    // 读注册表
    final String? value = WindowsRegistryConfigProcessor.withConfigAsString(config.registry);
    if(value == null){
      return config.failed;
    }

    return StringConfigProcessor.withConfig(config.output, value);
  }
}


class GameInitializer{
  final GameConfig config;
  final String channelId;
  final String? launcherPath;
  final String installPath;

  const GameInitializer({
    required this.config,
    required this.channelId,
    this.launcherPath,
    required this.installPath,
  });
}


class Game{
  final GameConfig config;
  final String channelId;
  final GameFSProxy? launcherProxy;
  final GameFSProxy installProxy;

  const Game({
    required this.config,
    required this.channelId,
    this.launcherProxy,
    required this.installProxy,
  });
}


