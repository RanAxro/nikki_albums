use serde::{Deserialize, Serialize};

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct VideoCustomData{
  #[serde(rename = "VideoRecordData")]
  pub video_record_data: VideoRecordData,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct VideoRecordData{
  #[serde(rename = "CreateTime")]
  pub create_time: f64,

  #[serde(rename = "CRF")]
  pub crf: u64,

  #[serde(rename = "DesiredHeight")]
  pub desired_height: u64,

  #[serde(rename = "DesiredWidth")]
  pub desired_width: u64,

  #[serde(rename = "DurationStr")]
  pub duration_str: String,

  #[serde(rename = "FramesCount")]
  pub frames_count: u64,

  #[serde(rename = "FrameEndWith")]
  pub frame_end_with: String,

  #[serde(rename = "FrameRate")]
  pub frame_rate: u64,

  #[serde(rename = "InputFilePath")]
  pub input_file_path: String,

  #[serde(rename = "OutputFilePath")]
  pub output_file_path: String,

  #[serde(rename = "PresetQuality")]
  pub preset_quality: String,

  #[serde(rename = "RoleID")]
  pub role_id: u64,

  #[serde(rename = "SourceHeight")]
  pub source_height: u64,

  #[serde(rename = "SourceWidth")]
  pub source_width: u64,

  #[serde(rename = "VideoSaveName")]
  pub video_save_name: String,

  #[serde(rename = "ViewportHeight")]
  pub viewport_height: u64,

  #[serde(rename = "VideoSavePath")]
  pub video_save_path: String,

  #[serde(rename = "ViewportWidth")]
  pub viewport_width: u64,
}



#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct VideoCoverCustomData{
  #[serde(rename = "VideoCoverData")]
  pub video_cover_data: VideoCoverData,
}

#[derive(Clone)]
#[derive(Serialize, Deserialize)]
pub struct VideoCoverData{
  #[serde(rename = "RoleID")]
  pub role_id: u64,

  #[serde(rename = "CreateTime")]
  pub create_time: u64,

  #[serde(rename = "videoCustomData")]
  pub video_custom_data: VideoRecordData,
}