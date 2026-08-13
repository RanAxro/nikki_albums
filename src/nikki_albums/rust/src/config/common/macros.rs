
#[macro_export] macro_rules! impl_json_frb{
  ($($struct_name:ty),+ $(,)?) => {
    $(
      impl $struct_name {
        #[frb(sync)]
        pub fn from_json(json: &str) -> Option<Self>{
          serde_json::from_str(json).ok()
        }

        #[frb(sync)]
        pub fn to_json(&self) -> Result<String, serde_json::error::Error>{
          serde_json::to_string(self)
        }

        #[frb(sync)]
        pub fn to_json_pretty(&self) -> Result<String, serde_json::error::Error>{
          serde_json::to_string_pretty(self)
        }
      }
    )+
  };
}