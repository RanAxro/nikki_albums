// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThemeConfigWrapper {

 ThemeConfigV1 get field0;
/// Create a copy of ThemeConfigWrapper
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeConfigWrapperCopyWith<ThemeConfigWrapper> get copyWith => _$ThemeConfigWrapperCopyWithImpl<ThemeConfigWrapper>(this as ThemeConfigWrapper, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeConfigWrapper&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ThemeConfigWrapper(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ThemeConfigWrapperCopyWith<$Res>  {
  factory $ThemeConfigWrapperCopyWith(ThemeConfigWrapper value, $Res Function(ThemeConfigWrapper) _then) = _$ThemeConfigWrapperCopyWithImpl;
@useResult
$Res call({
 ThemeConfigV1 field0
});




}
/// @nodoc
class _$ThemeConfigWrapperCopyWithImpl<$Res>
    implements $ThemeConfigWrapperCopyWith<$Res> {
  _$ThemeConfigWrapperCopyWithImpl(this._self, this._then);

  final ThemeConfigWrapper _self;
  final $Res Function(ThemeConfigWrapper) _then;

/// Create a copy of ThemeConfigWrapper
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field0 = null,}) {
  return _then(_self.copyWith(
field0: null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ThemeConfigV1,
  ));
}

}


/// Adds pattern-matching-related methods to [ThemeConfigWrapper].
extension ThemeConfigWrapperPatterns on ThemeConfigWrapper {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ThemeConfigWrapper_V1 value)?  v1,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ThemeConfigWrapper_V1() when v1 != null:
return v1(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ThemeConfigWrapper_V1 value)  v1,}){
final _that = this;
switch (_that) {
case ThemeConfigWrapper_V1():
return v1(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ThemeConfigWrapper_V1 value)?  v1,}){
final _that = this;
switch (_that) {
case ThemeConfigWrapper_V1() when v1 != null:
return v1(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ThemeConfigV1 field0)?  v1,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ThemeConfigWrapper_V1() when v1 != null:
return v1(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ThemeConfigV1 field0)  v1,}) {final _that = this;
switch (_that) {
case ThemeConfigWrapper_V1():
return v1(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ThemeConfigV1 field0)?  v1,}) {final _that = this;
switch (_that) {
case ThemeConfigWrapper_V1() when v1 != null:
return v1(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ThemeConfigWrapper_V1 extends ThemeConfigWrapper {
  const ThemeConfigWrapper_V1(this.field0): super._();
  

@override final  ThemeConfigV1 field0;

/// Create a copy of ThemeConfigWrapper
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeConfigWrapper_V1CopyWith<ThemeConfigWrapper_V1> get copyWith => _$ThemeConfigWrapper_V1CopyWithImpl<ThemeConfigWrapper_V1>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeConfigWrapper_V1&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ThemeConfigWrapper.v1(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ThemeConfigWrapper_V1CopyWith<$Res> implements $ThemeConfigWrapperCopyWith<$Res> {
  factory $ThemeConfigWrapper_V1CopyWith(ThemeConfigWrapper_V1 value, $Res Function(ThemeConfigWrapper_V1) _then) = _$ThemeConfigWrapper_V1CopyWithImpl;
@override @useResult
$Res call({
 ThemeConfigV1 field0
});




}
/// @nodoc
class _$ThemeConfigWrapper_V1CopyWithImpl<$Res>
    implements $ThemeConfigWrapper_V1CopyWith<$Res> {
  _$ThemeConfigWrapper_V1CopyWithImpl(this._self, this._then);

  final ThemeConfigWrapper_V1 _self;
  final $Res Function(ThemeConfigWrapper_V1) _then;

/// Create a copy of ThemeConfigWrapper
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ThemeConfigWrapper_V1(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ThemeConfigV1,
  ));
}


}

// dart format on
