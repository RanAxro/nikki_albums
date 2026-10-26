// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'string_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StringProcess {

 Object get field0;



@override
bool operator ==(Object other) {
  final _this = this as StringProcess;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcess&&const DeepCollectionEquality().equals(other.field0, _this.field0));
}


@override
int get hashCode {
  final _this = this as StringProcess;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.field0));
}

@override
String toString() {
  final _this = this as StringProcess;
  return 'StringProcess(field0: ${_this.field0})';
}


}

/// @nodoc
class $StringProcessCopyWith<$Res>  {
$StringProcessCopyWith(StringProcess _, $Res Function(StringProcess) __);
}


/// Adds pattern-matching-related methods to [StringProcess].
extension StringProcessPatterns on StringProcess {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StringProcess_Join value)?  join,TResult Function( StringProcess_Match value)?  match,TResult Function( StringProcess_Replace value)?  replace,TResult Function( StringProcess_ReplaceAll value)?  replaceAll,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StringProcess_Join() when join != null:
return join(_that);case StringProcess_Match() when match != null:
return match(_that);case StringProcess_Replace() when replace != null:
return replace(_that);case StringProcess_ReplaceAll() when replaceAll != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StringProcess_Join value)  join,required TResult Function( StringProcess_Match value)  match,required TResult Function( StringProcess_Replace value)  replace,required TResult Function( StringProcess_ReplaceAll value)  replaceAll,}){
final _that = this;
switch (_that) {
case StringProcess_Join():
return join(_that);case StringProcess_Match():
return match(_that);case StringProcess_Replace():
return replace(_that);case StringProcess_ReplaceAll():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StringProcess_Join value)?  join,TResult? Function( StringProcess_Match value)?  match,TResult? Function( StringProcess_Replace value)?  replace,TResult? Function( StringProcess_ReplaceAll value)?  replaceAll,}){
final _that = this;
switch (_that) {
case StringProcess_Join() when join != null:
return join(_that);case StringProcess_Match() when match != null:
return match(_that);case StringProcess_Replace() when replace != null:
return replace(_that);case StringProcess_ReplaceAll() when replaceAll != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( StringJoinProcess field0)?  join,TResult Function( StringMatchProcess field0)?  match,TResult Function( StringReplaceProcess field0)?  replace,TResult Function( StringReplaceAllProcess field0)?  replaceAll,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StringProcess_Join() when join != null:
return join(_that.field0);case StringProcess_Match() when match != null:
return match(_that.field0);case StringProcess_Replace() when replace != null:
return replace(_that.field0);case StringProcess_ReplaceAll() when replaceAll != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( StringJoinProcess field0)  join,required TResult Function( StringMatchProcess field0)  match,required TResult Function( StringReplaceProcess field0)  replace,required TResult Function( StringReplaceAllProcess field0)  replaceAll,}) {final _that = this;
switch (_that) {
case StringProcess_Join():
return join(_that.field0);case StringProcess_Match():
return match(_that.field0);case StringProcess_Replace():
return replace(_that.field0);case StringProcess_ReplaceAll():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( StringJoinProcess field0)?  join,TResult? Function( StringMatchProcess field0)?  match,TResult? Function( StringReplaceProcess field0)?  replace,TResult? Function( StringReplaceAllProcess field0)?  replaceAll,}) {final _that = this;
switch (_that) {
case StringProcess_Join() when join != null:
return join(_that.field0);case StringProcess_Match() when match != null:
return match(_that.field0);case StringProcess_Replace() when replace != null:
return replace(_that.field0);case StringProcess_ReplaceAll() when replaceAll != null:
return replaceAll(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class StringProcess_Join extends StringProcess {
  const StringProcess_Join(this.field0): super._();
  

@override final  StringJoinProcess field0;

/// Create a copy of StringProcess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringProcess_JoinCopyWith<StringProcess_Join> get copyWith => _$StringProcess_JoinCopyWithImpl<StringProcess_Join>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcess_Join&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'StringProcess.join(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StringProcess_JoinCopyWith<$Res> implements $StringProcessCopyWith<$Res> {
  factory $StringProcess_JoinCopyWith(StringProcess_Join value, $Res Function(StringProcess_Join) _then) = _$StringProcess_JoinCopyWithImpl;
@useResult
$Res call({
 StringJoinProcess field0
});




}
/// @nodoc
class _$StringProcess_JoinCopyWithImpl<$Res>
    implements $StringProcess_JoinCopyWith<$Res> {
  _$StringProcess_JoinCopyWithImpl(this._self, this._then);

  final StringProcess_Join _self;
  final $Res Function(StringProcess_Join) _then;

/// Create a copy of StringProcess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StringProcess_Join(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StringJoinProcess,
  ));
}


}

/// @nodoc


class StringProcess_Match extends StringProcess {
  const StringProcess_Match(this.field0): super._();
  

@override final  StringMatchProcess field0;

/// Create a copy of StringProcess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringProcess_MatchCopyWith<StringProcess_Match> get copyWith => _$StringProcess_MatchCopyWithImpl<StringProcess_Match>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcess_Match&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'StringProcess.match(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StringProcess_MatchCopyWith<$Res> implements $StringProcessCopyWith<$Res> {
  factory $StringProcess_MatchCopyWith(StringProcess_Match value, $Res Function(StringProcess_Match) _then) = _$StringProcess_MatchCopyWithImpl;
@useResult
$Res call({
 StringMatchProcess field0
});




}
/// @nodoc
class _$StringProcess_MatchCopyWithImpl<$Res>
    implements $StringProcess_MatchCopyWith<$Res> {
  _$StringProcess_MatchCopyWithImpl(this._self, this._then);

  final StringProcess_Match _self;
  final $Res Function(StringProcess_Match) _then;

/// Create a copy of StringProcess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StringProcess_Match(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StringMatchProcess,
  ));
}


}

/// @nodoc


class StringProcess_Replace extends StringProcess {
  const StringProcess_Replace(this.field0): super._();
  

@override final  StringReplaceProcess field0;

/// Create a copy of StringProcess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringProcess_ReplaceCopyWith<StringProcess_Replace> get copyWith => _$StringProcess_ReplaceCopyWithImpl<StringProcess_Replace>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcess_Replace&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'StringProcess.replace(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StringProcess_ReplaceCopyWith<$Res> implements $StringProcessCopyWith<$Res> {
  factory $StringProcess_ReplaceCopyWith(StringProcess_Replace value, $Res Function(StringProcess_Replace) _then) = _$StringProcess_ReplaceCopyWithImpl;
@useResult
$Res call({
 StringReplaceProcess field0
});




}
/// @nodoc
class _$StringProcess_ReplaceCopyWithImpl<$Res>
    implements $StringProcess_ReplaceCopyWith<$Res> {
  _$StringProcess_ReplaceCopyWithImpl(this._self, this._then);

  final StringProcess_Replace _self;
  final $Res Function(StringProcess_Replace) _then;

/// Create a copy of StringProcess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StringProcess_Replace(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StringReplaceProcess,
  ));
}


}

/// @nodoc


class StringProcess_ReplaceAll extends StringProcess {
  const StringProcess_ReplaceAll(this.field0): super._();
  

@override final  StringReplaceAllProcess field0;

/// Create a copy of StringProcess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringProcess_ReplaceAllCopyWith<StringProcess_ReplaceAll> get copyWith => _$StringProcess_ReplaceAllCopyWithImpl<StringProcess_ReplaceAll>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProcess_ReplaceAll&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'StringProcess.replaceAll(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StringProcess_ReplaceAllCopyWith<$Res> implements $StringProcessCopyWith<$Res> {
  factory $StringProcess_ReplaceAllCopyWith(StringProcess_ReplaceAll value, $Res Function(StringProcess_ReplaceAll) _then) = _$StringProcess_ReplaceAllCopyWithImpl;
@useResult
$Res call({
 StringReplaceAllProcess field0
});




}
/// @nodoc
class _$StringProcess_ReplaceAllCopyWithImpl<$Res>
    implements $StringProcess_ReplaceAllCopyWith<$Res> {
  _$StringProcess_ReplaceAllCopyWithImpl(this._self, this._then);

  final StringProcess_ReplaceAll _self;
  final $Res Function(StringProcess_ReplaceAll) _then;

/// Create a copy of StringProcess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StringProcess_ReplaceAll(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StringReplaceAllProcess,
  ));
}


}

// dart format on
