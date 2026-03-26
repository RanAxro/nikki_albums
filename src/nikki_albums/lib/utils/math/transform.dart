

import "angle.dart";


import "dart:math";
import "dart:ui";






enum FitMode{
  contain,
  cover,
}

Point<double> rotatePoint(Point<double> point, double rotation, {AngleUnit unit = AngleUnit.radian}){
  final double angle = unit == AngleUnit.radian ? rotation : convertAngleUnits(rotation, AngleUnit.degree, AngleUnit.radian);
  final double sinA = sin(angle);
  final double cosA = cos(angle);

  final double x = point.x * cosA - point.y * sinA;
  final double y = point.x * sinA + point.y * cosA;

  return Point<double>(x, y);
}

Size getRotatingRectangleBoundary(Size rect, double rotation, {AngleUnit unit = AngleUnit.radian}){
  final double angle = unit == AngleUnit.radian ? rotation : convertAngleUnits(rotation, AngleUnit.degree, AngleUnit.radian);
  final double sinA = sin(angle).abs();
  final double cosA = cos(angle).abs();

  final double rWidth = rect.width * cosA + rect.height * sinA;
  final double rHeight = rect.width * sinA + rect.height * cosA;

  return Size(rWidth, rHeight);
}

double fitRectangleScale(Size boundary, Size adapted, {FitMode mode = FitMode.contain}){
  if(boundary.width <= 0 || boundary.height <= 0) return 0.0;
  if(adapted.width <= 0 || adapted.height <= 0) return 1.0;

  final double scaleW = boundary.width / adapted.width;
  final double scaleH = boundary.height / adapted.height;

  return switch(mode){
    FitMode.contain => min(scaleW, scaleH),
    FitMode.cover => max(scaleW, scaleH),
  };
}
//
Size fitRectangleSize(Size boundary, Size adapted, {FitMode mode = FitMode.contain}){
  final double scale = fitRectangleScale(boundary, adapted, mode: mode);

  return adapted * scale;
}

double fitRotatingRectangleScale(Size boundary, Size adapted, {FitMode mode = FitMode.contain, double boundaryRotation = 0, double adaptedRotation = 0, AngleUnit unit = AngleUnit.radian}){
  final Size rotatedAdaptedRect = getRotatingRectangleBoundary(adapted, adaptedRotation - boundaryRotation, unit: unit);

  final double scale = fitRectangleScale(boundary, rotatedAdaptedRect, mode: mode);

  return mode == FitMode.contain ? scale : 1 / scale;
}

Offset centerRectangle(Size boundary, Size centered){
  return Offset(
    0.5 * (boundary.width - centered.width),
    0.5 * (boundary.height - centered.height),
  );
}

Offset centerRotatingRectangle(Size boundary, Size centered, {double boundaryRotation = 0, double centeredRotation = 0, AngleUnit unit = AngleUnit.radian}){
  final Size rotatedBoundary = getRotatingRectangleBoundary(boundary, boundaryRotation, unit: unit);
  final Size rotatedCentered = getRotatingRectangleBoundary(centered, centeredRotation, unit: unit);

  return Offset(
    0.5 * (rotatedBoundary.width - rotatedCentered.width),
    0.5 * (rotatedBoundary.height - rotatedCentered.height),
  );
}



Offset transformPointRelativeToRotatingRectangle(Size rect, {double rotation = 0, Offset point = Offset.zero, AngleUnit unit = AngleUnit.radian}){
  double angle;
  if(unit == AngleUnit.degree){
    angle = convertAngleUnits(rotation, AngleUnit.degree, AngleUnit.radian);
  }else{
    angle = rotation;
  }
  angle = angle % (2 * pi) - pi;

  final double sinA = sin(angle);
  final double cosA = cos(angle);

  late final double x;
  late final double y;
  // [-π, -π/2]
  if(angle <= -0.5 * pi){
    x = -(rect.width - point.dx) * cosA - (rect.height - point.dy) * sinA;
    y = -point.dx * sinA - (rect.height - point.dy) * cosA;
  }
  // (-π/2, 0]
  else if(angle <= 0){
    x = -(rect.height - point.dy) * sinA + point.dx * cosA;
    y = -point.dx * sinA + point.dy * cosA;
  }
  // (0, π/2]
  else if(angle <= pi){
    x = point.dx * cosA + point.dy * sinA;
    y = (rect.width - point.dx) * sinA + point.dy * cosA;
  }
  // (π/2, π]
  else{
    x = point.dy * sinA - (rect.width - point.dx) * cosA;
    y = (rect.width - point.dx) * sinA - (rect.height - point.dy) * cosA;
  }

  return Offset(x, y);
}

double fitRotatingRectangleScaleWithReferencePoint(Size boundary, Size adapted, {Offset relativeToBoundary = Offset.zero, Offset relativeToAdapted = Offset.zero, double boundaryRotation = 0, double adaptedRotation = 0, AngleUnit unit = AngleUnit.radian}){

  final double angle = adaptedRotation - boundaryRotation;

  // double angle;
  // if(unit == AngleUnit.degree){
  //   angle = convertAngleUnits(adaptedRotation - boundaryRotation, AngleUnit.degree, AngleUnit.radian);
  // }else{
  //   angle = adaptedRotation - boundaryRotation;
  // }
  // angle = angle % (2 * pi) - pi;
  //
  final Size rotatingAdaptedBoundary = getRotatingRectangleBoundary(adapted, angle, unit: AngleUnit.radian);
  //
  // final double sinA = sin(angle);
  // final double cosA = cos(angle);
  // late final Offset relativeToRotatingAdaptedBoundary;
  // // [-π, -π/2]
  // if(angle <= -0.5 * pi){
  //   relativeToRotatingAdaptedBoundary = Offset(-(adapted.width - relativeToAdapted.dx) * cosA - (adapted.height - relativeToAdapted.dy) * sinA, -relativeToAdapted.dx * sinA - (adapted.height - relativeToAdapted.dy) * cosA);
  // }
  // // (-π/2, 0]
  // else if(angle <= 0){
  //   relativeToRotatingAdaptedBoundary = Offset(-(adapted.height - relativeToAdapted.dy) * sinA + relativeToAdapted.dx * cosA, -relativeToAdapted.dx * sinA + relativeToAdapted.dy * cosA);
  // }
  // // (0, π/2]
  // else if(angle <= pi){
  //   relativeToRotatingAdaptedBoundary = Offset(relativeToAdapted.dx * cosA + relativeToAdapted.dy * sinA, (adapted.width - relativeToAdapted.dx) * sinA + relativeToAdapted.dy * cosA);
  // }
  // // (π/2, π]
  // else{
  //   relativeToRotatingAdaptedBoundary = Offset(relativeToAdapted.dy * sinA - (adapted.width - relativeToAdapted.dx) * cosA, (adapted.width - relativeToAdapted.dx) * sinA - (adapted.height - relativeToAdapted.dy) * cosA);
  // }

  final Offset relativeToRotatingAdaptedBoundary = transformPointRelativeToRotatingRectangle(adapted, rotation: angle, point: relativeToAdapted, unit: unit);

  final double leftScale = relativeToBoundary.dx / relativeToRotatingAdaptedBoundary.dx;
  final double topScale = relativeToBoundary.dy / relativeToRotatingAdaptedBoundary.dy;
  final double rightScale = (boundary.width - relativeToBoundary.dx) / (rotatingAdaptedBoundary.width - relativeToRotatingAdaptedBoundary.dx);
  final double bottomScale = (boundary.height - relativeToBoundary.dy) / (rotatingAdaptedBoundary.height - relativeToRotatingAdaptedBoundary.dy);

  return min(min(leftScale, topScale), min(rightScale, bottomScale));
}




