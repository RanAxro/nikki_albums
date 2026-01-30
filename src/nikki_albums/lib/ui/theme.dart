import "package:flutter/material.dart";


class AppTheme extends InheritedWidget{
  static final AppColorScheme defaultTheme = AppColorScheme.table[0xFFEEEEEE]!;

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
    return defaultTheme;
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
  highlight,
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
  final ColorRoleScheme highlight;

  const AppColorScheme({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.success,
    required this.error,
    required this.background,
    required this.highlight,
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
      case ColorRoles.highlight:
        return highlight;
    }
  }
}


const AppColorScheme theme1 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFFFFFFFF),
    onColor: Color(0xFF333333),
    enabledColor: Color(0xFFF3F3F3),
    disabledColor: Color(0xAAF3F3F3),
    onDisabledColor: Color(0x55333333),
    hoveredColor: Color(0xFFEEEEEE),
    onHoveredColor: Color(0xFF333333),
    pressedColor: Color(0xFFDDDDDD),
    onPressedColor: Color(0xFF333333),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFFF5F5F5),
    onColor: Color(0xFF333333),
    enabledColor: Color(0xFFE9E9E9),
    disabledColor: Color(0xAAE9E9E9),
    onDisabledColor: Color(0x55333333),
    hoveredColor: Color(0xFFE5E5E5),
    onHoveredColor: Color(0xFF333333),
    pressedColor: Color(0xFFD5D5D5),
    onPressedColor: Color(0xFF333333),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFFF5F5F5),
    onColor: Color(0xFF333333),
    enabledColor: Color(0xFFE9E9E9),
    disabledColor: Color(0xAAE9E9E9),
    onDisabledColor: Color(0x55333333),
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
    disabledColor: Color(0xAAF7F7F7),
    onDisabledColor: Color(0x55333333),
    hoveredColor: Color(0xFFE7E7E7),
    onHoveredColor: Color(0xFF333333),
    pressedColor: Color(0xFFD7D7D7),
    onPressedColor: Color(0xFF333333),
  ),
  highlight: ColorRoleScheme(
    color: Color(0xFF333333),
    onColor: Color(0xFFFFFFFF),
  ),
);



const AppColorScheme theme2 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFF333333),
    onColor: Color(0xFFEEEEEE),
    enabledColor: Color(0xFF404040),
    onDisabledColor: Color(0x55EEEEEE),
    hoveredColor: Color(0xFF444444),
    onHoveredColor: Color(0xFFEEEEEE),
    pressedColor: Color(0xFF555555),
    onPressedColor: Color(0xFFEEEEEE),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFF383838),
    onColor: Color(0xFFEEEEEE),
    enabledColor: Color(0xFF444444),
    onDisabledColor: Color(0x55EEEEEE),
    hoveredColor: Color(0xFF484848),
    onHoveredColor: Color(0xFFEEEEEE),
    pressedColor: Color(0xFF585858),
    onPressedColor: Color(0xFFEEEEEE),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFF383838),
    onColor: Color(0xFFEEEEEE),
    enabledColor: Color(0xFF444444),
    onDisabledColor: Color(0x55EEEEEE),
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
    onDisabledColor: Color(0x55EEEEEE),
    hoveredColor: Color(0xFF595959),
    onHoveredColor: Color(0xFFEEEEEE),
    pressedColor: Color(0xFF696969),
    onPressedColor: Color(0xFFEEEEEE),
  ),
  highlight: ColorRoleScheme(
    color: Color(0xFFEEEEEE),
    onColor: Color(0xFF444444),
  ),
);



const AppColorScheme theme3 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFFCCE7F6),
    onColor: Color(0xFF21556E),
    enabledColor: Color(0xFFB4DEF5),
    onDisabledColor: Color(0x5521556E),
    hoveredColor: Color(0xFFAFDAF1),
    onHoveredColor: Color(0xFF21556E),
    pressedColor: Color(0xFF9AD3F1),
    onPressedColor: Color(0xFF21556E),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFFDCF2FF),
    onColor: Color(0xFF21556E),
    enabledColor: Color(0xFFC6EAFF),
    onDisabledColor: Color(0x5521556E),
    hoveredColor: Color(0xFFC2E7FD),
    onHoveredColor: Color(0xFF21556E),
    pressedColor: Color(0xFFB0DDF7),
    onPressedColor: Color(0xFF21556E),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFFDCF2FF),
    onColor: Color(0xFF21556E),
    enabledColor: Color(0xFFC6EAFF),
    onDisabledColor: Color(0x5521556E),
    hoveredColor: Color(0xFFC2E7FD),
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
    onDisabledColor: Color(0x5521556E),
    hoveredColor: Color(0xFFB2D5EA),
    onHoveredColor: Color(0xFF21556E),
    pressedColor: Color(0xFF9ABDD1),
    onPressedColor: Color(0xFF21556E),
  ),
  highlight: ColorRoleScheme(
    color: Color(0xFF21556E),
    onColor: Color(0xFFECF3FB),
  ),
);



const AppColorScheme theme4 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFFFFE4F1),
    onColor: Color(0xFF7D2E50),
    enabledColor: Color(0xFFFFD5E8),
    onDisabledColor: Color(0x557D2E50),
    hoveredColor: Color(0xFFFFD1E4),
    onHoveredColor: Color(0xFF7D2E50),
    pressedColor: Color(0xFFFFBFD7),
    onPressedColor: Color(0xFF7D2E50),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFFFFEDF6),
    onColor: Color(0xFF7D2E50),
    enabledColor: Color(0xFFFFDEEF),
    onDisabledColor: Color(0x557D2E50),
    hoveredColor: Color(0xFFFFDAEB),
    onHoveredColor: Color(0xFF7D2E50),
    pressedColor: Color(0xFFFFC7E0),
    onPressedColor: Color(0xFF7D2E50),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFFFFEDF6),
    onColor: Color(0xFF7D2E50),
    enabledColor: Color(0xFFFFDEEF),
    hoveredColor: Color(0xFFFFDAEB),
    onDisabledColor: Color(0x557D2E50),
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
    onDisabledColor: Color(0x557D2E50),
    hoveredColor: Color(0xFFFFD1E4),
    onHoveredColor: Color(0xFF7D2E50),
    pressedColor: Color(0xFFFFBFD7),
    onPressedColor: Color(0xFF7D2E50),
  ),
  highlight: ColorRoleScheme(
    color: Color(0xFF7D2E50),
    onColor: Color(0xFFFFF5F9),
  ),
);



const AppColorScheme theme5 = AppColorScheme(
  primary: ColorRoleScheme(
    color: Color(0xFFFFF8E1),
    onColor: Color(0xFF6B5200),
    enabledColor: Color(0xFFFFF4C6),
    onDisabledColor: Color(0x556B5200),
    hoveredColor: Color(0xFFFFF0C2),
    onHoveredColor: Color(0xFF6B5200),
    pressedColor: Color(0xFFFFE8A3),
    onPressedColor: Color(0xFF6B5200),
  ),
  secondary: ColorRoleScheme(
    color: Color(0xFFFFFCF0),
    onColor: Color(0xFF6B5200),
    enabledColor: Color(0xFFFFFCDA),
    onDisabledColor: Color(0x556B5200),
    hoveredColor: Color(0xFFFFF8D6),
    onHoveredColor: Color(0xFF6B5200),
    pressedColor: Color(0xFFFFF4BC),
    onPressedColor: Color(0xFF6B5200),
  ),
  tertiary: ColorRoleScheme(
    color: Color(0xFFFFFCF0),
    onColor: Color(0xFF6B5200),
    enabledColor: Color(0xFFFFFCDA),
    onDisabledColor: Color(0x556B5200),
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
    onDisabledColor: Color(0x556B5200),
    hoveredColor: Color(0xFFFFF0C2),
    onHoveredColor: Color(0xFF6B5200),
    pressedColor: Color(0xFFFFE8A3),
    onPressedColor: Color(0xFF6B5200),
  ),
  highlight: ColorRoleScheme(
    color: Color(0xFF6B5200),
    onColor: Color(0xFFFFFCF5),
  ),
);