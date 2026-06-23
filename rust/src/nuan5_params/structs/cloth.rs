
#[derive(Clone)]
pub struct Cloth{
  pub id: i64,
  pub outfit: Option<i64>,
  pub species: u16,
  pub cloth_type: u8,
  pub state: u8,
}