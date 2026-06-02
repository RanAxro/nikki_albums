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
        spacing: listSpacing,
        children: [
          if(!Platform.isMacOS) const MaximizeOrRestoreButtonSwitch(),
          const FollowSystemSwitch(),
          block5H,
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
      builder: (BuildContext context, bool isUseMaximizeOrRestoreButton, Widget? child){
        return AppSwitchButton(
          value: isUseMaximizeOrRestoreButton,
          onChanged: (bool value) {
            AppState.isUseMaximizeOrRestoreButton.value = value;
          },
          child: AppText("maximizeOrRestoreButton", fontSize: 14),
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
      builder: (BuildContext context, bool isThemeFollowSystem, Widget? child){
        return AppSwitchButton(
          value: isThemeFollowSystem,
          onChanged: (bool value) {
            AppState.isThemeFollowSystem.value = value;
          },
          child: AppText("followSystemAppearance", fontSize: 14),
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
