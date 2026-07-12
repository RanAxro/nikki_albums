
#[derive(Clone)]
pub struct RichBuildingParams{
  pub name: String,
  pub cover_image: Option<String>,
  pub map_id: i32,
  pub last_modify_time: i64,
  pub uid: i64,
  pub game_area: String,
  pub template_type: i32,
  pub furniture_count: i32,
  pub version: Option<String>,
}

#[derive(Clone)]
pub struct BuildingParams{
  pub furniture_count: i32,
}