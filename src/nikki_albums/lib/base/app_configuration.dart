
import "dart:ui";

import "package:easy_localization/easy_localization.dart";


class AppConfiguration{
  final AppLocalizationConfiguration localization;

  const AppConfiguration({
    required this.localization,
  });
}

class AppLocalizationConfiguration{
  final List<Locale> supportedLocales;
  final String path;
  final Locale? fallbackLocale;
  final AssetLoader assetLoader;
  final Locale Function(Locale locale) onLoad;
  final Locale Function(Locale? prev, Locale next) onChange;

  const AppLocalizationConfiguration({
    required this.supportedLocales,
    required this.path,
    this.fallbackLocale,
    this.assetLoader = const RootBundleAssetLoader(),
    this.onLoad = _defaultLocalizationOnLoad,
    this.onChange = _defaultLocalizationOnChange,
  });
}

Locale _defaultLocalizationOnLoad(Locale locale){
  return locale;
}

Locale _defaultLocalizationOnChange(Locale? prev, Locale next){
  return next;
}