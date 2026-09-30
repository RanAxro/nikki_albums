import 'package:build/build.dart';

/// [AppStateGenerator] 的配置项，可以通过 `build.yaml` 里的 `options` 覆盖。
///
/// ```yaml
/// targets:
///   $default:
///     builders:
///       nikki_albums_generator:app_state:
///         options:
///           aggregate_class: AppState
/// ```
class AppStateBuilderOptions {
  /// 默认配置。
  static const defaults = AppStateBuilderOptions();

  /// 状态类（`Notifier` 子类）的后缀，默认为 `State`。
  ///
  /// 状态项 `_lang` 会生成类 `LangState`。
  final String stateSuffix;

  /// 状态类对应 Provider 的后缀，默认为 `Provider`。
  ///
  /// 状态项 `_lang` 会生成 `_langProvider`。
  final String providerSuffix;

  /// 状态项基础类名，默认为 `AppStateItem`。
  final String baseClass;

  /// 状态项定义类名，默认为 `AppStateItemDefine`。
  final String itemDefineClass;

  /// 聚合所有状态项的数据类名，默认为 `AppState`。
  final String aggregateClass;

  /// 聚合状态的 `Notifier` 类名，默认为 `AppStateNotifier`。
  final String aggregateNotifierClass;

  /// 聚合状态的 Provider 名，默认为 `appStateProvider`。
  final String aggregateProvider;

  const AppStateBuilderOptions({
    this.stateSuffix = 'State',
    this.providerSuffix = 'Provider',
    this.baseClass = 'AppStateItem',
    this.itemDefineClass = 'AppStateItemDefine',
    this.aggregateClass = 'AppState',
    this.aggregateNotifierClass = 'AppStateNotifier',
    this.aggregateProvider = 'appStateProvider',
  });

  /// 从 `build.yaml` 中的 `options` 读取配置。
  factory AppStateBuilderOptions.fromBuilderOptions(BuilderOptions options) {
    final config = options.config;
    final unknownKeys = config.keys.toSet()
      ..removeAll(const {
        'state_suffix',
        'provider_suffix',
        'base_class',
        'item_define_class',
        'aggregate_class',
        'aggregate_notifier_class',
        'aggregate_provider',
      });
    if (unknownKeys.isNotEmpty) {
      log.warning('忽略未知的 AppState 生成配置：${unknownKeys.join(', ')}');
    }

    return AppStateBuilderOptions(
      stateSuffix: _readString(config, 'state_suffix') ?? defaults.stateSuffix,
      providerSuffix:
          _readString(config, 'provider_suffix') ?? defaults.providerSuffix,
      baseClass: _readString(config, 'base_class') ?? defaults.baseClass,
      itemDefineClass:
          _readString(config, 'item_define_class') ?? defaults.itemDefineClass,
      aggregateClass:
          _readString(config, 'aggregate_class') ?? defaults.aggregateClass,
      aggregateNotifierClass:
          _readString(config, 'aggregate_notifier_class') ??
          defaults.aggregateNotifierClass,
      aggregateProvider:
          _readString(config, 'aggregate_provider') ?? defaults.aggregateProvider,
    );
  }

  static String? _readString(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value == null) return null;
    if (value is! String) {
      log.warning('AppState 生成配置 $key 必须是字符串，当前值为 $value。');
      return null;
    }
    return value;
  }
}
