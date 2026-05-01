import "dart:io";
import "dart:typed_data";

import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";

import "../domain/cropping.dart";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "dart:ui" as ui;

Future<ui.Image> getImage(String imagePath) async {
  final Uint8List bytes = await File(imagePath).readAsBytes();
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  return (await codec.getNextFrame()).image;
}

class ImageCropping extends StatefulWidget {
  final ui.Image image;
  final ImageCroppingParams? params;

  const ImageCropping({super.key, required this.image, this.params});

  @override
  State<ImageCropping> createState() => _ImageCroppingState();
}

class _ImageCroppingState extends State<ImageCropping> {
  late final ImageCroppingController controller;

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
    controller = ImageCroppingController.fromProcessor(
      processor: ImageCroppingProcessor.fromParams(
        width: widget.image.width.toDouble(),
        height: widget.image.height.toDouble(),
        params: widget.params ?? ImageCroppingParams.defaultParams,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ImageCroppingViewer(
            controller: controller,
            child: RawImage(image: widget.image),
          ),
        ),

        SizedBox(width: 200, child: ImageCroppingPanel(controller: controller)),
      ],
    );
  }
}

class ImageCroppingViewer extends StatefulWidget {
  final ImageCroppingController controller;
  final bool isDrawFrame;
  final ImageCroppingFrameDecoration frameDecoration;
  final bool allowControl;
  final Widget? child;

  const ImageCroppingViewer({
    super.key,
    required this.controller,
    this.isDrawFrame = true,
    this.frameDecoration = const ImageCroppingFrameDecoration(),
    this.allowControl = true,
    this.child,
  });

  @override
  State<ImageCroppingViewer> createState() => _ImageCroppingViewerState();
}

class _ImageCroppingViewerState extends State<ImageCroppingViewer> {
  late final ImageCroppingController controller;
  final ValueNotifier<CropFrameAnchorPoint> anchorPoint =
      ValueNotifier<CropFrameAnchorPoint>(CropFrameAnchorPoint.none);

  MouseCursor getCursor(CropFrameAnchorPoint anchorPoint) {
    if (!widget.isDrawFrame || !widget.allowControl) {
      return MouseCursor.defer;
    }

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        widget.controller.widgetSize = constraints.biggest;

        return Listener(
          onPointerDown: (_) {
            if (widget.isDrawFrame && widget.allowControl) {
              controller.transformStart(anchorPoint.value);
            }
          },
          onPointerUp: (_) {
            if (widget.isDrawFrame && widget.allowControl) {
              controller.transformEnd();
            }
          },
          onPointerMove: (PointerMoveEvent event) {
            if (widget.isDrawFrame && widget.allowControl) {
              controller.transformUpdate(event.delta);
            }
          },
          onPointerHover: (PointerHoverEvent event) {
            if (widget.isDrawFrame && widget.allowControl) {
              anchorPoint.value = controller.getAnchorPoint(
                event.localPosition,
              );
            }
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
                    Positioned(
                      left: controller.imageLeft,
                      top: controller.imageTop,
                      width: controller.imageWidth,
                      height: controller.imageHeight,
                      child: RotatedBox(
                        quarterTurns: controller.rotation,
                        child: widget.child == null
                            ? null
                            : KeepAliveWrapper(child: widget.child!),
                      ),
                    ),

                    if (widget.isDrawFrame)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ImageCroppingFramePainter(
                            frameRect: Rect.fromLTWH(
                              controller.frameLeft,
                              controller.frameTop,
                              controller.frameWidth,
                              controller.frameHeight,
                            ),
                            decoration: widget.frameDecoration,
                          ),
                          size: Size(
                            controller.imageWidth,
                            controller.imageHeight,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    anchorPoint.dispose();
    super.dispose();
  }
}

class ImageCroppingFrameDecoration {
  final double cornerRadius; // 角点半径
  final Color shadowColor; // 阴影颜色
  final Color borderColor; // 边框颜色
  final double borderWidth; // 边框宽度
  final int gridCount; // 格数量

  const ImageCroppingFrameDecoration({
    this.cornerRadius = 6.0,
    this.shadowColor = const Color(0xAA000000),
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
    this.gridCount = 3,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ImageCroppingFrameDecoration &&
            other.cornerRadius == cornerRadius &&
            other.shadowColor == shadowColor &&
            other.borderColor == borderColor &&
            other.borderWidth == borderWidth &&
            other.gridCount == gridCount;
  }

  @override
  int get hashCode => Object.hashAll([
    cornerRadius,
    shadowColor,
    borderColor,
    borderWidth,
    gridCount,
  ]);
}

class ImageCroppingFramePainter extends CustomPainter {
  final Rect frameRect; // 中间透明区域的位置和大小
  final ImageCroppingFrameDecoration decoration;

  ImageCroppingFramePainter({
    required this.frameRect,
    this.decoration = const ImageCroppingFrameDecoration(),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // 1. 绘制四周阴影遮罩（全屏填充，中间挖空）
    paint.color = decoration.shadowColor;
    paint.style = PaintingStyle.fill;

    // 使用 Path 实现中间透明效果
    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height)) // 全屏
      ..addRect(frameRect) // 中间透明区域
      ..fillType = PathFillType.evenOdd; // 奇偶填充规则，实现挖空效果

    canvas.drawPath(path, paint);

    // 2. 绘制白色边框
    final Paint borderPaint = Paint()
      ..color = decoration.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = decoration.borderWidth;

    canvas.drawRect(frameRect, borderPaint);

    // 3. 绘制四个角的小圆点
    final Paint cornerPaint = Paint()
      ..color = decoration.borderColor
      ..style = PaintingStyle.fill;

    // 左上角
    canvas.drawCircle(frameRect.topLeft, decoration.cornerRadius, cornerPaint);
    // 右上角
    canvas.drawCircle(frameRect.topRight, decoration.cornerRadius, cornerPaint);
    // 左下角
    canvas.drawCircle(
      frameRect.bottomLeft,
      decoration.cornerRadius,
      cornerPaint,
    );
    // 右下角
    canvas.drawCircle(
      frameRect.bottomRight,
      decoration.cornerRadius,
      cornerPaint,
    );

    // 4. 绘制九宫格白线
    final Paint gridPaint = Paint()
      ..color = decoration.borderColor.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 垂直线
    for (int i = 1; i < decoration.gridCount; i++) {
      final x = frameRect.left + (frameRect.width / decoration.gridCount) * i;
      canvas.drawLine(
        Offset(x, frameRect.top),
        Offset(x, frameRect.bottom),
        gridPaint,
      );
    }

    // 水平线
    for (int i = 1; i < decoration.gridCount; i++) {
      final y = frameRect.top + (frameRect.height / decoration.gridCount) * i;
      canvas.drawLine(
        Offset(frameRect.left, y),
        Offset(frameRect.right, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ImageCroppingFramePainter oldDelegate) {
    return oldDelegate.frameRect != frameRect ||
        oldDelegate.decoration != decoration;
  }
}

class ImageCroppingPanel extends StatefulWidget {
  final ImageCroppingController controller;

  const ImageCroppingPanel({super.key, required this.controller});

  @override
  State<ImageCroppingPanel> createState() => _ImageCroppingPanelState();
}

class _ImageCroppingPanelState extends State<ImageCroppingPanel> {
  late final ImageCroppingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: listSpacing,
      children: [
        Row(
          children: [
            AppButton.smallIcon(
              onClick: () {
                controller.contraRotate();
              },
              child: AppText("逆时针", isTranslate: false),
            ),
            AppButton.smallIcon(
              onClick: () {
                controller.rotate();
              },
              child: AppText("顺时针", isTranslate: false),
            ),
            AppButton.smallIcon(
              onClick: () {
                controller.resetRotation();
              },
              child: AppIcon("refresh"),
            ),
          ],
        ),

        AppButton.smallIcon(
          onClick: () {
            controller.resetFrame();
          },
          child: AppIcon("refresh"),
        ),

        for (final CropFrameRatio ratio in CropFrameRatio.values)
          ListenableBuilder(
            listenable: controller,
            builder: (BuildContext context, Widget? child) {
              return AppSwitch.smallText(
                value: controller.ratio == ratio,
                onChanged: (bool value) {
                  controller.ratio = ratio;
                },
                child: AppText(ratio.toString(), isTranslate: false),
              );
            },
          ),
      ],
    );
  }
}
