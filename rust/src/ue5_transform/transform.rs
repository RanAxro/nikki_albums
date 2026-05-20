use serde::{Deserialize, Serialize};

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct FQuat{
  pub x: f64,
  pub y: f64,
  pub z: f64,
  pub w: f64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct FVector{
  pub x: f64,
  pub y: f64,
  pub z: f64,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct FTransform{
  pub rotation: FQuat,
  pub translation: FVector,
  pub scale: FVector,
}

pub type FTransforms = Vec<FTransform>;