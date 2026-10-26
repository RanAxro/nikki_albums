// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'script.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Script {

 Object get field0;



@override
bool operator ==(Object other) {
  final _this = this as Script;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Script&&const DeepCollectionEquality().equals(other.field0, _this.field0));
}


@override
int get hashCode {
  final _this = this as Script;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.field0));
}

@override
String toString() {
  final _this = this as Script;
  return 'Script(field0: ${_this.field0})';
}


}

/// @nodoc
class $ScriptCopyWith<$Res>  {
$ScriptCopyWith(Script _, $Res Function(Script) __);
}


/// Adds pattern-matching-related methods to [Script].
extension ScriptPatterns on Script {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Script_EasyScript value)?  easyScript,TResult Function( Script_JS value)?  js,TResult Function( Script_Wasm value)?  wasm,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Script_EasyScript() when easyScript != null:
return easyScript(_that);case Script_JS() when js != null:
return js(_that);case Script_Wasm() when wasm != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Script_EasyScript value)  easyScript,required TResult Function( Script_JS value)  js,required TResult Function( Script_Wasm value)  wasm,}){
final _that = this;
switch (_that) {
case Script_EasyScript():
return easyScript(_that);case Script_JS():
return js(_that);case Script_Wasm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Script_EasyScript value)?  easyScript,TResult? Function( Script_JS value)?  js,TResult? Function( Script_Wasm value)?  wasm,}){
final _that = this;
switch (_that) {
case Script_EasyScript() when easyScript != null:
return easyScript(_that);case Script_JS() when js != null:
return js(_that);case Script_Wasm() when wasm != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<EasyScript> field0)?  easyScript,TResult Function( String field0)?  js,TResult Function( String field0)?  wasm,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Script_EasyScript() when easyScript != null:
return easyScript(_that.field0);case Script_JS() when js != null:
return js(_that.field0);case Script_Wasm() when wasm != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<EasyScript> field0)  easyScript,required TResult Function( String field0)  js,required TResult Function( String field0)  wasm,}) {final _that = this;
switch (_that) {
case Script_EasyScript():
return easyScript(_that.field0);case Script_JS():
return js(_that.field0);case Script_Wasm():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<EasyScript> field0)?  easyScript,TResult? Function( String field0)?  js,TResult? Function( String field0)?  wasm,}) {final _that = this;
switch (_that) {
case Script_EasyScript() when easyScript != null:
return easyScript(_that.field0);case Script_JS() when js != null:
return js(_that.field0);case Script_Wasm() when wasm != null:
return wasm(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class Script_EasyScript extends Script {
  const Script_EasyScript( List<EasyScript> field0): _field0 = field0,super._();
  

 final  List<EasyScript> _field0;
@override List<EasyScript> get field0 {
  if (_field0 is EqualUnmodifiableListView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field0);
}


/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Script_EasyScriptCopyWith<Script_EasyScript> get copyWith => _$Script_EasyScriptCopyWithImpl<Script_EasyScript>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Script_EasyScript&&const DeepCollectionEquality().equals(other.field0, _field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));
}

@override
String toString() {
    return 'Script.easyScript(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Script_EasyScriptCopyWith<$Res> implements $ScriptCopyWith<$Res> {
  factory $Script_EasyScriptCopyWith(Script_EasyScript value, $Res Function(Script_EasyScript) _then) = _$Script_EasyScriptCopyWithImpl;
@useResult
$Res call({
 List<EasyScript> field0
});




}
/// @nodoc
class _$Script_EasyScriptCopyWithImpl<$Res>
    implements $Script_EasyScriptCopyWith<$Res> {
  _$Script_EasyScriptCopyWithImpl(this._self, this._then);

  final Script_EasyScript _self;
  final $Res Function(Script_EasyScript) _then;

/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Script_EasyScript(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as List<EasyScript>,
  ));
}


}

/// @nodoc


class Script_JS extends Script {
  const Script_JS(this.field0): super._();
  

@override final  String field0;

/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Script_JSCopyWith<Script_JS> get copyWith => _$Script_JSCopyWithImpl<Script_JS>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Script_JS&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'Script.js(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Script_JSCopyWith<$Res> implements $ScriptCopyWith<$Res> {
  factory $Script_JSCopyWith(Script_JS value, $Res Function(Script_JS) _then) = _$Script_JSCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$Script_JSCopyWithImpl<$Res>
    implements $Script_JSCopyWith<$Res> {
  _$Script_JSCopyWithImpl(this._self, this._then);

  final Script_JS _self;
  final $Res Function(Script_JS) _then;

/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Script_JS(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class Script_Wasm extends Script {
  const Script_Wasm(this.field0): super._();
  

@override final  String field0;

/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Script_WasmCopyWith<Script_Wasm> get copyWith => _$Script_WasmCopyWithImpl<Script_Wasm>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Script_Wasm&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'Script.wasm(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Script_WasmCopyWith<$Res> implements $ScriptCopyWith<$Res> {
  factory $Script_WasmCopyWith(Script_Wasm value, $Res Function(Script_Wasm) _then) = _$Script_WasmCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$Script_WasmCopyWithImpl<$Res>
    implements $Script_WasmCopyWith<$Res> {
  _$Script_WasmCopyWithImpl(this._self, this._then);

  final Script_Wasm _self;
  final $Res Function(Script_Wasm) _then;

/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Script_Wasm(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
