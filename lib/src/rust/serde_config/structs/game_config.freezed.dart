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

 Object? get toLauncher; Object get toInstall;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowsGameSearcherConfig&&const DeepCollectionEquality().equals(other.toLauncher, toLauncher)&&const DeepCollectionEquality().equals(other.toInstall, toInstall));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(toLauncher),const DeepCollectionEquality().hash(toInstall));

@override
String toString() {
  return 'WindowsGameSearcherConfig(toLauncher: $toLauncher, toInstall: $toInstall)';
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( WindowsRegistryConfig? toLauncher,  WindowsRegistryConfig toInstall,  bool useConfigFile)?  registry,TResult Function( String path,  ConfigFileType configType,  String? toLauncher,  String? toLauncherRegex,  String toInstall,  String? toInstallRegex)?  configFile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WindowsGameSearcherConfig_Registry() when registry != null:
return registry(_that.toLauncher,_that.toInstall,_that.useConfigFile);case WindowsGameSearcherConfig_ConfigFile() when configFile != null:
return configFile(_that.path,_that.configType,_that.toLauncher,_that.toLauncherRegex,_that.toInstall,_that.toInstallRegex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( WindowsRegistryConfig? toLauncher,  WindowsRegistryConfig toInstall,  bool useConfigFile)  registry,required TResult Function( String path,  ConfigFileType configType,  String? toLauncher,  String? toLauncherRegex,  String toInstall,  String? toInstallRegex)  configFile,}) {final _that = this;
switch (_that) {
case WindowsGameSearcherConfig_Registry():
return registry(_that.toLauncher,_that.toInstall,_that.useConfigFile);case WindowsGameSearcherConfig_ConfigFile():
return configFile(_that.path,_that.configType,_that.toLauncher,_that.toLauncherRegex,_that.toInstall,_that.toInstallRegex);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( WindowsRegistryConfig? toLauncher,  WindowsRegistryConfig toInstall,  bool useConfigFile)?  registry,TResult? Function( String path,  ConfigFileType configType,  String? toLauncher,  String? toLauncherRegex,  String toInstall,  String? toInstallRegex)?  configFile,}) {final _that = this;
switch (_that) {
case WindowsGameSearcherConfig_Registry() when registry != null:
return registry(_that.toLauncher,_that.toInstall,_that.useConfigFile);case WindowsGameSearcherConfig_ConfigFile() when configFile != null:
return configFile(_that.path,_that.configType,_that.toLauncher,_that.toLauncherRegex,_that.toInstall,_that.toInstallRegex);case _:
  return null;

}
}

}

/// @nodoc


class WindowsGameSearcherConfig_Registry extends WindowsGameSearcherConfig {
  const WindowsGameSearcherConfig_Registry({this.toLauncher, required this.toInstall, required this.useConfigFile}): super._();
  

@override final  WindowsRegistryConfig? toLauncher;
@override final  WindowsRegistryConfig toInstall;
 final  bool useConfigFile;

/// Create a copy of WindowsGameSearcherConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindowsGameSearcherConfig_RegistryCopyWith<WindowsGameSearcherConfig_Registry> get copyWith => _$WindowsGameSearcherConfig_RegistryCopyWithImpl<WindowsGameSearcherConfig_Registry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowsGameSearcherConfig_Registry&&(identical(other.toLauncher, toLauncher) || other.toLauncher == toLauncher)&&(identical(other.toInstall, toInstall) || other.toInstall == toInstall)&&(identical(other.useConfigFile, useConfigFile) || other.useConfigFile == useConfigFile));
}


@override
int get hashCode => Object.hash(runtimeType,toLauncher,toInstall,useConfigFile);

@override
String toString() {
  return 'WindowsGameSearcherConfig.registry(toLauncher: $toLauncher, toInstall: $toInstall, useConfigFile: $useConfigFile)';
}


}

/// @nodoc
abstract mixin class $WindowsGameSearcherConfig_RegistryCopyWith<$Res> implements $WindowsGameSearcherConfigCopyWith<$Res> {
  factory $WindowsGameSearcherConfig_RegistryCopyWith(WindowsGameSearcherConfig_Registry value, $Res Function(WindowsGameSearcherConfig_Registry) _then) = _$WindowsGameSearcherConfig_RegistryCopyWithImpl;
@useResult
$Res call({
 WindowsRegistryConfig? toLauncher, WindowsRegistryConfig toInstall, bool useConfigFile
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
@pragma('vm:prefer-inline') $Res call({Object? toLauncher = freezed,Object? toInstall = null,Object? useConfigFile = null,}) {
  return _then(WindowsGameSearcherConfig_Registry(
toLauncher: freezed == toLauncher ? _self.toLauncher : toLauncher // ignore: cast_nullable_to_non_nullable
as WindowsRegistryConfig?,toInstall: null == toInstall ? _self.toInstall : toInstall // ignore: cast_nullable_to_non_nullable
as WindowsRegistryConfig,useConfigFile: null == useConfigFile ? _self.useConfigFile : useConfigFile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class WindowsGameSearcherConfig_ConfigFile extends WindowsGameSearcherConfig {
  const WindowsGameSearcherConfig_ConfigFile({required this.path, required this.configType, this.toLauncher, this.toLauncherRegex, required this.toInstall, this.toInstallRegex}): super._();
  

 final  String path;
 final  ConfigFileType configType;
@override final  String? toLauncher;
 final  String? toLauncherRegex;
@override final  String toInstall;
 final  String? toInstallRegex;

/// Create a copy of WindowsGameSearcherConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindowsGameSearcherConfig_ConfigFileCopyWith<WindowsGameSearcherConfig_ConfigFile> get copyWith => _$WindowsGameSearcherConfig_ConfigFileCopyWithImpl<WindowsGameSearcherConfig_ConfigFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowsGameSearcherConfig_ConfigFile&&(identical(other.path, path) || other.path == path)&&(identical(other.configType, configType) || other.configType == configType)&&(identical(other.toLauncher, toLauncher) || other.toLauncher == toLauncher)&&(identical(other.toLauncherRegex, toLauncherRegex) || other.toLauncherRegex == toLauncherRegex)&&(identical(other.toInstall, toInstall) || other.toInstall == toInstall)&&(identical(other.toInstallRegex, toInstallRegex) || other.toInstallRegex == toInstallRegex));
}


@override
int get hashCode => Object.hash(runtimeType,path,configType,toLauncher,toLauncherRegex,toInstall,toInstallRegex);

@override
String toString() {
  return 'WindowsGameSearcherConfig.configFile(path: $path, configType: $configType, toLauncher: $toLauncher, toLauncherRegex: $toLauncherRegex, toInstall: $toInstall, toInstallRegex: $toInstallRegex)';
}


}

/// @nodoc
abstract mixin class $WindowsGameSearcherConfig_ConfigFileCopyWith<$Res> implements $WindowsGameSearcherConfigCopyWith<$Res> {
  factory $WindowsGameSearcherConfig_ConfigFileCopyWith(WindowsGameSearcherConfig_ConfigFile value, $Res Function(WindowsGameSearcherConfig_ConfigFile) _then) = _$WindowsGameSearcherConfig_ConfigFileCopyWithImpl;
@useResult
$Res call({
 String path, ConfigFileType configType, String? toLauncher, String? toLauncherRegex, String toInstall, String? toInstallRegex
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
@pragma('vm:prefer-inline') $Res call({Object? path = null,Object? configType = null,Object? toLauncher = freezed,Object? toLauncherRegex = freezed,Object? toInstall = null,Object? toInstallRegex = freezed,}) {
  return _then(WindowsGameSearcherConfig_ConfigFile(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,configType: null == configType ? _self.configType : configType // ignore: cast_nullable_to_non_nullable
as ConfigFileType,toLauncher: freezed == toLauncher ? _self.toLauncher : toLauncher // ignore: cast_nullable_to_non_nullable
as String?,toLauncherRegex: freezed == toLauncherRegex ? _self.toLauncherRegex : toLauncherRegex // ignore: cast_nullable_to_non_nullable
as String?,toInstall: null == toInstall ? _self.toInstall : toInstall // ignore: cast_nullable_to_non_nullable
as String,toInstallRegex: freezed == toInstallRegex ? _self.toInstallRegex : toInstallRegex // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
