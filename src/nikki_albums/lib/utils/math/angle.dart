import "dart:math";

enum AngleUnit { degree, radian }

double convertAngleUnits(double angle, AngleUnit from, AngleUnit to) {
  // 如果单位相同，直接返回
  if (from == to) {
    return angle;
  }

  // 度转弧度
  if (from == AngleUnit.degree && to == AngleUnit.radian) {
    return angle * (pi / 180.0);
  }

  // 弧度转度
  if (from == AngleUnit.radian && to == AngleUnit.degree) {
    return angle * (180.0 / pi);
  }

  return angle;
}
