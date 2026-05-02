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

/// @nodoc
mixin _$DecodeEvent {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DecodeEvent&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'DecodeEvent(field0: $field0)';
}


}

/// @nodoc
class $DecodeEventCopyWith<$Res>  {
$DecodeEventCopyWith(DecodeEvent _, $Res Function(DecodeEvent) __);
}


/// Adds pattern-matching-related methods to [DecodeEvent].
extension DecodeEventPatterns on DecodeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DecodeEvent_Progress value)?  progress,TResult Function( DecodeEvent_Result value)?  result,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DecodeEvent_Progress() when progress != null:
return progress(_that);case DecodeEvent_Result() when result != null:
return result(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DecodeEvent_Progress value)  progress,required TResult Function( DecodeEvent_Result value)  result,}){
final _that = this;
switch (_that) {
case DecodeEvent_Progress():
return progress(_that);case DecodeEvent_Result():
return result(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DecodeEvent_Progress value)?  progress,TResult? Function( DecodeEvent_Result value)?  result,}){
final _that = this;
switch (_that) {
case DecodeEvent_Progress() when progress != null:
return progress(_that);case DecodeEvent_Result() when result != null:
return result(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( double field0)?  progress,TResult Function( List<CustomData?> field0)?  result,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DecodeEvent_Progress() when progress != null:
return progress(_that.field0);case DecodeEvent_Result() when result != null:
return result(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( double field0)  progress,required TResult Function( List<CustomData?> field0)  result,}) {final _that = this;
switch (_that) {
case DecodeEvent_Progress():
return progress(_that.field0);case DecodeEvent_Result():
return result(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( double field0)?  progress,TResult? Function( List<CustomData?> field0)?  result,}) {final _that = this;
switch (_that) {
case DecodeEvent_Progress() when progress != null:
return progress(_that.field0);case DecodeEvent_Result() when result != null:
return result(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class DecodeEvent_Progress extends DecodeEvent {
  const DecodeEvent_Progress(this.field0): super._();
  

@override final  double field0;

/// Create a copy of DecodeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DecodeEvent_ProgressCopyWith<DecodeEvent_Progress> get copyWith => _$DecodeEvent_ProgressCopyWithImpl<DecodeEvent_Progress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DecodeEvent_Progress&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'DecodeEvent.progress(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $DecodeEvent_ProgressCopyWith<$Res> implements $DecodeEventCopyWith<$Res> {
  factory $DecodeEvent_ProgressCopyWith(DecodeEvent_Progress value, $Res Function(DecodeEvent_Progress) _then) = _$DecodeEvent_ProgressCopyWithImpl;
@useResult
$Res call({
 double field0
});




}
/// @nodoc
class _$DecodeEvent_ProgressCopyWithImpl<$Res>
    implements $DecodeEvent_ProgressCopyWith<$Res> {
  _$DecodeEvent_ProgressCopyWithImpl(this._self, this._then);

  final DecodeEvent_Progress _self;
  final $Res Function(DecodeEvent_Progress) _then;

/// Create a copy of DecodeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(DecodeEvent_Progress(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class DecodeEvent_Result extends DecodeEvent {
  const DecodeEvent_Result(final  List<CustomData?> field0): _field0 = field0,super._();
  

 final  List<CustomData?> _field0;
@override List<CustomData?> get field0 {
  if (_field0 is EqualUnmodifiableListView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field0);
}


/// Create a copy of DecodeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DecodeEvent_ResultCopyWith<DecodeEvent_Result> get copyWith => _$DecodeEvent_ResultCopyWithImpl<DecodeEvent_Result>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DecodeEvent_Result&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'DecodeEvent.result(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $DecodeEvent_ResultCopyWith<$Res> implements $DecodeEventCopyWith<$Res> {
  factory $DecodeEvent_ResultCopyWith(DecodeEvent_Result value, $Res Function(DecodeEvent_Result) _then) = _$DecodeEvent_ResultCopyWithImpl;
@useResult
$Res call({
 List<CustomData?> field0
});




}
/// @nodoc
class _$DecodeEvent_ResultCopyWithImpl<$Res>
    implements $DecodeEvent_ResultCopyWith<$Res> {
  _$DecodeEvent_ResultCopyWithImpl(this._self, this._then);

  final DecodeEvent_Result _self;
  final $Res Function(DecodeEvent_Result) _then;

/// Create a copy of DecodeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(DecodeEvent_Result(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as List<CustomData?>,
  ));
}


}

// dart format on
