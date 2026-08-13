// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'string_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StringProcessConfig {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcessConfig&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'StringProcessConfig(field0: $field0)';
}


}

/// @nodoc
class $StringProcessConfigCopyWith<$Res>  {
$StringProcessConfigCopyWith(StringProcessConfig _, $Res Function(StringProcessConfig) __);
}


/// Adds pattern-matching-related methods to [StringProcessConfig].
extension StringProcessConfigPatterns on StringProcessConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StringProcessConfig_Join value)?  join,TResult Function( StringProcessConfig_Match value)?  match,TResult Function( StringProcessConfig_Replace value)?  replace,TResult Function( StringProcessConfig_ReplaceAll value)?  replaceAll,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StringProcessConfig_Join() when join != null:
return join(_that);case StringProcessConfig_Match() when match != null:
return match(_that);case StringProcessConfig_Replace() when replace != null:
return replace(_that);case StringProcessConfig_ReplaceAll() when replaceAll != null:
return replaceAll(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StringProcessConfig_Join value)  join,required TResult Function( StringProcessConfig_Match value)  match,required TResult Function( StringProcessConfig_Replace value)  replace,required TResult Function( StringProcessConfig_ReplaceAll value)  replaceAll,}){
final _that = this;
switch (_that) {
case StringProcessConfig_Join():
return join(_that);case StringProcessConfig_Match():
return match(_that);case StringProcessConfig_Replace():
return replace(_that);case StringProcessConfig_ReplaceAll():
return replaceAll(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StringProcessConfig_Join value)?  join,TResult? Function( StringProcessConfig_Match value)?  match,TResult? Function( StringProcessConfig_Replace value)?  replace,TResult? Function( StringProcessConfig_ReplaceAll value)?  replaceAll,}){
final _that = this;
switch (_that) {
case StringProcessConfig_Join() when join != null:
return join(_that);case StringProcessConfig_Match() when match != null:
return match(_that);case StringProcessConfig_Replace() when replace != null:
return replace(_that);case StringProcessConfig_ReplaceAll() when replaceAll != null:
return replaceAll(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( StringJoinProcessConfig field0)?  join,TResult Function( StringMatchProcessConfig field0)?  match,TResult Function( StringReplaceProcessConfig field0)?  replace,TResult Function( StringReplaceAllProcessConfig field0)?  replaceAll,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StringProcessConfig_Join() when join != null:
return join(_that.field0);case StringProcessConfig_Match() when match != null:
return match(_that.field0);case StringProcessConfig_Replace() when replace != null:
return replace(_that.field0);case StringProcessConfig_ReplaceAll() when replaceAll != null:
return replaceAll(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( StringJoinProcessConfig field0)  join,required TResult Function( StringMatchProcessConfig field0)  match,required TResult Function( StringReplaceProcessConfig field0)  replace,required TResult Function( StringReplaceAllProcessConfig field0)  replaceAll,}) {final _that = this;
switch (_that) {
case StringProcessConfig_Join():
return join(_that.field0);case StringProcessConfig_Match():
return match(_that.field0);case StringProcessConfig_Replace():
return replace(_that.field0);case StringProcessConfig_ReplaceAll():
return replaceAll(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( StringJoinProcessConfig field0)?  join,TResult? Function( StringMatchProcessConfig field0)?  match,TResult? Function( StringReplaceProcessConfig field0)?  replace,TResult? Function( StringReplaceAllProcessConfig field0)?  replaceAll,}) {final _that = this;
switch (_that) {
case StringProcessConfig_Join() when join != null:
return join(_that.field0);case StringProcessConfig_Match() when match != null:
return match(_that.field0);case StringProcessConfig_Replace() when replace != null:
return replace(_that.field0);case StringProcessConfig_ReplaceAll() when replaceAll != null:
return replaceAll(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class StringProcessConfig_Join extends StringProcessConfig {
  const StringProcessConfig_Join(this.field0): super._();
  

@override final  StringJoinProcessConfig field0;

/// Create a copy of StringProcessConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringProcessConfig_JoinCopyWith<StringProcessConfig_Join> get copyWith => _$StringProcessConfig_JoinCopyWithImpl<StringProcessConfig_Join>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcessConfig_Join&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StringProcessConfig.join(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StringProcessConfig_JoinCopyWith<$Res> implements $StringProcessConfigCopyWith<$Res> {
  factory $StringProcessConfig_JoinCopyWith(StringProcessConfig_Join value, $Res Function(StringProcessConfig_Join) _then) = _$StringProcessConfig_JoinCopyWithImpl;
@useResult
$Res call({
 StringJoinProcessConfig field0
});




}
/// @nodoc
class _$StringProcessConfig_JoinCopyWithImpl<$Res>
    implements $StringProcessConfig_JoinCopyWith<$Res> {
  _$StringProcessConfig_JoinCopyWithImpl(this._self, this._then);

  final StringProcessConfig_Join _self;
  final $Res Function(StringProcessConfig_Join) _then;

/// Create a copy of StringProcessConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StringProcessConfig_Join(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StringJoinProcessConfig,
  ));
}


}

/// @nodoc


class StringProcessConfig_Match extends StringProcessConfig {
  const StringProcessConfig_Match(this.field0): super._();
  

@override final  StringMatchProcessConfig field0;

/// Create a copy of StringProcessConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringProcessConfig_MatchCopyWith<StringProcessConfig_Match> get copyWith => _$StringProcessConfig_MatchCopyWithImpl<StringProcessConfig_Match>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcessConfig_Match&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StringProcessConfig.match(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StringProcessConfig_MatchCopyWith<$Res> implements $StringProcessConfigCopyWith<$Res> {
  factory $StringProcessConfig_MatchCopyWith(StringProcessConfig_Match value, $Res Function(StringProcessConfig_Match) _then) = _$StringProcessConfig_MatchCopyWithImpl;
@useResult
$Res call({
 StringMatchProcessConfig field0
});




}
/// @nodoc
class _$StringProcessConfig_MatchCopyWithImpl<$Res>
    implements $StringProcessConfig_MatchCopyWith<$Res> {
  _$StringProcessConfig_MatchCopyWithImpl(this._self, this._then);

  final StringProcessConfig_Match _self;
  final $Res Function(StringProcessConfig_Match) _then;

/// Create a copy of StringProcessConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StringProcessConfig_Match(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StringMatchProcessConfig,
  ));
}


}

/// @nodoc


class StringProcessConfig_Replace extends StringProcessConfig {
  const StringProcessConfig_Replace(this.field0): super._();
  

@override final  StringReplaceProcessConfig field0;

/// Create a copy of StringProcessConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringProcessConfig_ReplaceCopyWith<StringProcessConfig_Replace> get copyWith => _$StringProcessConfig_ReplaceCopyWithImpl<StringProcessConfig_Replace>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcessConfig_Replace&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StringProcessConfig.replace(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StringProcessConfig_ReplaceCopyWith<$Res> implements $StringProcessConfigCopyWith<$Res> {
  factory $StringProcessConfig_ReplaceCopyWith(StringProcessConfig_Replace value, $Res Function(StringProcessConfig_Replace) _then) = _$StringProcessConfig_ReplaceCopyWithImpl;
@useResult
$Res call({
 StringReplaceProcessConfig field0
});




}
/// @nodoc
class _$StringProcessConfig_ReplaceCopyWithImpl<$Res>
    implements $StringProcessConfig_ReplaceCopyWith<$Res> {
  _$StringProcessConfig_ReplaceCopyWithImpl(this._self, this._then);

  final StringProcessConfig_Replace _self;
  final $Res Function(StringProcessConfig_Replace) _then;

/// Create a copy of StringProcessConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StringProcessConfig_Replace(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StringReplaceProcessConfig,
  ));
}


}

/// @nodoc


class StringProcessConfig_ReplaceAll extends StringProcessConfig {
  const StringProcessConfig_ReplaceAll(this.field0): super._();
  

@override final  StringReplaceAllProcessConfig field0;

/// Create a copy of StringProcessConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringProcessConfig_ReplaceAllCopyWith<StringProcessConfig_ReplaceAll> get copyWith => _$StringProcessConfig_ReplaceAllCopyWithImpl<StringProcessConfig_ReplaceAll>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcessConfig_ReplaceAll&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StringProcessConfig.replaceAll(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StringProcessConfig_ReplaceAllCopyWith<$Res> implements $StringProcessConfigCopyWith<$Res> {
  factory $StringProcessConfig_ReplaceAllCopyWith(StringProcessConfig_ReplaceAll value, $Res Function(StringProcessConfig_ReplaceAll) _then) = _$StringProcessConfig_ReplaceAllCopyWithImpl;
@useResult
$Res call({
 StringReplaceAllProcessConfig field0
});




}
/// @nodoc
class _$StringProcessConfig_ReplaceAllCopyWithImpl<$Res>
    implements $StringProcessConfig_ReplaceAllCopyWith<$Res> {
  _$StringProcessConfig_ReplaceAllCopyWithImpl(this._self, this._then);

  final StringProcessConfig_ReplaceAll _self;
  final $Res Function(StringProcessConfig_ReplaceAll) _then;

/// Create a copy of StringProcessConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StringProcessConfig_ReplaceAll(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StringReplaceAllProcessConfig,
  ));
}


}

// dart format on
