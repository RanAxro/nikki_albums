
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

  // Future<bool> update(List<HotUpdateInfo> infos, {void Function(double progress)? onProgress, bool check = true}) async{
  //   bool needNotice = false;
  //
  //   for(final HotUpdateInfo info in infos){
  //     final String rootPath = await getHotUpdateAssetsPath(info.id);
  //     final Directory rootDir = Directory(rootPath);
  //
  //     final String versionFilePath = p.join(rootPath, info.versionId);
  //
  //     // 若 check == false, 会强制热更新
  //     if(check && await File(versionFilePath).exists()){
  //       continue;
  //     }
  //     needNotice = true;
  //
  //     if(await rootDir.exists()){
  //       await rootDir.delete(recursive: true);
  //     }
  //     await rootDir.create(recursive: true);
  //
  //     final Dio dio = Dio();
  //     final List<Future<Response>> downloadable = [];
  //     for(final FileHotUpdateInfo fileInfo in info.files){
  //       final String fileSavePath = p.join(rootPath, fileInfo.path);
  //
  //       downloadable.add(dio.download(fileInfo.downloadLink, fileSavePath));
  //     }
  //
  //     // 更新完成后写入 version_id 信息, 避免下次重复下载
  //     await File(versionFilePath).create(recursive: true);
  //
  //     await Future.wait(downloadable);
  //   }
  //
  //   return needNotice;
  // }

  Future<bool> update(List<HotUpdateInfo> infos, {void Function(double progress)? onProgress, bool check = true}) async{
    bool needNotice = false;

    // 1. 预计算总文件数，用于进度回调
    int totalFiles = 0;
    for(final HotUpdateInfo info in infos){
      final String rootPath = await getHotUpdateAssetsPath(info.id);
      final String versionFilePath = p.join(rootPath, info.versionId);
      if(check && await File(versionFilePath).exists()) continue;
      totalFiles += info.files.length;
    }
    if(totalFiles == 0) return false;

    int completedFiles = 0;

    // 2. 复用单个 Dio，配置合理超时
    final Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 2),
    ));

    try{
      for(final HotUpdateInfo info in infos){
        final String rootPath = await getHotUpdateAssetsPath(info.id);
        final Directory rootDir = Directory(rootPath);
        final String versionFilePath = p.join(rootPath, info.versionId);

        if(check && await File(versionFilePath).exists()) continue;
        needNotice = true;

        try{
          if(await rootDir.exists()){
            await rootDir.delete(recursive: true);
          }
          await rootDir.create(recursive: true);
        }catch(_){
          
        }

        // 3. 构建任务工厂（延迟执行，不立即创建 Future）
        final taskFactories = info.files.map((fileInfo) => () async{
          final String fileSavePath = p.join(rootPath, fileInfo.path);

          // 确保子目录存在
          final Directory parentDir = Directory(p.dirname(fileSavePath));
          if(!await parentDir.exists()){
            await parentDir.create(recursive: true);
          }

          // 4. 带重试的下载
          await _downloadWithRetry(dio, fileInfo.downloadLink, fileSavePath);

          completedFiles++;
          onProgress?.call(completedFiles / totalFiles);
        }).toList();

        // 5. 限制并发：同时最多 3 个，避免并发 TLS 握手被 RST
        await _runWithConcurrency(taskFactories, maxConcurrency: 3);

        // 全部下载成功后，写入版本标记
        await File(versionFilePath).create(recursive: true);
      }
    }finally{
      dio.close();
    }

    return needNotice;
  }

  /// 带重试的下载，HandshakeException / SocketException / 超时 自动重试
  Future<void> _downloadWithRetry(Dio dio, String url, String savePath) async{
    int attempt = 0;
    const int maxRetries = 3;

    while(true){
      try{
        await dio.download(url, savePath);
        return;
      }on DioException catch(e){
        attempt++;

        final bool isRetryable = e.error is HandshakeException ||
          e.error is SocketException ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout;

        if(isRetryable && attempt <= maxRetries){
          // 指数退避：2s, 4s, 8s
          await Future.delayed(Duration(seconds: 1 << attempt));
          continue;
        }

        // 重试耗尽，清理残留文件后抛出
        await _safeDelete(savePath);
        rethrow;
      }
    }
  }

  /// Worker Pool 限制并发数
  Future<void> _runWithConcurrency(List<Future<void> Function()> factories, {required int maxConcurrency}) async{
    final iterator = factories.iterator;

    Future<void> worker() async{
      while(iterator.moveNext()){
        await iterator.current();
      }
    }

    await Future.wait(
      List.generate(maxConcurrency, (_) => worker()),
      eagerError: true,
    );
  }

  Future<void> _safeDelete(String path) async{
    try{
      final File file = File(path);
      if(await file.exists()) await file.delete();
    }catch(_){

    }
  }
}