class AppStateDefine{
  final String? description;
  final String? rename;

  const AppStateDefine(
    this.description, {
    this.rename,
  });
}

/// 单个应用状态项的定义，描述状态项的类型、默认值以及持久化读写方式。
///
/// 类型参数 [T] 是状态值的类型，[P] 是持久化存储中使用的类型。
class AppStateItemDefine<T, P>{
  /// 状态的默认值，当持久化中没有存储值时使用。
  final T defaultValue;

  /// 从持久化数据 [P] 读取并转换为状态值 [T]。
  ///
  /// 第一个参数是当前的默认值，第二个参数是持久化中读出的原始数据。
  /// 返回转换后的状态值；为 `null` 表示该状态项不支持持久化读取。
  final T Function(T, P)? readPersistent;

  /// 将状态值 [T] 转换为持久化数据 [P] 以便写入存储。
  ///
  /// 第一个参数是新的状态值，第二个参数是当前持久化中的原始数据。
  /// 返回写入存储的数据；为 `null` 表示该状态项不支持持久化写入。
  final P Function(T, P)? writePersistent;

  /// 创建状态项定义。
  ///
  /// - [defaultValue] 状态默认值，必须提供
  /// - [readPersistent] 持久化读取函数，可选
  /// - [writePersistent] 持久化写入函数，可选
  const AppStateItemDefine({
    required this.defaultValue,
    this.readPersistent,
    this.writePersistent,
  });
}
