use serde::{Deserialize, Serialize};
use super::text::Text;

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum ThemeConfigWrapper{
  V1(ThemeConfigV1),
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct ThemeConfigV1{
  pub v1: bool,
  pub name: Text,
  pub color: (u8, u8, u8),
  pub scheme: ColorScheme,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct ColorScheme{
  pub primary: ColorRoleScheme,
  pub secondary: ColorRoleScheme,
  pub tertiary: ColorRoleScheme,
  pub success: ColorRoleScheme,
  pub error: ColorRoleScheme,
  pub background: ColorRoleScheme,
  pub highlight: ColorRoleScheme,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct ColorRoleScheme{
  pub color: u32,
  pub on_color: u32,
  pub enabled_color: u32,
  pub on_enabled_color: u32,
  pub disabled_color: u32,
  pub on_disabled_color: u32,
  pub hovered_color: u32,
  pub on_hovered_color: u32,
  pub pressed_color: u32,
  pub on_pressed_color: u32,
}