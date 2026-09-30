import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:nikki_albums_annotation/nikki_albums_annotation.dart';
import 'package:source_gen/source_gen.dart';

import '../../common/naming.dart';
import 'app_state_item.dart';
import 'app_state_options.dart';
import 'app_state_writer.dart';

/// 状态项定义的类型名，被 `@AppStateDefine` 标注的变量必须是这个类型。
const _itemDefineClassName = 'AppStateItemDefine';

/// 根据 [AppStateDefine] 注解生成 AppState 相关代码。
///
/// 生成内容：
/// * 状态项基础类（默认 `AppStateItem`）
/// * 每个状态项对应的状态类（`Notifier` 子类）与对应的 Provider
/// * 聚合所有状态项的数据类、`Notifier` 与 Provider
///
/// 被标注的变量名需要满足私有字段的命名规范，默认直接使用变量名：
///
/// ```dart
/// @AppStateDefine("当前语言")
/// final _lang = AppStateItemDefine<Locale, Persistent>(...);
/// ```
///
/// 会生成 `LangState`、`_langProvider`，并在聚合类里生成 `lang` 字段。
/// 如果注解提供了 `rename`，则用 `rename` 代替变量名参与命名。
class AppStateGenerator extends GeneratorForAnnotation<AppStateDefine> {
  /// 生成配置。
  final AppStateBuilderOptions options;

  AppStateGenerator([this.options = AppStateBuilderOptions.defaults])
    : super(inPackage: 'nikki_albums_annotation');

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final items = <AppStateItemInfo>[];
    for (final annotated in library.annotatedWith(typeChecker)) {
      items.add(_readItem(annotated));
    }

    if (items.isEmpty) return '';

    // 保证生成结果与源码中的声明顺序一致。
    items.sort((a, b) => a.offset.compareTo(b.offset));
    _checkConflicts(items);

    return AppStateWriter(options).write(items);
  }

  AppStateItemInfo _readItem(AnnotatedElement annotated) {
    final element = annotated.element;
    if (element is! TopLevelVariableElement) {
      throw InvalidGenerationSource(
        '@AppStateDefine 只能标注在顶层变量上。',
        element: element,
        todo: '把该变量移动到文件顶层，或者删除注解。',
      );
    }

    // 顶层变量一定有名字。
    final fieldName = element.name!;
    if (!isPrivateFieldName(fieldName)) {
      throw InvalidGenerationSource(
        '@AppStateDefine 标注的变量名必须是以下划线开头、后面接合法字段名的私有字段，'
        '例如 _isAgreeAgreement，当前为 $fieldName。',
        element: element,
        todo: '把变量重命名为 _$fieldName 这样的形式，'
            '或者用 @AppStateDefine("描述", rename: "...") 指定生成时使用的名字。',
      );
    }

    final type = element.type;
    if (type is! InterfaceType ||
        type.element.name != _itemDefineClassName ||
        type.typeArguments.length != 2) {
      throw InvalidGenerationSource(
        '被 @AppStateDefine 标注的变量必须使用 '
        '$_itemDefineClassName<状态类型, 持久化类型> 作为类型，'
        '当前类型为 $type。',
        element: element,
        todo: '例如：final $fieldName = '
            '$_itemDefineClassName<Locale, Persistent>(...);',
      );
    }

    final annotation = annotated.annotation;
    final baseName = _readBaseName(
      rename: annotation.peek('rename')?.stringValue,
      fieldName: fieldName,
      element: element,
    );

    return AppStateItemInfo(
      offset: element.firstFragment.nameOffset ?? 0,
      fieldName: fieldName,
      stateClass: '$baseName${options.stateSuffix}',
      providerName: '_${lowerFirst(baseName)}${options.providerSuffix}',
      fieldInAggregate: lowerFirst(baseName),
      valueType: _typeToCode(type.typeArguments[0]),
      persistentType: _typeToCode(type.typeArguments[1]),
      description: annotation.peek('description')?.stringValue,
    );
  }

  /// 生成时使用的名字：默认取变量名（去掉下划线），注解提供了 [rename] 时优先使用。
  String _readBaseName({
    required String? rename,
    required String fieldName,
    required Element element,
  }) {
    if (rename == null) return upperFirst(stripLeadingUnderscores(fieldName));

    final normalized = stripLeadingUnderscores(rename);
    if (normalized.isEmpty || !isIdentifier(normalized)) {
      throw InvalidGenerationSource(
        '@AppStateDefine 的 rename 必须是合法的标识符，当前为 "$rename"。',
        element: element,
        todo: '例如：@AppStateDefine("当前语言", rename: "Language")。',
      );
    }
    return upperFirst(normalized);
  }

  void _checkConflicts(List<AppStateItemInfo> items) {
    final persistentType = items.first.persistentType;
    final names = <String>{};
    for (final item in items) {
      if (item.persistentType != persistentType) {
        throw InvalidGenerationSource(
          '@AppStateDefine 标注的所有状态项必须使用同一种持久化类型，'
          '当前同时存在 $persistentType 与 ${item.persistentType}。',
        );
      }
      if (!names.add(item.fieldInAggregate)) {
        throw InvalidGenerationSource(
          '生成的状态名 ${item.stateClass} 重复，'
          '请通过 @AppStateDefine 的 rename 参数区分。',
        );
      }
    }
  }
}

/// 取出类型在源码中书写的方式，尽量保留别名（例如 `Persistent`）。
String _typeToCode(DartType type) {
  final aliasName = type.alias?.element.name;
  if (aliasName != null) return aliasName;
  return type.getDisplayString();
}
