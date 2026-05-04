use std::fmt::{Debug, Display, Formatter};
use flutter_rust_bridge::frb;
use serde::{ser, de};

#[derive(Debug)]
#[frb(name = "SerdeNuan5JsonError")]
pub struct Error{
  pub column: usize,
  pub line: usize,
  pub code: ErrorCode,
}

impl Error{
  #[cold]
  #[frb(name = "fromCode")]
  pub fn code(code: ErrorCode) -> Self{
    Error{
      column: 0,
      line: 0,
      code,
    }
  }

  #[cold]
  pub fn syntax(code: ErrorCode, line: usize, column: usize) -> Self{
    Error{column, line, code}
  }
}

impl Display for Error{
  fn fmt(&self, f: &mut Formatter) -> std::fmt::Result{
    write!(f, "{:?}", self.code)
  }
}
impl std::error::Error for Error{

}

impl ser::Error for Error{
  fn custom<T: Display>(msg: T) -> Self{
    Error{
      column: 0,
      line: 0,
      code: ErrorCode::Message(msg.to_string()),
    }
  }
}

impl de::Error for Error{
  fn custom<T>(msg: T) -> Self
  where
    T: Display
  {
    Error{
      column: 0,
      line: 0,
      code: ErrorCode::Message(msg.to_string()),
    }
  }
}

#[derive(Debug)]
pub enum ErrorCode {
  // ===== 值类型错误 =====
  ExpectedSomeValue,
  ExpectedSomeIdent,
  InvalidNumber,
  NumberOutOfRange,
  InvalidUnicodeCodePoint,

  // ===== 字符串解析错误 =====
  ExpectedDoubleQuote,
  EofWhileParsingString,
  ControlCharacterWhileParsingString,
  InvalidEscape,
  LoneLeadingSurrogateInHexEscape,
  UnexpectedEndOfHexEscape,

  // ===== 键相关错误 =====
  KeyMustBeAString,
  FloatKeyMustBeFinite,
  IdMapKeyMustBeAnInteger,
  ExpectedNumericKey,

  // ===== 对象/Map 解析错误 =====
  EofWhileParsingObject,
  ExpectedColon,
  ExpectedColonAtStart,
  ExpectedObjectCommaOrEnd,
  TrailingComma,
  EofWhileParsingIdMap,

  // ===== 数组解析错误 =====
  EofWhileParsingArray,
  ExpectedArrayCommaOrEnd,

  // ===== 通用解析状态错误 =====
  EofWhileParsingValue,
  TrailingCharacters,
  RecursionLimitExceeded,

  // ===== 通用消息 =====
  Message(String),
}