import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FFmpegManager {
  static final ValueNotifier<bool> isInstalledNotifier = ValueNotifier<bool>(
    true,
  );

  static Future<void> init() async {
    isInstalledNotifier.value = await isInstalled();
  }

  static Future<String> get _ffmpegPath async {
    // 优先使用随包打包分发的极简版 FFmpeg
    final bundledPath = p.join(
      p.dirname(Platform.resolvedExecutable),
      'bin',
      'ffmpeg.exe',
    );
    if (await File(bundledPath).exists()) {
      return bundledPath;
    }

    final appSupportDir = await getApplicationSupportDirectory();
    final binDir = Directory(p.join(appSupportDir.path, 'bin'));
    if (!await binDir.exists()) {
      await binDir.create(recursive: true);
    }
    return p.join(binDir.path, 'ffmpeg.exe');
  }

  static Future<bool> isInstalled() async {
    if (!Platform.isWindows)
      return true; // Only Windows needs to download FFmpeg
    final path = await _ffmpegPath;
    return await File(path).exists();
  }

  /// 检查 FFmpeg 是否就绪，未就绪则在开发环境下提示
  static Future<bool> checkAndDownload(BuildContext context) async {
    final ready = await isInstalled();
    if (!ready && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "FFmpeg 缺失！请确保运行过打包脚本。/ FFmpeg is missing from bundle.",
          ),
        ),
      );
    }
    return ready;
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
