// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'decrypt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomData {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CustomData()';
}


}

/// @nodoc
class $CustomDataCopyWith<$Res>  {
$CustomDataCopyWith(CustomData _, $Res Function(CustomData) __);
}


/// Adds pattern-matching-related methods to [CustomData].
extension CustomDataPatterns on CustomData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CustomData_Invalid value)?  invalid,TResult Function( CustomData_Valid value)?  valid,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CustomData_Invalid() when invalid != null:
return invalid(_that);case CustomData_Valid() when valid != null:
return valid(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CustomData_Invalid value)  invalid,required TResult Function( CustomData_Valid value)  valid,}){
final _that = this;
switch (_that) {
case CustomData_Invalid():
return invalid(_that);case CustomData_Valid():
return valid(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CustomData_Invalid value)?  invalid,TResult? Function( CustomData_Valid value)?  valid,}){
final _that = this;
switch (_that) {
case CustomData_Invalid() when invalid != null:
return invalid(_that);case CustomData_Valid() when valid != null:
return valid(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalid,TResult Function( Uint8List field0)?  valid,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CustomData_Invalid() when invalid != null:
return invalid();case CustomData_Valid() when valid != null:
return valid(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalid,required TResult Function( Uint8List field0)  valid,}) {final _that = this;
switch (_that) {
case CustomData_Invalid():
return invalid();case CustomData_Valid():
return valid(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalid,TResult? Function( Uint8List field0)?  valid,}) {final _that = this;
switch (_that) {
case CustomData_Invalid() when invalid != null:
return invalid();case CustomData_Valid() when valid != null:
return valid(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class CustomData_Invalid extends CustomData {
  const CustomData_Invalid(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomData_Invalid);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CustomData.invalid()';
}


}




/// @nodoc


class CustomData_Valid extends CustomData {
  const CustomData_Valid(this.field0): super._();
  

 final  Uint8List field0;

/// Create a copy of CustomData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomData_ValidCopyWith<CustomData_Valid> get copyWith => _$CustomData_ValidCopyWithImpl<CustomData_Valid>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomData_Valid&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'CustomData.valid(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $CustomData_ValidCopyWith<$Res> implements $CustomDataCopyWith<$Res> {
  factory $CustomData_ValidCopyWith(CustomData_Valid value, $Res Function(CustomData_Valid) _then) = _$CustomData_ValidCopyWithImpl;
@useResult
$Res call({
 Uint8List field0
});




}
/// @nodoc
class _$CustomData_ValidCopyWithImpl<$Res>
    implements $CustomData_ValidCopyWith<$Res> {
  _$CustomData_ValidCopyWithImpl(this._self, this._then);

  final CustomData_Valid _self;
  final $Res Function(CustomData_Valid) _then;

/// Create a copy of CustomData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(CustomData_Valid(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

// dart format on
