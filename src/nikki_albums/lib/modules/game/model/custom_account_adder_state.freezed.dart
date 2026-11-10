// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_account_adder_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomAccountAdderState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomAccountAdderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomAccountAdderState()';
}


}

/// @nodoc
class $CustomAccountAdderStateCopyWith<$Res>  {
$CustomAccountAdderStateCopyWith(CustomAccountAdderState _, $Res Function(CustomAccountAdderState) __);
}


/// Adds pattern-matching-related methods to [CustomAccountAdderState].
extension CustomAccountAdderStatePatterns on CustomAccountAdderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CustomAccountAdderState_None value)?  none,TResult Function( CustomAccountAdderState_Waiting value)?  waiting,TResult Function( CustomAccountAdderState_Error value)?  error,TResult Function( CustomAccountAdderState_Success value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CustomAccountAdderState_None() when none != null:
return none(_that);case CustomAccountAdderState_Waiting() when waiting != null:
return waiting(_that);case CustomAccountAdderState_Error() when error != null:
return error(_that);case CustomAccountAdderState_Success() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CustomAccountAdderState_None value)  none,required TResult Function( CustomAccountAdderState_Waiting value)  waiting,required TResult Function( CustomAccountAdderState_Error value)  error,required TResult Function( CustomAccountAdderState_Success value)  success,}){
final _that = this;
switch (_that) {
case CustomAccountAdderState_None():
return none(_that);case CustomAccountAdderState_Waiting():
return waiting(_that);case CustomAccountAdderState_Error():
return error(_that);case CustomAccountAdderState_Success():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CustomAccountAdderState_None value)?  none,TResult? Function( CustomAccountAdderState_Waiting value)?  waiting,TResult? Function( CustomAccountAdderState_Error value)?  error,TResult? Function( CustomAccountAdderState_Success value)?  success,}){
final _that = this;
switch (_that) {
case CustomAccountAdderState_None() when none != null:
return none(_that);case CustomAccountAdderState_Waiting() when waiting != null:
return waiting(_that);case CustomAccountAdderState_Error() when error != null:
return error(_that);case CustomAccountAdderState_Success() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function()?  waiting,TResult Function( TextRule? message)?  error,TResult Function( DeviceGameAccount deviceGameAccount)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CustomAccountAdderState_None() when none != null:
return none();case CustomAccountAdderState_Waiting() when waiting != null:
return waiting();case CustomAccountAdderState_Error() when error != null:
return error(_that.message);case CustomAccountAdderState_Success() when success != null:
return success(_that.deviceGameAccount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function()  waiting,required TResult Function( TextRule? message)  error,required TResult Function( DeviceGameAccount deviceGameAccount)  success,}) {final _that = this;
switch (_that) {
case CustomAccountAdderState_None():
return none();case CustomAccountAdderState_Waiting():
return waiting();case CustomAccountAdderState_Error():
return error(_that.message);case CustomAccountAdderState_Success():
return success(_that.deviceGameAccount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function()?  waiting,TResult? Function( TextRule? message)?  error,TResult? Function( DeviceGameAccount deviceGameAccount)?  success,}) {final _that = this;
switch (_that) {
case CustomAccountAdderState_None() when none != null:
return none();case CustomAccountAdderState_Waiting() when waiting != null:
return waiting();case CustomAccountAdderState_Error() when error != null:
return error(_that.message);case CustomAccountAdderState_Success() when success != null:
return success(_that.deviceGameAccount);case _:
  return null;

}
}

}

/// @nodoc


class CustomAccountAdderState_None implements CustomAccountAdderState {
  const CustomAccountAdderState_None();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomAccountAdderState_None);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomAccountAdderState.none()';
}


}




/// @nodoc


class CustomAccountAdderState_Waiting implements CustomAccountAdderState {
  const CustomAccountAdderState_Waiting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomAccountAdderState_Waiting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomAccountAdderState.waiting()';
}


}




/// @nodoc


class CustomAccountAdderState_Error implements CustomAccountAdderState {
  const CustomAccountAdderState_Error(this.message);
  

 final  TextRule? message;

/// Create a copy of CustomAccountAdderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomAccountAdderState_ErrorCopyWith<CustomAccountAdderState_Error> get copyWith => _$CustomAccountAdderState_ErrorCopyWithImpl<CustomAccountAdderState_Error>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomAccountAdderState_Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CustomAccountAdderState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CustomAccountAdderState_ErrorCopyWith<$Res> implements $CustomAccountAdderStateCopyWith<$Res> {
  factory $CustomAccountAdderState_ErrorCopyWith(CustomAccountAdderState_Error value, $Res Function(CustomAccountAdderState_Error) _then) = _$CustomAccountAdderState_ErrorCopyWithImpl;
@useResult
$Res call({
 TextRule? message
});


$TextRuleCopyWith<$Res>? get message;

}
/// @nodoc
class _$CustomAccountAdderState_ErrorCopyWithImpl<$Res>
    implements $CustomAccountAdderState_ErrorCopyWith<$Res> {
  _$CustomAccountAdderState_ErrorCopyWithImpl(this._self, this._then);

  final CustomAccountAdderState_Error _self;
  final $Res Function(CustomAccountAdderState_Error) _then;

/// Create a copy of CustomAccountAdderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(CustomAccountAdderState_Error(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as TextRule?,
  ));
}

/// Create a copy of CustomAccountAdderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextRuleCopyWith<$Res>? get message {
    if (_self.message == null) {
    return null;
  }

  return $TextRuleCopyWith<$Res>(_self.message!, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}

/// @nodoc


class CustomAccountAdderState_Success implements CustomAccountAdderState {
  const CustomAccountAdderState_Success(this.deviceGameAccount);
  

 final  DeviceGameAccount deviceGameAccount;

/// Create a copy of CustomAccountAdderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomAccountAdderState_SuccessCopyWith<CustomAccountAdderState_Success> get copyWith => _$CustomAccountAdderState_SuccessCopyWithImpl<CustomAccountAdderState_Success>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomAccountAdderState_Success&&(identical(other.deviceGameAccount, deviceGameAccount) || other.deviceGameAccount == deviceGameAccount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceGameAccount);
}

@override
String toString() {
    return 'CustomAccountAdderState.success(deviceGameAccount: $deviceGameAccount)';
}


}

/// @nodoc
abstract mixin class $CustomAccountAdderState_SuccessCopyWith<$Res> implements $CustomAccountAdderStateCopyWith<$Res> {
  factory $CustomAccountAdderState_SuccessCopyWith(CustomAccountAdderState_Success value, $Res Function(CustomAccountAdderState_Success) _then) = _$CustomAccountAdderState_SuccessCopyWithImpl;
@useResult
$Res call({
 DeviceGameAccount deviceGameAccount
});




}
/// @nodoc
class _$CustomAccountAdderState_SuccessCopyWithImpl<$Res>
    implements $CustomAccountAdderState_SuccessCopyWith<$Res> {
  _$CustomAccountAdderState_SuccessCopyWithImpl(this._self, this._then);

  final CustomAccountAdderState_Success _self;
  final $Res Function(CustomAccountAdderState_Success) _then;

/// Create a copy of CustomAccountAdderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceGameAccount = null,}) {
  return _then(CustomAccountAdderState_Success(
null == deviceGameAccount ? _self.deviceGameAccount : deviceGameAccount // ignore: cast_nullable_to_non_nullable
as DeviceGameAccount,
  ));
}


}

// dart format on
