import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nikki_albums/widgets/app/component.dart';
import 'package:nikki_albums/widgets/common/component.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FFmpegManager {
  static const List<String> _mirrors = [
    'https://mirror.ghproxy.com/https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip',
    'https://ghproxy.net/https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip',
    'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip',
  ];

  static Future<String> get _ffmpegPath async {
    final appSupportDir = await getApplicationSupportDirectory();
    final binDir = Directory(p.join(appSupportDir.path, 'bin'));
    if (!await binDir.exists()) {
      await binDir.create(recursive: true);
    }
    return p.join(binDir.path, 'ffmpeg.exe');
  }

  static Future<bool> isInstalled() async {
    if (!Platform.isWindows) return true; // Only Windows needs to download FFmpeg
    final path = await _ffmpegPath;
    return await File(path).exists();
  }

  /// 检查并在需要时弹出下载对话框
  static Future<bool> checkAndDownload(BuildContext context) async {
    if (await isInstalled()) return true;

    // UI Guardrail: 明确告知用户需要下载组件
    final bool? shouldDownload = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AppDialog(
          maxWidth: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: listSpacing,
            children: [
              AppText("extraComponentRequired", fontSize: 18, fontWeight: FontWeight.bold),
              block10H,
              AppText("ffmpegDownloadDescription"),
              block20H,
              Row(
                spacing: listSpacing,
                children: [
                  Expanded(
                    child: AppButton.smallText(
                      onClick: () => Navigator.of(context).pop(false),
                      child: AppText("cancel"),
                    ),
                  ),
                  Expanded(
                    child: AppButton.smallText(
                      colorRole: ColorRole.highlight,
                      isTransparent: false,
                      onClick: () => Navigator.of(context).pop(true),
                      child: AppText("download"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (shouldDownload != true) return false;

    // 显示下载进度
    bool downloadSuccess = false;
    if (context.mounted) {
      downloadSuccess = await _performDownload(context);
    }
    return downloadSuccess;
  }

  static Future<bool> _performDownload(BuildContext context) async {
    final ValueNotifier<double?> progressNotifier = ValueNotifier<double?>(0);
    final ValueNotifier<String> statusNotifier = ValueNotifier<String>("downloadingFFmpeg");
    final CancelToken cancelToken = CancelToken();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AppDialog(
            maxWidth: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: listSpacing,
              children: [
                ValueListenableBuilder(
                  valueListenable: statusNotifier,
                  builder: (context, status, _) => AppText(status, fontWeight: FontWeight.bold),
                ),
                block10H,
                ValueListenableBuilder(
                  valueListenable: progressNotifier,
                  builder: (context, progress, _) {
                    if (progress == null) {
                      return const LinearProgressIndicator();
                    }
                    return LinearProgressIndicator(value: progress);
                  },
                ),
                block20H,
                AppButton.smallText(
                  onClick: () {
                    cancelToken.cancel();
                    Navigator.of(context).pop();
                  },
                  child: AppText("cancel"),
                ),
              ],
            ),
          ),
        );
      },
    );

    final dio = Dio();
    final tempDir = await getTemporaryDirectory();
    final zipPath = p.join(tempDir.path, 'ffmpeg_download.zip');
    final finalExePath = await _ffmpegPath;

    try {
      bool downloaded = false;
      for (final url in _mirrors) {
        if (cancelToken.isCancelled) break;
        try {
          await dio.download(
            url,
            zipPath,
            cancelToken: cancelToken,
            onReceiveProgress: (count, total) {
              if (total > 0) {
                progressNotifier.value = count / total;
              }
            },
          );
          downloaded = true;
          break; // Success
        } catch (e) {
          debugPrint("Failed to download from $url: $e");
        }
      }

      if (!downloaded) {
        throw Exception("All mirrors failed");
      }

      if (cancelToken.isCancelled) return false;

      statusNotifier.value = "extractingFFmpeg";
      progressNotifier.value = null; // Indeterminate
      
      // 在后台线程解压，避免阻塞 UI
      await Future.delayed(const Duration(milliseconds: 100));
      
      final inputStream = InputFileStream(zipPath);
      final archive = ZipDecoder().decodeStream(inputStream);
      bool found = false;
      for (final file in archive) {
        if (file.name.endsWith('ffmpeg.exe')) {
          final outputStream = OutputFileStream(finalExePath);
          file.writeContent(outputStream);
          outputStream.close();
          found = true;
          break;
        }
      }
      inputStream.close();
      
      // 提权与清理
      if (found) {
        try {
          await Process.run('icacls', [finalExePath, '/grant', 'Everyone:RX']);
        } catch (_) {}
      }

      try {
        await File(zipPath).delete();
      } catch (_) {}

      if (context.mounted) {
        Navigator.of(context).pop(); // 关掉进度条
      }

      return found;
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // 关掉进度条
        // 提示失败
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr("ffmpegDownloadFailed"))),
        );
      }
      return false;
    }
  }

  /// 执行 FFmpeg 命令
  static Future<ProcessResult> execute(List<String> args) async {
    final exe = await _ffmpegPath;
    if (!await File(exe).exists()) {
      throw Exception("FFmpeg not installed");
    }
    return await Process.run(exe, args);
  }
}
