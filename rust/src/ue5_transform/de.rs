use super::{CountType, Endianness, FTransformFieldOrder, ErrorCode};
use super::transform::*;
use super::FTransformFormat;
use faster_hex::hex_decode;

struct Deserializer<P: Parser, T: FTransformDeserializer>{
  parser: P,
  count_type: CountType,
  transform_deserializer: T,
}

impl<P: Parser, T: FTransformDeserializer> Deserializer<P, T>{
  #[inline]
  fn deserialize(&mut self, value: &[u8], max_len: Option<usize>) -> Result<FTransforms, ErrorCode>{
    let mut index = 0;

    let mut transforms = match self.count_type{
      CountType::U16 => {
        let len = self.parser.read_u16(value, &mut index)?;
        if let Some(max) = max_len {
          if len as usize > max {
            return Err(ErrorCode::BufferOverrun);
          }
        }
        Vec::with_capacity(len as usize)
      },
      CountType::U32 => {
        let len = self.parser.read_u32(value, &mut index)?;
        if let Some(max) = max_len {
          if len as usize > max {
            return Err(ErrorCode::BufferOverrun);
          }
        }
        Vec::with_capacity(len as usize)
      },
      CountType::U64 => {
        let len = self.parser.read_u64(value, &mut index)?;
        if let Some(max) = max_len {
          if len as usize > max {
            return Err(ErrorCode::BufferOverrun);
          }
        }
        Vec::with_capacity(len as usize)
      },
      CountType::None => Vec::new(),
    };

    while index < value.len() {
      transforms.push(self.transform_deserializer.deserialize(&mut self.parser, value, &mut index)?);
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
  fn deserialize<P: Parser>(&mut self, parser: &mut P, input: &[u8], index: &mut usize) -> Result<FTransform, ErrorCode>;
  #[inline]
  fn deserialize_quat<P: Parser>(&mut self, parser: &mut P, input: &[u8], index: &mut usize) -> Result<FQuat, ErrorCode>{
    Ok(FQuat{
      x: parser.read_f64(input, index)?,
      y: parser.read_f64(input, index)?,
      z: parser.read_f64(input, index)?,
      w: parser.read_f64(input, index)?,
    })
  }
  #[inline]
  fn deserialize_vector<P: Parser>(&mut self, parser: &mut P, input: &[u8], index: &mut usize) -> Result<FVector, ErrorCode>{
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
  fn deserialize<P: Parser>(&mut self, parser: &mut P, input: &[u8], index: &mut usize) -> Result<FTransform, ErrorCode>{
    Ok(FTransform{
      rotation: self.deserialize_quat(parser, input, index)?,
      translation: self.deserialize_vector(parser, input, index)?,
      scale: self.deserialize_vector(parser, input, index)?,
    })
  }
}
impl FTransformDeserializer for TRSDeserializer{
  #[inline]
  fn deserialize<P: Parser>(&mut self, parser: &mut P, input: &[u8], index: &mut usize) -> Result<FTransform, ErrorCode>{
    Ok(FTransform{
      translation: self.deserialize_vector(parser, input, index)?,
      rotation: self.deserialize_quat(parser, input, index)?,
      scale: self.deserialize_vector(parser, input, index)?,
    })
  }
}


trait Parser{
  fn read_u8(&mut self, input: &[u8], index: &mut usize) -> Result<u8, ErrorCode>;
  fn read_u16(&mut self, input: &[u8], index: &mut usize) -> Result<u16, ErrorCode>;
  fn read_u32(&mut self, input: &[u8], index: &mut usize) -> Result<u32, ErrorCode>;
  fn read_u64(&mut self, input: &[u8], index: &mut usize) -> Result<u64, ErrorCode>;
  fn read_u128(&mut self, input: &[u8], index: &mut usize) -> Result<u128, ErrorCode>;
  fn read_f32(&mut self, input: &[u8], index: &mut usize) -> Result<f32, ErrorCode>;
  fn read_f64(&mut self, input: &[u8], index: &mut usize) -> Result<f64, ErrorCode>;
}

struct LeParser{}

impl Parser for LeParser{
  #[inline]
  fn read_u8(&mut self, input: &[u8], index: &mut usize) -> Result<u8, ErrorCode>{
    let bytes: [u8; 1] = input.get(*index..*index + 1)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 1;
    Ok(u8::from_le_bytes(bytes))
  }
  #[inline]
  fn read_u16(&mut self, input: &[u8], index: &mut usize) -> Result<u16, ErrorCode>{
    let bytes: [u8; 2] = input.get(*index..*index + 2)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 2;
    Ok(u16::from_le_bytes(bytes))
  }
  #[inline]
  fn read_u32(&mut self, input: &[u8], index: &mut usize) -> Result<u32, ErrorCode>{
    let bytes: [u8; 4] = input.get(*index..*index + 4)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 4;
    Ok(u32::from_le_bytes(bytes))
  }
  #[inline]
  fn read_u64(&mut self, input: &[u8], index: &mut usize) -> Result<u64, ErrorCode>{
    let bytes: [u8; 8] = input.get(*index..*index + 8)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 8;
    Ok(u64::from_le_bytes(bytes))
  }
  #[inline]
  fn read_u128(&mut self, input: &[u8], index: &mut usize) -> Result<u128, ErrorCode>{
    let bytes: [u8; 16] = input.get(*index..*index + 16)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 16;
    Ok(u128::from_le_bytes(bytes))
  }
  #[inline]
  fn read_f32(&mut self, input: &[u8], index: &mut usize) -> Result<f32, ErrorCode>{
    let bytes: [u8; 4] = input.get(*index..*index + 4)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 4;
    Ok(f32::from_le_bytes(bytes))
  }
  #[inline]
  fn read_f64(&mut self, input: &[u8], index: &mut usize) -> Result<f64, ErrorCode>{
    let bytes: [u8; 8] = input.get(*index..*index + 8)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 8;
    Ok(f64::from_le_bytes(bytes))
  }
}

struct BeParser{}

impl Parser for BeParser{
  #[inline]
  fn read_u8(&mut self, input: &[u8], index: &mut usize) -> Result<u8, ErrorCode>{
    let bytes: [u8; 1] = input.get(*index..*index + 1)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 1;
    Ok(u8::from_be_bytes(bytes))
  }
  #[inline]
  fn read_u16(&mut self, input: &[u8], index: &mut usize) -> Result<u16, ErrorCode>{
    let bytes: [u8; 2] = input.get(*index..*index + 2)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 2;
    Ok(u16::from_be_bytes(bytes))
  }
  #[inline]
  fn read_u32(&mut self, input: &[u8], index: &mut usize) -> Result<u32, ErrorCode>{
    let bytes: [u8; 4] = input.get(*index..*index + 4)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 4;
    Ok(u32::from_be_bytes(bytes))
  }
  #[inline]
  fn read_u64(&mut self, input: &[u8], index: &mut usize) -> Result<u64, ErrorCode>{
    let bytes: [u8; 8] = input.get(*index..*index + 8)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 8;
    Ok(u64::from_be_bytes(bytes))
  }
  #[inline]
  fn read_u128(&mut self, input: &[u8], index: &mut usize) -> Result<u128, ErrorCode>{
    let bytes: [u8; 16] = input.get(*index..*index + 16)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 16;
    Ok(u128::from_be_bytes(bytes))
  }
  #[inline]
  fn read_f32(&mut self, input: &[u8], index: &mut usize) -> Result<f32, ErrorCode>{
    let bytes: [u8; 4] = input.get(*index..*index + 4)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 4;
    Ok(f32::from_be_bytes(bytes))
  }
  #[inline]
  fn read_f64(&mut self, input: &[u8], index: &mut usize) -> Result<f64, ErrorCode>{
    let bytes: [u8; 8] = input.get(*index..*index + 8)
      .ok_or(ErrorCode::BufferOverrun)?
      .try_into()
      .map_err(|_| ErrorCode::BufferOverrun)?;
    *index += 8;
    Ok(f64::from_be_bytes(bytes))
  }
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
    b"0100000033333333333305406666666666661140713D0AD7A37024C0000000000000F03F91ED7C3F153BD040EE7C3F355E2A664066666666666CA540000000000000F03F000000000000F03F000000000000F03F",
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