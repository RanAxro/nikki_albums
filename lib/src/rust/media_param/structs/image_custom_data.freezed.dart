// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_custom_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DaMiaoInfoOption {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaMiaoInfoOption);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DaMiaoInfoOption()';
}


}

/// @nodoc
class $DaMiaoInfoOptionCopyWith<$Res>  {
$DaMiaoInfoOptionCopyWith(DaMiaoInfoOption _, $Res Function(DaMiaoInfoOption) __);
}


/// Adds pattern-matching-related methods to [DaMiaoInfoOption].
extension DaMiaoInfoOptionPatterns on DaMiaoInfoOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DaMiaoInfoOption_None value)?  none,TResult Function( DaMiaoInfoOption_Some value)?  some,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DaMiaoInfoOption_None() when none != null:
return none(_that);case DaMiaoInfoOption_Some() when some != null:
return some(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DaMiaoInfoOption_None value)  none,required TResult Function( DaMiaoInfoOption_Some value)  some,}){
final _that = this;
switch (_that) {
case DaMiaoInfoOption_None():
return none(_that);case DaMiaoInfoOption_Some():
return some(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DaMiaoInfoOption_None value)?  none,TResult? Function( DaMiaoInfoOption_Some value)?  some,}){
final _that = this;
switch (_that) {
case DaMiaoInfoOption_None() when none != null:
return none(_that);case DaMiaoInfoOption_Some() when some != null:
return some(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function( DaMiaoInfo field0)?  some,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DaMiaoInfoOption_None() when none != null:
return none();case DaMiaoInfoOption_Some() when some != null:
return some(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function( DaMiaoInfo field0)  some,}) {final _that = this;
switch (_that) {
case DaMiaoInfoOption_None():
return none();case DaMiaoInfoOption_Some():
return some(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function( DaMiaoInfo field0)?  some,}) {final _that = this;
switch (_that) {
case DaMiaoInfoOption_None() when none != null:
return none();case DaMiaoInfoOption_Some() when some != null:
return some(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class DaMiaoInfoOption_None extends DaMiaoInfoOption {
  const DaMiaoInfoOption_None(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaMiaoInfoOption_None);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DaMiaoInfoOption.none()';
}


}




/// @nodoc


class DaMiaoInfoOption_Some extends DaMiaoInfoOption {
  const DaMiaoInfoOption_Some(this.field0): super._();
  

 final  DaMiaoInfo field0;

/// Create a copy of DaMiaoInfoOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DaMiaoInfoOption_SomeCopyWith<DaMiaoInfoOption_Some> get copyWith => _$DaMiaoInfoOption_SomeCopyWithImpl<DaMiaoInfoOption_Some>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaMiaoInfoOption_Some&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'DaMiaoInfoOption.some(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $DaMiaoInfoOption_SomeCopyWith<$Res> implements $DaMiaoInfoOptionCopyWith<$Res> {
  factory $DaMiaoInfoOption_SomeCopyWith(DaMiaoInfoOption_Some value, $Res Function(DaMiaoInfoOption_Some) _then) = _$DaMiaoInfoOption_SomeCopyWithImpl;
@useResult
$Res call({
 DaMiaoInfo field0
});




}
/// @nodoc
class _$DaMiaoInfoOption_SomeCopyWithImpl<$Res>
    implements $DaMiaoInfoOption_SomeCopyWith<$Res> {
  _$DaMiaoInfoOption_SomeCopyWithImpl(this._self, this._then);

  final DaMiaoInfoOption_Some _self;
  final $Res Function(DaMiaoInfoOption_Some) _then;

/// Create a copy of DaMiaoInfoOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(DaMiaoInfoOption_Some(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as DaMiaoInfo,
  ));
}


}

/// @nodoc
mixin _$MountInfoOption {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MountInfoOption);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MountInfoOption()';
}


}

/// @nodoc
class $MountInfoOptionCopyWith<$Res>  {
$MountInfoOptionCopyWith(MountInfoOption _, $Res Function(MountInfoOption) __);
}


/// Adds pattern-matching-related methods to [MountInfoOption].
extension MountInfoOptionPatterns on MountInfoOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MountInfoOption_None value)?  none,TResult Function( MountInfoOption_Some value)?  some,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MountInfoOption_None() when none != null:
return none(_that);case MountInfoOption_Some() when some != null:
return some(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MountInfoOption_None value)  none,required TResult Function( MountInfoOption_Some value)  some,}){
final _that = this;
switch (_that) {
case MountInfoOption_None():
return none(_that);case MountInfoOption_Some():
return some(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MountInfoOption_None value)?  none,TResult? Function( MountInfoOption_Some value)?  some,}){
final _that = this;
switch (_that) {
case MountInfoOption_None() when none != null:
return none(_that);case MountInfoOption_Some() when some != null:
return some(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function( MountInfo field0)?  some,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MountInfoOption_None() when none != null:
return none();case MountInfoOption_Some() when some != null:
return some(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function( MountInfo field0)  some,}) {final _that = this;
switch (_that) {
case MountInfoOption_None():
return none();case MountInfoOption_Some():
return some(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function( MountInfo field0)?  some,}) {final _that = this;
switch (_that) {
case MountInfoOption_None() when none != null:
return none();case MountInfoOption_Some() when some != null:
return some(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class MountInfoOption_None extends MountInfoOption {
  const MountInfoOption_None(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MountInfoOption_None);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MountInfoOption.none()';
}


}




/// @nodoc


class MountInfoOption_Some extends MountInfoOption {
  const MountInfoOption_Some(this.field0): super._();
  

 final  MountInfo field0;

/// Create a copy of MountInfoOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MountInfoOption_SomeCopyWith<MountInfoOption_Some> get copyWith => _$MountInfoOption_SomeCopyWithImpl<MountInfoOption_Some>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MountInfoOption_Some&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'MountInfoOption.some(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $MountInfoOption_SomeCopyWith<$Res> implements $MountInfoOptionCopyWith<$Res> {
  factory $MountInfoOption_SomeCopyWith(MountInfoOption_Some value, $Res Function(MountInfoOption_Some) _then) = _$MountInfoOption_SomeCopyWithImpl;
@useResult
$Res call({
 MountInfo field0
});




}
/// @nodoc
class _$MountInfoOption_SomeCopyWithImpl<$Res>
    implements $MountInfoOption_SomeCopyWith<$Res> {
  _$MountInfoOption_SomeCopyWithImpl(this._self, this._then);

  final MountInfoOption_Some _self;
  final $Res Function(MountInfoOption_Some) _then;

/// Create a copy of MountInfoOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(MountInfoOption_Some(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as MountInfo,
  ));
}


}

/// @nodoc
mixin _$StaticInfosOption {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaticInfosOption);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StaticInfosOption()';
}


}

/// @nodoc
class $StaticInfosOptionCopyWith<$Res>  {
$StaticInfosOptionCopyWith(StaticInfosOption _, $Res Function(StaticInfosOption) __);
}


/// Adds pattern-matching-related methods to [StaticInfosOption].
extension StaticInfosOptionPatterns on StaticInfosOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StaticInfosOption_None value)?  none,TResult Function( StaticInfosOption_Some value)?  some,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StaticInfosOption_None() when none != null:
return none(_that);case StaticInfosOption_Some() when some != null:
return some(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StaticInfosOption_None value)  none,required TResult Function( StaticInfosOption_Some value)  some,}){
final _that = this;
switch (_that) {
case StaticInfosOption_None():
return none(_that);case StaticInfosOption_Some():
return some(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StaticInfosOption_None value)?  none,TResult? Function( StaticInfosOption_Some value)?  some,}){
final _that = this;
switch (_that) {
case StaticInfosOption_None() when none != null:
return none(_that);case StaticInfosOption_Some() when some != null:
return some(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function( StaticInfos field0)?  some,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StaticInfosOption_None() when none != null:
return none();case StaticInfosOption_Some() when some != null:
return some(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function( StaticInfos field0)  some,}) {final _that = this;
switch (_that) {
case StaticInfosOption_None():
return none();case StaticInfosOption_Some():
return some(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function( StaticInfos field0)?  some,}) {final _that = this;
switch (_that) {
case StaticInfosOption_None() when none != null:
return none();case StaticInfosOption_Some() when some != null:
return some(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class StaticInfosOption_None extends StaticInfosOption {
  const StaticInfosOption_None(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaticInfosOption_None);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StaticInfosOption.none()';
}


}




/// @nodoc


class StaticInfosOption_Some extends StaticInfosOption {
  const StaticInfosOption_Some(this.field0): super._();
  

 final  StaticInfos field0;

/// Create a copy of StaticInfosOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaticInfosOption_SomeCopyWith<StaticInfosOption_Some> get copyWith => _$StaticInfosOption_SomeCopyWithImpl<StaticInfosOption_Some>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaticInfosOption_Some&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StaticInfosOption.some(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StaticInfosOption_SomeCopyWith<$Res> implements $StaticInfosOptionCopyWith<$Res> {
  factory $StaticInfosOption_SomeCopyWith(StaticInfosOption_Some value, $Res Function(StaticInfosOption_Some) _then) = _$StaticInfosOption_SomeCopyWithImpl;
@useResult
$Res call({
 StaticInfos field0
});




}
/// @nodoc
class _$StaticInfosOption_SomeCopyWithImpl<$Res>
    implements $StaticInfosOption_SomeCopyWith<$Res> {
  _$StaticInfosOption_SomeCopyWithImpl(this._self, this._then);

  final StaticInfosOption_Some _self;
  final $Res Function(StaticInfosOption_Some) _then;

/// Create a copy of StaticInfosOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StaticInfosOption_Some(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StaticInfos,
  ));
}


}

// dart format on
