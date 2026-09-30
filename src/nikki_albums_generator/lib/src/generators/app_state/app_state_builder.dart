import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'app_state_generator.dart';
import 'app_state_options.dart';

/// 生成 `@AppStateDefine` 注解对应的代码。
///
/// 该 Builder 由 `build.yaml` 中的 `nikki_albums_generator:app_state` 引用，
/// 使用方只需要添加依赖并在源文件中加入 `part` 指令。
Builder appStateBuilder(BuilderOptions options) => SharedPartBuilder(
  [AppStateGenerator(AppStateBuilderOptions.fromBuilderOptions(options))],
  'app_state',
  writeDescriptions: false,
);
