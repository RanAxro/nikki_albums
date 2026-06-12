import "../model/update_info.dart";
import "launch_official_website.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/utils/system/system.dart";

import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:dio/dio.dart";
import "package:archive/archive_io.dart";
import "package:path/path.dart" as p;

abstract class Updater {
  const Updater();

  Future<void> update(
    UpdateInfo info, {
    void Function(double progress)? onProgress,
    void Function(String message)? onError,
  });
}

class WindowsUpdater extends Updater {
  const WindowsUpdater();

  @override
  Future<void> update(
    UpdateInfo info, {
    void Function(double)? onProgress,
    void Function(String)? onError,
  }) async {
    if (info.platformDownloadLink == "") {
      launchOfficialWebsite();
      return;
    }

    String errorMessage = "";

    // download
    final String archiveSavePath = p.join(
      (await getTempPath()).path,
      "${tr("nikkialbums")}.zip",
    );
    bool isDownload = false;

    try {
      final Dio dio = Dio();

      await dio.download(
        info.platformDownloadLink,
        archiveSavePath,
        onReceiveProgress: (int received, int total) {
          onProgress?.call((received / total - 0.1).clamp(0, 1));
        },
        options: Options(headers: {"Referer": "https://nikki.ranaxro.com"}),
      );

      isDownload = true;
    } catch (e) {
      isDownload = false;
      errorMessage = e.toString();
    }

    // decompress
    final String? decompressPath =
        AppState.sfxPath.value ?? getWindowsDesktopPath()?.path;
    bool isDecompress = false;

    String? exeFilename;

    if (decompressPath != null) {
      final InputFileStream inputStream = InputFileStream(archiveSavePath);
      try {
        final Archive archive = ZipDecoder().decodeStream(
          inputStream,
          callback: (ArchiveFile archiveFile) {
            if (archiveFile.isFile && archiveFile.name.endsWith(".exe")) {
              exeFilename = archiveFile.name;
            }
          },
        );

        await extractArchiveToDisk(archive, decompressPath);

        isDecompress = true;
      } catch (e) {
        isDecompress = false;
        errorMessage = e.toString();
        await inputStream.close();
      }
    }

    onProgress?.call(1);

    /// 下载成功
    if (isDownload) {
      /// 下载成功 并且 解压成功
      if (isDecompress && decompressPath != null) {
        /// 获取到 exe 文件名
        if (exeFilename != null) {
          Explorer.openFile(File(p.join(decompressPath, exeFilename)));
        }
        /// 未获取到 exe 文件名
        else {
          Explorer.openDir(Directory(decompressPath));
        }
      }
      /// 下载成功 但 解压失败
      else {
        Explorer.openDir(Directory(archiveSavePath));
      }

      onCloseApp(() async{
        if(decompressPath != null){
          await Process.start(
            decompressPath,
            ["-force"],
            runInShell: false,
            mode: ProcessStartMode.detached,
          );
        }
      });
      await closeApp();
    } else {
      onError?.call(errorMessage);
    }
  }
}

class MacOSUpdater extends Updater {
  const MacOSUpdater();

  @override
  Future<void> update(
    UpdateInfo info, {
    void Function(double)? onProgress,
    void Function(String)? onError,
  }) async {
    if (info.platformDownloadLink == "") {
      launchOfficialWebsite();
      return;
    }

    String errorMessage = "";

    // download
    final String archiveSavePath = p.join(
      (await getTempPath()).path,
      "${tr("nikkialbums")}_Update.zip",
    );
    bool isDownload = false;

    try {
      final Dio dio = Dio();

      await dio.download(
        info.platformDownloadLink,
        archiveSavePath,
        onReceiveProgress: (int received, int total) {
          onProgress?.call((received / total - 0.1).clamp(0, 1));
        },
        options: Options(headers: {"Referer": "https://nikki.ranaxro.com"}),
      );

      isDownload = true;
    } catch (e) {
      isDownload = false;
      errorMessage = e.toString();
    }

    // decompress
    final String? home = Platform.environment['HOME'];
    final String decompressPath = home != null
        ? p.join(home, 'Downloads')
        : (await getTempPath()).path;
    bool isDecompress = false;

    String? appFilename;

    final InputFileStream inputStream = InputFileStream(archiveSavePath);
    try {
      final Archive archive = ZipDecoder().decodeStream(
        inputStream,
        callback: (ArchiveFile archiveFile) {
          final String name = archiveFile.name;
          if (name.endsWith(".app/") && name.split("/").length == 2) {
            appFilename = name.substring(0, name.length - 1);
          } else if (name.endsWith(".app") && !name.contains("/")) {
            appFilename = name;
          }
        },
      );

      await extractArchiveToDisk(archive, decompressPath);

      isDecompress = true;
    } catch (e) {
      isDecompress = false;
      errorMessage = e.toString();
      await inputStream.close();
    }

    onProgress?.call(1);

    if (isDownload) {
      if (isDecompress) {
        if (appFilename != null) {
          Process.run("open", ["-R", p.join(decompressPath, appFilename!)]);
        } else {
          Process.run("open", [decompressPath]);
        }
      } else {
        Process.run("open", ["-R", archiveSavePath]);
      }

      await closeApp();
    } else {
      onError?.call(errorMessage);
    }
  }
}
