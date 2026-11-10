// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_game_picker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceGamePickerState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceGamePickerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceGamePickerState()';
}


}

/// @nodoc
class $DeviceGamePickerStateCopyWith<$Res>  {
$DeviceGamePickerStateCopyWith(DeviceGamePickerState _, $Res Function(DeviceGamePickerState) __);
}


/// Adds pattern-matching-related methods to [DeviceGamePickerState].
extension DeviceGamePickerStatePatterns on DeviceGamePickerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeviceGamePickerState_None value)?  none,TResult Function( DeviceGamePickerState_Waiting value)?  waiting,TResult Function( DeviceGamePickerState_Error value)?  error,TResult Function( DeviceGamePickerState_Success value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeviceGamePickerState_None() when none != null:
return none(_that);case DeviceGamePickerState_Waiting() when waiting != null:
return waiting(_that);case DeviceGamePickerState_Error() when error != null:
return error(_that);case DeviceGamePickerState_Success() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeviceGamePickerState_None value)  none,required TResult Function( DeviceGamePickerState_Waiting value)  waiting,required TResult Function( DeviceGamePickerState_Error value)  error,required TResult Function( DeviceGamePickerState_Success value)  success,}){
final _that = this;
switch (_that) {
case DeviceGamePickerState_None():
return none(_that);case DeviceGamePickerState_Waiting():
return waiting(_that);case DeviceGamePickerState_Error():
return error(_that);case DeviceGamePickerState_Success():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeviceGamePickerState_None value)?  none,TResult? Function( DeviceGamePickerState_Waiting value)?  waiting,TResult? Function( DeviceGamePickerState_Error value)?  error,TResult? Function( DeviceGamePickerState_Success value)?  success,}){
final _that = this;
switch (_that) {
case DeviceGamePickerState_None() when none != null:
return none(_that);case DeviceGamePickerState_Waiting() when waiting != null:
return waiting(_that);case DeviceGamePickerState_Error() when error != null:
return error(_that);case DeviceGamePickerState_Success() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function()?  waiting,TResult Function( TextRule? message)?  error,TResult Function( DeviceGame deviceGame)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeviceGamePickerState_None() when none != null:
return none();case DeviceGamePickerState_Waiting() when waiting != null:
return waiting();case DeviceGamePickerState_Error() when error != null:
return error(_that.message);case DeviceGamePickerState_Success() when success != null:
return success(_that.deviceGame);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function()  waiting,required TResult Function( TextRule? message)  error,required TResult Function( DeviceGame deviceGame)  success,}) {final _that = this;
switch (_that) {
case DeviceGamePickerState_None():
return none();case DeviceGamePickerState_Waiting():
return waiting();case DeviceGamePickerState_Error():
return error(_that.message);case DeviceGamePickerState_Success():
return success(_that.deviceGame);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function()?  waiting,TResult? Function( TextRule? message)?  error,TResult? Function( DeviceGame deviceGame)?  success,}) {final _that = this;
switch (_that) {
case DeviceGamePickerState_None() when none != null:
return none();case DeviceGamePickerState_Waiting() when waiting != null:
return waiting();case DeviceGamePickerState_Error() when error != null:
return error(_that.message);case DeviceGamePickerState_Success() when success != null:
return success(_that.deviceGame);case _:
  return null;

}
}

}

/// @nodoc


class DeviceGamePickerState_None implements DeviceGamePickerState {
  const DeviceGamePickerState_None();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceGamePickerState_None);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceGamePickerState.none()';
}


}




/// @nodoc


class DeviceGamePickerState_Waiting implements DeviceGamePickerState {
  const DeviceGamePickerState_Waiting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceGamePickerState_Waiting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceGamePickerState.waiting()';
}


}




/// @nodoc


class DeviceGamePickerState_Error implements DeviceGamePickerState {
  const DeviceGamePickerState_Error(this.message);
  

 final  TextRule? message;

/// Create a copy of DeviceGamePickerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceGamePickerState_ErrorCopyWith<DeviceGamePickerState_Error> get copyWith => _$DeviceGamePickerState_ErrorCopyWithImpl<DeviceGamePickerState_Error>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceGamePickerState_Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'DeviceGamePickerState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DeviceGamePickerState_ErrorCopyWith<$Res> implements $DeviceGamePickerStateCopyWith<$Res> {
  factory $DeviceGamePickerState_ErrorCopyWith(DeviceGamePickerState_Error value, $Res Function(DeviceGamePickerState_Error) _then) = _$DeviceGamePickerState_ErrorCopyWithImpl;
@useResult
$Res call({
 TextRule? message
});


$TextRuleCopyWith<$Res>? get message;

}
/// @nodoc
class _$DeviceGamePickerState_ErrorCopyWithImpl<$Res>
    implements $DeviceGamePickerState_ErrorCopyWith<$Res> {
  _$DeviceGamePickerState_ErrorCopyWithImpl(this._self, this._then);

  final DeviceGamePickerState_Error _self;
  final $Res Function(DeviceGamePickerState_Error) _then;

/// Create a copy of DeviceGamePickerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(DeviceGamePickerState_Error(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as TextRule?,
  ));
}

/// Create a copy of DeviceGamePickerState
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


class DeviceGamePickerState_Success implements DeviceGamePickerState {
  const DeviceGamePickerState_Success(this.deviceGame);
  

 final  DeviceGame deviceGame;

/// Create a copy of DeviceGamePickerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceGamePickerState_SuccessCopyWith<DeviceGamePickerState_Success> get copyWith => _$DeviceGamePickerState_SuccessCopyWithImpl<DeviceGamePickerState_Success>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceGamePickerState_Success&&(identical(other.deviceGame, deviceGame) || other.deviceGame == deviceGame));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceGame);
}

@override
String toString() {
    return 'DeviceGamePickerState.success(deviceGame: $deviceGame)';
}


}

/// @nodoc
abstract mixin class $DeviceGamePickerState_SuccessCopyWith<$Res> implements $DeviceGamePickerStateCopyWith<$Res> {
  factory $DeviceGamePickerState_SuccessCopyWith(DeviceGamePickerState_Success value, $Res Function(DeviceGamePickerState_Success) _then) = _$DeviceGamePickerState_SuccessCopyWithImpl;
@useResult
$Res call({
 DeviceGame deviceGame
});


$DeviceGameCopyWith<$Res> get deviceGame;

}
/// @nodoc
class _$DeviceGamePickerState_SuccessCopyWithImpl<$Res>
    implements $DeviceGamePickerState_SuccessCopyWith<$Res> {
  _$DeviceGamePickerState_SuccessCopyWithImpl(this._self, this._then);

  final DeviceGamePickerState_Success _self;
  final $Res Function(DeviceGamePickerState_Success) _then;

/// Create a copy of DeviceGamePickerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceGame = null,}) {
  return _then(DeviceGamePickerState_Success(
null == deviceGame ? _self.deviceGame : deviceGame // ignore: cast_nullable_to_non_nullable
as DeviceGame,
  ));
}

/// Create a copy of DeviceGamePickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceGameCopyWith<$Res> get deviceGame {
  
  return $DeviceGameCopyWith<$Res>(_self.deviceGame, (value) {
    return _then(_self.copyWith(deviceGame: value));
  });
}
}

// dart format on
