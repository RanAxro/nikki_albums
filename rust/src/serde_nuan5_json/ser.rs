use super::ext_type::ID_MAP_TOKEN;
use super::error::{Error, ErrorCode};
use std::fmt::{Display};
use std::hint;
use std::num::FpCategory;
use delegate::delegate;
use serde::{ser, Serialize};
use serde::ser::Impossible;

type Output = Vec<u8>;

/// A structure for serializing Rust values into nuan5json.
struct Serializer<F = CompactFormatter>{
  output: Output,
  formatter: F,
}

impl Serializer{
  /// Creates a new nuan5json serializer.
  #[inline]
  pub fn new(output: Output) -> Self{
    Serializer::with_formatter(output, CompactFormatter{})
  }
}

impl<'a> Serializer<PrettyFormatter<'a>>{
  /// Creates a new nuan5json pretty print serializer.
  #[inline]
  pub fn pretty(output: Output) -> Self{
    Serializer::with_formatter(output, PrettyFormatter::new())
  }
}

impl<F> Serializer<F>{
  /// Creates a new nuan5json visitor whose output will be written
  #[inline]
  pub fn with_formatter(output: Output, formatter: F) -> Self{
    Serializer{ output, formatter }
  }

  /// Unwrap the `Output` from the `Serializer`.
  #[inline]
  pub fn into_inner(self) -> Output{
    self.output
  }
}



impl<'a, F> ser::Serializer for &'a mut Serializer<F>
where
  F: Formatter,
{
  type Ok = ();
  type Error = Error;

  type SerializeSeq = Compound<'a, F>;
  type SerializeTuple = Compound<'a, F>;
  type SerializeTupleStruct = Compound<'a, F>;
  type SerializeTupleVariant = Compound<'a, F>;
  type SerializeMap = Compound<'a, F>;
  type SerializeStruct = Compound<'a, F>;
  type SerializeStructVariant = Compound<'a, F>;

  #[inline]
  fn serialize_bool(self, value: bool) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_bool(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_i8(self, value: i8) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_i8(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_i16(self, value: i16) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_i16(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_i32(self, value: i32) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_i32(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_i64(self, value: i64) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_i64(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_i128(self, value: i128) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_i128(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_u8(self, value: u8) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_u8(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_u16(self, value: u16) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_u16(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_u32(self, value: u32) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_u32(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_u64(self, value: u64) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_u64(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_u128(self, value: u128) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_u128(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_f32(self, value: f32) -> Result<Self::Ok, Self::Error>{
    match value.classify(){
      FpCategory::Nan | FpCategory::Infinite => self.formatter.write_null(&mut self.output),
      _ => self.formatter.write_f32(&mut self.output, value),
    };
    Ok(())
  }

  #[inline]
  fn serialize_f64(self, value: f64) -> Result<Self::Ok, Self::Error>{
    match value.classify(){
      FpCategory::Nan | FpCategory::Infinite => self.formatter.write_null(&mut self.output),
      _ => self.formatter.write_f64(&mut self.output, value),
    };
    Ok(())
  }

  #[inline]
  fn serialize_char(self, value: char) -> Result<Self::Ok, Self::Error>{
    // A char encoded as UTF-8 takes 4 bytes at most.
    let mut buf = [0; 4];
    self.serialize_str(value.encode_utf8(&mut buf))
  }

  #[inline]
  fn serialize_str(self, value: &str) -> Result<Self::Ok, Self::Error>{
    format_escaped_str(&mut self.output, &mut self.formatter, value);
    Ok(())
  }

  #[inline]
  fn serialize_bytes(self, value: &[u8]) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_byte_array(&mut self.output, value);
    Ok(())
  }

  #[inline]
  fn serialize_none(self) -> Result<Self::Ok, Self::Error>{
    self.serialize_unit()
  }

  #[inline]
  fn serialize_some<T>(self, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Serialize,
  {
    value.serialize(self)
  }

  #[inline]
  fn serialize_unit(self) -> Result<Self::Ok, Self::Error>{
    self.formatter.write_null(&mut self.output);
    Ok(())
  }

  #[inline]
  fn serialize_unit_struct(self, _name: &'static str) -> Result<Self::Ok, Self::Error>{
    self.serialize_unit()
  }

  #[inline]
  fn serialize_unit_variant(self, _name: &'static str, _variant_index: u32, variant: &'static str) -> Result<Self::Ok, Self::Error>{
    self.serialize_str(variant)
  }

  #[inline]
  fn serialize_newtype_struct<T>(self, _name: &'static str, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Serialize,
  {
    match _name{
      ID_MAP_TOKEN => value.serialize(IdMapSerializer{ ser: self}),
      _ => value.serialize(self),
    }
  }

  #[inline]
  fn serialize_newtype_variant<T>(self, _name: &'static str, _variant_index: u32, variant: &'static str, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Serialize,
  {
    self.formatter.begin_object(&mut self.output);
    self.formatter.begin_object_key(&mut self.output, true);
    self.serialize_str(variant)?;
    self.formatter.end_object_key(&mut self.output);
    self.formatter.begin_object_value(&mut self.output);
    value.serialize(&mut *self)?;
    self.formatter.end_object_value(&mut self.output);
    self.formatter.end_object(&mut self.output);
    Ok(())
  }

  #[inline]
  fn serialize_seq(self, len: Option<usize>) -> Result<Self::SerializeSeq, Self::Error>{
    let _ = len;
    self.formatter.begin_array(&mut self.output);
    Ok(Compound{
      ser: self,
      state: State::First,
      is_id_map: false,
    })
  }

  #[inline]
  fn serialize_tuple(self, len: usize) -> Result<Self::SerializeTuple, Self::Error>{
    self.serialize_seq(Some(len))
  }

  #[inline]
  fn serialize_tuple_struct(self, _name: &'static str, len: usize) -> Result<Self::SerializeTupleStruct, Self::Error>{
    self.serialize_seq(Some(len))
  }

  #[inline]
  fn serialize_tuple_variant(self, _name: &'static str, _variant_index: u32, variant: &'static str, len: usize) -> Result<Self::SerializeTupleVariant, Self::Error>{
    self.formatter.begin_object(&mut self.output);
    self.formatter.begin_object_key(&mut self.output, true);
    self.serialize_str(variant)?;
    self.formatter.end_object_key(&mut self.output);
    self.formatter.begin_object_value(&mut self.output);
    self.serialize_seq(Some(len))
  }

  #[inline]
  fn serialize_map(self, len: Option<usize>) -> Result<Self::SerializeMap, Self::Error>{
    let _ = len;
    self.formatter.begin_object(&mut self.output);
    Ok(Compound{
      ser: self,
      state: State::First,
      is_id_map: false,
    })
  }

  #[inline]
  fn serialize_struct(self, name: &'static str, len: usize) -> Result<Self::SerializeStruct, Self::Error>{
    let _ = name;
    self.serialize_map(Some(len))
  }

  #[inline]
  fn serialize_struct_variant(self, _name: &'static str, _variant_index: u32, variant: &'static str, len: usize) -> Result<Self::SerializeStructVariant, Self::Error>{
    self.formatter.begin_object(&mut self.output);
    self.formatter.begin_object_key(&mut self.output, true);
    self.serialize_str(variant)?;
    self.formatter.end_object_key(&mut self.output);
    self.formatter.begin_object_value(&mut self.output);
    self.serialize_map(Some(len))
  }

  fn collect_str<T>(self, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Display,
  {
    self.formatter.begin_string(&mut self.output);
    format_escaped_str(&mut self.output, &mut self.formatter, &value.to_string());
    self.formatter.end_string(&mut self.output);
    Ok(())
  }
}




#[derive(Eq, PartialEq)]
enum State{
  First,
  Rest,
}

struct Compound<'a, F: 'a>{
  ser: &'a mut Serializer<F>,
  state: State,
  is_id_map: bool,
}

impl<'a, F> ser::SerializeSeq for Compound<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  fn serialize_element<T>(&mut self, value: &T) -> Result<(), Self::Error>
  where
    T: ?Sized + Serialize
  {
    self.ser.formatter.begin_array_value(&mut self.ser.output, self.state == State::First);
    value.serialize(&mut *self.ser)?;
    self.ser.formatter.end_array_value(&mut self.ser.output);
    self.state = State::Rest;
    Ok(())
  }

  fn end(self) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.end_array(&mut self.ser.output);
    Ok(())
  }
}

impl<'a, F> ser::SerializeTuple for Compound<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  fn serialize_element<T>(&mut self, value: &T) -> Result<(), Self::Error>
  where
    T: ?Sized + Serialize
  {
    ser::SerializeSeq::serialize_element(self, value)
  }

  fn end(self) -> Result<Self::Ok, Self::Error>{
    ser::SerializeSeq::end(self)
  }
}

impl<'a, F> ser::SerializeTupleStruct for Compound<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  fn serialize_field<T>(&mut self, value: &T) -> Result<(), Self::Error>
  where
    T: ?Sized + Serialize
  {
    ser::SerializeSeq::serialize_element(self, value)
  }

  fn end(self) -> Result<Self::Ok, Self::Error>{
    ser::SerializeSeq::end(self)
  }
}

impl<'a, F> ser::SerializeTupleVariant for Compound<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  fn serialize_field<T>(&mut self, value: &T) -> Result<(), Self::Error>
  where
    T: ?Sized + Serialize
  {
    ser::SerializeSeq::serialize_element(self, value)
  }

  fn end(self) -> Result<Self::Ok, Self::Error>{
    // ser::SerializeSeq::end(&self)?;
    self.ser.formatter.end_array(&mut self.ser.output);
    self.ser.formatter.end_object_value(&mut self.ser.output);
    self.ser.formatter.end_object(&mut self.ser.output);
    Ok(())
  }
}

impl<'a, F> ser::SerializeMap for Compound<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  fn serialize_key<T>(&mut self, key: &T) -> Result<(), Self::Error>
  where
    T: ?Sized + Serialize
  {
    if self.is_id_map {
      self.ser.formatter.begin_id_map_key(&mut self.ser.output, self.state == State::First);
      key.serialize(IdMapKeySerializer{ser: self.ser})?;
      self.ser.formatter.end_id_map_key(&mut self.ser.output);
      self.state = State::Rest;
    }else{
      self.ser.formatter.begin_object_key(&mut self.ser.output, self.state == State::First);
      key.serialize(MapKeySerializer{ser: self.ser})?;
      self.ser.formatter.end_object_key(&mut self.ser.output);
      self.state = State::Rest;
    }
    Ok(())
  }

  fn serialize_value<T>(&mut self, value: &T) -> Result<(), Self::Error>
  where
    T: ?Sized + Serialize
  {
    if self.is_id_map {
      self.ser.formatter.begin_id_map_value(&mut self.ser.output);
      value.serialize(&mut *self.ser)?;
      self.ser.formatter.end_id_map_value(&mut self.ser.output);
    }else{
      self.ser.formatter.begin_object_value(&mut self.ser.output);
      value.serialize(&mut *self.ser)?;
      self.ser.formatter.end_object_value(&mut self.ser.output);
    }
    Ok(())
  }

  fn serialize_entry<K, V>(&mut self, key: &K, value: &V) -> Result<(), Self::Error>
  where
    K: ?Sized + Serialize,
    V: ?Sized + Serialize,
  {
    self.serialize_key(key)?;
    self.serialize_value(value)
  }

  fn end(self) -> Result<Self::Ok, Self::Error>{
    if self.is_id_map {
      self.ser.formatter.end_id_map(&mut self.ser.output);
    }else{
      self.ser.formatter.end_object(&mut self.ser.output);
    }
    Ok(())
  }
}

impl<'a, F> ser::SerializeStruct for Compound<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  fn serialize_field<T>(&mut self, key: &'static str, value: &T) -> Result<(), Self::Error>
  where
    T: ?Sized + Serialize
  {
    ser::SerializeMap::serialize_entry(self, key, value)
  }

  fn end(self) -> Result<Self::Ok, Self::Error>{
    ser::SerializeMap::end(self)
  }
}

impl<'a, F> ser::SerializeStructVariant for Compound<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  fn serialize_field<T>(&mut self, key: &'static str, value: &T) -> Result<(), Self::Error>
  where
    T: ?Sized + Serialize
  {
    ser::SerializeStruct::serialize_field(self, key, value)
  }

  fn end(self) -> Result<Self::Ok, Self::Error>{
    if self.is_id_map {
      self.ser.formatter.end_id_map(&mut self.ser.output);
      self.ser.formatter.end_id_map_value(&mut self.ser.output);
      self.ser.formatter.end_id_map(&mut self.ser.output);
    }else{
      self.ser.formatter.end_object(&mut self.ser.output);
      self.ser.formatter.end_object_value(&mut self.ser.output);
      self.ser.formatter.end_object(&mut self.ser.output);
    }
    Ok(())
  }
}



struct IdMapSerializer<'a, F: 'a>{
  ser: &'a mut Serializer<F>,
}

impl<'a, F> ser::Serializer for IdMapSerializer<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  type SerializeSeq = Compound<'a, F>;
  type SerializeTuple = Compound<'a, F>;
  type SerializeTupleStruct = Compound<'a, F>;
  type SerializeTupleVariant = Compound<'a, F>;
  type SerializeMap = Compound<'a, F>;
  type SerializeStruct = Compound<'a, F>;
  type SerializeStructVariant = Compound<'a, F>;

  delegate!{
    to self.ser{
      fn serialize_bool(self, v: bool) -> Result<Self::Ok, Self::Error>;
      fn serialize_i8(self, v: i8) -> Result<Self::Ok, Self::Error>;
      fn serialize_i16(self, v: i16) -> Result<Self::Ok, Self::Error>;
      fn serialize_i32(self, v: i32) -> Result<Self::Ok, Self::Error>;
      fn serialize_i64(self, v: i64) -> Result<Self::Ok, Self::Error>;
      fn serialize_i128(self, v: i128) -> Result<Self::Ok, Self::Error>;
      fn serialize_u8(self, v: u8) -> Result<Self::Ok, Self::Error>;
      fn serialize_u16(self, v: u16) -> Result<Self::Ok, Self::Error>;
      fn serialize_u32(self, v: u32) -> Result<Self::Ok, Self::Error>;
      fn serialize_u64(self, v: u64) -> Result<Self::Ok, Self::Error>;
      fn serialize_u128(self, v: u128) -> Result<Self::Ok, Self::Error>;
      fn serialize_f32(self, v: f32) -> Result<Self::Ok, Self::Error>;
      fn serialize_f64(self, v: f64) -> Result<Self::Ok, Self::Error>;
      fn serialize_char(self, v: char) -> Result<Self::Ok, Self::Error>;
      fn serialize_str(self, v: &str) -> Result<Self::Ok, Self::Error>;
      fn serialize_bytes(self, v: &[u8]) -> Result<Self::Ok, Self::Error>;
      fn serialize_none(self) -> Result<Self::Ok, Self::Error>;
      fn serialize_some<T>(self, value: &T) -> Result<Self::Ok, Self::Error>
      where
        T: ?Sized + Serialize;
      fn serialize_unit(self) -> Result<Self::Ok, Self::Error>;
      fn serialize_unit_struct(self, name: &'static str) -> Result<Self::Ok, Self::Error>;
      fn serialize_unit_variant(self, name: &'static str, variant_index: u32, variant: &'static str) -> Result<Self::Ok, Self::Error>;
      fn serialize_newtype_struct<T>(self, name: &'static str, value: &T) -> Result<Self::Ok, Self::Error>
      where
        T: ?Sized + Serialize;
      fn serialize_newtype_variant<T>(self, name: &'static str, variant_index: u32, variant: &'static str, value: &T) -> Result<Self::Ok, Self::Error>
      where
        T: ?Sized + Serialize;
      fn serialize_seq(self, len: Option<usize>) -> Result<Self::SerializeSeq, Self::Error>;
      fn serialize_tuple(self, len: usize) -> Result<Self::SerializeTuple, Self::Error>;
      fn serialize_tuple_struct(self, name: &'static str, len: usize) -> Result<Self::SerializeTupleStruct, Self::Error>;
      fn serialize_tuple_variant(self, name: &'static str, variant_index: u32, variant: &'static str, len: usize) -> Result<Self::SerializeTupleVariant, Self::Error>;

      fn serialize_struct(self, name: &'static str, len: usize) -> Result<Self::SerializeStruct, Self::Error>;
      fn serialize_struct_variant(self, name: &'static str, variant_index: u32, variant: &'static str, len: usize) -> Result<Self::SerializeStructVariant, Self::Error>;
    }
  }

  fn serialize_map(self, len: Option<usize>) -> Result<Self::SerializeMap, Self::Error>{
    let _ = len;
    self.ser.formatter.begin_id_map(&mut self.ser.output);
    Ok(Compound{
      ser: self.ser,
      state: State::First,
      is_id_map: true,
    })
  }
}


struct MapKeySerializer<'a, F: 'a>{
  ser: &'a mut Serializer<F>,
}

impl<'a, F> ser::Serializer for MapKeySerializer<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  type SerializeSeq = Impossible<Self::Ok, Self::Error>;
  type SerializeTuple = Impossible<Self::Ok, Self::Error>;
  type SerializeTupleStruct = Impossible<Self::Ok, Self::Error>;
  type SerializeTupleVariant = Impossible<Self::Ok, Self::Error>;
  type SerializeMap = Impossible<Self::Ok, Self::Error>;
  type SerializeStruct = Impossible<Self::Ok, Self::Error>;
  type SerializeStructVariant = Impossible<Self::Ok, Self::Error>;

  fn serialize_bool(self, v: bool) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_bool(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_i8(self, v: i8) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_i8(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_i16(self, v: i16) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_i16(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_i32(self, v: i32) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_i32(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_i64(self, v: i64) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_i64(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_i128(self, v: i128) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_i128(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_u8(self, v: u8) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_u8(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_u16(self, v: u16) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_u16(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_u32(self, v: u32) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_u32(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_u64(self, v: u64) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_u64(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_u128(self, v: u128) -> Result<Self::Ok, Self::Error>{
    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_u128(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_f32(self, v: f32) -> Result<Self::Ok, Self::Error>{
    if !v.is_finite() {
      return Err(Error::code(ErrorCode::FloatKeyMustBeFinite));
    }

    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_f32(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_f64(self, v: f64) -> Result<Self::Ok, Self::Error>{
    if !v.is_finite() {
      return Err(Error::code(ErrorCode::FloatKeyMustBeFinite));
    }

    self.ser.formatter.begin_string(&mut self.ser.output);
    self.ser.serialize_f64(v)?;
    self.ser.formatter.end_string(&mut self.ser.output);
    Ok(())
  }

  fn serialize_char(self, v: char) -> Result<Self::Ok, Self::Error>{
    self.ser.serialize_char(v)
  }

  fn serialize_str(self, v: &str) -> Result<Self::Ok, Self::Error>{
    self.ser.serialize_str(v)
  }

  fn serialize_bytes(self, v: &[u8]) -> Result<Self::Ok, Self::Error>{
    let _ = v;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_none(self) -> Result<Self::Ok, Self::Error>{
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_some<T>(self, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Serialize
  {
    let _ = value;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_unit(self) -> Result<Self::Ok, Self::Error>{
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_unit_struct(self, name: &'static str) -> Result<Self::Ok, Self::Error>{
    let _ = name;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_unit_variant(self, name: &'static str, variant_index: u32, variant: &'static str) -> Result<Self::Ok, Self::Error>{
    let _ = name;
    let _ = variant_index;
    let _ = variant;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_newtype_struct<T>(self, name: &'static str, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Serialize
  {
    let _ = name;
    let _ = value;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_newtype_variant<T>(self, name: &'static str, variant_index: u32, variant: &'static str, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Serialize
  {
    let _ = name;
    let _ = variant_index;
    let _ = variant;
    let _ = value;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_seq(self, len: Option<usize>) -> Result<Self::SerializeSeq, Self::Error>{
    let _ = len;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_tuple(self, len: usize) -> Result<Self::SerializeTuple, Self::Error>{
    let _ = len;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_tuple_struct(self, name: &'static str, len: usize) -> Result<Self::SerializeTupleStruct, Self::Error>{
    let _ = name;
    let _ = len;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_tuple_variant(self, name: &'static str, variant_index: u32, variant: &'static str, len: usize) -> Result<Self::SerializeTupleVariant, Self::Error>{
    let _ = name;
    let _ = variant_index;
    let _ = variant;
    let _ = len;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_map(self, len: Option<usize>) -> Result<Self::SerializeMap, Self::Error>{
    let _ = len;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_struct(self, name: &'static str, len: usize) -> Result<Self::SerializeStruct, Self::Error>{
    let _ = name;
    let _ = len;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }

  fn serialize_struct_variant(self, name: &'static str, variant_index: u32, variant: &'static str, len: usize) -> Result<Self::SerializeStructVariant, Self::Error>{
    let _ = name;
    let _ = variant_index;
    let _ = variant;
    let _ = len;
    Err(Error::code(ErrorCode::KeyMustBeAString))
  }
}


struct IdMapKeySerializer<'a, F: 'a>{
  ser: &'a mut Serializer<F>,
}

impl<'a, F> ser::Serializer for IdMapKeySerializer<'a, F>
where
  F: Formatter
{
  type Ok = ();
  type Error = Error;

  type SerializeSeq = Impossible<Self::Ok, Self::Error>;
  type SerializeTuple = Impossible<Self::Ok, Self::Error>;
  type SerializeTupleStruct = Impossible<Self::Ok, Self::Error>;
  type SerializeTupleVariant = Impossible<Self::Ok, Self::Error>;
  type SerializeMap = Impossible<Self::Ok, Self::Error>;
  type SerializeStruct = Impossible<Self::Ok, Self::Error>;
  type SerializeStructVariant = Impossible<Self::Ok, Self::Error>;

  fn serialize_bool(self, v: bool) -> Result<Self::Ok, Self::Error>{
    let _ = v;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  delegate!{
    to self.ser{
      fn serialize_i8(self, v: i8) -> Result<Self::Ok, Self::Error>;
      fn serialize_i16(self, v: i16) -> Result<Self::Ok, Self::Error>;
      fn serialize_i32(self, v: i32) -> Result<Self::Ok, Self::Error>;
      fn serialize_i64(self, v: i64) -> Result<Self::Ok, Self::Error>;
      fn serialize_i128(self, v: i128) -> Result<Self::Ok, Self::Error>;
      fn serialize_u8(self, v: u8) -> Result<Self::Ok, Self::Error>;
      fn serialize_u16(self, v: u16) -> Result<Self::Ok, Self::Error>;
      fn serialize_u32(self, v: u32) -> Result<Self::Ok, Self::Error>;
      fn serialize_u64(self, v: u64) -> Result<Self::Ok, Self::Error>;
      fn serialize_u128(self, v: u128) -> Result<Self::Ok, Self::Error>;
    }
  }

  fn serialize_f32(self, v: f32) -> Result<Self::Ok, Self::Error>{
    let _ = v;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_f64(self, v: f64) -> Result<Self::Ok, Self::Error>{
    let _ = v;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_char(self, v: char) -> Result<Self::Ok, Self::Error>{
    let _ = v;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_str(self, v: &str) -> Result<Self::Ok, Self::Error>{
    let _ = v;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_bytes(self, v: &[u8]) -> Result<Self::Ok, Self::Error>{
    let _ = v;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_none(self) -> Result<Self::Ok, Self::Error>{
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_some<T>(self, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Serialize
  {
    let _ = value;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_unit(self) -> Result<Self::Ok, Self::Error>{
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_unit_struct(self, name: &'static str) -> Result<Self::Ok, Self::Error>{
    let _ = name;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_unit_variant(self, name: &'static str, variant_index: u32, variant: &'static str) -> Result<Self::Ok, Self::Error>{
    let _ = name;
    let _ = variant_index;
    let _ = variant;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_newtype_struct<T>(self, name: &'static str, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Serialize
  {
    let _ = name;
    let _ = value;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_newtype_variant<T>(self, name: &'static str, variant_index: u32, variant: &'static str, value: &T) -> Result<Self::Ok, Self::Error>
  where
    T: ?Sized + Serialize
  {
    let _ = name;
    let _ = variant_index;
    let _ = variant;
    let _ = value;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_seq(self, len: Option<usize>) -> Result<Self::SerializeSeq, Self::Error>{
    let _ = len;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_tuple(self, len: usize) -> Result<Self::SerializeTuple, Self::Error>{
    let _ = len;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_tuple_struct(self, name: &'static str, len: usize) -> Result<Self::SerializeTupleStruct, Self::Error>{
    let _ = name;
    let _ = len;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_tuple_variant(self, name: &'static str, variant_index: u32, variant: &'static str, len: usize) -> Result<Self::SerializeTupleVariant, Self::Error>{
    let _ = name;
    let _ = variant_index;
    let _ = variant;
    let _ = len;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_map(self, len: Option<usize>) -> Result<Self::SerializeMap, Self::Error>{
    let _ = len;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_struct(self, name: &'static str, len: usize) -> Result<Self::SerializeStruct, Self::Error>{
    let _ = name;
    let _ = len;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }

  fn serialize_struct_variant(self, name: &'static str, variant_index: u32, variant: &'static str, len: usize) -> Result<Self::SerializeStructVariant, Self::Error>{
    let _ = name;
    let _ = variant_index;
    let _ = variant;
    let _ = len;
    Err(Error::code(ErrorCode::IdMapKeyMustBeAnInteger))
  }
}






/// Represents a character escape code in a type-safe manner.
enum CharEscape{
  /// An escaped quote `"`
  Quote,
  /// An escaped reverse solidus `\`
  ReverseSolidus,
  /// An escaped solidus `/`
  Solidus,
  /// An escaped backspace character (usually escaped as `\b`)
  Backspace,
  /// An escaped form feed character (usually escaped as `\f`)
  FormFeed,
  /// An escaped line feed character (usually escaped as `\n`)
  LineFeed,
  /// An escaped carriage return character (usually escaped as `\r`)
  CarriageReturn,
  /// An escaped tab character (usually escaped as `\t`)
  Tab,
  /// An escaped ASCII plane control character (usually escaped as
  /// `\u00XX` where `XX` are two hex characters)
  AsciiControl(u8),
}

/// This trait abstracts away serializing the nuan5json control characters, which allows the user to
/// optionally pretty print the nuan5json output.
trait Formatter{
  /// Writes a `null` value.
  #[inline]
  fn write_null(&mut self, output: &mut Output){
    output.extend_from_slice(b"null");
  }

  /// Writes a `true` or `false` value.
  #[inline]
  fn write_bool(&mut self, output: &mut Output, value: bool){
    output.extend_from_slice(if value { b"true" } else { b"false" });
  }

  /// Writes an integer value like `-123`.
  #[inline]
  fn write_i8(&mut self, output: &mut Output, value: i8){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes an integer value like `-123`.
  #[inline]
  fn write_i16(&mut self, output: &mut Output, value: i16){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes an integer value like `-123`.
  #[inline]
  fn write_i32(&mut self, output: &mut Output, value: i32){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes an integer value like `-123`.
  #[inline]
  fn write_i64(&mut self, output: &mut Output, value: i64){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes an integer value like `-123`.
  #[inline]
  fn write_i128(&mut self, output: &mut Output, value: i128){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes an integer value like `123`.
  #[inline]
  fn write_u8(&mut self, output: &mut Output, value: u8){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes an integer value like `123`.
  #[inline]
  fn write_u16(&mut self, output: &mut Output, value: u16){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes an integer value like `123`.
  #[inline]
  fn write_u32(&mut self, output: &mut Output, value: u32){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes an integer value like `123`.
  #[inline]
  fn write_u64(&mut self, output: &mut Output, value: u64){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes an integer value like `123`.
  #[inline]
  fn write_u128(&mut self, output: &mut Output, value: u128){
    let mut buffer = itoa::Buffer::new();
    let s = buffer.format(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes a floating point value like `-31.26e+12`.
  ///
  /// # Special cases
  ///
  /// This function **does not** check for NaN or infinity. If the input
  /// number is not a finite float, the printed representation will be some
  /// correctly formatted but unspecified numerical value.
  ///
  /// Please check [`is_finite`] yourself before calling this function, or
  /// check [`is_nan`] and [`is_infinite`] and handle those cases yourself
  /// with a different `Formatter` method.
  ///
  /// [`is_finite`]: f32::is_finite
  /// [`is_nan`]: f32::is_nan
  /// [`is_infinite`]: f32::is_infinite
  #[inline]
  fn write_f32(&mut self, output: &mut Output, value: f32){
    let mut buffer = ryu::Buffer::new();
    let s = buffer.format_finite(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes a floating point value like `-31.26e+12`.
  ///
  /// # Special cases
  ///
  /// This function **does not** check for NaN or infinity. If the input
  /// number is not a finite float, the printed representation will be some
  /// correctly formatted but unspecified numerical value.
  ///
  /// Please check [`is_finite`] yourself before calling this function, or
  /// check [`is_nan`] and [`is_infinite`] and handle those cases yourself
  /// with a different `Formatter` method.
  ///
  /// [`is_finite`]: f64::is_finite
  /// [`is_nan`]: f64::is_nan
  /// [`is_infinite`]: f64::is_infinite
  #[inline]
  fn write_f64(&mut self, output: &mut Output, value: f64){
    let mut buffer = ryu::Buffer::new();
    let s = buffer.format_finite(value);
    output.extend_from_slice(s.as_bytes());
  }

  /// Writes a number that has already been rendered to a string.
  #[inline]
  fn write_number_str(&mut self, output: &mut Output, value: &str){
    output.extend_from_slice(value.as_bytes());
  }

  /// Called before each series of `write_string_fragment` and
  /// `write_char_escape`.  Writes a `"`.
  #[inline]
  fn begin_string(&mut self, output: &mut Output){
    output.push(b'"')
  }

  /// Called after each series of `write_string_fragment` and
  /// `write_char_escape`.  Writes a `"`.
  #[inline]
  fn end_string(&mut self, output: &mut Output){
    output.push(b'"')
  }

  /// Writes a string fragment that doesn't need any escaping.
  #[inline]
  fn write_string_fragment(&mut self, output: &mut Output, fragment: &str){
    output.extend_from_slice(fragment.as_bytes())
  }

  /// Writes a character escape code.
  #[inline]
  fn write_char_escape(&mut self, output: &mut Output, char_escape: CharEscape){
    let escape_char = match char_escape {
      CharEscape::Quote => b'"',
      CharEscape::ReverseSolidus => b'\\',
      CharEscape::Solidus => b'/',
      CharEscape::Backspace => b'b',
      CharEscape::FormFeed => b'f',
      CharEscape::LineFeed => b'n',
      CharEscape::CarriageReturn => b'r',
      CharEscape::Tab => b't',
      CharEscape::AsciiControl(_) => b'u',
    };

    match char_escape{
      CharEscape::AsciiControl(byte) => {
        static HEX_DIGITS: [u8; 16] = *b"0123456789abcdef";
        let bytes = &[
          b'\\',
          escape_char,
          b'0',
          b'0',
          HEX_DIGITS[(byte >> 4) as usize],
          HEX_DIGITS[(byte & 0xF) as usize],
        ];
        output.extend_from_slice(bytes)
      }
      _ => output.extend_from_slice(&[b'\\', escape_char]),
    }
  }

  /// Writes the representation of a byte array. Formatters can choose whether
  /// to represent bytes as a nuan5json array of integers (the default), or some
  /// nuan5json string encoding like hex or base64.
  fn write_byte_array(&mut self, output: &mut Output, value: &[u8]){
    self.begin_array(output);
    let mut first = true;
    for byte in value{
      self.begin_array_value(output, first);
      self.write_u8(output, *byte);
      self.end_array_value(output);
      first = false;
    }
    self.end_array(output)
  }

  /// Called before every array.  Writes a `[`.
  #[inline]
  fn begin_array(&mut self, output: &mut Output){
    output.push(b'[');
  }

  /// Called after every array.  Writes a `]`.
  #[inline]
  fn end_array(&mut self, output: &mut Output){
    output.push(b']');
  }

  /// Called before every array value.  Writes a `,` if needed.
  #[inline]
  fn begin_array_value(&mut self, output: &mut Output, first: bool){
    if !first {
      output.push(b',');
    }
  }

  /// Called after every array value.
  #[inline]
  fn end_array_value(&mut self, output: &mut Output){
    let _ = output;
  }

  /// Called before every object.  Writes a `{`.
  #[inline]
  fn begin_object(&mut self, output: &mut Output){
    output.push(b'{');
  }

  /// Called after every object.  Writes a `}`.
  #[inline]
  fn end_object(&mut self, output: &mut Output){
    output.push(b'}');
  }

  /// Called before every object key.
  #[inline]
  fn begin_object_key(&mut self, output: &mut Output, first: bool){
    if !first {
      output.push(b',');
    }
  }

  /// Called after every object key.  A `:` should be written
  /// by either this method or `begin_object_value`.
  #[inline]
  fn end_object_key(&mut self, output: &mut Output){
    let _ = output;
  }

  /// Called before every object value.  A `:` should be written
  /// by either this method or `end_object_key`.
  #[inline]
  fn begin_object_value(&mut self, output: &mut Output){
    output.push(b':');
  }

  /// Called after every object value.
  #[inline]
  fn end_object_value(&mut self, output: &mut Output){
    let _ = output;
  }

  /// Called before every idMap.  Writes a `[:`.
  #[inline]
  fn begin_id_map(&mut self, output: &mut Output){
    output.extend_from_slice(b"[:");
  }

  /// Called after every idMap.  Writes a `]`.
  #[inline]
  fn end_id_map(&mut self, output: &mut Output){
    output.push(b']');
  }

  /// Called before every idMap key.
  #[inline]
  fn begin_id_map_key(&mut self, output: &mut Output, first: bool){
    if !first {
      output.push(b',');
    }
  }

  /// Called after every idMap key.  A `:` should be written
  /// by either this method or `begin_id_map_value`.
  #[inline]
  fn end_id_map_key(&mut self, output: &mut Output){
    let _ = output;
  }

  /// Called before every idMap value.  A `:` should be written
  /// by either this method or `end_id_map_key`.
  #[inline]
  fn begin_id_map_value(&mut self, output: &mut Output){
    output.push(b':');
  }

  /// Called after every idMap value.
  #[inline]
  fn end_id_map_value(&mut self, output: &mut Output){
    let _ = output;
  }

  /// Writes a raw nuan5json fragment that doesn't need any escaping.
  #[inline]
  fn write_raw_fragment(&mut self, output: &mut Output, fragment: &str){
    output.extend_from_slice(fragment.as_bytes());
  }
}




/// This structure compacts a nuan5json value with no extra whitespace.
#[derive(Clone, Debug, Default)]
struct CompactFormatter{

}

impl Formatter for CompactFormatter{

}

/// This structure pretty prints a nuan5json value to make it human readable.
#[derive(Clone, Debug)]
struct PrettyFormatter<'a>{
  current_indent: usize,
  has_value: bool,
  indent: &'a [u8],
}

impl<'a> PrettyFormatter<'a>{
  /// Construct a pretty printer formatter that defaults to using two spaces for indentation.
  pub fn new() -> Self {
    PrettyFormatter::with_indent(b"  ")
  }

  /// Construct a pretty printer formatter that uses the `indent` string for indentation.
  pub fn with_indent(indent: &'a [u8]) -> Self{
    PrettyFormatter{
      current_indent: 0,
      has_value: false,
      indent,
    }
  }
}

impl<'a> Default for PrettyFormatter<'a>{
  fn default() -> Self{
    PrettyFormatter::new()
  }
}

impl<'a> Formatter for PrettyFormatter<'a>{
  #[inline]
  fn begin_array(&mut self, output: &mut Output){
    self.current_indent += 1;
    self.has_value = false;
    output.push(b'[');
  }

  #[inline]
  fn end_array(&mut self, output: &mut Output){
    self.current_indent -= 1;

    if self.has_value {
      output.push(b'\n');
      indent(output, self.current_indent, self.indent);
    }

    output.push(b']');
  }

  #[inline]
  fn begin_array_value(&mut self, output: &mut Output, first: bool){
    output.extend_from_slice(if first { b"\n" } else { b",\n" });
    indent(output, self.current_indent, self.indent)
  }

  #[inline]
  fn end_array_value(&mut self, output: &mut Output){
    let _ = output;
    self.has_value = true;
  }

  #[inline]
  fn begin_object(&mut self, output: &mut Output){
    self.current_indent += 1;
    self.has_value = false;
    output.push(b'{');
  }

  #[inline]
  fn end_object(&mut self, output: &mut Output){
    self.current_indent -= 1;

    if self.has_value {
      output.push(b'\n');
      indent(output, self.current_indent, self.indent);
    }

    output.push(b'}');
  }

  #[inline]
  fn begin_object_key(&mut self, output: &mut Output, first: bool){
    output.extend_from_slice(if first { b"\n" } else { b",\n" });
    indent(output, self.current_indent, self.indent)
  }

  #[inline]
  fn begin_object_value(&mut self, output: &mut Output){
    output.extend_from_slice(b": ");
  }

  #[inline]
  fn end_object_value(&mut self, output: &mut Output){
    let _ = output;
    self.has_value = true;
  }

  #[inline]
  fn begin_id_map(&mut self, output: &mut Output){
    self.current_indent += 1;
    self.has_value = false;
    output.extend_from_slice(b"[:");
  }

  #[inline]
  fn end_id_map(&mut self, output: &mut Output){
    self.current_indent -= 1;

    if self.has_value {
      output.push(b'\n');
      indent(output, self.current_indent, self.indent);
    }

    output.push(b']');
  }

  #[inline]
  fn begin_id_map_key(&mut self, output: &mut Output, first: bool){
    output.extend_from_slice(if first { b"\n" } else { b",\n" });
    indent(output, self.current_indent, self.indent)
  }

  #[inline]
  fn begin_id_map_value(&mut self, output: &mut Output){
    output.extend_from_slice(b": ");
  }

  #[inline]
  fn end_id_map_value(&mut self, output: &mut Output){
    let _ = output;
    self.has_value = true;
  }
}




fn format_escaped_str<F>(output: &mut Output, formatter: &mut F, value: &str)
where
  F: ?Sized + Formatter,
{
  formatter.begin_string(output);
  format_escaped_str_contents(output, formatter, value);
  formatter.end_string(output);
}

fn format_escaped_str_contents<F>(output: &mut Output, formatter: &mut F, value: &str)
where
  F: ?Sized + Formatter,
{
  let mut bytes = value.as_bytes();

  let mut i = 0;
  while i < bytes.len() {
    let (string_run, rest) = bytes.split_at(i);
    let (&byte, rest) = rest.split_first().unwrap();

    let escape = ESCAPE[byte as usize];

    i += 1;
    if escape == 0 {
      continue;
    }

    bytes = rest;
    i = 0;

    // Safety: string_run is a valid utf8 string, since we only split on ascii sequences
    let string_run = unsafe { str::from_utf8_unchecked(string_run) };
    if !string_run.is_empty() {
      formatter.write_string_fragment(output, string_run);
    }

    let char_escape = match escape{
      BB => CharEscape::Backspace,
      TT => CharEscape::Tab,
      NN => CharEscape::LineFeed,
      FF => CharEscape::FormFeed,
      RR => CharEscape::CarriageReturn,
      QU => CharEscape::Quote,
      BS => CharEscape::ReverseSolidus,
      UU => CharEscape::AsciiControl(byte),
      // Safety: the escape table does not contain any other type of character.
      _ => unsafe { hint::unreachable_unchecked() },
    };
    formatter.write_char_escape(output, char_escape);
  }

  // Safety: bytes is a valid utf8 string, since we only split on ascii sequences
  let string_run = unsafe { str::from_utf8_unchecked(bytes) };
  if string_run.is_empty() {
    return;
  }

  formatter.write_string_fragment(output, string_run);
}

const BB: u8 = b'b'; // \x08
const TT: u8 = b't'; // \x09
const NN: u8 = b'n'; // \x0A
const FF: u8 = b'f'; // \x0C
const RR: u8 = b'r'; // \x0D
const QU: u8 = b'"'; // \x22
const BS: u8 = b'\\'; // \x5C
const UU: u8 = b'u'; // \x00...\x1F except the ones above
const __: u8 = 0;

// Lookup table of escape sequences. A value of b'x' at index i means that byte
// i is escaped as "\x" in JSON. A value of 0 means that byte i is not escaped.
static ESCAPE: [u8; 256] = [
  //   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  UU, UU, UU, UU, UU, UU, UU, UU, BB, TT, NN, UU, FF, RR, UU, UU, // 0
  UU, UU, UU, UU, UU, UU, UU, UU, UU, UU, UU, UU, UU, UU, UU, UU, // 1
  __, __, QU, __, __, __, __, __, __, __, __, __, __, __, __, __, // 2
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // 3
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // 4
  __, __, __, __, __, __, __, __, __, __, __, __, BS, __, __, __, // 5
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // 6
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // 7
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // 8
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // 9
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // A
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // B
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // C
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // D
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // E
  __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, // F
];







/// Serialize the given data structure as a nuan5json byte vector.
pub fn to_vec<T>(value: &T) -> Result<Output, Error>
where
  T: ?Sized + Serialize,
{
  let output = Output::with_capacity(128);
  let mut ser = Serializer::new(output);
  value.serialize(&mut ser)?;
  Ok(ser.output)
}

/// Serialize the given data structure as a pretty-printed nuan5json byte vector.
pub fn to_vec_pretty<T>(value: &T) -> Result<Output, Error>
where
  T: ?Sized + Serialize,
{
  let output = Output::with_capacity(128);
  let mut ser = Serializer::with_formatter(output, PrettyFormatter::new());
  value.serialize(&mut ser)?;
  Ok(ser.output)
}

/// Serialize the given data structure as a String of nuah5json.
pub fn to_string<T>(value: &T) -> Result<String, Error>
where
  T: ?Sized + Serialize,
{
  let vec = to_vec(value)?;
  let string = unsafe{
    // We do not emit invalid UTF-8.
    String::from_utf8_unchecked(vec)
  };
  Ok(string)
}

/// Serialize the given data structure as a pretty-printed String of nuan5json.
pub fn to_string_pretty<T>(value: &T) -> Result<String, Error>
where
  T: ?Sized + Serialize,
{
  let vec = to_vec_pretty(value)?;
  let string = unsafe {
    // We do not emit invalid UTF-8.
    String::from_utf8_unchecked(vec)
  };
  Ok(string)
}


fn indent(output: &mut Output, depth: usize, indent_s: &[u8]){
  for _ in 0..depth {
    output.extend_from_slice(indent_s);
  }
}




