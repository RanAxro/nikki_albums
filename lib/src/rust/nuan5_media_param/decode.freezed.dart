// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'decode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaCustomData {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaCustomData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MediaCustomData()';
}


}

/// @nodoc
class $MediaCustomDataCopyWith<$Res>  {
$MediaCustomDataCopyWith(MediaCustomData _, $Res Function(MediaCustomData) __);
}


/// Adds pattern-matching-related methods to [MediaCustomData].
extension MediaCustomDataPatterns on MediaCustomData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MediaCustomData_Invalid value)?  invalid,TResult Function( MediaCustomData_Valid value)?  valid,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MediaCustomData_Invalid() when invalid != null:
return invalid(_that);case MediaCustomData_Valid() when valid != null:
return valid(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MediaCustomData_Invalid value)  invalid,required TResult Function( MediaCustomData_Valid value)  valid,}){
final _that = this;
switch (_that) {
case MediaCustomData_Invalid():
return invalid(_that);case MediaCustomData_Valid():
return valid(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MediaCustomData_Invalid value)?  invalid,TResult? Function( MediaCustomData_Valid value)?  valid,}){
final _that = this;
switch (_that) {
case MediaCustomData_Invalid() when invalid != null:
return invalid(_that);case MediaCustomData_Valid() when valid != null:
return valid(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalid,TResult Function( MediaParam field0)?  valid,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MediaCustomData_Invalid() when invalid != null:
return invalid();case MediaCustomData_Valid() when valid != null:
return valid(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalid,required TResult Function( MediaParam field0)  valid,}) {final _that = this;
switch (_that) {
case MediaCustomData_Invalid():
return invalid();case MediaCustomData_Valid():
return valid(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalid,TResult? Function( MediaParam field0)?  valid,}) {final _that = this;
switch (_that) {
case MediaCustomData_Invalid() when invalid != null:
return invalid();case MediaCustomData_Valid() when valid != null:
return valid(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class MediaCustomData_Invalid extends MediaCustomData {
  const MediaCustomData_Invalid(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaCustomData_Invalid);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MediaCustomData.invalid()';
}


}




/// @nodoc


class MediaCustomData_Valid extends MediaCustomData {
  const MediaCustomData_Valid(this.field0): super._();
  

 final  MediaParam field0;

/// Create a copy of MediaCustomData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaCustomData_ValidCopyWith<MediaCustomData_Valid> get copyWith => _$MediaCustomData_ValidCopyWithImpl<MediaCustomData_Valid>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaCustomData_Valid&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'MediaCustomData.valid(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $MediaCustomData_ValidCopyWith<$Res> implements $MediaCustomDataCopyWith<$Res> {
  factory $MediaCustomData_ValidCopyWith(MediaCustomData_Valid value, $Res Function(MediaCustomData_Valid) _then) = _$MediaCustomData_ValidCopyWithImpl;
@useResult
$Res call({
 MediaParam field0
});


$MediaParamCopyWith<$Res> get field0;

}
/// @nodoc
class _$MediaCustomData_ValidCopyWithImpl<$Res>
    implements $MediaCustomData_ValidCopyWith<$Res> {
  _$MediaCustomData_ValidCopyWithImpl(this._self, this._then);

  final MediaCustomData_Valid _self;
  final $Res Function(MediaCustomData_Valid) _then;

/// Create a copy of MediaCustomData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(MediaCustomData_Valid(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as MediaParam,
  ));
}

/// Create a copy of MediaCustomData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaParamCopyWith<$Res> get field0 {
  
  return $MediaParamCopyWith<$Res>(_self.field0, (value) {
    return _then(_self.copyWith(field0: value));
  });
}
}

/// @nodoc
mixin _$MediaParam {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaParam&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'MediaParam(field0: $field0)';
}


}

/// @nodoc
class $MediaParamCopyWith<$Res>  {
$MediaParamCopyWith(MediaParam _, $Res Function(MediaParam) __);
}


/// Adds pattern-matching-related methods to [MediaParam].
extension MediaParamPatterns on MediaParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MediaParam_MomoCameraParams value)?  momoCameraParams,TResult Function( MediaParam_NikkiPhoto value)?  nikkiPhoto,TResult Function( MediaParam_ClockInPhoto value)?  clockInPhoto,TResult Function( MediaParam_Collage value)?  collage,TResult Function( MediaParam_DIY value)?  diy,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MediaParam_MomoCameraParams() when momoCameraParams != null:
return momoCameraParams(_that);case MediaParam_NikkiPhoto() when nikkiPhoto != null:
return nikkiPhoto(_that);case MediaParam_ClockInPhoto() when clockInPhoto != null:
return clockInPhoto(_that);case MediaParam_Collage() when collage != null:
return collage(_that);case MediaParam_DIY() when diy != null:
return diy(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MediaParam_MomoCameraParams value)  momoCameraParams,required TResult Function( MediaParam_NikkiPhoto value)  nikkiPhoto,required TResult Function( MediaParam_ClockInPhoto value)  clockInPhoto,required TResult Function( MediaParam_Collage value)  collage,required TResult Function( MediaParam_DIY value)  diy,}){
final _that = this;
switch (_that) {
case MediaParam_MomoCameraParams():
return momoCameraParams(_that);case MediaParam_NikkiPhoto():
return nikkiPhoto(_that);case MediaParam_ClockInPhoto():
return clockInPhoto(_that);case MediaParam_Collage():
return collage(_that);case MediaParam_DIY():
return diy(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MediaParam_MomoCameraParams value)?  momoCameraParams,TResult? Function( MediaParam_NikkiPhoto value)?  nikkiPhoto,TResult? Function( MediaParam_ClockInPhoto value)?  clockInPhoto,TResult? Function( MediaParam_Collage value)?  collage,TResult? Function( MediaParam_DIY value)?  diy,}){
final _that = this;
switch (_that) {
case MediaParam_MomoCameraParams() when momoCameraParams != null:
return momoCameraParams(_that);case MediaParam_NikkiPhoto() when nikkiPhoto != null:
return nikkiPhoto(_that);case MediaParam_ClockInPhoto() when clockInPhoto != null:
return clockInPhoto(_that);case MediaParam_Collage() when collage != null:
return collage(_that);case MediaParam_DIY() when diy != null:
return diy(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( MomoCameraParams field0)?  momoCameraParams,TResult Function( NikkiPhotoParams field0)?  nikkiPhoto,TResult Function( ClockInPhotoParams field0)?  clockInPhoto,TResult Function( CollageParams field0)?  collage,TResult Function( DiyParams field0)?  diy,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MediaParam_MomoCameraParams() when momoCameraParams != null:
return momoCameraParams(_that.field0);case MediaParam_NikkiPhoto() when nikkiPhoto != null:
return nikkiPhoto(_that.field0);case MediaParam_ClockInPhoto() when clockInPhoto != null:
return clockInPhoto(_that.field0);case MediaParam_Collage() when collage != null:
return collage(_that.field0);case MediaParam_DIY() when diy != null:
return diy(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( MomoCameraParams field0)  momoCameraParams,required TResult Function( NikkiPhotoParams field0)  nikkiPhoto,required TResult Function( ClockInPhotoParams field0)  clockInPhoto,required TResult Function( CollageParams field0)  collage,required TResult Function( DiyParams field0)  diy,}) {final _that = this;
switch (_that) {
case MediaParam_MomoCameraParams():
return momoCameraParams(_that.field0);case MediaParam_NikkiPhoto():
return nikkiPhoto(_that.field0);case MediaParam_ClockInPhoto():
return clockInPhoto(_that.field0);case MediaParam_Collage():
return collage(_that.field0);case MediaParam_DIY():
return diy(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( MomoCameraParams field0)?  momoCameraParams,TResult? Function( NikkiPhotoParams field0)?  nikkiPhoto,TResult? Function( ClockInPhotoParams field0)?  clockInPhoto,TResult? Function( CollageParams field0)?  collage,TResult? Function( DiyParams field0)?  diy,}) {final _that = this;
switch (_that) {
case MediaParam_MomoCameraParams() when momoCameraParams != null:
return momoCameraParams(_that.field0);case MediaParam_NikkiPhoto() when nikkiPhoto != null:
return nikkiPhoto(_that.field0);case MediaParam_ClockInPhoto() when clockInPhoto != null:
return clockInPhoto(_that.field0);case MediaParam_Collage() when collage != null:
return collage(_that.field0);case MediaParam_DIY() when diy != null:
return diy(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class MediaParam_MomoCameraParams extends MediaParam {
  const MediaParam_MomoCameraParams(this.field0): super._();
  

@override final  MomoCameraParams field0;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaParam_MomoCameraParamsCopyWith<MediaParam_MomoCameraParams> get copyWith => _$MediaParam_MomoCameraParamsCopyWithImpl<MediaParam_MomoCameraParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaParam_MomoCameraParams&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'MediaParam.momoCameraParams(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $MediaParam_MomoCameraParamsCopyWith<$Res> implements $MediaParamCopyWith<$Res> {
  factory $MediaParam_MomoCameraParamsCopyWith(MediaParam_MomoCameraParams value, $Res Function(MediaParam_MomoCameraParams) _then) = _$MediaParam_MomoCameraParamsCopyWithImpl;
@useResult
$Res call({
 MomoCameraParams field0
});




}
/// @nodoc
class _$MediaParam_MomoCameraParamsCopyWithImpl<$Res>
    implements $MediaParam_MomoCameraParamsCopyWith<$Res> {
  _$MediaParam_MomoCameraParamsCopyWithImpl(this._self, this._then);

  final MediaParam_MomoCameraParams _self;
  final $Res Function(MediaParam_MomoCameraParams) _then;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(MediaParam_MomoCameraParams(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as MomoCameraParams,
  ));
}


}

/// @nodoc


class MediaParam_NikkiPhoto extends MediaParam {
  const MediaParam_NikkiPhoto(this.field0): super._();
  

@override final  NikkiPhotoParams field0;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaParam_NikkiPhotoCopyWith<MediaParam_NikkiPhoto> get copyWith => _$MediaParam_NikkiPhotoCopyWithImpl<MediaParam_NikkiPhoto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaParam_NikkiPhoto&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'MediaParam.nikkiPhoto(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $MediaParam_NikkiPhotoCopyWith<$Res> implements $MediaParamCopyWith<$Res> {
  factory $MediaParam_NikkiPhotoCopyWith(MediaParam_NikkiPhoto value, $Res Function(MediaParam_NikkiPhoto) _then) = _$MediaParam_NikkiPhotoCopyWithImpl;
@useResult
$Res call({
 NikkiPhotoParams field0
});




}
/// @nodoc
class _$MediaParam_NikkiPhotoCopyWithImpl<$Res>
    implements $MediaParam_NikkiPhotoCopyWith<$Res> {
  _$MediaParam_NikkiPhotoCopyWithImpl(this._self, this._then);

  final MediaParam_NikkiPhoto _self;
  final $Res Function(MediaParam_NikkiPhoto) _then;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(MediaParam_NikkiPhoto(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as NikkiPhotoParams,
  ));
}


}

/// @nodoc


class MediaParam_ClockInPhoto extends MediaParam {
  const MediaParam_ClockInPhoto(this.field0): super._();
  

@override final  ClockInPhotoParams field0;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaParam_ClockInPhotoCopyWith<MediaParam_ClockInPhoto> get copyWith => _$MediaParam_ClockInPhotoCopyWithImpl<MediaParam_ClockInPhoto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaParam_ClockInPhoto&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'MediaParam.clockInPhoto(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $MediaParam_ClockInPhotoCopyWith<$Res> implements $MediaParamCopyWith<$Res> {
  factory $MediaParam_ClockInPhotoCopyWith(MediaParam_ClockInPhoto value, $Res Function(MediaParam_ClockInPhoto) _then) = _$MediaParam_ClockInPhotoCopyWithImpl;
@useResult
$Res call({
 ClockInPhotoParams field0
});




}
/// @nodoc
class _$MediaParam_ClockInPhotoCopyWithImpl<$Res>
    implements $MediaParam_ClockInPhotoCopyWith<$Res> {
  _$MediaParam_ClockInPhotoCopyWithImpl(this._self, this._then);

  final MediaParam_ClockInPhoto _self;
  final $Res Function(MediaParam_ClockInPhoto) _then;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(MediaParam_ClockInPhoto(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ClockInPhotoParams,
  ));
}


}

/// @nodoc


class MediaParam_Collage extends MediaParam {
  const MediaParam_Collage(this.field0): super._();
  

@override final  CollageParams field0;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaParam_CollageCopyWith<MediaParam_Collage> get copyWith => _$MediaParam_CollageCopyWithImpl<MediaParam_Collage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaParam_Collage&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'MediaParam.collage(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $MediaParam_CollageCopyWith<$Res> implements $MediaParamCopyWith<$Res> {
  factory $MediaParam_CollageCopyWith(MediaParam_Collage value, $Res Function(MediaParam_Collage) _then) = _$MediaParam_CollageCopyWithImpl;
@useResult
$Res call({
 CollageParams field0
});




}
/// @nodoc
class _$MediaParam_CollageCopyWithImpl<$Res>
    implements $MediaParam_CollageCopyWith<$Res> {
  _$MediaParam_CollageCopyWithImpl(this._self, this._then);

  final MediaParam_Collage _self;
  final $Res Function(MediaParam_Collage) _then;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(MediaParam_Collage(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as CollageParams,
  ));
}


}

/// @nodoc


class MediaParam_DIY extends MediaParam {
  const MediaParam_DIY(this.field0): super._();
  

@override final  DiyParams field0;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaParam_DIYCopyWith<MediaParam_DIY> get copyWith => _$MediaParam_DIYCopyWithImpl<MediaParam_DIY>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaParam_DIY&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'MediaParam.diy(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $MediaParam_DIYCopyWith<$Res> implements $MediaParamCopyWith<$Res> {
  factory $MediaParam_DIYCopyWith(MediaParam_DIY value, $Res Function(MediaParam_DIY) _then) = _$MediaParam_DIYCopyWithImpl;
@useResult
$Res call({
 DiyParams field0
});




}
/// @nodoc
class _$MediaParam_DIYCopyWithImpl<$Res>
    implements $MediaParam_DIYCopyWith<$Res> {
  _$MediaParam_DIYCopyWithImpl(this._self, this._then);

  final MediaParam_DIY _self;
  final $Res Function(MediaParam_DIY) _then;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(MediaParam_DIY(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as DiyParams,
  ));
}


}

// dart format on
