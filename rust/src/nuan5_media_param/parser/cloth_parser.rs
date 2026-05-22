use super::super::structs::cloth::*;

const OUTFIT_SIZE: i64 = 4;
const CLOTH_TYPE_SIZE: i64 = 2;
const STATE_SIZE: i64 = 1;
const SPECIES_SIZE: i64 = 3;

pub fn parse_cloth(id: &i64) -> Cloth{
  let mut op_id = id.clone();

  let outfit = op_id % OUTFIT_SIZE;
  op_id /= OUTFIT_SIZE;

  let cloth_type = (op_id % CLOTH_TYPE_SIZE) as u8;
  op_id /= CLOTH_TYPE_SIZE;

  let state = (op_id % STATE_SIZE) as u8;
  op_id /= STATE_SIZE;

  let species = (op_id % SPECIES_SIZE) as u16;
  op_id /= SPECIES_SIZE;

  Cloth{
    id: id.clone(),
    outfit,
    species,
    cloth_type,
    state,
  }
}