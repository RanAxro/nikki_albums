// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Nuan5DatabaseItem {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nuan5DatabaseItem&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'Nuan5DatabaseItem(field0: $field0)';
}


}

/// @nodoc
class $Nuan5DatabaseItemCopyWith<$Res>  {
$Nuan5DatabaseItemCopyWith(Nuan5DatabaseItem _, $Res Function(Nuan5DatabaseItem) __);
}


/// Adds pattern-matching-related methods to [Nuan5DatabaseItem].
extension Nuan5DatabaseItemPatterns on Nuan5DatabaseItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Nuan5DatabaseItem_Light value)?  light,TResult Function( Nuan5DatabaseItem_LightType value)?  lightType,TResult Function( Nuan5DatabaseItem_Filter value)?  filter,TResult Function( Nuan5DatabaseItem_FilterType value)?  filterType,TResult Function( Nuan5DatabaseItem_MomoPose value)?  momoPose,TResult Function( Nuan5DatabaseItem_ClothDyeArea value)?  clothDyeArea,TResult Function( Nuan5DatabaseItem_ClothDyePalette value)?  clothDyePalette,TResult Function( Nuan5DatabaseItem_ClothDiySwatchColor value)?  clothDiySwatchColor,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Nuan5DatabaseItem_Light() when light != null:
return light(_that);case Nuan5DatabaseItem_LightType() when lightType != null:
return lightType(_that);case Nuan5DatabaseItem_Filter() when filter != null:
return filter(_that);case Nuan5DatabaseItem_FilterType() when filterType != null:
return filterType(_that);case Nuan5DatabaseItem_MomoPose() when momoPose != null:
return momoPose(_that);case Nuan5DatabaseItem_ClothDyeArea() when clothDyeArea != null:
return clothDyeArea(_that);case Nuan5DatabaseItem_ClothDyePalette() when clothDyePalette != null:
return clothDyePalette(_that);case Nuan5DatabaseItem_ClothDiySwatchColor() when clothDiySwatchColor != null:
return clothDiySwatchColor(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Nuan5DatabaseItem_Light value)  light,required TResult Function( Nuan5DatabaseItem_LightType value)  lightType,required TResult Function( Nuan5DatabaseItem_Filter value)  filter,required TResult Function( Nuan5DatabaseItem_FilterType value)  filterType,required TResult Function( Nuan5DatabaseItem_MomoPose value)  momoPose,required TResult Function( Nuan5DatabaseItem_ClothDyeArea value)  clothDyeArea,required TResult Function( Nuan5DatabaseItem_ClothDyePalette value)  clothDyePalette,required TResult Function( Nuan5DatabaseItem_ClothDiySwatchColor value)  clothDiySwatchColor,}){
final _that = this;
switch (_that) {
case Nuan5DatabaseItem_Light():
return light(_that);case Nuan5DatabaseItem_LightType():
return lightType(_that);case Nuan5DatabaseItem_Filter():
return filter(_that);case Nuan5DatabaseItem_FilterType():
return filterType(_that);case Nuan5DatabaseItem_MomoPose():
return momoPose(_that);case Nuan5DatabaseItem_ClothDyeArea():
return clothDyeArea(_that);case Nuan5DatabaseItem_ClothDyePalette():
return clothDyePalette(_that);case Nuan5DatabaseItem_ClothDiySwatchColor():
return clothDiySwatchColor(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Nuan5DatabaseItem_Light value)?  light,TResult? Function( Nuan5DatabaseItem_LightType value)?  lightType,TResult? Function( Nuan5DatabaseItem_Filter value)?  filter,TResult? Function( Nuan5DatabaseItem_FilterType value)?  filterType,TResult? Function( Nuan5DatabaseItem_MomoPose value)?  momoPose,TResult? Function( Nuan5DatabaseItem_ClothDyeArea value)?  clothDyeArea,TResult? Function( Nuan5DatabaseItem_ClothDyePalette value)?  clothDyePalette,TResult? Function( Nuan5DatabaseItem_ClothDiySwatchColor value)?  clothDiySwatchColor,}){
final _that = this;
switch (_that) {
case Nuan5DatabaseItem_Light() when light != null:
return light(_that);case Nuan5DatabaseItem_LightType() when lightType != null:
return lightType(_that);case Nuan5DatabaseItem_Filter() when filter != null:
return filter(_that);case Nuan5DatabaseItem_FilterType() when filterType != null:
return filterType(_that);case Nuan5DatabaseItem_MomoPose() when momoPose != null:
return momoPose(_that);case Nuan5DatabaseItem_ClothDyeArea() when clothDyeArea != null:
return clothDyeArea(_that);case Nuan5DatabaseItem_ClothDyePalette() when clothDyePalette != null:
return clothDyePalette(_that);case Nuan5DatabaseItem_ClothDiySwatchColor() when clothDiySwatchColor != null:
return clothDiySwatchColor(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Nuan5Light field0)?  light,TResult Function( Nuan5LightType field0)?  lightType,TResult Function( Nuan5Filter field0)?  filter,TResult Function( Nuan5FilterType field0)?  filterType,TResult Function( Nuan5MomoPose field0)?  momoPose,TResult Function( Nuan5ClothDyeArea field0)?  clothDyeArea,TResult Function( Nuan5ClothDyePalette field0)?  clothDyePalette,TResult Function( Nuan5ClothDiySwatchColor field0)?  clothDiySwatchColor,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Nuan5DatabaseItem_Light() when light != null:
return light(_that.field0);case Nuan5DatabaseItem_LightType() when lightType != null:
return lightType(_that.field0);case Nuan5DatabaseItem_Filter() when filter != null:
return filter(_that.field0);case Nuan5DatabaseItem_FilterType() when filterType != null:
return filterType(_that.field0);case Nuan5DatabaseItem_MomoPose() when momoPose != null:
return momoPose(_that.field0);case Nuan5DatabaseItem_ClothDyeArea() when clothDyeArea != null:
return clothDyeArea(_that.field0);case Nuan5DatabaseItem_ClothDyePalette() when clothDyePalette != null:
return clothDyePalette(_that.field0);case Nuan5DatabaseItem_ClothDiySwatchColor() when clothDiySwatchColor != null:
return clothDiySwatchColor(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Nuan5Light field0)  light,required TResult Function( Nuan5LightType field0)  lightType,required TResult Function( Nuan5Filter field0)  filter,required TResult Function( Nuan5FilterType field0)  filterType,required TResult Function( Nuan5MomoPose field0)  momoPose,required TResult Function( Nuan5ClothDyeArea field0)  clothDyeArea,required TResult Function( Nuan5ClothDyePalette field0)  clothDyePalette,required TResult Function( Nuan5ClothDiySwatchColor field0)  clothDiySwatchColor,}) {final _that = this;
switch (_that) {
case Nuan5DatabaseItem_Light():
return light(_that.field0);case Nuan5DatabaseItem_LightType():
return lightType(_that.field0);case Nuan5DatabaseItem_Filter():
return filter(_that.field0);case Nuan5DatabaseItem_FilterType():
return filterType(_that.field0);case Nuan5DatabaseItem_MomoPose():
return momoPose(_that.field0);case Nuan5DatabaseItem_ClothDyeArea():
return clothDyeArea(_that.field0);case Nuan5DatabaseItem_ClothDyePalette():
return clothDyePalette(_that.field0);case Nuan5DatabaseItem_ClothDiySwatchColor():
return clothDiySwatchColor(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Nuan5Light field0)?  light,TResult? Function( Nuan5LightType field0)?  lightType,TResult? Function( Nuan5Filter field0)?  filter,TResult? Function( Nuan5FilterType field0)?  filterType,TResult? Function( Nuan5MomoPose field0)?  momoPose,TResult? Function( Nuan5ClothDyeArea field0)?  clothDyeArea,TResult? Function( Nuan5ClothDyePalette field0)?  clothDyePalette,TResult? Function( Nuan5ClothDiySwatchColor field0)?  clothDiySwatchColor,}) {final _that = this;
switch (_that) {
case Nuan5DatabaseItem_Light() when light != null:
return light(_that.field0);case Nuan5DatabaseItem_LightType() when lightType != null:
return lightType(_that.field0);case Nuan5DatabaseItem_Filter() when filter != null:
return filter(_that.field0);case Nuan5DatabaseItem_FilterType() when filterType != null:
return filterType(_that.field0);case Nuan5DatabaseItem_MomoPose() when momoPose != null:
return momoPose(_that.field0);case Nuan5DatabaseItem_ClothDyeArea() when clothDyeArea != null:
return clothDyeArea(_that.field0);case Nuan5DatabaseItem_ClothDyePalette() when clothDyePalette != null:
return clothDyePalette(_that.field0);case Nuan5DatabaseItem_ClothDiySwatchColor() when clothDiySwatchColor != null:
return clothDiySwatchColor(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class Nuan5DatabaseItem_Light extends Nuan5DatabaseItem {
  const Nuan5DatabaseItem_Light(this.field0): super._();
  

@override final  Nuan5Light field0;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Nuan5DatabaseItem_LightCopyWith<Nuan5DatabaseItem_Light> get copyWith => _$Nuan5DatabaseItem_LightCopyWithImpl<Nuan5DatabaseItem_Light>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nuan5DatabaseItem_Light&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Nuan5DatabaseItem.light(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Nuan5DatabaseItem_LightCopyWith<$Res> implements $Nuan5DatabaseItemCopyWith<$Res> {
  factory $Nuan5DatabaseItem_LightCopyWith(Nuan5DatabaseItem_Light value, $Res Function(Nuan5DatabaseItem_Light) _then) = _$Nuan5DatabaseItem_LightCopyWithImpl;
@useResult
$Res call({
 Nuan5Light field0
});




}
/// @nodoc
class _$Nuan5DatabaseItem_LightCopyWithImpl<$Res>
    implements $Nuan5DatabaseItem_LightCopyWith<$Res> {
  _$Nuan5DatabaseItem_LightCopyWithImpl(this._self, this._then);

  final Nuan5DatabaseItem_Light _self;
  final $Res Function(Nuan5DatabaseItem_Light) _then;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Nuan5DatabaseItem_Light(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Nuan5Light,
  ));
}


}

/// @nodoc


class Nuan5DatabaseItem_LightType extends Nuan5DatabaseItem {
  const Nuan5DatabaseItem_LightType(this.field0): super._();
  

@override final  Nuan5LightType field0;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Nuan5DatabaseItem_LightTypeCopyWith<Nuan5DatabaseItem_LightType> get copyWith => _$Nuan5DatabaseItem_LightTypeCopyWithImpl<Nuan5DatabaseItem_LightType>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nuan5DatabaseItem_LightType&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Nuan5DatabaseItem.lightType(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Nuan5DatabaseItem_LightTypeCopyWith<$Res> implements $Nuan5DatabaseItemCopyWith<$Res> {
  factory $Nuan5DatabaseItem_LightTypeCopyWith(Nuan5DatabaseItem_LightType value, $Res Function(Nuan5DatabaseItem_LightType) _then) = _$Nuan5DatabaseItem_LightTypeCopyWithImpl;
@useResult
$Res call({
 Nuan5LightType field0
});




}
/// @nodoc
class _$Nuan5DatabaseItem_LightTypeCopyWithImpl<$Res>
    implements $Nuan5DatabaseItem_LightTypeCopyWith<$Res> {
  _$Nuan5DatabaseItem_LightTypeCopyWithImpl(this._self, this._then);

  final Nuan5DatabaseItem_LightType _self;
  final $Res Function(Nuan5DatabaseItem_LightType) _then;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Nuan5DatabaseItem_LightType(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Nuan5LightType,
  ));
}


}

/// @nodoc


class Nuan5DatabaseItem_Filter extends Nuan5DatabaseItem {
  const Nuan5DatabaseItem_Filter(this.field0): super._();
  

@override final  Nuan5Filter field0;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Nuan5DatabaseItem_FilterCopyWith<Nuan5DatabaseItem_Filter> get copyWith => _$Nuan5DatabaseItem_FilterCopyWithImpl<Nuan5DatabaseItem_Filter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nuan5DatabaseItem_Filter&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Nuan5DatabaseItem.filter(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Nuan5DatabaseItem_FilterCopyWith<$Res> implements $Nuan5DatabaseItemCopyWith<$Res> {
  factory $Nuan5DatabaseItem_FilterCopyWith(Nuan5DatabaseItem_Filter value, $Res Function(Nuan5DatabaseItem_Filter) _then) = _$Nuan5DatabaseItem_FilterCopyWithImpl;
@useResult
$Res call({
 Nuan5Filter field0
});




}
/// @nodoc
class _$Nuan5DatabaseItem_FilterCopyWithImpl<$Res>
    implements $Nuan5DatabaseItem_FilterCopyWith<$Res> {
  _$Nuan5DatabaseItem_FilterCopyWithImpl(this._self, this._then);

  final Nuan5DatabaseItem_Filter _self;
  final $Res Function(Nuan5DatabaseItem_Filter) _then;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Nuan5DatabaseItem_Filter(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Nuan5Filter,
  ));
}


}

/// @nodoc


class Nuan5DatabaseItem_FilterType extends Nuan5DatabaseItem {
  const Nuan5DatabaseItem_FilterType(this.field0): super._();
  

@override final  Nuan5FilterType field0;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Nuan5DatabaseItem_FilterTypeCopyWith<Nuan5DatabaseItem_FilterType> get copyWith => _$Nuan5DatabaseItem_FilterTypeCopyWithImpl<Nuan5DatabaseItem_FilterType>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nuan5DatabaseItem_FilterType&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Nuan5DatabaseItem.filterType(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Nuan5DatabaseItem_FilterTypeCopyWith<$Res> implements $Nuan5DatabaseItemCopyWith<$Res> {
  factory $Nuan5DatabaseItem_FilterTypeCopyWith(Nuan5DatabaseItem_FilterType value, $Res Function(Nuan5DatabaseItem_FilterType) _then) = _$Nuan5DatabaseItem_FilterTypeCopyWithImpl;
@useResult
$Res call({
 Nuan5FilterType field0
});




}
/// @nodoc
class _$Nuan5DatabaseItem_FilterTypeCopyWithImpl<$Res>
    implements $Nuan5DatabaseItem_FilterTypeCopyWith<$Res> {
  _$Nuan5DatabaseItem_FilterTypeCopyWithImpl(this._self, this._then);

  final Nuan5DatabaseItem_FilterType _self;
  final $Res Function(Nuan5DatabaseItem_FilterType) _then;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Nuan5DatabaseItem_FilterType(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Nuan5FilterType,
  ));
}


}

/// @nodoc


class Nuan5DatabaseItem_MomoPose extends Nuan5DatabaseItem {
  const Nuan5DatabaseItem_MomoPose(this.field0): super._();
  

@override final  Nuan5MomoPose field0;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Nuan5DatabaseItem_MomoPoseCopyWith<Nuan5DatabaseItem_MomoPose> get copyWith => _$Nuan5DatabaseItem_MomoPoseCopyWithImpl<Nuan5DatabaseItem_MomoPose>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nuan5DatabaseItem_MomoPose&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Nuan5DatabaseItem.momoPose(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Nuan5DatabaseItem_MomoPoseCopyWith<$Res> implements $Nuan5DatabaseItemCopyWith<$Res> {
  factory $Nuan5DatabaseItem_MomoPoseCopyWith(Nuan5DatabaseItem_MomoPose value, $Res Function(Nuan5DatabaseItem_MomoPose) _then) = _$Nuan5DatabaseItem_MomoPoseCopyWithImpl;
@useResult
$Res call({
 Nuan5MomoPose field0
});




}
/// @nodoc
class _$Nuan5DatabaseItem_MomoPoseCopyWithImpl<$Res>
    implements $Nuan5DatabaseItem_MomoPoseCopyWith<$Res> {
  _$Nuan5DatabaseItem_MomoPoseCopyWithImpl(this._self, this._then);

  final Nuan5DatabaseItem_MomoPose _self;
  final $Res Function(Nuan5DatabaseItem_MomoPose) _then;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Nuan5DatabaseItem_MomoPose(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Nuan5MomoPose,
  ));
}


}

/// @nodoc


class Nuan5DatabaseItem_ClothDyeArea extends Nuan5DatabaseItem {
  const Nuan5DatabaseItem_ClothDyeArea(this.field0): super._();
  

@override final  Nuan5ClothDyeArea field0;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Nuan5DatabaseItem_ClothDyeAreaCopyWith<Nuan5DatabaseItem_ClothDyeArea> get copyWith => _$Nuan5DatabaseItem_ClothDyeAreaCopyWithImpl<Nuan5DatabaseItem_ClothDyeArea>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nuan5DatabaseItem_ClothDyeArea&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Nuan5DatabaseItem.clothDyeArea(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Nuan5DatabaseItem_ClothDyeAreaCopyWith<$Res> implements $Nuan5DatabaseItemCopyWith<$Res> {
  factory $Nuan5DatabaseItem_ClothDyeAreaCopyWith(Nuan5DatabaseItem_ClothDyeArea value, $Res Function(Nuan5DatabaseItem_ClothDyeArea) _then) = _$Nuan5DatabaseItem_ClothDyeAreaCopyWithImpl;
@useResult
$Res call({
 Nuan5ClothDyeArea field0
});




}
/// @nodoc
class _$Nuan5DatabaseItem_ClothDyeAreaCopyWithImpl<$Res>
    implements $Nuan5DatabaseItem_ClothDyeAreaCopyWith<$Res> {
  _$Nuan5DatabaseItem_ClothDyeAreaCopyWithImpl(this._self, this._then);

  final Nuan5DatabaseItem_ClothDyeArea _self;
  final $Res Function(Nuan5DatabaseItem_ClothDyeArea) _then;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Nuan5DatabaseItem_ClothDyeArea(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Nuan5ClothDyeArea,
  ));
}


}

/// @nodoc


class Nuan5DatabaseItem_ClothDyePalette extends Nuan5DatabaseItem {
  const Nuan5DatabaseItem_ClothDyePalette(this.field0): super._();
  

@override final  Nuan5ClothDyePalette field0;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Nuan5DatabaseItem_ClothDyePaletteCopyWith<Nuan5DatabaseItem_ClothDyePalette> get copyWith => _$Nuan5DatabaseItem_ClothDyePaletteCopyWithImpl<Nuan5DatabaseItem_ClothDyePalette>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nuan5DatabaseItem_ClothDyePalette&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Nuan5DatabaseItem.clothDyePalette(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Nuan5DatabaseItem_ClothDyePaletteCopyWith<$Res> implements $Nuan5DatabaseItemCopyWith<$Res> {
  factory $Nuan5DatabaseItem_ClothDyePaletteCopyWith(Nuan5DatabaseItem_ClothDyePalette value, $Res Function(Nuan5DatabaseItem_ClothDyePalette) _then) = _$Nuan5DatabaseItem_ClothDyePaletteCopyWithImpl;
@useResult
$Res call({
 Nuan5ClothDyePalette field0
});




}
/// @nodoc
class _$Nuan5DatabaseItem_ClothDyePaletteCopyWithImpl<$Res>
    implements $Nuan5DatabaseItem_ClothDyePaletteCopyWith<$Res> {
  _$Nuan5DatabaseItem_ClothDyePaletteCopyWithImpl(this._self, this._then);

  final Nuan5DatabaseItem_ClothDyePalette _self;
  final $Res Function(Nuan5DatabaseItem_ClothDyePalette) _then;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Nuan5DatabaseItem_ClothDyePalette(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Nuan5ClothDyePalette,
  ));
}


}

/// @nodoc


class Nuan5DatabaseItem_ClothDiySwatchColor extends Nuan5DatabaseItem {
  const Nuan5DatabaseItem_ClothDiySwatchColor(this.field0): super._();
  

@override final  Nuan5ClothDiySwatchColor field0;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Nuan5DatabaseItem_ClothDiySwatchColorCopyWith<Nuan5DatabaseItem_ClothDiySwatchColor> get copyWith => _$Nuan5DatabaseItem_ClothDiySwatchColorCopyWithImpl<Nuan5DatabaseItem_ClothDiySwatchColor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nuan5DatabaseItem_ClothDiySwatchColor&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Nuan5DatabaseItem.clothDiySwatchColor(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Nuan5DatabaseItem_ClothDiySwatchColorCopyWith<$Res> implements $Nuan5DatabaseItemCopyWith<$Res> {
  factory $Nuan5DatabaseItem_ClothDiySwatchColorCopyWith(Nuan5DatabaseItem_ClothDiySwatchColor value, $Res Function(Nuan5DatabaseItem_ClothDiySwatchColor) _then) = _$Nuan5DatabaseItem_ClothDiySwatchColorCopyWithImpl;
@useResult
$Res call({
 Nuan5ClothDiySwatchColor field0
});




}
/// @nodoc
class _$Nuan5DatabaseItem_ClothDiySwatchColorCopyWithImpl<$Res>
    implements $Nuan5DatabaseItem_ClothDiySwatchColorCopyWith<$Res> {
  _$Nuan5DatabaseItem_ClothDiySwatchColorCopyWithImpl(this._self, this._then);

  final Nuan5DatabaseItem_ClothDiySwatchColor _self;
  final $Res Function(Nuan5DatabaseItem_ClothDiySwatchColor) _then;

/// Create a copy of Nuan5DatabaseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Nuan5DatabaseItem_ClothDiySwatchColor(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Nuan5ClothDiySwatchColor,
  ));
}


}

// dart format on
