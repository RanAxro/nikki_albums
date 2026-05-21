pub mod transform;
pub mod se;
pub mod de;

pub struct FTransformFormat{
  pub endian: Endianness,
  pub count_type: CountType,
  pub field_order: FTransformFieldOrder,
  // pub scalar_type: ScalarType,
  // pub alignment: usize,
}

// pub enum ScalarType{
//   Float,
//   Double,
// }

pub enum Endianness{
  LE,
  BE,
}

pub enum CountType{
  None,
  U16,
  U32,
  U64,
}

// pub enum FQuatFieldOrder{
//   XYZW,
//   WXYZ,
// }

pub enum FTransformFieldOrder{
  RTS,
  // RST,
  TRS,
  // TSR,
  // SRT,
  // STR,
}

#[derive(Debug)]
pub enum ErrorCode{
  BufferOverrun,
  InvalidHex,
  ExceedingLength,
}