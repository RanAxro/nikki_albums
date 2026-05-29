import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";

class Personalization extends StatelessWidget {
  const Personalization({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(smallPadding),
      child: Column(
        spacing: bigListSpacing,
        children: [
          const MaximizeOrRestoreButtonSwitch(),
          const LivePhotoFormatSetting(),
          const ChangeTheme(),
        ],
      ),
    );
  }
}

class LivePhotoFormatSetting extends StatelessWidget {
  const LivePhotoFormatSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.livePhotoExportFormat,
      builder: (BuildContext context, String format, Widget? child) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: listSpacing,
            children: [
              Text(
                context.tr("livePhotoExportFormat"),
                style: TextStyle(
                  color: AppTheme.of(context)!.colorScheme.background.onColor,
                ),
              ),
              Text(
                context.tr("livePhotoExportFormat_description"),
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.of(context)!.colorScheme.background.onColor.withOpacity(0.6),
                ),
              ),
              Row(
                spacing: listSpacing,
                children: [
                  _buildOption(context, "none", format),
                  _buildOption(context, "apple", format),
                  _buildOption(context, "google", format),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context, String value, String current) {
    final bool selected = value == current;
    return SmallButton(
      padding: const EdgeInsets.symmetric(horizontal: smallPadding),
      width: null,
      colorRole: selected ? ColorRole.primary : ColorRole.background,
      transparent: !selected,
      onClick: () {
        AppState.livePhotoExportFormat.value = value;
      },
      child: Text(
        context.tr("livePhotoExportFormat_$value"),
        style: TextStyle(
          color: selected
              ? AppTheme.of(context)!.colorScheme.primary.onColor
              : AppTheme.of(context)!.colorScheme.background.onColor,
        ),
      ),
    );
  }
}

class MaximizeOrRestoreButtonSwitch extends StatelessWidget {
  const MaximizeOrRestoreButtonSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.isUseMaximizeOrRestoreButton,
      builder:
          (
            BuildContext context,
            bool isUseMaximizeOrRestoreButton,
            Widget? child,
          ) {
            return Align(
              alignment: Alignment.centerLeft,
              child: SmallButton(
                padding: const EdgeInsets.all(smallPadding),
                colorRole: ColorRole.background,
                transparent: false,
                width: smallDialogMaxWidth,
                height: mediumButtonSize,
                onClick: () {
                  if (isUseMaximizeOrRestoreButton) {
                    AppState.isUseMaximizeOrRestoreButton.value = false;
                  } else {
                    AppState.isUseMaximizeOrRestoreButton.value = true;
                  }
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${context.tr("maximizeOrRestoreButton")}: ${isUseMaximizeOrRestoreButton ? context.tr("enable") : context.tr("disable")}",
                    style: TextStyle(
                      color: AppTheme.of(
                        context,
                      )!.colorScheme.background.onColor,
                    ),
                  ),
                ),
              ),
            );
          },
    );
  }
}

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: smallCardMaxHeight,
      child: Row(
        spacing: bigListSpacing,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              context.tr("theme"),
              style: TextStyle(
                color: AppTheme.of(context)!.colorScheme.background.onColor,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: smallButtonContentSize,
                mainAxisSpacing: listSpacing,
                crossAxisSpacing: listSpacing,
                childAspectRatio: 1 / 1,
              ),
              itemCount: AppColorScheme.table.length,
              itemBuilder: (BuildContext context, int index) {
                final int color = AppColorScheme.table.keys.toList(
                  growable: false,
                )[index];
                return GestureDetector(
                  onTap: () {
                    AppState.theme.value = color;
                  },
                  child: ClipOval(child: Container(color: Color(color))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
