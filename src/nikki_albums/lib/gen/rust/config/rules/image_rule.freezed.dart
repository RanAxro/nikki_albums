// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImageRule {

 Object get field0;



@override
bool operator ==(Object other) {
  final _this = this as ImageRule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageRule&&const DeepCollectionEquality().equals(other.field0, _this.field0));
}


@override
int get hashCode {
  final _this = this as ImageRule;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.field0));
}

@override
String toString() {
  final _this = this as ImageRule;
  return 'ImageRule(field0: ${_this.field0})';
}


}

/// @nodoc
class $ImageRuleCopyWith<$Res>  {
$ImageRuleCopyWith(ImageRule _, $Res Function(ImageRule) __);
}


/// Adds pattern-matching-related methods to [ImageRule].
extension ImageRulePatterns on ImageRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ImageRule_Icon value)?  icon,TResult Function( ImageRule_NGFS value)?  ngfs,TResult Function( ImageRule_Native value)?  native,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ImageRule_Icon() when icon != null:
return icon(_that);case ImageRule_NGFS() when ngfs != null:
return ngfs(_that);case ImageRule_Native() when native != null:
return native(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ImageRule_Icon value)  icon,required TResult Function( ImageRule_NGFS value)  ngfs,required TResult Function( ImageRule_Native value)  native,}){
final _that = this;
switch (_that) {
case ImageRule_Icon():
return icon(_that);case ImageRule_NGFS():
return ngfs(_that);case ImageRule_Native():
return native(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ImageRule_Icon value)?  icon,TResult? Function( ImageRule_NGFS value)?  ngfs,TResult? Function( ImageRule_Native value)?  native,}){
final _that = this;
switch (_that) {
case ImageRule_Icon() when icon != null:
return icon(_that);case ImageRule_NGFS() when ngfs != null:
return ngfs(_that);case ImageRule_Native() when native != null:
return native(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( IconImageRule field0)?  icon,TResult Function( NGFSImageRule field0)?  ngfs,TResult Function( NativeImageRule field0)?  native,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ImageRule_Icon() when icon != null:
return icon(_that.field0);case ImageRule_NGFS() when ngfs != null:
return ngfs(_that.field0);case ImageRule_Native() when native != null:
return native(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( IconImageRule field0)  icon,required TResult Function( NGFSImageRule field0)  ngfs,required TResult Function( NativeImageRule field0)  native,}) {final _that = this;
switch (_that) {
case ImageRule_Icon():
return icon(_that.field0);case ImageRule_NGFS():
return ngfs(_that.field0);case ImageRule_Native():
return native(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( IconImageRule field0)?  icon,TResult? Function( NGFSImageRule field0)?  ngfs,TResult? Function( NativeImageRule field0)?  native,}) {final _that = this;
switch (_that) {
case ImageRule_Icon() when icon != null:
return icon(_that.field0);case ImageRule_NGFS() when ngfs != null:
return ngfs(_that.field0);case ImageRule_Native() when native != null:
return native(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ImageRule_Icon extends ImageRule {
  const ImageRule_Icon(this.field0): super._();
  

@override final  IconImageRule field0;

/// Create a copy of ImageRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageRule_IconCopyWith<ImageRule_Icon> get copyWith => _$ImageRule_IconCopyWithImpl<ImageRule_Icon>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageRule_Icon&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'ImageRule.icon(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ImageRule_IconCopyWith<$Res> implements $ImageRuleCopyWith<$Res> {
  factory $ImageRule_IconCopyWith(ImageRule_Icon value, $Res Function(ImageRule_Icon) _then) = _$ImageRule_IconCopyWithImpl;
@useResult
$Res call({
 IconImageRule field0
});




}
/// @nodoc
class _$ImageRule_IconCopyWithImpl<$Res>
    implements $ImageRule_IconCopyWith<$Res> {
  _$ImageRule_IconCopyWithImpl(this._self, this._then);

  final ImageRule_Icon _self;
  final $Res Function(ImageRule_Icon) _then;

/// Create a copy of ImageRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ImageRule_Icon(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as IconImageRule,
  ));
}


}

/// @nodoc


class ImageRule_NGFS extends ImageRule {
  const ImageRule_NGFS(this.field0): super._();
  

@override final  NGFSImageRule field0;

/// Create a copy of ImageRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageRule_NGFSCopyWith<ImageRule_NGFS> get copyWith => _$ImageRule_NGFSCopyWithImpl<ImageRule_NGFS>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageRule_NGFS&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'ImageRule.ngfs(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ImageRule_NGFSCopyWith<$Res> implements $ImageRuleCopyWith<$Res> {
  factory $ImageRule_NGFSCopyWith(ImageRule_NGFS value, $Res Function(ImageRule_NGFS) _then) = _$ImageRule_NGFSCopyWithImpl;
@useResult
$Res call({
 NGFSImageRule field0
});




}
/// @nodoc
class _$ImageRule_NGFSCopyWithImpl<$Res>
    implements $ImageRule_NGFSCopyWith<$Res> {
  _$ImageRule_NGFSCopyWithImpl(this._self, this._then);

  final ImageRule_NGFS _self;
  final $Res Function(ImageRule_NGFS) _then;

/// Create a copy of ImageRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ImageRule_NGFS(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as NGFSImageRule,
  ));
}


}

/// @nodoc


class ImageRule_Native extends ImageRule {
  const ImageRule_Native(this.field0): super._();
  

@override final  NativeImageRule field0;

/// Create a copy of ImageRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageRule_NativeCopyWith<ImageRule_Native> get copyWith => _$ImageRule_NativeCopyWithImpl<ImageRule_Native>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageRule_Native&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'ImageRule.native(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ImageRule_NativeCopyWith<$Res> implements $ImageRuleCopyWith<$Res> {
  factory $ImageRule_NativeCopyWith(ImageRule_Native value, $Res Function(ImageRule_Native) _then) = _$ImageRule_NativeCopyWithImpl;
@useResult
$Res call({
 NativeImageRule field0
});




}
/// @nodoc
class _$ImageRule_NativeCopyWithImpl<$Res>
    implements $ImageRule_NativeCopyWith<$Res> {
  _$ImageRule_NativeCopyWithImpl(this._self, this._then);

  final ImageRule_Native _self;
  final $Res Function(ImageRule_Native) _then;

/// Create a copy of ImageRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ImageRule_Native(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as NativeImageRule,
  ));
}


}

// dart format on
