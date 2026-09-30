/// nikki_albums 的代码生成器。
///
/// 生成的代码由 `build_runner` 驱动，具体配置见本包的 `build.yaml`。
/// 每个 Generator 的代码放在 `lib/src/generators/<name>` 目录下，
/// 这里统一导出它们的 Builder 工厂。
library;

export 'src/generators/app_state/app_state_builder.dart' show appStateBuilder;
