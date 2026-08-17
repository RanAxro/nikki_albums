// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_persistent_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppPersistentState {

 bool? get isAgreeAgreement; bool? get isInitialStartup; String? get lang; int? get theme; Map<String, String> get unknownField;
/// Create a copy of AppPersistentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppPersistentStateCopyWith<AppPersistentState> get copyWith => _$AppPersistentStateCopyWithImpl<AppPersistentState>(this as AppPersistentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppPersistentState&&(identical(other.isAgreeAgreement, isAgreeAgreement) || other.isAgreeAgreement == isAgreeAgreement)&&(identical(other.isInitialStartup, isInitialStartup) || other.isInitialStartup == isInitialStartup)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.theme, theme) || other.theme == theme)&&const DeepCollectionEquality().equals(other.unknownField, unknownField));
}


@override
int get hashCode => Object.hash(runtimeType,isAgreeAgreement,isInitialStartup,lang,theme,const DeepCollectionEquality().hash(unknownField));

@override
String toString() {
  return 'AppPersistentState(isAgreeAgreement: $isAgreeAgreement, isInitialStartup: $isInitialStartup, lang: $lang, theme: $theme, unknownField: $unknownField)';
}


}

/// @nodoc
abstract mixin class $AppPersistentStateCopyWith<$Res>  {
  factory $AppPersistentStateCopyWith(AppPersistentState value, $Res Function(AppPersistentState) _then) = _$AppPersistentStateCopyWithImpl;
@useResult
$Res call({
 bool? isAgreeAgreement, bool? isInitialStartup, String? lang, int? theme, Map<String, String> unknownField
});




}
/// @nodoc
class _$AppPersistentStateCopyWithImpl<$Res>
    implements $AppPersistentStateCopyWith<$Res> {
  _$AppPersistentStateCopyWithImpl(this._self, this._then);

  final AppPersistentState _self;
  final $Res Function(AppPersistentState) _then;

/// Create a copy of AppPersistentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAgreeAgreement = freezed,Object? isInitialStartup = freezed,Object? lang = freezed,Object? theme = freezed,Object? unknownField = null,}) {
  return _then(_self.copyWith(
isAgreeAgreement: freezed == isAgreeAgreement ? _self.isAgreeAgreement : isAgreeAgreement // ignore: cast_nullable_to_non_nullable
as bool?,isInitialStartup: freezed == isInitialStartup ? _self.isInitialStartup : isInitialStartup // ignore: cast_nullable_to_non_nullable
as bool?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as int?,unknownField: null == unknownField ? _self.unknownField : unknownField // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isAgreeAgreement,  bool? isInitialStartup,  String? lang,  int? theme,  Map<String, String> unknownField)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppPersistentState() when $default != null:
return $default(_that.isAgreeAgreement,_that.isInitialStartup,_that.lang,_that.theme,_that.unknownField);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isAgreeAgreement,  bool? isInitialStartup,  String? lang,  int? theme,  Map<String, String> unknownField)  $default,) {final _that = this;
switch (_that) {
case _AppPersistentState():
return $default(_that.isAgreeAgreement,_that.isInitialStartup,_that.lang,_that.theme,_that.unknownField);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isAgreeAgreement,  bool? isInitialStartup,  String? lang,  int? theme,  Map<String, String> unknownField)?  $default,) {final _that = this;
switch (_that) {
case _AppPersistentState() when $default != null:
return $default(_that.isAgreeAgreement,_that.isInitialStartup,_that.lang,_that.theme,_that.unknownField);case _:
  return null;

}
}

}

/// @nodoc


class _AppPersistentState extends AppPersistentState {
  const _AppPersistentState({this.isAgreeAgreement, this.isInitialStartup, this.lang, this.theme, required final  Map<String, String> unknownField}): _unknownField = unknownField,super._();
  

@override final  bool? isAgreeAgreement;
@override final  bool? isInitialStartup;
@override final  String? lang;
@override final  int? theme;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppPersistentState&&(identical(other.isAgreeAgreement, isAgreeAgreement) || other.isAgreeAgreement == isAgreeAgreement)&&(identical(other.isInitialStartup, isInitialStartup) || other.isInitialStartup == isInitialStartup)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.theme, theme) || other.theme == theme)&&const DeepCollectionEquality().equals(other._unknownField, _unknownField));
}


@override
int get hashCode => Object.hash(runtimeType,isAgreeAgreement,isInitialStartup,lang,theme,const DeepCollectionEquality().hash(_unknownField));

@override
String toString() {
  return 'AppPersistentState(isAgreeAgreement: $isAgreeAgreement, isInitialStartup: $isInitialStartup, lang: $lang, theme: $theme, unknownField: $unknownField)';
}


}

/// @nodoc
abstract mixin class _$AppPersistentStateCopyWith<$Res> implements $AppPersistentStateCopyWith<$Res> {
  factory _$AppPersistentStateCopyWith(_AppPersistentState value, $Res Function(_AppPersistentState) _then) = __$AppPersistentStateCopyWithImpl;
@override @useResult
$Res call({
 bool? isAgreeAgreement, bool? isInitialStartup, String? lang, int? theme, Map<String, String> unknownField
});




}
/// @nodoc
class __$AppPersistentStateCopyWithImpl<$Res>
    implements _$AppPersistentStateCopyWith<$Res> {
  __$AppPersistentStateCopyWithImpl(this._self, this._then);

  final _AppPersistentState _self;
  final $Res Function(_AppPersistentState) _then;

/// Create a copy of AppPersistentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAgreeAgreement = freezed,Object? isInitialStartup = freezed,Object? lang = freezed,Object? theme = freezed,Object? unknownField = null,}) {
  return _then(_AppPersistentState(
isAgreeAgreement: freezed == isAgreeAgreement ? _self.isAgreeAgreement : isAgreeAgreement // ignore: cast_nullable_to_non_nullable
as bool?,isInitialStartup: freezed == isInitialStartup ? _self.isInitialStartup : isInitialStartup // ignore: cast_nullable_to_non_nullable
as bool?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as int?,unknownField: null == unknownField ? _self._unknownField : unknownField // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
