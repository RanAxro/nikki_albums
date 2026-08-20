
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:nikki_albums/src/rust/config/app_persistent_state.dart";
import "package:nikki_albums_annotation/nikki_albums_annotation.dart";

import "dart:ui";



typedef Persistent = AppPersistentState;

@AppStateDefine("用户是否同意政策")
final _isAgreeAgreement = AppStateItemDefine<bool, Persistent>(
  defaultValue: false,
  ref: (p) => p.isAgreeAgreement,
);

@AppStateDefine("是否首次使用程序")
final _isInitialStartup = AppStateItemDefine<bool, Persistent>(
  defaultValue: false,
  ref: (p) => p.isInitialStartup,
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





/// 以下代码为自动生成

class AppState{
  final IsAgreeAgreementState isAgreeAgreement;
  final IsInitialStartupState isInitialStartup;
  final LangState lang;

  const AppState({
    required this.isAgreeAgreement,
    required this.isInitialStartup,
    required this.lang,
  });
}

abstract class AppStateItem<T, P> extends Notifier<T>{
  AppStateItemDefine<T, P> get _define;

  T get defaultValue => _define.defaultValue;

  bool get isPersist => _define.ref != null || (_define.readPersistent != null && _define.writePersistent != null);

  @override
  T build() => defaultValue;

  void fromPersistent(P p){
    if(!isPersist) return;
    if(_define.readPersistent != null){
      state = _define.readPersistent!.call(defaultValue, p);
    }else{
      state = _fromPersistentByRef(p);
    }
  }

  T _fromPersistentByRef(P p){
    return _define.ref?.call(p) ?? defaultValue;
  }

  P toPersistent(P p){
    if(!isPersist) return p;
    if(_define.writePersistent != null){
      return _define.writePersistent!.call(state, p);
    }else{
      return _toPersistentByRef(state, p);
    }
  }

  P _toPersistentByRef(T v, P p){
    return p;
  }
}

class IsAgreeAgreementState extends AppStateItem<bool, Persistent>{
  @override
  AppStateItemDefine<bool, Persistent> get _define => _isAgreeAgreement;

  @override
  Persistent _toPersistentByRef(bool v, Persistent p){
    return p.copyWith(isAgreeAgreement: v);
  }
}

class IsInitialStartupState extends AppStateItem<bool, Persistent>{
  @override
  AppStateItemDefine<bool, Persistent> get _define => _isInitialStartup;

  @override
  Persistent _toPersistentByRef(bool v, Persistent p){
    return p.copyWith(isInitialStartup: v);
  }
}

class LangState extends AppStateItem<Locale, Persistent>{
  @override
  AppStateItemDefine<Locale, Persistent> get _define => _lang;
}