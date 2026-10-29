
import "package:nikki_albums/base/app_configuration.dart";
import "modules/app_base/domain/lang_asset_loader.dart";

import "dart:ui";


const AppConfiguration configuration = AppConfiguration(
  localization: AppLocalizationConfiguration(
    supportedLocales: [
      Locale("zh", "CN"),
      Locale("en", "US"),
      Locale("fr", "FR"),
      Locale("de", "DE"),
      Locale("id", "ID"),
      Locale("it", "IT"),
      Locale("ja", "JP"),
      Locale("ko", "KR"),
      Locale("pt", "BR"),
      Locale("es", "ES"),
      Locale("th", "TH"),
      Locale("zh", "TW"),
    ],
    path: "assets/lang",
    fallbackLocale: Locale("en", "US"),
    assetLoader: AppLangAssetLoader(),
  ),
);