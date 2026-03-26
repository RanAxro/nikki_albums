

import "package:flutter/painting.dart";

/// 获取Hue渐变色条
/// [centerColor] 色条的中心色
List<Color> getHueGradientColor(Color centerColor){
  // 提取主色的色相（Hue）
  final double dominantHue = _getHue(centerColor);

  // 生成鲜艳的色条：饱和度100%，亮度50%
  // 色条结构: [主色-180°, 主色-120°, 主色-60°, 主色, 主色+60°, 主色+120°, 主色+180°]
  final List<Color> centeredColors = <Color>[];
  final List<double> offsets = [-180.0, -120.0, -60.0, 0.0, 60.0, 120.0, 180.0];

  for(final double offset in offsets){
    final hue = (dominantHue + offset) % 360;
    // 固定饱和度100%，亮度50%，保证鲜艳
    final color = _hslToRGB(hue, 100.0, 50.0);
    centeredColors.add(color);
  }

  return centeredColors;
}


/// 提取色相（Hue）0-360
double _getHue(Color color){
  final double r = color.r;
  final double g = color.g;
  final double b = color.b;

  final double max = [r, g, b].reduce((a, b) => a > b ? a : b);
  final double min = [r, g, b].reduce((a, b) => a < b ? a : b);
  final double diff = max - min;

  if(diff == 0) return 0;

  late final double h;
  if(max == r){
    h = (g - b) / diff + (g < b ? 6 : 0);
  }else if(max == g){
    h = (b - r) / diff + 2;
  }else{
    h = (r - g) / diff + 4;
  }

  return h * 60;
}

/// HSL转Color（H:0-360, S:0-100, L:0-100）
Color _hslToRGB(double h, double s, double l){
  final double hue = h % 360;
  final double sat = s / 100;
  final double light = l / 100;

  final double c = (1 - (2 * light - 1).abs()) * sat;
  final double x = c * (1 - ((hue / 60) % 2 - 1).abs());
  final double m = light - c / 2;

  late final double r, g, b;
  if(hue < 60){
    r = c; g = x; b = 0;
  }else if(hue < 120){
    r = x; g = c; b = 0;
  }else if(hue < 180){
    r = 0; g = c; b = x;
  }else if(hue < 240){
    r = 0; g = x; b = c;
  }else if(hue < 300){
    r = x; g = 0; b = c;
  }else{
    r = c; g = 0; b = x;
  }

  return Color.fromRGBO(
    ((r + m) * 255).round(),
    ((g + m) * 255).round(),
    ((b + m) * 255).round(),
    1,
  );
}