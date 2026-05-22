// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Text {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Text&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'Text(field0: $field0)';
}


}

/// @nodoc
class $TextCopyWith<$Res>  {
$TextCopyWith(Text _, $Res Function(Text) __);
}


/// Adds pattern-matching-related methods to [Text].
extension TextPatterns on Text {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Text_Ordinary value)?  ordinary,TResult Function( Text_Translate value)?  translate,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Text_Ordinary() when ordinary != null:
return ordinary(_that);case Text_Translate() when translate != null:
return translate(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Text_Ordinary value)  ordinary,required TResult Function( Text_Translate value)  translate,}){
final _that = this;
switch (_that) {
case Text_Ordinary():
return ordinary(_that);case Text_Translate():
return translate(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Text_Ordinary value)?  ordinary,TResult? Function( Text_Translate value)?  translate,}){
final _that = this;
switch (_that) {
case Text_Ordinary() when ordinary != null:
return ordinary(_that);case Text_Translate() when translate != null:
return translate(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( OrdinaryText field0)?  ordinary,TResult Function( TranslateText field0)?  translate,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Text_Ordinary() when ordinary != null:
return ordinary(_that.field0);case Text_Translate() when translate != null:
return translate(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( OrdinaryText field0)  ordinary,required TResult Function( TranslateText field0)  translate,}) {final _that = this;
switch (_that) {
case Text_Ordinary():
return ordinary(_that.field0);case Text_Translate():
return translate(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( OrdinaryText field0)?  ordinary,TResult? Function( TranslateText field0)?  translate,}) {final _that = this;
switch (_that) {
case Text_Ordinary() when ordinary != null:
return ordinary(_that.field0);case Text_Translate() when translate != null:
return translate(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class Text_Ordinary extends Text {
  const Text_Ordinary(this.field0): super._();
  

@override final  OrdinaryText field0;

/// Create a copy of Text
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Text_OrdinaryCopyWith<Text_Ordinary> get copyWith => _$Text_OrdinaryCopyWithImpl<Text_Ordinary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Text_Ordinary&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Text.ordinary(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Text_OrdinaryCopyWith<$Res> implements $TextCopyWith<$Res> {
  factory $Text_OrdinaryCopyWith(Text_Ordinary value, $Res Function(Text_Ordinary) _then) = _$Text_OrdinaryCopyWithImpl;
@useResult
$Res call({
 OrdinaryText field0
});




}
/// @nodoc
class _$Text_OrdinaryCopyWithImpl<$Res>
    implements $Text_OrdinaryCopyWith<$Res> {
  _$Text_OrdinaryCopyWithImpl(this._self, this._then);

  final Text_Ordinary _self;
  final $Res Function(Text_Ordinary) _then;

/// Create a copy of Text
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Text_Ordinary(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as OrdinaryText,
  ));
}


}

/// @nodoc


class Text_Translate extends Text {
  const Text_Translate(this.field0): super._();
  

@override final  TranslateText field0;

/// Create a copy of Text
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Text_TranslateCopyWith<Text_Translate> get copyWith => _$Text_TranslateCopyWithImpl<Text_Translate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Text_Translate&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'Text.translate(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Text_TranslateCopyWith<$Res> implements $TextCopyWith<$Res> {
  factory $Text_TranslateCopyWith(Text_Translate value, $Res Function(Text_Translate) _then) = _$Text_TranslateCopyWithImpl;
@useResult
$Res call({
 TranslateText field0
});




}
/// @nodoc
class _$Text_TranslateCopyWithImpl<$Res>
    implements $Text_TranslateCopyWith<$Res> {
  _$Text_TranslateCopyWithImpl(this._self, this._then);

  final Text_Translate _self;
  final $Res Function(Text_Translate) _then;

/// Create a copy of Text
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Text_Translate(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as TranslateText,
  ));
}


}

// dart format on
