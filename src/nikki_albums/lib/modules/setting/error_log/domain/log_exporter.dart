import "dart:io";

import "package:nikki_albums/utils/path.dart";
import "package:nikki_albums/utils/archive.dart";
import "package:nikki_albums/utils/native_file_picker.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/modules/setting/error_log/domain/log_manager.dart";

import "package:flutter/services.dart";
import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";


/// 日志导出与剪贴板工具
abstract class LogExporter {
  /// 导出全部日志（error.log / crash.log 及其 .1 备份）为 zip。
  /// 用户取消选择返回 null；导出成功返回文件路径。
  static Future<String?> exportAsZip(BuildContext context) async {
    final Path logsDir = await AppLogger.errorLog.directoryPath();

    // 收集所有日志文件（不存在则跳过）
    final List<File> files = [];
    final List<Path> archivePaths = [];
    for (final String name in const [
      "error.log",
      "error.log.1",
      "crash.log",
      "crash.log.1",
    ]) {
      final Path p = logsDir + name;
      if (await p.file.exists()) {
        files.add(p.file);
        archivePaths.add(Path(name));
      }
    }

    if (files.isEmpty) {
      if (context.mounted) {
        AppToast.showMessage(
          context: context,
          message: context.tr("error_log_empty"),
          state: false,
        );
      }
      return null;
    }

    // 生成带时间戳的文件名：nikkialbums_logs_YYYYMMDD_HHMMSS.zip
    final DateTime now = DateTime.now();
    final String stamp =
        "${now.year.toString().padLeft(4, "0")}"
        "${now.month.toString().padLeft(2, "0")}"
        "${now.day.toString().padLeft(2, "0")}_"
        "${now.hour.toString().padLeft(2, "0")}"
        "${now.minute.toString().padLeft(2, "0")}"
        "${now.second.toString().padLeft(2, "0")}";
    final String zipName = "nikkialbums_logs_$stamp.zip";

    final String? savePath = await NativeFilePicker.saveFile(
      dialogTitle: context.tr("error_log_export"),
      fileName: zipName,
    );

    // 用户取消
    if (savePath == null) return null;

    try {
      await compressZip(files, archivePaths, File(savePath));
      if (context.mounted) {
        AppToast.showMessage(
          context: context,
          message: context.tr("error_log_export_success"),
          state: true,
        );
      }
      return savePath;
    } catch (e) {
      if (context.mounted) {
        AppToast.showMessage(
          context: context,
          message: "${context.tr("error_log_export_failed")}\n$e",
          state: false,
        );
      }
      return null;
    }
  }

  /// 复制最近一条日志到剪贴板。便于用户在反馈渠道中粘贴。
  static Future<void> copyLastEntry(
    BuildContext context,
    LogFileManager manager,
  ) async {
    final String content = await manager.read();
    final String lastEntry = _extractLastEntry(content);

    await Clipboard.setData(ClipboardData(text: lastEntry));
    if (context.mounted) {
      AppToast.showMessage(
        context: context,
        message: context.tr("error_log_copied"),
        state: true,
      );
    }
  }

  /// 复制全部日志内容到剪贴板。
  static Future<void> copyAll(
    BuildContext context,
    LogFileManager manager,
  ) async {
    final String content = await manager.read();
    if (content.isEmpty) {
      if (context.mounted) {
        AppToast.showMessage(
          context: context,
          message: context.tr("error_log_empty"),
          state: false,
        );
      }
      return;
    }
    await Clipboard.setData(ClipboardData(text: content));
    if (context.mounted) {
      AppToast.showMessage(
        context: context,
        message: context.tr("error_log_copied"),
        state: true,
      );
    }
  }

  /// 从日志文本中提取最后一条记录（以 `[YYYY-MM-DD` 开头作为分隔）
  static String _extractLastEntry(String content) {
    if (content.isEmpty) return "";

    // 倒序找最后一个条目起始位置
    final int idx = content.lastIndexOf("\n[");
    if (idx == -1) return content.trim();
    return content.substring(idx + 1).trim();
  }
}
