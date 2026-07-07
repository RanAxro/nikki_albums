use flutter_rust_bridge::frb;
use super::model::*;
use std::collections::HashMap;


#[frb(ignore)]
pub struct Nuan5Database<R: Nuan5DatabaseReader>{
  reader: R,
}

impl<R: Nuan5DatabaseReader> Nuan5Database<R>{
  pub fn is_open(&self) -> bool{
    self.reader.is_open()
  }

  pub fn open(&mut self, path: &str) -> bool{
    self.reader.open(path)
  }

  pub fn close(&mut self){
    self.reader.close()
  }

  pub fn has(&self, category: &Nuan5DatabaseCategory) -> bool{
    self.reader.has(category)
  }

  pub fn list(&self, category: &Nuan5DatabaseCategory, from: usize, max: isize) -> Vec<i64>{
    self.reader.list(category, from, max)
  }

  pub fn get(&self, category: &Nuan5DatabaseCategory, ids: &[i64]) -> HashMap<i64, Nuan5DatabaseItem>{
    self.reader.get(category, ids)
  }
}

pub trait Nuan5DatabaseReader{
  #[frb(sync)]
  fn is_open(&self) -> bool;
  fn open(&mut self, path: &str) -> bool;
  fn close(&mut self);
  fn has(&self, category: &Nuan5DatabaseCategory) -> bool;
  fn list(&self, category: &Nuan5DatabaseCategory, from: usize, max: isize) -> Vec<i64>;
  fn get(&self, category: &Nuan5DatabaseCategory, ids: &[i64]) -> HashMap<i64, Nuan5DatabaseItem>;
}

