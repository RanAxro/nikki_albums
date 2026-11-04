// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_manager_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pluginManager)
final pluginManagerProvider = PluginManagerProvider._();

final class PluginManagerProvider
    extends $FunctionalProvider<PluginManager, PluginManager, PluginManager>
    with $Provider<PluginManager> {
  PluginManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pluginManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pluginManagerHash();

  @$internal
  @override
  $ProviderElement<PluginManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PluginManager create(Ref ref) {
    return pluginManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PluginManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PluginManager>(value),
    );
  }
}

String _$pluginManagerHash() => r'327fcaae2399f43795218c750c505528c091d416';

@ProviderFor(PluginState)
final pluginStateProvider = PluginStateProvider._();

final class PluginStateProvider
    extends $NotifierProvider<PluginState, Map<Plugin, bool>> {
  PluginStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pluginStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pluginStateHash();

  @$internal
  @override
  PluginState create() => PluginState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<Plugin, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<Plugin, bool>>(value),
    );
  }
}

String _$pluginStateHash() => r'c31ecb9cfd066d92843d9a363e4b38923c5fc476';

abstract class _$PluginState extends $Notifier<Map<Plugin, bool>> {
  Map<Plugin, bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<Plugin, bool>, Map<Plugin, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<Plugin, bool>, Map<Plugin, bool>>,
              Map<Plugin, bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PluginRegisteredIcon)
final pluginRegisteredIconProvider = PluginRegisteredIconProvider._();

final class PluginRegisteredIconProvider
    extends $NotifierProvider<PluginRegisteredIcon, Map<String, dynamic>> {
  PluginRegisteredIconProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pluginRegisteredIconProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pluginRegisteredIconHash();

  @$internal
  @override
  PluginRegisteredIcon create() => PluginRegisteredIcon();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$pluginRegisteredIconHash() =>
    r'69f0d98ab0fdf4955c173183a69d8ac9bc50a488';

abstract class _$PluginRegisteredIcon extends $Notifier<Map<String, dynamic>> {
  Map<String, dynamic> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, dynamic>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, dynamic>, Map<String, dynamic>>,
              Map<String, dynamic>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PluginRegisteredGame)
final pluginRegisteredGameProvider = PluginRegisteredGameProvider._();

final class PluginRegisteredGameProvider
    extends $NotifierProvider<PluginRegisteredGame, List<String>> {
  PluginRegisteredGameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pluginRegisteredGameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pluginRegisteredGameHash();

  @$internal
  @override
  PluginRegisteredGame create() => PluginRegisteredGame();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$pluginRegisteredGameHash() =>
    r'2e8ff6631d79213072a87b2afb2daee58b46d927';

abstract class _$PluginRegisteredGame extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
