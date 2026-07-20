use super::super::structs::cloth::*;

const OUTFIT_SIZE: i64 = 10000;
const CLOTH_TYPE_SIZE: i64 = 100;
const STATE_SIZE: i64 = 10;
const SPECIES_SIZE: i64 = 1000;

pub fn parse_cloth(id: &i64) -> Cloth{
  let mut op_id = id.clone();

  let outfit_feature = op_id % OUTFIT_SIZE;
  op_id /= OUTFIT_SIZE;

  let cloth_type = (op_id % CLOTH_TYPE_SIZE) as u8;
  op_id /= CLOTH_TYPE_SIZE;

  let state = (op_id % STATE_SIZE) as u8;
  op_id /= STATE_SIZE;

  let species = (op_id % SPECIES_SIZE) as u16;
  op_id /= SPECIES_SIZE;

  let outfit = get_outfit(outfit_feature, state);

  Cloth{
    id: id.clone(),
    outfit,
    species,
    cloth_type,
    state,
  }
}

fn get_outfit(outfit_feature: i64, state: u8) -> Option<i64>{
  if outfit_feature == 9042 && state == 0 {
    return Some(2018);
  }
  if outfit_feature == 304 && state == 7 {
    return Some(3030403);
  }

  match state{
    0 => Some(1 * OUTFIT_SIZE + outfit_feature),
    2 => Some((1 * OUTFIT_SIZE + outfit_feature) * 100 + 1),
    3 => Some((1 * OUTFIT_SIZE + outfit_feature) * 100 + 2),
    4 => Some((1 * OUTFIT_SIZE + outfit_feature) * 100 + 3),
    5 => Some((1 * OUTFIT_SIZE + outfit_feature) * 100 + 4),
    6 => Some(3 * OUTFIT_SIZE + outfit_feature),
    7 => Some(3 * OUTFIT_SIZE + outfit_feature),
    9 => Some(2 * OUTFIT_SIZE + outfit_feature),
    _ => None,
  }
}