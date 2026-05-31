
import "package:nikki_albums/modules/game/uid.dart";
import "package:nikki_albums/modules/game/image.dart";
import "package:nikki_albums/info.dart";
import "package:nikki_albums/src/rust/nuan5_media_param/structs/nikki_photo_params.dart";
import "package:nikki_albums/src/rust/nuan5_media_param/decode.dart";




bool filterOnlyDailyTask(ImageItem item, Uid? uid, AlbumType type){
  if(type != AlbumType.NikkiPhotos_HighQuality) return false;

  final MediaCustomData? data = item.getParamSync(uid?.value, AlbumType.NikkiPhotos_HighQuality);
  return data?.whenOrNull(
    valid: (MediaParam param){
      return param.whenOrNull(
        nikkiPhoto: (nikkiPhoto){
          for(final task in nikkiPhoto.photography.task){
            final bool? exist = task.whenOrNull(
              interactive: (interactive){
                for(final int taskId in interactive.keys){
                  /// TODO
                  /// 15002 套配合地点判断，需判断地点位于“星海”
                  // const List<int> taskIdList = [15002, 15006, 15008, 11120, 11121];
                  const List<int> taskIdList = [15006, 15008, 11120, 11121];

                  if(taskIdList.contains(taskId)){
                    return true;
                  }
                }
                return false;
              },
            );

            if(exist == true){
              return true;
            }
          }

          return false;
        },
      );
    },
  ) ?? false;
}

bool filterHasCompletedTask(ImageItem item, Uid? uid, AlbumType type){
  if(type != AlbumType.NikkiPhotos_HighQuality) return false;

  final MediaCustomData? data = item.getParamSync(uid?.value, AlbumType.NikkiPhotos_HighQuality);
  return data?.whenOrNull(
    valid: (MediaParam param){
      return param.whenOrNull(
        nikkiPhoto: (nikkiPhoto){
          for(final task in nikkiPhoto.photography.task){
            final bool? exist = task.whenOrNull(
              interactive: (interactive){
                for(final bool taskState in interactive.values){
                  if(taskState){
                    return true;
                  }
                }
                return false;
              },
            );

            if(exist == true){
              return true;
            }
          }

          return false;
        },
      );
    },
  ) ?? false;
}

bool filterHasUnfinishedTask(ImageItem item, Uid? uid, AlbumType type){
  if(type != AlbumType.NikkiPhotos_HighQuality) return false;

  final MediaCustomData? data = item.getParamSync(uid?.value, AlbumType.NikkiPhotos_HighQuality);
  return data?.whenOrNull(
    valid: (MediaParam param){
      return param.whenOrNull(
        nikkiPhoto: (nikkiPhoto){
          for(final task in nikkiPhoto.photography.task){
            final bool? exist = task.whenOrNull(
              interactive: (interactive){
                for(final bool taskState in interactive.values){
                  if(!taskState){
                    return true;
                  }
                }
                return false;
              },
            );

            if(exist == true){
              return true;
            }
          }

          return false;
        },
      );
    },
  ) ?? false;
}

bool filterOnlyPuzzleTask(ImageItem item, Uid? uid, AlbumType type){
  if(type != AlbumType.NikkiPhotos_HighQuality) return false;

  final MediaCustomData? data = item.getParamSync(uid?.value, AlbumType.NikkiPhotos_HighQuality);
  return data?.whenOrNull(
    valid: (MediaParam param){
      return param.whenOrNull(
        nikkiPhoto: (nikkiPhoto){
          for(final task in nikkiPhoto.photography.task){
            final bool? exist = task.whenOrNull(
              puzzle: (int puzzle){
                return true;
              },
            );

            if(exist == true){
              return true;
            }
          }

          return false;
        },
      );
    },
  ) ?? false;
}

bool filterOnlyRiskTask(ImageItem item, Uid? uid, AlbumType type){
  if(type != AlbumType.NikkiPhotos_HighQuality) return false;

  final MediaCustomData? data = item.getParamSync(uid?.value, AlbumType.NikkiPhotos_HighQuality);
  return data?.whenOrNull(
    valid: (MediaParam param){
      return param.whenOrNull(
        nikkiPhoto: (nikkiPhoto){
          for(final task in nikkiPhoto.photography.task){
            final bool? exist = task.whenOrNull(
              risk: (Map<int, bool> risk){
                return risk.isNotEmpty;
              },
            );

            if(exist == true){
              return true;
            }
          }

          return false;
        },
      );
    },
  ) ?? false;
}