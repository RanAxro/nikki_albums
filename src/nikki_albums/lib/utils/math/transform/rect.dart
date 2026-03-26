

import "dart:math";
import 'package:vector_math/vector_math.dart';

class Rect{
  double width;
  double height;
  Vector2 center;
  double angle;

  Rect({
    required this.width,
    required this.height,
    required this.center,
    this.angle = 0,
  });

  double get halfWidth => 0.5 * width;
  double get halfHeight => 0.5 * height;

  List<Vector2> get localCorners{
    final Matrix2 matrix = Matrix2.rotation(-angle);

    List<Vector2> corners = [Vector2(-halfWidth, halfHeight), Vector2(halfWidth, halfHeight), Vector2(halfWidth, -halfHeight), Vector2(-halfWidth, -halfHeight)];

    return corners.map((Vector2 corner) => matrix.transform(corner)).toList();
  }

  List<Vector2> get corners{
    return localCorners.map((Vector2 corner) => corner + center).toList();
  }

  double get area => width * height;

  Rect get boundingRect{
    final double sinA = sin(angle).abs();
    final double cosA = cos(angle).abs();

    final double rWidth = width * cosA + height * sinA;
    final double rHeight = width * sinA + height * cosA;

    return Rect(width: rWidth, height: rHeight, center: center, angle: 0);
  }

  bool isContainPoint(Vector2 point){
    final Matrix2 matrix = Matrix2.rotation(-angle);

    final Vector2 compared = matrix.transformed(point - center);

    return compared.x > -halfWidth && compared.x < halfWidth && compared.y > -halfHeight && compared.y < halfHeight;
  }

  bool isContainWith(Rect compared){
    for(final Vector2 corner in compared.corners){
      if(!isContainPoint(corner)) return false;
    }

    return true;
  }

  bool isContainedWithin(Rect compared){
    for(final Vector2 corner in corners){
      if(!compared.isContainPoint(corner)) return false;
    }

    return true;
  }

  bool isIntersectWith(Rect compared){
    // 辅助函数：获取边的垂直法向量（归一化）
    Vector2 getNormal(Vector2 p1, Vector2 p2){
      final Vector2 edge = p2 - p1;
      final double len = sqrt(edge.x * edge.x + edge.y * edge.y);
      return len < 1e-10 ? Vector2.zero() : Vector2(-edge.y / len, edge.x / len);
    }

    // 辅助函数：计算矩形在轴上的投影最小值和最大值
    // 返回 [min, max] 存储在 Vector2 中（x=min, y=max）
    Vector2 project(List<Vector2> corners, Vector2 axis){
      double min = double.infinity;
      double max = double.negativeInfinity;
      for(final corner in corners){
        final double proj = corner.x * axis.x + corner.y * axis.y;
        if (proj < min) min = proj;
        if (proj > max) max = proj;
      }
      return Vector2(min, max);
    }

    // 辅助函数：检查两个投影区间是否分离
    bool isSeparated(Vector2 proj1, Vector2 proj2) {
      return proj1.y < proj2.x || proj2.y < proj1.x;
    }

    final myCorners = corners;
    final otherCorners = compared.corners;

    // 4个分离轴：当前矩形的2条边 + 比较矩形的2条边
    final axes = [
      getNormal(myCorners[0], myCorners[1]),      // 当前矩形上边
      getNormal(myCorners[1], myCorners[2]),      // 当前矩形右边
      getNormal(otherCorners[0], otherCorners[1]), // 比较矩形上边
      getNormal(otherCorners[1], otherCorners[2]), // 比较矩形右边
    ];

    // 在每个轴上检测投影是否重叠
    for (final axis in axes) {
      // 跳过零向量（边退化情况）
      if (axis.length < 1e-10) continue;

      if (isSeparated(project(myCorners, axis), project(otherCorners, axis))) {
        return false; // 找到分离轴，不相交
      }
    }

    return true; // 没有分离轴，相交
  }
}