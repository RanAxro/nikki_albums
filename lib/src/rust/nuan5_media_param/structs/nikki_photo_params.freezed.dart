// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nikki_photo_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditPhotoState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditPhotoState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditPhotoState()';
}


}

/// @nodoc
class $EditPhotoStateCopyWith<$Res>  {
$EditPhotoStateCopyWith(EditPhotoState _, $Res Function(EditPhotoState) __);
}


/// Adds pattern-matching-related methods to [EditPhotoState].
extension EditPhotoStatePatterns on EditPhotoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditPhotoState_Enabled value)?  enabled,TResult Function( EditPhotoState_Disabled value)?  disabled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditPhotoState_Enabled() when enabled != null:
return enabled(_that);case EditPhotoState_Disabled() when disabled != null:
return disabled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditPhotoState_Enabled value)  enabled,required TResult Function( EditPhotoState_Disabled value)  disabled,}){
final _that = this;
switch (_that) {
case EditPhotoState_Enabled():
return enabled(_that);case EditPhotoState_Disabled():
return disabled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditPhotoState_Enabled value)?  enabled,TResult? Function( EditPhotoState_Disabled value)?  disabled,}){
final _that = this;
switch (_that) {
case EditPhotoState_Enabled() when enabled != null:
return enabled(_that);case EditPhotoState_Disabled() when disabled != null:
return disabled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( EditPhotoParams field0)?  enabled,TResult Function()?  disabled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditPhotoState_Enabled() when enabled != null:
return enabled(_that.field0);case EditPhotoState_Disabled() when disabled != null:
return disabled();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( EditPhotoParams field0)  enabled,required TResult Function()  disabled,}) {final _that = this;
switch (_that) {
case EditPhotoState_Enabled():
return enabled(_that.field0);case EditPhotoState_Disabled():
return disabled();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( EditPhotoParams field0)?  enabled,TResult? Function()?  disabled,}) {final _that = this;
switch (_that) {
case EditPhotoState_Enabled() when enabled != null:
return enabled(_that.field0);case EditPhotoState_Disabled() when disabled != null:
return disabled();case _:
  return null;

}
}

}

/// @nodoc


class EditPhotoState_Enabled extends EditPhotoState {
  const EditPhotoState_Enabled(this.field0): super._();
  

 final  EditPhotoParams field0;

/// Create a copy of EditPhotoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditPhotoState_EnabledCopyWith<EditPhotoState_Enabled> get copyWith => _$EditPhotoState_EnabledCopyWithImpl<EditPhotoState_Enabled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditPhotoState_Enabled&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'EditPhotoState.enabled(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $EditPhotoState_EnabledCopyWith<$Res> implements $EditPhotoStateCopyWith<$Res> {
  factory $EditPhotoState_EnabledCopyWith(EditPhotoState_Enabled value, $Res Function(EditPhotoState_Enabled) _then) = _$EditPhotoState_EnabledCopyWithImpl;
@useResult
$Res call({
 EditPhotoParams field0
});




}
/// @nodoc
class _$EditPhotoState_EnabledCopyWithImpl<$Res>
    implements $EditPhotoState_EnabledCopyWith<$Res> {
  _$EditPhotoState_EnabledCopyWithImpl(this._self, this._then);

  final EditPhotoState_Enabled _self;
  final $Res Function(EditPhotoState_Enabled) _then;

/// Create a copy of EditPhotoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(EditPhotoState_Enabled(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as EditPhotoParams,
  ));
}


}

/// @nodoc


class EditPhotoState_Disabled extends EditPhotoState {
  const EditPhotoState_Disabled(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditPhotoState_Disabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditPhotoState.disabled()';
}


}




/// @nodoc
mixin _$FilterParams {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterParams);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FilterParams()';
}


}

/// @nodoc
class $FilterParamsCopyWith<$Res>  {
$FilterParamsCopyWith(FilterParams _, $Res Function(FilterParams) __);
}


/// Adds pattern-matching-related methods to [FilterParams].
extension FilterParamsPatterns on FilterParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FilterParams_Some value)?  some,TResult Function( FilterParams_None value)?  none,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FilterParams_Some() when some != null:
return some(_that);case FilterParams_None() when none != null:
return none(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FilterParams_Some value)  some,required TResult Function( FilterParams_None value)  none,}){
final _that = this;
switch (_that) {
case FilterParams_Some():
return some(_that);case FilterParams_None():
return none(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FilterParams_Some value)?  some,TResult? Function( FilterParams_None value)?  none,}){
final _that = this;
switch (_that) {
case FilterParams_Some() when some != null:
return some(_that);case FilterParams_None() when none != null:
return none(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  double strength)?  some,TResult Function()?  none,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FilterParams_Some() when some != null:
return some(_that.id,_that.strength);case FilterParams_None() when none != null:
return none();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  double strength)  some,required TResult Function()  none,}) {final _that = this;
switch (_that) {
case FilterParams_Some():
return some(_that.id,_that.strength);case FilterParams_None():
return none();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  double strength)?  some,TResult? Function()?  none,}) {final _that = this;
switch (_that) {
case FilterParams_Some() when some != null:
return some(_that.id,_that.strength);case FilterParams_None() when none != null:
return none();case _:
  return null;

}
}

}

/// @nodoc


class FilterParams_Some extends FilterParams {
  const FilterParams_Some({required this.id, required this.strength}): super._();
  

 final  String id;
 final  double strength;

/// Create a copy of FilterParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterParams_SomeCopyWith<FilterParams_Some> get copyWith => _$FilterParams_SomeCopyWithImpl<FilterParams_Some>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterParams_Some&&(identical(other.id, id) || other.id == id)&&(identical(other.strength, strength) || other.strength == strength));
}


@override
int get hashCode => Object.hash(runtimeType,id,strength);

@override
String toString() {
  return 'FilterParams.some(id: $id, strength: $strength)';
}


}

/// @nodoc
abstract mixin class $FilterParams_SomeCopyWith<$Res> implements $FilterParamsCopyWith<$Res> {
  factory $FilterParams_SomeCopyWith(FilterParams_Some value, $Res Function(FilterParams_Some) _then) = _$FilterParams_SomeCopyWithImpl;
@useResult
$Res call({
 String id, double strength
});




}
/// @nodoc
class _$FilterParams_SomeCopyWithImpl<$Res>
    implements $FilterParams_SomeCopyWith<$Res> {
  _$FilterParams_SomeCopyWithImpl(this._self, this._then);

  final FilterParams_Some _self;
  final $Res Function(FilterParams_Some) _then;

/// Create a copy of FilterParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? strength = null,}) {
  return _then(FilterParams_Some(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class FilterParams_None extends FilterParams {
  const FilterParams_None(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterParams_None);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FilterParams.none()';
}


}




/// @nodoc
mixin _$LightParams {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LightParams);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LightParams()';
}


}

/// @nodoc
class $LightParamsCopyWith<$Res>  {
$LightParamsCopyWith(LightParams _, $Res Function(LightParams) __);
}


/// Adds pattern-matching-related methods to [LightParams].
extension LightParamsPatterns on LightParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LightParams_Some value)?  some,TResult Function( LightParams_None value)?  none,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LightParams_Some() when some != null:
return some(_that);case LightParams_None() when none != null:
return none(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LightParams_Some value)  some,required TResult Function( LightParams_None value)  none,}){
final _that = this;
switch (_that) {
case LightParams_Some():
return some(_that);case LightParams_None():
return none(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LightParams_Some value)?  some,TResult? Function( LightParams_None value)?  none,}){
final _that = this;
switch (_that) {
case LightParams_Some() when some != null:
return some(_that);case LightParams_None() when none != null:
return none(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  double strength)?  some,TResult Function()?  none,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LightParams_Some() when some != null:
return some(_that.id,_that.strength);case LightParams_None() when none != null:
return none();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  double strength)  some,required TResult Function()  none,}) {final _that = this;
switch (_that) {
case LightParams_Some():
return some(_that.id,_that.strength);case LightParams_None():
return none();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  double strength)?  some,TResult? Function()?  none,}) {final _that = this;
switch (_that) {
case LightParams_Some() when some != null:
return some(_that.id,_that.strength);case LightParams_None() when none != null:
return none();case _:
  return null;

}
}

}

/// @nodoc


class LightParams_Some extends LightParams {
  const LightParams_Some({required this.id, required this.strength}): super._();
  

 final  String id;
 final  double strength;

/// Create a copy of LightParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LightParams_SomeCopyWith<LightParams_Some> get copyWith => _$LightParams_SomeCopyWithImpl<LightParams_Some>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LightParams_Some&&(identical(other.id, id) || other.id == id)&&(identical(other.strength, strength) || other.strength == strength));
}


@override
int get hashCode => Object.hash(runtimeType,id,strength);

@override
String toString() {
  return 'LightParams.some(id: $id, strength: $strength)';
}


}

/// @nodoc
abstract mixin class $LightParams_SomeCopyWith<$Res> implements $LightParamsCopyWith<$Res> {
  factory $LightParams_SomeCopyWith(LightParams_Some value, $Res Function(LightParams_Some) _then) = _$LightParams_SomeCopyWithImpl;
@useResult
$Res call({
 String id, double strength
});




}
/// @nodoc
class _$LightParams_SomeCopyWithImpl<$Res>
    implements $LightParams_SomeCopyWith<$Res> {
  _$LightParams_SomeCopyWithImpl(this._self, this._then);

  final LightParams_Some _self;
  final $Res Function(LightParams_Some) _then;

/// Create a copy of LightParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? strength = null,}) {
  return _then(LightParams_Some(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class LightParams_None extends LightParams {
  const LightParams_None(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LightParams_None);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LightParams.none()';
}


}




/// @nodoc
mixin _$MomoHiddenState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MomoHiddenState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MomoHiddenState()';
}


}

/// @nodoc
class $MomoHiddenStateCopyWith<$Res>  {
$MomoHiddenStateCopyWith(MomoHiddenState _, $Res Function(MomoHiddenState) __);
}


/// Adds pattern-matching-related methods to [MomoHiddenState].
extension MomoHiddenStatePatterns on MomoHiddenState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MomoHiddenState_Enabled value)?  enabled,TResult Function( MomoHiddenState_Disabled value)?  disabled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MomoHiddenState_Enabled() when enabled != null:
return enabled(_that);case MomoHiddenState_Disabled() when disabled != null:
return disabled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MomoHiddenState_Enabled value)  enabled,required TResult Function( MomoHiddenState_Disabled value)  disabled,}){
final _that = this;
switch (_that) {
case MomoHiddenState_Enabled():
return enabled(_that);case MomoHiddenState_Disabled():
return disabled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MomoHiddenState_Enabled value)?  enabled,TResult? Function( MomoHiddenState_Disabled value)?  disabled,}){
final _that = this;
switch (_that) {
case MomoHiddenState_Enabled() when enabled != null:
return enabled(_that);case MomoHiddenState_Disabled() when disabled != null:
return disabled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  enabled,TResult Function( MomoParams field0)?  disabled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MomoHiddenState_Enabled() when enabled != null:
return enabled();case MomoHiddenState_Disabled() when disabled != null:
return disabled(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  enabled,required TResult Function( MomoParams field0)  disabled,}) {final _that = this;
switch (_that) {
case MomoHiddenState_Enabled():
return enabled();case MomoHiddenState_Disabled():
return disabled(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  enabled,TResult? Function( MomoParams field0)?  disabled,}) {final _that = this;
switch (_that) {
case MomoHiddenState_Enabled() when enabled != null:
return enabled();case MomoHiddenState_Disabled() when disabled != null:
return disabled(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class MomoHiddenState_Enabled extends MomoHiddenState {
  const MomoHiddenState_Enabled(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MomoHiddenState_Enabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MomoHiddenState.enabled()';
}


}




/// @nodoc


class MomoHiddenState_Disabled extends MomoHiddenState {
  const MomoHiddenState_Disabled(this.field0): super._();
  

 final  MomoParams field0;

/// Create a copy of MomoHiddenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MomoHiddenState_DisabledCopyWith<MomoHiddenState_Disabled> get copyWith => _$MomoHiddenState_DisabledCopyWithImpl<MomoHiddenState_Disabled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MomoHiddenState_Disabled&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'MomoHiddenState.disabled(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $MomoHiddenState_DisabledCopyWith<$Res> implements $MomoHiddenStateCopyWith<$Res> {
  factory $MomoHiddenState_DisabledCopyWith(MomoHiddenState_Disabled value, $Res Function(MomoHiddenState_Disabled) _then) = _$MomoHiddenState_DisabledCopyWithImpl;
@useResult
$Res call({
 MomoParams field0
});




}
/// @nodoc
class _$MomoHiddenState_DisabledCopyWithImpl<$Res>
    implements $MomoHiddenState_DisabledCopyWith<$Res> {
  _$MomoHiddenState_DisabledCopyWithImpl(this._self, this._then);

  final MomoHiddenState_Disabled _self;
  final $Res Function(MomoHiddenState_Disabled) _then;

/// Create a copy of MomoHiddenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(MomoHiddenState_Disabled(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as MomoParams,
  ));
}


}

/// @nodoc
mixin _$OutfitDyeData {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutfitDyeData&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'OutfitDyeData(field0: $field0)';
}


}

/// @nodoc
class $OutfitDyeDataCopyWith<$Res>  {
$OutfitDyeDataCopyWith(OutfitDyeData _, $Res Function(OutfitDyeData) __);
}


/// Adds pattern-matching-related methods to [OutfitDyeData].
extension OutfitDyeDataPatterns on OutfitDyeData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OutfitDyeData_Hair value)?  hair,TResult Function( OutfitDyeData_General value)?  general,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OutfitDyeData_Hair() when hair != null:
return hair(_that);case OutfitDyeData_General() when general != null:
return general(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OutfitDyeData_Hair value)  hair,required TResult Function( OutfitDyeData_General value)  general,}){
final _that = this;
switch (_that) {
case OutfitDyeData_Hair():
return hair(_that);case OutfitDyeData_General():
return general(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OutfitDyeData_Hair value)?  hair,TResult? Function( OutfitDyeData_General value)?  general,}){
final _that = this;
switch (_that) {
case OutfitDyeData_Hair() when hair != null:
return hair(_that);case OutfitDyeData_General() when general != null:
return general(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( OutfitDyeHairData field0)?  hair,TResult Function( OutfitDyeGeneralData field0)?  general,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OutfitDyeData_Hair() when hair != null:
return hair(_that.field0);case OutfitDyeData_General() when general != null:
return general(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( OutfitDyeHairData field0)  hair,required TResult Function( OutfitDyeGeneralData field0)  general,}) {final _that = this;
switch (_that) {
case OutfitDyeData_Hair():
return hair(_that.field0);case OutfitDyeData_General():
return general(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( OutfitDyeHairData field0)?  hair,TResult? Function( OutfitDyeGeneralData field0)?  general,}) {final _that = this;
switch (_that) {
case OutfitDyeData_Hair() when hair != null:
return hair(_that.field0);case OutfitDyeData_General() when general != null:
return general(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class OutfitDyeData_Hair extends OutfitDyeData {
  const OutfitDyeData_Hair(this.field0): super._();
  

@override final  OutfitDyeHairData field0;

/// Create a copy of OutfitDyeData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutfitDyeData_HairCopyWith<OutfitDyeData_Hair> get copyWith => _$OutfitDyeData_HairCopyWithImpl<OutfitDyeData_Hair>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutfitDyeData_Hair&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'OutfitDyeData.hair(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $OutfitDyeData_HairCopyWith<$Res> implements $OutfitDyeDataCopyWith<$Res> {
  factory $OutfitDyeData_HairCopyWith(OutfitDyeData_Hair value, $Res Function(OutfitDyeData_Hair) _then) = _$OutfitDyeData_HairCopyWithImpl;
@useResult
$Res call({
 OutfitDyeHairData field0
});




}
/// @nodoc
class _$OutfitDyeData_HairCopyWithImpl<$Res>
    implements $OutfitDyeData_HairCopyWith<$Res> {
  _$OutfitDyeData_HairCopyWithImpl(this._self, this._then);

  final OutfitDyeData_Hair _self;
  final $Res Function(OutfitDyeData_Hair) _then;

/// Create a copy of OutfitDyeData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(OutfitDyeData_Hair(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as OutfitDyeHairData,
  ));
}


}

/// @nodoc


class OutfitDyeData_General extends OutfitDyeData {
  const OutfitDyeData_General(this.field0): super._();
  

@override final  OutfitDyeGeneralData field0;

/// Create a copy of OutfitDyeData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutfitDyeData_GeneralCopyWith<OutfitDyeData_General> get copyWith => _$OutfitDyeData_GeneralCopyWithImpl<OutfitDyeData_General>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutfitDyeData_General&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'OutfitDyeData.general(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $OutfitDyeData_GeneralCopyWith<$Res> implements $OutfitDyeDataCopyWith<$Res> {
  factory $OutfitDyeData_GeneralCopyWith(OutfitDyeData_General value, $Res Function(OutfitDyeData_General) _then) = _$OutfitDyeData_GeneralCopyWithImpl;
@useResult
$Res call({
 OutfitDyeGeneralData field0
});




}
/// @nodoc
class _$OutfitDyeData_GeneralCopyWithImpl<$Res>
    implements $OutfitDyeData_GeneralCopyWith<$Res> {
  _$OutfitDyeData_GeneralCopyWithImpl(this._self, this._then);

  final OutfitDyeData_General _self;
  final $Res Function(OutfitDyeData_General) _then;

/// Create a copy of OutfitDyeData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(OutfitDyeData_General(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as OutfitDyeGeneralData,
  ));
}


}

/// @nodoc
mixin _$TaskParams {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskParams&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'TaskParams(field0: $field0)';
}


}

/// @nodoc
class $TaskParamsCopyWith<$Res>  {
$TaskParamsCopyWith(TaskParams _, $Res Function(TaskParams) __);
}


/// Adds pattern-matching-related methods to [TaskParams].
extension TaskParamsPatterns on TaskParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskParams_Puzzle value)?  puzzle,TResult Function( TaskParams_Risk value)?  risk,TResult Function( TaskParams_Interactive value)?  interactive,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskParams_Puzzle() when puzzle != null:
return puzzle(_that);case TaskParams_Risk() when risk != null:
return risk(_that);case TaskParams_Interactive() when interactive != null:
return interactive(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskParams_Puzzle value)  puzzle,required TResult Function( TaskParams_Risk value)  risk,required TResult Function( TaskParams_Interactive value)  interactive,}){
final _that = this;
switch (_that) {
case TaskParams_Puzzle():
return puzzle(_that);case TaskParams_Risk():
return risk(_that);case TaskParams_Interactive():
return interactive(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskParams_Puzzle value)?  puzzle,TResult? Function( TaskParams_Risk value)?  risk,TResult? Function( TaskParams_Interactive value)?  interactive,}){
final _that = this;
switch (_that) {
case TaskParams_Puzzle() when puzzle != null:
return puzzle(_that);case TaskParams_Risk() when risk != null:
return risk(_that);case TaskParams_Interactive() when interactive != null:
return interactive(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PlatformInt64 field0)?  puzzle,TResult Function( Map<PlatformInt64, bool> field0)?  risk,TResult Function( Map<PlatformInt64, bool> field0)?  interactive,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskParams_Puzzle() when puzzle != null:
return puzzle(_that.field0);case TaskParams_Risk() when risk != null:
return risk(_that.field0);case TaskParams_Interactive() when interactive != null:
return interactive(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PlatformInt64 field0)  puzzle,required TResult Function( Map<PlatformInt64, bool> field0)  risk,required TResult Function( Map<PlatformInt64, bool> field0)  interactive,}) {final _that = this;
switch (_that) {
case TaskParams_Puzzle():
return puzzle(_that.field0);case TaskParams_Risk():
return risk(_that.field0);case TaskParams_Interactive():
return interactive(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PlatformInt64 field0)?  puzzle,TResult? Function( Map<PlatformInt64, bool> field0)?  risk,TResult? Function( Map<PlatformInt64, bool> field0)?  interactive,}) {final _that = this;
switch (_that) {
case TaskParams_Puzzle() when puzzle != null:
return puzzle(_that.field0);case TaskParams_Risk() when risk != null:
return risk(_that.field0);case TaskParams_Interactive() when interactive != null:
return interactive(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class TaskParams_Puzzle extends TaskParams {
  const TaskParams_Puzzle(this.field0): super._();
  

@override final  PlatformInt64 field0;

/// Create a copy of TaskParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskParams_PuzzleCopyWith<TaskParams_Puzzle> get copyWith => _$TaskParams_PuzzleCopyWithImpl<TaskParams_Puzzle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskParams_Puzzle&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'TaskParams.puzzle(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $TaskParams_PuzzleCopyWith<$Res> implements $TaskParamsCopyWith<$Res> {
  factory $TaskParams_PuzzleCopyWith(TaskParams_Puzzle value, $Res Function(TaskParams_Puzzle) _then) = _$TaskParams_PuzzleCopyWithImpl;
@useResult
$Res call({
 PlatformInt64 field0
});




}
/// @nodoc
class _$TaskParams_PuzzleCopyWithImpl<$Res>
    implements $TaskParams_PuzzleCopyWith<$Res> {
  _$TaskParams_PuzzleCopyWithImpl(this._self, this._then);

  final TaskParams_Puzzle _self;
  final $Res Function(TaskParams_Puzzle) _then;

/// Create a copy of TaskParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(TaskParams_Puzzle(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as PlatformInt64,
  ));
}


}

/// @nodoc


class TaskParams_Risk extends TaskParams {
  const TaskParams_Risk(final  Map<PlatformInt64, bool> field0): _field0 = field0,super._();
  

 final  Map<PlatformInt64, bool> _field0;
@override Map<PlatformInt64, bool> get field0 {
  if (_field0 is EqualUnmodifiableMapView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_field0);
}


/// Create a copy of TaskParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskParams_RiskCopyWith<TaskParams_Risk> get copyWith => _$TaskParams_RiskCopyWithImpl<TaskParams_Risk>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskParams_Risk&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'TaskParams.risk(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $TaskParams_RiskCopyWith<$Res> implements $TaskParamsCopyWith<$Res> {
  factory $TaskParams_RiskCopyWith(TaskParams_Risk value, $Res Function(TaskParams_Risk) _then) = _$TaskParams_RiskCopyWithImpl;
@useResult
$Res call({
 Map<PlatformInt64, bool> field0
});




}
/// @nodoc
class _$TaskParams_RiskCopyWithImpl<$Res>
    implements $TaskParams_RiskCopyWith<$Res> {
  _$TaskParams_RiskCopyWithImpl(this._self, this._then);

  final TaskParams_Risk _self;
  final $Res Function(TaskParams_Risk) _then;

/// Create a copy of TaskParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(TaskParams_Risk(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as Map<PlatformInt64, bool>,
  ));
}


}

/// @nodoc


class TaskParams_Interactive extends TaskParams {
  const TaskParams_Interactive(final  Map<PlatformInt64, bool> field0): _field0 = field0,super._();
  

 final  Map<PlatformInt64, bool> _field0;
@override Map<PlatformInt64, bool> get field0 {
  if (_field0 is EqualUnmodifiableMapView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_field0);
}


/// Create a copy of TaskParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskParams_InteractiveCopyWith<TaskParams_Interactive> get copyWith => _$TaskParams_InteractiveCopyWithImpl<TaskParams_Interactive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskParams_Interactive&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'TaskParams.interactive(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $TaskParams_InteractiveCopyWith<$Res> implements $TaskParamsCopyWith<$Res> {
  factory $TaskParams_InteractiveCopyWith(TaskParams_Interactive value, $Res Function(TaskParams_Interactive) _then) = _$TaskParams_InteractiveCopyWithImpl;
@useResult
$Res call({
 Map<PlatformInt64, bool> field0
});




}
/// @nodoc
class _$TaskParams_InteractiveCopyWithImpl<$Res>
    implements $TaskParams_InteractiveCopyWith<$Res> {
  _$TaskParams_InteractiveCopyWithImpl(this._self, this._then);

  final TaskParams_Interactive _self;
  final $Res Function(TaskParams_Interactive) _then;

/// Create a copy of TaskParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(TaskParams_Interactive(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as Map<PlatformInt64, bool>,
  ));
}


}

// dart format on
