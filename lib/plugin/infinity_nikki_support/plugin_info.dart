import "package:nikki_albums/src/rust/serde_config/structs/common.dart";
import "package:nikki_albums/src/rust/serde_config/structs/plugin_info.dart";

const PluginInfo pluginConfig = PluginInfo(
  uuid: "05d5e067-ac1a-44c2-9f87-5ccaae613954",
  name: Text.translate(TranslateText(key: "infinity_nikki_support_name")),
  description: Text.translate(TranslateText(key: "infinity_nikki_support_description")),
  icon: "infinity_nikki.webp",
  version: 1,
  author: "Nikki Albums",
  web: r"nikki.ranaxro.com",
  downloadUrl: "",
  pluginList: null,
  appVersion: 0,
  platforms: Platform.values,
);