import "dart:math";
import "package:nikki_albums/utils/math/angle.dart";
import "package:vector_math/vector_math.dart" hide Colors;
import "dart:ui" as ui;

// import "package:flutter/gestures.dart" hide Matrix4;
import "package:flutter/material.dart" hide Matrix4;
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
  w1h2(1 / 2),
  w5h4(5 / 4),
  w4h5(4 / 5),
  w21h9(21 / 9),
  w9h21(9 / 21);

  final double ratio;
  const CropFrameRatio(this.ratio);

  static Map<CropFrameRatio, CropFrameRatio> _flipMap = {
    CropFrameRatio.free: CropFrameRatio.free,
    CropFrameRatio.origin: CropFrameRatio.origin,
    CropFrameRatio.current: CropFrameRatio.current,
    CropFrameRatio.w1h1: CropFrameRatio.w1h1,
    CropFrameRatio.w3h4: CropFrameRatio.w4h3,
    CropFrameRatio.w4h3: CropFrameRatio.w3h4,
    CropFrameRatio.w16h9: CropFrameRatio.w9h16,
    CropFrameRatio.w9h16: CropFrameRatio.w16h9,
    CropFrameRatio.w2h3: CropFrameRatio.w3h2,
    CropFrameRatio.w3h2: CropFrameRatio.w2h3,
    CropFrameRatio.w2h1: CropFrameRatio.w1h2,
    CropFrameRatio.w1h2: CropFrameRatio.w2h1,
    CropFrameRatio.w5h4: CropFrameRatio.w4h5,
    CropFrameRatio.w4h5: CropFrameRatio.w5h4,
    CropFrameRatio.w21h9: CropFrameRatio.w9h21,
    CropFrameRatio.w9h21: CropFrameRatio.w21h9,
  };

  CropFrameRatio get flip => _flipMap[this]!;

  String get key => "image_edit.$name";
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
        1,
      );
  static const ImageCroppingParamDef cropFrameBottom =
      ImageCroppingParamDef<double>(
        ImageCroppingType.cropFrameBottom,
        "ie_crop_frame_bottom",
        1,
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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ImageCroppingParams &&
            other.rotation == rotation &&
            other.cropFrameRatio == cropFrameRatio &&
            other.cropFrameLeft == cropFrameLeft &&
            other.cropFrameTop == cropFrameTop &&
            other.cropFrameRight == cropFrameRight &&
            other.cropFrameBottom == cropFrameBottom;
  }

  @override
  int get hashCode => Object.hashAll([
    rotation,
    cropFrameRatio,
    cropFrameLeft,
    cropFrameTop,
    cropFrameRight,
    cropFrameBottom,
  ]);
}

class ImageCroppingHandler {
  final ui.Image image;

  const ImageCroppingHandler({required this.image});

  Future<ui.Image> handle(ImageCroppingParams params) async {
    final Size originalSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final Size rotatedBoundary = getRotatingRectangleBoundary(
      originalSize,
      params.rotation,
      unit: AngleUnit.radian,
    );

    final double canvasWidth = rotatedBoundary.width;
    final double canvasHeight = rotatedBoundary.height;

    // 计算裁剪区域
    final double cropLeft = params.cropFrameLeft * canvasWidth;
    final double cropTop = params.cropFrameTop * canvasHeight;
    final double cropRight = params.cropFrameRight * canvasWidth;
    final double cropBottom = params.cropFrameBottom * canvasHeight;

    final double cropWidth = cropRight - cropLeft;
    final double cropHeight = cropBottom - cropTop;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // 关键：先裁剪再绘制，直接输出目标尺寸
    canvas.clipRect(Rect.fromLTWH(0, 0, cropWidth, cropHeight));

    // 变换矩阵：平移使得裁剪区域左上角对准 (0,0)
    canvas.translate(-cropLeft, -cropTop);

    // 执行旋转绘制（与之前相同）
    canvas.translate(canvasWidth / 2, canvasHeight / 2);
    canvas.rotate(params.rotation);
    canvas.translate(-originalSize.width / 2, -originalSize.height / 2);

    canvas.drawImage(
      image,
      Offset.zero,
      Paint()..filterQuality = FilterQuality.high,
    );

    final ui.Picture picture = recorder.endRecording();
    return await picture.toImage(cropWidth.toInt(), cropHeight.toInt());
  }
}

class ImageCroppingProcessor {
  int _rotation;
  double _width;
  double _height;
  CropFrameRatio _ratio;
  final double minLength;
  final Vector4 _frame;
  final Vector4 _virtuality;

  ImageCroppingProcessor(
    int rotation,
    double width,
    double height,
    CropFrameRatio ratio,
    this.minLength,
    Vector4 frame,
  ) : _rotation = rotation,
      _width = width,
      _height = height,
      _ratio = ratio,
      _frame = frame,
      _virtuality = frame.clone() {
    this.ratio = ratio;
  }

  factory ImageCroppingProcessor.fromLTRB({
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

    return ImageCroppingProcessor(
      0,
      width,
      height,
      ratio,
      max(0, minLength),
      Vector4(l, t, r, b),
    );
  }

  factory ImageCroppingProcessor.fromParams({
    required double width,
    required double height,
    double minLength = 1,
    required ImageCroppingParams params,
  }) {
    return ImageCroppingProcessor(
      (2 * params.rotation / pi).toInt(),
      width,
      height,
      params.cropFrameRatio,
      minLength,
      Vector4(
        params.cropFrameLeft * width,
        params.cropFrameTop * height,
        params.cropFrameRight * width,
        params.cropFrameBottom * height,
      ),
    );
  }

  double get width => _width;
  double get height => _height;
  Size get size => Size(width, height);
  double get _l => _virtuality.left;
  double get _t => _virtuality.top;
  double get _r => _virtuality.right;
  double get _b => _virtuality.bottom;
  double get _w => _virtuality.rectWidth;
  double get _h => _virtuality.rectHeight;
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
  Vector2 get center => Vector2(0.5 * (left + right), 0.5 * (top + bottom));
  Vector2 get leftTop => Vector2(left, top);
  Vector2 get rightTop => Vector2(right, top);
  Vector2 get rightBottom => Vector2(right, bottom);
  Vector2 get leftBottom => Vector2(left, bottom);

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

    l = l.clamp(0, width);
    t = t.clamp(0, height);
    r = r.clamp(0, width);
    b = b.clamp(0, height);

    if (l > r) {
      (l, r) = (r, l);
    } else if (l == r) {
      l = (--l).clamp(0, width);
      r = (++r).clamp(0, width);
    }

    if (t > b) {
      (t, b) = (b, t);
    } else if (t == b) {
      t = (--t).clamp(0, height);
      b = (++b).clamp(0, height);
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
          rect.top.clamp(0, height),
          width,
          rect.bottom.clamp(0, height),
        );
      }
      if (rect.top > height) {
        return Vector4(
          rect.left.clamp(0, width),
          height,
          rect.right.clamp(0, width),
          height,
        );
      }
      if (rect.right < 0) {
        return Vector4(
          0,
          rect.top.clamp(0, height),
          0,
          rect.bottom.clamp(0, height),
        );
      }

      /// bottom < 0
      return Vector4(
        rect.left.clamp(0, width),
        0,
        rect.right.clamp(0, width),
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

  CropFrameAnchorPoint getAnchorPoint(Vector2 pos, {double e = 5}) {
    final double toLT = leftTop.distanceToSquared(pos);
    final double toRT = rightTop.distanceToSquared(pos);
    final double toRB = rightBottom.distanceToSquared(pos);
    final double toLB = leftBottom.distanceToSquared(pos);

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

    if (pos.x < left - e ||
        pos.x > right + e ||
        pos.y < top - e ||
        pos.y > bottom + e)
      return CropFrameAnchorPoint.none;

    final double toL = (pos.x - left).abs();
    final double toT = (pos.y - top).abs();
    final double toR = (pos.x - right).abs();
    final double toB = (pos.y - bottom).abs();
    final double minDistanceFromLine = min(min(toL, toT), min(toR, toB));
    if (minDistanceFromLine <= e) {
      if (minDistanceFromLine == toL) return CropFrameAnchorPoint.left;
      if (minDistanceFromLine == toT) return CropFrameAnchorPoint.top;
      if (minDistanceFromLine == toR) return CropFrameAnchorPoint.right;
      if (minDistanceFromLine == toB) return CropFrameAnchorPoint.bottom;
    }

    return CropFrameAnchorPoint.center;
  }

  void _rotate() {
    final double toWidth = _height;
    final double toHeight = _width;
    final double toLeft = _height - _frame.bottom;
    final double toTop = _frame.left;
    final double toRight = _height - _frame.top;
    final double toBottom = _frame.right;
    _width = toWidth;
    _height = toHeight;
    _frame.setValues(toLeft, toTop, toRight, toBottom);
    _frame.copyInto(_virtuality);
    _ratio = _ratio.flip;
  }

  int get rotation => _rotation;
  double get rotationDegree => (90 * rotation).toDouble();
  double get rotationRadian => 0.5 * pi * rotation;

  set rotation(int r) {
    int times = (r - _rotation) % 4;
    while (times-- != 0) {
      _rotate();
    }
    _rotation = r % 4;
  }

  void rotate() {
    rotation = rotation + 1;
  }

  void contraRotate() {
    rotation = rotation - 1;
  }

  CropFrameRatio get ratio => _ratio;

  set ratio(CropFrameRatio newRatio) {
    if (newRatio != CropFrameRatio.free) {
      final Vector2 center = this.center;

      final double minHorizontal = min(center.x, width - center.x);
      final double minVertical = min(center.y, height - center.y);

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

      _frame.left = center.x - halfWidth;
      _frame.top = center.y - halfHeight;
      _frame.right = center.x + halfWidth;
      _frame.bottom = center.y + halfHeight;
    }

    _frame.copyInto(_virtuality);
    _ratio = newRatio;
  }

  void transformStart(CropFrameAnchorPoint anchorPoint) {
    _anchorPoint = anchorPoint;
  }

  void transformUpdate(Vector2 delta) {
    if (_anchorPoint == CropFrameAnchorPoint.none) return;

    _virtuality.add(_anchorPoint.frag.multiplied(delta.xyxy));

    if (_ratio == CropFrameRatio.free) {
      _updateFrameWithoutRatio();
    } else {
      _updateFrameWithRatio();
    }
  }

  void _updateFrameWithoutRatio() {
    if (_anchorPoint == CropFrameAnchorPoint.center) {
      return _moveFrame();
    }

    final Vector4 d = _virtuality - _frame;
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
    _frame.add(d);
  }

  void _updateFrameWithRatio() {
    if (_anchorPoint == CropFrameAnchorPoint.center) {
      return _moveFrame();
    }

    final Vector4 maxRect = _getIntersection(_virtuality);

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
      d = d.clamp(minD, maxD);

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
    _frame.copyInto(_virtuality);
  }

  void resetRotation() {
    rotation = 0;
  }

  void resetFrame() {
    _frame.setValues(0, 0, width, height);
    _frame.copyInto(_virtuality);
    _ratio = CropFrameRatio.free;
  }

  ImageCroppingParams get params {
    return ImageCroppingParams(
      rotation: rotationRadian,
      cropFrameRatio: ratio,
      cropFrameLeft: left / width,
      cropFrameTop: top / height,
      cropFrameRight: right / width,
      cropFrameBottom: bottom / height,
    );
  }

  set params(ImageCroppingParams p) {
    rotation = (p.rotation / (pi / 2)).toInt();
    _frame.setValues(
      p.cropFrameLeft * width,
      p.cropFrameTop * height,
      p.cropFrameRight * width,
      p.cropFrameBottom * height,
    );
    _frame.copyInto(_virtuality);
    ratio = p.cropFrameRatio;
  }
}

class ImageCroppingController extends ChangeNotifier {
  Size _widgetSize;
  final ImageCroppingProcessor _processor;

  ImageCroppingController.fromProcessor({
    required ImageCroppingProcessor processor,
  }) : _widgetSize = processor.size,
       _processor = processor;

  factory ImageCroppingController.fromParams({
    required double width,
    required double height,
    double minLength = 1,
    required ImageCroppingParams params,
  }) {
    return ImageCroppingController.fromProcessor(
      processor: ImageCroppingProcessor.fromParams(
        width: width,
        height: height,
        minLength: minLength,
        params: params,
      ),
    );
  }

  void _calculateLocation() {
    final double scale = fitRectangleScale(_widgetSize, _processor.size);
    final Size toSize = _processor.size * scale;
    Offset offset = centerRectangle(_widgetSize, toSize);
    if (offset.dx.isInfinite) {
      offset = Offset(0, offset.dy);
    }
    if (offset.dy.isInfinite) {
      offset = Offset(offset.dx, 0);
    }

    _scale = scale;
    _offset = offset;
  }

  double _scale = 1;
  Offset _offset = Offset.zero;
  Size get widgetSize => _widgetSize;
  set widgetSize(Size size) {
    _widgetSize = size;

    _calculateLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  double get imageLeft => _offset.dx;
  double get imageTop => _offset.dy;
  double get imageWidth => _processor.width * _scale;
  double get imageHeight => _processor.height * _scale;
  double get frameLeft => _offset.dx + _processor.left * _scale;
  double get frameTop => _offset.dy + _processor.top * _scale;
  double get frameWidth => _processor.frameWidth * _scale;
  double get frameHeight => _processor.frameHeight * _scale;

  double get e => 6;
  CropFrameAnchorPoint getAnchorPoint(Offset offset) {
    final Offset localOffset = offset - _offset;
    return _processor.getAnchorPoint(
      Vector2(localOffset.dx / _scale, localOffset.dy / _scale),
      e: e / _scale,
    );
  }

  int get rotation => _processor.rotation;
  double get rotationDegree => _processor.rotationDegree;
  double get rotationRadian => _processor.rotationRadian;

  void rotate() {
    _processor.rotate();

    _calculateLocation();

    notifyListeners();
  }

  void contraRotate() {
    _processor.contraRotate();

    _calculateLocation();

    notifyListeners();
  }

  CropFrameRatio get ratio => _processor.ratio;
  set ratio(CropFrameRatio r) {
    _processor.ratio = r;
    notifyListeners();
  }

  void transformStart(CropFrameAnchorPoint anchorPoint) {
    _processor.transformStart(anchorPoint);
    notifyListeners();
  }

  void transformUpdate(Offset offset) {
    _processor.transformUpdate(Vector2(offset.dx / _scale, offset.dy / _scale));
    notifyListeners();
  }

  void transformEnd() {
    _processor.transformEnd();
    notifyListeners();
  }

  void resetRotation() {
    _processor.resetRotation();

    _calculateLocation();

    notifyListeners();
  }

  void resetFrame() {
    _processor.resetFrame();

    notifyListeners();
  }

  ImageCroppingParams get params => _processor.params;

  set params(ImageCroppingParams p) {
    _processor.params = p;
    notifyListeners();
  }
}
