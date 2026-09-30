
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:nikki_albums/src/rust/config/app_persistent_state.dart";
import "package:nikki_albums_annotation/nikki_albums_annotation.dart";

import "dart:ui";

part "app_state.g.dart";


typedef Persistent = AppPersistentState;

@AppStateDefine("用户是否同意政策")
final _isAgreeAgreement = AppStateItemDefine<bool, Persistent>(
  defaultValue: false,
  readPersistent: (d, p) => p.isAgreeAgreement ?? d,
  writePersistent: (v, p) => p.copyWith(isAgreeAgreement: v),
);

@AppStateDefine("是否首次使用程序")
final _isInitialStartup = AppStateItemDefine<bool, Persistent>(
  defaultValue: false,
  readPersistent: (d, p) => p.isInitialStartup ?? d,
  writePersistent: (v, p) => p.copyWith(isInitialStartup: v),
);

@AppStateDefine("当前语言")
final _lang = AppStateItemDefine<Locale, Persistent>(
  defaultValue: Locale("zh", "CN"),
  readPersistent: (d, p){
    final String? lang = p.lang;
    if(lang == null) return d;
    final List<String> parts = lang.split("-");
    if(parts.isEmpty) return d;
    return Locale(parts.first, parts.elementAtOrNull(1));
  },
  writePersistent: (v, p) => p.copyWith(lang: v.toLanguageTag()),
);





// ---------------------------------------------------------------------------
// 以下代码为自动生成，请勿手动修改。
//
// 生成规则见 package:nikki_albums_generator，修改注解后执行：
//     dart run build_runner build
//
// 生成结果位于同目录的 app_state.g.dart。
// ---------------------------------------------------------------------------
