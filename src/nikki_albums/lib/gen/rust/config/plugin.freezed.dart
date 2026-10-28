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
