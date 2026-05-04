use std::cmp;
use std::ops::Deref;
use super::ext_type::ID_MAP_TOKEN;
use super::error::{Error, ErrorCode};
use serde::{de, forward_to_deserialize_any};
use serde::de::{Expected, Unexpected, Visitor};



type Input<'a> = &'a [u8];

/// A structure that deserializes nuan5json into Rust values.
struct Deserializer<'a>{
  input: Input<'a>,
  index: usize,
  scratch: Vec<u8>,
  remaining_depth: u8,
}

impl<'a> Deserializer<'a>{
  pub fn new(input: Input<'a>) -> Self{
    Deserializer{
      input,
      index: 0,
      scratch: Vec::new(),
      remaining_depth: 128,
    }
  }
}


struct Position{
  pub line: usize,
  pub column: usize,
}

/// error
impl<'a> Deserializer<'a>{
  #[cold]
  fn position_of_index(&self, i: usize) -> Position{
    let start_of_line = match memchr::memrchr(b'\n', &self.input[..i]){
      Some(position) => position + 1,
      None => 0,
    };
    Position{
      line: 1 + memchr::memchr_iter(b'\n', &self.input[..start_of_line]).count(),
      column: i - start_of_line,
    }
  }

  #[cold]
  fn position(&self) -> Position{
    self.position_of_index(self.index)
  }

  #[cold]
  fn peek_position(&self) -> Position{
    self.position_of_index(cmp::min(self.input.len(), self.index + 1))
  }

  #[cold]
  fn error(&self, reason: ErrorCode) -> Error{
    let position = self.position();
    Error::syntax(reason, position.line, position.column)
  }

  #[cold]
  fn peek_error(&self, reason: ErrorCode) -> Error{
    let position = self.peek_position();
    Error::syntax(reason, position.line, position.column)
  }

  #[cold]
  fn peek_invalid_type(&mut self, exp: &dyn Expected) -> Error{
    match self.expect_peek(){
      Ok(peek) => {
        match peek{
          b'n' => {
            self.discard();
            if let Err(err) = self.parse_ident(b"ull"){
              return err;
            }
            de::Error::invalid_type(Unexpected::Unit, exp)
          }
          b't' => {
            self.discard();
            if let Err(err) = self.parse_ident(b"rue"){
              return err;
            }
            de::Error::invalid_type(Unexpected::Bool(true), exp)
          }
          b'f' => {
            self.discard();
            if let Err(err) = self.parse_ident(b"alse"){
              return err;
            }
            de::Error::invalid_type(Unexpected::Bool(false), exp)
          }
          b'-' => {
            self.discard();
            match self.parse_any_number(false){
              Ok(n) => n.invalid_type(exp),
              Err(err) => err,
            }
          }
          b'0'..=b'9' => match self.parse_any_number(true){
            Ok(n) => n.invalid_type(exp),
            Err(err) => err,
          },
          b'"' => {
            self.discard();
            self.scratch.clear();
            match self.parse_str(){
              Ok(s) => de::Error::invalid_type(Unexpected::Str(&s), exp),
              Err(err) => err,
            }
          }
          b'[' => de::Error::invalid_type(Unexpected::Seq, exp),
          b'{' => de::Error::invalid_type(Unexpected::Map, exp),
          _ => self.peek_error(ErrorCode::ExpectedSomeValue),
        }
      }
      Err(err) => err
    }
  }

  /// The `Deserializer::end` method should be called after a value has been fully deserialized.
  /// This allows the `Deserializer` to validate that the input is at the end or that it
  /// only has trailing whitespace.
  pub fn end(&mut self) -> Result<(), Error>{
    Ok(())
    // match self.parse_whitespace(){
    //   Some(_) => Err(self.peek_error(ErrorCode::TrailingCharacters)),
    //   None => Ok(()),
    // }
  }
}

/// deserialize_number
impl<'a> Deserializer<'a>{
  pub fn deserialize_number<'any, V>(&mut self, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'any>,
  {
    match self.expect_parse_whitespace()?{
      b'-' => {
        self.discard();
        self.parse_integer(false)?.visit(visitor)
      }
      b'0'..=b'9' => self.parse_integer(true)?.visit(visitor),
      _ => Err(self.peek_invalid_type(&visitor)),
    }
  }

  pub fn do_deserialize_i128<'any, V>(&mut self, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'any>,
  {
    let mut buf = String::new();

    match self.expect_parse_whitespace()?{
      b'-' => {
        self.discard();
        buf.push('-');
      }
      _ => {}
    }

    self.scan_integer128(&mut buf)?;

    match buf.parse(){
      Ok(int) => visitor.visit_i128(int),
      Err(_) => {
        return Err(self.error(ErrorCode::NumberOutOfRange));
      }
    }
  }

  pub(crate) fn do_deserialize_u128<'any, V>(&mut self, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'any>,
  {
    match self.expect_parse_whitespace()?{
      b'-' => {
        return Err(self.peek_error(ErrorCode::NumberOutOfRange));
      }
      _ => {}
    }

    let mut buf = String::new();
    self.scan_integer128(&mut buf)?;

    match buf.parse(){
      Ok(int) => visitor.visit_u128(int),
      Err(_) => {
        Err(self.error(ErrorCode::NumberOutOfRange))
      }
    }
  }

  fn scan_integer128(&mut self, buf: &mut String) -> Result<(), Error>{
    match self.expect_next()?{
      b'0' => {
        buf.push('0');
        // There can be only one leading '0'.
        match self.expect_peek()?{
          b'0'..=b'9' => Err(self.peek_error(ErrorCode::InvalidNumber)),
          _ => Ok(()),
        }
      }
      c @ b'1'..=b'9' => {
        buf.push(c as char);
        while let c @ b'0'..=b'9' = self.expect_peek()?{
          self.discard();
          buf.push(c as char);
        }
        Ok(())
      }
      _ => Err(self.error(ErrorCode::InvalidNumber)),
    }
  }
}

/// parse mediocrity
impl<'a> Deserializer<'a>{
  #[inline]
  fn next(&mut self) -> Option<u8>{
    if self.index < self.input.len() {
      let c = self.input[self.index];
      self.index += 1;
      Some(c)
    }else{
      None
    }
  }

  #[inline]
  fn expect_next(&mut self) -> Result<u8, Error>{
    if self.index < self.input.len() {
      let c = self.input[self.index];
      self.index += 1;
      Ok(c)
    }else{
      Err(self.peek_error(ErrorCode::EofWhileParsingValue))
    }
  }

  #[inline]
  fn peek(&mut self) -> Option<u8>{
    if self.index < self.input.len() {
      Some(self.input[self.index])
    }else{
      None
    }
  }

  #[inline]
  fn expect_peek(&mut self) -> Result<u8, Error>{
    if self.index < self.input.len() {
      Ok(self.input[self.index])
    }else{
      Err(self.peek_error(ErrorCode::EofWhileParsingValue))
    }
  }

  #[inline]
  fn discard(&mut self){
    self.index += 1;
  }

  /// Returns the first non-whitespace byte without consuming it, or `None` if
  /// EOF is encountered.
  #[inline]
  fn parse_whitespace(&mut self) -> Option<u8>{
    loop{
      match self.peek(){
        Some(b' ' | b'\n' | b'\t' | b'\r') => {
          self.discard();
        }
        other => {
          return other;
        }
      }
    }
  }

  #[inline]
  fn expect_parse_whitespace(&mut self) -> Result<u8, Error>{
    loop{
      match self.peek(){
        None => {
          return Err(self.peek_error(ErrorCode::EofWhileParsingValue))
        },
        Some(b' ' | b'\n' | b'\t' | b'\r') => {
          self.discard();
        },
        Some(other) => {
          return Ok(other);
        },
      }
    }
  }

  #[inline]
  fn parse_ident(&mut self, ident: &[u8]) -> Result<(), Error>{
    for expected in ident{
      match self.next(){
        None => {
          return Err(self.error(ErrorCode::EofWhileParsingValue));
        }
        Some(next) => {
          if next != *expected {
            return Err(self.error(ErrorCode::ExpectedSomeIdent));
          }
        }
      }
    }

    Ok(())
  }
}

/// Adds a WTF-8 codepoint to the end of the buffer. This is a more efficient
/// implementation of String::push. The codepoint may be a surrogate.
#[inline]
fn push_wtf8_codepoint(n: u32, scratch: &mut Vec<u8>) {
  if n < 0x80 {
    scratch.push(n as u8);
    return;
  }

  scratch.reserve(4);

  // SAFETY: After the `reserve` call, `scratch` has at least 4 bytes of
  // allocated but uninitialized memory after its last initialized byte, which
  // is where `ptr` points. All reachable match arms write `encoded_len` bytes
  // to that region and update the length accordingly, and `encoded_len` is
  // always <= 4.
  unsafe {
    let ptr = scratch.as_mut_ptr().add(scratch.len());

    let encoded_len = match n {
      0..=0x7F => unreachable!(),
      0x80..=0x7FF => {
        ptr.write(((n >> 6) & 0b0001_1111) as u8 | 0b1100_0000);
        2
      }
      0x800..=0xFFFF => {
        ptr.write(((n >> 12) & 0b0000_1111) as u8 | 0b1110_0000);
        ptr.add(1)
          .write(((n >> 6) & 0b0011_1111) as u8 | 0b1000_0000);
        3
      }
      0x1_0000..=0x10_FFFF => {
        ptr.write(((n >> 18) & 0b0000_0111) as u8 | 0b1111_0000);
        ptr.add(1)
          .write(((n >> 12) & 0b0011_1111) as u8 | 0b1000_0000);
        ptr.add(2)
          .write(((n >> 6) & 0b0011_1111) as u8 | 0b1000_0000);
        4
      }
      0x11_0000.. => unreachable!(),
    };
    ptr.add(encoded_len - 1)
      .write((n & 0b0011_1111) as u8 | 0b1000_0000);

    scratch.set_len(scratch.len() + encoded_len);
  }
}

const fn decode_hex_val_slow(val: u8) -> Option<u8>{
  match val{
    b'0'..=b'9' => Some(val - b'0'),
    b'A'..=b'F' => Some(val - b'A' + 10),
    b'a'..=b'f' => Some(val - b'a' + 10),
    _ => None,
  }
}

const fn build_hex_table(shift: usize) -> [i16; 256]{
  let mut table = [0; 256];
  let mut ch = 0;
  while ch < 256{
    table[ch] = match decode_hex_val_slow(ch as u8){
      Some(val) => (val as i16) << shift,
      None => -1,
    };
    ch += 1;
  }
  table
}

static HEX0: [i16; 256] = build_hex_table(0);
static HEX1: [i16; 256] = build_hex_table(4);

fn decode_four_hex_digits(a: u8, b: u8, c: u8, d: u8) -> Option<u16>{
  let a = HEX1[a as usize] as i32;
  let b = HEX0[b as usize] as i32;
  let c = HEX1[c as usize] as i32;
  let d = HEX0[d as usize] as i32;

  let codepoint = ((a | b) << 8) | c | d;

  // A single sign bit check.
  if codepoint >= 0 {
    Some(codepoint as u16)
  }else{
    None
  }
}

static POW10: [f64; 309] = [
  1e000, 1e001, 1e002, 1e003, 1e004, 1e005, 1e006, 1e007, 1e008, 1e009, //
  1e010, 1e011, 1e012, 1e013, 1e014, 1e015, 1e016, 1e017, 1e018, 1e019, //
  1e020, 1e021, 1e022, 1e023, 1e024, 1e025, 1e026, 1e027, 1e028, 1e029, //
  1e030, 1e031, 1e032, 1e033, 1e034, 1e035, 1e036, 1e037, 1e038, 1e039, //
  1e040, 1e041, 1e042, 1e043, 1e044, 1e045, 1e046, 1e047, 1e048, 1e049, //
  1e050, 1e051, 1e052, 1e053, 1e054, 1e055, 1e056, 1e057, 1e058, 1e059, //
  1e060, 1e061, 1e062, 1e063, 1e064, 1e065, 1e066, 1e067, 1e068, 1e069, //
  1e070, 1e071, 1e072, 1e073, 1e074, 1e075, 1e076, 1e077, 1e078, 1e079, //
  1e080, 1e081, 1e082, 1e083, 1e084, 1e085, 1e086, 1e087, 1e088, 1e089, //
  1e090, 1e091, 1e092, 1e093, 1e094, 1e095, 1e096, 1e097, 1e098, 1e099, //
  1e100, 1e101, 1e102, 1e103, 1e104, 1e105, 1e106, 1e107, 1e108, 1e109, //
  1e110, 1e111, 1e112, 1e113, 1e114, 1e115, 1e116, 1e117, 1e118, 1e119, //
  1e120, 1e121, 1e122, 1e123, 1e124, 1e125, 1e126, 1e127, 1e128, 1e129, //
  1e130, 1e131, 1e132, 1e133, 1e134, 1e135, 1e136, 1e137, 1e138, 1e139, //
  1e140, 1e141, 1e142, 1e143, 1e144, 1e145, 1e146, 1e147, 1e148, 1e149, //
  1e150, 1e151, 1e152, 1e153, 1e154, 1e155, 1e156, 1e157, 1e158, 1e159, //
  1e160, 1e161, 1e162, 1e163, 1e164, 1e165, 1e166, 1e167, 1e168, 1e169, //
  1e170, 1e171, 1e172, 1e173, 1e174, 1e175, 1e176, 1e177, 1e178, 1e179, //
  1e180, 1e181, 1e182, 1e183, 1e184, 1e185, 1e186, 1e187, 1e188, 1e189, //
  1e190, 1e191, 1e192, 1e193, 1e194, 1e195, 1e196, 1e197, 1e198, 1e199, //
  1e200, 1e201, 1e202, 1e203, 1e204, 1e205, 1e206, 1e207, 1e208, 1e209, //
  1e210, 1e211, 1e212, 1e213, 1e214, 1e215, 1e216, 1e217, 1e218, 1e219, //
  1e220, 1e221, 1e222, 1e223, 1e224, 1e225, 1e226, 1e227, 1e228, 1e229, //
  1e230, 1e231, 1e232, 1e233, 1e234, 1e235, 1e236, 1e237, 1e238, 1e239, //
  1e240, 1e241, 1e242, 1e243, 1e244, 1e245, 1e246, 1e247, 1e248, 1e249, //
  1e250, 1e251, 1e252, 1e253, 1e254, 1e255, 1e256, 1e257, 1e258, 1e259, //
  1e260, 1e261, 1e262, 1e263, 1e264, 1e265, 1e266, 1e267, 1e268, 1e269, //
  1e270, 1e271, 1e272, 1e273, 1e274, 1e275, 1e276, 1e277, 1e278, 1e279, //
  1e280, 1e281, 1e282, 1e283, 1e284, 1e285, 1e286, 1e287, 1e288, 1e289, //
  1e290, 1e291, 1e292, 1e293, 1e294, 1e295, 1e296, 1e297, 1e298, 1e299, //
  1e300, 1e301, 1e302, 1e303, 1e304, 1e305, 1e306, 1e307, 1e308,
];

enum ParserNumber{
  F64(f64),
  U64(u64),
  I64(i64),
}

impl ParserNumber{
  fn visit<'de, V>(self, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    match self {
      ParserNumber::F64(x) => visitor.visit_f64(x),
      ParserNumber::U64(x) => visitor.visit_u64(x),
      ParserNumber::I64(x) => visitor.visit_i64(x),
    }
  }

  fn invalid_type(self, exp: &dyn Expected) -> Error{
    match self {
      ParserNumber::F64(x) => de::Error::invalid_type(Unexpected::Float(x), exp),
      ParserNumber::U64(x) => de::Error::invalid_type(Unexpected::Unsigned(x), exp),
      ParserNumber::I64(x) => de::Error::invalid_type(Unexpected::Signed(x), exp),
    }
  }
}

macro_rules! overflow{
  ($a:ident * 10 + $b:ident, $c:expr) => {
    match $c{
      c => $a >= c / 10 && ($a > c / 10 || $b > c % 10),
    }
  };
}

/// parse number
impl<'a> Deserializer<'a>{
  fn parse_integer(&mut self, positive: bool) -> Result<ParserNumber, Error>{
    match self.expect_next()?{
      b'0' => {
        // There can be only one leading '0'.
        match self.expect_peek()?{
          b'0'..=b'9' => Err(self.peek_error(ErrorCode::InvalidNumber)),
          _ => self.parse_number(positive, 0),
        }
      }
      c @ b'1'..=b'9' => {
        let mut significand = (c - b'0') as u64;

        loop{
          match self.expect_peek()?{
            c @ b'0'..=b'9' => {
              let digit = (c - b'0') as u64;

              // We need to be careful with overflow. If we can,
              // try to keep the number as a `u64` until we grow
              // too large. At that point, switch to parsing the
              // value as a `f64`.
              if overflow!(significand * 10 + digit, u64::MAX) {
                return Ok(ParserNumber::F64(self.parse_long_integer(positive, significand)?));
              }

              self.discard();
              significand = significand * 10 + digit;
            }
            _ => {
              return self.parse_number(positive, significand);
            }
          }
        }
      }
      _ => Err(self.error(ErrorCode::InvalidNumber)),
    }
  }

  fn parse_number(&mut self, positive: bool, significand: u64) -> Result<ParserNumber, Error>{
    // self.expect_next()?
    match self.expect_peek()?{
      b'.' => Ok(ParserNumber::F64(self.parse_decimal(positive, significand, 0)?)),
      b'e' | b'E' => Ok(ParserNumber::F64(self.parse_exponent(positive, significand, 0)?)),
      _ => {
        if positive {
          Ok(ParserNumber::U64(significand))
        } else {
          let neg = (significand as i64).wrapping_neg();

          // Convert into a float if we underflow, or on `-0`.
          if neg >= 0 {
            Ok(ParserNumber::F64(-(significand as f64)))
          }else{
            Ok(ParserNumber::I64(neg))
          }
        }
      }
    }
  }

  fn parse_decimal(&mut self, positive: bool, mut significand: u64, exponent_before_decimal_point: i32) -> Result<f64, Error>{
    self.discard();

    let mut exponent_after_decimal_point = 0;
    while let c @ b'0'..=b'9' = self.expect_peek()?{
      let digit = (c - b'0') as u64;

      if overflow!(significand * 10 + digit, u64::MAX) {
        let exponent = exponent_before_decimal_point + exponent_after_decimal_point;
        return self.parse_decimal_overflow(positive, significand, exponent);
      }

      self.discard();
      significand = significand * 10 + digit;
      exponent_after_decimal_point -= 1;
    }

    // Error if there is not at least one digit after the decimal point.
    if exponent_after_decimal_point == 0 {
      return match self.peek(){
        Some(_) => Err(self.peek_error(ErrorCode::InvalidNumber)),
        None => Err(self.peek_error(ErrorCode::EofWhileParsingValue)),
      }
    }

    let exponent = exponent_before_decimal_point + exponent_after_decimal_point;
    match self.expect_peek()?{
      b'e' | b'E' => self.parse_exponent(positive, significand, exponent),
      _ => self.f64_from_parts(positive, significand, exponent),
    }
  }

  fn parse_exponent(&mut self, positive: bool, significand: u64, starting_exp: i32) -> Result<f64, Error>{
    self.discard();

    let positive_exp = match self.expect_peek()?{
      b'+' => {
        self.discard();
        true
      }
      b'-' => {
        self.discard();
        false
      }
      _ => true,
    };

    // Make sure a digit follows the exponent place.
    let mut exp = match self.expect_next()?{
      c @ b'0'..=b'9' => (c - b'0') as i32,
      _ => {
        return Err(self.error(ErrorCode::InvalidNumber));
      }
    };

    while let c @ b'0'..=b'9' = self.expect_peek()?{
      self.discard();
      let digit = (c - b'0') as i32;

      if overflow!(exp * 10 + digit, i32::MAX) {
        let zero_significand = significand == 0;
        return self.parse_exponent_overflow(positive, zero_significand, positive_exp);
      }

      exp = exp * 10 + digit;
    }

    let final_exp = if positive_exp {
      starting_exp.saturating_add(exp)
    } else {
      starting_exp.saturating_sub(exp)
    };

    self.f64_from_parts(positive, significand, final_exp)
  }

  fn f64_from_parts(&mut self, positive: bool, significand: u64, mut exponent: i32) -> Result<f64, Error>{
    let mut f = significand as f64;
    loop {
      match POW10.get(exponent.wrapping_abs() as usize) {
        Some(&pow) => {
          if exponent >= 0 {
            f *= pow;
            if f.is_infinite() {
              return Err(self.error(ErrorCode::NumberOutOfRange));
            }
          } else {
            f /= pow;
          }
          break;
        }
        None => {
          if f == 0.0 {
            break;
          }
          if exponent >= 0 {
            return Err(self.error(ErrorCode::NumberOutOfRange));
          }
          f /= 1e308;
          exponent += 308;
        }
      }
    }
    Ok(if positive { f } else { -f })
  }


  #[cold]
  #[inline(never)]
  fn parse_long_integer(&mut self, positive: bool, significand: u64) -> Result<f64, Error>{
    let mut exponent = 0;
    loop {
      match self.expect_peek()?{
        b'0'..=b'9' => {
          self.discard();
          // This could overflow... if your integer is gigabytes long.
          // Ignore that possibility.
          exponent += 1;
        }
        b'.' => {
          return self.parse_decimal(positive, significand, exponent);
        }
        b'e' | b'E' => {
          return self.parse_exponent(positive, significand, exponent);
        }
        _ => {
          return self.f64_from_parts(positive, significand, exponent);
        }
      }
    }
  }

  #[cold]
  #[inline(never)]
  fn parse_decimal_overflow(&mut self, positive: bool, significand: u64, exponent: i32) -> Result<f64, Error>{
    // The next multiply/add would overflow, so just ignore all further
    // digits.
    while let b'0'..=b'9' = self.expect_peek()?{
      self.discard();
    }

    match self.expect_peek()?{
      b'e' | b'E' => self.parse_exponent(positive, significand, exponent),
      _ => self.f64_from_parts(positive, significand, exponent),
    }
  }

  // This cold code should not be inlined into the middle of the hot
  // exponent-parsing loop above.
  #[cold]
  #[inline(never)]
  fn parse_exponent_overflow(&mut self, positive: bool, zero_significand: bool, positive_exp: bool) -> Result<f64, Error>{
    // Error instead of +/- infinity.
    if !zero_significand && positive_exp {
      return Err(self.error(ErrorCode::NumberOutOfRange));
    }

    while let b'0'..=b'9' = self.expect_peek()?{
      self.discard();
    }
    Ok(if positive { 0.0 } else { -0.0 })
  }

  fn parse_any_signed_number(&mut self) -> Result<ParserNumber, Error>{
    let value = match self.expect_peek()?{
      b'-' => {
        self.discard();
        self.parse_any_number(false)
      }
      b'0'..=b'9' => self.parse_any_number(true),
      _ => Err(self.peek_error(ErrorCode::InvalidNumber)),
    };

    match self.peek(){
      Some(_) => Err(self.peek_error(ErrorCode::InvalidNumber)),
      None => value,
    }
  }

  fn parse_any_number(&mut self, positive: bool) -> Result<ParserNumber, Error>{
    self.parse_integer(positive)
  }
}


fn as_str<'de, 's>(de: &Deserializer<'de>, slice: &'s [u8]) -> Result<&'s str, Error>{
  str::from_utf8(slice).or_else(|_| Err(de.error(ErrorCode::InvalidUnicodeCodePoint)))
}

fn is_escape(ch: u8, including_control_characters: bool) -> bool{
  ch == b'"' || ch == b'\\' || (including_control_characters && ch < 0x20)
}


enum Reference<'b, 'c, T>
where
  T: ?Sized + 'static,
{
  Borrowed(&'b T),
  Copied(&'c T),
}

impl<'b, 'c, T> Deref for Reference<'b, 'c, T>
where
  T: ?Sized + 'static,
{
  type Target = T;

  fn deref(&self) -> &Self::Target {
    match *self {
      Reference::Borrowed(b) => b,
      Reference::Copied(c) => c,
    }
  }
}

/// parse string
impl<'a> Deserializer<'a>{
  #[cold]
  #[inline(never)]
  fn skip_to_escape_slow(&mut self){
    while self.index < self.input.len() && !is_escape(self.input[self.index], true){
      self.index += 1;
    }
  }

  fn skip_to_escape(&mut self, forbid_control_characters: bool){
    // Immediately bail-out on empty strings and consecutive escapes (e.g. \u041b\u0435)
    if self.index == self.input.len() || is_escape(self.input[self.index], forbid_control_characters) {
      return;
    }
    self.index += 1;

    let rest = &self.input[self.index..];

    if !forbid_control_characters {
      self.index += memchr::memchr2(b'"', b'\\', rest).unwrap_or(rest.len());
      return;
    }

    // We wish to find the first byte in range 0x00..=0x1F or " or \. Ideally, we'd use
    // something akin to memchr3, but the memchr crate does not support this at the moment.
    // Therefore, we use a variation on Mycroft's algorithm [1] to provide performance better
    // than a naive loop. It runs faster than equivalent two-pass memchr2+SWAR code on
    // benchmarks and it's cross-platform, so probably the right fit.
    // [1]: https://groups.google.com/forum/#!original/comp.lang.c/2HtQXvg7iKc/xOJeipH6KLMJ

    type Chunk = u64;

    const STEP: usize = size_of::<Chunk>();
    const ONE_BYTES: Chunk = Chunk::MAX / 255; // 0x0101...01

    for chunk in rest.chunks_exact(STEP) {
      let chars = Chunk::from_le_bytes(chunk.try_into().unwrap());
      let contains_ctrl = chars.wrapping_sub(ONE_BYTES * 0x20) & !chars;
      let chars_quote = chars ^ (ONE_BYTES * Chunk::from(b'"'));
      let contains_quote = chars_quote.wrapping_sub(ONE_BYTES) & !chars_quote;
      let chars_backslash = chars ^ (ONE_BYTES * Chunk::from(b'\\'));
      let contains_backslash = chars_backslash.wrapping_sub(ONE_BYTES) & !chars_backslash;
      let masked = (contains_ctrl | contains_quote | contains_backslash) & (ONE_BYTES << 7);
      if masked != 0 {
        // SAFETY: chunk is in-bounds for slice
        self.index = unsafe { chunk.as_ptr().offset_from(self.input.as_ptr()) } as usize
          + masked.trailing_zeros() as usize / 8;
        return;
      }
    }

    self.index += rest.len() / STEP * STEP;
    self.skip_to_escape_slow();
  }


  fn parse_escape<'de>(&mut self, validate: bool) -> Result<(), Error>{
    match self.expect_peek()?{
      b'"' => self.scratch.push(b'"'),
      b'\\' => self.scratch.push(b'\\'),
      b'/' => self.scratch.push(b'/'),
      b'b' => self.scratch.push(b'\x08'),
      b'f' => self.scratch.push(b'\x0c'),
      b'n' => self.scratch.push(b'\n'),
      b'r' => self.scratch.push(b'\r'),
      b't' => self.scratch.push(b'\t'),
      b'u' => return self.parse_unicode_escape(validate),
      _ => return Err(self.error(ErrorCode::InvalidEscape)),
    }

    Ok(())
  }

  #[cold]
  fn parse_unicode_escape<'de>(&mut self, validate: bool) -> Result<(), Error>{
    let mut n = self.decode_hex_escape()?;

    // Non-BMP characters are encoded as a sequence of two hex escapes,
    // representing UTF-16 surrogates. If deserializing a utf-8 string the
    // surrogates are required to be paired, whereas deserializing a byte string
    // accepts lone surrogates.
    if validate && n >= 0xDC00 && n <= 0xDFFF {
      // XXX: This is actually a trailing surrogate.
      return Err(self.error(ErrorCode::LoneLeadingSurrogateInHexEscape));
    }

    loop {
      if n < 0xD800 || n > 0xDBFF {
        // Every u16 outside of the surrogate ranges is guaranteed to be a
        // legal char.
        push_wtf8_codepoint(n as u32, &mut self.scratch);
        return Ok(());
      }

      // n is a leading surrogate, we now expect a trailing surrogate.
      let n1 = n;

      if self.expect_peek()? == b'\\' {
        self.discard();
      } else {
        return if validate {
          self.discard();
          Err(self.error(ErrorCode::UnexpectedEndOfHexEscape))
        }else{
          push_wtf8_codepoint(n1 as u32, &mut self.scratch);
          Ok(())
        };
      }

      if self.expect_peek()? == b'u' {
        self.discard();
      }else{
        return if validate {
          self.discard();
          Err(self.error(ErrorCode::UnexpectedEndOfHexEscape))
        }else{
          push_wtf8_codepoint(n1 as u32, &mut self.scratch);
          // The \ prior to this byte started an escape sequence, so we
          // need to parse that now. This recursive call does not blow the
          // stack on malicious input because the escape is not \u, so it
          // will be handled by one of the easy nonrecursive cases.
          self.parse_escape(validate)
        };
      }

      let n2 = self.decode_hex_escape()?;

      if n2 < 0xDC00 || n2 > 0xDFFF {
        if validate {
          return Err(self.error(ErrorCode::LoneLeadingSurrogateInHexEscape))
        }
        push_wtf8_codepoint(n1 as u32, &mut self.scratch);
        // If n2 is a leading surrogate, we need to restart.
        n = n2;
        continue;
      }

      // This value is in range U+10000..=U+10FFFF, which is always a valid
      // codepoint.
      let n = ((((n1 - 0xD800) as u32) << 10) | (n2 - 0xDC00) as u32) + 0x1_0000;
      push_wtf8_codepoint(n, &mut self.scratch);
      return Ok(());
    }
  }

  #[inline]
  fn decode_hex_escape(&mut self) -> Result<u16, Error>{
    match self.input[self.index..]{
      [a, b, c, d, ..] => {
        self.index += 4;
        match decode_four_hex_digits(a, b, c, d) {
          Some(val) => Ok(val),
          None => Err(self.error(ErrorCode::InvalidEscape)),
        }
      }
      _ => {
        self.index = self.input.len();
        Err(self.error(ErrorCode::EofWhileParsingString))
      }
    }
  }

  /// The big optimization here over IoRead is that if the string contains no
  /// backslash escape sequences, the returned &str is a slice of the raw JSON
  /// data so we avoid copying into the scratch space.
  fn parse_str_bytes<'s, T, F>(&'s mut self, validate: bool, result: F) -> Result<Reference<'a, 's, T>, Error>
  where
    T: ?Sized + 's,
    F: for<'f> FnOnce(&'s Self, &'f [u8]) -> Result<&'f T, Error>,
  {
    // Index of the first byte not yet copied into the scratch space.
    let mut start = self.index;

    loop{
      self.skip_to_escape(validate);
      if self.index == self.input.len() {
        return Err(self.error(ErrorCode::EofWhileParsingString))
      }
      match self.input[self.index]{
        b'"' => {
          // let borrowed = &self.input[start..self.index];
          // self.index += 1;
          // return self.as_str(borrowed).map(Reference::Borrowed)

          return if self.scratch.is_empty() {
            // Fast path: return a slice of the raw JSON without any
            // copying.
            let borrowed = &self.input[start..self.index];
            self.index += 1;
            result(self, borrowed).map(Reference::Borrowed)
          }else{
            self.scratch.extend_from_slice(&self.input[start..self.index]);
            self.index += 1;
            result(self, &*self.scratch).map(Reference::Copied)
          }
        }
        b'\\' => {
          self.scratch.extend_from_slice(&self.input[start..self.index]);
          self.index += 1;
          self.parse_escape(validate)?;
          start = self.index;
        }
        _ => {
          self.index += 1;
          return Err(self.error(ErrorCode::ControlCharacterWhileParsingString));
        }
      }
    }
  }

  fn parse_str_raw<'s>(&'s mut self,) -> Result<Reference<'a, 's, [u8]>, Error>{
    self.parse_str_bytes(false, |_, bytes| Ok(bytes))
  }

  fn parse_str<'s>(&'s mut self) -> Result<Reference<'a, 's, str>, Error>{
    self.parse_str_bytes(true, as_str)
  }
}

/// parse compound
impl<'a> Deserializer<'a>{
  fn parse_object_colon(&mut self) -> Result<(), Error>{
    match self.parse_whitespace(){
      Some(b':') => {
        self.discard();
        Ok(())
      }
      Some(_) => Err(self.peek_error(ErrorCode::ExpectedColon)),
      None => Err(self.peek_error(ErrorCode::EofWhileParsingObject)),
    }
  }

  fn parse_id_map_colon(&mut self) -> Result<(), Error>{
    self.parse_object_colon()
  }

  fn end_array(&mut self) -> Result<(), Error>{
    match self.parse_whitespace(){
      Some(b']') => {
        self.discard();
        Ok(())
      }
      Some(b',') => {
        self.discard();
        match self.parse_whitespace(){
          Some(b']') => Err(self.peek_error(ErrorCode::TrailingComma)),
          _ => Err(self.peek_error(ErrorCode::TrailingCharacters)),
        }
      }
      Some(_) => Err(self.peek_error(ErrorCode::TrailingCharacters)),
      None => Err(self.peek_error(ErrorCode::EofWhileParsingArray)),
    }
  }

  fn end_object(&mut self) -> Result<(), Error>{
    match self.parse_whitespace(){
      Some(b'}') => {
        self.discard();
        Ok(())
      }
      Some(b',') => Err(self.peek_error(ErrorCode::TrailingComma)),
      Some(_) => Err(self.peek_error(ErrorCode::TrailingCharacters)),
      None => Err(self.peek_error(ErrorCode::EofWhileParsingObject)),
    }
  }

  fn end_id_map(&mut self) -> Result<(), Error>{
    match self.parse_whitespace(){
      Some(b']') => {
        self.discard();
        Ok(())
      }
      Some(b',') => {
        self.discard();
        match self.parse_whitespace(){
          Some(b']') => Err(self.peek_error(ErrorCode::TrailingComma)),
          _ => Err(self.peek_error(ErrorCode::TrailingCharacters)),
        }
      }
      Some(_) => Err(self.peek_error(ErrorCode::TrailingCharacters)),
      None => Err(self.peek_error(ErrorCode::EofWhileParsingIdMap)),
    }
  }
}

/// ignore
impl<'a> Deserializer<'a>{
  fn ignore_value(&mut self) -> Result<(), Error>{
    self.scratch.clear();
    let mut enclosing = None;

    loop{
      let frame = match self.expect_parse_whitespace()?{
        b'n' => {
          self.discard();
          self.parse_ident(b"ull")?;
          None
        }
        b't' => {
          self.discard();
          self.parse_ident(b"rue")?;
          None
        }
        b'f' => {
          self.discard();
          self.parse_ident(b"alse")?;
          None
        }
        b'-' => {
          self.discard();
          self.ignore_integer()?;
          None
        }
        b'0'..=b'9' => {
          self.ignore_integer()?;
          None
        }
        b'"' => {
          self.discard();
          self.ignore_str()?;
          None
        }
        frame @ (b'[' | b'{') => {
          self.scratch.extend(enclosing.take());
          self.discard();
          Some(frame)
        }
        _ => return Err(self.peek_error(ErrorCode::ExpectedSomeValue)),
      };

      let (mut accept_comma, mut frame) = match frame{
        Some(frame) => (false, frame),
        None => match enclosing.take(){
          Some(frame) => (true, frame),
          None => match self.scratch.pop(){
            Some(frame) => (true, frame),
            None => return Ok(()),
          },
        },
      };

      loop{
        match self.parse_whitespace(){
          Some(b',') if accept_comma => {
            self.discard();
            break;
          }
          Some(b']') if frame == b'[' => {}
          Some(b'}') if frame == b'{' => {}
          Some(_) => {
            if accept_comma {
              return Err(self.peek_error(match frame{
                b'[' => ErrorCode::ExpectedArrayCommaOrEnd,
                b'{' => ErrorCode::ExpectedObjectCommaOrEnd,
                _ => unreachable!(),
              }));
            }else{
              break;
            }
          }
          None => {
            return Err(self.peek_error(match frame{
              b'[' => ErrorCode::EofWhileParsingArray,
              b'{' => ErrorCode::EofWhileParsingObject,
              _ => unreachable!(),
            }));
          }
        }

        self.discard();
        frame = match self.scratch.pop(){
          Some(frame) => frame,
          None => return Ok(()),
        };
        accept_comma = true;
      }

      if frame == b'{' {
        match self.parse_whitespace(){
          Some(b'"') => self.discard(),
          Some(_) => return Err(self.peek_error(ErrorCode::KeyMustBeAString)),
          None => return Err(self.peek_error(ErrorCode::EofWhileParsingObject)),
        }
        self.ignore_str()?;
        match self.parse_whitespace(){
          Some(b':') => self.discard(),
          Some(_) => return Err(self.peek_error(ErrorCode::ExpectedColon)),
          None => return Err(self.peek_error(ErrorCode::EofWhileParsingObject)),
        }
      }

      enclosing = Some(frame);
    }
  }

  fn ignore_integer(&mut self) -> Result<(), Error>{
    match self.expect_next()?{
      b'0' => {
        // There can be only one leading '0'.
        if let b'0'..=b'9' = self.expect_peek()?{
          return Err(self.peek_error(ErrorCode::InvalidNumber));
        }
      }
      b'1'..=b'9' => {
        while let b'0'..=b'9' = self.expect_peek()?{
          self.discard();
        }
      }
      _ => {
        return Err(self.error(ErrorCode::InvalidNumber));
      }
    }

    match self.expect_peek()?{
      b'.' => self.ignore_decimal(),
      b'e' | b'E' => self.ignore_exponent(),
      _ => Ok(()),
    }
  }

  fn ignore_decimal(&mut self) -> Result<(), Error>{
    self.discard();

    let mut at_least_one_digit = false;
    while let b'0'..=b'9' = self.expect_peek()?{
      self.discard();
      at_least_one_digit = true;
    }

    if !at_least_one_digit {
      return Err(self.peek_error(ErrorCode::InvalidNumber));
    }

    match self.expect_peek()?{
      b'e' | b'E' => self.ignore_exponent(),
      _ => Ok(()),
    }
  }

  fn ignore_exponent(&mut self) -> Result<(), Error>{
    self.discard();

    match self.expect_peek()?{
      b'+' | b'-' => self.discard(),
      _ => {}
    }

    // Make sure a digit follows the exponent place.
    match self.expect_next()?{
      b'0'..=b'9' => {}
      _ => {
        return Err(self.error(ErrorCode::InvalidNumber));
      }
    }

    while let b'0'..=b'9' = self.expect_peek()?{
      self.discard();
    }

    Ok(())
  }

  fn ignore_str(&mut self) -> Result<(), Error>{
    loop {
      self.skip_to_escape(true);
      if self.index == self.input.len() {
        return Err(self.error(ErrorCode::EofWhileParsingString));
      }
      match self.input[self.index]{
        b'"' => {
          self.index += 1;
          return Ok(());
        }
        b'\\' => {
          self.index += 1;
          self.ignore_escape()?;
        }
        _ => {
          return Err(self.error(ErrorCode::ControlCharacterWhileParsingString));
        }
      }
    }
  }

  fn ignore_escape<'de>(&mut self) -> Result<(), Error>{
    let ch = self.expect_next()?;

    match ch{
      b'"' | b'\\' | b'/' | b'b' | b'f' | b'n' | b'r' | b't' => {}
      b'u' => {
        // At this point we don't care if the codepoint is valid. We just
        // want to consume it. We don't actually know what is valid or not
        // at this point, because that depends on if this string will
        // ultimately be parsed into a string or a byte buffer in the "real"
        // parse.

        self.decode_hex_escape()?;
      }
      _ => {
        return Err(self.error(ErrorCode::InvalidEscape));
      }
    }

    Ok(())
  }
}


macro_rules! deserialize_number{
  ($method:ident) => {
    deserialize_number!($method, deserialize_number);
  };

  ($method:ident, $using:ident) => {
    fn $method<V>(self, visitor: V) -> Result<V::Value, Error>
    where
      V: de::Visitor<'de>,
    {
      self.$using(visitor)
    }
  };
}

macro_rules! if_checking_recursion_limit{
  ($($body:tt)*) => {
    $($body)*
  };
}

macro_rules! check_recursion{
  (($this:ident .$field:ident) $($body:tt)*) => {
    if_checking_recursion_limit!{
      $this.$field.remaining_depth -= 1;
      if $this.$field.remaining_depth == 0 {
        return Err($this.$field.peek_error(ErrorCode::RecursionLimitExceeded));
      }
    }

    $this.$field $($body)*

    if_checking_recursion_limit!{
      $this.$field.remaining_depth += 1;
    }
  };
  ($this:ident $($body:tt)*) => {
    if_checking_recursion_limit!{
      $this.remaining_depth -= 1;
      if $this.remaining_depth == 0 {
        return Err($this.peek_error(ErrorCode::RecursionLimitExceeded));
      }
    }

    $this $($body)*

    if_checking_recursion_limit!{
      $this.remaining_depth += 1;
    }
  };
}

impl<'de> de::Deserializer<'de> for &mut Deserializer<'de>{
  type Error = Error;

  fn deserialize_any<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match self.expect_parse_whitespace()?{
      b'n' => {
        self.discard();
        self.parse_ident(b"ull")?;
        visitor.visit_unit()
      }
      b't' => {
        self.discard();
        self.parse_ident(b"rue")?;
        visitor.visit_bool(true)
      }
      b'f' => {
        self.discard();
        self.parse_ident(b"alse")?;
        visitor.visit_bool(false)
      }
      b'-' => {
        self.discard();
        self.parse_any_number(false)?.visit(visitor)
      }
      b'0'..=b'9' => self.parse_any_number(true)?.visit(visitor),
      b'"' => {
        self.discard();
        self.scratch.clear();
        match self.parse_str()?{
          Reference::Borrowed(s) => visitor.visit_borrowed_str(s),
          Reference::Copied(s) => visitor.visit_str(s),
        }
      }
      b'[' => {
        self.discard();
        match self.expect_peek()?{
          b':' => {
            check_recursion!{
              self.discard();
              let ret = visitor.visit_map(IdMapAccess::new(self));
            }

            match (ret, self.end_id_map()){
              (Ok(ret), Ok(())) => Ok(ret),
              (Err(err), _) | (_, Err(err)) => Err(err),
            }
          },
          _ => {
            check_recursion!{
              self.peek();
              let ret = visitor.visit_seq(SeqAccess::new(self));
            }

            match (ret, self.end_array()){
              (Ok(ret), Ok(())) => Ok(ret),
              (Err(err), _) | (_, Err(err)) => Err(err),
            }
          },
        }
      }
      b'{' => {
        check_recursion!{
          self.discard();
          let ret = visitor.visit_map(MapAccess::new(self));
        }

        match (ret, self.end_object()){
          (Ok(ret), Ok(())) => Ok(ret),
          (Err(err), _) | (_, Err(err)) => Err(err),
        }
      }
      _ => Err(self.peek_error(ErrorCode::ExpectedSomeValue)),
    }
  }

  fn deserialize_bool<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match self.expect_parse_whitespace()?{
      b't' => {
        self.discard();
        self.parse_ident(b"rue")?;
        visitor.visit_bool(true)
      }
      b'f' => {
        self.discard();
        self.parse_ident(b"alse")?;
        visitor.visit_bool(false)
      }
      _ => Err(self.peek_invalid_type(&visitor)),
    }
  }

  deserialize_number!(deserialize_i8);
  deserialize_number!(deserialize_i16);
  deserialize_number!(deserialize_i32);
  deserialize_number!(deserialize_i64);
  deserialize_number!(deserialize_i128, do_deserialize_i128);
  deserialize_number!(deserialize_u8);
  deserialize_number!(deserialize_u16);
  deserialize_number!(deserialize_u32);
  deserialize_number!(deserialize_u64);
  deserialize_number!(deserialize_u128, do_deserialize_u128);
  deserialize_number!(deserialize_f32);
  deserialize_number!(deserialize_f64);

  fn deserialize_char<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    self.deserialize_str(visitor)
  }

  fn deserialize_str<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match self.expect_parse_whitespace()?{
      b'"' => {
        self.discard();
        self.scratch.clear();
        match self.parse_str()?{
          Reference::Borrowed(s) => visitor.visit_borrowed_str(s),
          Reference::Copied(s) => visitor.visit_str(s),
        }
      }
      _ => Err(self.peek_invalid_type(&visitor)),
    }
  }

  fn deserialize_string<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    self.deserialize_str(visitor)
  }

  fn deserialize_bytes<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match self.expect_parse_whitespace()?{
      b'"' => {
        self.discard();
        self.scratch.clear();
        match self.parse_str_raw()?{
          Reference::Borrowed(b) => visitor.visit_borrowed_bytes(b),
          Reference::Copied(b) => visitor.visit_bytes(b),
        }
      }
      b'[' => self.deserialize_seq(visitor),
      _ => Err(self.peek_invalid_type(&visitor)),
    }
  }

  fn deserialize_byte_buf<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    self.deserialize_bytes(visitor)
  }

  fn deserialize_option<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match self.parse_whitespace(){
      Some(b'n') => {
        self.discard();
        self.parse_ident(b"ull")?;
        visitor.visit_none()
      }
      _ => visitor.visit_some(self),
    }
  }

  fn deserialize_unit<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match self.expect_parse_whitespace()?{
      b'n' => {
        self.discard();
        self.parse_ident(b"ull")?;
        visitor.visit_unit()
      }
      _ => Err(self.peek_invalid_type(&visitor)),
    }
  }

  fn deserialize_unit_struct<V>(self, name: &'static str, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    let _ = name;
    self.deserialize_unit(visitor)
  }

  fn deserialize_newtype_struct<V>(self, name: &'static str, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match name{
      ID_MAP_TOKEN => {
        visitor.visit_newtype_struct(IdMapDeserializer{de: self})
      },
      _ => {
        visitor.visit_newtype_struct(self)
      }
    }
  }

  fn deserialize_seq<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match self.expect_parse_whitespace()?{
      b'[' => {
        check_recursion!{
          self.discard();
          let ret = visitor.visit_seq(SeqAccess::new(self));
        }

        match (ret, self.end_array()){
          (Ok(ret), Ok(())) => Ok(ret),
          (Err(err), _) | (_, Err(err)) => Err(err),
        }
      }
      _ => Err(self.peek_invalid_type(&visitor)),
    }
  }

  fn deserialize_tuple<V>(self, len: usize, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    let _ = len;
    self.deserialize_seq(visitor)
  }

  fn deserialize_tuple_struct<V>(self, name: &'static str, len: usize, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    let _ = name;
    let _ = len;
    self.deserialize_seq(visitor)
  }

  fn deserialize_map<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match self.expect_parse_whitespace()?{
      b'{' => {
        check_recursion!{
          self.discard();
          let ret = visitor.visit_map(MapAccess::new(self));
        }

        match (ret, self.end_object()){
          (Ok(ret), Ok(())) => Ok(ret),
          (Err(err), _) | (_, Err(err)) => Err(err),
        }
      }
      _ => Err(self.peek_invalid_type(&visitor)),
    }
  }

  fn deserialize_struct<V>(self, name: &'static str, fields: &'static [&'static str], visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    let _ = name;
    let _ = fields;

    match self.expect_parse_whitespace()?{
      b'[' => {
        check_recursion!{
          self.discard();
          let ret = visitor.visit_seq(SeqAccess::new(self));
        }

        match (ret, self.end_array()){
          (Ok(ret), Ok(())) => Ok(ret),
          (Err(err), _) | (_, Err(err)) => Err(err),
        }
      }
      b'{' => {
        check_recursion! {
          self.discard();
          let ret = visitor.visit_map(MapAccess::new(self));
        }

        match (ret, self.end_object()){
          (Ok(ret), Ok(())) => Ok(ret),
          (Err(err), _) | (_, Err(err)) => Err(err),
        }
      }
      _ => Err(self.peek_invalid_type(&visitor)),
    }
  }

  fn deserialize_enum<V>(self, name: &'static str, variants: &'static [&'static str], visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    let _ = name;
    let _ = variants;

    match self.expect_parse_whitespace()?{
      b'{' => {
        check_recursion!{
          self.discard();
          let ret = visitor.visit_enum(VariantAccess::new(self));
        }
        let value = ret?;

        match self.parse_whitespace(){
          Some(b'}') => {
            self.discard();
            Ok(value)
          }
          Some(_) => Err(self.error(ErrorCode::ExpectedSomeValue)),
          None => Err(self.error(ErrorCode::EofWhileParsingObject)),
        }
      }
      b'"' => visitor.visit_enum(UnitVariantAccess::new(self)),
      _ => Err(self.peek_error(ErrorCode::ExpectedSomeValue)),
    }
  }

  fn deserialize_identifier<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    self.deserialize_str(visitor)
  }

  fn deserialize_ignored_any<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    self.ignore_value()?;
    visitor.visit_unit()
  }
}



struct SeqAccess<'de, 'a>{
  de: &'a mut Deserializer<'de>,
  first: bool,
}

impl<'de, 'a> SeqAccess<'de, 'a>{
  fn new(de: &'a mut Deserializer<'de>) -> Self{
    SeqAccess { de, first: true }
  }
}

impl<'de, 'a> de::SeqAccess<'de> for SeqAccess<'de, 'a>{
  type Error = Error;

  fn next_element_seed<T>(&mut self, seed: T) -> Result<Option<T::Value>, Error>
  where
    T: de::DeserializeSeed<'de>,
  {
    fn has_next_element(seq: &mut SeqAccess) -> Result<bool, Error>{
      let peek = match seq.de.parse_whitespace(){
        Some(b) => b,
        None => {
          return Err(seq.de.peek_error(ErrorCode::EofWhileParsingArray));
        }
      };

      if peek == b']' {
        Ok(false)
      }else if seq.first{
        seq.first = false;
        Ok(true)
      }else if peek == b','{
        seq.de.discard();
        match seq.de.parse_whitespace(){
          Some(b']') => Err(seq.de.peek_error(ErrorCode::TrailingComma)),
          Some(_) => Ok(true),
          None => Err(seq.de.peek_error(ErrorCode::EofWhileParsingValue)),
        }
      } else {
        Err(seq.de.peek_error(ErrorCode::ExpectedArrayCommaOrEnd))
      }
    }

    if has_next_element(self)?{
      Ok(Some(seed.deserialize(&mut *self.de)?))
    } else {
      Ok(None)
    }
  }
}



struct MapAccess<'de, 'a>{
  de: &'a mut Deserializer<'de>,
  first: bool,
}

impl<'de, 'a> MapAccess<'de, 'a>{
  fn new(de: &'a mut Deserializer<'de>) -> Self{
    MapAccess{de, first: true}
  }
}

impl<'de, 'a> de::MapAccess<'de> for MapAccess<'de, 'a>{
  type Error = Error;

  fn next_key_seed<K>(&mut self, seed: K) -> Result<Option<K::Value>, Error>
  where
    K: de::DeserializeSeed<'de>,
  {
    fn has_next_key(map: &mut MapAccess) -> Result<bool, Error>{
      let peek = match map.de.parse_whitespace(){
        Some(b) => b,
        None => {
          return Err(map.de.peek_error(ErrorCode::EofWhileParsingObject));
        }
      };

      if peek == b'}' {
        Ok(false)
      }else if map.first{
        map.first = false;
        if peek == b'"' {
          Ok(true)
        }else{
          Err(map.de.peek_error(ErrorCode::KeyMustBeAString))
        }
      } else if peek == b',' {
        map.de.discard();
        match map.de.parse_whitespace(){
          Some(b'"') => Ok(true),
          Some(b'}') => Err(map.de.peek_error(ErrorCode::TrailingComma)),
          Some(_) => Err(map.de.peek_error(ErrorCode::KeyMustBeAString)),
          None => Err(map.de.peek_error(ErrorCode::EofWhileParsingValue)),
        }
      }else{
        Err(map.de.peek_error(ErrorCode::ExpectedObjectCommaOrEnd))
      }
    }

    if has_next_key(self)? {
      Ok(Some(seed.deserialize(MapKeyDeserializer{de: &mut *self.de})?))
    }else{
      Ok(None)
    }
  }

  fn next_value_seed<V>(&mut self, seed: V) -> Result<V::Value, Error>
  where
    V: de::DeserializeSeed<'de>,
  {
    self.de.parse_object_colon()?;

    seed.deserialize(&mut *self.de)
  }
}


struct IdMapAccess<'de, 'a>{
  de: &'a mut Deserializer<'de>,
  first: bool,
}

impl<'de, 'a> IdMapAccess<'de, 'a>{
  fn new(de: &'a mut Deserializer<'de>) -> Self{
    IdMapAccess{de, first: true}
  }
}

impl<'de, 'a> de::MapAccess<'de> for IdMapAccess<'de, 'a>{
  type Error = Error;

  fn next_key_seed<K>(&mut self, seed: K) -> Result<Option<K::Value>, Error>
  where
    K: de::DeserializeSeed<'de>,
  {
    fn has_next_key(map: &mut IdMapAccess) -> Result<bool, Error>{
      let peek = match map.de.parse_whitespace(){
        Some(b) => b,
        None => {
          return Err(map.de.peek_error(ErrorCode::EofWhileParsingIdMap));
        }
      };

      if peek == b']' {
        Ok(false)
      }else if map.first{
        map.first = false;
        Ok(true)
      }else if peek == b',' {
        map.de.discard();
        match map.de.parse_whitespace(){
          Some(b']') => Err(map.de.peek_error(ErrorCode::TrailingComma)),
          Some(_) => Ok(true),
          None => Err(map.de.peek_error(ErrorCode::EofWhileParsingValue)),
        }
      }else{
        Err(map.de.peek_error(ErrorCode::ExpectedObjectCommaOrEnd))
      }
    }

    if has_next_key(self)? {
      Ok(Some(seed.deserialize(&mut *self.de)?))
    }else{
      Ok(None)
    }
  }

  fn next_value_seed<V>(&mut self, seed: V) -> Result<V::Value, Error>
  where
    V: de::DeserializeSeed<'de>,
  {
    self.de.parse_id_map_colon()?;

    seed.deserialize(&mut *self.de)
  }
}

struct VariantAccess<'de, 'a>{
  de: &'a mut Deserializer<'de>,
}

impl<'de, 'a> VariantAccess<'de, 'a>{
  fn new(de: &'a mut Deserializer<'de>) -> Self{
    VariantAccess{de}
  }
}

impl<'de, 'a> de::EnumAccess<'de> for VariantAccess<'de, 'a>{
  type Error = Error;
  type Variant = Self;

  fn variant_seed<V>(self, seed: V) -> Result<(V::Value, Self), Error>
  where
    V: de::DeserializeSeed<'de>,
  {
    let val = seed.deserialize(&mut *self.de)?;
    self.de.parse_object_colon()?;
    Ok((val, self))
  }
}

impl<'de, 'a> de::VariantAccess<'de> for VariantAccess<'de, 'a>{
  type Error = Error;

  fn unit_variant(self) -> Result<(), Error>{
    de::Deserialize::deserialize(self.de)
  }

  fn newtype_variant_seed<T>(self, seed: T) -> Result<T::Value, Error>
  where
    T: de::DeserializeSeed<'de>
  {
    seed.deserialize(self.de)
  }

  fn tuple_variant<V>(self, _len: usize, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>
  {
    de::Deserializer::deserialize_seq(self.de, visitor)
  }

  fn struct_variant<V>(self, fields: &'static [&'static str], visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    de::Deserializer::deserialize_struct(self.de, "", fields, visitor)
  }
}

struct UnitVariantAccess<'de, 'a>{
  de: &'a mut Deserializer<'de>,
}

impl<'de, 'a> UnitVariantAccess<'de, 'a>{
  fn new(de: &'a mut Deserializer<'de>) -> Self{
    UnitVariantAccess{de}
  }
}

impl<'de, 'a> de::EnumAccess<'de> for UnitVariantAccess<'de, 'a>{
  type Error = Error;
  type Variant = Self;

  fn variant_seed<V>(self, seed: V) -> Result<(V::Value, Self), Error>
  where
    V: de::DeserializeSeed<'de>,
  {
    let variant = seed.deserialize(&mut *self.de)?;
    Ok((variant, self))
  }
}

impl<'de, 'a> de::VariantAccess<'de> for UnitVariantAccess<'de, 'a>{
  type Error = Error;

  fn unit_variant(self) -> Result<(), Error>{
    Ok(())
  }

  fn newtype_variant_seed<T>(self, _seed: T) -> Result<T::Value, Error>
  where
    T: de::DeserializeSeed<'de>,
  {
    Err(de::Error::invalid_type(
      Unexpected::UnitVariant,
      &"newtype variant",
    ))
  }

  fn tuple_variant<V>(self, _len: usize, _visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    Err(de::Error::invalid_type(
      Unexpected::UnitVariant,
      &"tuple variant",
    ))
  }

  fn struct_variant<V>(self, _fields: &'static [&'static str], _visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    Err(de::Error::invalid_type(
      Unexpected::UnitVariant,
      &"struct variant",
    ))
  }
}




/// Only deserialize from this after peeking a '"' byte! Otherwise it may
/// deserialize invalid JSON successfully.
struct MapKeyDeserializer<'de, 'a>{
  de: &'a mut Deserializer<'de>,
}

macro_rules! deserialize_numeric_key{
  ($method:ident) => {
    fn $method<V>(self, visitor: V) -> Result<V::Value, Error>
    where
      V: de::Visitor<'de>,
    {
      self.deserialize_number(visitor)
    }
  };

  ($method:ident, $delegate:ident) => {
    fn $method<V>(self, visitor: V) -> Result<V::Value, Error>
    where
      V: de::Visitor<'de>,
    {
      self.de.discard();

      match self.de.peek(){
        Some(b'0'..=b'9' | b'-') => {}
        _ => return Err(self.de.error(ErrorCode::ExpectedNumericKey)),
      }

      let value = self.de.$delegate(visitor)?;

      match self.de.peek(){
        Some(b'"') => self.de.discard(),
        _ => return Err(self.de.peek_error(ErrorCode::ExpectedDoubleQuote)),
      }

      Ok(value)
    }
  };
}
impl<'de, 'a> MapKeyDeserializer<'de, 'a>{
  deserialize_numeric_key!(deserialize_number, deserialize_number);
}

impl<'de, 'a> de::Deserializer<'de> for MapKeyDeserializer<'de, 'a>{
  type Error = Error;

  #[inline]
  fn deserialize_any<V>(self, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    self.de.discard();
    self.de.scratch.clear();
    match self.de.parse_str()?{
      Reference::Borrowed(s) => visitor.visit_borrowed_str(s),
      Reference::Copied(s) => visitor.visit_str(s),
    }
  }

  deserialize_numeric_key!(deserialize_i8);
  deserialize_numeric_key!(deserialize_i16);
  deserialize_numeric_key!(deserialize_i32);
  deserialize_numeric_key!(deserialize_i64);
  deserialize_numeric_key!(deserialize_i128, deserialize_i128);
  deserialize_numeric_key!(deserialize_u8);
  deserialize_numeric_key!(deserialize_u16);
  deserialize_numeric_key!(deserialize_u32);
  deserialize_numeric_key!(deserialize_u64);
  deserialize_numeric_key!(deserialize_u128, deserialize_u128);
  deserialize_numeric_key!(deserialize_f32);
  deserialize_numeric_key!(deserialize_f64);

  fn deserialize_bool<V>(self, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    self.de.discard();

    match self.de.expect_next()?{
      b't' => {
        self.de.parse_ident(b"rue\"")?;
        visitor.visit_bool(true)
      }
      b'f' => {
        self.de.parse_ident(b"alse\"")?;
        visitor.visit_bool(false)
      }
      _ => {
        self.de.scratch.clear();
        let s = self.de.parse_str()?;
        Err(de::Error::invalid_type(Unexpected::Str(&s), &visitor))
      }
    }
  }

  #[inline]
  fn deserialize_bytes<V>(self, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    self.de.deserialize_bytes(visitor)
  }

  #[inline]
  fn deserialize_byte_buf<V>(self, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    self.de.deserialize_bytes(visitor)
  }

  #[inline]
  fn deserialize_option<V>(self, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    // Map keys cannot be null.
    visitor.visit_some(self)
  }

  #[inline]
  fn deserialize_newtype_struct<V>(self, name: &'static str, visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    let _ = name;
    visitor.visit_newtype_struct(self)
  }

  #[inline]
  fn deserialize_enum<V>(self, name: &'static str, variants: &'static [&'static str], visitor: V) -> Result<V::Value, Error>
  where
    V: Visitor<'de>,
  {
    self.de.deserialize_enum(name, variants, visitor)
  }

  forward_to_deserialize_any!{
    char str string unit unit_struct seq tuple tuple_struct map struct
    identifier ignored_any
  }
}



struct IdMapDeserializer<'de, 'a>{
  de: &'a mut Deserializer<'de>,
}

impl<'de, 'a> de::Deserializer<'de> for IdMapDeserializer<'de, 'a>{
  type Error = Error;

  fn deserialize_any<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    Err(self.de.peek_invalid_type(&visitor))
  }

  forward_to_deserialize_any!{
    bool
    i8 i16 i32 i64 i128
    u8 u16 u32 u64 u128
    f32 f64
    char str string bytes byte_buf
    option unit unit_struct newtype_struct seq tuple tuple_struct struct
    enum identifier ignored_any
  }

  fn deserialize_map<V>(self, visitor: V) -> Result<V::Value, Self::Error>
  where
    V: Visitor<'de>
  {
    match self.de.expect_parse_whitespace()?{
      b'[' => {
        self.de.discard();
        match self.de.expect_peek()?{
          b':' => {
            check_recursion!{
              (self.de).discard();
              let ret = visitor.visit_map(IdMapAccess::new(self.de));
            }

            match (ret, self.de.end_id_map()){
              (Ok(ret), Ok(())) => Ok(ret),
              (Err(err), _) | (_, Err(err)) => Err(err),
            }
          }
          _ => Err(self.de.peek_invalid_type(&visitor)),
        }
      }
      _ => Err(self.de.peek_error(ErrorCode::ExpectedColonAtStart)),
    }
  }
}



pub fn from_slice<'de, T>(input: &'de [u8]) -> Result<T, Error>
where
  T: de::Deserialize<'de>,
{
  let mut de = Deserializer::new(input);
  let value = de::Deserialize::deserialize(&mut de)?;

  // Make sure the whole stream has been consumed.
  de.end()?;
  Ok(value)
}


pub fn from_str<'a, T>(s: &'a str) -> Result<T, Error>
where
  T: de::Deserialize<'a>,
{
  from_slice(s.as_ref())
}