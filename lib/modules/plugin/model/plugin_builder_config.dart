import "package:nikki_albums/src/rust/serde_config/structs/plugin_info.dart";
import "package:nikki_albums/src/rust/serde_config/structs/game_config.dart";

class PluginBuilderConfig {
  final PluginInfo info;
  final Map<String, dynamic> languageList;
  final List<String> iconList;
  final List<GameConfig> gameConfigList;
  final List themeList;

  const PluginBuilderConfig({
    required this.info,
    this.languageList = const {},
    this.iconList = const [],
    this.gameConfigList = const [],
    this.themeList = const [],
  });
}
