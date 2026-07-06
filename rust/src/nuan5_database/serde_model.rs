use std::fmt;
use flutter_rust_bridge::frb;
use serde::{de, Deserialize, Deserializer};
use serde::de::{SeqAccess, Visitor};
use super::model::*;


impl<'de> Deserialize<'de> for Nuan5Light{
  #[frb(ignore)]
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>,
  {
    struct Nuan5LightVisitor;

    impl<'de> Visitor<'de> for Nuan5LightVisitor{
      type Value = Nuan5Light;

      fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result{
        formatter.write_str("Not Nuan5Light")
      }

      fn visit_seq<A>(self, mut seq: A) -> Result<Self::Value, A::Error>
      where
        A: SeqAccess<'de>,
      {
        let string_id = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(0, &self))?;

        Ok(Nuan5Light{
          string_id,
        })
      }
    }

    deserializer.deserialize_seq(Nuan5LightVisitor)
  }
}

impl<'de> Deserialize<'de> for Nuan5Filter{
  #[frb(ignore)]
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>,
  {
    struct Nuan5FilterVisitor;

    impl<'de> Visitor<'de> for Nuan5FilterVisitor{
      type Value = Nuan5Filter;

      fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result{
        formatter.write_str("Not Nuan5Filter")
      }

      fn visit_seq<A>(self, mut seq: A) -> Result<Self::Value, A::Error>
      where
        A: SeqAccess<'de>,
      {
        let string_id = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(0, &self))?;

        Ok(Nuan5Filter{
          string_id,
        })
      }
    }

    deserializer.deserialize_seq(Nuan5FilterVisitor)
  }
}

impl<'de> Deserialize<'de> for Nuan5ClothDyeArea{
  #[frb(ignore)]
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>,
  {
    struct Nuan5ClothDyeAreaVisitor;

    impl<'de> Visitor<'de> for Nuan5ClothDyeAreaVisitor{
      type Value = Nuan5ClothDyeArea;

      fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result{
        formatter.write_str("Not Nuan5ClothDyeArea")
      }

      fn visit_seq<A>(self, mut seq: A) -> Result<Self::Value, A::Error>
      where
        A: SeqAccess<'de>,
      {
        let max_color_area_num = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(0, &self))?;
        let max_pattern_area_num = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(1, &self))?;
        let max_pattern_mask_num = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(2, &self))?;

        Ok(Nuan5ClothDyeArea{
          max_color_area_num,
          max_pattern_area_num,
          max_pattern_mask_num,
        })
      }
    }

    deserializer.deserialize_seq(Nuan5ClothDyeAreaVisitor)
  }
}

impl<'de> Deserialize<'de> for Nuan5ClothDyePalette{
  #[frb(ignore)]
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>,
  {
    struct Nuan5ClothDyePaletteVisitor;

    impl<'de> Visitor<'de> for Nuan5ClothDyePaletteVisitor{
      type Value = Nuan5ClothDyePalette;

      fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result{
        formatter.write_str("Not Nuan5ClothDyePalette")
      }

      fn visit_seq<A>(self, mut seq: A) -> Result<Self::Value, A::Error>
      where
        A: SeqAccess<'de>,
      {
        let directly = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(0, &self))?;
        let complete = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(1, &self))?;
        let grow_up = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(2, &self))?;
        let evolution_1 = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(3, &self))?;
        let evolution_2 = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(4, &self))?;

        Ok(Nuan5ClothDyePalette{
          directly,
          complete,
          grow_up,
          evolution_1,
          evolution_2,
        })
      }
    }

    deserializer.deserialize_seq(Nuan5ClothDyePaletteVisitor)
  }
}

impl<'de> Deserialize<'de> for Nuan5ClothDiySwatchColor{
  #[frb(ignore)]
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>,
  {
    struct Nuan5ClothDiySwatchColorVisitor;

    impl<'de> Visitor<'de> for Nuan5ClothDiySwatchColorVisitor{
      type Value = Nuan5ClothDiySwatchColor;

      fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result{
        formatter.write_str("Not Nuan5ClothDiySwatchColor")
      }

      fn visit_seq<A>(self, mut seq: A) -> Result<Self::Value, A::Error>
      where
        A: SeqAccess<'de>,
      {
        let r = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(0, &self))?;
        let g = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(1, &self))?;
        let b = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(2, &self))?;
        let a = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(3, &self))?;

        Ok(Nuan5ClothDiySwatchColor{
          r, g, b, a
        })
      }
    }

    deserializer.deserialize_seq(Nuan5ClothDiySwatchColorVisitor)
  }
}
