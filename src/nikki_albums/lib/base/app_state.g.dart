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

/// 当前游戏会话
class SelectedDeviceGameState
    extends AppStateItem<DeviceGameSession?, Persistent> {
  @override
  AppStateItemDefine<DeviceGameSession?, Persistent> get _define =>
      _selectedDeviceGame;
}

/// 自定义游戏
class PickedDeviceGameState extends AppStateItem<List<DeviceGame>, Persistent> {
  @override
  AppStateItemDefine<List<DeviceGame>, Persistent> get _define =>
      _pickedDeviceGame;
}

/// 隐藏的账号
class HiddenAccountState
    extends AppStateItem<List<DeviceGameAccount>, Persistent> {
  @override
  AppStateItemDefine<List<DeviceGameAccount>, Persistent> get _define =>
      _hiddenAccount;
}

/// 标星的账号
class StarredAccountState
    extends AppStateItem<List<DeviceGameAccount>, Persistent> {
  @override
  AppStateItemDefine<List<DeviceGameAccount>, Persistent> get _define =>
      _starredAccount;
}

/// 置顶的账号
class TopRankedAccountState
    extends AppStateItem<List<DeviceGameAccount>, Persistent> {
  @override
  AppStateItemDefine<List<DeviceGameAccount>, Persistent> get _define =>
      _topRankedAccount;
}

/// 用户添加的自定义账号
class AddedCustomAccountState
    extends AppStateItem<List<DeviceGameAccount>, Persistent> {
  @override
  AppStateItemDefine<List<DeviceGameAccount>, Persistent> get _define =>
      _addedCustomAccount;
}

/// 账号备注
class AccountNoteState
    extends AppStateItem<List<DeviceGameAccountNote>, Persistent> {
  @override
  AppStateItemDefine<List<DeviceGameAccountNote>, Persistent> get _define =>
      _accountNote;
}

final _isAgreeAgreementProvider = NotifierProvider<IsAgreeAgreementState, bool>(
  IsAgreeAgreementState.new,
);

final _isInitialStartupProvider = NotifierProvider<IsInitialStartupState, bool>(
  IsInitialStartupState.new,
);

final _langProvider = NotifierProvider<LangState, Locale>(LangState.new);

final _selectedDeviceGameProvider =
    NotifierProvider<SelectedDeviceGameState, DeviceGameSession?>(
      SelectedDeviceGameState.new,
    );

final _pickedDeviceGameProvider =
    NotifierProvider<PickedDeviceGameState, List<DeviceGame>>(
      PickedDeviceGameState.new,
    );

final _hiddenAccountProvider =
    NotifierProvider<HiddenAccountState, List<DeviceGameAccount>>(
      HiddenAccountState.new,
    );

final _starredAccountProvider =
    NotifierProvider<StarredAccountState, List<DeviceGameAccount>>(
      StarredAccountState.new,
    );

final _topRankedAccountProvider =
    NotifierProvider<TopRankedAccountState, List<DeviceGameAccount>>(
      TopRankedAccountState.new,
    );

final _addedCustomAccountProvider =
    NotifierProvider<AddedCustomAccountState, List<DeviceGameAccount>>(
      AddedCustomAccountState.new,
    );

final _accountNoteProvider =
    NotifierProvider<AccountNoteState, List<DeviceGameAccountNote>>(
      AccountNoteState.new,
    );

const _appStateCopyWithSentinel = Object();

/// 所有状态项的聚合数据，可以一次性读取全部状态。
class AppState {
  /// 用户是否同意政策
  final bool isAgreeAgreement;

  /// 是否首次使用程序
  final bool isInitialStartup;

  /// 当前语言
  final Locale lang;

  /// 当前游戏会话
  final DeviceGameSession? selectedDeviceGame;

  /// 自定义游戏
  final List<DeviceGame> pickedDeviceGame;

  /// 隐藏的账号
  final List<DeviceGameAccount> hiddenAccount;

  /// 标星的账号
  final List<DeviceGameAccount> starredAccount;

  /// 置顶的账号
  final List<DeviceGameAccount> topRankedAccount;

  /// 用户添加的自定义账号
  final List<DeviceGameAccount> addedCustomAccount;

  /// 账号备注
  final List<DeviceGameAccountNote> accountNote;

  const AppState({
    required this.isAgreeAgreement,
    required this.isInitialStartup,
    required this.lang,
    required this.selectedDeviceGame,
    required this.pickedDeviceGame,
    required this.hiddenAccount,
    required this.starredAccount,
    required this.topRankedAccount,
    required this.addedCustomAccount,
    required this.accountNote,
  });

  AppState copyWith({
    bool? isAgreeAgreement,
    bool? isInitialStartup,
    Locale? lang,
    Object? selectedDeviceGame = _appStateCopyWithSentinel,
    List<DeviceGame>? pickedDeviceGame,
    List<DeviceGameAccount>? hiddenAccount,
    List<DeviceGameAccount>? starredAccount,
    List<DeviceGameAccount>? topRankedAccount,
    List<DeviceGameAccount>? addedCustomAccount,
    List<DeviceGameAccountNote>? accountNote,
  }) {
    return AppState(
      isAgreeAgreement: isAgreeAgreement ?? this.isAgreeAgreement,
      isInitialStartup: isInitialStartup ?? this.isInitialStartup,
      lang: lang ?? this.lang,
      selectedDeviceGame:
          identical(selectedDeviceGame, _appStateCopyWithSentinel)
          ? this.selectedDeviceGame
          : selectedDeviceGame as DeviceGameSession?,
      pickedDeviceGame: pickedDeviceGame ?? this.pickedDeviceGame,
      hiddenAccount: hiddenAccount ?? this.hiddenAccount,
      starredAccount: starredAccount ?? this.starredAccount,
      topRankedAccount: topRankedAccount ?? this.topRankedAccount,
      addedCustomAccount: addedCustomAccount ?? this.addedCustomAccount,
      accountNote: accountNote ?? this.accountNote,
    );
  }
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
      selectedDeviceGame: ref.watch(_selectedDeviceGameProvider),
      pickedDeviceGame: ref.watch(_pickedDeviceGameProvider),
      hiddenAccount: ref.watch(_hiddenAccountProvider),
      starredAccount: ref.watch(_starredAccountProvider),
      topRankedAccount: ref.watch(_topRankedAccountProvider),
      addedCustomAccount: ref.watch(_addedCustomAccountProvider),
      accountNote: ref.watch(_accountNoteProvider),
    );
  }

  AppState getAppState() {
    return state;
  }

  void setAppState(AppState appState) {
    state = appState;
  }

  AppState setAppStateWith({
    bool? isAgreeAgreement,
    bool? isInitialStartup,
    Locale? lang,
    Object? selectedDeviceGame = _appStateCopyWithSentinel,
    List<DeviceGame>? pickedDeviceGame,
    List<DeviceGameAccount>? hiddenAccount,
    List<DeviceGameAccount>? starredAccount,
    List<DeviceGameAccount>? topRankedAccount,
    List<DeviceGameAccount>? addedCustomAccount,
    List<DeviceGameAccountNote>? accountNote,
  }) {
    final newState = state.copyWith(
      isAgreeAgreement: isAgreeAgreement,
      isInitialStartup: isInitialStartup,
      lang: lang,
      selectedDeviceGame: selectedDeviceGame,
      pickedDeviceGame: pickedDeviceGame,
      hiddenAccount: hiddenAccount,
      starredAccount: starredAccount,
      topRankedAccount: topRankedAccount,
      addedCustomAccount: addedCustomAccount,
      accountNote: accountNote,
    );
    state = newState;
    return newState;
  }

  /// 从持久化数据中恢复所有状态项。
  void loadFromPersistent(Persistent p) {
    ref.read(_isAgreeAgreementProvider.notifier).fromPersistent(p);
    ref.read(_isInitialStartupProvider.notifier).fromPersistent(p);
    ref.read(_langProvider.notifier).fromPersistent(p);
    ref.read(_selectedDeviceGameProvider.notifier).fromPersistent(p);
    ref.read(_pickedDeviceGameProvider.notifier).fromPersistent(p);
    ref.read(_hiddenAccountProvider.notifier).fromPersistent(p);
    ref.read(_starredAccountProvider.notifier).fromPersistent(p);
    ref.read(_topRankedAccountProvider.notifier).fromPersistent(p);
    ref.read(_addedCustomAccountProvider.notifier).fromPersistent(p);
    ref.read(_accountNoteProvider.notifier).fromPersistent(p);
  }

  /// 把所有状态项写回持久化数据。
  Persistent saveToPersistent(Persistent p) {
    Persistent res = p;
    res = ref.read(_isAgreeAgreementProvider.notifier).toPersistent(res);
    res = ref.read(_isInitialStartupProvider.notifier).toPersistent(res);
    res = ref.read(_langProvider.notifier).toPersistent(res);
    res = ref.read(_selectedDeviceGameProvider.notifier).toPersistent(res);
    res = ref.read(_pickedDeviceGameProvider.notifier).toPersistent(res);
    res = ref.read(_hiddenAccountProvider.notifier).toPersistent(res);
    res = ref.read(_starredAccountProvider.notifier).toPersistent(res);
    res = ref.read(_topRankedAccountProvider.notifier).toPersistent(res);
    res = ref.read(_addedCustomAccountProvider.notifier).toPersistent(res);
    res = ref.read(_accountNoteProvider.notifier).toPersistent(res);
    return res;
  }
}
