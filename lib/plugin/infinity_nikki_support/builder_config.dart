import "plugin_info.dart";
import "lang/zh-CN.dart";
import "lang/en-US.dart";
import "icon.dart";
import "game_config.dart";
import "package:nikki_albums/modules/plugin/model/plugin_builder_config.dart";

const PluginBuilderConfig builderConfig = PluginBuilderConfig(
  info: pluginConfig,
  languageList: {
    "zh-CN": zhCN,
    "en-US": enUS,
  },
  iconList: iconList,
  gameConfigList: [infinityNikkiConfig],
);