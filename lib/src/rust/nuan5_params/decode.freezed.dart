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
mixin _$ClothDiyParam {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClothDiyParam&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'ClothDiyParam(field0: $field0)';
}


}

/// @nodoc
class $ClothDiyParamCopyWith<$Res>  {
$ClothDiyParamCopyWith(ClothDiyParam _, $Res Function(ClothDiyParam) __);
}


/// Adds pattern-matching-related methods to [ClothDiyParam].
extension ClothDiyParamPatterns on ClothDiyParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ClothDiyParam_ClothDiy value)?  clothDiy,TResult Function( ClothDiyParam_DiyHistoryShareCode value)?  diyHistoryShareCode,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ClothDiyParam_ClothDiy() when clothDiy != null:
return clothDiy(_that);case ClothDiyParam_DiyHistoryShareCode() when diyHistoryShareCode != null:
return diyHistoryShareCode(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ClothDiyParam_ClothDiy value)  clothDiy,required TResult Function( ClothDiyParam_DiyHistoryShareCode value)  diyHistoryShareCode,}){
final _that = this;
switch (_that) {
case ClothDiyParam_ClothDiy():
return clothDiy(_that);case ClothDiyParam_DiyHistoryShareCode():
return diyHistoryShareCode(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ClothDiyParam_ClothDiy value)?  clothDiy,TResult? Function( ClothDiyParam_DiyHistoryShareCode value)?  diyHistoryShareCode,}){
final _that = this;
switch (_that) {
case ClothDiyParam_ClothDiy() when clothDiy != null:
return clothDiy(_that);case ClothDiyParam_DiyHistoryShareCode() when diyHistoryShareCode != null:
return diyHistoryShareCode(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ClothDiyParams field0)?  clothDiy,TResult Function( List<DiyHistoryShareCodeParams> field0)?  diyHistoryShareCode,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ClothDiyParam_ClothDiy() when clothDiy != null:
return clothDiy(_that.field0);case ClothDiyParam_DiyHistoryShareCode() when diyHistoryShareCode != null:
return diyHistoryShareCode(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ClothDiyParams field0)  clothDiy,required TResult Function( List<DiyHistoryShareCodeParams> field0)  diyHistoryShareCode,}) {final _that = this;
switch (_that) {
case ClothDiyParam_ClothDiy():
return clothDiy(_that.field0);case ClothDiyParam_DiyHistoryShareCode():
return diyHistoryShareCode(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ClothDiyParams field0)?  clothDiy,TResult? Function( List<DiyHistoryShareCodeParams> field0)?  diyHistoryShareCode,}) {final _that = this;
switch (_that) {
case ClothDiyParam_ClothDiy() when clothDiy != null:
return clothDiy(_that.field0);case ClothDiyParam_DiyHistoryShareCode() when diyHistoryShareCode != null:
return diyHistoryShareCode(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ClothDiyParam_ClothDiy extends ClothDiyParam {
  const ClothDiyParam_ClothDiy(this.field0): super._();
  

@override final  ClothDiyParams field0;

/// Create a copy of ClothDiyParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClothDiyParam_ClothDiyCopyWith<ClothDiyParam_ClothDiy> get copyWith => _$ClothDiyParam_ClothDiyCopyWithImpl<ClothDiyParam_ClothDiy>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClothDiyParam_ClothDiy&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ClothDiyParam.clothDiy(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ClothDiyParam_ClothDiyCopyWith<$Res> implements $ClothDiyParamCopyWith<$Res> {
  factory $ClothDiyParam_ClothDiyCopyWith(ClothDiyParam_ClothDiy value, $Res Function(ClothDiyParam_ClothDiy) _then) = _$ClothDiyParam_ClothDiyCopyWithImpl;
@useResult
$Res call({
 ClothDiyParams field0
});




}
/// @nodoc
class _$ClothDiyParam_ClothDiyCopyWithImpl<$Res>
    implements $ClothDiyParam_ClothDiyCopyWith<$Res> {
  _$ClothDiyParam_ClothDiyCopyWithImpl(this._self, this._then);

  final ClothDiyParam_ClothDiy _self;
  final $Res Function(ClothDiyParam_ClothDiy) _then;

/// Create a copy of ClothDiyParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ClothDiyParam_ClothDiy(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ClothDiyParams,
  ));
}


}

/// @nodoc


class ClothDiyParam_DiyHistoryShareCode extends ClothDiyParam {
  const ClothDiyParam_DiyHistoryShareCode(final  List<DiyHistoryShareCodeParams> field0): _field0 = field0,super._();
  

 final  List<DiyHistoryShareCodeParams> _field0;
@override List<DiyHistoryShareCodeParams> get field0 {
  if (_field0 is EqualUnmodifiableListView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field0);
}


/// Create a copy of ClothDiyParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClothDiyParam_DiyHistoryShareCodeCopyWith<ClothDiyParam_DiyHistoryShareCode> get copyWith => _$ClothDiyParam_DiyHistoryShareCodeCopyWithImpl<ClothDiyParam_DiyHistoryShareCode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClothDiyParam_DiyHistoryShareCode&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'ClothDiyParam.diyHistoryShareCode(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ClothDiyParam_DiyHistoryShareCodeCopyWith<$Res> implements $ClothDiyParamCopyWith<$Res> {
  factory $ClothDiyParam_DiyHistoryShareCodeCopyWith(ClothDiyParam_DiyHistoryShareCode value, $Res Function(ClothDiyParam_DiyHistoryShareCode) _then) = _$ClothDiyParam_DiyHistoryShareCodeCopyWithImpl;
@useResult
$Res call({
 List<DiyHistoryShareCodeParams> field0
});




}
/// @nodoc
class _$ClothDiyParam_DiyHistoryShareCodeCopyWithImpl<$Res>
    implements $ClothDiyParam_DiyHistoryShareCodeCopyWith<$Res> {
  _$ClothDiyParam_DiyHistoryShareCodeCopyWithImpl(this._self, this._then);

  final ClothDiyParam_DiyHistoryShareCode _self;
  final $Res Function(ClothDiyParam_DiyHistoryShareCode) _then;

/// Create a copy of ClothDiyParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ClothDiyParam_DiyHistoryShareCode(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as List<DiyHistoryShareCodeParams>,
  ));
}


}

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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MediaParam_CameraParams value)?  cameraParams,TResult Function( MediaParam_NikkiPhoto value)?  nikkiPhoto,TResult Function( MediaParam_ClockInPhoto value)?  clockInPhoto,TResult Function( MediaParam_Collage value)?  collage,TResult Function( MediaParam_DIY value)?  diy,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MediaParam_CameraParams() when cameraParams != null:
return cameraParams(_that);case MediaParam_NikkiPhoto() when nikkiPhoto != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MediaParam_CameraParams value)  cameraParams,required TResult Function( MediaParam_NikkiPhoto value)  nikkiPhoto,required TResult Function( MediaParam_ClockInPhoto value)  clockInPhoto,required TResult Function( MediaParam_Collage value)  collage,required TResult Function( MediaParam_DIY value)  diy,}){
final _that = this;
switch (_that) {
case MediaParam_CameraParams():
return cameraParams(_that);case MediaParam_NikkiPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MediaParam_CameraParams value)?  cameraParams,TResult? Function( MediaParam_NikkiPhoto value)?  nikkiPhoto,TResult? Function( MediaParam_ClockInPhoto value)?  clockInPhoto,TResult? Function( MediaParam_Collage value)?  collage,TResult? Function( MediaParam_DIY value)?  diy,}){
final _that = this;
switch (_that) {
case MediaParam_CameraParams() when cameraParams != null:
return cameraParams(_that);case MediaParam_NikkiPhoto() when nikkiPhoto != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CameraParams field0)?  cameraParams,TResult Function( NikkiPhotoParams field0)?  nikkiPhoto,TResult Function( ClockInPhotoParams field0)?  clockInPhoto,TResult Function( CollageParams field0)?  collage,TResult Function( ClothDiyParams field0)?  diy,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MediaParam_CameraParams() when cameraParams != null:
return cameraParams(_that.field0);case MediaParam_NikkiPhoto() when nikkiPhoto != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CameraParams field0)  cameraParams,required TResult Function( NikkiPhotoParams field0)  nikkiPhoto,required TResult Function( ClockInPhotoParams field0)  clockInPhoto,required TResult Function( CollageParams field0)  collage,required TResult Function( ClothDiyParams field0)  diy,}) {final _that = this;
switch (_that) {
case MediaParam_CameraParams():
return cameraParams(_that.field0);case MediaParam_NikkiPhoto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CameraParams field0)?  cameraParams,TResult? Function( NikkiPhotoParams field0)?  nikkiPhoto,TResult? Function( ClockInPhotoParams field0)?  clockInPhoto,TResult? Function( CollageParams field0)?  collage,TResult? Function( ClothDiyParams field0)?  diy,}) {final _that = this;
switch (_that) {
case MediaParam_CameraParams() when cameraParams != null:
return cameraParams(_that.field0);case MediaParam_NikkiPhoto() when nikkiPhoto != null:
return nikkiPhoto(_that.field0);case MediaParam_ClockInPhoto() when clockInPhoto != null:
return clockInPhoto(_that.field0);case MediaParam_Collage() when collage != null:
return collage(_that.field0);case MediaParam_DIY() when diy != null:
return diy(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class MediaParam_CameraParams extends MediaParam {
  const MediaParam_CameraParams(this.field0): super._();
  

@override final  CameraParams field0;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaParam_CameraParamsCopyWith<MediaParam_CameraParams> get copyWith => _$MediaParam_CameraParamsCopyWithImpl<MediaParam_CameraParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaParam_CameraParams&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'MediaParam.cameraParams(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $MediaParam_CameraParamsCopyWith<$Res> implements $MediaParamCopyWith<$Res> {
  factory $MediaParam_CameraParamsCopyWith(MediaParam_CameraParams value, $Res Function(MediaParam_CameraParams) _then) = _$MediaParam_CameraParamsCopyWithImpl;
@useResult
$Res call({
 CameraParams field0
});




}
/// @nodoc
class _$MediaParam_CameraParamsCopyWithImpl<$Res>
    implements $MediaParam_CameraParamsCopyWith<$Res> {
  _$MediaParam_CameraParamsCopyWithImpl(this._self, this._then);

  final MediaParam_CameraParams _self;
  final $Res Function(MediaParam_CameraParams) _then;

/// Create a copy of MediaParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(MediaParam_CameraParams(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as CameraParams,
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
  

@override final  ClothDiyParams field0;

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
 ClothDiyParams field0
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
as ClothDiyParams,
  ));
}


}

// dart format on
