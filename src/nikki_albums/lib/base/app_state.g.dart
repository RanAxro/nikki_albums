// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// 该文件由 nikki_albums_generator 根据 @AppStateDefine 注解生成，请勿手动修改。
//
// 重新生成：dart run build_runner build

/// 单个状态项的基础实现，负责默认值与持久化数据之间的转换。
abstract class AppStateItem<T, P> extends Notifier<T> {
  AppStateItemDefine<T, P> get _define;

  T get defaultValue => _define.defaultValue;

  bool get isPersist =>
      _define.readPersistent != null && _define.writePersistent != null;

  @override
  T build() => defaultValue;

  void fromPersistent(P p) {
    if (!isPersist) return;
    state = _define.readPersistent!.call(defaultValue, p);
  }

  P toPersistent(P p) {
    if (!isPersist) return p;
    return _define.writePersistent!.call(state, p);
  }
}

/// 用户是否同意政策
class IsAgreeAgreementState extends AppStateItem<bool, Persistent> {
  @override
  AppStateItemDefine<bool, Persistent> get _define => _isAgreeAgreement;
}

/// 是否首次使用程序
class IsInitialStartupState extends AppStateItem<bool, Persistent> {
  @override
  AppStateItemDefine<bool, Persistent> get _define => _isInitialStartup;
}

/// 当前语言
class LangState extends AppStateItem<Locale, Persistent> {
  @override
  AppStateItemDefine<Locale, Persistent> get _define => _lang;
}

final _isAgreeAgreementProvider = NotifierProvider<IsAgreeAgreementState, bool>(
  IsAgreeAgreementState.new,
);

final _isInitialStartupProvider = NotifierProvider<IsInitialStartupState, bool>(
  IsInitialStartupState.new,
);

final _langProvider = NotifierProvider<LangState, Locale>(LangState.new);

/// 所有状态项的聚合数据，可以一次性读取全部状态。
class AppState {
  /// 用户是否同意政策
  final bool isAgreeAgreement;

  /// 是否首次使用程序
  final bool isInitialStartup;

  /// 当前语言
  final Locale lang;

  const AppState({
    required this.isAgreeAgreement,
    required this.isInitialStartup,
    required this.lang,
  });
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(
  AppStateNotifier.new,
);

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    return AppState(
      isAgreeAgreement: ref.watch(_isAgreeAgreementProvider),
      isInitialStartup: ref.watch(_isInitialStartupProvider),
      lang: ref.watch(_langProvider),
    );
  }

  /// 从持久化数据中恢复所有状态项。
  void loadFromPersistent(Persistent p) {
    ref.read(_isAgreeAgreementProvider.notifier).fromPersistent(p);
    ref.read(_isInitialStartupProvider.notifier).fromPersistent(p);
    ref.read(_langProvider.notifier).fromPersistent(p);
  }

  /// 把所有状态项写回持久化数据。
  Persistent saveToPersistent(Persistent p) {
    Persistent res = p;
    res = ref.read(_isAgreeAgreementProvider.notifier).toPersistent(res);
    res = ref.read(_isInitialStartupProvider.notifier).toPersistent(res);
    res = ref.read(_langProvider.notifier).toPersistent(res);
    return res;
  }
}
