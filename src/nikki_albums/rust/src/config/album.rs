use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub enum AlbumSliverType{
  Grid,
  WaterfallFlow,
}

#[derive(Serialize, Deserialize)]
pub enum AlbumGridOrientation{
  Portrait,
  Landscape,
}

#[derive(Serialize, Deserialize)]
pub enum AlbumGridAspectRatio{
  Grid11,
  Grid32,
  Grid43,
  Grid169,
}

#[derive(Serialize, Deserialize)]
pub enum AlbumDensity{
  Compact,
  Spacious,
}