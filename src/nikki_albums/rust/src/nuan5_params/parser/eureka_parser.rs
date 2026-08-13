use super::super::structs::eureka::Eureka;

const COLOR_SIZE: i64 = 10;
const LEVEL_SIZE: i64 = 10;
const ATTACHMENT_POINT_SIZE: i64 = 10;

pub fn parse_eureka(id: &i64) -> Eureka{
  let mut op_id = id.clone();

  let color = (op_id % COLOR_SIZE) as u8;
  op_id /= COLOR_SIZE;

  let level = (op_id % LEVEL_SIZE) as u8;
  op_id /= LEVEL_SIZE;

  let attachment_point = (op_id % ATTACHMENT_POINT_SIZE) as u8;
  op_id /= ATTACHMENT_POINT_SIZE;

  Eureka{
    id: id.clone(),
    outfit: op_id,
    attachment_point,
    level,
    color,
  }
}