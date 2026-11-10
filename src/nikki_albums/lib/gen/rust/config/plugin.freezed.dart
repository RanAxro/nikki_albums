// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plugin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PickedDeviceGameResult {

 Object? get field0;



@override
bool operator ==(Object other) {
  final _this = this as PickedDeviceGameResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickedDeviceGameResult&&const DeepCollectionEquality().equals(other.field0, _this.field0));
}


@override
int get hashCode {
  final _this = this as PickedDeviceGameResult;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.field0));
}

@override
String toString() {
  final _this = this as PickedDeviceGameResult;
  return 'PickedDeviceGameResult(field0: ${_this.field0})';
}


}

/// @nodoc
class $PickedDeviceGameResultCopyWith<$Res>  {
$PickedDeviceGameResultCopyWith(PickedDeviceGameResult _, $Res Function(PickedDeviceGameResult) __);
}


/// Adds pattern-matching-related methods to [PickedDeviceGameResult].
extension PickedDeviceGameResultPatterns on PickedDeviceGameResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PickedDeviceGameResult_Ok value)?  ok,TResult Function( PickedDeviceGameResult_Err value)?  err,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PickedDeviceGameResult_Ok() when ok != null:
return ok(_that);case PickedDeviceGameResult_Err() when err != null:
return err(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PickedDeviceGameResult_Ok value)  ok,required TResult Function( PickedDeviceGameResult_Err value)  err,}){
final _that = this;
switch (_that) {
case PickedDeviceGameResult_Ok():
return ok(_that);case PickedDeviceGameResult_Err():
return err(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PickedDeviceGameResult_Ok value)?  ok,TResult? Function( PickedDeviceGameResult_Err value)?  err,}){
final _that = this;
switch (_that) {
case PickedDeviceGameResult_Ok() when ok != null:
return ok(_that);case PickedDeviceGameResult_Err() when err != null:
return err(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DeviceGame field0)?  ok,TResult Function( TextRule? field0)?  err,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PickedDeviceGameResult_Ok() when ok != null:
return ok(_that.field0);case PickedDeviceGameResult_Err() when err != null:
return err(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DeviceGame field0)  ok,required TResult Function( TextRule? field0)  err,}) {final _that = this;
switch (_that) {
case PickedDeviceGameResult_Ok():
return ok(_that.field0);case PickedDeviceGameResult_Err():
return err(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DeviceGame field0)?  ok,TResult? Function( TextRule? field0)?  err,}) {final _that = this;
switch (_that) {
case PickedDeviceGameResult_Ok() when ok != null:
return ok(_that.field0);case PickedDeviceGameResult_Err() when err != null:
return err(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class PickedDeviceGameResult_Ok extends PickedDeviceGameResult {
  const PickedDeviceGameResult_Ok(this.field0): super._();
  

@override final  DeviceGame field0;

/// Create a copy of PickedDeviceGameResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickedDeviceGameResult_OkCopyWith<PickedDeviceGameResult_Ok> get copyWith => _$PickedDeviceGameResult_OkCopyWithImpl<PickedDeviceGameResult_Ok>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PickedDeviceGameResult_Ok&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'PickedDeviceGameResult.ok(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $PickedDeviceGameResult_OkCopyWith<$Res> implements $PickedDeviceGameResultCopyWith<$Res> {
  factory $PickedDeviceGameResult_OkCopyWith(PickedDeviceGameResult_Ok value, $Res Function(PickedDeviceGameResult_Ok) _then) = _$PickedDeviceGameResult_OkCopyWithImpl;
@useResult
$Res call({
 DeviceGame field0
});


$DeviceGameCopyWith<$Res> get field0;

}
/// @nodoc
class _$PickedDeviceGameResult_OkCopyWithImpl<$Res>
    implements $PickedDeviceGameResult_OkCopyWith<$Res> {
  _$PickedDeviceGameResult_OkCopyWithImpl(this._self, this._then);

  final PickedDeviceGameResult_Ok _self;
  final $Res Function(PickedDeviceGameResult_Ok) _then;

/// Create a copy of PickedDeviceGameResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(PickedDeviceGameResult_Ok(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as DeviceGame,
  ));
}

/// Create a copy of PickedDeviceGameResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceGameCopyWith<$Res> get field0 {
  
  return $DeviceGameCopyWith<$Res>(_self.field0, (value) {
    return _then(_self.copyWith(field0: value));
  });
}
}

/// @nodoc


class PickedDeviceGameResult_Err extends PickedDeviceGameResult {
  const PickedDeviceGameResult_Err([this.field0]): super._();
  

@override final  TextRule? field0;

/// Create a copy of PickedDeviceGameResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickedDeviceGameResult_ErrCopyWith<PickedDeviceGameResult_Err> get copyWith => _$PickedDeviceGameResult_ErrCopyWithImpl<PickedDeviceGameResult_Err>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PickedDeviceGameResult_Err&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'PickedDeviceGameResult.err(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $PickedDeviceGameResult_ErrCopyWith<$Res> implements $PickedDeviceGameResultCopyWith<$Res> {
  factory $PickedDeviceGameResult_ErrCopyWith(PickedDeviceGameResult_Err value, $Res Function(PickedDeviceGameResult_Err) _then) = _$PickedDeviceGameResult_ErrCopyWithImpl;
@useResult
$Res call({
 TextRule? field0
});


$TextRuleCopyWith<$Res>? get field0;

}
/// @nodoc
class _$PickedDeviceGameResult_ErrCopyWithImpl<$Res>
    implements $PickedDeviceGameResult_ErrCopyWith<$Res> {
  _$PickedDeviceGameResult_ErrCopyWithImpl(this._self, this._then);

  final PickedDeviceGameResult_Err _self;
  final $Res Function(PickedDeviceGameResult_Err) _then;

/// Create a copy of PickedDeviceGameResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = freezed,}) {
  return _then(PickedDeviceGameResult_Err(
freezed == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as TextRule?,
  ));
}

/// Create a copy of PickedDeviceGameResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextRuleCopyWith<$Res>? get field0 {
    if (_self.field0 == null) {
    return null;
  }

  return $TextRuleCopyWith<$Res>(_self.field0!, (value) {
    return _then(_self.copyWith(field0: value));
  });
}
}

/// @nodoc
mixin _$ScriptInfo {

 Object get field0;



@override
bool operator ==(Object other) {
  final _this = this as ScriptInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptInfo&&const DeepCollectionEquality().equals(other.field0, _this.field0));
}


@override
int get hashCode {
  final _this = this as ScriptInfo;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.field0));
}

@override
String toString() {
  final _this = this as ScriptInfo;
  return 'ScriptInfo(field0: ${_this.field0})';
}


}

/// @nodoc
class $ScriptInfoCopyWith<$Res>  {
$ScriptInfoCopyWith(ScriptInfo _, $Res Function(ScriptInfo) __);
}


/// Adds pattern-matching-related methods to [ScriptInfo].
extension ScriptInfoPatterns on ScriptInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScriptInfo_NES value)?  nes,TResult Function( ScriptInfo_JS value)?  js,TResult Function( ScriptInfo_Wasm value)?  wasm,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScriptInfo_NES() when nes != null:
return nes(_that);case ScriptInfo_JS() when js != null:
return js(_that);case ScriptInfo_Wasm() when wasm != null:
return wasm(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScriptInfo_NES value)  nes,required TResult Function( ScriptInfo_JS value)  js,required TResult Function( ScriptInfo_Wasm value)  wasm,}){
final _that = this;
switch (_that) {
case ScriptInfo_NES():
return nes(_that);case ScriptInfo_JS():
return js(_that);case ScriptInfo_Wasm():
return wasm(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScriptInfo_NES value)?  nes,TResult? Function( ScriptInfo_JS value)?  js,TResult? Function( ScriptInfo_Wasm value)?  wasm,}){
final _that = this;
switch (_that) {
case ScriptInfo_NES() when nes != null:
return nes(_that);case ScriptInfo_JS() when js != null:
return js(_that);case ScriptInfo_Wasm() when wasm != null:
return wasm(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<NES> field0)?  nes,TResult Function( JSScriptInfo field0)?  js,TResult Function( String field0)?  wasm,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScriptInfo_NES() when nes != null:
return nes(_that.field0);case ScriptInfo_JS() when js != null:
return js(_that.field0);case ScriptInfo_Wasm() when wasm != null:
return wasm(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<NES> field0)  nes,required TResult Function( JSScriptInfo field0)  js,required TResult Function( String field0)  wasm,}) {final _that = this;
switch (_that) {
case ScriptInfo_NES():
return nes(_that.field0);case ScriptInfo_JS():
return js(_that.field0);case ScriptInfo_Wasm():
return wasm(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<NES> field0)?  nes,TResult? Function( JSScriptInfo field0)?  js,TResult? Function( String field0)?  wasm,}) {final _that = this;
switch (_that) {
case ScriptInfo_NES() when nes != null:
return nes(_that.field0);case ScriptInfo_JS() when js != null:
return js(_that.field0);case ScriptInfo_Wasm() when wasm != null:
return wasm(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ScriptInfo_NES extends ScriptInfo {
  const ScriptInfo_NES( List<NES> field0): _field0 = field0,super._();
  

 final  List<NES> _field0;
@override List<NES> get field0 {
  if (_field0 is EqualUnmodifiableListView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field0);
}


/// Create a copy of ScriptInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptInfo_NESCopyWith<ScriptInfo_NES> get copyWith => _$ScriptInfo_NESCopyWithImpl<ScriptInfo_NES>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptInfo_NES&&const DeepCollectionEquality().equals(other.field0, _field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));
}

@override
String toString() {
    return 'ScriptInfo.nes(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ScriptInfo_NESCopyWith<$Res> implements $ScriptInfoCopyWith<$Res> {
  factory $ScriptInfo_NESCopyWith(ScriptInfo_NES value, $Res Function(ScriptInfo_NES) _then) = _$ScriptInfo_NESCopyWithImpl;
@useResult
$Res call({
 List<NES> field0
});




}
/// @nodoc
class _$ScriptInfo_NESCopyWithImpl<$Res>
    implements $ScriptInfo_NESCopyWith<$Res> {
  _$ScriptInfo_NESCopyWithImpl(this._self, this._then);

  final ScriptInfo_NES _self;
  final $Res Function(ScriptInfo_NES) _then;

/// Create a copy of ScriptInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ScriptInfo_NES(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as List<NES>,
  ));
}


}

/// @nodoc


class ScriptInfo_JS extends ScriptInfo {
  const ScriptInfo_JS(this.field0): super._();
  

@override final  JSScriptInfo field0;

/// Create a copy of ScriptInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptInfo_JSCopyWith<ScriptInfo_JS> get copyWith => _$ScriptInfo_JSCopyWithImpl<ScriptInfo_JS>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptInfo_JS&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'ScriptInfo.js(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ScriptInfo_JSCopyWith<$Res> implements $ScriptInfoCopyWith<$Res> {
  factory $ScriptInfo_JSCopyWith(ScriptInfo_JS value, $Res Function(ScriptInfo_JS) _then) = _$ScriptInfo_JSCopyWithImpl;
@useResult
$Res call({
 JSScriptInfo field0
});




}
/// @nodoc
class _$ScriptInfo_JSCopyWithImpl<$Res>
    implements $ScriptInfo_JSCopyWith<$Res> {
  _$ScriptInfo_JSCopyWithImpl(this._self, this._then);

  final ScriptInfo_JS _self;
  final $Res Function(ScriptInfo_JS) _then;

/// Create a copy of ScriptInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ScriptInfo_JS(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as JSScriptInfo,
  ));
}


}

/// @nodoc


class ScriptInfo_Wasm extends ScriptInfo {
  const ScriptInfo_Wasm(this.field0): super._();
  

@override final  String field0;

/// Create a copy of ScriptInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptInfo_WasmCopyWith<ScriptInfo_Wasm> get copyWith => _$ScriptInfo_WasmCopyWithImpl<ScriptInfo_Wasm>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptInfo_Wasm&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'ScriptInfo.wasm(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ScriptInfo_WasmCopyWith<$Res> implements $ScriptInfoCopyWith<$Res> {
  factory $ScriptInfo_WasmCopyWith(ScriptInfo_Wasm value, $Res Function(ScriptInfo_Wasm) _then) = _$ScriptInfo_WasmCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$ScriptInfo_WasmCopyWithImpl<$Res>
    implements $ScriptInfo_WasmCopyWith<$Res> {
  _$ScriptInfo_WasmCopyWithImpl(this._self, this._then);

  final ScriptInfo_Wasm _self;
  final $Res Function(ScriptInfo_Wasm) _then;

/// Create a copy of ScriptInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ScriptInfo_Wasm(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
