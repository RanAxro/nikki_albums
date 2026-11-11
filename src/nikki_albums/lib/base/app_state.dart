
import "package:nikki_albums_annotation/nikki_albums_annotation.dart";
import "package:nikki_albums/gen/rust/config/app_persistent_state.dart";
import "package:nikki_albums/gen/rust/config/game.dart";

import "dart:ui";

import "package:flutter_riverpod/flutter_riverpod.dart";

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

@AppStateDefine("当前游戏会话")
final _selectedDeviceGame = AppStateItemDefine<DeviceGameSession?, Persistent>(
  defaultValue: null,
  readPersistent: (d, p) => p.selectedDeviceGame ?? d,
  writePersistent: (v, p) => p.copyWith(selectedDeviceGame: v),
);

@AppStateDefine("自定义游戏")
final _pickedDeviceGame = AppStateItemDefine<List<DeviceGame>, Persistent>(
  defaultValue: [],
  readPersistent: (d, p) => p.pickedDeviceGame ?? d,
  writePersistent: (v, p) => p.copyWith(pickedDeviceGame: v),
);

@AppStateDefine("隐藏的账号")
final _hiddenAccount = AppStateItemDefine<List<DeviceGameAccount>, Persistent>(
  defaultValue: [],
  readPersistent: (d, p) => p.hiddenAccount ?? d,
  writePersistent: (v, p) => p.copyWith(hiddenAccount: v),
);

@AppStateDefine("标星的账号")
final _starredAccount = AppStateItemDefine<List<DeviceGameAccount>, Persistent>(
  defaultValue: [],
  readPersistent: (d, p) => p.starredAccount ?? d,
  writePersistent: (v, p) => p.copyWith(starredAccount: v),
);

@AppStateDefine("置顶的账号")
final _topRankedAccount = AppStateItemDefine<List<DeviceGameAccount>, Persistent>(
  defaultValue: [],
  readPersistent: (d, p) => p.topRankedAccount ?? d,
  writePersistent: (v, p) => p.copyWith(topRankedAccount: v),
);

@AppStateDefine("用户添加的自定义账号")
final _addedCustomAccount = AppStateItemDefine<List<DeviceGameAccount>, Persistent>(
  defaultValue: [],
  readPersistent: (d, p) => p.addedCustomAccount ?? d,
  writePersistent: (v, p) => p.copyWith(addedCustomAccount: v),
);

@AppStateDefine("账号备注")
final _accountNote = AppStateItemDefine<List<DeviceGameAccountNote>, Persistent>(
  defaultValue: [],
  readPersistent: (d, p) => p.accountNote ?? d,
  writePersistent: (v, p) => p.copyWith(accountNote: v),
);




// ---------------------------------------------------------------------------
// 以下代码为自动生成，请勿手动修改。
//
// 生成规则见 package:nikki_albums_generator，修改注解后执行：
//     dart run build_runner build
//
// 生成结果位于同目录的 app_state.g.dart。
// ---------------------------------------------------------------------------
