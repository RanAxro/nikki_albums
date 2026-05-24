import "package:nikki_albums/src/rust/serde_config/structs/common.dart";
import "package:nikki_albums/src/rust/serde_config/structs/plugin_info.dart";


class InternalPluginBuilderConfig{
  final PluginInfo info;
  final Map<String, dynamic> languageList;
  final List<String> iconList;
  final List gameConfigList;
  final List themeList;

  const InternalPluginBuilderConfig({
    required this.info,
    this.languageList = const {},
    this.iconList = const [],
    this.gameConfigList = const [],
    this.themeList = const [],
  });
}