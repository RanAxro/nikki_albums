use super::nikki_photo_params::NikkiPhotoParams;

#[derive(Clone)]
pub struct CollageParams{
  pub template_id: i64,
  pub region_pictures: Vec<RegionPicture>,
}

#[derive(Clone)]
pub struct RegionPicture{
  pub position: (f64, f64),
  pub rotation: f64,
  pub scale: f64,
  pub image_id: String,
  pub ori_custom_data: NikkiPhotoParams,
}