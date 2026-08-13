
import "package:flutter/material.dart";


Color getContrastColor(Color background){
  // 计算亮度 (YIQ 公式)
  final double yiq = ((background.red * 299) + (background.green * 587) + (background.blue * 114)) / 1000;

  return yiq >= 128 ? Colors.black : Colors.white;
}