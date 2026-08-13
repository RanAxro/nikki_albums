// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WindowsGameSearcherConfig {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowsGameSearcherConfig&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'WindowsGameSearcherConfig(field0: $field0)';
}


}

/// @nodoc
class $WindowsGameSearcherConfigCopyWith<$Res>  {
$WindowsGameSearcherConfigCopyWith(WindowsGameSearcherConfig _, $Res Function(WindowsGameSearcherConfig) __);
}


/// Adds pattern-matching-related methods to [WindowsGameSearcherConfig].
extension WindowsGameSearcherConfigPatterns on WindowsGameSearcherConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WindowsGameSearcherConfig_Registry value)?  registry,TResult Function( WindowsGameSearcherConfig_ConfigFile value)?  configFile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WindowsGameSearcherConfig_Registry() when registry != null:
return registry(_that);case WindowsGameSearcherConfig_ConfigFile() when configFile != null:
return configFile(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WindowsGameSearcherConfig_Registry value)  registry,required TResult Function( WindowsGameSearcherConfig_ConfigFile value)  configFile,}){
final _that = this;
switch (_that) {
case WindowsGameSearcherConfig_Registry():
return registry(_that);case WindowsGameSearcherConfig_ConfigFile():
return configFile(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WindowsGameSearcherConfig_Registry value)?  registry,TResult? Function( WindowsGameSearcherConfig_ConfigFile value)?  configFile,}){
final _that = this;
switch (_that) {
case WindowsGameSearcherConfig_Registry() when registry != null:
return registry(_that);case WindowsGameSearcherConfig_ConfigFile() when configFile != null:
return configFile(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( WindowsGameRegistrySearcherConfig field0)?  registry,TResult Function( WindowsGameConfigFileSearcherConfig field0)?  configFile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WindowsGameSearcherConfig_Registry() when registry != null:
return registry(_that.field0);case WindowsGameSearcherConfig_ConfigFile() when configFile != null:
return configFile(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( WindowsGameRegistrySearcherConfig field0)  registry,required TResult Function( WindowsGameConfigFileSearcherConfig field0)  configFile,}) {final _that = this;
switch (_that) {
case WindowsGameSearcherConfig_Registry():
return registry(_that.field0);case WindowsGameSearcherConfig_ConfigFile():
return configFile(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( WindowsGameRegistrySearcherConfig field0)?  registry,TResult? Function( WindowsGameConfigFileSearcherConfig field0)?  configFile,}) {final _that = this;
switch (_that) {
case WindowsGameSearcherConfig_Registry() when registry != null:
return registry(_that.field0);case WindowsGameSearcherConfig_ConfigFile() when configFile != null:
return configFile(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class WindowsGameSearcherConfig_Registry extends WindowsGameSearcherConfig {
  const WindowsGameSearcherConfig_Registry(this.field0): super._();
  

@override final  WindowsGameRegistrySearcherConfig field0;

/// Create a copy of WindowsGameSearcherConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindowsGameSearcherConfig_RegistryCopyWith<WindowsGameSearcherConfig_Registry> get copyWith => _$WindowsGameSearcherConfig_RegistryCopyWithImpl<WindowsGameSearcherConfig_Registry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowsGameSearcherConfig_Registry&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'WindowsGameSearcherConfig.registry(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $WindowsGameSearcherConfig_RegistryCopyWith<$Res> implements $WindowsGameSearcherConfigCopyWith<$Res> {
  factory $WindowsGameSearcherConfig_RegistryCopyWith(WindowsGameSearcherConfig_Registry value, $Res Function(WindowsGameSearcherConfig_Registry) _then) = _$WindowsGameSearcherConfig_RegistryCopyWithImpl;
@useResult
$Res call({
 WindowsGameRegistrySearcherConfig field0
});




}
/// @nodoc
class _$WindowsGameSearcherConfig_RegistryCopyWithImpl<$Res>
    implements $WindowsGameSearcherConfig_RegistryCopyWith<$Res> {
  _$WindowsGameSearcherConfig_RegistryCopyWithImpl(this._self, this._then);

  final WindowsGameSearcherConfig_Registry _self;
  final $Res Function(WindowsGameSearcherConfig_Registry) _then;

/// Create a copy of WindowsGameSearcherConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(WindowsGameSearcherConfig_Registry(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as WindowsGameRegistrySearcherConfig,
  ));
}


}

/// @nodoc


class WindowsGameSearcherConfig_ConfigFile extends WindowsGameSearcherConfig {
  const WindowsGameSearcherConfig_ConfigFile(this.field0): super._();
  

@override final  WindowsGameConfigFileSearcherConfig field0;

/// Create a copy of WindowsGameSearcherConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindowsGameSearcherConfig_ConfigFileCopyWith<WindowsGameSearcherConfig_ConfigFile> get copyWith => _$WindowsGameSearcherConfig_ConfigFileCopyWithImpl<WindowsGameSearcherConfig_ConfigFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowsGameSearcherConfig_ConfigFile&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'WindowsGameSearcherConfig.configFile(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $WindowsGameSearcherConfig_ConfigFileCopyWith<$Res> implements $WindowsGameSearcherConfigCopyWith<$Res> {
  factory $WindowsGameSearcherConfig_ConfigFileCopyWith(WindowsGameSearcherConfig_ConfigFile value, $Res Function(WindowsGameSearcherConfig_ConfigFile) _then) = _$WindowsGameSearcherConfig_ConfigFileCopyWithImpl;
@useResult
$Res call({
 WindowsGameConfigFileSearcherConfig field0
});




}
/// @nodoc
class _$WindowsGameSearcherConfig_ConfigFileCopyWithImpl<$Res>
    implements $WindowsGameSearcherConfig_ConfigFileCopyWith<$Res> {
  _$WindowsGameSearcherConfig_ConfigFileCopyWithImpl(this._self, this._then);

  final WindowsGameSearcherConfig_ConfigFile _self;
  final $Res Function(WindowsGameSearcherConfig_ConfigFile) _then;

/// Create a copy of WindowsGameSearcherConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(WindowsGameSearcherConfig_ConfigFile(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as WindowsGameConfigFileSearcherConfig,
  ));
}


}

// dart format on
