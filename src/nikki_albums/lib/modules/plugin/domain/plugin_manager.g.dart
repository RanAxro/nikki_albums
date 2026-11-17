// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_manager.dart';

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
