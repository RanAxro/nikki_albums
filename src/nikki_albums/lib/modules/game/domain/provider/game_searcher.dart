

import "../../model/launcher_channel.dart";
import "../../model/infinity_nikki_info.dart";
import "package:nikkialbums/modules/game/lib/launcher.dart";
import "package:nikkialbums/modules/game/lib/game.dart";
import "package:nikkialbums/modules/app_base/data/log.dart";
import "package:nikkialbums/utils/system/windows.dart";

import "dart:io";

import "package:path/path.dart" as p;
import "package:ini/ini.dart";
import "package:win32/win32.dart";
import "package:win32_registry/win32_registry.dart";


abstract class GameSearcher{
  static Future<List<Game>> findByInfoInWindows() async{
    final List<Game> gameList = <Game>[];
    final Set<LauncherChannel> finished = <LauncherChannel>{};

    for(final InfinityNikkiInfo info in infinityNikkiInfos){
      for(final WindowsRegistryInfo registryInfo in info.locateByWindowsRegistry){
        // 去重
        if(finished.contains(info.channel)) continue;

        // 读注册表
        late final String? value;
        try{
          final RegistryKey key = Registry.openPath(
            registryInfo.hive,
            path: registryInfo.path,
            desiredAccessRights: AccessRights.readOnly,
          );
          value = key.getStringValue(registryInfo.key);
          key.close();
        }on WindowsException catch(e){
          // 键值/路径不存在 ERROR_FILE_NOT_FOUND == 2
          if(e.hr == ERROR_FILE_NOT_FOUND){
            value = null;
          }else{
            AppLog.write("game.GameSearcher.findByInfoInWindows.@1", e.toString());
            value = null;
          }
        }catch(e){
          AppLog.write("game.GameSearcher.findByInfoInWindows.@2", e.toString());
        }

        // 读不到值则退出当前循环
        if(value == null) continue;

        // 找launcher路径
        final String launcherPath = p.join(value, registryInfo.locateToLauncher);
        // 判断launcher文件夹是否存在
        final Directory launcherDir = Directory(launcherPath);
        if(!(await launcherDir.exists())) continue;

        // 找install路径
        String installPath = p.join(launcherPath, registryInfo.locateToInstall);
        Directory installDir = Directory(installPath);
        bool isInstallExist = await installDir.exists();

        // 若找不到install文件玩则去 config.ini 找
        if(isInstallExist == false && registryInfo.configPath != null){
          // 获取用户名
          final String? username = await getWindowsUserName();
          if(username == null) continue;

          // 获取配置文件
          final String iniPath = registryInfo.configPath!.replaceAll(r"$username$", username);
          final File iniFile = File(iniPath);
          // 若配置文件不存在, 则退出当前循环
          if(!(await iniFile.exists())){
            continue;
          }

          // 读取配置文件的 Download.gameDir值
          // late final String iniText;
          // try{
          //   iniText = await iniFile.readAsString();
          // }catch(e){
          //   /// @ 2
          //   AppLog.write("game.Game.static.find.@2", e.toString());
          //   continue;
          // }


          late final List<String> iniLines;
          try{
            iniLines = await iniFile.readAsLines();
          }catch(e){
            AppLog.write("game.GameSearcher.findByInfoInWindows.@3", e.toString());
            continue;
          }
          final Config iniConfig = Config.fromStrings(iniLines);
          final String? installPathOrNull = iniConfig.get("Download", "gameDir");

          if(installPathOrNull != null){
            installPath = installPathOrNull;
            installDir = Directory(installPath);
            isInstallExist = await installDir.exists();
          }


          // // 解析ini
          // late final Map<String, Map<String, String>> jsonMap;
          // try {
          //   jsonMap = parseIni(iniText);
          // } catch (e) {
          //   /// @ 3
          //   AppLog.write("game.Game.static.find.@3", e.toString());
          //   continue;
          // }
          // if(jsonMap["Download"] is Map && jsonMap["Download"]!["gameDir"] is String){
          //   // 判断install是否存在
          //   installPath = jsonMap["Download"]!["gameDir"]!;
          //   installDir = Directory(installPath);
          //   isInstallExist = await installDir.exists();
          // }
        }

        // 成功获取到install路径
        if(isInstallExist){
          finished.add(info.channel);
          gameList.add(Game(
            launcher: WindowsGameLauncher(
              channel: info.channel,
              path: launcherPath,
            ),
            installPath: installPath,
          ));
        }
      }
    }

    return gameList;
  }

// static Future<List<Game>> findByInfoInAndroid() async{
//
// }
}