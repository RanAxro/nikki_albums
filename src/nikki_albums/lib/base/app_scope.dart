
import "package:nikki_albums/base/app_configuration.dart";
import "package:nikki_albums/base/app_router.dart";
import "package:nikki_albums/base/app_state.dart";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:easy_localization/easy_localization.dart";
import "package:forui/forui.dart";



class AppScope extends StatelessWidget{
  final AppConfiguration configuration;
  // final Widget child;
  final Future<void> Function()? onInit;

  const AppScope({
    super.key,
    required this.configuration,
    // required this.child,
    this.onInit,
  });

  @override
  Widget build(BuildContext context){
    return ProviderScope(
      child: AppLocalizationScope(
        configuration: configuration,
        child: AppThemeScope(
          configuration: configuration,
          // child: child,
        ),
      ),
    );
  }
}


class AppLocalizationScope extends ConsumerStatefulWidget{
  final AppConfiguration configuration;
  final Widget child;
  
  const AppLocalizationScope({
    super.key,
    required this.configuration,
    required this.child,
  });

  @override
  ConsumerState<AppLocalizationScope> createState() => _AppLocalizationScopeState();
}
class _AppLocalizationScopeState extends ConsumerState<AppLocalizationScope>{
  AppLocalizationConfiguration get cfg => widget.configuration.localization;

  @override
  void initState(){
    super.initState();
    final Locale loadLocale = ref.read(appStateProvider).lang;
    final Locale locale = cfg.onLoad(loadLocale);
    context.setLocale(locale);
  }
  
  @override
  Widget build(BuildContext context){
    ref.listen(appStateProvider.select((AppState state) => state.lang), (Locale? prev, Locale next){
      final Locale locale = cfg.onChange(prev, next);
      context.setLocale(locale);
    });

    return EasyLocalization(
      supportedLocales: cfg.supportedLocales,
      path: cfg.path,
      // startLocale: Locale("en", "US"),
      fallbackLocale: cfg.fallbackLocale,
      useFallbackTranslations: true,
      useFallbackTranslationsForEmptyResources: true,
      saveLocale: false,
      assetLoader: cfg.assetLoader,
      child: widget.child,
    );
  }
}


class AppThemeScope extends ConsumerWidget{
  final AppConfiguration configuration;
  // final Widget child;

  const AppThemeScope({
    super.key,
    required this.configuration,
    // required this.child,
  });

  FPlatformVariant get platform{
    return switch (defaultTargetPlatform){
      TargetPlatform.android || TargetPlatform.iOS || TargetPlatform.fuchsia => FPlatformVariantConstraint.touch,
      _ => FPlatformVariantConstraint.desktop,
    };
  }

  FThemeData get theme{
    final brightness = FTheme.neutral.light;
    return platform.desktop ? brightness.desktop : brightness.touch;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme.toApproximateMaterialTheme(),
      // darkTheme: _darkTheme.toApproximateMaterialTheme(),
      themeMode: ThemeMode.system,

      localizationsDelegates: [
        // easy_localization
        ...context.localizationDelegates,
        // forui
        ...FLocalizations.localizationsDelegates,
      ],
      supportedLocales: context.supportedLocales,
      builder: (BuildContext context, Widget? child) => FTheme(
        data: theme,
        platform: platform,
        child: FToaster(child: child!),
      ),
      routerConfig: appRouter,
    );

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: theme.toApproximateMaterialTheme(),
    //   // darkTheme: _darkTheme.toApproximateMaterialTheme(),
    //   themeMode: ThemeMode.system,
    //
    //   localizationsDelegates: [
    //     // easy_localization
    //     ...context.localizationDelegates,
    //     // forui
    //     ...FLocalizations.localizationsDelegates,
    //   ],
    //   supportedLocales: context.supportedLocales,
    //   builder: (BuildContext context, Widget? child) => FTheme(
    //     data: theme,
    //     platform: platform,
    //     child: FToaster(child: child!),
    //   ),
    //   home: child,
    // );
  }
}


