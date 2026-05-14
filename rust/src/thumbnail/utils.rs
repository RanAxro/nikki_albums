/// 计算保持宽高比的目标尺寸
pub(crate) fn calculate_dimensions(
  src_w: u32,
  src_h: u32,
  target_w: Option<u32>,
  target_h: Option<u32>,
) -> (u32, u32){
  match (target_w, target_h) {
    (None, None) => (src_w, src_h),
    (Some(w), None) => {
      let ratio = w as f32 / src_w as f32;
      let h = (src_h as f32 * ratio).round() as u32;
      (w, h.max(1))
    }
    (None, Some(h)) => {
      let ratio = h as f32 / src_h as f32;
      let w = (src_w as f32 * ratio).round() as u32;
      (w.max(1), h)
    }
    (Some(w), Some(h)) => {
      // Fit 模式
      let ratio = (w as f32 / src_w as f32).min(h as f32 / src_h as f32);
      let new_w = (src_w as f32 * ratio).round() as u32;
      let new_h = (src_h as f32 * ratio).round() as u32;
      (new_w.max(1), new_h.max(1))
    }
  }
}