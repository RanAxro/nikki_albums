// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ErrorCode {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode()';
}


}

/// @nodoc
class $ErrorCodeCopyWith<$Res>  {
$ErrorCodeCopyWith(ErrorCode _, $Res Function(ErrorCode) __);
}


/// Adds pattern-matching-related methods to [ErrorCode].
extension ErrorCodePatterns on ErrorCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ErrorCode_ExpectedSomeValue value)?  expectedSomeValue,TResult Function( ErrorCode_ExpectedSomeIdent value)?  expectedSomeIdent,TResult Function( ErrorCode_InvalidNumber value)?  invalidNumber,TResult Function( ErrorCode_NumberOutOfRange value)?  numberOutOfRange,TResult Function( ErrorCode_InvalidUnicodeCodePoint value)?  invalidUnicodeCodePoint,TResult Function( ErrorCode_ExpectedDoubleQuote value)?  expectedDoubleQuote,TResult Function( ErrorCode_EofWhileParsingString value)?  eofWhileParsingString,TResult Function( ErrorCode_ControlCharacterWhileParsingString value)?  controlCharacterWhileParsingString,TResult Function( ErrorCode_InvalidEscape value)?  invalidEscape,TResult Function( ErrorCode_LoneLeadingSurrogateInHexEscape value)?  loneLeadingSurrogateInHexEscape,TResult Function( ErrorCode_UnexpectedEndOfHexEscape value)?  unexpectedEndOfHexEscape,TResult Function( ErrorCode_KeyMustBeAString value)?  keyMustBeAString,TResult Function( ErrorCode_FloatKeyMustBeFinite value)?  floatKeyMustBeFinite,TResult Function( ErrorCode_IdMapKeyMustBeAnInteger value)?  idMapKeyMustBeAnInteger,TResult Function( ErrorCode_ExpectedNumericKey value)?  expectedNumericKey,TResult Function( ErrorCode_EofWhileParsingObject value)?  eofWhileParsingObject,TResult Function( ErrorCode_ExpectedColon value)?  expectedColon,TResult Function( ErrorCode_ExpectedColonAtStart value)?  expectedColonAtStart,TResult Function( ErrorCode_ExpectedObjectCommaOrEnd value)?  expectedObjectCommaOrEnd,TResult Function( ErrorCode_TrailingComma value)?  trailingComma,TResult Function( ErrorCode_EofWhileParsingIdMap value)?  eofWhileParsingIdMap,TResult Function( ErrorCode_EofWhileParsingArray value)?  eofWhileParsingArray,TResult Function( ErrorCode_ExpectedArrayCommaOrEnd value)?  expectedArrayCommaOrEnd,TResult Function( ErrorCode_EofWhileParsingValue value)?  eofWhileParsingValue,TResult Function( ErrorCode_TrailingCharacters value)?  trailingCharacters,TResult Function( ErrorCode_RecursionLimitExceeded value)?  recursionLimitExceeded,TResult Function( ErrorCode_Message value)?  message,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ErrorCode_ExpectedSomeValue() when expectedSomeValue != null:
return expectedSomeValue(_that);case ErrorCode_ExpectedSomeIdent() when expectedSomeIdent != null:
return expectedSomeIdent(_that);case ErrorCode_InvalidNumber() when invalidNumber != null:
return invalidNumber(_that);case ErrorCode_NumberOutOfRange() when numberOutOfRange != null:
return numberOutOfRange(_that);case ErrorCode_InvalidUnicodeCodePoint() when invalidUnicodeCodePoint != null:
return invalidUnicodeCodePoint(_that);case ErrorCode_ExpectedDoubleQuote() when expectedDoubleQuote != null:
return expectedDoubleQuote(_that);case ErrorCode_EofWhileParsingString() when eofWhileParsingString != null:
return eofWhileParsingString(_that);case ErrorCode_ControlCharacterWhileParsingString() when controlCharacterWhileParsingString != null:
return controlCharacterWhileParsingString(_that);case ErrorCode_InvalidEscape() when invalidEscape != null:
return invalidEscape(_that);case ErrorCode_LoneLeadingSurrogateInHexEscape() when loneLeadingSurrogateInHexEscape != null:
return loneLeadingSurrogateInHexEscape(_that);case ErrorCode_UnexpectedEndOfHexEscape() when unexpectedEndOfHexEscape != null:
return unexpectedEndOfHexEscape(_that);case ErrorCode_KeyMustBeAString() when keyMustBeAString != null:
return keyMustBeAString(_that);case ErrorCode_FloatKeyMustBeFinite() when floatKeyMustBeFinite != null:
return floatKeyMustBeFinite(_that);case ErrorCode_IdMapKeyMustBeAnInteger() when idMapKeyMustBeAnInteger != null:
return idMapKeyMustBeAnInteger(_that);case ErrorCode_ExpectedNumericKey() when expectedNumericKey != null:
return expectedNumericKey(_that);case ErrorCode_EofWhileParsingObject() when eofWhileParsingObject != null:
return eofWhileParsingObject(_that);case ErrorCode_ExpectedColon() when expectedColon != null:
return expectedColon(_that);case ErrorCode_ExpectedColonAtStart() when expectedColonAtStart != null:
return expectedColonAtStart(_that);case ErrorCode_ExpectedObjectCommaOrEnd() when expectedObjectCommaOrEnd != null:
return expectedObjectCommaOrEnd(_that);case ErrorCode_TrailingComma() when trailingComma != null:
return trailingComma(_that);case ErrorCode_EofWhileParsingIdMap() when eofWhileParsingIdMap != null:
return eofWhileParsingIdMap(_that);case ErrorCode_EofWhileParsingArray() when eofWhileParsingArray != null:
return eofWhileParsingArray(_that);case ErrorCode_ExpectedArrayCommaOrEnd() when expectedArrayCommaOrEnd != null:
return expectedArrayCommaOrEnd(_that);case ErrorCode_EofWhileParsingValue() when eofWhileParsingValue != null:
return eofWhileParsingValue(_that);case ErrorCode_TrailingCharacters() when trailingCharacters != null:
return trailingCharacters(_that);case ErrorCode_RecursionLimitExceeded() when recursionLimitExceeded != null:
return recursionLimitExceeded(_that);case ErrorCode_Message() when message != null:
return message(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ErrorCode_ExpectedSomeValue value)  expectedSomeValue,required TResult Function( ErrorCode_ExpectedSomeIdent value)  expectedSomeIdent,required TResult Function( ErrorCode_InvalidNumber value)  invalidNumber,required TResult Function( ErrorCode_NumberOutOfRange value)  numberOutOfRange,required TResult Function( ErrorCode_InvalidUnicodeCodePoint value)  invalidUnicodeCodePoint,required TResult Function( ErrorCode_ExpectedDoubleQuote value)  expectedDoubleQuote,required TResult Function( ErrorCode_EofWhileParsingString value)  eofWhileParsingString,required TResult Function( ErrorCode_ControlCharacterWhileParsingString value)  controlCharacterWhileParsingString,required TResult Function( ErrorCode_InvalidEscape value)  invalidEscape,required TResult Function( ErrorCode_LoneLeadingSurrogateInHexEscape value)  loneLeadingSurrogateInHexEscape,required TResult Function( ErrorCode_UnexpectedEndOfHexEscape value)  unexpectedEndOfHexEscape,required TResult Function( ErrorCode_KeyMustBeAString value)  keyMustBeAString,required TResult Function( ErrorCode_FloatKeyMustBeFinite value)  floatKeyMustBeFinite,required TResult Function( ErrorCode_IdMapKeyMustBeAnInteger value)  idMapKeyMustBeAnInteger,required TResult Function( ErrorCode_ExpectedNumericKey value)  expectedNumericKey,required TResult Function( ErrorCode_EofWhileParsingObject value)  eofWhileParsingObject,required TResult Function( ErrorCode_ExpectedColon value)  expectedColon,required TResult Function( ErrorCode_ExpectedColonAtStart value)  expectedColonAtStart,required TResult Function( ErrorCode_ExpectedObjectCommaOrEnd value)  expectedObjectCommaOrEnd,required TResult Function( ErrorCode_TrailingComma value)  trailingComma,required TResult Function( ErrorCode_EofWhileParsingIdMap value)  eofWhileParsingIdMap,required TResult Function( ErrorCode_EofWhileParsingArray value)  eofWhileParsingArray,required TResult Function( ErrorCode_ExpectedArrayCommaOrEnd value)  expectedArrayCommaOrEnd,required TResult Function( ErrorCode_EofWhileParsingValue value)  eofWhileParsingValue,required TResult Function( ErrorCode_TrailingCharacters value)  trailingCharacters,required TResult Function( ErrorCode_RecursionLimitExceeded value)  recursionLimitExceeded,required TResult Function( ErrorCode_Message value)  message,}){
final _that = this;
switch (_that) {
case ErrorCode_ExpectedSomeValue():
return expectedSomeValue(_that);case ErrorCode_ExpectedSomeIdent():
return expectedSomeIdent(_that);case ErrorCode_InvalidNumber():
return invalidNumber(_that);case ErrorCode_NumberOutOfRange():
return numberOutOfRange(_that);case ErrorCode_InvalidUnicodeCodePoint():
return invalidUnicodeCodePoint(_that);case ErrorCode_ExpectedDoubleQuote():
return expectedDoubleQuote(_that);case ErrorCode_EofWhileParsingString():
return eofWhileParsingString(_that);case ErrorCode_ControlCharacterWhileParsingString():
return controlCharacterWhileParsingString(_that);case ErrorCode_InvalidEscape():
return invalidEscape(_that);case ErrorCode_LoneLeadingSurrogateInHexEscape():
return loneLeadingSurrogateInHexEscape(_that);case ErrorCode_UnexpectedEndOfHexEscape():
return unexpectedEndOfHexEscape(_that);case ErrorCode_KeyMustBeAString():
return keyMustBeAString(_that);case ErrorCode_FloatKeyMustBeFinite():
return floatKeyMustBeFinite(_that);case ErrorCode_IdMapKeyMustBeAnInteger():
return idMapKeyMustBeAnInteger(_that);case ErrorCode_ExpectedNumericKey():
return expectedNumericKey(_that);case ErrorCode_EofWhileParsingObject():
return eofWhileParsingObject(_that);case ErrorCode_ExpectedColon():
return expectedColon(_that);case ErrorCode_ExpectedColonAtStart():
return expectedColonAtStart(_that);case ErrorCode_ExpectedObjectCommaOrEnd():
return expectedObjectCommaOrEnd(_that);case ErrorCode_TrailingComma():
return trailingComma(_that);case ErrorCode_EofWhileParsingIdMap():
return eofWhileParsingIdMap(_that);case ErrorCode_EofWhileParsingArray():
return eofWhileParsingArray(_that);case ErrorCode_ExpectedArrayCommaOrEnd():
return expectedArrayCommaOrEnd(_that);case ErrorCode_EofWhileParsingValue():
return eofWhileParsingValue(_that);case ErrorCode_TrailingCharacters():
return trailingCharacters(_that);case ErrorCode_RecursionLimitExceeded():
return recursionLimitExceeded(_that);case ErrorCode_Message():
return message(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ErrorCode_ExpectedSomeValue value)?  expectedSomeValue,TResult? Function( ErrorCode_ExpectedSomeIdent value)?  expectedSomeIdent,TResult? Function( ErrorCode_InvalidNumber value)?  invalidNumber,TResult? Function( ErrorCode_NumberOutOfRange value)?  numberOutOfRange,TResult? Function( ErrorCode_InvalidUnicodeCodePoint value)?  invalidUnicodeCodePoint,TResult? Function( ErrorCode_ExpectedDoubleQuote value)?  expectedDoubleQuote,TResult? Function( ErrorCode_EofWhileParsingString value)?  eofWhileParsingString,TResult? Function( ErrorCode_ControlCharacterWhileParsingString value)?  controlCharacterWhileParsingString,TResult? Function( ErrorCode_InvalidEscape value)?  invalidEscape,TResult? Function( ErrorCode_LoneLeadingSurrogateInHexEscape value)?  loneLeadingSurrogateInHexEscape,TResult? Function( ErrorCode_UnexpectedEndOfHexEscape value)?  unexpectedEndOfHexEscape,TResult? Function( ErrorCode_KeyMustBeAString value)?  keyMustBeAString,TResult? Function( ErrorCode_FloatKeyMustBeFinite value)?  floatKeyMustBeFinite,TResult? Function( ErrorCode_IdMapKeyMustBeAnInteger value)?  idMapKeyMustBeAnInteger,TResult? Function( ErrorCode_ExpectedNumericKey value)?  expectedNumericKey,TResult? Function( ErrorCode_EofWhileParsingObject value)?  eofWhileParsingObject,TResult? Function( ErrorCode_ExpectedColon value)?  expectedColon,TResult? Function( ErrorCode_ExpectedColonAtStart value)?  expectedColonAtStart,TResult? Function( ErrorCode_ExpectedObjectCommaOrEnd value)?  expectedObjectCommaOrEnd,TResult? Function( ErrorCode_TrailingComma value)?  trailingComma,TResult? Function( ErrorCode_EofWhileParsingIdMap value)?  eofWhileParsingIdMap,TResult? Function( ErrorCode_EofWhileParsingArray value)?  eofWhileParsingArray,TResult? Function( ErrorCode_ExpectedArrayCommaOrEnd value)?  expectedArrayCommaOrEnd,TResult? Function( ErrorCode_EofWhileParsingValue value)?  eofWhileParsingValue,TResult? Function( ErrorCode_TrailingCharacters value)?  trailingCharacters,TResult? Function( ErrorCode_RecursionLimitExceeded value)?  recursionLimitExceeded,TResult? Function( ErrorCode_Message value)?  message,}){
final _that = this;
switch (_that) {
case ErrorCode_ExpectedSomeValue() when expectedSomeValue != null:
return expectedSomeValue(_that);case ErrorCode_ExpectedSomeIdent() when expectedSomeIdent != null:
return expectedSomeIdent(_that);case ErrorCode_InvalidNumber() when invalidNumber != null:
return invalidNumber(_that);case ErrorCode_NumberOutOfRange() when numberOutOfRange != null:
return numberOutOfRange(_that);case ErrorCode_InvalidUnicodeCodePoint() when invalidUnicodeCodePoint != null:
return invalidUnicodeCodePoint(_that);case ErrorCode_ExpectedDoubleQuote() when expectedDoubleQuote != null:
return expectedDoubleQuote(_that);case ErrorCode_EofWhileParsingString() when eofWhileParsingString != null:
return eofWhileParsingString(_that);case ErrorCode_ControlCharacterWhileParsingString() when controlCharacterWhileParsingString != null:
return controlCharacterWhileParsingString(_that);case ErrorCode_InvalidEscape() when invalidEscape != null:
return invalidEscape(_that);case ErrorCode_LoneLeadingSurrogateInHexEscape() when loneLeadingSurrogateInHexEscape != null:
return loneLeadingSurrogateInHexEscape(_that);case ErrorCode_UnexpectedEndOfHexEscape() when unexpectedEndOfHexEscape != null:
return unexpectedEndOfHexEscape(_that);case ErrorCode_KeyMustBeAString() when keyMustBeAString != null:
return keyMustBeAString(_that);case ErrorCode_FloatKeyMustBeFinite() when floatKeyMustBeFinite != null:
return floatKeyMustBeFinite(_that);case ErrorCode_IdMapKeyMustBeAnInteger() when idMapKeyMustBeAnInteger != null:
return idMapKeyMustBeAnInteger(_that);case ErrorCode_ExpectedNumericKey() when expectedNumericKey != null:
return expectedNumericKey(_that);case ErrorCode_EofWhileParsingObject() when eofWhileParsingObject != null:
return eofWhileParsingObject(_that);case ErrorCode_ExpectedColon() when expectedColon != null:
return expectedColon(_that);case ErrorCode_ExpectedColonAtStart() when expectedColonAtStart != null:
return expectedColonAtStart(_that);case ErrorCode_ExpectedObjectCommaOrEnd() when expectedObjectCommaOrEnd != null:
return expectedObjectCommaOrEnd(_that);case ErrorCode_TrailingComma() when trailingComma != null:
return trailingComma(_that);case ErrorCode_EofWhileParsingIdMap() when eofWhileParsingIdMap != null:
return eofWhileParsingIdMap(_that);case ErrorCode_EofWhileParsingArray() when eofWhileParsingArray != null:
return eofWhileParsingArray(_that);case ErrorCode_ExpectedArrayCommaOrEnd() when expectedArrayCommaOrEnd != null:
return expectedArrayCommaOrEnd(_that);case ErrorCode_EofWhileParsingValue() when eofWhileParsingValue != null:
return eofWhileParsingValue(_that);case ErrorCode_TrailingCharacters() when trailingCharacters != null:
return trailingCharacters(_that);case ErrorCode_RecursionLimitExceeded() when recursionLimitExceeded != null:
return recursionLimitExceeded(_that);case ErrorCode_Message() when message != null:
return message(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  expectedSomeValue,TResult Function()?  expectedSomeIdent,TResult Function()?  invalidNumber,TResult Function()?  numberOutOfRange,TResult Function()?  invalidUnicodeCodePoint,TResult Function()?  expectedDoubleQuote,TResult Function()?  eofWhileParsingString,TResult Function()?  controlCharacterWhileParsingString,TResult Function()?  invalidEscape,TResult Function()?  loneLeadingSurrogateInHexEscape,TResult Function()?  unexpectedEndOfHexEscape,TResult Function()?  keyMustBeAString,TResult Function()?  floatKeyMustBeFinite,TResult Function()?  idMapKeyMustBeAnInteger,TResult Function()?  expectedNumericKey,TResult Function()?  eofWhileParsingObject,TResult Function()?  expectedColon,TResult Function()?  expectedColonAtStart,TResult Function()?  expectedObjectCommaOrEnd,TResult Function()?  trailingComma,TResult Function()?  eofWhileParsingIdMap,TResult Function()?  eofWhileParsingArray,TResult Function()?  expectedArrayCommaOrEnd,TResult Function()?  eofWhileParsingValue,TResult Function()?  trailingCharacters,TResult Function()?  recursionLimitExceeded,TResult Function( String field0)?  message,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ErrorCode_ExpectedSomeValue() when expectedSomeValue != null:
return expectedSomeValue();case ErrorCode_ExpectedSomeIdent() when expectedSomeIdent != null:
return expectedSomeIdent();case ErrorCode_InvalidNumber() when invalidNumber != null:
return invalidNumber();case ErrorCode_NumberOutOfRange() when numberOutOfRange != null:
return numberOutOfRange();case ErrorCode_InvalidUnicodeCodePoint() when invalidUnicodeCodePoint != null:
return invalidUnicodeCodePoint();case ErrorCode_ExpectedDoubleQuote() when expectedDoubleQuote != null:
return expectedDoubleQuote();case ErrorCode_EofWhileParsingString() when eofWhileParsingString != null:
return eofWhileParsingString();case ErrorCode_ControlCharacterWhileParsingString() when controlCharacterWhileParsingString != null:
return controlCharacterWhileParsingString();case ErrorCode_InvalidEscape() when invalidEscape != null:
return invalidEscape();case ErrorCode_LoneLeadingSurrogateInHexEscape() when loneLeadingSurrogateInHexEscape != null:
return loneLeadingSurrogateInHexEscape();case ErrorCode_UnexpectedEndOfHexEscape() when unexpectedEndOfHexEscape != null:
return unexpectedEndOfHexEscape();case ErrorCode_KeyMustBeAString() when keyMustBeAString != null:
return keyMustBeAString();case ErrorCode_FloatKeyMustBeFinite() when floatKeyMustBeFinite != null:
return floatKeyMustBeFinite();case ErrorCode_IdMapKeyMustBeAnInteger() when idMapKeyMustBeAnInteger != null:
return idMapKeyMustBeAnInteger();case ErrorCode_ExpectedNumericKey() when expectedNumericKey != null:
return expectedNumericKey();case ErrorCode_EofWhileParsingObject() when eofWhileParsingObject != null:
return eofWhileParsingObject();case ErrorCode_ExpectedColon() when expectedColon != null:
return expectedColon();case ErrorCode_ExpectedColonAtStart() when expectedColonAtStart != null:
return expectedColonAtStart();case ErrorCode_ExpectedObjectCommaOrEnd() when expectedObjectCommaOrEnd != null:
return expectedObjectCommaOrEnd();case ErrorCode_TrailingComma() when trailingComma != null:
return trailingComma();case ErrorCode_EofWhileParsingIdMap() when eofWhileParsingIdMap != null:
return eofWhileParsingIdMap();case ErrorCode_EofWhileParsingArray() when eofWhileParsingArray != null:
return eofWhileParsingArray();case ErrorCode_ExpectedArrayCommaOrEnd() when expectedArrayCommaOrEnd != null:
return expectedArrayCommaOrEnd();case ErrorCode_EofWhileParsingValue() when eofWhileParsingValue != null:
return eofWhileParsingValue();case ErrorCode_TrailingCharacters() when trailingCharacters != null:
return trailingCharacters();case ErrorCode_RecursionLimitExceeded() when recursionLimitExceeded != null:
return recursionLimitExceeded();case ErrorCode_Message() when message != null:
return message(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  expectedSomeValue,required TResult Function()  expectedSomeIdent,required TResult Function()  invalidNumber,required TResult Function()  numberOutOfRange,required TResult Function()  invalidUnicodeCodePoint,required TResult Function()  expectedDoubleQuote,required TResult Function()  eofWhileParsingString,required TResult Function()  controlCharacterWhileParsingString,required TResult Function()  invalidEscape,required TResult Function()  loneLeadingSurrogateInHexEscape,required TResult Function()  unexpectedEndOfHexEscape,required TResult Function()  keyMustBeAString,required TResult Function()  floatKeyMustBeFinite,required TResult Function()  idMapKeyMustBeAnInteger,required TResult Function()  expectedNumericKey,required TResult Function()  eofWhileParsingObject,required TResult Function()  expectedColon,required TResult Function()  expectedColonAtStart,required TResult Function()  expectedObjectCommaOrEnd,required TResult Function()  trailingComma,required TResult Function()  eofWhileParsingIdMap,required TResult Function()  eofWhileParsingArray,required TResult Function()  expectedArrayCommaOrEnd,required TResult Function()  eofWhileParsingValue,required TResult Function()  trailingCharacters,required TResult Function()  recursionLimitExceeded,required TResult Function( String field0)  message,}) {final _that = this;
switch (_that) {
case ErrorCode_ExpectedSomeValue():
return expectedSomeValue();case ErrorCode_ExpectedSomeIdent():
return expectedSomeIdent();case ErrorCode_InvalidNumber():
return invalidNumber();case ErrorCode_NumberOutOfRange():
return numberOutOfRange();case ErrorCode_InvalidUnicodeCodePoint():
return invalidUnicodeCodePoint();case ErrorCode_ExpectedDoubleQuote():
return expectedDoubleQuote();case ErrorCode_EofWhileParsingString():
return eofWhileParsingString();case ErrorCode_ControlCharacterWhileParsingString():
return controlCharacterWhileParsingString();case ErrorCode_InvalidEscape():
return invalidEscape();case ErrorCode_LoneLeadingSurrogateInHexEscape():
return loneLeadingSurrogateInHexEscape();case ErrorCode_UnexpectedEndOfHexEscape():
return unexpectedEndOfHexEscape();case ErrorCode_KeyMustBeAString():
return keyMustBeAString();case ErrorCode_FloatKeyMustBeFinite():
return floatKeyMustBeFinite();case ErrorCode_IdMapKeyMustBeAnInteger():
return idMapKeyMustBeAnInteger();case ErrorCode_ExpectedNumericKey():
return expectedNumericKey();case ErrorCode_EofWhileParsingObject():
return eofWhileParsingObject();case ErrorCode_ExpectedColon():
return expectedColon();case ErrorCode_ExpectedColonAtStart():
return expectedColonAtStart();case ErrorCode_ExpectedObjectCommaOrEnd():
return expectedObjectCommaOrEnd();case ErrorCode_TrailingComma():
return trailingComma();case ErrorCode_EofWhileParsingIdMap():
return eofWhileParsingIdMap();case ErrorCode_EofWhileParsingArray():
return eofWhileParsingArray();case ErrorCode_ExpectedArrayCommaOrEnd():
return expectedArrayCommaOrEnd();case ErrorCode_EofWhileParsingValue():
return eofWhileParsingValue();case ErrorCode_TrailingCharacters():
return trailingCharacters();case ErrorCode_RecursionLimitExceeded():
return recursionLimitExceeded();case ErrorCode_Message():
return message(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  expectedSomeValue,TResult? Function()?  expectedSomeIdent,TResult? Function()?  invalidNumber,TResult? Function()?  numberOutOfRange,TResult? Function()?  invalidUnicodeCodePoint,TResult? Function()?  expectedDoubleQuote,TResult? Function()?  eofWhileParsingString,TResult? Function()?  controlCharacterWhileParsingString,TResult? Function()?  invalidEscape,TResult? Function()?  loneLeadingSurrogateInHexEscape,TResult? Function()?  unexpectedEndOfHexEscape,TResult? Function()?  keyMustBeAString,TResult? Function()?  floatKeyMustBeFinite,TResult? Function()?  idMapKeyMustBeAnInteger,TResult? Function()?  expectedNumericKey,TResult? Function()?  eofWhileParsingObject,TResult? Function()?  expectedColon,TResult? Function()?  expectedColonAtStart,TResult? Function()?  expectedObjectCommaOrEnd,TResult? Function()?  trailingComma,TResult? Function()?  eofWhileParsingIdMap,TResult? Function()?  eofWhileParsingArray,TResult? Function()?  expectedArrayCommaOrEnd,TResult? Function()?  eofWhileParsingValue,TResult? Function()?  trailingCharacters,TResult? Function()?  recursionLimitExceeded,TResult? Function( String field0)?  message,}) {final _that = this;
switch (_that) {
case ErrorCode_ExpectedSomeValue() when expectedSomeValue != null:
return expectedSomeValue();case ErrorCode_ExpectedSomeIdent() when expectedSomeIdent != null:
return expectedSomeIdent();case ErrorCode_InvalidNumber() when invalidNumber != null:
return invalidNumber();case ErrorCode_NumberOutOfRange() when numberOutOfRange != null:
return numberOutOfRange();case ErrorCode_InvalidUnicodeCodePoint() when invalidUnicodeCodePoint != null:
return invalidUnicodeCodePoint();case ErrorCode_ExpectedDoubleQuote() when expectedDoubleQuote != null:
return expectedDoubleQuote();case ErrorCode_EofWhileParsingString() when eofWhileParsingString != null:
return eofWhileParsingString();case ErrorCode_ControlCharacterWhileParsingString() when controlCharacterWhileParsingString != null:
return controlCharacterWhileParsingString();case ErrorCode_InvalidEscape() when invalidEscape != null:
return invalidEscape();case ErrorCode_LoneLeadingSurrogateInHexEscape() when loneLeadingSurrogateInHexEscape != null:
return loneLeadingSurrogateInHexEscape();case ErrorCode_UnexpectedEndOfHexEscape() when unexpectedEndOfHexEscape != null:
return unexpectedEndOfHexEscape();case ErrorCode_KeyMustBeAString() when keyMustBeAString != null:
return keyMustBeAString();case ErrorCode_FloatKeyMustBeFinite() when floatKeyMustBeFinite != null:
return floatKeyMustBeFinite();case ErrorCode_IdMapKeyMustBeAnInteger() when idMapKeyMustBeAnInteger != null:
return idMapKeyMustBeAnInteger();case ErrorCode_ExpectedNumericKey() when expectedNumericKey != null:
return expectedNumericKey();case ErrorCode_EofWhileParsingObject() when eofWhileParsingObject != null:
return eofWhileParsingObject();case ErrorCode_ExpectedColon() when expectedColon != null:
return expectedColon();case ErrorCode_ExpectedColonAtStart() when expectedColonAtStart != null:
return expectedColonAtStart();case ErrorCode_ExpectedObjectCommaOrEnd() when expectedObjectCommaOrEnd != null:
return expectedObjectCommaOrEnd();case ErrorCode_TrailingComma() when trailingComma != null:
return trailingComma();case ErrorCode_EofWhileParsingIdMap() when eofWhileParsingIdMap != null:
return eofWhileParsingIdMap();case ErrorCode_EofWhileParsingArray() when eofWhileParsingArray != null:
return eofWhileParsingArray();case ErrorCode_ExpectedArrayCommaOrEnd() when expectedArrayCommaOrEnd != null:
return expectedArrayCommaOrEnd();case ErrorCode_EofWhileParsingValue() when eofWhileParsingValue != null:
return eofWhileParsingValue();case ErrorCode_TrailingCharacters() when trailingCharacters != null:
return trailingCharacters();case ErrorCode_RecursionLimitExceeded() when recursionLimitExceeded != null:
return recursionLimitExceeded();case ErrorCode_Message() when message != null:
return message(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ErrorCode_ExpectedSomeValue extends ErrorCode {
  const ErrorCode_ExpectedSomeValue(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_ExpectedSomeValue);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.expectedSomeValue()';
}


}




/// @nodoc


class ErrorCode_ExpectedSomeIdent extends ErrorCode {
  const ErrorCode_ExpectedSomeIdent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_ExpectedSomeIdent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.expectedSomeIdent()';
}


}




/// @nodoc


class ErrorCode_InvalidNumber extends ErrorCode {
  const ErrorCode_InvalidNumber(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_InvalidNumber);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.invalidNumber()';
}


}




/// @nodoc


class ErrorCode_NumberOutOfRange extends ErrorCode {
  const ErrorCode_NumberOutOfRange(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_NumberOutOfRange);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.numberOutOfRange()';
}


}




/// @nodoc


class ErrorCode_InvalidUnicodeCodePoint extends ErrorCode {
  const ErrorCode_InvalidUnicodeCodePoint(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_InvalidUnicodeCodePoint);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.invalidUnicodeCodePoint()';
}


}




/// @nodoc


class ErrorCode_ExpectedDoubleQuote extends ErrorCode {
  const ErrorCode_ExpectedDoubleQuote(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_ExpectedDoubleQuote);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.expectedDoubleQuote()';
}


}




/// @nodoc


class ErrorCode_EofWhileParsingString extends ErrorCode {
  const ErrorCode_EofWhileParsingString(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_EofWhileParsingString);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.eofWhileParsingString()';
}


}




/// @nodoc


class ErrorCode_ControlCharacterWhileParsingString extends ErrorCode {
  const ErrorCode_ControlCharacterWhileParsingString(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_ControlCharacterWhileParsingString);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.controlCharacterWhileParsingString()';
}


}




/// @nodoc


class ErrorCode_InvalidEscape extends ErrorCode {
  const ErrorCode_InvalidEscape(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_InvalidEscape);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.invalidEscape()';
}


}




/// @nodoc


class ErrorCode_LoneLeadingSurrogateInHexEscape extends ErrorCode {
  const ErrorCode_LoneLeadingSurrogateInHexEscape(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_LoneLeadingSurrogateInHexEscape);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.loneLeadingSurrogateInHexEscape()';
}


}




/// @nodoc


class ErrorCode_UnexpectedEndOfHexEscape extends ErrorCode {
  const ErrorCode_UnexpectedEndOfHexEscape(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_UnexpectedEndOfHexEscape);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.unexpectedEndOfHexEscape()';
}


}




/// @nodoc


class ErrorCode_KeyMustBeAString extends ErrorCode {
  const ErrorCode_KeyMustBeAString(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_KeyMustBeAString);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.keyMustBeAString()';
}


}




/// @nodoc


class ErrorCode_FloatKeyMustBeFinite extends ErrorCode {
  const ErrorCode_FloatKeyMustBeFinite(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_FloatKeyMustBeFinite);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.floatKeyMustBeFinite()';
}


}




/// @nodoc


class ErrorCode_IdMapKeyMustBeAnInteger extends ErrorCode {
  const ErrorCode_IdMapKeyMustBeAnInteger(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_IdMapKeyMustBeAnInteger);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.idMapKeyMustBeAnInteger()';
}


}




/// @nodoc


class ErrorCode_ExpectedNumericKey extends ErrorCode {
  const ErrorCode_ExpectedNumericKey(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_ExpectedNumericKey);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.expectedNumericKey()';
}


}




/// @nodoc


class ErrorCode_EofWhileParsingObject extends ErrorCode {
  const ErrorCode_EofWhileParsingObject(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_EofWhileParsingObject);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.eofWhileParsingObject()';
}


}




/// @nodoc


class ErrorCode_ExpectedColon extends ErrorCode {
  const ErrorCode_ExpectedColon(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_ExpectedColon);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.expectedColon()';
}


}




/// @nodoc


class ErrorCode_ExpectedColonAtStart extends ErrorCode {
  const ErrorCode_ExpectedColonAtStart(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_ExpectedColonAtStart);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.expectedColonAtStart()';
}


}




/// @nodoc


class ErrorCode_ExpectedObjectCommaOrEnd extends ErrorCode {
  const ErrorCode_ExpectedObjectCommaOrEnd(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_ExpectedObjectCommaOrEnd);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.expectedObjectCommaOrEnd()';
}


}




/// @nodoc


class ErrorCode_TrailingComma extends ErrorCode {
  const ErrorCode_TrailingComma(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_TrailingComma);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.trailingComma()';
}


}




/// @nodoc


class ErrorCode_EofWhileParsingIdMap extends ErrorCode {
  const ErrorCode_EofWhileParsingIdMap(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_EofWhileParsingIdMap);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.eofWhileParsingIdMap()';
}


}




/// @nodoc


class ErrorCode_EofWhileParsingArray extends ErrorCode {
  const ErrorCode_EofWhileParsingArray(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_EofWhileParsingArray);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.eofWhileParsingArray()';
}


}




/// @nodoc


class ErrorCode_ExpectedArrayCommaOrEnd extends ErrorCode {
  const ErrorCode_ExpectedArrayCommaOrEnd(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_ExpectedArrayCommaOrEnd);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.expectedArrayCommaOrEnd()';
}


}




/// @nodoc


class ErrorCode_EofWhileParsingValue extends ErrorCode {
  const ErrorCode_EofWhileParsingValue(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_EofWhileParsingValue);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.eofWhileParsingValue()';
}


}




/// @nodoc


class ErrorCode_TrailingCharacters extends ErrorCode {
  const ErrorCode_TrailingCharacters(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_TrailingCharacters);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.trailingCharacters()';
}


}




/// @nodoc


class ErrorCode_RecursionLimitExceeded extends ErrorCode {
  const ErrorCode_RecursionLimitExceeded(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_RecursionLimitExceeded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ErrorCode.recursionLimitExceeded()';
}


}




/// @nodoc


class ErrorCode_Message extends ErrorCode {
  const ErrorCode_Message(this.field0): super._();
  

 final  String field0;

/// Create a copy of ErrorCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCode_MessageCopyWith<ErrorCode_Message> get copyWith => _$ErrorCode_MessageCopyWithImpl<ErrorCode_Message>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCode_Message&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ErrorCode.message(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ErrorCode_MessageCopyWith<$Res> implements $ErrorCodeCopyWith<$Res> {
  factory $ErrorCode_MessageCopyWith(ErrorCode_Message value, $Res Function(ErrorCode_Message) _then) = _$ErrorCode_MessageCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$ErrorCode_MessageCopyWithImpl<$Res>
    implements $ErrorCode_MessageCopyWith<$Res> {
  _$ErrorCode_MessageCopyWithImpl(this._self, this._then);

  final ErrorCode_Message _self;
  final $Res Function(ErrorCode_Message) _then;

/// Create a copy of ErrorCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ErrorCode_Message(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
