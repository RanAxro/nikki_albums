// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sorting_method.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SortingMethod<T extends MediaItem> {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SortingMethod<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SortingMethod<$T>()';
}


}

/// @nodoc
class $SortingMethodCopyWith<T extends MediaItem,$Res>  {
$SortingMethodCopyWith(SortingMethod<T> _, $Res Function(SortingMethod<T>) __);
}


/// Adds pattern-matching-related methods to [SortingMethod].
extension SortingMethodPatterns<T extends MediaItem> on SortingMethod<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SortingMethod_None<T> value)?  none,TResult Function( SortingMethod_CTime<T> value)?  cTime,TResult Function( SortingMethod_MTime<T> value)?  mTime,TResult Function( SortingMethod_ATime<T> value)?  aTime,TResult Function( SortingMethod_Size<T> value)?  size,TResult Function( SortingMethod_Custom<T> value)?  custom,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SortingMethod_None() when none != null:
return none(_that);case SortingMethod_CTime() when cTime != null:
return cTime(_that);case SortingMethod_MTime() when mTime != null:
return mTime(_that);case SortingMethod_ATime() when aTime != null:
return aTime(_that);case SortingMethod_Size() when size != null:
return size(_that);case SortingMethod_Custom() when custom != null:
return custom(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SortingMethod_None<T> value)  none,required TResult Function( SortingMethod_CTime<T> value)  cTime,required TResult Function( SortingMethod_MTime<T> value)  mTime,required TResult Function( SortingMethod_ATime<T> value)  aTime,required TResult Function( SortingMethod_Size<T> value)  size,required TResult Function( SortingMethod_Custom<T> value)  custom,}){
final _that = this;
switch (_that) {
case SortingMethod_None():
return none(_that);case SortingMethod_CTime():
return cTime(_that);case SortingMethod_MTime():
return mTime(_that);case SortingMethod_ATime():
return aTime(_that);case SortingMethod_Size():
return size(_that);case SortingMethod_Custom():
return custom(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SortingMethod_None<T> value)?  none,TResult? Function( SortingMethod_CTime<T> value)?  cTime,TResult? Function( SortingMethod_MTime<T> value)?  mTime,TResult? Function( SortingMethod_ATime<T> value)?  aTime,TResult? Function( SortingMethod_Size<T> value)?  size,TResult? Function( SortingMethod_Custom<T> value)?  custom,}){
final _that = this;
switch (_that) {
case SortingMethod_None() when none != null:
return none(_that);case SortingMethod_CTime() when cTime != null:
return cTime(_that);case SortingMethod_MTime() when mTime != null:
return mTime(_that);case SortingMethod_ATime() when aTime != null:
return aTime(_that);case SortingMethod_Size() when size != null:
return size(_that);case SortingMethod_Custom() when custom != null:
return custom(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function()?  cTime,TResult Function()?  mTime,TResult Function()?  aTime,TResult Function()?  size,TResult Function( int Function(T a, T b) compare)?  custom,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SortingMethod_None() when none != null:
return none();case SortingMethod_CTime() when cTime != null:
return cTime();case SortingMethod_MTime() when mTime != null:
return mTime();case SortingMethod_ATime() when aTime != null:
return aTime();case SortingMethod_Size() when size != null:
return size();case SortingMethod_Custom() when custom != null:
return custom(_that.compare);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function()  cTime,required TResult Function()  mTime,required TResult Function()  aTime,required TResult Function()  size,required TResult Function( int Function(T a, T b) compare)  custom,}) {final _that = this;
switch (_that) {
case SortingMethod_None():
return none();case SortingMethod_CTime():
return cTime();case SortingMethod_MTime():
return mTime();case SortingMethod_ATime():
return aTime();case SortingMethod_Size():
return size();case SortingMethod_Custom():
return custom(_that.compare);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function()?  cTime,TResult? Function()?  mTime,TResult? Function()?  aTime,TResult? Function()?  size,TResult? Function( int Function(T a, T b) compare)?  custom,}) {final _that = this;
switch (_that) {
case SortingMethod_None() when none != null:
return none();case SortingMethod_CTime() when cTime != null:
return cTime();case SortingMethod_MTime() when mTime != null:
return mTime();case SortingMethod_ATime() when aTime != null:
return aTime();case SortingMethod_Size() when size != null:
return size();case SortingMethod_Custom() when custom != null:
return custom(_that.compare);case _:
  return null;

}
}

}

/// @nodoc


class SortingMethod_None<T extends MediaItem> implements SortingMethod<T> {
  const SortingMethod_None();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SortingMethod_None<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SortingMethod<$T>.none()';
}


}




/// @nodoc


class SortingMethod_CTime<T extends MediaItem> implements SortingMethod<T> {
  const SortingMethod_CTime();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SortingMethod_CTime<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SortingMethod<$T>.cTime()';
}


}




/// @nodoc


class SortingMethod_MTime<T extends MediaItem> implements SortingMethod<T> {
  const SortingMethod_MTime();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SortingMethod_MTime<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SortingMethod<$T>.mTime()';
}


}




/// @nodoc


class SortingMethod_ATime<T extends MediaItem> implements SortingMethod<T> {
  const SortingMethod_ATime();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SortingMethod_ATime<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SortingMethod<$T>.aTime()';
}


}




/// @nodoc


class SortingMethod_Size<T extends MediaItem> implements SortingMethod<T> {
  const SortingMethod_Size();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SortingMethod_Size<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SortingMethod<$T>.size()';
}


}




/// @nodoc


class SortingMethod_Custom<T extends MediaItem> implements SortingMethod<T> {
  const SortingMethod_Custom(this.compare);
  

 final  int Function(T a, T b) compare;

/// Create a copy of SortingMethod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SortingMethod_CustomCopyWith<T, SortingMethod_Custom<T>> get copyWith => _$SortingMethod_CustomCopyWithImpl<T, SortingMethod_Custom<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SortingMethod_Custom<T>&&(identical(other.compare, compare) || other.compare == compare));
}


@override
int get hashCode {
    return Object.hash(runtimeType,compare);
}

@override
String toString() {
    return 'SortingMethod<$T>.custom(compare: $compare)';
}


}

/// @nodoc
abstract mixin class $SortingMethod_CustomCopyWith<T extends MediaItem,$Res> implements $SortingMethodCopyWith<T, $Res> {
  factory $SortingMethod_CustomCopyWith(SortingMethod_Custom<T> value, $Res Function(SortingMethod_Custom<T>) _then) = _$SortingMethod_CustomCopyWithImpl;
@useResult
$Res call({
 int Function(T a, T b) compare
});




}
/// @nodoc
class _$SortingMethod_CustomCopyWithImpl<T extends MediaItem,$Res>
    implements $SortingMethod_CustomCopyWith<T, $Res> {
  _$SortingMethod_CustomCopyWithImpl(this._self, this._then);

  final SortingMethod_Custom<T> _self;
  final $Res Function(SortingMethod_Custom<T>) _then;

/// Create a copy of SortingMethod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? compare = null,}) {
  return _then(SortingMethod_Custom<T>(
null == compare ? _self.compare : compare // ignore: cast_nullable_to_non_nullable
as int Function(T a, T b),
  ));
}


}

// dart format on
