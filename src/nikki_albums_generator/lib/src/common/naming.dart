/// 生成代码时用到的命名工具。
///
/// 所有 Generator 共用这里的规则，保证生成出来的名字风格一致。
library;

/// 合法的 Dart 标识符（不包含关键字判断）。
final RegExp _identifier = RegExp(r'^[a-zA-Z_$][a-zA-Z0-9_$]*$');

/// 规范的私有字段名：以下划线开头，后面接合法的小驼峰字段名。
///
/// 例如 `_isAgreeAgreement`、`_lang`。
final RegExp _privateFieldName = RegExp(r'^_[a-z][a-zA-Z0-9]*$');

final RegExp _leadingUnderscores = RegExp('^_+');

/// 是否是合法的 Dart 标识符。
bool isIdentifier(String name) => _identifier.hasMatch(name);

/// 是否是符合规范的私有字段名，例如 `_isAgreeAgreement`。
bool isPrivateFieldName(String name) => _privateFieldName.hasMatch(name);

/// 去掉名字开头的一个或多个下划线。
String stripLeadingUnderscores(String name) =>
    name.replaceFirst(_leadingUnderscores, '');

/// 首字母大写，例如 `lang` -> `Lang`。
String upperFirst(String name) =>
    name.isEmpty ? name : '${name[0].toUpperCase()}${name.substring(1)}';

/// 首字母小写，例如 `Lang` -> `lang`。
String lowerFirst(String name) =>
    name.isEmpty ? name : '${name[0].toLowerCase()}${name.substring(1)}';
