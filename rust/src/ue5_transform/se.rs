use crate::ue5_transform::{CountType, Endianness, FTransformFieldOrder};
use super::transform::*;
use super::FTransformFormat;
use faster_hex::{hex_string, hex_string_upper};

type Output = Vec<u8>;


struct Serializer<F: Formatter, T: FTransformSerializer>{
  formatter: F,
  count_type: CountType,
  transform_serializer: T,
}

impl<F: Formatter, T: FTransformSerializer> Serializer<F, T>{
  #[inline]
  fn new(formatter: F, count_type: CountType, ft_ser: T) -> Self{
    Self{
      formatter,
      count_type,
      transform_serializer: ft_ser,
    }
  }
}
impl<T: FTransformSerializer> Serializer<LeFormatter, T>{
  #[inline]
  fn le_with_ft_ser(count_type: CountType, ft_ser: T) -> Self{
    Self{
      formatter: LeFormatter{},
      count_type,
      transform_serializer: ft_ser,
    }
  }
}
impl Serializer<LeFormatter, RTSSerializer>{
  #[inline]
  fn le_rts(count_type: CountType) -> Self{
    Self{
      formatter: LeFormatter{},
      count_type,
      transform_serializer: RTSSerializer{},
    }
  }
}
impl<T: FTransformSerializer> Serializer<BeFormatter, T>{
  #[inline]
  fn be_with_ft_ser(count_type: CountType, ft_ser: T) -> Self{
    Self{
      formatter: BeFormatter{},
      count_type,
      transform_serializer: ft_ser,
    }
  }
}

impl<F: Formatter, T: FTransformSerializer> Serializer<F, T>{
  #[inline]
  fn serialize(&self, value: &FTransforms) -> Output{
    let mut output = Output::new();

    match self.count_type{
      CountType::U8 => self.formatter.write_u8(&mut output, value.len() as u8),
      CountType::U16 => self.formatter.write_u16(&mut output, value.len() as u16),
      CountType::U32 => self.formatter.write_u32(&mut output, value.len() as u32),
      CountType::U64 => self.formatter.write_u64(&mut output, value.len() as u64),
      CountType::U128 => self.formatter.write_u128(&mut output, value.len() as u128),
      CountType::None => {},
    };

    for transform in value{
      self.transform_serializer.serialize(&self.formatter, &mut output, transform);
    }

    output
  }
}




trait FTransformSerializer{
  fn serialize<F: Formatter>(&self, formatter: &F, output: &mut Output, value: &FTransform);
  #[inline]
  fn serialize_quat<F: Formatter>(&self, formatter: &F, output: &mut Output, value: &FQuat){
    formatter.write_f64(output, value.x);
    formatter.write_f64(output, value.y);
    formatter.write_f64(output, value.z);
    formatter.write_f64(output, value.w);
  }
  #[inline]
  fn serialize_vector<F: Formatter>(&self, formatter: &F, output: &mut Output, value: &FVector){
    formatter.write_f64(output, value.x);
    formatter.write_f64(output, value.y);
    formatter.write_f64(output, value.z);
  }
}

struct RTSSerializer{}
struct TRSSerializer{}

impl FTransformSerializer for RTSSerializer{
  #[inline]
  fn serialize<F: Formatter>(&self, formatter: &F, output: &mut Output, value: &FTransform){
    self.serialize_quat(formatter, output, &value.rotation);
    self.serialize_vector(formatter, output, &value.translation);
    self.serialize_vector(formatter, output, &value.scale);
  }
}
impl FTransformSerializer for TRSSerializer{
  #[inline]
  fn serialize<F: Formatter>(&self, formatter: &F, output: &mut Output, value: &FTransform){
    self.serialize_vector(formatter, output, &value.translation);
    self.serialize_quat(formatter, output, &value.rotation);
    self.serialize_vector(formatter, output, &value.scale);
  }
}


trait Formatter{
  fn write_u8(&self, output: &mut Output, value: u8);
  fn write_u16(&self, output: &mut Output, value: u16);
  fn write_u32(&self, output: &mut Output, value: u32);
  fn write_u64(&self, output: &mut Output, value: u64);
  fn write_u128(&self, output: &mut Output, value: u128);
  fn write_f32(&self, output: &mut Output, value: f32);
  fn write_f64(&self, output: &mut Output, value: f64);
}

struct LeFormatter{}
impl Formatter for LeFormatter{
  #[inline]
  fn write_u8(&self, output: &mut Output, value: u8){
    output.extend_from_slice(&value.to_le_bytes());
  }
  #[inline]
  fn write_u16(&self, output: &mut Output, value: u16){
    output.extend_from_slice(&value.to_le_bytes());
  }
  #[inline]
  fn write_u32(&self, output: &mut Output, value: u32){
    output.extend_from_slice(&value.to_le_bytes());
  }
  #[inline]
  fn write_u64(&self, output: &mut Output, value: u64){
    output.extend_from_slice(&value.to_le_bytes());
  }
  #[inline]
  fn write_u128(&self, output: &mut Output, value: u128){
    output.extend_from_slice(&value.to_le_bytes());
  }
  #[inline]
  fn write_f32(&self, output: &mut Output, value: f32){
    output.extend_from_slice(&value.to_le_bytes());
  }
  #[inline]
  fn write_f64(&self, output: &mut Output, value: f64){
    output.extend_from_slice(&value.to_le_bytes());
  }
}


struct BeFormatter{}
impl Formatter for BeFormatter{
  #[inline]
  fn write_u8(&self, output: &mut Output, value: u8){
    output.extend_from_slice(&value.to_be_bytes());
  }
  #[inline]
  fn write_u16(&self, output: &mut Output, value: u16){
    output.extend_from_slice(&value.to_be_bytes());
  }
  #[inline]
  fn write_u32(&self, output: &mut Output, value: u32){
    output.extend_from_slice(&value.to_be_bytes());
  }
  #[inline]
  fn write_u64(&self, output: &mut Output, value: u64){
    output.extend_from_slice(&value.to_be_bytes());
  }
  #[inline]
  fn write_u128(&self, output: &mut Output, value: u128){
    output.extend_from_slice(&value.to_be_bytes());
  }
  #[inline]
  fn write_f32(&self, output: &mut Output, value: f32){
    output.extend_from_slice(&value.to_be_bytes());
  }
  #[inline]
  fn write_f64(&self, output: &mut Output, value: f64){
    output.extend_from_slice(&value.to_be_bytes());
  }
}


pub fn to_bytes(transforms: &FTransforms, format: FTransformFormat) -> Output{
  match (format.endian, format.field_order){
    (Endianness::LE, FTransformFieldOrder::RTS) => Serializer::le_rts(format.count_type).serialize(transforms),
    (Endianness::LE, FTransformFieldOrder::TRS) => Serializer::le_with_ft_ser(format.count_type, TRSSerializer{}).serialize(transforms),
    (Endianness::BE, FTransformFieldOrder::RTS) => Serializer::be_with_ft_ser(format.count_type, RTSSerializer{}).serialize(transforms),
    (Endianness::BE, FTransformFieldOrder::TRS) => Serializer::be_with_ft_ser(format.count_type, TRSSerializer{}).serialize(transforms),
  }
}

pub fn to_hex(transforms: &FTransforms, format: FTransformFormat) -> String{
  let output = to_bytes(transforms, format);
  hex_string(&output)
}

pub fn to_hex_upper(transforms: &FTransforms, format: FTransformFormat) -> String{
  let output = to_bytes(transforms, format);
  hex_string_upper(&output)
}

#[test]
fn test(){
  let transforms = vec![
    FTransform{
      rotation: FQuat{x: 0.12233, y: -0.3284, z: 0.0, w: 1.0},
      translation: FVector{x: 16620.332, y: 177.324, z: 2742.2},
      scale: FVector{x: 1.0, y: 1.0, z: 1.0},
    }
  ];

  let res = to_hex_upper(&transforms, FTransformFormat{
    endian: Endianness::LE,
    field_order: FTransformFieldOrder::RTS,
    count_type: CountType::U32,
  });

  // 010000008CD651D50451BF3FDC68006F8104D5BF0000000000000000000000000000F03F91ED7C3F153BD040EE7C3F355E2A664066666666666CA540000000000000F03F000000000000F03F000000000000F03F
  println!("{}", res);
}