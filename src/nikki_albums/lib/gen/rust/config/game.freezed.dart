// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Game {

 String get uniqueId; Map<String, String> get info; String get installPath;
/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameCopyWith<Game> get copyWith => _$GameCopyWithImpl<Game>(this as Game, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Game;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Game&&(identical(other.uniqueId, _this.uniqueId) || other.uniqueId == _this.uniqueId)&&const DeepCollectionEquality().equals(other.info, _this.info)&&(identical(other.installPath, _this.installPath) || other.installPath == _this.installPath));
}


@override
int get hashCode {
  final _this = this as Game;
  return Object.hash(runtimeType,_this.uniqueId,const DeepCollectionEquality().hash(_this.info),_this.installPath);
}

@override
String toString() {
  final _this = this as Game;
  return 'Game(uniqueId: ${_this.uniqueId}, info: ${_this.info}, installPath: ${_this.installPath})';
}


}

/// @nodoc
abstract mixin class $GameCopyWith<$Res>  {
  factory $GameCopyWith(Game value, $Res Function(Game) _then) = _$GameCopyWithImpl;
@useResult
$Res call({
 String uniqueId, Map<String, String> info, String installPath
});




}
/// @nodoc
class _$GameCopyWithImpl<$Res>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._self, this._then);

  final Game _self;
  final $Res Function(Game) _then;

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uniqueId = null,Object? info = null,Object? installPath = null,}) {
  return _then(Game(
uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Map<String, String>,installPath: null == installPath ? _self.installPath : installPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Game].
extension GamePatterns on Game {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Game value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Game value)  $default,){
final _that = this;
switch (_that) {
case _Game():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Game value)?  $default,){
final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uniqueId,  Map<String, String> info,  String installPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that.uniqueId,_that.info,_that.installPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uniqueId,  Map<String, String> info,  String installPath)  $default,) {final _that = this;
switch (_that) {
case _Game():
return $default(_that.uniqueId,_that.info,_that.installPath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uniqueId,  Map<String, String> info,  String installPath)?  $default,) {final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that.uniqueId,_that.info,_that.installPath);case _:
  return null;

}
}

}

/// @nodoc


class _Game extends Game {
  const _Game({required this.uniqueId, required  Map<String, String> info, required this.installPath}): _info = info,super._();
  

@override final  String uniqueId;
 final  Map<String, String> _info;
@override Map<String, String> get info {
  if (_info is EqualUnmodifiableMapView) return _info;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_info);
}

@override final  String installPath;

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameCopyWith<_Game> get copyWith => __$GameCopyWithImpl<_Game>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Game&&(identical(other.uniqueId, uniqueId) || other.uniqueId == uniqueId)&&const DeepCollectionEquality().equals(other.info, _info)&&(identical(other.installPath, installPath) || other.installPath == installPath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,uniqueId,const DeepCollectionEquality().hash(_info),installPath);
}

@override
String toString() {
    return 'Game(uniqueId: $uniqueId, info: $info, installPath: $installPath)';
}


}

/// @nodoc
abstract mixin class _$GameCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$GameCopyWith(_Game value, $Res Function(_Game) _then) = __$GameCopyWithImpl;
@override @useResult
$Res call({
 String uniqueId, Map<String, String> info, String installPath
});




}
/// @nodoc
class __$GameCopyWithImpl<$Res>
    implements _$GameCopyWith<$Res> {
  __$GameCopyWithImpl(this._self, this._then);

  final _Game _self;
  final $Res Function(_Game) _then;

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uniqueId = null,Object? info = null,Object? installPath = null,}) {
  return _then(_Game(
uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self._info : info // ignore: cast_nullable_to_non_nullable
as Map<String, String>,installPath: null == installPath ? _self.installPath : installPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$GameRegistry {

 String get ownership; String get uuid; TextRule get name; IconRule get icon; GameConnectionMethod get connectMethod; GamePickerConfig? get customGamePicker;
/// Create a copy of GameRegistry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameRegistryCopyWith<GameRegistry> get copyWith => _$GameRegistryCopyWithImpl<GameRegistry>(this as GameRegistry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GameRegistry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameRegistry&&(identical(other.ownership, _this.ownership) || other.ownership == _this.ownership)&&(identical(other.uuid, _this.uuid) || other.uuid == _this.uuid)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.connectMethod, _this.connectMethod) || other.connectMethod == _this.connectMethod)&&(identical(other.customGamePicker, _this.customGamePicker) || other.customGamePicker == _this.customGamePicker));
}


@override
int get hashCode {
  final _this = this as GameRegistry;
  return Object.hash(runtimeType,_this.ownership,_this.uuid,_this.name,_this.icon,_this.connectMethod,_this.customGamePicker);
}

@override
String toString() {
  final _this = this as GameRegistry;
  return 'GameRegistry(ownership: ${_this.ownership}, uuid: ${_this.uuid}, name: ${_this.name}, icon: ${_this.icon}, connectMethod: ${_this.connectMethod}, customGamePicker: ${_this.customGamePicker})';
}


}

/// @nodoc
abstract mixin class $GameRegistryCopyWith<$Res>  {
  factory $GameRegistryCopyWith(GameRegistry value, $Res Function(GameRegistry) _then) = _$GameRegistryCopyWithImpl;
@useResult
$Res call({
 String ownership, String uuid, TextRule name, IconRule icon, GameConnectionMethod connectMethod, GamePickerConfig? customGamePicker
});


$TextRuleCopyWith<$Res> get name;$IconRuleCopyWith<$Res> get icon;

}
/// @nodoc
class _$GameRegistryCopyWithImpl<$Res>
    implements $GameRegistryCopyWith<$Res> {
  _$GameRegistryCopyWithImpl(this._self, this._then);

  final GameRegistry _self;
  final $Res Function(GameRegistry) _then;

/// Create a copy of GameRegistry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ownership = null,Object? uuid = null,Object? name = null,Object? icon = null,Object? connectMethod = null,Object? customGamePicker = freezed,}) {
  return _then(GameRegistry(
ownership: null == ownership ? _self.ownership : ownership // ignore: cast_nullable_to_non_nullable
as String,uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as TextRule,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconRule,connectMethod: null == connectMethod ? _self.connectMethod : connectMethod // ignore: cast_nullable_to_non_nullable
as GameConnectionMethod,customGamePicker: freezed == customGamePicker ? _self.customGamePicker : customGamePicker // ignore: cast_nullable_to_non_nullable
as GamePickerConfig?,
  ));
}
/// Create a copy of GameRegistry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextRuleCopyWith<$Res> get name {
  
  return $TextRuleCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of GameRegistry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IconRuleCopyWith<$Res> get icon {
  
  return $IconRuleCopyWith<$Res>(_self.icon, (value) {
    return _then(_self.copyWith(icon: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameRegistry].
extension GameRegistryPatterns on GameRegistry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameRegistry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameRegistry() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameRegistry value)  $default,){
final _that = this;
switch (_that) {
case _GameRegistry():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameRegistry value)?  $default,){
final _that = this;
switch (_that) {
case _GameRegistry() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ownership,  String uuid,  TextRule name,  IconRule icon,  GameConnectionMethod connectMethod,  GamePickerConfig? customGamePicker)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameRegistry() when $default != null:
return $default(_that.ownership,_that.uuid,_that.name,_that.icon,_that.connectMethod,_that.customGamePicker);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ownership,  String uuid,  TextRule name,  IconRule icon,  GameConnectionMethod connectMethod,  GamePickerConfig? customGamePicker)  $default,) {final _that = this;
switch (_that) {
case _GameRegistry():
return $default(_that.ownership,_that.uuid,_that.name,_that.icon,_that.connectMethod,_that.customGamePicker);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ownership,  String uuid,  TextRule name,  IconRule icon,  GameConnectionMethod connectMethod,  GamePickerConfig? customGamePicker)?  $default,) {final _that = this;
switch (_that) {
case _GameRegistry() when $default != null:
return $default(_that.ownership,_that.uuid,_that.name,_that.icon,_that.connectMethod,_that.customGamePicker);case _:
  return null;

}
}

}

/// @nodoc


class _GameRegistry extends GameRegistry {
  const _GameRegistry({required this.ownership, required this.uuid, required this.name, required this.icon, required this.connectMethod, this.customGamePicker}): super._();
  

@override final  String ownership;
@override final  String uuid;
@override final  TextRule name;
@override final  IconRule icon;
@override final  GameConnectionMethod connectMethod;
@override final  GamePickerConfig? customGamePicker;

/// Create a copy of GameRegistry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameRegistryCopyWith<_GameRegistry> get copyWith => __$GameRegistryCopyWithImpl<_GameRegistry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameRegistry&&(identical(other.ownership, ownership) || other.ownership == ownership)&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.connectMethod, connectMethod) || other.connectMethod == connectMethod)&&(identical(other.customGamePicker, customGamePicker) || other.customGamePicker == customGamePicker));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ownership,uuid,name,icon,connectMethod,customGamePicker);
}

@override
String toString() {
    return 'GameRegistry(ownership: $ownership, uuid: $uuid, name: $name, icon: $icon, connectMethod: $connectMethod, customGamePicker: $customGamePicker)';
}


}

/// @nodoc
abstract mixin class _$GameRegistryCopyWith<$Res> implements $GameRegistryCopyWith<$Res> {
  factory _$GameRegistryCopyWith(_GameRegistry value, $Res Function(_GameRegistry) _then) = __$GameRegistryCopyWithImpl;
@override @useResult
$Res call({
 String ownership, String uuid, TextRule name, IconRule icon, GameConnectionMethod connectMethod, GamePickerConfig? customGamePicker
});


@override $TextRuleCopyWith<$Res> get name;@override $IconRuleCopyWith<$Res> get icon;

}
/// @nodoc
class __$GameRegistryCopyWithImpl<$Res>
    implements _$GameRegistryCopyWith<$Res> {
  __$GameRegistryCopyWithImpl(this._self, this._then);

  final _GameRegistry _self;
  final $Res Function(_GameRegistry) _then;

/// Create a copy of GameRegistry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ownership = null,Object? uuid = null,Object? name = null,Object? icon = null,Object? connectMethod = null,Object? customGamePicker = freezed,}) {
  return _then(_GameRegistry(
ownership: null == ownership ? _self.ownership : ownership // ignore: cast_nullable_to_non_nullable
as String,uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as TextRule,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconRule,connectMethod: null == connectMethod ? _self.connectMethod : connectMethod // ignore: cast_nullable_to_non_nullable
as GameConnectionMethod,customGamePicker: freezed == customGamePicker ? _self.customGamePicker : customGamePicker // ignore: cast_nullable_to_non_nullable
as GamePickerConfig?,
  ));
}

/// Create a copy of GameRegistry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextRuleCopyWith<$Res> get name {
  
  return $TextRuleCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of GameRegistry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IconRuleCopyWith<$Res> get icon {
  
  return $IconRuleCopyWith<$Res>(_self.icon, (value) {
    return _then(_self.copyWith(icon: value));
  });
}
}

// dart format on
