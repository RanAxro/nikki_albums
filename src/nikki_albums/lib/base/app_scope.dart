
import "app_localization_asset_loader.dart";
import "app_configuration.dart";
import "app_router.dart";
import "app_state.dart";
import "package:nikki_albums/gen/rust/config/app_persistent_state.dart";
import "package:nikki_albums/utils/extension.dart";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:forui/forui.dart";
import "package:easy_localization/easy_localization.dart";
import 'package:easy_localization/src/localization.dart';


class AppScope extends StatelessWidget{
  final AppPersistentState? initAppPersistentState;
  final void Function(AppPersistentState)? onAppPersistentStateChange;
  final AppConfiguration configuration;
  final Future<void> Function()? onInit;

  const AppScope({
    super.key,
    required this.initAppPersistentState,
    required this.onAppPersistentStateChange,
    required this.configuration,
    this.onInit,
  });

  @override
  Widget build(BuildContext context){
    return ProviderScope(
      child: AppStateScope(
        initAppPersistentState: initAppPersistentState,
        onAppPersistentStateChange: onAppPersistentStateChange,
        configuration: configuration,
        child: AppLocalizationScope(
          configuration: configuration,
          child: AppThemeScope(
            configuration: configuration,
          ),
        ),
      ),
    );
  }
}


class AppStateScope extends StatefulHookConsumerWidget{
  final AppPersistentState? initAppPersistentState;
  final void Function(AppPersistentState)? onAppPersistentStateChange;
  final AppConfiguration configuration;
  final Widget child;

  const AppStateScope({
    super.key,
    this.initAppPersistentState,
    this.onAppPersistentStateChange,
    required this.configuration,
    required this.child,
  });

  @override
  ConsumerState<AppStateScope> createState() => _AppStateScopeState();
}
class _AppStateScopeState extends ConsumerState<AppStateScope>{
  AppLocalizationConfiguration get cfg => widget.configuration.localization;

  @override
  void initState(){
    super.initState();
    widget.initAppPersistentState.let((AppPersistentState initAppPersistentState){
      ref.read(appStateProvider.notifier).loadFromPersistent(initAppPersistentState);
    });
  }

  @override
  Widget build(BuildContext context){
    final AppState appState = ref.watch(appStateProvider);
    final AppState? debounced = useDebounced(appState, const Duration(milliseconds: 200));

    useEffect((){
      if(debounced != null && widget.onAppPersistentStateChange != null){
        final AppPersistentState p = AppPersistentState(unknownField: {});
        final AppPersistentState res = ref.read(appStateProvider.notifier).saveToPersistent(p);
        widget.onAppPersistentStateChange?.call(res);
      }
      return null;
    }, [debounced]);

    return widget.child;
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

  Future<void> reloadTranslations(BuildContext context) async{
    final Locale locale = context.locale;
    final controller = EasyLocalization.of(context)!.delegate.localizationController!;

    await controller.setLocale(locale);

    Localization.load(
      context.mounted ? context.locale : locale,
      translations: controller.translations,
      fallbackTranslations: controller.fallbackTranslations,
    );
  }
  
  @override
  Widget build(BuildContext context){
    final Locale loadLocale = ref.read(appStateProvider).lang;
    final Locale locale = cfg.onLoad(loadLocale);

    return EasyLocalization(
      supportedLocales: cfg.supportedLocales,
      path: cfg.path,
      startLocale: locale,
      fallbackLocale: cfg.fallbackLocale,
      useFallbackTranslations: true,
      useFallbackTranslationsForEmptyResources: true,
      saveLocale: false,
      assetLoader: AppLocalizationAssetLoader(),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child){
          ref.listen(appStateProvider.select((AppState state) => state.lang), (Locale? prev, Locale next){
            final Locale locale = cfg.onChange(prev, next);
            context.setLocale(locale);
          });

          ref.listen(appStateProvider.select((AppState state) => state.registerLoc), (_, next){
            AppLocalizationAssetLoader.pluginRegisterLoc = next;
            reloadTranslations(context);
          });
          ref.listen(appStateProvider.select((AppState state) => state.registerGlobalLoc), (_, next){
            AppLocalizationAssetLoader.pluginRegisterGlobalLoc = next;
            reloadTranslations(context);
          });

          return child!;
        },
        child: widget.child,
      ),
    );
  }
}


class AppThemeScope extends ConsumerWidget{
  final AppConfiguration configuration;

  const AppThemeScope({
    super.key,
    required this.configuration,
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

      locale: context.locale,
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
  }
}


