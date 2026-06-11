import "package:flutter/material.dart";
import "dart:io";

const double smallButtonSize = 36;
const double smallButtonContentSize = 20;
const double mediumButtonSize = 40;
const double mediumButtonContentSize = 26;
const double bigButtonSize = 80;
const double bigButtonContentSize = 62;
const double largeButtonSize = 160;
const double largeButtonContentSize = 140;

const double windowTitleBarHeight = smallButtonSize + 10;
const double androidTitleBarHeight = smallButtonSize + 15;
const double topBarHeight = smallButtonSize + 8;

/// Parses the runtime macOS major version from [Platform.operatingSystemVersion].
/// Returns 0 on non-macOS platforms or if parsing fails.
final int macOSMajorVersion = () {
  if (!Platform.isMacOS) return 0;
  // e.g. "Version 26.0 (Build 25A5279m)"
  final match = RegExp(
    r'Version (\d+)',
  ).firstMatch(Platform.operatingSystemVersion);
  return int.tryParse(match?.group(1) ?? '') ?? 0;
}();

/// Reserved width for native macOS traffic light buttons.
/// macOS 26+ (Tahoe): 28px buttons with 8px HIG gaps need more space.
/// macOS 14–15: smaller buttons with tighter default spacing.
final double macOSTrafficLightWidth = macOSMajorVersion >= 26 ? 120 : 88;

const double sideBarWidth = mediumButtonSize + 10;
const double sideBarExpandWidth = 200;

const double smallDialogMaxWidth = 400;
const double smallCardMaxWidth = 400;
const double smallCardMaxHeight = 100;
const double mediumCardMaxWidth = 800;
const double mediumCardMaxHeight = 300;
const double toastMaxWidth = 400;
const double toastMaxHeight = 150;

const double smallTextFieldHeight = 48;
const double iconWeakeningRate = 0.5;
const double tinyBorder = 0.25;
const double smallBorder = 2;
const double scrollbarThickness = 12;
const double smallDividerThickness = 1;
const double smallBorderRadius = 8;
const double sliderThickness = 8;
const double topBarPadding = (topBarHeight - smallButtonSize) / 2;
const double tinyPadding = 4;
const double smallPadding = 8;
const double bigPadding = 20;
const double bigListSpacing = 16;
const double listSpacing = 6;

const SizedBox block0 = SizedBox(width: 0, height: 0);
const SizedBox block5W = SizedBox(width: 5);
const SizedBox block10W = SizedBox(width: 10);
const SizedBox block15W = SizedBox(width: 15);
const SizedBox block20W = SizedBox(width: 20);
const SizedBox block5H = SizedBox(height: 5);
const SizedBox block10H = SizedBox(height: 10);
const SizedBox block20H = SizedBox(height: 20);

const Duration animationTime = Duration(milliseconds: 100);
const Duration imageToggleDuration = Duration(milliseconds: 300);
const Curve animationCurve = Curves.linear;
const Duration toastDuration = Duration(milliseconds: 3000);

const double dialogSafePadding = 40;
const double dialogBorderRadius = smallBorderRadius + 0.5 * smallPadding;

double get safeMargin {
  if (Platform.isWindows) {
    return 5;
  }
  return 0;
}
