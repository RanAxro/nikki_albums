import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "dart:io";
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
          if(!Platform.isMacOS) const MaximizeOrRestoreButtonSwitch(),
          const FollowSystemSwitch(),
          const ChangeTheme(),
        ],
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                child: Row(
                  children: [
                    Text(
                      context.tr("maximizeOrRestoreButton"),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.of(context)!.colorScheme.background.onColor,
                      ),
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isUseMaximizeOrRestoreButton,
                        onChanged: (bool value) {
                          AppState.isUseMaximizeOrRestoreButton.value = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
    );
  }
}

class FollowSystemSwitch extends StatelessWidget {
  const FollowSystemSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.isThemeFollowSystem,
      builder:
          (
            BuildContext context,
            bool isThemeFollowSystem,
            Widget? child,
          ) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                child: Row(
                  children: [
                    Text(
                      context.tr("followSystemAppearance"),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.of(context)!.colorScheme.background.onColor,
                      ),
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isThemeFollowSystem,
                        onChanged: (bool value) {
                          AppState.isThemeFollowSystem.value = value;
                        },
                      ),
                    ),
                  ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: smallPadding),
      child: SizedBox(
        height: smallCardMaxHeight,
        child: Row(
          spacing: bigListSpacing,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                context.tr("theme"),
                style: TextStyle(
                  fontSize: 14,
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
                      if (AppState.isThemeFollowSystem.value) {
                        final bool isClickedDark = (color == 0xFF333333);
                        final bool isSystemDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
                        if (isClickedDark != isSystemDark) {
                          AppState.isThemeFollowSystem.value = false;
                        }
                      }
                      AppState.theme.value = color;
                    },
                    child: ClipOval(child: Container(color: Color(color))),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
