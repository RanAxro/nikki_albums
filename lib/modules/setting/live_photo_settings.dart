import "dart:io";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/utils/ffmpeg_manager.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";

class LivePhotoSettings extends StatelessWidget {
  const LivePhotoSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(smallPadding),
      child: ValueListenableBuilder(
        valueListenable: AppState.livePhotoExportFormat,
        builder: (BuildContext context, String format, Widget? child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr("livePhotoExportFormat"),
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.of(context)!.colorScheme.background.onColor,
                ),
              ),
              block10H,

              Text(
                context.tr("livePhotoExportFormat_description"),
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.of(context)!.colorScheme.background.onColor.withOpacity(0.6),
                ),
              ),
              block10H,

              _buildRadioOption(context, "none", format),
              _buildRadioOption(context, "apple", format),
              _buildRadioOption(context, "google", format),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRadioOption(BuildContext context, String value, String current) {
    final bool selected = value == current;
    return IntrinsicWidth(
      child: AppButton.smallText(
        onClick: () async {
          if (Platform.isWindows && value == "apple") {
            final success = await FFmpegManager.checkAndDownload(context);
            if (success) {
              AppState.livePhotoExportFormat.value = value;
            }
          } else {
            AppState.livePhotoExportFormat.value = value;
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: listSpacing,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 20,
              color: AppTheme.of(context)!.colorScheme.background.onColor,
            ),
            Text(
              context.tr("livePhotoExportFormat_$value"),
              style: TextStyle(
                color: AppTheme.of(context)!.colorScheme.background.onColor,
              ),
            ),
            if (Platform.isWindows && value == "apple")
              ValueListenableBuilder<bool>(
                valueListenable: FFmpegManager.isInstalledNotifier,
                builder: (context, isInstalled, _) {
                  if (!isInstalled) {
                    return Icon(
                      Icons.cloud_download_outlined,
                      size: 16,
                      color: AppTheme.of(context)!.colorScheme.background.onColor,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
          ],
        ),
      ),
    );
  }
}
