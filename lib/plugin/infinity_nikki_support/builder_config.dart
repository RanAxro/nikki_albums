import "plugin_info.dart";
import "language.dart";
import "icon.dart";
import "game_config.dart";
import "package:nikki_albums/modules/plugin/model/plugin_builder_config.dart";

const PluginBuilderConfig builderConfig = PluginBuilderConfig(
  info: pluginConfig,
  languageList: languageList,
  iconList: iconList,
  gameConfigList: [infinityNikkiConfig],
);