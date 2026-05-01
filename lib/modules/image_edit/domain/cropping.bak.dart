import "dart:math";
import "package:nikki_albums/widgets/app/component.dart";
import "package:vector_math/vector_math.dart" hide Colors;
import "dart:ui";

import "package:flutter/gestures.dart" hide Matrix4;
import "package:flutter/material.dart" hide Matrix4;
import "package:flutter/material.dart" as m show Matrix4;
import "package:nikki_albums/utils/math/transform.dart";

extension on Vector4 {
  double get left => this[0];
  double get top => this[1];
  double get right => this[2];
  double get bottom => this[3];
  double get rectWidth => right - left;
  double get rectHeight => bottom - top;

  set left(double l) => this[0] = l;
  set top(double t) => this[1] = t;
  set right(double r) => this[2] = r;
  set bottom(double b) => this[3] = b;

  Vector4 multiplied(Vector4 other) {
    final Vector4 vec = Vector4.copy(this);
    return vec..multiply(other);
  }
}

enum CropFrameRatio {
  free(double.nan),
  origin(double.nan),
  current(double.nan),
  w1h1(1 / 1),
  w3h4(3 / 4),
  w4h3(4 / 3),
  w16h9(16 / 9),
  w9h16(9 / 16),
  w2h3(2 / 3),
  w3h2(3 / 2),
  w2h1(2 / 1),
  w1h2(1 / 2);

  final double ratio;
  const CropFrameRatio(this.ratio);
}

enum CropFrameAnchorPoint {
  none(0, 0, 0, 0),
  center(1, 1, 1, 1),
  left(1, 0, 0, 0),
  top(0, 1, 0, 0),
  right(0, 0, 1, 0),
  bottom(0, 0, 0, 1),
  leftTop(1, 1, 0, 0),
  rightTop(0, 1, 1, 0),
  leftBottom(1, 0, 0, 1),
  rightBottom(0, 0, 1, 1);

  final int tl, tt, tr, tb;
  const CropFrameAnchorPoint(this.tl, this.tt, this.tr, this.tb);

  static final _fragMap = <CropFrameAnchorPoint, Vector4>{};

  Vector4 get frag {
    if (!_fragMap.containsKey(this)) {
      _fragMap[this] = Vector4(
        tl.toDouble(),
        tt.toDouble(),
        tr.toDouble(),
        tb.toDouble(),
      );
    }

    return _fragMap[this]!;
  }
}

// class CropFrame{
//   double left;
//   double top;
//   double right;
//   double bottom;
//
//   CropFrame._(this.left, this.top, this.right, this.bottom);
//
//   factory CropFrame.fromLTRB({
//     required double left,
//     required double top,
//     required double right,
//     required double bottom,
//   }){
//     return CropFrame._(left, top, right, bottom);
//   }
//
//   factory CropFrame.fromFullImage(num width, num height){
//     return CropFrame._(0, 0, width.toDouble(), height.toDouble());
//   }
// }

enum ImageCroppingType {
  rotation,
  cropFrameRatio,
  cropFrameLeft,
  cropFrameTop,
  cropFrameRight,
  cropFrameBottom,
}

class ImageCroppingParamDef<T> {
  static const ImageCroppingParamDef rotation = ImageCroppingParamDef<double>(
    ImageCroppingType.rotation,
    "ie_rotation",
    0,
  );
  static const ImageCroppingParamDef cropFrameRatio =
      ImageCroppingParamDef<CropFrameRatio>(
        ImageCroppingType.cropFrameRatio,
        "ie_crop_frame_ratio",
        CropFrameRatio.free,
      );
  static const ImageCroppingParamDef cropFrameLeft =
      ImageCroppingParamDef<double>(
        ImageCroppingType.cropFrameLeft,
        "ie_crop_frame_left",
        0,
      );
  static const ImageCroppingParamDef cropFrameTop =
      ImageCroppingParamDef<double>(
        ImageCroppingType.cropFrameTop,
        "ie_crop_frame_top",
        0,
      );
  static const ImageCroppingParamDef cropFrameRight =
      ImageCroppingParamDef<double>(
        ImageCroppingType.cropFrameRight,
        "ie_crop_frame_right",
        0,
      );
  static const ImageCroppingParamDef cropFrameBottom =
      ImageCroppingParamDef<double>(
        ImageCroppingType.cropFrameBottom,
        "ie_crop_frame_bottom",
        0,
      );

  static const Map<ImageCroppingType, ImageCroppingParamDef> _def = {
    ImageCroppingType.rotation: rotation,
    ImageCroppingType.cropFrameRatio: cropFrameRatio,
    ImageCroppingType.cropFrameLeft: cropFrameLeft,
    ImageCroppingType.cropFrameTop: cropFrameTop,
    ImageCroppingType.cropFrameRight: cropFrameRight,
    ImageCroppingType.cropFrameBottom: cropFrameBottom,
  };

  static ImageCroppingParamDef by(ImageCroppingType type) => _def[type]!;

  final ImageCroppingType type;
  final String key;
  final T defaultValue;

  const ImageCroppingParamDef(this.type, this.key, this.defaultValue);
}

class ImageCroppingParams {
  static final ImageCroppingParams defaultParams = ImageCroppingParams(
    rotation: ImageCroppingParamDef.rotation.defaultValue,
    cropFrameRatio: ImageCroppingParamDef.cropFrameRatio.defaultValue,
    cropFrameLeft: ImageCroppingParamDef.cropFrameLeft.defaultValue,
    cropFrameTop: ImageCroppingParamDef.cropFrameTop.defaultValue,
    cropFrameRight: ImageCroppingParamDef.cropFrameRight.defaultValue,
    cropFrameBottom: ImageCroppingParamDef.cropFrameBottom.defaultValue,
  );

  final double rotation;
  final CropFrameRatio cropFrameRatio;
  final double cropFrameLeft;
  final double cropFrameTop;
  final double cropFrameRight;
  final double cropFrameBottom;

  const ImageCroppingParams({
    required this.rotation,
    required this.cropFrameRatio,
    required this.cropFrameLeft,
    required this.cropFrameTop,
    required this.cropFrameRight,
    required this.cropFrameBottom,
  });
}

// class ImageCroppingProcessor extends ChangeNotifier{
//   final double imageWidth;
//   final double imageHeight;
//   double _rotation;
//   CropFrameRatio _frameRatio;
//   double _frameLeft;
//   double _frameTop;
//   double _frameRight;
//   double _frameBottom;
//
//   ImageCroppingProcessor({
//     required this.imageWidth,
//     required this.imageHeight,
//     double rotation = 0,
//     CropFrameRatio ratio = CropFrameRatio.free,
//     double left = 0,
//     double top = 0,
//     double right = 0,
//     double bottom = 0,
//   }) :
//     _rotation = rotation,
//     _frameRatio = ratio,
//     _frameLeft = left,
//     _frameTop = top,
//     _frameRight = right,
//     _frameBottom = bottom
//   {
//     _init();
//   }
//
//   late double _canvasWidth;
//   late double _canvasHeight;
//   late double _left;
//   late double _top;
//   late double _right;
//   late double _bottom;
//
//   void _init(){
//     _calculateRotatingRect();
//     _left = _frameLeft;
//     _top = _frameTop;
//     _right = _frameRight;
//     _bottom = _frameBottom;
//   }
//
//   Size get imageSize => Size(imageWidth, imageHeight);
//   double get canvasWidth => _canvasWidth;
//   double get canvasHeight => _canvasHeight;
//   // Size get canvasSize => Size(canvasWidth, canvasHeight);
//   // double get frameWidth => (canvasWidth - _frameRight) - _frameLeft;
//   // double get frameHeight => (canvasHeight - _frameBottom) - _frameTop;
//   // Size get frameSize => Size(frameWidth, frameHeight);
//   // double get virtualWidth => (canvasWidth - _right) - _left;
//   // double get virtualHeight => (canvasHeight - _bottom) - _top;
//   // Size get virtualSize => Size(virtualWidth, virtualHeight);
//
//   void _calculateRotatingRect(){
//     final Size rSize = getRotatingRectangleBoundary(imageSize, _rotation, unit: AngleUnit.degree);
//     _canvasWidth = rSize.width;
//     _canvasHeight = rSize.height;
//   }
//
//   set rotation(double newRotation){
//     transformEnd();
//
//     /// TODO
//   }
//
//
//   CropFrameAnchorPoint _anchorPoint = CropFrameAnchorPoint.center;
//
//   void transformStart(CropFrameAnchorPoint anchorPoint){
//     _anchorPoint = anchorPoint;
//   }
//
//   void transformUpdate(Offset offset){
//     _left += offset.dx * _anchorPoint.tl;
//     _top += offset.dy * _anchorPoint.tt;
//     _right += offset.dx * _anchorPoint.tr;
//     _bottom += offset.dy * _anchorPoint.tb;
//
//     _updateFrame();
//
//     notifyListeners();
//   }
//
//   // void _getFixedPoint
//
//   void _updateFrame(){
//
//   }
//
//   void transformEnd(){
//     _anchorPoint = CropFrameAnchorPoint.center;
//     _left = _frameLeft;
//     _top = _frameTop;
//     _right = _frameRight;
//     _bottom = _frameBottom;
//   }
// }

class _Rect {
  Vector2 _center;
  double halfWidth;
  double halfHeight;
  double rotation;

  _Rect(Vector2 center, this.halfWidth, this.halfHeight, this.rotation)
    : _center = center.clone();

  factory _Rect.zero() {
    return _Rect(Vector2.zero(), 0, 0, 0);
  }

  factory _Rect.from(_Rect arg) {
    return _Rect(arg.center, arg.halfWidth, arg.halfHeight, arg.rotation);
  }

  Size get halfSize => Size(halfWidth, halfHeight);
  double get width => 2 * halfWidth;
  double get height => 2 * halfHeight;
  Size get size => Size(width, height);
  double get area => width * height;
  double get ratio => width / height;

  double get sinR => sin(rotation);
  double get cosR => cos(rotation);
  double get sinRAbs => sinR.abs();
  double get cosRAbs => cosR.abs();

  double get boundaryHalfWidth => halfWidth * cosRAbs + halfHeight * sinRAbs;
  double get boundaryHalfHeight => halfWidth * sinRAbs + halfHeight * cosRAbs;
  Size get boundaryHalfSize => Size(boundaryHalfWidth, boundaryHalfHeight);
  double get boundaryWidth => 2 * boundaryHalfWidth;
  double get boundaryHeight => 2 * boundaryHalfHeight;
  Size get boundarySize => Size(boundaryWidth, boundaryHeight);
  double get boundaryArea => boundaryHalfWidth * boundaryHalfHeight;
  double get boundaryRatio => boundaryHalfWidth / boundaryHalfHeight;

  double get centerX => _center.x;
  double get centerY => _center.y;
  Vector2 get center => _center.clone();

  Vector2 get localUnrotatedRightBottom => Vector2(halfWidth, halfHeight);
  Vector2 get localUnrotatedRightTop => Vector2(halfWidth, -halfHeight);
  Vector2 get localUnrotatedLeftTop => Vector2(-halfWidth, -halfHeight);
  Vector2 get localUnrotatedLeftBottom => Vector2(-halfWidth, halfHeight);
  List<Vector2> get localRawPoints => [
    localUnrotatedRightBottom,
    localUnrotatedRightTop,
    localUnrotatedLeftTop,
    localUnrotatedLeftBottom,
  ];
  List<Vector2> get localRawAxisPoints => [
    localUnrotatedRightBottom,
    localUnrotatedRightTop,
  ];

  Vector2 get localRightBottom =>
      Matrix2.rotation(rotation).transform(localUnrotatedRightBottom);
  Vector2 get localRightTop =>
      Matrix2.rotation(rotation).transform(localUnrotatedRightTop);
  Vector2 get localLeftTop =>
      Matrix2.rotation(rotation).transform(localUnrotatedLeftTop);
  Vector2 get localLeftBottom =>
      Matrix2.rotation(rotation).transform(localUnrotatedLeftBottom);
  List<Vector2> get localPoints => [
    localRightBottom,
    localRightTop,
    localLeftTop,
    localLeftBottom,
  ];
  List<Vector2> get localAxisPoints => [localRightBottom, localRightTop];

  Vector2 get unrotatedRightBottom => localUnrotatedRightBottom + center;
  Vector2 get unrotatedRightTop => localUnrotatedRightTop + center;
  Vector2 get unrotatedLeftTop => localUnrotatedLeftTop + center;
  Vector2 get unrotatedLeftBottom => localUnrotatedLeftBottom + center;
  List<Vector2> get rawPoints => [
    unrotatedRightBottom,
    unrotatedRightTop,
    unrotatedLeftTop,
    unrotatedLeftBottom,
  ];
  List<Vector2> get rawAxisPoints => [unrotatedRightBottom, unrotatedRightTop];

  Vector2 get rightBottom => localRightBottom + center;
  Vector2 get rightTop => localRightTop + center;
  Vector2 get leftTop => localLeftTop + center;
  Vector2 get leftBottom => localLeftBottom + center;
  List<Vector2> get points => [rightBottom, rightTop, leftTop, leftBottom];
  List<Vector2> get axisPoints => [rightBottom, rightTop];

  set halfSize(Size hSize) {
    halfWidth = hSize.width;
    halfHeight = hSize.height;
  }

  set width(double w) {
    halfWidth = 0.5 * w;
  }

  set height(double h) {
    halfHeight = 0.5 * h;
  }

  set size(Size size) {
    halfWidth = 0.5 * size.width;
    halfHeight = 0.5 * size.height;
  }

  set centerX(double cx) {
    _center.x = cx;
  }

  set centerY(double cy) {
    _center.y = cy;
  }

  set center(Vector2 c) {
    _center.setFrom(c);
  }

  bool containLocalPoint(Vector2 point) {
    final double s1 = localRightBottom.cross(point).abs();
    final double s2 = localRightTop.cross(point).abs();
    return s1 + s2 <= 0.5 * area;
  }

  bool containPoint(Vector2 point) => containLocalPoint(point - _center);

  bool containRect(_Rect rect) {
    final bool r1 = containLocalPoint(rect.localRightBottom);
    final bool r2 = containLocalPoint(rect.localRightTop);
    final bool r3 = containLocalPoint(rect.localLeftTop);
    final bool r4 = containLocalPoint(rect.localLeftBottom);
    return r1 && r2 && r3 && r4;
  }

  double scaleOfPointRestOn(Vector2 point) {
    final Vector2 localPoint = point - _center;
    final double s1 = localRightBottom.cross(localPoint).abs();
    final double s2 = localRightTop.cross(localPoint).abs();
    return 0.5 * area / (s1 + s2);
  }

  _Rect clone() {
    return _Rect.from(this);
  }

  void setFrom(_Rect arg) {
    _center = arg.center;
    halfWidth = arg.halfWidth;
    halfHeight = arg.halfHeight;
    rotation = arg.rotation;
  }
}

class ImageCroppingProcessor extends ChangeNotifier {
  final _Rect _image;
  final _Rect _frame;
  final _Rect _virtuality;
  final _Rect _preview;
  double _rotation;
  CropFrameRatio _ratio;

  ImageCroppingProcessor._({
    required _Rect image,
    required _Rect frame,
    required double rotation,
    required CropFrameRatio ratio,
  }) : _image = image,
       _frame = frame,
       _rotation = rotation,
       _ratio = ratio,
       _virtuality = _Rect.from(frame),
       _preview = _Rect.from(frame);

  factory ImageCroppingProcessor.fromWHR(
    double width,
    double height,
    double rotation,
  ) {
    return ImageCroppingProcessor._(
      image: _Rect(Vector2.zero(), width, height, rotation),
      frame: _Rect(Vector2.zero(), width, height, 0),
      rotation: rotation,
      ratio: CropFrameRatio.free,
    );
  }

  Vector2 toCenterSystem(Vector2 arg) {
    return Vector2(
      arg.x - _image.boundaryHalfWidth,
      arg.y - _image.boundaryHalfHeight,
    );
  }

  Vector2 toLeftTopSystem(Vector2 arg) {
    return Vector2(
      arg.x + _image.boundaryHalfWidth,
      arg.y + _image.boundaryHalfHeight,
    );
  }

  double get canvasWidth => _image.boundaryWidth;
  double get canvasHeight => _image.boundaryHeight;
  Size get canvasSize => Size(canvasWidth, canvasHeight);
  double get imageWidth => _image.width;
  double get imageHeight => _image.height;
  double get rotation => _rotation;
  double get frameWidth => _preview.width;
  double get frameHeight => _preview.height;

  set rotation(double r) {
    _rotation = r;
    _image.rotation = r;

    // _preview.center = Vector2(100, 200);
    _preview.center = Vector2(200, 300);

    // var point = _preview.rightBottom;
    // if(!_image.containPoint(point)){
    //   print(_image.scaleOfPointRestOn(point));
    //   _preview.size *= _image.scaleOfPointRestOn(point);
    // }
    // double scale = 1;

    final List<Vector2> points = _preview.points;
    for (final Vector2 point in points) {
      final double scale = min(1, _image.scaleOfPointRestOn(point));
      point.scale(scale);

      // scale = min(scale, _image.scaleOfPointRestOn(point));
      // if(!_image.containPoint(point)){
      //   print(_image.scaleOfPointRestOn(point));
      //   _preview.size *= _image.scaleOfPointRestOn(point);
      // }
    }
    final double right = min(points[0].x, points[1].x);
    final double top = max(points[1].y, points[2].y);
    final double left = max(points[2].x, points[3].x);
    final double bottom = min(points[3].y, points[0].y);

    if (left >= right || top >= bottom) {
      _reset();
    }

    _preview.centerX = 0.5 * (left + right);
    _preview.centerY = 0.5 * (top + bottom);
    _preview.width = right - left;
    _preview.height = bottom - top;

    for (final Vector2 point in _preview.axisPoints) {
      print(_image.containPoint(point));
    }

    _virtuality.setFrom(_preview);
    _frame.setFrom(_preview);

    notifyListeners();
  }

  void _reset() {}

  void _verifyCenter(Vector2 center) {
    final double scale = _image.scaleOfPointRestOn(center);
    if (scale <= 1) {
      center.setZero();
    }
  }

  CropFrameAnchorPoint _anchorPoint = CropFrameAnchorPoint.none;
  CropFrameAnchorPoint get anchorPoint => _anchorPoint;
  set anchorPoint(CropFrameAnchorPoint ap) {
    _anchorPoint = ap;
    notifyListeners();
  }

  CropFrameAnchorPoint getAnchorPoint(Vector2 point, {double e = 10}) {
    final double toLT = point.distanceToSquared(_virtuality.leftTop);
    final double toRT = point.distanceToSquared(_virtuality.rightTop);
    final double toRB = point.distanceToSquared(_virtuality.rightBottom);
    final double toLB = point.distanceToSquared(_virtuality.leftBottom);

    final double minDistanceSquaredFromPoint = min(
      min(toLT, toRT),
      min(toRB, toLB),
    );
    if (minDistanceSquaredFromPoint <= e * e) {
      if (minDistanceSquaredFromPoint == toLT)
        return CropFrameAnchorPoint.leftTop;
      if (minDistanceSquaredFromPoint == toRT)
        return CropFrameAnchorPoint.rightTop;
      if (minDistanceSquaredFromPoint == toRB)
        return CropFrameAnchorPoint.rightBottom;
      if (minDistanceSquaredFromPoint == toLB)
        return CropFrameAnchorPoint.leftBottom;
    }

    if (point.x < _virtuality.leftTop.x - e ||
        point.x > _virtuality.rightBottom.x + e ||
        point.y < _virtuality.leftTop.y - e ||
        point.y > _virtuality.rightBottom.y + e)
      return CropFrameAnchorPoint.none;

    final double toL = (point.x - _virtuality.leftTop.x).abs();
    final double toT = (point.y - _virtuality.leftTop.y).abs();
    final double toR = (point.x - _virtuality.rightBottom.x).abs();
    final double toB = (point.y - _virtuality.rightBottom.y).abs();
    final double minDistanceFromLine = min(min(toL, toT), min(toR, toB));
    if (minDistanceFromLine <= e) {
      if (minDistanceFromLine == toL) return CropFrameAnchorPoint.left;
      if (minDistanceFromLine == toT) return CropFrameAnchorPoint.top;
      if (minDistanceFromLine == toR) return CropFrameAnchorPoint.right;
      if (minDistanceFromLine == toB) return CropFrameAnchorPoint.bottom;
    }

    return CropFrameAnchorPoint.center;
  }
}

class ImageRectCropping extends StatefulWidget {
  final ImageCroppingProcessor controller;

  const ImageRectCropping({super.key, required this.controller});

  @override
  State<ImageRectCropping> createState() => _ImageRectCroppingState();
}

class _ImageRectCroppingState extends State<ImageRectCropping> {
  late final ImageCroppingProcessor controller;

  MouseCursor getCursor(CropFrameAnchorPoint anchorPoint) {
    return switch (anchorPoint) {
      CropFrameAnchorPoint.none => MouseCursor.defer,
      CropFrameAnchorPoint.center => SystemMouseCursors.move,
      CropFrameAnchorPoint.left => SystemMouseCursors.resizeLeftRight,
      CropFrameAnchorPoint.top => SystemMouseCursors.resizeUpDown,
      CropFrameAnchorPoint.right => SystemMouseCursors.resizeLeftRight,
      CropFrameAnchorPoint.bottom => SystemMouseCursors.resizeUpDown,
      CropFrameAnchorPoint.leftTop => SystemMouseCursors.resizeUpLeftDownRight,
      CropFrameAnchorPoint.rightTop => SystemMouseCursors.resizeUpRightDownLeft,
      CropFrameAnchorPoint.leftBottom =>
        SystemMouseCursors.resizeUpRightDownLeft,
      CropFrameAnchorPoint.rightBottom =>
        SystemMouseCursors.resizeUpLeftDownRight,
    };
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListenableBuilder(
            listenable: controller,
            builder: (BuildContext context, Widget? child) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double scale = fitRectangleScale(
                    constraints.biggest,
                    controller.canvasSize,
                  );

                  return Center(
                    child: Listener(
                      onPointerMove: (PointerMoveEvent event) {
                        final Vector2 p = Vector2(
                          event.localPosition.dx / scale,
                          event.localPosition.dy / scale,
                        );
                        print(
                          controller._image.containPoint(
                            controller.toCenterSystem(p),
                          ),
                        );
                      },
                      onPointerHover: (PointerHoverEvent event) {
                        final Vector2 point = Vector2(
                          event.localPosition.dx,
                          event.localPosition.dy,
                        )..scale(1 / scale);
                        controller.anchorPoint = controller.getAnchorPoint(
                          controller.toCenterSystem(point),
                        );
                      },
                      child: MouseRegion(
                        cursor: getCursor(controller.anchorPoint),
                        child: Container(
                          width: controller.canvasWidth * scale,
                          height: controller.canvasHeight * scale,
                          alignment: Alignment.center,
                          color: Colors.black,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Center(
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: m.Matrix4.identity()
                                      ..rotateZ(controller.rotation),
                                    child: Container(
                                      width: controller.imageWidth * scale,
                                      height: controller.imageHeight * scale,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                left:
                                    controller
                                        .toLeftTopSystem(
                                          controller._preview.leftTop,
                                        )
                                        .x *
                                    scale,
                                top:
                                    controller
                                        .toLeftTopSystem(
                                          controller._preview.leftTop,
                                        )
                                        .y *
                                    scale,
                                width: controller.frameWidth * scale,
                                height: controller.frameHeight * scale,
                                child: Container(
                                  width: controller.frameWidth * scale,
                                  height: controller.frameHeight * scale,
                                  color: Colors.grey.withAlpha(100),
                                ),
                              ),

                              // Align(
                              //   alignment: Alignment(controller._preview.centerX / controller._image.boundaryHalfWidth, controller._preview.centerY / controller._image.boundaryHalfHeight),
                              //   child: Container(
                              //     width: controller.frameWidth * scale,
                              //     height: controller.frameHeight * scale,
                              //     color: Colors.grey.withAlpha(100),
                              //   ),
                              // ),
                              Align(
                                alignment: Alignment(
                                  controller._preview.rightBottom.x /
                                      controller._image.boundaryHalfWidth,
                                  controller._preview.rightBottom.y /
                                      controller._image.boundaryHalfHeight,
                                ),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  color: Colors.red,
                                ),
                              ),

                              // Align(
                              //   alignment: Alignment(controller._image.localRightBottom.x / controller._image.boundaryHalfWidth, controller._image.localRightBottom.y / controller._image.boundaryHalfHeight),
                              //   child: Container(
                              //     width: 8,
                              //     height: 8,
                              //     color: Colors.red,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        Column(
          children: [
            ListenableBuilder(
              listenable: controller,
              builder: (BuildContext context, Widget? child) {
                return SizedBox(
                  width: 400,
                  height: 100,
                  child: AppSlider(
                    value: controller.rotation / (pi / 180.0),
                    min: -180,
                    max: 180,
                    divisions: 360,
                    onChanged: (double value) {
                      controller.rotation = value * (pi / 180.0);
                    },
                  ),
                  // child: AppSlider(
                  //   value: controller.rotation / (pi / 180.0),
                  //   min: -180,
                  //   max: 180,
                  //   divisions: 360,
                  //   onChanged: (double value){
                  //     controller.rotation = value * (pi / 180.0);
                  //   },
                  // ),
                );
              },
            ),

            // for(final CropFrameRatio ratio in CropFrameRatio.values)
            //   AppButton(
            //     onClick: (){
            //       controller.ratio = ratio;
            //     },
            //     child: AppText(ratio.name, isTranslate: false),
            //   ),
          ],
        ),
      ],
    );
  }
}

// class RectCroppingProcessor extends ChangeNotifier{
//   final double canvasWidth;
//   final double canvasHeight;
//   CropFrameRatio _ratio;
//   double _minWidth;
//   double _minHeight;
//   final Vector4 _pad;
//   final Vector2 _anchor;
//
//   RectCroppingProcessor._(this.canvasWidth, this.canvasHeight, CropFrameRatio ratio, double minWidth, double minHeight, Vector4 pad) :
//     _ratio = ratio,
//     _minWidth = minWidth,
//     _minHeight = minHeight,
//     _pad = pad
//   {
//     this.ratio = ratio;
//   }
//
//   factory RectCroppingProcessor.fromLTRB({
//     required double width,
//     required double height,
//     CropFrameRatio ratio = CropFrameRatio.free,
//     double minWidth = 1,
//     double minHeight = 1,
//     double? left,
//     double? top,
//     double? right,
//     double? bottom,
//   }){
//     final (double l, double t, double r, double b) = verify(width, height, left, top, right, bottom);
//
//     return RectCroppingProcessor._(width, height, ratio, max(0, minWidth), max(0, minHeight), Vector4(l, t, r, b));
//   }
//
//
//   Size get size => Size(width, height);
//   // double get _l => _rect.left;
//   // double get _t => _rect.top;
//   // double get _r => _rect.right;
//   // double get _b => _rect.bottom;
//   // double get _w => _rect.rectWidth;
//   // double get _h => _rect.rectHeight;
//   // double get left => _frame.left;
//   // double get top => _frame.top;
//   // double get right => _frame.right;
//   // double get bottom => _frame.bottom;
//   // double get leftDist => left;
//   // double get topDist => top;
//   // double get rightDist => width - right;
//   // double get bottomDist => height - bottom;
//   // double get frameWidth => _frame.rectWidth;
//   // double get frameHeight => _frame.rectHeight;
//   // Size get frameSize => Size(frameWidth, frameHeight);
//   // Offset get center => Offset(0.5 * (left + right), 0.5 * (top + bottom));
//   // Offset get leftTop => Offset(left, top);
//   // Offset get rightTop => Offset(right, top);
//   // Offset get rightBottom => Offset(right, bottom);
//   // Offset get leftBottom => Offset(left, bottom);
//   //
//   // double get minLength => _minLength;
//   // set minLength(double newValue){
//   //   if(newValue == _minLength) return;
//   //
//   //   _minLength = minLength;
//   //
//   //   ///TODO
//   // }
//
//   static (double, double, double, double) verify(double width, double height, double? left, double? top, double? right, double? bottom){
//     double l = left ?? 0;
//     double t = top ?? 0;
//     double r = right ?? width;
//     double b = bottom ?? height;
//
//     l = clampDouble(l, 0, width);
//     t = clampDouble(t, 0, height);
//     r = clampDouble(r, 0, width);
//     b = clampDouble(b, 0, height);
//
//     if(l > r){
//       (l, r) = (r, l);
//     }
//     else if(l == r){
//       l = clampDouble(--l, 0, width);
//       r = clampDouble(++r, 0, width);
//     }
//
//     if(t > b){
//       (t, b) = (b, t);
//     }
//     else if(t == b){
//       t = clampDouble(--t, 0, height);
//       b = clampDouble(++b, 0, height);
//     }
//
//     return (l, t, r, b);
//   }
//
//   (double, double, double, double) _verify(double? left, double? top, double? right, double? bottom) => verify(width, height, left, top, right, bottom);
//
//   static Vector4 getIntersection(double width, double height, Vector4 rect){
//     // 分离
//     if(rect.left > width || rect.top > height || rect.right < 0 || rect.bottom < 0){
//       if(rect.left > width){
//         return Vector4(width, clampDouble(rect.top, 0, height), width, clampDouble(rect.bottom, 0, height));
//       }
//       if(rect.top > height){
//         return Vector4(clampDouble(rect.left, 0, width), height, clampDouble(rect.right, 0, width), height);
//       }
//       if(rect.right < 0){
//         return Vector4(0, clampDouble(rect.top, 0, height), 0, clampDouble(rect.bottom, 0, height));
//       }
//
//       /// bottom < 0
//       return Vector4(clampDouble(rect.left, 0, width), 0, clampDouble(rect.right, 0, width), 0);
//     }
//     // 包含
//     else if(0 <= rect.left && rect.right <= width && 0 <= rect.top && rect.bottom <= height){
//       return Vector4(rect.left, rect.top, rect.right ,rect.bottom);
//     }
//     // 相交或被包含
//     else{
//       return Vector4(max(0, rect.left), max(0, rect.top), min(rect.right, width), min(rect.bottom, height));
//     }
//   }
//
//   Vector4 _getIntersection(Vector4 rect) => getIntersection(width, height, rect);
//
//   CropFrameAnchorPoint _anchorPoint = CropFrameAnchorPoint.none;
//
//   CropFrameAnchorPoint getAnchorPoint(Offset offset, {double e = 5}){
//     final double toLT = (offset - leftTop).distanceSquared;
//     final double toRT = (offset - rightTop).distanceSquared;
//     final double toRB = (offset - rightBottom).distanceSquared;
//     final double toLB = (offset - leftBottom).distanceSquared;
//
//     final double minDistanceSquaredFromPoint = min(min(toLT, toRT), min(toRB, toLB));
//     if(minDistanceSquaredFromPoint <= e * e){
//       if(minDistanceSquaredFromPoint == toLT) return CropFrameAnchorPoint.leftTop;
//       if(minDistanceSquaredFromPoint == toRT) return CropFrameAnchorPoint.rightTop;
//       if(minDistanceSquaredFromPoint == toRB) return CropFrameAnchorPoint.rightBottom;
//       if(minDistanceSquaredFromPoint == toLB) return CropFrameAnchorPoint.leftBottom;
//     }
//
//     if(offset.dx < left - e || offset.dx > right + e || offset.dy < top - e || offset.dy > bottom + e) return CropFrameAnchorPoint.none;
//
//     final double toL = (offset.dx - left).abs();
//     final double toT = (offset.dy - top).abs();
//     final double toR = (offset.dx - right).abs();
//     final double toB = (offset.dy - bottom).abs();
//     final double minDistanceFromLine = min(min(toL, toT), min(toR, toB));
//     if(minDistanceFromLine <= e){
//       if(minDistanceFromLine == toL) return CropFrameAnchorPoint.left;
//       if(minDistanceFromLine == toT) return CropFrameAnchorPoint.top;
//       if(minDistanceFromLine == toR) return CropFrameAnchorPoint.right;
//       if(minDistanceFromLine == toB) return CropFrameAnchorPoint.bottom;
//     }
//
//     return CropFrameAnchorPoint.center;
//   }
//
//   CropFrameRatio get ratio => _ratio;
//
//   set ratio(CropFrameRatio newRatio){
//     if(newRatio != CropFrameRatio.free){
//       final Offset center = this.center;
//
//       final double minHorizontal = min(center.dx, width - center.dx);
//       final double minVertical = min(center.dy, height - center.dy);
//
//       late double halfWidth;
//       late double halfHeight;
//       late final double r;
//       if(newRatio == CropFrameRatio.origin){
//         r = width / height;
//       }else if(newRatio == CropFrameRatio.current){
//         r = frameWidth / frameHeight;
//       }else{
//         r = newRatio.ratio;
//       }
//       if(minHorizontal / minVertical <= r){
//         halfWidth = minHorizontal;
//         halfHeight = minHorizontal / r;
//       }else{
//         halfWidth = minVertical * r;
//         halfHeight = minVertical;
//       }
//
//       final double oldArea = frameWidth * frameHeight;
//       final double area = 4 * halfWidth * halfHeight;
//
//       if(area > oldArea){
//         final double scale = sqrt(oldArea / area);
//         halfWidth *= scale;
//         halfHeight *= scale;
//       }
//
//       // _frame.setFrom(Vector4(center.dx, center.dy, center.dx, center.dy) + Vector4(-halfWidth, -halfHeight, halfWidth, halfHeight));
//
//       _frame.left = center.dx - halfWidth;
//       _frame.top = center.dy - halfHeight;
//       _frame.right = center.dx + halfWidth;
//       _frame.bottom = center.dy + halfHeight;
//     }
//
//     _frame.copyInto(_rect);
//     _ratio = newRatio;
//
//     notifyListeners();
//   }
//
//   void transformStart(CropFrameAnchorPoint anchorPoint){
//     _anchorPoint = anchorPoint;
//   }
//
//   void transformUpdate(Offset offset){
//     if(_anchorPoint == CropFrameAnchorPoint.none) return;
//
//     _rect.add(_anchorPoint.frag.multiplied(Vector4(offset.dx, offset.dy, offset.dx, offset.dy)));
//
//     if(_ratio == CropFrameRatio.free){
//       _updateFrameWithoutRatio();
//     }else{
//       _updateFrameWithRatio();
//     }
//
//     notifyListeners();
//   }
//
//   void _updateFrameWithoutRatio(){
//     if(_anchorPoint == CropFrameAnchorPoint.center){
//       return _moveFrame();
//     }
//
//     //TODO
//     // final Vector4 d = Vector4(_l - left, _t - top, _r - right, _b - bottom);
//     final Vector4 d = _rect - _frame;
//     final Vector4 minD = Vector4(-left, -top, left - right + minLength, top - bottom + minLength);
//     final Vector4 maxD = Vector4(right - left - minLength, bottom - top - minLength, width - right, height - bottom);
//     d.clamp(_anchorPoint.frag.multiplied(minD), _anchorPoint.frag.multiplied(maxD));
//     // d.clamp(minD, maxD);
//     _frame.add(d);
//
//     // final Vector4 maxRect = _getIntersection(_rect);
//     //
//     // if(maxRect.left >= maxRect.right){
//     //   maxRect.left = (right - 1) * _anchorPoint.tl + left * _anchorPoint.tr;
//     //   maxRect.right = (left + 1) * _anchorPoint.tr + right * _anchorPoint.tl;
//     // }
//     // if(maxRect.top >= maxRect.bottom){
//     //   maxRect.top = (bottom - 1) * _anchorPoint.tt + top * _anchorPoint.tb;
//     //   maxRect.bottom = (top + 1) * _anchorPoint.tb + bottom * _anchorPoint.tt;
//     // }
//
//     // final double stateX = maxRect.rectWidth <= minLength ? 1 : 0;
//     // final double stateY = maxRect.rectHeight <= minLength ? 1 : 0;
//     // final double l = maxRect.left, t = maxRect.top, r = maxRect.right, b = maxRect.bottom, e = minLength;
//     // final Matrix4 M = Matrix4(r - e, l, l, l, t, b - e, t, t, r, r, r + e, r, b, b, b, t + e);
//     // maxRect.setFrom(M * (_anchorPoint.frag.multiplied(Vector4(stateX, stateY, stateX, stateY))));
//
//     // maxRect.copyInto(_frame);
//   }
//
//   void _updateFrameWithRatio(){
//     if(_anchorPoint == CropFrameAnchorPoint.center){
//       return _moveFrame();
//     }
//
//     final Vector4 maxRect = _getIntersection(_rect);
//
//     if(_anchorPoint == CropFrameAnchorPoint.leftTop || _anchorPoint == CropFrameAnchorPoint.rightTop || _anchorPoint == CropFrameAnchorPoint.rightBottom || _anchorPoint == CropFrameAnchorPoint.leftBottom){
//
//
//       // double ratio = frameWidth / frameHeight;
//       //
//       // final Vector4 d = Vector4(_l - left, _t - top, _r - right, _b - bottom);
//       // final Vector4 minD = Vector4(
//       //   -min(top * ratio, left),
//       //   -min(top, left / ratio),
//       //   max(minLength, minLength * ratio) - frameWidth,
//       //   max(minLength / ratio, minLength) - frameHeight,
//       // );
//       // final Vector4 maxD = Vector4(
//       //   frameWidth - max(minLength, minLength * ratio),
//       //   frameHeight - max(minLength / ratio, minLength),
//       //   min((height - bottom) * ratio, width - right),
//       //   min(height - bottom, (width - right) / ratio),
//       // );
//       // d.clamp(minD, maxD);
//       // _frame.add(d);
//
//
//       final Size size = frameSize;
//       late final double scale;
//       late final Size fitSize;
//       if(maxRect.left >= maxRect.right || maxRect.top >= maxRect.bottom){
//         scale = fitRectangleScale(Size(1, 1), size, mode: FitMode.cover);
//         fitSize = size * scale;
//       }else{
//         scale = fitRectangleScale(Size(maxRect.right - maxRect.left, maxRect.bottom - maxRect.top), size);
//         fitSize = size * scale;
//       }
//
//       final double dx = fitSize.width - size.width;
//       final double dy = fitSize.height - size.height;
//
//       _frame.add(_anchorPoint.frag.multiplied(Vector4(-dx, -dy, dx, dy)));
//
//     }
//     else{
//       final double e = 1;
//       double ratio = frameWidth / frameHeight;
//
//       final Vector4 flag = _anchorPoint.frag;
//       double d = flag.dot(Vector4(-(_l - left), -(_t - top), _r - right, _b - bottom));
//
//       final Vector4 v1 = Vector4(top * ratio, left / ratio, top * ratio, left / ratio);
//       final Vector4 v2 = Vector4(bottomDist * ratio, rightDist / ratio, bottomDist * ratio, rightDist / ratio);
//       final Vector4 v3 = Vector4(leftDist, topDist, rightDist, bottomDist);
//       final Vector4 v4 = Vector4(frameWidth, frameHeight, frameWidth, frameHeight);
//       final double maxD = min(2 * min(flag.dot(v1), flag.dot(v2)), flag.dot(v3));
//       final double minD = e - flag.dot(v4);
//       d = clampDouble(d, minD, maxD);
//
//       final double k1 = 0.5 * ratio;
//       final double k2 = 0.5 / ratio;
//       final Matrix4 M = Matrix4(-1.0, -k2, 0.0, k2, -k1, -1.0, k1, 0.0, 0.0, -k2, 1.0, k2, -k1, 0.0, k1, 1.0);
//
//       _frame.add((M * flag) * d);
//     }
//   }
//
//   void _moveFrame(){
//     final Vector4 d = Vector4(_l - left, _t - top, _r - right, _b - bottom);
//     final Vector4 minD = Vector4(-left, -top, -left, -top);
//     final Vector4 maxD = Vector4(width - right, height - bottom, width - right, height - bottom);
//     d.clamp(minD, maxD);
//     _frame.add(d);
//
//     // final Vector4 maxRect = _getIntersection(_rect);
//     //
//     // if(maxRect.left == 0){
//     //   maxRect.right = _w;
//     // }
//     // if(maxRect.top == 0){
//     //   maxRect.bottom = _h;
//     // }
//     // if(maxRect.right == width){
//     //   maxRect.left = width - _w;
//     // }
//     // if(maxRect.bottom == height){
//     //   maxRect.top = height - _h;
//     // }
//     //
//     // maxRect.copyInto(_frame);
//   }
//
//   void transformEnd(){
//     _anchorPoint = CropFrameAnchorPoint.center;
//     _frame.copyInto(_rect);
//   }
//
//   double _scale = 1;
//   Offset scaleCenter = Offset.zero;
//   void scaleStart({Offset? absoluteCenter, Offset? relativeCenter}){
//     if(absoluteCenter != null){
//       scaleCenter = absoluteCenter;
//     }else if(relativeCenter != null){
//       scaleCenter = Offset(left, top) + relativeCenter;
//     }else{
//       scaleCenter = center;
//     }
//   }
//
//   void scaleUpdate(double scale){
//     _scale += scale;
//   }
//
//   void scaleEnd(){
//     _scale = 1;
//     scaleCenter = Offset.zero;
//   }
//
//
//
//   Size get canvasSize => Size(canvasWidth, canvasHeight);
//   Vector2 get canvasSizeV => Vector2(canvasWidth, canvasHeight);
//   double get rawPadLeft => _pad.left;
//   double get rawPadTop => _pad.top;
//   double get rawPadRight => _pad.right;
//   double get rawPadBottom => _pad.bottom;
//   double get rawLeft => _anchor.x + rawPadLeft;
//   double get rawTop => _anchor.y + rawPadTop;
//   double get rawRight => _anchor.x + rawPadRight;
//   double get rawBottom => _anchor.y + rawPadBottom;
//   double get rawLeftDist => rawLeft;
//   double get rawTopDist => rawTop;
//   double get rawRightDist => canvasWidth - rawRight;
//   double get rawBottomDist => canvasHeight - rawBottom;
//   double get rawWidth => rawPadLeft + rawPadRight;
//   double get rawHeight => rawPadTop + rawPadBottom;
//   Size get rawSize => Size(rawWidth, rawHeight);
//   Vector2 get rawSizeV => Vector2(rawWidth, rawHeight);
//   Offset get rawCenter => Offset(_anchor.x + 0.5 * (rawPadLeft + rawPadRight), _anchor.y + 0.5 * (rawPadTop + rawPadBottom));
//   Offset get rawLeftTop => Offset(rawLeft, rawTop);
//   Offset get rawRightTop => Offset(rawRight, rawTop);
//   Offset get rawRightBottom => Offset(rawRight, rawBottom);
//   Offset get rawLeftBottom => Offset(rawLeft, rawBottom);
//   Vector2 get rawCenterV => Vector2(_anchor.x + 0.5 * (rawPadLeft + rawPadRight), _anchor.y + 0.5 * (rawPadTop + rawPadBottom));
//   Vector2 get rawLeftTopV => Vector2(rawLeft, rawTop);
//   Vector2 get rawRightTopV => Vector2(rawRight, rawTop);
//   Vector2 get rawRightBottomV => Vector2(rawRight, rawBottom);
//   Vector2 get rawLeftBottomV => Vector2(rawLeft, rawBottom);
//
//
//   Offset get absoluteAnchor => Offset(_anchor.x, _anchor.y);
//   Offset get relativeAnchor => Offset(-rawLeft, -rawTop);
//   Vector2 get absoluteAnchorV => Vector2(_anchor.x, _anchor.y);
//   Vector2 get relativeAnchorV => Vector2(-rawLeft, -rawTop);
//   set absoluteAnchor(Offset newAnchor) => absoluteAnchorV = Vector2(newAnchor.dx, newAnchor.dy);
//   set absoluteAnchorV(Vector2 newAnchor){
//     final Vector2 anchor = newAnchor.clone();
//     anchor.clamp(Vector2.zero(), canvasSizeV);
//     anchor.sub(_anchor);
//     _pad.add(anchor.xyxy);
//   }
//
//
//   bool _isMove = false;
//   final Vector2 _move = Vector2.zero();
//   final Vector2 _moved = Vector2.zero();
//
//   void moveStart(){
//     _isMove = true;
//   }
//
//   void moveUpdate(Offset offset){
//     _move.add(Vector2(offset.dx, offset.dy));
//     _movedUpdate();
//   }
//
//   void moveUpdateTo(Offset pos){
//     _move.setFrom(Vector2(pos.dx, pos.dy) - rawCenterV);
//     _movedUpdate();
//   }
//
//   void _movedUpdate(){
//     // final Vector2 minMoved = rawLeftTopV - absoluteAnchorV;
//     // final Vector2 maxMoved = Vector2(canvasWidth - rawPadRight, canvasHeight - rawPadBottom);
//     _moved.clamp(minMoved, maxMoved);
//   }
//
//   void moveEnd(){
//     // TODO
//
//     _move.setZero();
//     _isMove = false;
//   }
//
//
// }

class RectCroppingProcessor extends ChangeNotifier {
  final double width;
  final double height;
  CropFrameRatio _ratio;
  double _minLength;
  final Vector4 _frame;
  final Vector4 _rect;

  RectCroppingProcessor._(
    this.width,
    this.height,
    CropFrameRatio ratio,
    double minLength,
    Vector4 frame,
  ) : _ratio = ratio,
      _minLength = minLength,
      _frame = frame,
      _rect = Vector4.copy(frame) {
    this.ratio = ratio;
  }

  factory RectCroppingProcessor.fromLTRB({
    required double width,
    required double height,
    CropFrameRatio ratio = CropFrameRatio.free,
    double minLength = 1,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    final (double l, double t, double r, double b) = verify(
      width,
      height,
      left,
      top,
      right,
      bottom,
    );

    return RectCroppingProcessor._(
      width,
      height,
      ratio,
      max(0, minLength),
      Vector4(l, t, r, b),
    );
  }

  Size get size => Size(width, height);
  double get _l => _rect.left;
  double get _t => _rect.top;
  double get _r => _rect.right;
  double get _b => _rect.bottom;
  double get _w => _rect.rectWidth;
  double get _h => _rect.rectHeight;
  double get left => _frame.left;
  double get top => _frame.top;
  double get right => _frame.right;
  double get bottom => _frame.bottom;
  double get leftDist => left;
  double get topDist => top;
  double get rightDist => width - right;
  double get bottomDist => height - bottom;
  double get frameWidth => _frame.rectWidth;
  double get frameHeight => _frame.rectHeight;
  Size get frameSize => Size(frameWidth, frameHeight);
  Offset get center => Offset(0.5 * (left + right), 0.5 * (top + bottom));
  Offset get leftTop => Offset(left, top);
  Offset get rightTop => Offset(right, top);
  Offset get rightBottom => Offset(right, bottom);
  Offset get leftBottom => Offset(left, bottom);

  double get minLength => _minLength;
  set minLength(double newValue) {
    if (newValue == _minLength) return;

    _minLength = minLength;

    ///TODO
  }

  static (double, double, double, double) verify(
    double width,
    double height,
    double? left,
    double? top,
    double? right,
    double? bottom,
  ) {
    double l = left ?? 0;
    double t = top ?? 0;
    double r = right ?? width;
    double b = bottom ?? height;

    l = clampDouble(l, 0, width);
    t = clampDouble(t, 0, height);
    r = clampDouble(r, 0, width);
    b = clampDouble(b, 0, height);

    if (l > r) {
      (l, r) = (r, l);
    } else if (l == r) {
      l = clampDouble(--l, 0, width);
      r = clampDouble(++r, 0, width);
    }

    if (t > b) {
      (t, b) = (b, t);
    } else if (t == b) {
      t = clampDouble(--t, 0, height);
      b = clampDouble(++b, 0, height);
    }

    return (l, t, r, b);
  }

  (double, double, double, double) _verify(
    double? left,
    double? top,
    double? right,
    double? bottom,
  ) => verify(width, height, left, top, right, bottom);

  static Vector4 getIntersection(double width, double height, Vector4 rect) {
    // 分离
    if (rect.left > width ||
        rect.top > height ||
        rect.right < 0 ||
        rect.bottom < 0) {
      if (rect.left > width) {
        return Vector4(
          width,
          clampDouble(rect.top, 0, height),
          width,
          clampDouble(rect.bottom, 0, height),
        );
      }
      if (rect.top > height) {
        return Vector4(
          clampDouble(rect.left, 0, width),
          height,
          clampDouble(rect.right, 0, width),
          height,
        );
      }
      if (rect.right < 0) {
        return Vector4(
          0,
          clampDouble(rect.top, 0, height),
          0,
          clampDouble(rect.bottom, 0, height),
        );
      }

      /// bottom < 0
      return Vector4(
        clampDouble(rect.left, 0, width),
        0,
        clampDouble(rect.right, 0, width),
        0,
      );
    }
    // 包含
    else if (0 <= rect.left &&
        rect.right <= width &&
        0 <= rect.top &&
        rect.bottom <= height) {
      return Vector4(rect.left, rect.top, rect.right, rect.bottom);
    }
    // 相交或被包含
    else {
      return Vector4(
        max(0, rect.left),
        max(0, rect.top),
        min(rect.right, width),
        min(rect.bottom, height),
      );
    }
  }

  Vector4 _getIntersection(Vector4 rect) =>
      getIntersection(width, height, rect);

  CropFrameAnchorPoint _anchorPoint = CropFrameAnchorPoint.none;

  CropFrameAnchorPoint getAnchorPoint(Offset offset, {double e = 5}) {
    final double toLT = (offset - leftTop).distanceSquared;
    final double toRT = (offset - rightTop).distanceSquared;
    final double toRB = (offset - rightBottom).distanceSquared;
    final double toLB = (offset - leftBottom).distanceSquared;

    final double minDistanceSquaredFromPoint = min(
      min(toLT, toRT),
      min(toRB, toLB),
    );
    if (minDistanceSquaredFromPoint <= e * e) {
      if (minDistanceSquaredFromPoint == toLT)
        return CropFrameAnchorPoint.leftTop;
      if (minDistanceSquaredFromPoint == toRT)
        return CropFrameAnchorPoint.rightTop;
      if (minDistanceSquaredFromPoint == toRB)
        return CropFrameAnchorPoint.rightBottom;
      if (minDistanceSquaredFromPoint == toLB)
        return CropFrameAnchorPoint.leftBottom;
    }

    if (offset.dx < left - e ||
        offset.dx > right + e ||
        offset.dy < top - e ||
        offset.dy > bottom + e)
      return CropFrameAnchorPoint.none;

    final double toL = (offset.dx - left).abs();
    final double toT = (offset.dy - top).abs();
    final double toR = (offset.dx - right).abs();
    final double toB = (offset.dy - bottom).abs();
    final double minDistanceFromLine = min(min(toL, toT), min(toR, toB));
    if (minDistanceFromLine <= e) {
      if (minDistanceFromLine == toL) return CropFrameAnchorPoint.left;
      if (minDistanceFromLine == toT) return CropFrameAnchorPoint.top;
      if (minDistanceFromLine == toR) return CropFrameAnchorPoint.right;
      if (minDistanceFromLine == toB) return CropFrameAnchorPoint.bottom;
    }

    return CropFrameAnchorPoint.center;
  }

  CropFrameRatio get ratio => _ratio;

  set ratio(CropFrameRatio newRatio) {
    if (newRatio != CropFrameRatio.free) {
      final Offset center = this.center;

      final double minHorizontal = min(center.dx, width - center.dx);
      final double minVertical = min(center.dy, height - center.dy);

      late double halfWidth;
      late double halfHeight;
      late final double r;
      if (newRatio == CropFrameRatio.origin) {
        r = width / height;
      } else if (newRatio == CropFrameRatio.current) {
        r = frameWidth / frameHeight;
      } else {
        r = newRatio.ratio;
      }
      if (minHorizontal / minVertical <= r) {
        halfWidth = minHorizontal;
        halfHeight = minHorizontal / r;
      } else {
        halfWidth = minVertical * r;
        halfHeight = minVertical;
      }

      final double oldArea = frameWidth * frameHeight;
      final double area = 4 * halfWidth * halfHeight;

      if (area > oldArea) {
        final double scale = sqrt(oldArea / area);
        halfWidth *= scale;
        halfHeight *= scale;
      }

      // _frame.setFrom(Vector4(center.dx, center.dy, center.dx, center.dy) + Vector4(-halfWidth, -halfHeight, halfWidth, halfHeight));

      _frame.left = center.dx - halfWidth;
      _frame.top = center.dy - halfHeight;
      _frame.right = center.dx + halfWidth;
      _frame.bottom = center.dy + halfHeight;
    }

    _frame.copyInto(_rect);
    _ratio = newRatio;

    notifyListeners();
  }

  void transformStart(CropFrameAnchorPoint anchorPoint) {
    _anchorPoint = anchorPoint;
  }

  void transformUpdate(Offset offset) {
    if (_anchorPoint == CropFrameAnchorPoint.none) return;

    _rect.add(
      _anchorPoint.frag.multiplied(
        Vector4(offset.dx, offset.dy, offset.dx, offset.dy),
      ),
    );

    if (_ratio == CropFrameRatio.free) {
      _updateFrameWithoutRatio();
    } else {
      _updateFrameWithRatio();
    }

    notifyListeners();
  }

  void _updateFrameWithoutRatio() {
    if (_anchorPoint == CropFrameAnchorPoint.center) {
      return _moveFrame();
    }

    //TODO
    // final Vector4 d = Vector4(_l - left, _t - top, _r - right, _b - bottom);
    final Vector4 d = _rect - _frame;
    final Vector4 minD = Vector4(
      -left,
      -top,
      left - right + minLength,
      top - bottom + minLength,
    );
    final Vector4 maxD = Vector4(
      right - left - minLength,
      bottom - top - minLength,
      width - right,
      height - bottom,
    );
    d.clamp(
      _anchorPoint.frag.multiplied(minD),
      _anchorPoint.frag.multiplied(maxD),
    );
    // d.clamp(minD, maxD);
    _frame.add(d);

    // final Vector4 maxRect = _getIntersection(_rect);
    //
    // if(maxRect.left >= maxRect.right){
    //   maxRect.left = (right - 1) * _anchorPoint.tl + left * _anchorPoint.tr;
    //   maxRect.right = (left + 1) * _anchorPoint.tr + right * _anchorPoint.tl;
    // }
    // if(maxRect.top >= maxRect.bottom){
    //   maxRect.top = (bottom - 1) * _anchorPoint.tt + top * _anchorPoint.tb;
    //   maxRect.bottom = (top + 1) * _anchorPoint.tb + bottom * _anchorPoint.tt;
    // }

    // final double stateX = maxRect.rectWidth <= minLength ? 1 : 0;
    // final double stateY = maxRect.rectHeight <= minLength ? 1 : 0;
    // final double l = maxRect.left, t = maxRect.top, r = maxRect.right, b = maxRect.bottom, e = minLength;
    // final Matrix4 M = Matrix4(r - e, l, l, l, t, b - e, t, t, r, r, r + e, r, b, b, b, t + e);
    // maxRect.setFrom(M * (_anchorPoint.frag.multiplied(Vector4(stateX, stateY, stateX, stateY))));

    // maxRect.copyInto(_frame);
  }

  void _updateFrameWithRatio() {
    if (_anchorPoint == CropFrameAnchorPoint.center) {
      return _moveFrame();
    }

    final Vector4 maxRect = _getIntersection(_rect);

    if (_anchorPoint == CropFrameAnchorPoint.leftTop ||
        _anchorPoint == CropFrameAnchorPoint.rightTop ||
        _anchorPoint == CropFrameAnchorPoint.rightBottom ||
        _anchorPoint == CropFrameAnchorPoint.leftBottom) {
      // double ratio = frameWidth / frameHeight;
      //
      // final Vector4 d = Vector4(_l - left, _t - top, _r - right, _b - bottom);
      // final Vector4 minD = Vector4(
      //   -min(top * ratio, left),
      //   -min(top, left / ratio),
      //   max(minLength, minLength * ratio) - frameWidth,
      //   max(minLength / ratio, minLength) - frameHeight,
      // );
      // final Vector4 maxD = Vector4(
      //   frameWidth - max(minLength, minLength * ratio),
      //   frameHeight - max(minLength / ratio, minLength),
      //   min((height - bottom) * ratio, width - right),
      //   min(height - bottom, (width - right) / ratio),
      // );
      // d.clamp(minD, maxD);
      // _frame.add(d);

      final Size size = frameSize;
      late final double scale;
      late final Size fitSize;
      if (maxRect.left >= maxRect.right || maxRect.top >= maxRect.bottom) {
        scale = fitRectangleScale(Size(1, 1), size, mode: FitMode.cover);
        fitSize = size * scale;
      } else {
        scale = fitRectangleScale(
          Size(maxRect.right - maxRect.left, maxRect.bottom - maxRect.top),
          size,
        );
        fitSize = size * scale;
      }

      final double dx = fitSize.width - size.width;
      final double dy = fitSize.height - size.height;

      _frame.add(_anchorPoint.frag.multiplied(Vector4(-dx, -dy, dx, dy)));
    } else {
      final double e = 1;
      double ratio = frameWidth / frameHeight;

      final Vector4 flag = _anchorPoint.frag;
      double d = flag.dot(
        Vector4(-(_l - left), -(_t - top), _r - right, _b - bottom),
      );

      final Vector4 v1 = Vector4(
        top * ratio,
        left / ratio,
        top * ratio,
        left / ratio,
      );
      final Vector4 v2 = Vector4(
        bottomDist * ratio,
        rightDist / ratio,
        bottomDist * ratio,
        rightDist / ratio,
      );
      final Vector4 v3 = Vector4(leftDist, topDist, rightDist, bottomDist);
      final Vector4 v4 = Vector4(
        frameWidth,
        frameHeight,
        frameWidth,
        frameHeight,
      );
      final double maxD = min(
        2 * min(flag.dot(v1), flag.dot(v2)),
        flag.dot(v3),
      );
      final double minD = e - flag.dot(v4);
      d = clampDouble(d, minD, maxD);

      final double k1 = 0.5 * ratio;
      final double k2 = 0.5 / ratio;
      final Matrix4 M = Matrix4(
        -1.0,
        -k2,
        0.0,
        k2,
        -k1,
        -1.0,
        k1,
        0.0,
        0.0,
        -k2,
        1.0,
        k2,
        -k1,
        0.0,
        k1,
        1.0,
      );

      _frame.add((M * flag) * d);
    }
  }

  void _moveFrame() {
    final Vector4 d = Vector4(_l - left, _t - top, _r - right, _b - bottom);
    final Vector4 minD = Vector4(-left, -top, -left, -top);
    final Vector4 maxD = Vector4(
      width - right,
      height - bottom,
      width - right,
      height - bottom,
    );
    d.clamp(minD, maxD);
    _frame.add(d);

    // final Vector4 maxRect = _getIntersection(_rect);
    //
    // if(maxRect.left == 0){
    //   maxRect.right = _w;
    // }
    // if(maxRect.top == 0){
    //   maxRect.bottom = _h;
    // }
    // if(maxRect.right == width){
    //   maxRect.left = width - _w;
    // }
    // if(maxRect.bottom == height){
    //   maxRect.top = height - _h;
    // }
    //
    // maxRect.copyInto(_frame);
  }

  void transformEnd() {
    _anchorPoint = CropFrameAnchorPoint.center;
    _frame.copyInto(_rect);
  }

  double _scale = 1;
  Offset scaleCenter = Offset.zero;
  void scaleStart({Offset? absoluteCenter, Offset? relativeCenter}) {
    if (absoluteCenter != null) {
      scaleCenter = absoluteCenter;
    } else if (relativeCenter != null) {
      scaleCenter = Offset(left, top) + relativeCenter;
    } else {
      scaleCenter = center;
    }
  }

  void scaleUpdate(double scale) {
    _scale += scale;
  }

  void scaleEnd() {
    _scale = 1;
    scaleCenter = Offset.zero;
  }
}

const a = 0;

//
// class RectCroppingProcessor extends ChangeNotifier{
//   final double width;
//   final double height;
//   CropFrameRatio _ratio;
//   double _left;
//   double _top;
//   double _right;
//   double _bottom;
//   double _l;
//   double _t;
//   double _r;
//   double _b;
//
//   RectCroppingProcessor._(this.width, this.height, CropFrameRatio ratio, double left, double top, double right, double bottom) :
//     _ratio = ratio,
//     _left = left,
//     _top = top,
//     _right = right,
//     _bottom = bottom,
//     _l = left,
//     _t = top,
//     _r = right,
//     _b = bottom
//   {
//     this.ratio = ratio;
//   }
//
//   factory RectCroppingProcessor.fromLTRB({
//     required double width,
//     required double height,
//     CropFrameRatio ratio = CropFrameRatio.free,
//     double? left,
//     double? top,
//     double? right,
//     double? bottom,
//   }){
//     // double l = left ?? 0;
//     // double t = top ?? 0;
//     // double r = right ?? width;
//     // double b = bottom ?? height;
//     //
//     // l = clampDouble(l, 0, width);
//     // t = clampDouble(t, 0, height);
//     // r = clampDouble(r, 0, width);
//     // b = clampDouble(b, 0, height);
//     //
//     // if(l > r){
//     //   (l, r) = (r, l);
//     // }
//     // if(t > b){
//     //   (t, b) = (b, t);
//     // }
//
//     final (double l, double t, double r, double b) = verify(width, height, left, top, right, bottom);
//
//     return RectCroppingProcessor._(width, height, ratio, l, t, r, b);
//   }
//
//
//   Size get size => Size(width, height);
//   double get _w => _r - _l;
//   double get _h => _b - _t;
//   double get left => _left;
//   double get top => _top;
//   double get right => _right;
//   double get bottom => _bottom;
//   double get rectWidth => _right - _left;
//   double get rectHeight => _bottom - _top;
//   Size get rectSize => Size(rectWidth, rectHeight);
//   Offset get center => Offset(0.5 * (_left + _right), 0.5 * (_top + _bottom));
//   Offset get leftTop => Offset(_left, _top);
//   Offset get rightTop => Offset(_right, _top);
//   Offset get rightBottom => Offset(_right, _bottom);
//   Offset get leftBottom => Offset(_left, _bottom);
//
//   static (double, double, double, double) verify(double width, double height, double? left, double? top, double? right, double? bottom){
//     double l = left ?? 0;
//     double t = top ?? 0;
//     double r = right ?? width;
//     double b = bottom ?? height;
//
//     l = clampDouble(l, 0, width);
//     t = clampDouble(t, 0, height);
//     r = clampDouble(r, 0, width);
//     b = clampDouble(b, 0, height);
//
//     if(l > r){
//       (l, r) = (r, l);
//     }
//     else if(l == r){
//       l = clampDouble(--l, 0, width);
//       r = clampDouble(++r, 0, width);
//     }
//
//     if(t > b){
//       (t, b) = (b, t);
//     }
//     else if(t == b){
//       t = clampDouble(--t, 0, height);
//       b = clampDouble(++b, 0, height);
//     }
//
//     return (l, t, r, b);
//   }
//
//   (double, double, double, double) _verify(double? left, double? top, double? right, double? bottom) => verify(width, height, left, top, right, bottom);
//
//   static (double, double, double, double) getIntersection(double width, double height, double left, double top, double right, double bottom){
//     // 分离
//     if(left > width || top > height || right < 0 || bottom < 0){
//       if(left > width){
//         return (width, clampDouble(top, 0, height), width, clampDouble(bottom, 0, height));
//       }
//       if(top > height){
//         return (clampDouble(left, 0, width), height, clampDouble(right, 0, width), height);
//       }
//       if(right < 0){
//         return (0, clampDouble(top, 0, height), 0, clampDouble(bottom, 0, height));
//       }
//
//       /// bottom < 0
//       return (clampDouble(left, 0, width), 0, clampDouble(right, 0, width), 0);
//     }
//     // 包含
//     else if(0 <= left && left < right && right <= width && 0 <= top && top < bottom && bottom <= height){
//       return (left, top, right ,bottom);
//     }
//     // 相交或被包含
//     else{
//       return (max(0, left), max(0, top), min(right, width), min(bottom, height));
//     }
//   }
//
//   (double, double, double, double) _getIntersection(double left, double top, double right, double bottom) => getIntersection(width, height, left, top, right, bottom);
//
//   CropFrameAnchorPoint _anchorPoint = CropFrameAnchorPoint.center;
//
//   CropFrameAnchorPoint getAnchorPoint(Offset offset, {double e = 5}){
//     final double toLT = (offset - leftTop).distanceSquared;
//     final double toRT = (offset - rightTop).distanceSquared;
//     final double toRB = (offset - rightBottom).distanceSquared;
//     final double toLB = (offset - leftBottom).distanceSquared;
//
//     final double minDistanceSquaredFromPoint = min(min(toLT, toRT), min(toRB, toLB));
//     if(minDistanceSquaredFromPoint <= e * e){
//       if(minDistanceSquaredFromPoint == toLT) return CropFrameAnchorPoint.leftTop;
//       if(minDistanceSquaredFromPoint == toRT) return CropFrameAnchorPoint.rightTop;
//       if(minDistanceSquaredFromPoint == toRB) return CropFrameAnchorPoint.rightBottom;
//       if(minDistanceSquaredFromPoint == toLB) return CropFrameAnchorPoint.leftBottom;
//     }
//
//     if(offset.dx < _left - e || offset.dx > _right + e || offset.dy < _top - e || offset.dy > _bottom + e) return CropFrameAnchorPoint.none;
//
//     final double toL = (offset.dx - left).abs();
//     final double toT = (offset.dy - top).abs();
//     final double toR = (offset.dx - right).abs();
//     final double toB = (offset.dy - bottom).abs();
//     final double minDistanceFromLine = min(min(toL, toT), min(toR, toB));
//     if(minDistanceFromLine <= e){
//       if(minDistanceFromLine == toL) return CropFrameAnchorPoint.left;
//       if(minDistanceFromLine == toT) return CropFrameAnchorPoint.top;
//       if(minDistanceFromLine == toR) return CropFrameAnchorPoint.right;
//       if(minDistanceFromLine == toB) return CropFrameAnchorPoint.bottom;
//     }
//
//     return CropFrameAnchorPoint.center;
//   }
//
//   CropFrameRatio get ratio => _ratio;
//
//   set ratio(CropFrameRatio newRatio){
//     if(newRatio != CropFrameRatio.free){
//       final double centerX = 0.5 * (_right + _left);
//       final double centerY = 0.5 * (_bottom + _top);
//
//       final double minHorizontal = min(centerX, width - centerX);
//       final double minVertical = min(centerY, height - centerY);
//
//       late double halfWidth;
//       late double halfHeight;
//       final double r = newRatio == CropFrameRatio.origin ? width / height : newRatio.ratio;
//       if(minHorizontal / minVertical <= r){
//         halfWidth = minHorizontal;
//         halfHeight = minHorizontal / r;
//       }else{
//         halfWidth = minVertical * r;
//         halfHeight = minVertical;
//       }
//
//       final double oldArea = rectWidth * rectHeight;
//       final double area = 4 * halfWidth * halfHeight;
//
//       if(area > oldArea){
//         final double scale = sqrt(oldArea / area);
//         halfWidth *= scale;
//         halfHeight *= scale;
//       }
//
//       _left = centerX - halfWidth;
//       _top = centerY - halfHeight;
//       _right = centerX + halfWidth;
//       _bottom = centerY + halfHeight;
//     }
//
//     _l = _left;
//     _t = _top;
//     _r = _right;
//     _b = _bottom;
//     _ratio = newRatio;
//
//     notifyListeners();
//   }
//
//   void transformStart(CropFrameAnchorPoint anchorPoint){
//     _anchorPoint = anchorPoint;
//   }
//
//   void transformUpdate(Offset offset){
//     _l += offset.dx * _anchorPoint.tl;
//     _t += offset.dy * _anchorPoint.tt;
//     _r += offset.dx * _anchorPoint.tr;
//     _b += offset.dy * _anchorPoint.tb;
//
//     if(_ratio == CropFrameRatio.free){
//       _updateFrameWithoutRatio();
//     }else{
//       _updateFrameWithRatio();
//     }
//
//     notifyListeners();
//   }
//
//   void _updateFrameWithoutRatio(){
//     // double l = clampDouble(_l, 0, width);
//     // double t = clampDouble(_t, 0, height);
//     // double r = clampDouble(_r, 0, width);
//     // double b = clampDouble(_b, 0, height);
//     //
//     // if(l > r){
//     //   (l, r) = (r, l);
//     // }
//     // if(t > b){
//     //   (t, b) = (b, t);
//     // }
//     //
//     // _left = l;
//     // _top = t;
//     // _right = r;
//     // _bottom = b;
//
//
//
//
//     // final (double l, double t, double r, double b) = _verify(_l, _t, _r, _b);
//     // _left = l; _top = t; _right = r; _bottom = b;
//     //
//     // if(_anchorPoint == CropFrameAnchorPoint.center){
//     //   if(_l < 0){
//     //     _right = _w;
//     //     _left = 0;
//     //   }
//     //   if(_t < 0){
//     //     _bottom = _h;
//     //     _top = 0;
//     //   }
//     //   if(_r > width){
//     //     _left = width - _w;
//     //     _right = width;
//     //   }
//     //   if(_b > height){
//     //     _top = height - _h;
//     //     _bottom = height;
//     //   }
//     // }
//
//
//     var (double l, double t, double r, double b) = _getIntersection(_l, _t, _r, _b);
//
//     if(_anchorPoint == CropFrameAnchorPoint.center){
//       _left = l; _top = t; _right = r; _bottom = b;
//       if(l == 0){
//         _right = _w;
//       }
//       if(t == 0){
//         _bottom = _h;
//       }
//       if(r == width){
//         _left = width - _w;
//       }
//       if(b == height){
//         _top = height - _h;
//       }
//     }else{
//       if(l >= r){
//         l = (_right - 1) * _anchorPoint.tl + _left * _anchorPoint.tr;
//         r = (_left + 1) * _anchorPoint.tr + _right * _anchorPoint.tl;
//       }
//       if(t >= b){
//         t = (_bottom - 1) * _anchorPoint.tt + _top * _anchorPoint.tb;
//         b = (_top + 1) * _anchorPoint.tb + _bottom * _anchorPoint.tt;
//       }
//
//       _left = l; _top = t; _right = r; _bottom = b;
//     }
//   }
//
//   void _updateFrameWithRatio(){
//     // final (double, double, double, double) intersection = _getIntersection(_l, _t, _r, _b);
//     // final (double l, double t, double r, double b) = _verify(intersection.$1, intersection.$2, intersection.$3, intersection.$4);
//     final (double l, double t, double r, double b) = _getIntersection(_l, _t, _r, _b);
//
//     if(_anchorPoint == CropFrameAnchorPoint.center){
//       _left = l; _top = t; _right = r; _bottom = b;
//       if(l == 0){
//         _right = _w;
//       }
//       if(t == 0){
//         _bottom = _h;
//       }
//       if(r == width){
//         _left = width - _w;
//       }
//       if(b == height){
//         _top = height - _h;
//       }
//     }else{
//       if(_anchorPoint == CropFrameAnchorPoint.leftTop || _anchorPoint == CropFrameAnchorPoint.rightTop || _anchorPoint == CropFrameAnchorPoint.rightBottom || _anchorPoint == CropFrameAnchorPoint.leftBottom){
//
//         final Size rectSize = this.rectSize;
//         late final double scale;
//         late final Size fitSize;
//         if(l >= r || t >= b){
//           scale = fitRectangleScale(Size(1, 1), rectSize, mode: FitMode.cover);
//           fitSize = rectSize * scale;
//         }else{
//           scale = fitRectangleScale(Size(r - l, b - t), rectSize);
//           fitSize = rectSize * scale;
//         }
//
//         final double dx = fitSize.width - rectSize.width;
//         final double dy = fitSize.height - rectSize.height;
//
//         _left -= dx * _anchorPoint.tl;
//         _top -= dy * _anchorPoint.tt;
//         _right += dx * _anchorPoint.tr;
//         _bottom += dy * _anchorPoint.tb;
//       }
//       else{
//         final double e = 1;
//         double ratio = rectWidth / rectHeight;
//
//         final Vector4 flag = Vector4(_anchorPoint.tl.toDouble(), _anchorPoint.tt.toDouble(), _anchorPoint.tr.toDouble(), _anchorPoint.tb.toDouble());
//         double d = flag.dot(Vector4(-(_l - _left), -(_t - _top), _r - _right, _b - _bottom));
//
//         final Vector4 v1 = Vector4(_top * ratio, _left / ratio, _top * ratio, _left / ratio);
//         final Vector4 v2 = Vector4((height - _bottom) * ratio, (width - _right) / ratio, (height - _bottom) * ratio, (width - _right) / ratio);
//         final Vector4 v3 = Vector4(_left, _top, width - _right, height - _bottom);
//         final Vector4 v4 = Vector4(_left - _right, _top - _bottom, _left - _right, _top - _bottom);
//         final double maxD = min(2 * min(flag.dot(v1), flag.dot(v2)), flag.dot(v3));
//         final double minD = flag.dot(v4) + e;
//         d = clampDouble(d, minD, maxD);
//
//         final double k1 = 0.5 * ratio;
//         final double k2 = 0.5 / ratio;
//         // final Matrix4 M = Matrix4(-1.0, -k1, 0.0, -k1, -k2, -1.0, -k2, 0.0, 0.0, k1, 1.0, k1, k2, 0.0, k2, 1.0);
//         final Matrix4 M = Matrix4(-1.0, -k2, 0.0, k2, -k1, -1.0, k1, 0.0, 0.0, -k2, 1.0, k2, -k1, 0.0, k1, 1.0);
//
//         Vector4 pos = Vector4(_left, _top, _right, _bottom);
//         // pos = pos + (M.transposed() * flag) * d;
//         pos = pos + (M * flag) * d;
//
//         _left = pos.x;
//         _top = pos.y;
//         _right = pos.z;
//         _bottom = pos.w;
//
//         // if(_anchorPoint == CropFrameAnchorPoint.left || _anchorPoint == CropFrameAnchorPoint.right){
//         //   double dx = _anchorPoint.tr * (_r - _right) - _anchorPoint.tl * (_l - _left);
//         //   final double maxDx = min(2 * ratio * _top, min(2 * ratio * (height - _bottom), _anchorPoint.tl * _left + _anchorPoint.tr * (width - _right)));
//         //   dx = clampDouble(dx, _left - _right + 1, maxDx);
//         //
//         //   _left = _left - _anchorPoint.tl * dx;
//         //   _top = _top - 0.5 * dx / ratio;
//         //   _right = _right + _anchorPoint.tr * dx;
//         //   _bottom = _bottom + 0.5 * dx / ratio;
//         // }
//         // if(_anchorPoint == CropFrameAnchorPoint.top || _anchorPoint == CropFrameAnchorPoint.bottom){
//         //   double dy = _anchorPoint.tb * (_b - _bottom) - _anchorPoint.tt * (_t - _top);
//         //   final double maxDy = min(2 / ratio * _left, min(2 / ratio * (width - _right), _anchorPoint.tt * _top + _anchorPoint.tb * (height - _bottom)));
//         //   dy = clampDouble(dy, _top - _bottom + 1, maxDy);
//         //
//         //   _left = _left - 0.5 * dy * ratio;
//         //   _top = _top - _anchorPoint.tt * dy;
//         //   _right = _right + 0.5 * dy * ratio;
//         //   _bottom = _bottom + _anchorPoint.tb * dy;
//         // }
//
//         0;
//
//         // if(_anchorPoint == CropFrameAnchorPoint.left){
//         //   double dx = _l - _left;
//         //   final double maxDx = min((-2 * ratio * _top).abs(), min(((_bottom - height) * 2 * ratio).abs(), (-_left).abs()));
//         //   if(dx < 0 && dx.abs() > maxDx){
//         //     dx = maxDx * dx.sign;
//         //   }
//         //   if(dx >= _right - _left){
//         //     dx = _right - _left - 1;
//         //   }
//         //   double l = _left + dx;
//         //   double t = _top + 0.5 * dx / ratio;
//         //   double r = _right;
//         //   double b = _bottom - 0.5 * dx / ratio;
//         //
//         //   _left = l;
//         //   _top = t;
//         //   _right = r;
//         //   _bottom = b;
//         // }
//         // if(_anchorPoint == CropFrameAnchorPoint.right){
//         //   double dx = _r - _right;
//         //   final double maxDx = min((2 * ratio * _top).abs(), min(((height - _bottom) * 2 * ratio).abs(), (width - _right).abs()));
//         //   if(dx > 0 && dx.abs() > maxDx){
//         //     dx = maxDx * dx.sign;
//         //   }
//         //   if(dx <= _left - _right){
//         //     dx = _left - _right + 1;
//         //   }
//         //   double l = _left;
//         //   double t = _top - 0.5 * dx / ratio;
//         //   double r = _right + dx;
//         //   double b = _bottom + 0.5 * dx / ratio;
//         //
//         //   _left = l;
//         //   _top = t;
//         //   _right = r;
//         //   _bottom = b;
//         // }
//         // if(_anchorPoint == CropFrameAnchorPoint.top){
//         //   double dy = _t - _top;
//         //   final double maxDy = min((-2 * _left / ratio).abs(), min(((_right - width) * 2 / ratio).abs(), (-_top).abs()));
//         //   if(dy < 0 && dy.abs() > maxDy){
//         //     dy = maxDy * dy.sign;
//         //   }
//         //   if(dy >= _bottom - _top){
//         //     dy = _bottom - _top - 1;
//         //   }
//         //   double l = _left + 0.5 * ratio * dy;
//         //   double t = _top + dy;
//         //   double r = _right - 0.5 * ratio * dy;
//         //   double b = _bottom;
//         //
//         //   _left = l;
//         //   _top = t;
//         //   _right = r;
//         //   _bottom = b;
//         // }
//         // if(_anchorPoint == CropFrameAnchorPoint.bottom){
//         //   double dy = _b - _bottom;
//         //   final double maxDy = min((2 * _left / ratio).abs(), min(((width - _right) * 2 / ratio).abs(), (height - _bottom).abs()));
//         //   if(dy > 0 && dy.abs() > maxDy){
//         //     dy = maxDy * dy.sign;
//         //   }
//         //   if(dy <= _top - _bottom){
//         //     dy = _top - _bottom + 1;
//         //   }
//         //   double l = _left - 0.5 * ratio * dy;
//         //   double t = _top;
//         //   double r = _right + 0.5 * ratio * dy;
//         //   double b = _bottom + dy;
//         //
//         //   _left = l;
//         //   _top = t;
//         //   _right = r;
//         //   _bottom = b;
//         // }
//
//         // final Size rectSize = this.rectSize;
//         // late final double scale;
//         // late final Size fitSize;
//         // if(l >= r || t >= b){
//         //   scale = fitRectangleScale(Size(1, 1), rectSize, mode: FitMode.cover);
//         //   fitSize = rectSize * scale;
//         // }else{
//         //   if(_l < _left || _t < _top || _r > _right || _b > _bottom){
//         //     scale = fitRectangleScale(Size(r - l, b - t), rectSize, mode: FitMode.cover);
//         //   }else{
//         //     scale = fitRectangleScale(Size(r - l, b - t), rectSize, mode: FitMode.contain);
//         //   }
//         //   fitSize = rectSize * scale;
//         // }
//         // // final (double fl, double ft, double fr, double fb) = _getIntersection(_l, _t, _r, _b);
//         //
//         //
//         //
//         // final double dx = fitSize.width - rectSize.width;
//         // final double dy = fitSize.height - rectSize.height;
//         //
//         //
//         // if(_anchorPoint == CropFrameAnchorPoint.left || _anchorPoint == CropFrameAnchorPoint.right){
//         //   _left -= dx * _anchorPoint.tl;
//         //   _top -= 0.5 * dy;
//         //   _right += dx * _anchorPoint.tr;
//         //   _bottom += 0.5 * dy;
//         // }
//         // else if(_anchorPoint == CropFrameAnchorPoint.top || _anchorPoint == CropFrameAnchorPoint.bottom){
//         //   _left -= 0.5 * dx;
//         //   _top -= dy * _anchorPoint.tt;
//         //   _right += 0.5 * dx;
//         //   _bottom += dy * _anchorPoint.tb;
//         // }
//       }
//     }
//   }
//
//   void transformEnd(){
//     _anchorPoint = CropFrameAnchorPoint.center;
//     _l = _left;
//     _t = _top;
//     _r = _right;
//     _b = _bottom;
//   }
// }

class RectCropping extends StatefulWidget {
  final RectCroppingProcessor controller;

  const RectCropping({super.key, required this.controller});

  @override
  State<RectCropping> createState() => _RectCroppingState();
}

class _RectCroppingState extends State<RectCropping> {
  late final RectCroppingProcessor controller;

  final ValueNotifier<CropFrameAnchorPoint> anchorPoint =
      ValueNotifier<CropFrameAnchorPoint>(CropFrameAnchorPoint.none);

  MouseCursor getCursor(CropFrameAnchorPoint anchorPoint) {
    return switch (anchorPoint) {
      CropFrameAnchorPoint.none => MouseCursor.defer,
      CropFrameAnchorPoint.center => SystemMouseCursors.move,
      CropFrameAnchorPoint.left => SystemMouseCursors.resizeLeftRight,
      CropFrameAnchorPoint.top => SystemMouseCursors.resizeUpDown,
      CropFrameAnchorPoint.right => SystemMouseCursors.resizeLeftRight,
      CropFrameAnchorPoint.bottom => SystemMouseCursors.resizeUpDown,
      CropFrameAnchorPoint.leftTop => SystemMouseCursors.resizeUpLeftDownRight,
      CropFrameAnchorPoint.rightTop => SystemMouseCursors.resizeUpRightDownLeft,
      CropFrameAnchorPoint.leftBottom =>
        SystemMouseCursors.resizeUpRightDownLeft,
      CropFrameAnchorPoint.rightBottom =>
        SystemMouseCursors.resizeUpLeftDownRight,
    };
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double scale = fitRectangleScale(
              constraints.biggest,
              controller.size,
            );
            final Size size = controller.size * scale;
            final Offset offset = centerRectangle(constraints.biggest, size);

            return Listener(
              onPointerDown: (_) {
                controller.transformStart(anchorPoint.value);
              },
              onPointerUp: (_) {
                controller.transformEnd();
              },
              onPointerMove: (PointerMoveEvent event) {
                controller.transformUpdate(event.delta / scale);
              },
              onPointerHover: (PointerHoverEvent event) {
                anchorPoint.value = controller.getAnchorPoint(
                  event.localPosition / scale,
                );
                // switch(anchorPoint){
                //   case CropFrameAnchorPoint.none:
                //     cursor = MouseCursor.defer;
                //     break;
                //   case CropFrameAnchorPoint.center:
                //     cursor = SystemMouseCursors.move;
                //     break;
                //   case CropFrameAnchorPoint.left:
                //     cursor = SystemMouseCursors.resizeLeftRight;
                //     break;
                //   case CropFrameAnchorPoint.top:
                //     cursor = SystemMouseCursors.resizeUpDown;
                //     break;
                //   case CropFrameAnchorPoint.right:
                //     cursor = SystemMouseCursors.resizeLeftRight;
                //     break;
                //   case CropFrameAnchorPoint.bottom:
                //     cursor = SystemMouseCursors.resizeUpDown;
                //     break;
                //   case CropFrameAnchorPoint.leftTop:
                //     cursor = SystemMouseCursors.resizeUpLeftDownRight;
                //     break;
                //   case CropFrameAnchorPoint.rightTop:
                //     cursor = SystemMouseCursors.resizeUpRightDownLeft;
                //     break;
                //   case CropFrameAnchorPoint.leftBottom:
                //     cursor = SystemMouseCursors.resizeUpRightDownLeft;
                //     break;
                //   case CropFrameAnchorPoint.rightBottom:
                //     cursor = SystemMouseCursors.resizeUpLeftDownRight;
                //     break;
                // }
              },
              child: ListenableBuilder(
                listenable: controller,
                builder: (BuildContext context, Widget? child) {
                  return ValueListenableBuilder(
                    valueListenable: anchorPoint,
                    builder:
                        (
                          BuildContext context,
                          CropFrameAnchorPoint anchorPoint,
                          Widget? child,
                        ) {
                          return MouseRegion(
                            cursor: getCursor(anchorPoint),
                            child: child,
                          );
                        },
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black,
                          width: controller.width * scale,
                          height: controller.height * scale,
                        ),

                        Positioned(
                          left: controller.left * scale,
                          top: controller.top * scale,
                          width: controller.frameWidth * scale,
                          height: controller.frameHeight * scale,
                          child: Container(
                            color: Colors.blue,
                            width: controller.frameWidth * scale,
                            height: controller.frameHeight * scale,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),

        Column(
          children: [
            for (final CropFrameRatio ratio in CropFrameRatio.values)
              AppButton(
                onClick: () {
                  controller.ratio = ratio;
                },
                child: AppText(ratio.name, isTranslate: false),
              ),
          ],
        ),
      ],
    );
  }
}

// class EditParams{
//   final double rotation;
//   final Rect cropFrame;
//   final ImageFragmentParams fragmentParams;
//
//   const EditParams({
//     required this.rotation,
//     required this.cropFrame,
//     required this.fragmentParams,
//   });
// }
