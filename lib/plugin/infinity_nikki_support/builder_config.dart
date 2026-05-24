import "plugin_info.dart";
import "language.dart";
import "icon.dart";
import "game_config.dart";
import "package:nikki_albums/modules/plugin/model/internal_plugin_builder_config.dart";

const InternalPluginBuilderConfig builderConfig = InternalPluginBuilderConfig(
  info: pluginConfig,
  languageList: languageList,
  iconList: iconList,
  gameConfigList: [infinityNikkiConfig],
);