import "dart:io";

import "../domain/log_manager.dart";
import "../domain/log_exporter.dart";
import "package:nikki_albums/utils/path.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";


/// 设置页：错误报告日志 / 崩溃日志 分区
///
/// 顶部操作栏（导出 / 打开目录 / 刷新）+ 内嵌双 Tab（错误报告 / 崩溃日志）+ 内容区。
class ErrorLog extends StatefulWidget {
  const ErrorLog({super.key});

  @override
  State<ErrorLog> createState() => _ErrorLogState();
}

class _ErrorLogState extends State<ErrorLog> {
  final PageController _tabController = PageController(initialPage: 0);

  /// 用来触发内容区刷新的计数器
  int _refreshCount = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _refreshCount++;
    });
  }

  Future<void> _openLogDirectory() async {
    final Path dir = await AppLogger.errorLog.directoryPath();
    if (!await dir.directory.exists()) {
      await dir.directory.create(recursive: true);
    }
    await dir.open(FileSystemEntityType.directory);
  }

  Future<void> _export(BuildContext context) async {
    await LogExporter.exportAsZip(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(smallPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 顶部说明
          AppText.tr("error_log_description", fontSize: 12),

          // 顶部操作栏
          Row(
            spacing: listSpacing,
            children: [
              AppButton.smallText(
                colorRole: ColorRole.background,
                isTransparent: false,
                onClick: () => _export(context),
                child: AppText.tr("error_log_export"),
              ),
              AppButton.smallText(
                onClick: _openLogDirectory,
                child: AppText.tr("error_log_open_dir"),
              ),
              AppButton.smallText(
                onClick: _refresh,
                child: AppText.tr("error_log_refresh"),
              ),
            ],
          ),

          block10H,

          // 内嵌 Tab 切换条
          SizedBox(
            width: sideBarExpandWidth,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ListenableBuilder(
                  listenable: _tabController,
                  builder: (BuildContext context, Widget? child) {
                    return AppRadioStack(
                      direction: Axis.vertical,
                      selectedIndex: _tabController.page?.toInt() ?? 0,
                      children: [
                        AppButton.smallText(
                          width: constraints.maxWidth,
                          height: smallButtonSize,
                          onClick: () => _tabController.jumpToPage(0),
                          child: AppText.tr("error_log_error_tab"),
                        ),
                        AppButton.smallText(
                          width: constraints.maxWidth,
                          height: smallButtonSize,
                          onClick: () => _tabController.jumpToPage(1),
                          child: AppText.tr("error_log_crash_tab"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          block10H,

          // 内容区
          Expanded(
            child: PageView(
              controller: _tabController,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _LogViewer(
                  key: ValueKey("error_$_refreshCount"),
                  manager: AppLogger.errorLog,
                ),
                _LogViewer(
                  key: ValueKey("crash_$_refreshCount"),
                  manager: AppLogger.crashLog,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 单个日志文件的可视化视图
class _LogViewer extends StatefulWidget {
  final LogFileManager manager;

  const _LogViewer({super.key, required this.manager});

  @override
  State<_LogViewer> createState() => _LogViewerState();
}

class _LogViewerState extends State<_LogViewer> {
  @override
  Widget build(BuildContext context) {
    return RFutureBuilder(
      future: _load(),
      builder: (BuildContext context, _LogData data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 文件信息 + 操作按钮
            Row(
              spacing: listSpacing,
              children: [
                AppText(
                  "${context.tr("error_log_size")}: ${_formatSize(data.size)}",
                  fontSize: 12,
                ),
                const Spacer(),
                AppButton.smallText(
                  onClick: () => _confirmClear(context),
                  child: AppText.tr("error_log_clear"),
                ),
                AppButton.smallText(
                  onClick: () => _copyAll(context),
                  child: AppText.tr("error_log_copy_all"),
                ),
                AppButton.smallText(
                  onClick: () => _copyLast(context),
                  child: AppText.tr("error_log_copy_last"),
                ),
              ],
            ),

            block5H,

            // 内容区
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(smallBorderRadius),
                  border: Border.all(
                    color: AppColorScheme.of(context)
                        .byRole(ColorRole.of(context))
                        .onDisabledColor,
                  ),
                ),
                child: data.content.isEmpty
                    ? Center(child: AppText.tr("error_log_empty"))
                    : SmoothPointerScroll(
                        builder: (BuildContext context,
                            ScrollController scrollController,
                            ScrollPhysics physics,
                            IndependentScrollbarController scrollbarController) {
                          return SingleChildScrollView(
                            controller: scrollController,
                            physics: physics,
                            child: Padding(
                              padding: const EdgeInsets.all(smallPadding),
                              child: SelectableText(
                                data.content,
                                style: TextStyle(
                                  fontFamily: "monospace",
                                  fontSize: 12,
                                  color: AppTheme.of(context)!
                                      .colorScheme
                                      .background
                                      .onColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<_LogData> _load() async {
    final String content = await widget.manager.read();
    final int size = await widget.manager.fileSize();
    return _LogData(content: content, size: size);
  }

  Future<void> _confirmClear(BuildContext context) async {
    final bool? ok = await showAppDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AppConfirmDialog(
          title: "error_log_clear",
          isTranslateTitle: true,
          message: context.tr("error_log_clear_confirm"),
          isTranslateMessage: false,
          isRisk: true,
        );
      },
    );

    if (ok != true) return;

    await widget.manager.clear();
    if (mounted) {
      AppToast.showMessage(
        context: context,
        message: context.tr("error_log_clear_success"),
        state: true,
      );
      // 刷新：通过重建触发 future 重新执行
      setState(() {});
    }
  }

  Future<void> _copyAll(BuildContext context) async {
    await LogExporter.copyAll(context, widget.manager);
  }

  Future<void> _copyLast(BuildContext context) async {
    await LogExporter.copyLastEntry(context, widget.manager);
  }
}

class _LogData {
  final String content;
  final int size;
  const _LogData({required this.content, required this.size});
}

/// 字节数格式化为可读字符串
String _formatSize(int bytes) {
  if (bytes < 1024) return "$bytes B";
  if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
  return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
}
