// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Location {

 Dimension? get dimension; Subarea? get subarea;
/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationCopyWith<Location> get copyWith => _$LocationCopyWithImpl<Location>(this as Location, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location&&(identical(other.dimension, dimension) || other.dimension == dimension)&&(identical(other.subarea, subarea) || other.subarea == subarea));
}


@override
int get hashCode => Object.hash(runtimeType,dimension,subarea);

@override
String toString() {
  return 'Location(dimension: $dimension, subarea: $subarea)';
}


}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res>  {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) = _$LocationCopyWithImpl;
@useResult
$Res call({
 Dimension? dimension, Subarea? subarea
});




}
/// @nodoc
class _$LocationCopyWithImpl<$Res>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dimension = freezed,Object? subarea = freezed,}) {
  return _then(_self.copyWith(
dimension: freezed == dimension ? _self.dimension : dimension // ignore: cast_nullable_to_non_nullable
as Dimension?,subarea: freezed == subarea ? _self.subarea : subarea // ignore: cast_nullable_to_non_nullable
as Subarea?,
  ));
}

}


/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Location_Standard value)?  standard,TResult Function( Location_Special value)?  special,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Location_Standard() when standard != null:
return standard(_that);case Location_Special() when special != null:
return special(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Location_Standard value)  standard,required TResult Function( Location_Special value)  special,}){
final _that = this;
switch (_that) {
case Location_Standard():
return standard(_that);case Location_Special():
return special(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Location_Standard value)?  standard,TResult? Function( Location_Special value)?  special,}){
final _that = this;
switch (_that) {
case Location_Standard() when standard != null:
return standard(_that);case Location_Special() when special != null:
return special(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Dimension? dimension,  Nation? nation,  Region? region,  Area? area,  Subarea? subarea)?  standard,TResult Function( Dimension? dimension,  Subarea? subarea)?  special,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Location_Standard() when standard != null:
return standard(_that.dimension,_that.nation,_that.region,_that.area,_that.subarea);case Location_Special() when special != null:
return special(_that.dimension,_that.subarea);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Dimension? dimension,  Nation? nation,  Region? region,  Area? area,  Subarea? subarea)  standard,required TResult Function( Dimension? dimension,  Subarea? subarea)  special,}) {final _that = this;
switch (_that) {
case Location_Standard():
return standard(_that.dimension,_that.nation,_that.region,_that.area,_that.subarea);case Location_Special():
return special(_that.dimension,_that.subarea);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Dimension? dimension,  Nation? nation,  Region? region,  Area? area,  Subarea? subarea)?  standard,TResult? Function( Dimension? dimension,  Subarea? subarea)?  special,}) {final _that = this;
switch (_that) {
case Location_Standard() when standard != null:
return standard(_that.dimension,_that.nation,_that.region,_that.area,_that.subarea);case Location_Special() when special != null:
return special(_that.dimension,_that.subarea);case _:
  return null;

}
}

}

/// @nodoc


class Location_Standard extends Location {
  const Location_Standard({this.dimension, this.nation, this.region, this.area, this.subarea}): super._();
  

@override final  Dimension? dimension;
 final  Nation? nation;
 final  Region? region;
 final  Area? area;
@override final  Subarea? subarea;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Location_StandardCopyWith<Location_Standard> get copyWith => _$Location_StandardCopyWithImpl<Location_Standard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location_Standard&&(identical(other.dimension, dimension) || other.dimension == dimension)&&(identical(other.nation, nation) || other.nation == nation)&&(identical(other.region, region) || other.region == region)&&(identical(other.area, area) || other.area == area)&&(identical(other.subarea, subarea) || other.subarea == subarea));
}


@override
int get hashCode => Object.hash(runtimeType,dimension,nation,region,area,subarea);

@override
String toString() {
  return 'Location.standard(dimension: $dimension, nation: $nation, region: $region, area: $area, subarea: $subarea)';
}


}

/// @nodoc
abstract mixin class $Location_StandardCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory $Location_StandardCopyWith(Location_Standard value, $Res Function(Location_Standard) _then) = _$Location_StandardCopyWithImpl;
@override @useResult
$Res call({
 Dimension? dimension, Nation? nation, Region? region, Area? area, Subarea? subarea
});




}
/// @nodoc
class _$Location_StandardCopyWithImpl<$Res>
    implements $Location_StandardCopyWith<$Res> {
  _$Location_StandardCopyWithImpl(this._self, this._then);

  final Location_Standard _self;
  final $Res Function(Location_Standard) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dimension = freezed,Object? nation = freezed,Object? region = freezed,Object? area = freezed,Object? subarea = freezed,}) {
  return _then(Location_Standard(
dimension: freezed == dimension ? _self.dimension : dimension // ignore: cast_nullable_to_non_nullable
as Dimension?,nation: freezed == nation ? _self.nation : nation // ignore: cast_nullable_to_non_nullable
as Nation?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as Region?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as Area?,subarea: freezed == subarea ? _self.subarea : subarea // ignore: cast_nullable_to_non_nullable
as Subarea?,
  ));
}


}

/// @nodoc


class Location_Special extends Location {
  const Location_Special({this.dimension, this.subarea}): super._();
  

@override final  Dimension? dimension;
@override final  Subarea? subarea;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Location_SpecialCopyWith<Location_Special> get copyWith => _$Location_SpecialCopyWithImpl<Location_Special>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location_Special&&(identical(other.dimension, dimension) || other.dimension == dimension)&&(identical(other.subarea, subarea) || other.subarea == subarea));
}


@override
int get hashCode => Object.hash(runtimeType,dimension,subarea);

@override
String toString() {
  return 'Location.special(dimension: $dimension, subarea: $subarea)';
}


}

/// @nodoc
abstract mixin class $Location_SpecialCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory $Location_SpecialCopyWith(Location_Special value, $Res Function(Location_Special) _then) = _$Location_SpecialCopyWithImpl;
@override @useResult
$Res call({
 Dimension? dimension, Subarea? subarea
});




}
/// @nodoc
class _$Location_SpecialCopyWithImpl<$Res>
    implements $Location_SpecialCopyWith<$Res> {
  _$Location_SpecialCopyWithImpl(this._self, this._then);

  final Location_Special _self;
  final $Res Function(Location_Special) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dimension = freezed,Object? subarea = freezed,}) {
  return _then(Location_Special(
dimension: freezed == dimension ? _self.dimension : dimension // ignore: cast_nullable_to_non_nullable
as Dimension?,subarea: freezed == subarea ? _self.subarea : subarea // ignore: cast_nullable_to_non_nullable
as Subarea?,
  ));
}


}

// dart format on
