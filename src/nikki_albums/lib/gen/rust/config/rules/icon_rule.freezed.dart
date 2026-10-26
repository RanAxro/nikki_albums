// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IconRule {

 Object get field0;



@override
bool operator ==(Object other) {
  final _this = this as IconRule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IconRule&&const DeepCollectionEquality().equals(other.field0, _this.field0));
}


@override
int get hashCode {
  final _this = this as IconRule;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.field0));
}

@override
String toString() {
  final _this = this as IconRule;
  return 'IconRule(field0: ${_this.field0})';
}


}

/// @nodoc
class $IconRuleCopyWith<$Res>  {
$IconRuleCopyWith(IconRule _, $Res Function(IconRule) __);
}


/// Adds pattern-matching-related methods to [IconRule].
extension IconRulePatterns on IconRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( IconRule_Image value)?  image,TResult Function( IconRule_Font value)?  font,required TResult orElse(),}){
final _that = this;
switch (_that) {
case IconRule_Image() when image != null:
return image(_that);case IconRule_Font() when font != null:
return font(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( IconRule_Image value)  image,required TResult Function( IconRule_Font value)  font,}){
final _that = this;
switch (_that) {
case IconRule_Image():
return image(_that);case IconRule_Font():
return font(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( IconRule_Image value)?  image,TResult? Function( IconRule_Font value)?  font,}){
final _that = this;
switch (_that) {
case IconRule_Image() when image != null:
return image(_that);case IconRule_Font() when font != null:
return font(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ImageIconRule field0)?  image,TResult Function( FontIconRule field0)?  font,required TResult orElse(),}) {final _that = this;
switch (_that) {
case IconRule_Image() when image != null:
return image(_that.field0);case IconRule_Font() when font != null:
return font(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ImageIconRule field0)  image,required TResult Function( FontIconRule field0)  font,}) {final _that = this;
switch (_that) {
case IconRule_Image():
return image(_that.field0);case IconRule_Font():
return font(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ImageIconRule field0)?  image,TResult? Function( FontIconRule field0)?  font,}) {final _that = this;
switch (_that) {
case IconRule_Image() when image != null:
return image(_that.field0);case IconRule_Font() when font != null:
return font(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class IconRule_Image extends IconRule {
  const IconRule_Image(this.field0): super._();
  

@override final  ImageIconRule field0;

/// Create a copy of IconRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IconRule_ImageCopyWith<IconRule_Image> get copyWith => _$IconRule_ImageCopyWithImpl<IconRule_Image>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is IconRule_Image&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'IconRule.image(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $IconRule_ImageCopyWith<$Res> implements $IconRuleCopyWith<$Res> {
  factory $IconRule_ImageCopyWith(IconRule_Image value, $Res Function(IconRule_Image) _then) = _$IconRule_ImageCopyWithImpl;
@useResult
$Res call({
 ImageIconRule field0
});




}
/// @nodoc
class _$IconRule_ImageCopyWithImpl<$Res>
    implements $IconRule_ImageCopyWith<$Res> {
  _$IconRule_ImageCopyWithImpl(this._self, this._then);

  final IconRule_Image _self;
  final $Res Function(IconRule_Image) _then;

/// Create a copy of IconRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(IconRule_Image(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ImageIconRule,
  ));
}


}

/// @nodoc


class IconRule_Font extends IconRule {
  const IconRule_Font(this.field0): super._();
  

@override final  FontIconRule field0;

/// Create a copy of IconRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IconRule_FontCopyWith<IconRule_Font> get copyWith => _$IconRule_FontCopyWithImpl<IconRule_Font>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is IconRule_Font&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'IconRule.font(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $IconRule_FontCopyWith<$Res> implements $IconRuleCopyWith<$Res> {
  factory $IconRule_FontCopyWith(IconRule_Font value, $Res Function(IconRule_Font) _then) = _$IconRule_FontCopyWithImpl;
@useResult
$Res call({
 FontIconRule field0
});




}
/// @nodoc
class _$IconRule_FontCopyWithImpl<$Res>
    implements $IconRule_FontCopyWith<$Res> {
  _$IconRule_FontCopyWithImpl(this._self, this._then);

  final IconRule_Font _self;
  final $Res Function(IconRule_Font) _then;

/// Create a copy of IconRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(IconRule_Font(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as FontIconRule,
  ));
}


}

// dart format on
