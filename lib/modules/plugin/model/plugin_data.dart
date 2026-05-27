
import "package:nikki_albums/src/rust/serde_config/structs/plugin_info.dart";
import "package:nikki_albums/src/rust/serde_config/structs/game_config.dart";

class PluginData{
  final bool enable;
  final PluginInfo info;
  final Map<String, String> langPathList;
  final Map<String, String> iconPathList;
  final List<GameConfig> gameConfigList;
  final List themeList;

  const PluginData({
    required this.enable,
    required this.info,
    required this.langPathList,
    required this.iconPathList,
    required this.gameConfigList,
    required this.themeList,
  });
}