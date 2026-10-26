// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TextRule {

 Object get field0;



@override
bool operator ==(Object other) {
  final _this = this as TextRule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextRule&&const DeepCollectionEquality().equals(other.field0, _this.field0));
}


@override
int get hashCode {
  final _this = this as TextRule;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.field0));
}

@override
String toString() {
  final _this = this as TextRule;
  return 'TextRule(field0: ${_this.field0})';
}


}

/// @nodoc
class $TextRuleCopyWith<$Res>  {
$TextRuleCopyWith(TextRule _, $Res Function(TextRule) __);
}


/// Adds pattern-matching-related methods to [TextRule].
extension TextRulePatterns on TextRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextRule_Literal value)?  literal,TResult Function( TextRule_Translate value)?  translate,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextRule_Literal() when literal != null:
return literal(_that);case TextRule_Translate() when translate != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextRule_Literal value)  literal,required TResult Function( TextRule_Translate value)  translate,}){
final _that = this;
switch (_that) {
case TextRule_Literal():
return literal(_that);case TextRule_Translate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextRule_Literal value)?  literal,TResult? Function( TextRule_Translate value)?  translate,}){
final _that = this;
switch (_that) {
case TextRule_Literal() when literal != null:
return literal(_that);case TextRule_Translate() when translate != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( LiteralTextRule field0)?  literal,TResult Function( TranslateTextRule field0)?  translate,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextRule_Literal() when literal != null:
return literal(_that.field0);case TextRule_Translate() when translate != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( LiteralTextRule field0)  literal,required TResult Function( TranslateTextRule field0)  translate,}) {final _that = this;
switch (_that) {
case TextRule_Literal():
return literal(_that.field0);case TextRule_Translate():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( LiteralTextRule field0)?  literal,TResult? Function( TranslateTextRule field0)?  translate,}) {final _that = this;
switch (_that) {
case TextRule_Literal() when literal != null:
return literal(_that.field0);case TextRule_Translate() when translate != null:
return translate(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class TextRule_Literal extends TextRule {
  const TextRule_Literal(this.field0): super._();
  

@override final  LiteralTextRule field0;

/// Create a copy of TextRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextRule_LiteralCopyWith<TextRule_Literal> get copyWith => _$TextRule_LiteralCopyWithImpl<TextRule_Literal>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TextRule_Literal&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'TextRule.literal(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $TextRule_LiteralCopyWith<$Res> implements $TextRuleCopyWith<$Res> {
  factory $TextRule_LiteralCopyWith(TextRule_Literal value, $Res Function(TextRule_Literal) _then) = _$TextRule_LiteralCopyWithImpl;
@useResult
$Res call({
 LiteralTextRule field0
});




}
/// @nodoc
class _$TextRule_LiteralCopyWithImpl<$Res>
    implements $TextRule_LiteralCopyWith<$Res> {
  _$TextRule_LiteralCopyWithImpl(this._self, this._then);

  final TextRule_Literal _self;
  final $Res Function(TextRule_Literal) _then;

/// Create a copy of TextRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(TextRule_Literal(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as LiteralTextRule,
  ));
}


}

/// @nodoc


class TextRule_Translate extends TextRule {
  const TextRule_Translate(this.field0): super._();
  

@override final  TranslateTextRule field0;

/// Create a copy of TextRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextRule_TranslateCopyWith<TextRule_Translate> get copyWith => _$TextRule_TranslateCopyWithImpl<TextRule_Translate>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TextRule_Translate&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'TextRule.translate(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $TextRule_TranslateCopyWith<$Res> implements $TextRuleCopyWith<$Res> {
  factory $TextRule_TranslateCopyWith(TextRule_Translate value, $Res Function(TextRule_Translate) _then) = _$TextRule_TranslateCopyWithImpl;
@useResult
$Res call({
 TranslateTextRule field0
});




}
/// @nodoc
class _$TextRule_TranslateCopyWithImpl<$Res>
    implements $TextRule_TranslateCopyWith<$Res> {
  _$TextRule_TranslateCopyWithImpl(this._self, this._then);

  final TextRule_Translate _self;
  final $Res Function(TextRule_Translate) _then;

/// Create a copy of TextRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(TextRule_Translate(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as TranslateTextRule,
  ));
}


}

// dart format on
