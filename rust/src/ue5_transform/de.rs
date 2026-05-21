use super::{CountType, Endianness, FTransformFieldOrder, ErrorCode};
use super::transform::*;
use super::FTransformFormat;
use faster_hex::hex_decode;

struct Deserializer<P: Parser, T: FTransformDeserializer>{
  parser: P,
  count_type: CountType,
  transform_deserializer: T,
}

macro_rules! read_count{
  ($count_type:expr, $parser:expr, $value:expr, $index:expr, $max_len:expr, {
    $($count:ident => $read_fn:ident),* $(,)?
  }) => {
    match $count_type {
      $(
        CountType::$count => {
          let len = $parser.$read_fn($value, &mut $index)?;
          if let Some(max) = $max_len {
            if len as usize > max {
              return Err(ErrorCode::BufferOverrun);
            }
          }
          Vec::with_capacity(len as usize)
        },
      )*
      CountType::None => Vec::new(),
    }
  };
}

impl<P: Parser, T: FTransformDeserializer> Deserializer<P, T>{
  #[inline]
  fn deserialize(&self, value: &[u8], max_len: Option<usize>) -> Result<FTransforms, ErrorCode>{
    let mut index = 0;

    let mut transforms = read_count!(
      self.count_type, self.parser, value, index, max_len,
      {
        U8   => read_u8,
        U16  => read_u16,
        U32  => read_u32,
        U64  => read_u64,
        U128 => read_u128,
      }
    );

    while index < value.len() {
      transforms.push(self.transform_deserializer.deserialize(&self.parser, value, &mut index)?);
    }

    Ok(transforms)
  }
}

impl<T: FTransformDeserializer> Deserializer<LeParser, T>{
  #[inline]
  fn le_with_ft_ser(count_type: CountType, ft_de: T) -> Self{
    Self{
      parser: LeParser{},
      count_type,
      transform_deserializer: ft_de,
    }
  }
}
impl Deserializer<LeParser, RTSDeserializer>{
  #[inline]
  fn le_rts(count_type: CountType) -> Self{
    Self{
      parser: LeParser{},
      count_type,
      transform_deserializer: RTSDeserializer{},
    }
  }
}
impl<T: FTransformDeserializer> Deserializer<BeParser, T>{
  #[inline]
  fn be_with_ft_ser(count_type: CountType, ft_de: T) -> Self{
    Self{
      parser: BeParser{},
      count_type,
      transform_deserializer: ft_de,
    }
  }
}




trait FTransformDeserializer{
  fn deserialize<P: Parser>(&self, parser: &P, input: &[u8], index: &mut usize) -> Result<FTransform, ErrorCode>;
  #[inline]
  fn deserialize_quat<P: Parser>(&self, parser: &P, input: &[u8], index: &mut usize) -> Result<FQuat, ErrorCode>{
    Ok(FQuat{
      x: parser.read_f64(input, index)?,
      y: parser.read_f64(input, index)?,
      z: parser.read_f64(input, index)?,
      w: parser.read_f64(input, index)?,
    })
  }
  #[inline]
  fn deserialize_vector<P: Parser>(&self, parser: &P, input: &[u8], index: &mut usize) -> Result<FVector, ErrorCode>{
    Ok(FVector{
      x: parser.read_f64(input, index)?,
      y: parser.read_f64(input, index)?,
      z: parser.read_f64(input, index)?,
    })
  }
}

struct RTSDeserializer{}
struct TRSDeserializer{}

impl FTransformDeserializer for RTSDeserializer{
  #[inline]
  fn deserialize<P: Parser>(&self, parser: &P, input: &[u8], index: &mut usize) -> Result<FTransform, ErrorCode>{
    Ok(FTransform{
      rotation: self.deserialize_quat(parser, input, index)?,
      translation: self.deserialize_vector(parser, input, index)?,
      scale: self.deserialize_vector(parser, input, index)?,
    })
  }
}
impl FTransformDeserializer for TRSDeserializer{
  #[inline]
  fn deserialize<P: Parser>(&self, parser: &P, input: &[u8], index: &mut usize) -> Result<FTransform, ErrorCode>{
    Ok(FTransform{
      translation: self.deserialize_vector(parser, input, index)?,
      rotation: self.deserialize_quat(parser, input, index)?,
      scale: self.deserialize_vector(parser, input, index)?,
    })
  }
}


trait Parser{
  fn read_u8(&self, input: &[u8], index: &mut usize) -> Result<u8, ErrorCode>;
  fn read_u16(&self, input: &[u8], index: &mut usize) -> Result<u16, ErrorCode>;
  fn read_u32(&self, input: &[u8], index: &mut usize) -> Result<u32, ErrorCode>;
  fn read_u64(&self, input: &[u8], index: &mut usize) -> Result<u64, ErrorCode>;
  fn read_u128(&self, input: &[u8], index: &mut usize) -> Result<u128, ErrorCode>;
  fn read_f32(&self, input: &[u8], index: &mut usize) -> Result<f32, ErrorCode>;
  fn read_f64(&self, input: &[u8], index: &mut usize) -> Result<f64, ErrorCode>;
}

macro_rules! __endian_from_bytes{
  (le, $type:ty, $bytes:expr) => {
    <$type>::from_le_bytes($bytes)
  };
  (be, $type:ty, $bytes:expr) => {
    <$type>::from_be_bytes($bytes)
  };
}
macro_rules! define_read{
  ($name:ident, $type:ty, $size:expr, $endian:tt) => {
    #[inline]
    fn $name(&self, input: &[u8], index: &mut usize) -> Result<$type, ErrorCode>{
      let bytes: [u8; $size] = input
        .get(*index..*index + $size)
        .ok_or(ErrorCode::BufferOverrun)?
        .try_into()
        .map_err(|_| ErrorCode::BufferOverrun)?;
      *index += $size;
      Ok(__endian_from_bytes!($endian, $type, bytes))
    }
  };
}

struct LeParser{}

impl Parser for LeParser{
  define_read!(read_u8, u8, 1, le);
  define_read!(read_u16, u16, 2, le);
  define_read!(read_u32, u32, 4, le);
  define_read!(read_u64, u64, 8, le);
  define_read!(read_u128, u128, 16, le);
  define_read!(read_f32, f32, 4, le);
  define_read!(read_f64, f64, 8, le);
}

struct BeParser{}

impl Parser for BeParser{
  define_read!(read_u8, u8, 1, be);
  define_read!(read_u16, u16, 2, be);
  define_read!(read_u32, u32, 4, be);
  define_read!(read_u64, u64, 8, be);
  define_read!(read_u128, u128, 16, be);
  define_read!(read_f32, f32, 4, be);
  define_read!(read_f64, f64, 8, be);
}


pub fn from_bytes(bytes: &[u8], format: FTransformFormat, max_len: Option<usize>) -> Result<FTransforms, ErrorCode>{
  Ok(match (format.endian, format.field_order){
    (Endianness::LE, FTransformFieldOrder::RTS) => Deserializer::le_rts(format.count_type).deserialize(bytes, max_len)?,
    (Endianness::LE, FTransformFieldOrder::TRS) => Deserializer::le_with_ft_ser(format.count_type, TRSDeserializer{}).deserialize(bytes, max_len)?,
    (Endianness::BE, FTransformFieldOrder::RTS) => Deserializer::be_with_ft_ser(format.count_type, RTSDeserializer{}).deserialize(bytes, max_len)?,
    (Endianness::BE, FTransformFieldOrder::TRS) => Deserializer::be_with_ft_ser(format.count_type, TRSDeserializer{}).deserialize(bytes, max_len)?,
  })
}

pub fn from_hex(bytes: &[u8], format: FTransformFormat, max_len: Option<usize>) -> Result<FTransforms, ErrorCode>{
  let mut dst = vec![0u8; bytes.len() / 2];
  hex_decode(bytes, &mut dst).map_err(|_| ErrorCode::InvalidHex)?;

  from_bytes(&dst, format, max_len)
}

#[test]
fn test(){
  let fts = from_hex(
    b"010000008CD651D50451BF3FDC68006F8104D5BF0000000000000000000000000000F03F91ED7C3F153BD040EE7C3F355E2A664066666666666CA540000000000000F03F000000000000F03F000000000000F03F",
    FTransformFormat{
      endian: Endianness::LE,
      field_order: FTransformFieldOrder::RTS,
      count_type: CountType::U32,
    },
    None,
  );
  if let Ok(ft) = &fts {
    println!("{}", ft[0].rotation.x);
    println!("{}", ft[0].rotation.y);
    println!("{}", ft[0].rotation.z);
    println!("{}", ft[0].rotation.w);
    println!("{}", ft[0].translation.x);
    println!("{}", ft[0].translation.y);
    println!("{}", ft[0].translation.z);
    println!("{}", ft[0].scale.x);
    println!("{}", ft[0].scale.y);
    println!("{}", ft[0].scale.z);
  }
}