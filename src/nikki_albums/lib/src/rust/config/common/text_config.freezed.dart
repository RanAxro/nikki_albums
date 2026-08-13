// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TextConfig {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextConfig&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'TextConfig(field0: $field0)';
}


}

/// @nodoc
class $TextConfigCopyWith<$Res>  {
$TextConfigCopyWith(TextConfig _, $Res Function(TextConfig) __);
}


/// Adds pattern-matching-related methods to [TextConfig].
extension TextConfigPatterns on TextConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextConfig_Literal value)?  literal,TResult Function( TextConfig_Translate value)?  translate,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextConfig_Literal() when literal != null:
return literal(_that);case TextConfig_Translate() when translate != null:
return translate(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextConfig_Literal value)  literal,required TResult Function( TextConfig_Translate value)  translate,}){
final _that = this;
switch (_that) {
case TextConfig_Literal():
return literal(_that);case TextConfig_Translate():
return translate(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextConfig_Literal value)?  literal,TResult? Function( TextConfig_Translate value)?  translate,}){
final _that = this;
switch (_that) {
case TextConfig_Literal() when literal != null:
return literal(_that);case TextConfig_Translate() when translate != null:
return translate(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( LiteralTextConfig field0)?  literal,TResult Function( TranslateTextConfig field0)?  translate,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextConfig_Literal() when literal != null:
return literal(_that.field0);case TextConfig_Translate() when translate != null:
return translate(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( LiteralTextConfig field0)  literal,required TResult Function( TranslateTextConfig field0)  translate,}) {final _that = this;
switch (_that) {
case TextConfig_Literal():
return literal(_that.field0);case TextConfig_Translate():
return translate(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( LiteralTextConfig field0)?  literal,TResult? Function( TranslateTextConfig field0)?  translate,}) {final _that = this;
switch (_that) {
case TextConfig_Literal() when literal != null:
return literal(_that.field0);case TextConfig_Translate() when translate != null:
return translate(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class TextConfig_Literal extends TextConfig {
  const TextConfig_Literal(this.field0): super._();
  

@override final  LiteralTextConfig field0;

/// Create a copy of TextConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextConfig_LiteralCopyWith<TextConfig_Literal> get copyWith => _$TextConfig_LiteralCopyWithImpl<TextConfig_Literal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextConfig_Literal&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'TextConfig.literal(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $TextConfig_LiteralCopyWith<$Res> implements $TextConfigCopyWith<$Res> {
  factory $TextConfig_LiteralCopyWith(TextConfig_Literal value, $Res Function(TextConfig_Literal) _then) = _$TextConfig_LiteralCopyWithImpl;
@useResult
$Res call({
 LiteralTextConfig field0
});




}
/// @nodoc
class _$TextConfig_LiteralCopyWithImpl<$Res>
    implements $TextConfig_LiteralCopyWith<$Res> {
  _$TextConfig_LiteralCopyWithImpl(this._self, this._then);

  final TextConfig_Literal _self;
  final $Res Function(TextConfig_Literal) _then;

/// Create a copy of TextConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(TextConfig_Literal(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as LiteralTextConfig,
  ));
}


}

/// @nodoc


class TextConfig_Translate extends TextConfig {
  const TextConfig_Translate(this.field0): super._();
  

@override final  TranslateTextConfig field0;

/// Create a copy of TextConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextConfig_TranslateCopyWith<TextConfig_Translate> get copyWith => _$TextConfig_TranslateCopyWithImpl<TextConfig_Translate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextConfig_Translate&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'TextConfig.translate(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $TextConfig_TranslateCopyWith<$Res> implements $TextConfigCopyWith<$Res> {
  factory $TextConfig_TranslateCopyWith(TextConfig_Translate value, $Res Function(TextConfig_Translate) _then) = _$TextConfig_TranslateCopyWithImpl;
@useResult
$Res call({
 TranslateTextConfig field0
});




}
/// @nodoc
class _$TextConfig_TranslateCopyWithImpl<$Res>
    implements $TextConfig_TranslateCopyWith<$Res> {
  _$TextConfig_TranslateCopyWithImpl(this._self, this._then);

  final TextConfig_Translate _self;
  final $Res Function(TextConfig_Translate) _then;

/// Create a copy of TextConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(TextConfig_Translate(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as TranslateTextConfig,
  ));
}


}

// dart format on
