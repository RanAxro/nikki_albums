# nikki_albums_generator

`nikki_albums` 使用的代码生成器，基于 `build_runner`：

* `@AppStateDefine`：生成状态类、Provider，以及聚合的 `AppState` / `AppStateNotifier` / `appStateProvider`。

## 目录结构

```
lib/
├── nikki_albums_generator.dart              # 对外入口：导出所有 Builder 工厂
└── src/
    ├── common/                              # 各 Generator 共用的工具
    │   └── naming.dart                      # 命名转换与命名规范校验
    └── generators/                          # 所有 Generator，一个 Generator 一个目录
        └── app_state/                       # @AppStateDefine
            ├── app_state_builder.dart       # Builder 工厂（build.yaml 引用）
            ├── app_state_generator.dart     # 分析注解、组装数据
            ├── app_state_writer.dart        # 把数据渲染成 Dart 代码
            ├── app_state_item.dart          # 生成过程中用到的数据模型
            └── app_state_options.dart       # Builder 配置项
```

## 新增一个 Generator

1. 在 `lib/src/generators/<name>/` 下按上面的分工新增文件，
   Builder 工厂的入参是 `BuilderOptions`，返回值是 `Builder`（推荐 `SharedPartBuilder`）。
2. 在 `lib/nikki_albums_generator.dart` 中导出该工厂。
3. 在 `build.yaml` 的 `builders` 下登记，例如：

```yaml
builders:
  <name>:
    import: "package:nikki_albums_generator/nikki_albums_generator.dart"
    builder_factories: ["<name>Builder"]
    build_extensions: { ".dart": [".<name>.g.part"] }
    auto_apply: dependents
    build_to: cache
    applies_builders: ["source_gen|combining_builder"]
```

## 使用

在应用包的 `dev_dependencies` 中加入依赖：

```yaml
dev_dependencies:
  nikki_albums_generator:
    path: ../nikki_albums_generator
```

在需要生成代码的文件里加入 `part` 指令：

```dart
part "app_state.g.dart";
```

修改注解后重新生成：

```bash
dart run build_runner build
```

## 生成规则

被 `@AppStateDefine` 标注的顶层变量必须是 `AppStateItemDefine<T, P>` 类型，
变量名需要符合私有字段的命名规范：以下划线开头，后面接合法的小驼峰字段名
（例如 `_isAgreeAgreement`）。生成的名字默认由变量名推导（去掉前缀下划线，
并把首字母大写）：

| 源码 | 生成内容 |
| --- | --- |
| `final _lang = AppStateItemDefine<Locale, Persistent>(...)` | `LangState`、`_langProvider`、聚合类中的 `lang` 字段 |

变量名不符合规范时会直接报错。如果推导出来的名字不合适，
可以通过注解的 `rename` 参数指定，`rename` 会代替变量名参与命名（同样以下划线外的
合法标识符为准）：

```dart
@AppStateDefine("当前语言", rename: "Language")
final _lang = AppStateItemDefine<Locale, Persistent>(...);
```

还会生成一个聚合类，默认名称为 `AppState`，同时生成 `AppStateNotifier` 与
`appStateProvider`，用于批量读取、加载和保存所有状态。

生成的名字可以通过 `build.yaml` 中的 `options` 调整：

```yaml
targets:
  $default:
    builders:
      nikki_albums_generator:app_state:
        options:
          state_suffix: State
          provider_suffix: Provider
          base_class: AppStateItem
          item_define_class: AppStateItemDefine
          aggregate_class: AppState
          aggregate_notifier_class: AppStateNotifier
          aggregate_provider: appStateProvider
```
