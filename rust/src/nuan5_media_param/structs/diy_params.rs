use std::collections::HashMap;
use super::nikki_photo_params::ClothParams;


#[derive(Clone)]
pub struct DiyParams{
  pub pose_id: Option<i64>,
  pub pattern_data: HashMap<i64, i64>,
  pub clothes: Vec<ClothParams>,
}