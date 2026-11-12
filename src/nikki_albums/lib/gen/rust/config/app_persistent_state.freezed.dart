// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_persistent_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppPersistentState {

 bool? get isAgreeAgreement; bool? get isInitialStartup; String? get lang; int? get theme; DeviceGameSession? get selectedDeviceGame; List<DeviceGame>? get pickedDeviceGame; List<DeviceGameAccount>? get hiddenAccount; List<DeviceGameAccount>? get starredAccount; List<DeviceGameAccount>? get topRankedAccount; List<DeviceGameAccount>? get addedCustomAccount; List<DeviceGameAccountNote>? get accountNote; AlbumSliverType? get albumSliver; AlbumGridOrientation? get albumGridOrientation; AlbumGridAspectRatio? get albumGridAspectRatio; AlbumDensity? get albumDensity; Map<String, String> get unknownField;
/// Create a copy of AppPersistentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppPersistentStateCopyWith<AppPersistentState> get copyWith => _$AppPersistentStateCopyWithImpl<AppPersistentState>(this as AppPersistentState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppPersistentState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppPersistentState&&(identical(other.isAgreeAgreement, _this.isAgreeAgreement) || other.isAgreeAgreement == _this.isAgreeAgreement)&&(identical(other.isInitialStartup, _this.isInitialStartup) || other.isInitialStartup == _this.isInitialStartup)&&(identical(other.lang, _this.lang) || other.lang == _this.lang)&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.selectedDeviceGame, _this.selectedDeviceGame) || other.selectedDeviceGame == _this.selectedDeviceGame)&&const DeepCollectionEquality().equals(other.pickedDeviceGame, _this.pickedDeviceGame)&&const DeepCollectionEquality().equals(other.hiddenAccount, _this.hiddenAccount)&&const DeepCollectionEquality().equals(other.starredAccount, _this.starredAccount)&&const DeepCollectionEquality().equals(other.topRankedAccount, _this.topRankedAccount)&&const DeepCollectionEquality().equals(other.addedCustomAccount, _this.addedCustomAccount)&&const DeepCollectionEquality().equals(other.accountNote, _this.accountNote)&&(identical(other.albumSliver, _this.albumSliver) || other.albumSliver == _this.albumSliver)&&(identical(other.albumGridOrientation, _this.albumGridOrientation) || other.albumGridOrientation == _this.albumGridOrientation)&&(identical(other.albumGridAspectRatio, _this.albumGridAspectRatio) || other.albumGridAspectRatio == _this.albumGridAspectRatio)&&(identical(other.albumDensity, _this.albumDensity) || other.albumDensity == _this.albumDensity)&&const DeepCollectionEquality().equals(other.unknownField, _this.unknownField));
}


@override
int get hashCode {
  final _this = this as AppPersistentState;
  return Object.hash(runtimeType,_this.isAgreeAgreement,_this.isInitialStartup,_this.lang,_this.theme,_this.selectedDeviceGame,const DeepCollectionEquality().hash(_this.pickedDeviceGame),const DeepCollectionEquality().hash(_this.hiddenAccount),const DeepCollectionEquality().hash(_this.starredAccount),const DeepCollectionEquality().hash(_this.topRankedAccount),const DeepCollectionEquality().hash(_this.addedCustomAccount),const DeepCollectionEquality().hash(_this.accountNote),_this.albumSliver,_this.albumGridOrientation,_this.albumGridAspectRatio,_this.albumDensity,const DeepCollectionEquality().hash(_this.unknownField));
}

@override
String toString() {
  final _this = this as AppPersistentState;
  return 'AppPersistentState(isAgreeAgreement: ${_this.isAgreeAgreement}, isInitialStartup: ${_this.isInitialStartup}, lang: ${_this.lang}, theme: ${_this.theme}, selectedDeviceGame: ${_this.selectedDeviceGame}, pickedDeviceGame: ${_this.pickedDeviceGame}, hiddenAccount: ${_this.hiddenAccount}, starredAccount: ${_this.starredAccount}, topRankedAccount: ${_this.topRankedAccount}, addedCustomAccount: ${_this.addedCustomAccount}, accountNote: ${_this.accountNote}, albumSliver: ${_this.albumSliver}, albumGridOrientation: ${_this.albumGridOrientation}, albumGridAspectRatio: ${_this.albumGridAspectRatio}, albumDensity: ${_this.albumDensity}, unknownField: ${_this.unknownField})';
}


}

/// @nodoc
abstract mixin class $AppPersistentStateCopyWith<$Res>  {
  factory $AppPersistentStateCopyWith(AppPersistentState value, $Res Function(AppPersistentState) _then) = _$AppPersistentStateCopyWithImpl;
@useResult
$Res call({
 bool? isAgreeAgreement, bool? isInitialStartup, String? lang, int? theme, DeviceGameSession? selectedDeviceGame, List<DeviceGame>? pickedDeviceGame, List<DeviceGameAccount>? hiddenAccount, List<DeviceGameAccount>? starredAccount, List<DeviceGameAccount>? topRankedAccount, List<DeviceGameAccount>? addedCustomAccount, List<DeviceGameAccountNote>? accountNote, AlbumSliverType? albumSliver, AlbumGridOrientation? albumGridOrientation, AlbumGridAspectRatio? albumGridAspectRatio, AlbumDensity? albumDensity, Map<String, String> unknownField
});


$DeviceGameSessionCopyWith<$Res>? get selectedDeviceGame;

}
/// @nodoc
class _$AppPersistentStateCopyWithImpl<$Res>
    implements $AppPersistentStateCopyWith<$Res> {
  _$AppPersistentStateCopyWithImpl(this._self, this._then);

  final AppPersistentState _self;
  final $Res Function(AppPersistentState) _then;

/// Create a copy of AppPersistentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAgreeAgreement = freezed,Object? isInitialStartup = freezed,Object? lang = freezed,Object? theme = freezed,Object? selectedDeviceGame = freezed,Object? pickedDeviceGame = freezed,Object? hiddenAccount = freezed,Object? starredAccount = freezed,Object? topRankedAccount = freezed,Object? addedCustomAccount = freezed,Object? accountNote = freezed,Object? albumSliver = freezed,Object? albumGridOrientation = freezed,Object? albumGridAspectRatio = freezed,Object? albumDensity = freezed,Object? unknownField = null,}) {
  return _then(AppPersistentState(
isAgreeAgreement: freezed == isAgreeAgreement ? _self.isAgreeAgreement : isAgreeAgreement // ignore: cast_nullable_to_non_nullable
as bool?,isInitialStartup: freezed == isInitialStartup ? _self.isInitialStartup : isInitialStartup // ignore: cast_nullable_to_non_nullable
as bool?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as int?,selectedDeviceGame: freezed == selectedDeviceGame ? _self.selectedDeviceGame : selectedDeviceGame // ignore: cast_nullable_to_non_nullable
as DeviceGameSession?,pickedDeviceGame: freezed == pickedDeviceGame ? _self.pickedDeviceGame : pickedDeviceGame // ignore: cast_nullable_to_non_nullable
as List<DeviceGame>?,hiddenAccount: freezed == hiddenAccount ? _self.hiddenAccount : hiddenAccount // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccount>?,starredAccount: freezed == starredAccount ? _self.starredAccount : starredAccount // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccount>?,topRankedAccount: freezed == topRankedAccount ? _self.topRankedAccount : topRankedAccount // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccount>?,addedCustomAccount: freezed == addedCustomAccount ? _self.addedCustomAccount : addedCustomAccount // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccount>?,accountNote: freezed == accountNote ? _self.accountNote : accountNote // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccountNote>?,albumSliver: freezed == albumSliver ? _self.albumSliver : albumSliver // ignore: cast_nullable_to_non_nullable
as AlbumSliverType?,albumGridOrientation: freezed == albumGridOrientation ? _self.albumGridOrientation : albumGridOrientation // ignore: cast_nullable_to_non_nullable
as AlbumGridOrientation?,albumGridAspectRatio: freezed == albumGridAspectRatio ? _self.albumGridAspectRatio : albumGridAspectRatio // ignore: cast_nullable_to_non_nullable
as AlbumGridAspectRatio?,albumDensity: freezed == albumDensity ? _self.albumDensity : albumDensity // ignore: cast_nullable_to_non_nullable
as AlbumDensity?,unknownField: null == unknownField ? _self.unknownField : unknownField // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}
/// Create a copy of AppPersistentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceGameSessionCopyWith<$Res>? get selectedDeviceGame {
    if (_self.selectedDeviceGame == null) {
    return null;
  }

  return $DeviceGameSessionCopyWith<$Res>(_self.selectedDeviceGame!, (value) {
    return _then(_self.copyWith(selectedDeviceGame: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppPersistentState].
extension AppPersistentStatePatterns on AppPersistentState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppPersistentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppPersistentState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppPersistentState value)  $default,){
final _that = this;
switch (_that) {
case _AppPersistentState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppPersistentState value)?  $default,){
final _that = this;
switch (_that) {
case _AppPersistentState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isAgreeAgreement,  bool? isInitialStartup,  String? lang,  int? theme,  DeviceGameSession? selectedDeviceGame,  List<DeviceGame>? pickedDeviceGame,  List<DeviceGameAccount>? hiddenAccount,  List<DeviceGameAccount>? starredAccount,  List<DeviceGameAccount>? topRankedAccount,  List<DeviceGameAccount>? addedCustomAccount,  List<DeviceGameAccountNote>? accountNote,  AlbumSliverType? albumSliver,  AlbumGridOrientation? albumGridOrientation,  AlbumGridAspectRatio? albumGridAspectRatio,  AlbumDensity? albumDensity,  Map<String, String> unknownField)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppPersistentState() when $default != null:
return $default(_that.isAgreeAgreement,_that.isInitialStartup,_that.lang,_that.theme,_that.selectedDeviceGame,_that.pickedDeviceGame,_that.hiddenAccount,_that.starredAccount,_that.topRankedAccount,_that.addedCustomAccount,_that.accountNote,_that.albumSliver,_that.albumGridOrientation,_that.albumGridAspectRatio,_that.albumDensity,_that.unknownField);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isAgreeAgreement,  bool? isInitialStartup,  String? lang,  int? theme,  DeviceGameSession? selectedDeviceGame,  List<DeviceGame>? pickedDeviceGame,  List<DeviceGameAccount>? hiddenAccount,  List<DeviceGameAccount>? starredAccount,  List<DeviceGameAccount>? topRankedAccount,  List<DeviceGameAccount>? addedCustomAccount,  List<DeviceGameAccountNote>? accountNote,  AlbumSliverType? albumSliver,  AlbumGridOrientation? albumGridOrientation,  AlbumGridAspectRatio? albumGridAspectRatio,  AlbumDensity? albumDensity,  Map<String, String> unknownField)  $default,) {final _that = this;
switch (_that) {
case _AppPersistentState():
return $default(_that.isAgreeAgreement,_that.isInitialStartup,_that.lang,_that.theme,_that.selectedDeviceGame,_that.pickedDeviceGame,_that.hiddenAccount,_that.starredAccount,_that.topRankedAccount,_that.addedCustomAccount,_that.accountNote,_that.albumSliver,_that.albumGridOrientation,_that.albumGridAspectRatio,_that.albumDensity,_that.unknownField);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isAgreeAgreement,  bool? isInitialStartup,  String? lang,  int? theme,  DeviceGameSession? selectedDeviceGame,  List<DeviceGame>? pickedDeviceGame,  List<DeviceGameAccount>? hiddenAccount,  List<DeviceGameAccount>? starredAccount,  List<DeviceGameAccount>? topRankedAccount,  List<DeviceGameAccount>? addedCustomAccount,  List<DeviceGameAccountNote>? accountNote,  AlbumSliverType? albumSliver,  AlbumGridOrientation? albumGridOrientation,  AlbumGridAspectRatio? albumGridAspectRatio,  AlbumDensity? albumDensity,  Map<String, String> unknownField)?  $default,) {final _that = this;
switch (_that) {
case _AppPersistentState() when $default != null:
return $default(_that.isAgreeAgreement,_that.isInitialStartup,_that.lang,_that.theme,_that.selectedDeviceGame,_that.pickedDeviceGame,_that.hiddenAccount,_that.starredAccount,_that.topRankedAccount,_that.addedCustomAccount,_that.accountNote,_that.albumSliver,_that.albumGridOrientation,_that.albumGridAspectRatio,_that.albumDensity,_that.unknownField);case _:
  return null;

}
}

}

/// @nodoc


class _AppPersistentState extends AppPersistentState {
  const _AppPersistentState({this.isAgreeAgreement, this.isInitialStartup, this.lang, this.theme, this.selectedDeviceGame,  List<DeviceGame>? pickedDeviceGame,  List<DeviceGameAccount>? hiddenAccount,  List<DeviceGameAccount>? starredAccount,  List<DeviceGameAccount>? topRankedAccount,  List<DeviceGameAccount>? addedCustomAccount,  List<DeviceGameAccountNote>? accountNote, this.albumSliver, this.albumGridOrientation, this.albumGridAspectRatio, this.albumDensity, required  Map<String, String> unknownField}): _pickedDeviceGame = pickedDeviceGame,_hiddenAccount = hiddenAccount,_starredAccount = starredAccount,_topRankedAccount = topRankedAccount,_addedCustomAccount = addedCustomAccount,_accountNote = accountNote,_unknownField = unknownField,super._();
  

@override final  bool? isAgreeAgreement;
@override final  bool? isInitialStartup;
@override final  String? lang;
@override final  int? theme;
@override final  DeviceGameSession? selectedDeviceGame;
 final  List<DeviceGame>? _pickedDeviceGame;
@override List<DeviceGame>? get pickedDeviceGame {
  final value = _pickedDeviceGame;
  if (value == null) return null;
  if (_pickedDeviceGame is EqualUnmodifiableListView) return _pickedDeviceGame;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<DeviceGameAccount>? _hiddenAccount;
@override List<DeviceGameAccount>? get hiddenAccount {
  final value = _hiddenAccount;
  if (value == null) return null;
  if (_hiddenAccount is EqualUnmodifiableListView) return _hiddenAccount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<DeviceGameAccount>? _starredAccount;
@override List<DeviceGameAccount>? get starredAccount {
  final value = _starredAccount;
  if (value == null) return null;
  if (_starredAccount is EqualUnmodifiableListView) return _starredAccount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<DeviceGameAccount>? _topRankedAccount;
@override List<DeviceGameAccount>? get topRankedAccount {
  final value = _topRankedAccount;
  if (value == null) return null;
  if (_topRankedAccount is EqualUnmodifiableListView) return _topRankedAccount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<DeviceGameAccount>? _addedCustomAccount;
@override List<DeviceGameAccount>? get addedCustomAccount {
  final value = _addedCustomAccount;
  if (value == null) return null;
  if (_addedCustomAccount is EqualUnmodifiableListView) return _addedCustomAccount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<DeviceGameAccountNote>? _accountNote;
@override List<DeviceGameAccountNote>? get accountNote {
  final value = _accountNote;
  if (value == null) return null;
  if (_accountNote is EqualUnmodifiableListView) return _accountNote;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  AlbumSliverType? albumSliver;
@override final  AlbumGridOrientation? albumGridOrientation;
@override final  AlbumGridAspectRatio? albumGridAspectRatio;
@override final  AlbumDensity? albumDensity;
 final  Map<String, String> _unknownField;
@override Map<String, String> get unknownField {
  if (_unknownField is EqualUnmodifiableMapView) return _unknownField;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_unknownField);
}


/// Create a copy of AppPersistentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppPersistentStateCopyWith<_AppPersistentState> get copyWith => __$AppPersistentStateCopyWithImpl<_AppPersistentState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppPersistentState&&(identical(other.isAgreeAgreement, isAgreeAgreement) || other.isAgreeAgreement == isAgreeAgreement)&&(identical(other.isInitialStartup, isInitialStartup) || other.isInitialStartup == isInitialStartup)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.selectedDeviceGame, selectedDeviceGame) || other.selectedDeviceGame == selectedDeviceGame)&&const DeepCollectionEquality().equals(other.pickedDeviceGame, _pickedDeviceGame)&&const DeepCollectionEquality().equals(other.hiddenAccount, _hiddenAccount)&&const DeepCollectionEquality().equals(other.starredAccount, _starredAccount)&&const DeepCollectionEquality().equals(other.topRankedAccount, _topRankedAccount)&&const DeepCollectionEquality().equals(other.addedCustomAccount, _addedCustomAccount)&&const DeepCollectionEquality().equals(other.accountNote, _accountNote)&&(identical(other.albumSliver, albumSliver) || other.albumSliver == albumSliver)&&(identical(other.albumGridOrientation, albumGridOrientation) || other.albumGridOrientation == albumGridOrientation)&&(identical(other.albumGridAspectRatio, albumGridAspectRatio) || other.albumGridAspectRatio == albumGridAspectRatio)&&(identical(other.albumDensity, albumDensity) || other.albumDensity == albumDensity)&&const DeepCollectionEquality().equals(other.unknownField, _unknownField));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isAgreeAgreement,isInitialStartup,lang,theme,selectedDeviceGame,const DeepCollectionEquality().hash(_pickedDeviceGame),const DeepCollectionEquality().hash(_hiddenAccount),const DeepCollectionEquality().hash(_starredAccount),const DeepCollectionEquality().hash(_topRankedAccount),const DeepCollectionEquality().hash(_addedCustomAccount),const DeepCollectionEquality().hash(_accountNote),albumSliver,albumGridOrientation,albumGridAspectRatio,albumDensity,const DeepCollectionEquality().hash(_unknownField));
}

@override
String toString() {
    return 'AppPersistentState(isAgreeAgreement: $isAgreeAgreement, isInitialStartup: $isInitialStartup, lang: $lang, theme: $theme, selectedDeviceGame: $selectedDeviceGame, pickedDeviceGame: $pickedDeviceGame, hiddenAccount: $hiddenAccount, starredAccount: $starredAccount, topRankedAccount: $topRankedAccount, addedCustomAccount: $addedCustomAccount, accountNote: $accountNote, albumSliver: $albumSliver, albumGridOrientation: $albumGridOrientation, albumGridAspectRatio: $albumGridAspectRatio, albumDensity: $albumDensity, unknownField: $unknownField)';
}


}

/// @nodoc
abstract mixin class _$AppPersistentStateCopyWith<$Res> implements $AppPersistentStateCopyWith<$Res> {
  factory _$AppPersistentStateCopyWith(_AppPersistentState value, $Res Function(_AppPersistentState) _then) = __$AppPersistentStateCopyWithImpl;
@override @useResult
$Res call({
 bool? isAgreeAgreement, bool? isInitialStartup, String? lang, int? theme, DeviceGameSession? selectedDeviceGame, List<DeviceGame>? pickedDeviceGame, List<DeviceGameAccount>? hiddenAccount, List<DeviceGameAccount>? starredAccount, List<DeviceGameAccount>? topRankedAccount, List<DeviceGameAccount>? addedCustomAccount, List<DeviceGameAccountNote>? accountNote, AlbumSliverType? albumSliver, AlbumGridOrientation? albumGridOrientation, AlbumGridAspectRatio? albumGridAspectRatio, AlbumDensity? albumDensity, Map<String, String> unknownField
});


@override $DeviceGameSessionCopyWith<$Res>? get selectedDeviceGame;

}
/// @nodoc
class __$AppPersistentStateCopyWithImpl<$Res>
    implements _$AppPersistentStateCopyWith<$Res> {
  __$AppPersistentStateCopyWithImpl(this._self, this._then);

  final _AppPersistentState _self;
  final $Res Function(_AppPersistentState) _then;

/// Create a copy of AppPersistentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAgreeAgreement = freezed,Object? isInitialStartup = freezed,Object? lang = freezed,Object? theme = freezed,Object? selectedDeviceGame = freezed,Object? pickedDeviceGame = freezed,Object? hiddenAccount = freezed,Object? starredAccount = freezed,Object? topRankedAccount = freezed,Object? addedCustomAccount = freezed,Object? accountNote = freezed,Object? albumSliver = freezed,Object? albumGridOrientation = freezed,Object? albumGridAspectRatio = freezed,Object? albumDensity = freezed,Object? unknownField = null,}) {
  return _then(_AppPersistentState(
isAgreeAgreement: freezed == isAgreeAgreement ? _self.isAgreeAgreement : isAgreeAgreement // ignore: cast_nullable_to_non_nullable
as bool?,isInitialStartup: freezed == isInitialStartup ? _self.isInitialStartup : isInitialStartup // ignore: cast_nullable_to_non_nullable
as bool?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as int?,selectedDeviceGame: freezed == selectedDeviceGame ? _self.selectedDeviceGame : selectedDeviceGame // ignore: cast_nullable_to_non_nullable
as DeviceGameSession?,pickedDeviceGame: freezed == pickedDeviceGame ? _self._pickedDeviceGame : pickedDeviceGame // ignore: cast_nullable_to_non_nullable
as List<DeviceGame>?,hiddenAccount: freezed == hiddenAccount ? _self._hiddenAccount : hiddenAccount // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccount>?,starredAccount: freezed == starredAccount ? _self._starredAccount : starredAccount // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccount>?,topRankedAccount: freezed == topRankedAccount ? _self._topRankedAccount : topRankedAccount // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccount>?,addedCustomAccount: freezed == addedCustomAccount ? _self._addedCustomAccount : addedCustomAccount // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccount>?,accountNote: freezed == accountNote ? _self._accountNote : accountNote // ignore: cast_nullable_to_non_nullable
as List<DeviceGameAccountNote>?,albumSliver: freezed == albumSliver ? _self.albumSliver : albumSliver // ignore: cast_nullable_to_non_nullable
as AlbumSliverType?,albumGridOrientation: freezed == albumGridOrientation ? _self.albumGridOrientation : albumGridOrientation // ignore: cast_nullable_to_non_nullable
as AlbumGridOrientation?,albumGridAspectRatio: freezed == albumGridAspectRatio ? _self.albumGridAspectRatio : albumGridAspectRatio // ignore: cast_nullable_to_non_nullable
as AlbumGridAspectRatio?,albumDensity: freezed == albumDensity ? _self.albumDensity : albumDensity // ignore: cast_nullable_to_non_nullable
as AlbumDensity?,unknownField: null == unknownField ? _self._unknownField : unknownField // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

/// Create a copy of AppPersistentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceGameSessionCopyWith<$Res>? get selectedDeviceGame {
    if (_self.selectedDeviceGame == null) {
    return null;
  }

  return $DeviceGameSessionCopyWith<$Res>(_self.selectedDeviceGame!, (value) {
    return _then(_self.copyWith(selectedDeviceGame: value));
  });
}
}

// dart format on
