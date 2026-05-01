import "dart:async";

import "package:nikki_albums/widgets/common/component.dart";

import "component.dart";

import "package:bitsdojo_window/bitsdojo_window.dart";
import "package:flutter/services.dart";

import "package:flutter/material.dart";
import "dart:io";

Future<T?> showAppDialog<T extends Object?>({
  required BuildContext context,
  bool isBarrier = false,
  Duration transitionDuration = animationTime,
  required Widget Function(BuildContext context) builder,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: transitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) {
      return GestureDetector(
        onTap: () {
          if (isBarrier) {
            SystemSound.play(SystemSoundType.alert);
          } else {
            Navigator.pop(context);
          }
        },
        onPanStart: (_) {
          if (Platform.isWindows) {
            appWindow.startDragging();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(dialogSafePadding),
          color: Colors.black54,
          child: Center(
            child: GestureDetector(
              onTap: () {},
              onPanStart: (_) {},
              child: Builder(builder: builder),
            ),
          ),
        ),
      );
    },
  );
}

class AppDialog extends StatelessWidget {
  final ColorRole colorRole;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final double? maxHeight;
  final BoxConstraints? constraints;
  final bool useIntrinsicWidth;
  final bool useIntrinsicHeight;
  final String? title;
  final bool isTranslate;
  final bool useCloseButton;
  final Widget child;

  const AppDialog({
    super.key,
    this.colorRole = ColorRole.background,
    this.borderRadius = dialogBorderRadius,
    this.padding = const EdgeInsets.all(smallPadding),
    this.maxWidth,
    this.maxHeight,
    this.constraints,
    this.useIntrinsicWidth = false,
    this.useIntrinsicHeight = true,
    this.title,
    this.isTranslate = true,
    this.useCloseButton = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;

    if (title != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: smallButtonSize,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: smallPadding),
                    child: AppText(
                      title!,
                      isTranslate: isTranslate,
                      fontSize: smallButtonContentSize,
                    ),
                  ),
                ),
                if (useCloseButton)
                  AppButton.smallIcon(
                    onClick: Navigator.of(context).pop,
                    child: AppIcon("cross", height: 20),
                  ),
              ],
            ),
          ),

          Expanded(child: child),
        ],
      );
    }

    child = ConstrainedBox(
      constraints:
          constraints ??
          BoxConstraints(
            maxWidth: maxWidth ?? double.infinity,
            maxHeight: maxHeight ?? double.infinity,
          ),
      child: Padding(padding: padding ?? const EdgeInsets.all(0), child: child),
    );

    if (useIntrinsicWidth) {
      child = IntrinsicWidth(child: child);
    }
    if (useIntrinsicHeight) {
      child = IntrinsicHeight(child: child);
    }

    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: AppBackground(colorRole: colorRole, child: child),
      ),
    );
  }
}

class AppConfirmDialog extends StatelessWidget {
  final ColorRole colorRole;
  final double? maxWidth;
  final double? maxHeight;
  final BoxConstraints? constraints;
  final bool useIntrinsicWidth;
  final bool useIntrinsicHeight;
  final String? title;
  final bool isTranslateTitle;
  final bool useCloseButton;
  final String? message;
  final bool isTranslateMessage;
  final String yMessage;
  final bool isTranslateYMessage;
  final String nMessage;
  final bool isTranslateNMessage;
  final bool isRisk;

  const AppConfirmDialog({
    super.key,
    this.colorRole = ColorRole.background,
    this.maxWidth = smallCardMaxWidth,
    this.maxHeight,
    this.constraints,
    this.useIntrinsicWidth = false,
    this.useIntrinsicHeight = true,
    this.title,
    this.isTranslateTitle = true,
    this.useCloseButton = false,
    this.message,
    this.isTranslateMessage = false,
    this.yMessage = "confirm",
    this.isTranslateYMessage = true,
    this.nMessage = "cancel",
    this.isTranslateNMessage = true,
    this.isRisk = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      colorRole: colorRole,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      constraints: constraints,
      useIntrinsicWidth: useIntrinsicWidth,
      useIntrinsicHeight: useIntrinsicHeight,
      title: title,
      isTranslate: isTranslateTitle,
      useCloseButton: useCloseButton,
      child: Column(
        spacing: listSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          SmoothPointerScroll(
            builder:
                (
                  BuildContext context,
                  ScrollController controller,
                  ScrollPhysics physics,
                  IndependentScrollbarController scrollbarController,
                ) {
                  return SingleChildScrollView(
                    child: AppText(message!, isTranslate: isTranslateMessage),
                  );
                },
          ),

          Row(
            spacing: listSpacing,
            children: isRisk
                ? [
                    Expanded(
                      child: AppButton.smallIcon(
                        width: null,
                        isTransparent: false,
                        onClick: () {
                          Navigator.of(context).pop(true);
                        },
                        child: AppText(yMessage),
                      ),
                    ),
                    Expanded(
                      child: AppButton.smallIcon(
                        width: null,
                        colorRole: ColorRole.highlight,
                        isTransparent: false,
                        onClick: () {
                          Navigator.of(context).pop(false);
                        },
                        child: AppText(nMessage),
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: AppButton.smallIcon(
                        width: null,
                        isTransparent: false,
                        onClick: () {
                          Navigator.of(context).pop(false);
                        },
                        child: AppText(nMessage),
                      ),
                    ),
                    Expanded(
                      child: AppButton.smallIcon(
                        width: null,
                        colorRole: ColorRole.highlight,
                        isTransparent: false,
                        onClick: () {
                          Navigator.of(context).pop(true);
                        },
                        child: AppText(yMessage),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

abstract class AppToast {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;
  static bool isShowing = false;

  static void show({
    required BuildContext context,
    Duration? duration = toastDuration,
    ColorRole colorRole = ColorRole.background,
    bool state = true,
    String title = "ui_toast_tip",
    bool isTranslate = true,
    required Widget child,
  }) {
    hide();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          right: 20,
          bottom: 40,
          child: Material(
            color: AppThemeColor.transparent,
            child: AppThemeRole(
              colorRole: colorRole,
              child: SlideFadeIn(
                offsetBegin: Offset(100, 0),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: topBarPadding,
                    right: topBarPadding,
                    bottom: topBarPadding,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(smallBorderRadius),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.3],
                      colors: [
                        state
                            ? AppThemeColor.littleGreen
                            : AppThemeColor.littleRed,
                        AppColorScheme.of(
                          context,
                        ).byRole(ColorRole.of(context)).color,
                      ],
                    ),
                    boxShadow: [
                      const BoxShadow(
                        color: AppThemeColor.shadow,
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  width: toastMaxWidth,
                  height: toastMaxHeight,
                  child: Column(
                    children: [
                      SizedBox(
                        height: topBarHeight,
                        child: Row(
                          children: [
                            SizedBox(width: smallPadding),
                            Expanded(
                              child: AppText(
                                title,
                                isTranslate: isTranslate,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppButton.smallIcon(
                              onClick: hide,
                              child: AppIcon("cross"),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    isShowing = true;
    if (duration != null) {
      _timer = Timer(duration, () {
        hide();
      });
    }
  }

  static void showMessage({
    required BuildContext context,
    Duration duration = toastDuration,
    ColorRole colorRole = ColorRole.background,
    bool state = true,
    String title = "ui_toast_tip",
    bool isTranslate = true,
    required String message,
  }) {
    show(
      context: context,
      duration: duration,
      colorRole: colorRole,
      state: state,
      title: title,
      isTranslate: isTranslate,
      child: AppText(message, isTranslate: false),
    );
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _timer?.cancel();
    _timer = null;
    isShowing = false;
  }
}
