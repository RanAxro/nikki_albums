import 'app_state_item.dart';
import 'app_state_options.dart';

/// 把分析出来的状态项渲染成 Dart 代码。
///
/// 生成结果会写进源文件的 `part` 文件里，所以不需要 import 指令，
/// 可以直接使用源文件里已有的 `Notifier`、`Locale` 等符号。
class AppStateWriter {
  final AppStateBuilderOptions options;

  const AppStateWriter(this.options);

  String write(List<AppStateItemInfo> items) {
    final persistentType = items.first.persistentType;
    final buffer = StringBuffer()
      ..writeln('// 该文件由 nikki_albums_generator 根据 @AppStateDefine 注解生成，请勿手动修改。')
      ..writeln('//')
      ..writeln('// 重新生成：dart run build_runner build')
      ..writeln();

    _writeBaseClass(buffer);
    for (final item in items) {
      _writeItemClass(buffer, item, persistentType);
    }
    for (final item in items) {
      _writeItemProvider(buffer, item);
    }
    _writeAggregateClass(buffer, items);
    _writeAggregateNotifier(buffer, items, persistentType);

    return buffer.toString();
  }

  void _writeBaseClass(StringBuffer buffer) {
    final baseClass = options.baseClass;
    final itemDefineClass = options.itemDefineClass;
    buffer
      ..writeln('/// 单个状态项的基础实现，负责默认值与持久化数据之间的转换。')
      ..writeln('abstract class $baseClass<T, P> extends Notifier<T> {')
      ..writeln('  $itemDefineClass<T, P> get _define;')
      ..writeln()
      ..writeln('  T get defaultValue => _define.defaultValue;')
      ..writeln()
      ..writeln('  bool get isPersist =>')
      ..writeln(
        '      _define.readPersistent != null && _define.writePersistent != null;',
      )
      ..writeln()
      ..writeln('  @override')
      ..writeln('  T build() => defaultValue;')
      ..writeln()
      ..writeln('  void fromPersistent(P p) {')
      ..writeln('    if (!isPersist) return;')
      ..writeln('    state = _define.readPersistent!.call(defaultValue, p);')
      ..writeln('  }')
      ..writeln()
      ..writeln('  P toPersistent(P p) {')
      ..writeln('    if (!isPersist) return p;')
      ..writeln('    return _define.writePersistent!.call(state, p);')
      ..writeln('  }')
      ..writeln('}')
      ..writeln();
  }

  void _writeItemClass(
    StringBuffer buffer,
    AppStateItemInfo item,
    String persistentType,
  ) {
    _writeDocComment(buffer, item.description);
    buffer
      ..writeln(
        'class ${item.stateClass} '
        'extends ${options.baseClass}<${item.valueType}, $persistentType> {',
      )
      ..writeln('  @override')
      ..writeln(
        '  ${options.itemDefineClass}<${item.valueType}, $persistentType> '
        'get _define => ${item.fieldName};',
      )
      ..writeln('}')
      ..writeln();
  }

  void _writeItemProvider(StringBuffer buffer, AppStateItemInfo item) {
    buffer
      ..writeln(
        'final ${item.providerName} = '
        'NotifierProvider<${item.stateClass}, ${item.valueType}>(',
      )
      ..writeln('  ${item.stateClass}.new,')
      ..writeln(');')
      ..writeln();
  }

  void _writeAggregateClass(StringBuffer buffer, List<AppStateItemInfo> items) {
    final aggregateClass = options.aggregateClass;
    buffer.writeln('/// 所有状态项的聚合数据，可以一次性读取全部状态。');
    buffer.writeln('class $aggregateClass {');
    for (final item in items) {
      _writeDocComment(buffer, item.description, indent: '  ');
      buffer.writeln('  final ${item.valueType} ${item.fieldInAggregate};');
    }
    buffer
      ..writeln()
      ..writeln('  const $aggregateClass({');
    for (final item in items) {
      buffer.writeln('    required this.${item.fieldInAggregate},');
    }
    buffer
      ..writeln('  });')
      ..writeln('}')
      ..writeln();
  }

  void _writeAggregateNotifier(
    StringBuffer buffer,
    List<AppStateItemInfo> items,
    String persistentType,
  ) {
    final aggregateClass = options.aggregateClass;
    final notifierClass = options.aggregateNotifierClass;
    buffer
      ..writeln(
        'final ${options.aggregateProvider} = '
        'NotifierProvider<$notifierClass, $aggregateClass>(',
      )
      ..writeln('  $notifierClass.new,')
      ..writeln(');')
      ..writeln()
      ..writeln('class $notifierClass extends Notifier<$aggregateClass> {')
      ..writeln('  @override')
      ..writeln('  $aggregateClass build() {')
      ..writeln('    return $aggregateClass(');
    for (final item in items) {
      buffer.writeln(
        '      ${item.fieldInAggregate}: ref.watch(${item.providerName}),',
      );
    }
    buffer
      ..writeln('    );')
      ..writeln('  }')
      ..writeln()
      ..writeln('  /// 从持久化数据中恢复所有状态项。')
      ..writeln('  void loadFromPersistent($persistentType p) {');
    for (final item in items) {
      buffer.writeln(
        '    ref.read(${item.providerName}.notifier).fromPersistent(p);',
      );
    }
    buffer
      ..writeln('  }')
      ..writeln()
      ..writeln('  /// 把所有状态项写回持久化数据。')
      ..writeln('  $persistentType saveToPersistent($persistentType p) {')
      ..writeln('    $persistentType res = p;');
    for (final item in items) {
      buffer.writeln(
        '    res = ref.read(${item.providerName}.notifier).toPersistent(res);',
      );
    }
    buffer
      ..writeln('    return res;')
      ..writeln('  }')
      ..writeln('}');
  }

  void _writeDocComment(
    StringBuffer buffer,
    String? description, {
    String indent = '',
  }) {
    if (description == null) return;
    for (final line in description.split('\n')) {
      buffer.writeln('$indent/// $line');
    }
  }
}
