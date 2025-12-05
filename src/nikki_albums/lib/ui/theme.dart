import "package:flutter/material.dart";


class AppTheme extends InheritedWidget{
  final int theme;

  const AppTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  AppColorScheme get colorScheme{
    if(AppColorScheme.table.containsKey(theme)){
      return AppColorScheme.table[theme]!;
    }
    return AppColorScheme.table[0xFFCCE7F6]!;
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget){
    return oldWidget.theme != theme;
  }

  static AppTheme? of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<AppTheme>();
  }
}

enum ColorRoles{
  primary,
  secondary,
  tertiary,
  success,
  error,
  background,
}

class ColorRoleScheme{
  final Color color;
  final Color onColor;
  final Color enabledColor;
  final Color onEnabledColor;
  final Color disabledColor;
  final Color onDisabledColor;
  final Color hoveredColor;
  final Color onHoveredColor;
  final Color pressedColor;
  final Color onPressedColor;

  const ColorRoleScheme({
    required this.color,
    required this.onColor,
    Color? enabledColor,
    Color? onEnabledColor,
    Color? disabledColor,
    Color? onDisabledColor,
    Color? hoveredColor,
    Color? onHoveredColor,
    Color? pressedColor,
    Color? onPressedColor
  }) :
    enabledColor = enabledColor ?? color,
    onEnabledColor = onEnabledColor ?? onColor,
    disabledColor = disabledColor ?? color,
    onDisabledColor = onDisabledColor ?? onColor,
    hoveredColor = hoveredColor ?? color,
    onHoveredColor = onHoveredColor ?? onColor,
    pressedColor = pressedColor ?? color,
    onPressedColor = onPressedColor ?? onColor;
}

class AppColorScheme{
  static Map<int, AppColorScheme> table = {
    0xFFEEEEEE: theme1,
    0xFF333333: theme2,
    0xFFCCE7F6: theme3,
    0xFFFFE4F1: theme4,
    0xFFFFF8E1: theme5,
  };

  final ColorRoleScheme primary;
  final ColorRoleScheme secondary;
  final ColorRoleScheme tertiary;
  final ColorRoleScheme success;
  final ColorRoleScheme error;
  final ColorRoleScheme background;

  const AppColorScheme({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.success,
    required this.error,
    required this.background
  });

  ColorRoleScheme byRole(ColorRoles role){
    switch(role){
      case ColorRoles.primary:
        return primary;
      case ColorRoles.secondary:
        return secondary;
      case ColorRoles.tertiary:
        return tertiary;
      case ColorRoles.success:
        return success;
      case ColorRoles.error:
        return error;
      case ColorRoles.background:
        return background;
    }
  }

  // final Color primary;
  // final Color onPrimary;
  // final Color primaryHovered;
  // final Color onPrimaryHovered;
  // final Color primaryPressed;
  // final Color onPrimaryPressed;
  //
  // final Color secondary;
  // final Color onSecondary;
  // final Color secondaryHovered;
  // final Color onSecondaryHovered;
  // final Color secondaryPressed;
  // final Color onSecondaryPressed;
  //
  // final Color error;
  // final Color onError;
  // final Color errorHovered;
  // final Color onErrorHovered;
  // final Color errorPressed;
  // final Color onErrorPressed;
  //
  // final Color background;
  // final Color onBackground;
}



// ColorScheme getColorScheme(int color){
//   if(themeTable.containsKey(color)) return themeTable[color]!;
//
//   // default theme
//   return theme2;
// }
//
// const Map<int, ColorScheme> themeTable = {
//   0xFF333333: theme2,
//   0xFFC0E2F5: theme3,
// };
//
// const ColorScheme theme2 = ColorScheme(
//   brightness: Brightness.light,
//   primary: Color(0xFF333333),
//   onPrimary: Color(0xFFEEEEEE),
//   primaryContainer: Color(0xFF666666),
//   onPrimaryContainer: Color(0xFFEEEEEE),
//   secondary: Color(0xFF444444),
//   onSecondary: Color(0xFFEEEEEE),
//   secondaryContainer: Color(0xFF666666),
//   onSecondaryContainer: Color(0xFFEEEEEE),
//   tertiary: Color(0xFF666666),
//   error: Color(0xFFFF0000),
//   onError: Color(0xFFEEEEEE),
//   surface: Color(0xFF222222),
//   onSurface: Color(0xFFEEEEEE),
//   shadow: Color(0x99000000),
// );

// const ColorScheme theme3 = ColorScheme(
//   brightness: Brightness.light,
//
//   primary: Color(0xFFC0E2F5),
//   onPrimary: Color(0xFF21556E),
//   primaryContainer: Color(0xFFa1d6f3),
//   onPrimaryContainer: Color(0xFF21556E),
//   primaryFixed: Color(0xFFa1d6f3),
//   onPrimaryFixed: Color(0xFF21556E),
//   primaryFixedDim: Color(0xFFa1d6f3),
//   onPrimaryFixedVariant: Color(0xFF21556E),
//
//   secondary: Color(0xFFDCF2FF),
//   onSecondary: Color(0xFF21556E),
//   secondaryContainer: Color(0xFFc2e7fd),
//   onSecondaryContainer: Color(0xFF21556E),
//   secondaryFixed: Color(0xFFc2e7fd),
//   onSecondaryFixed: Color(0xFF21556E),
//   secondaryFixedDim: Color(0xFFc2e7fd),
//   onSecondaryFixedVariant: Color(0xFF21556E),
//
//   tertiary: Color(0xFFB0CDED),
//   error: Color(0xFFE25041),
//   onError: Color(0xFF21556E),
//   surface: Color(0xFFf1f7fc),
//   onSurface: Color(0xFF21556E),
//   shadow: Color(0x99000000),
// );

const AppColorScheme theme1 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFFFFFFFF),
    onColor: Color(0xFF333333),
    hoveredColor: Color(0xFFEEEEEE),
    onHoveredColor: Color(0xFF333333),
    pressedColor: Color(0xFFDDDDDD),
    onPressedColor: Color(0xFF333333),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFFF5F5F5),
    onColor: Color(0xFF333333),
    hoveredColor: Color(0xFFE5E5E5),
    onHoveredColor: Color(0xFF333333),
    pressedColor: Color(0xFFD5D5D5),
    onPressedColor: Color(0xFF333333),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFFF5F5F5),
    onColor: Color(0xFF333333),
    hoveredColor: Color(0xFFE5E5E5),
    onHoveredColor: Color(0xFF333333),
    pressedColor: Color(0xFFD5D5D5),
    onPressedColor: Color(0xFF333333),
  ),
  success: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFF333333),
    hoveredColor: Color(0xFF00EE00),
    onHoveredColor: Color(0xFF333333),
    pressedColor: Color(0xFF00EE00),
    onPressedColor: Color(0xFF333333),
  ),
  error: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFF333333),
    hoveredColor: Color(0xFFEE7777),
    onHoveredColor: Color(0xFF333333),
    pressedColor: Color(0xFFEE4444),
    onPressedColor: Color(0xFF333333),
  ),
  background: ColorRoleScheme(
    color: Color(0xFFFFFFFF),
    onColor: Color(0xFF333333),
    enabledColor: Color(0xFFF7F7F7),
    hoveredColor: Color(0xFFE7E7E7),
    onHoveredColor: Color(0xFF333333),
    pressedColor: Color(0xFFD7D7D7),
    onPressedColor: Color(0xFF333333),
  ),
);



const AppColorScheme theme2 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFF333333),
    onColor: Color(0xFFEEEEEE),
    hoveredColor: Color(0xFF444444),
    onHoveredColor: Color(0xFFEEEEEE),
    pressedColor: Color(0xFF555555),
    onPressedColor: Color(0xFFEEEEEE),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFF383838),
    onColor: Color(0xFFEEEEEE),
    hoveredColor: Color(0xFF484848),
    onHoveredColor: Color(0xFFEEEEEE),
    pressedColor: Color(0xFF585858),
    onPressedColor: Color(0xFFEEEEEE),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFF383838),
    onColor: Color(0xFFEEEEEE),
    hoveredColor: Color(0xFF484848),
    onHoveredColor: Color(0xFFEEEEEE),
    pressedColor: Color(0xFF585858),
    onPressedColor: Color(0xFFEEEEEE),
  ),
  success: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFFEEEEEE),
    hoveredColor: Color(0xFF00EE00),
    onHoveredColor: Color(0xFFEEEEEE),
    pressedColor: Color(0xFF00EE00),
    onPressedColor: Color(0xFFEEEEEE),
  ),
  error: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFFEEEEEE),
    hoveredColor: Color(0xFFEE7777),
    onHoveredColor: Color(0xFFEEEEEE),
    pressedColor: Color(0xFFEE4444),
    onPressedColor: Color(0xFFEEEEEE),
  ),
  background: ColorRoleScheme(
    color: Color(0xFF444444),
    onColor: Color(0xFFEEEEEE),
    enabledColor: Color(0xFF494949),
    hoveredColor: Color(0xFF595959),
    onHoveredColor: Color(0xFFEEEEEE),
    pressedColor: Color(0xFF696969),
    onPressedColor: Color(0xFFEEEEEE),
  ),
);



const AppColorScheme theme3 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFFCCE7F6),
    onColor: Color(0xFF21556E),
    hoveredColor: Color(0xFFAFDAF1),
    onHoveredColor: Color(0xFF21556E),
    pressedColor: Color(0xFF9AD3F1),
    onPressedColor: Color(0xFF21556E),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFFDCF2FF),
    onColor: Color(0xFF21556E),
    hoveredColor: Color(0xFFc2e7fd),
    onHoveredColor: Color(0xFF21556E),
    pressedColor: Color(0xFFB0DDF7),
    onPressedColor: Color(0xFF21556E),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFFDCF2FF),
    onColor: Color(0xFF21556E),
    hoveredColor: Color(0xFFc2e7fd),
    onHoveredColor: Color(0xFF21556E),
    pressedColor: Color(0xFFc2e7fd),
    onPressedColor: Color(0xFF21556E),
  ),
  success: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFF21556E),
    hoveredColor: Color(0xFF5FE27A),
    onHoveredColor: Color(0xFF21556E),
    pressedColor: Color(0xFF5FE27A),
    onPressedColor: Color(0xFF21556E),
  ),
  error: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFF21556E),
    hoveredColor: Color(0xFFDD6B5C),
    onHoveredColor: Color(0xFF21556E),
    pressedColor: Color(0xFFE25041),
    onPressedColor: Color(0xFF21556E),
  ),
  background: ColorRoleScheme(
    color: Color(0xFFECF3FB),
    onColor: Color(0xFF21556E),
    enabledColor: Color(0xFFE2E9F1),
    hoveredColor: Color(0xFFB2D5EA),
    onHoveredColor: Color(0xFF21556E),
    pressedColor: Color(0xFF9ABDD1),
    onPressedColor: Color(0xFF21556E),
  ),
);



const AppColorScheme theme4 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFFFFE4F1),
    onColor: Color(0xFF7D2E50),
    hoveredColor: Color(0xFFFFD1E4),
    onHoveredColor: Color(0xFF7D2E50),
    pressedColor: Color(0xFFFFBFD7),
    onPressedColor: Color(0xFF7D2E50),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFFFFEDF6),
    onColor: Color(0xFF7D2E50),
    hoveredColor: Color(0xFFFFDAEB),
    onHoveredColor: Color(0xFF7D2E50),
    pressedColor: Color(0xFFFFC7E0),
    onPressedColor: Color(0xFF7D2E50),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFFFFEDF6),
    onColor: Color(0xFF7D2E50),
    hoveredColor: Color(0xFFFFDAEB),
    onHoveredColor: Color(0xFF7D2E50),
    pressedColor: Color(0xFFFFDAEB),
    onPressedColor: Color(0xFF7D2E50),
  ),
  success: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFF7D2E50),
    hoveredColor: Color(0xFF7ED96D),
    onHoveredColor: Color(0xFF7D2E50),
    pressedColor: Color(0xFF7ED96D),
    onPressedColor: Color(0xFF7D2E50),
  ),
  error: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFF7D2E50),
    hoveredColor: Color(0xFFF28B7D),
    onHoveredColor: Color(0xFF7D2E50),
    pressedColor: Color(0xFFEF6A59),
    onPressedColor: Color(0xFF7D2E50),
  ),
  background: ColorRoleScheme(
    color: Color(0xFFFFF5F9),
    onColor: Color(0xFF7D2E50),
    enabledColor: Color(0xFFFFEBF3),
    hoveredColor: Color(0xFFFFD1E4),
    onHoveredColor: Color(0xFF7D2E50),
    pressedColor: Color(0xFFFFBFD7),
    onPressedColor: Color(0xFF7D2E50),
  ),
);



const AppColorScheme theme5 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFFFFF8E1),
    onColor: Color(0xFF6B5200),
    hoveredColor: Color(0xFFFFF0C2),
    onHoveredColor: Color(0xFF6B5200),
    pressedColor: Color(0xFFFFE8A3),
    onPressedColor: Color(0xFF6B5200),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFFFFFCF0),
    onColor: Color(0xFF6B5200),
    hoveredColor: Color(0xFFFFF8D6),
    onHoveredColor: Color(0xFF6B5200),
    pressedColor: Color(0xFFFFF4BC),
    onPressedColor: Color(0xFF6B5200),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFFFFFCF0),
    onColor: Color(0xFF6B5200),
    hoveredColor: Color(0xFFFFF8D6),
    onHoveredColor: Color(0xFF6B5200),
    pressedColor: Color(0xFFFFF8D6),
    onPressedColor: Color(0xFF6B5200),
  ),
  success: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFF6B5200),
    hoveredColor: Color(0xFF9ED96D),
    onHoveredColor: Color(0xFF6B5200),
    pressedColor: Color(0xFF9ED96D),
    onPressedColor: Color(0xFF6B5200),
  ),
  error: ColorRoleScheme(
    color: Color(0x00000000),
    onColor: Color(0xFF6B5200),
    hoveredColor: Color(0xFFFFA884),
    onHoveredColor: Color(0xFF6B5200),
    pressedColor: Color(0xFFFF8A5C),
    onPressedColor: Color(0xFF6B5200),
  ),
  background: ColorRoleScheme(
    color: Color(0xFFFFFCF5),
    onColor: Color(0xFF6B5200),
    enabledColor: Color(0xFFFFF8E7),
    hoveredColor: Color(0xFFFFF0C2),
    onHoveredColor: Color(0xFF6B5200),
    pressedColor: Color(0xFFFFE8A3),
    onPressedColor: Color(0xFF6B5200),
  ),
);