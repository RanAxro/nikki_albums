

import "../model/hot_update_info.dart";
import "package:nikki_albums/utils/system/system.dart";

import "dart:io";

import "package:path/path.dart" as p;
import "package:dio/dio.dart";


Future<String> getHotUpdateAssetsPath(String id) async{
  return p.join((await getAppDataDirectoryPath()).path, "HotUpdate", id);
}

class HotUpdater{
  const HotUpdater();

  Future<void> update(List<HotUpdateInfo> infos, {void Function(double progress)? onProgress, bool check = true}) async{
    for(final HotUpdateInfo info in infos){
      final String rootPath = await getHotUpdateAssetsPath(info.id);
      final Directory rootDir = Directory(rootPath);

      final String versionFilePath = p.join(rootPath, info.versionId);

      // 若 check == false, 会强制热更新
      if(check && await File(versionFilePath).exists()){
        continue;
      }
      if(await rootDir.exists()){
        await rootDir.delete(recursive: true);
      }
      await rootDir.create(recursive: true);

      await File(versionFilePath).create(recursive: true);

      final List<Future<Response>> downloadable = [];
      for(final FileHotUpdateInfo fileInfo in info.files){
        final String fileSavePath = p.join(rootPath, fileInfo.path);

        final Dio dio = Dio();

        downloadable.add(dio.download(fileInfo.downloadLink, fileSavePath));
      }

      await Future.wait(downloadable);
    }
  }
}