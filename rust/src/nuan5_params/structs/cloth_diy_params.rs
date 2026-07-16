use std::collections::HashMap;
use super::nikki_photo_params::ClothParams;

#[derive(Clone)]
pub struct ClothDiyParams{
  pub pose_id: Option<i64>,
  pub pattern_data: HashMap<i64, i64>,
  pub clothes: Vec<ClothParams>,
}

pub type DiyHistoryShareCodeParamsBox = Vec<DiyHistoryShareCodeParams>;

#[derive(Clone)]
pub struct DiyHistoryShareCodeParams{
  pub role_id: String,
  pub time_stamp: f64,
  pub share_code: String,
}

#[derive(Clone)]
pub struct ClothDiyQrCodeParams{
  pub share_code: String,
}