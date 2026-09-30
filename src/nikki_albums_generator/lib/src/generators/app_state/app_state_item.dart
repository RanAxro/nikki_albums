/// 单个状态项在生成代码时需要用到的信息。
class AppStateItemInfo {
  /// 状态项变量在源码中的位置，用于保持生成顺序与声明顺序一致。
  final int offset;

  /// 状态项变量名，例如 `_lang`。
  final String fieldName;

  /// 生成的状态类名，例如 `LangState`。
  final String stateClass;

  /// 生成的 Provider 名，例如 `_langProvider`。
  final String providerName;

  /// 聚合类中的字段名，例如 `lang`。
  final String fieldInAggregate;

  /// 状态值的类型，例如 `Locale`。
  final String valueType;

  /// 持久化数据的类型，例如 `Persistent`。
  final String persistentType;

  /// 注解里填写的描述。
  final String? description;

  const AppStateItemInfo({
    required this.offset,
    required this.fieldName,
    required this.stateClass,
    required this.providerName,
    required this.fieldInAggregate,
    required this.valueType,
    required this.persistentType,
    required this.description,
  });
}
