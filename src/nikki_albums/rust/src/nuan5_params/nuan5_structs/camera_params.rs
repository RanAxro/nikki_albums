use serde::{Deserialize, Deserializer, Serialize, Serializer};
use serde::de::{self, SeqAccess, Visitor};
use serde::ser::SerializeSeq;
use std::fmt;



#[derive(Debug)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum CameraParams{
  V1(CameraParamsV1),
  V2(CameraParamsV2),
}



/// V1
#[derive(Debug)]
pub struct CameraParamsV1{
  pub flag: i64,                        // 1

  pub portrait_mode: i64,               // 2

  pub dx_camera_actor: f64,             // 3
  pub dy_camera_actor: f64,             // 4
  pub dz_camera_actor: f64,             // 5
  pub d_pitch_camera_actor: f64,        // 6
  pub d_yaw_camera_actor: f64,          // 7

  pub mode: i64,                        // 8

  pub dx_camera_component: f64,         // 9
  pub dy_camera_component: f64,         // 10
  pub dz_camera_component: f64,         // 11
  pub d_pitch_camera_component: f64,    // 12
  pub d_yaw_camera_component: f64,      // 13

  pub d_roll_camera_actor: f64,         // 14

  pub camera_focal_length: f64,         // 15
  pub aperture_section: u8,             // 16

  pub d_roll_camera_component: f64,     // 17

  pub light_id: String,                 // 18
  pub light_strength: f64,              // 19

  pub vignette_intensity: f64,          // 20
  pub bloom_intensity: f64,             // 21
  pub bloom_threshold: f64,             // 22
  pub brightness: f64,                  // 23
  pub exposure: f64,                    // 24
  pub contrast: f64,                    // 25
  pub saturation: f64,                  // 26
  pub vibrance: f64,                    // 27
  pub highlights: f64,                  // 28
  pub shadows: f64,                     // 29

  pub filter_id: String,                // 30
  pub filter_strength: f64,             // 31
}

impl Serialize for CameraParamsV1{
  fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
  where
    S: Serializer,
  {
    let mut seq = serializer.serialize_seq(Some(31))?;
    seq.serialize_element(&self.flag)?;
    seq.serialize_element(&self.portrait_mode)?;
    seq.serialize_element(&self.dx_camera_actor)?;
    seq.serialize_element(&self.dy_camera_actor)?;
    seq.serialize_element(&self.dz_camera_actor)?;
    seq.serialize_element(&self.d_pitch_camera_actor)?;
    seq.serialize_element(&self.d_yaw_camera_actor)?;
    seq.serialize_element(&self.mode)?;
    seq.serialize_element(&self.dx_camera_component)?;
    seq.serialize_element(&self.dy_camera_component)?;
    seq.serialize_element(&self.dz_camera_component)?;
    seq.serialize_element(&self.d_pitch_camera_component)?;
    seq.serialize_element(&self.d_yaw_camera_component)?;
    seq.serialize_element(&self.d_roll_camera_actor)?;
    seq.serialize_element(&self.camera_focal_length)?;
    seq.serialize_element(&self.aperture_section)?;
    seq.serialize_element(&self.d_roll_camera_component)?;
    seq.serialize_element(&self.light_id)?;
    seq.serialize_element(&self.light_strength)?;
    seq.serialize_element(&self.vignette_intensity)?;
    seq.serialize_element(&self.bloom_intensity)?;
    seq.serialize_element(&self.bloom_threshold)?;
    seq.serialize_element(&self.brightness)?;
    seq.serialize_element(&self.exposure)?;
    seq.serialize_element(&self.contrast)?;
    seq.serialize_element(&self.saturation)?;
    seq.serialize_element(&self.vibrance)?;
    seq.serialize_element(&self.highlights)?;
    seq.serialize_element(&self.shadows)?;
    seq.serialize_element(&self.filter_id)?;
    seq.serialize_element(&self.filter_strength)?;
    seq.end()
  }
}

impl<'de> Deserialize<'de> for CameraParamsV1{
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>,
  {
    struct CameraParamsV1Visitor;

    impl<'de> Visitor<'de> for CameraParamsV1Visitor{
      type Value = CameraParamsV1;

      fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result{
        formatter.write_str("a sequence of 31 elements representing CameraParams")
      }

      fn visit_seq<A>(self, mut seq: A) -> Result<Self::Value, A::Error>
      where
        A: SeqAccess<'de>,
      {
        let flag = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(0, &self))?;
        let portrait_mode = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(1, &self))?;
        let dx_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(2, &self))?;
        let dy_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(3, &self))?;
        let dz_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(4, &self))?;
        let d_pitch_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(5, &self))?;
        let d_yaw_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(6, &self))?;
        let mode = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(7, &self))?;
        let dx_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(8, &self))?;
        let dy_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(9, &self))?;
        let dz_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(10, &self))?;
        let d_pitch_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(11, &self))?;
        let d_yaw_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(12, &self))?;
        let d_roll_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(13, &self))?;
        let camera_focal_length = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(14, &self))?;
        let aperture_section = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(15, &self))?;
        let d_roll_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(16, &self))?;
        let light_id = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(17, &self))?;
        let light_strength = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(18, &self))?;
        let vignette_intensity = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(19, &self))?;
        let bloom_intensity = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(20, &self))?;
        let bloom_threshold = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(21, &self))?;
        let brightness = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(22, &self))?;
        let exposure = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(23, &self))?;
        let contrast = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(24, &self))?;
        let saturation = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(25, &self))?;
        let vibrance = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(26, &self))?;
        let highlights = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(27, &self))?;
        let shadows = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(28, &self))?;
        let filter_id = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(29, &self))?;
        let filter_strength = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(30, &self))?;

        Ok(CameraParamsV1{
          flag, portrait_mode, dx_camera_actor, dy_camera_actor, dz_camera_actor,
          d_pitch_camera_actor, d_yaw_camera_actor, mode, dx_camera_component,
          dy_camera_component, dz_camera_component, d_pitch_camera_component,
          d_yaw_camera_component, d_roll_camera_actor, camera_focal_length,
          aperture_section, d_roll_camera_component, light_id, light_strength,
          vignette_intensity, bloom_intensity, bloom_threshold, brightness,
          exposure, contrast, saturation, vibrance, highlights, shadows,
          filter_id, filter_strength,
        })
      }
    }

    deserializer.deserialize_seq(CameraParamsV1Visitor)
  }
}



/// V2

#[derive(Debug)]
pub struct CameraParamsV2{
  pub flag: i64,                        // 1

  pub portrait_mode: i64,               // 2

  pub dx_camera_actor: f64,             // 3
  pub dy_camera_actor: f64,             // 4
  pub dz_camera_actor: f64,             // 5
  pub d_pitch_camera_actor: f64,        // 6
  pub d_yaw_camera_actor: f64,          // 7

  pub mode: i64,                        // 8

  pub dx_camera_component: f64,         // 9
  pub dy_camera_component: f64,         // 10
  pub dz_camera_component: f64,         // 11
  pub d_pitch_camera_component: f64,    // 12
  pub d_yaw_camera_component: f64,      // 13

  pub d_roll_camera_actor: f64,         // 14

  pub camera_focal_length: f64,         // 15
  pub aperture_section: u8,             // 16

  pub d_roll_camera_component: f64,     // 17

  pub light_id: String,                 // 18
  pub light_strength: f64,              // 19

  pub vignette_intensity: f64,          // 20
  pub bloom_intensity: f64,             // 21
  pub bloom_threshold: f64,             // 22
  pub brightness: f64,                  // 23
  pub exposure: f64,                    // 24
  pub contrast: f64,                    // 25
  pub saturation: f64,                  // 26
  pub vibrance: f64,                    // 27
  pub highlights: f64,                  // 28
  pub shadows: f64,                     // 29

  pub filter_id: String,                // 30
  pub filter_strength: f64,             // 31

  pub momo: CameraParamsV2MomoHidden,   // 32
}

#[derive(Debug)]
pub enum CameraParamsV2MomoHidden{
  Enable,
  Disable{
    momo_pose: i64,                     // 33
    horizontal: f64,                    // 34
    distance: f64,                      // 35
    height: f64,                        // 36
    rotate_momo: f64,                   // 37
    auto_ground_snap: u8,               // 38
    floating_effect: u8,                // 39
    pose_with_nikki: u8,                // 40
  },
}

impl Serialize for CameraParamsV2{
  fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
  where
    S: Serializer,
  {
    let mut seq = serializer.serialize_seq(Some(match &self.momo{
      CameraParamsV2MomoHidden::Enable => 32,
      CameraParamsV2MomoHidden::Disable{ .. } => 40,
    }))?;
    seq.serialize_element(&self.flag)?;
    seq.serialize_element(&self.portrait_mode)?;
    seq.serialize_element(&self.dx_camera_actor)?;
    seq.serialize_element(&self.dy_camera_actor)?;
    seq.serialize_element(&self.dz_camera_actor)?;
    seq.serialize_element(&self.d_pitch_camera_actor)?;
    seq.serialize_element(&self.d_yaw_camera_actor)?;
    seq.serialize_element(&self.mode)?;
    seq.serialize_element(&self.dx_camera_component)?;
    seq.serialize_element(&self.dy_camera_component)?;
    seq.serialize_element(&self.dz_camera_component)?;
    seq.serialize_element(&self.d_pitch_camera_component)?;
    seq.serialize_element(&self.d_yaw_camera_component)?;
    seq.serialize_element(&self.d_roll_camera_actor)?;
    seq.serialize_element(&self.camera_focal_length)?;
    seq.serialize_element(&self.aperture_section)?;
    seq.serialize_element(&self.d_roll_camera_component)?;
    seq.serialize_element(&self.light_id)?;
    seq.serialize_element(&self.light_strength)?;
    seq.serialize_element(&self.vignette_intensity)?;
    seq.serialize_element(&self.bloom_intensity)?;
    seq.serialize_element(&self.bloom_threshold)?;
    seq.serialize_element(&self.brightness)?;
    seq.serialize_element(&self.exposure)?;
    seq.serialize_element(&self.contrast)?;
    seq.serialize_element(&self.saturation)?;
    seq.serialize_element(&self.vibrance)?;
    seq.serialize_element(&self.highlights)?;
    seq.serialize_element(&self.shadows)?;
    seq.serialize_element(&self.filter_id)?;
    seq.serialize_element(&self.filter_strength)?;
    seq.serialize_element(match &self.momo{
      CameraParamsV2MomoHidden::Enable => &0u8,
      CameraParamsV2MomoHidden::Disable{ .. } => &1u8,
    })?;
    match &self.momo{
      CameraParamsV2MomoHidden::Enable => {},
      CameraParamsV2MomoHidden::Disable{
        momo_pose,
        horizontal,
        distance,
        height,
        rotate_momo,
        auto_ground_snap,
        floating_effect,
        pose_with_nikki,
      } => {
        seq.serialize_element(momo_pose)?;
        seq.serialize_element(horizontal)?;
        seq.serialize_element(distance)?;
        seq.serialize_element(height)?;
        seq.serialize_element(rotate_momo)?;
        seq.serialize_element(auto_ground_snap)?;
        seq.serialize_element(floating_effect)?;
        seq.serialize_element(pose_with_nikki)?;
      },
    };
    seq.end()
  }
}

impl<'de> Deserialize<'de> for CameraParamsV2{
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>,
  {
    struct CameraParamsV2Visitor;

    impl<'de> Visitor<'de> for CameraParamsV2Visitor{
      type Value = CameraParamsV2;

      fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result{
        formatter.write_str("a sequence of 31 elements representing CameraParams")
      }

      fn visit_seq<A>(self, mut seq: A) -> Result<Self::Value, A::Error>
      where
        A: SeqAccess<'de>,
      {
        let flag = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(0, &self))?;
        let portrait_mode = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(1, &self))?;
        let dx_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(2, &self))?;
        let dy_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(3, &self))?;
        let dz_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(4, &self))?;
        let d_pitch_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(5, &self))?;
        let d_yaw_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(6, &self))?;
        let mode = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(7, &self))?;
        let dx_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(8, &self))?;
        let dy_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(9, &self))?;
        let dz_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(10, &self))?;
        let d_pitch_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(11, &self))?;
        let d_yaw_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(12, &self))?;
        let d_roll_camera_actor = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(13, &self))?;
        let camera_focal_length = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(14, &self))?;
        let aperture_section = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(15, &self))?;
        let d_roll_camera_component = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(16, &self))?;
        let light_id = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(17, &self))?;
        let light_strength = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(18, &self))?;
        let vignette_intensity = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(19, &self))?;
        let bloom_intensity = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(20, &self))?;
        let bloom_threshold = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(21, &self))?;
        let brightness = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(22, &self))?;
        let exposure = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(23, &self))?;
        let contrast = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(24, &self))?;
        let saturation = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(25, &self))?;
        let vibrance = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(26, &self))?;
        let highlights = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(27, &self))?;
        let shadows = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(28, &self))?;
        let filter_id = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(29, &self))?;
        let filter_strength = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(30, &self))?;
        let momo_hidden: u8 = seq.next_element()?
          .ok_or_else(|| de::Error::invalid_length(31, &self))?;
        let momo = match momo_hidden{
          1 => {
            CameraParamsV2MomoHidden::Disable{
              momo_pose: seq.next_element()?.ok_or_else(|| de::Error::invalid_length(32, &self))?,
              horizontal: seq.next_element()?.ok_or_else(|| de::Error::invalid_length(33, &self))?,
              distance: seq.next_element()?.ok_or_else(|| de::Error::invalid_length(34, &self))?,
              height: seq.next_element()?.ok_or_else(|| de::Error::invalid_length(35, &self))?,
              rotate_momo: seq.next_element()?.ok_or_else(|| de::Error::invalid_length(36, &self))?,
              auto_ground_snap: seq.next_element()?.ok_or_else(|| de::Error::invalid_length(37, &self))?,
              floating_effect: seq.next_element()?.ok_or_else(|| de::Error::invalid_length(38, &self))?,
              pose_with_nikki: seq.next_element()?.ok_or_else(|| de::Error::invalid_length(39, &self))?,
            }
          },
          _ => CameraParamsV2MomoHidden::Enable,
        };

        Ok(CameraParamsV2{
          flag, portrait_mode, dx_camera_actor, dy_camera_actor, dz_camera_actor,
          d_pitch_camera_actor, d_yaw_camera_actor, mode, dx_camera_component,
          dy_camera_component, dz_camera_component, d_pitch_camera_component,
          d_yaw_camera_component, d_roll_camera_actor, camera_focal_length,
          aperture_section, d_roll_camera_component, light_id, light_strength,
          vignette_intensity, bloom_intensity, bloom_threshold, brightness,
          exposure, contrast, saturation, vibrance, highlights, shadows,
          filter_id, filter_strength, momo,
        })
      }
    }

    deserializer.deserialize_seq(CameraParamsV2Visitor)
  }
}