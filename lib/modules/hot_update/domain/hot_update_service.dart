

import "../model/hot_update_info.dart";
import "package:nikki_albums/utils/system/system.dart";

import "dart:io";

import "package:path/path.dart" as p;
import "package:dio/dio.dart";


Future<String> getHotUpdatePath() async{
  return p.join((await getAppDataDirectoryPath()).path, "HotUpdate");
}

Future<String> getHotUpdateAssetsPath(String id) async{
  return p.join((await getAppDataDirectoryPath()).path, "HotUpdate", id);
}

class HotUpdater{
  const HotUpdater();

  Future<bool> update(List<HotUpdateInfo> infos, {void Function(double progress)? onProgress, bool check = true}) async{
    bool needNotice = false;

    for(final HotUpdateInfo info in infos){
      final String rootPath = await getHotUpdateAssetsPath(info.id);
      final Directory rootDir = Directory(rootPath);

      final String versionFilePath = p.join(rootPath, info.versionId);

      // 若 check == false, 会强制热更新
      if(check && await File(versionFilePath).exists()){
        continue;
      }
      needNotice = true;

      if(await rootDir.exists()){
        await rootDir.delete(recursive: true);
      }
      await rootDir.create(recursive: true);

      final Dio dio = Dio();
      final List<Future<Response>> downloadable = [];
      for(final FileHotUpdateInfo fileInfo in info.files){
        final String fileSavePath = p.join(rootPath, fileInfo.path);

        downloadable.add(dio.download(fileInfo.downloadLink, fileSavePath));
      }

      // 更新完成后写入 version_id 信息, 避免下次重复下载
      await File(versionFilePath).create(recursive: true);

      await Future.wait(downloadable);
    }

    return needNotice;
  }
}