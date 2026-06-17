use super::super::structs::cloth::*;

const OUTFIT_SIZE: i64 = 10000;
const CLOTH_TYPE_SIZE: i64 = 100;
const STATE_SIZE: i64 = 10;
const SPECIES_SIZE: i64 = 1000;

pub fn parse_cloth(id: &i64) -> Cloth{
  let mut op_id = id.clone();

  let mut outfit = OUTFIT_SIZE + op_id % OUTFIT_SIZE;
  op_id /= OUTFIT_SIZE;

  let cloth_type = (op_id % CLOTH_TYPE_SIZE) as u8;
  op_id /= CLOTH_TYPE_SIZE;

  let state = (op_id % STATE_SIZE) as u8;
  op_id /= STATE_SIZE;

  let species = (op_id % SPECIES_SIZE) as u16;
  op_id /= SPECIES_SIZE;

  outfit = get_complete_outfit(outfit, state);

  Cloth{
    id: id.clone(),
    outfit,
    species,
    cloth_type,
    state,
  }
}

fn get_complete_outfit(outfit: i64, state: u8) -> i64{
  match state{
    2 => outfit * 100 + 1,
    3 => outfit * 100 + 2,
    4 => outfit * 100 + 3,
    5 => outfit * 100 + 4,
    _ => outfit,
  }
}