
#[macro_export] macro_rules! impl_json_frb{
  ($($struct_name:ty),+ $(,)?) => {
    $(
      impl $struct_name {
        #[frb(sync)]
        pub fn from_json(json: &str) -> Result<Self, serde_json::error::Error>{
          serde_json::from_str(json)
        }

        #[frb(sync)]
        pub fn from_json_bytes(json: &[u8]) -> Result<Self, serde_json::error::Error>{
          serde_json::from_slice(json)
        }

        #[frb(sync)]
        pub fn to_json(&self) -> Result<String, serde_json::error::Error>{
          serde_json::to_string(self)
        }

        #[frb(sync)]
        pub fn to_json_bytes(&self) -> Result<Vec<u8>, serde_json::error::Error>{
          serde_json::to_vec(self)
        }

        #[frb(sync)]
        pub fn to_json_pretty(&self) -> Result<String, serde_json::error::Error>{
          serde_json::to_string_pretty(self)
        }

        #[frb(sync)]
        pub fn to_json_bytes_pretty(&self) -> Result<Vec<u8>, serde_json::error::Error>{
          serde_json::to_vec_pretty(self)
        }
      }
    )+
  };
}