use serde::{Deserialize, Serialize};
use super::image_custom_data;

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct ShareCode{
  #[serde(rename = "Content")]
  pub content: image_custom_data::DIYCustomData,
}

pub type DiyHistoryShareCodeBox = Vec<DiyHistoryShareCode>;

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct DiyHistoryShareCode{
  #[serde(rename = "RoleID")]
  pub role_id: String,

  #[serde(rename = "TimeStamp")]
  pub time_stamp: f64,

  #[serde(rename = "ShareCode")]
  pub share_code: String,
}