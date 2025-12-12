import "dart:math";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

/// 独立滚动条, 不依赖于 ScrollView

/* =========================  Controller ========================= */

class IndependentScrollbarController extends ChangeNotifier{
  bool _isDrag = false;
  double _progress;
  double? _virtualScrollViewExtent;

  IndependentScrollbarController({
    double initialProgress = 0.0,
    double? initialVirtualScrollViewExtent,
  }) :
    _progress = initialProgress.clamp(0.0, 1.0),
    _virtualScrollViewExtent = initialVirtualScrollViewExtent
  ;

  bool get isDrag => _isDrag;
  double get progress => _progress;
  double? get virtualScrollViewExtent => _virtualScrollViewExtent;

  set progress(double value){
    value = value.clamp(0.0, 1.0);
    if(_progress == value) return;
    _progress = value;
    notifyListeners();
  }
  set virtualScrollViewExtent(double? value){
    if(_virtualScrollViewExtent == value) return;
    _virtualScrollViewExtent = value;
    notifyListeners();
  }

  void _startDrag(){
    if(_isDrag) return;
    _isDrag = true;
    notifyListeners();
  }

  void _endDrag(){
    if(!_isDrag) return;
    _isDrag = false;
    notifyListeners();
  }

  @override
  void dispose(){
    super.dispose();
  }
}

/* =====================  IndependentScrollbar =================== */

class IndependentScrollbar extends StatelessWidget{
  final IndependentScrollbarController controller;
  final Axis direction;
  final double thickness;
  final Radius trackRadius;
  final Color? trackColor;

  final double thumbLength;
  final Radius thumbRadius;
  final Color color;
  final Color? hoveredColor;
  final Color? pressedColor;

  const IndependentScrollbar({
    super.key,
    required this.controller,

    this.direction = Axis.vertical,
    this.thickness = 10,
    this.trackRadius = Radius.zero,
    this.trackColor,

    this.thumbLength = 50,
    this.thumbRadius = Radius.zero,
    this.color = Colors.grey,
    Color? hoveredColor,
    Color? pressedColor,
  }) :
    hoveredColor = hoveredColor ?? color,
    pressedColor = pressedColor ?? color
  ;

  @override
  Widget build(BuildContext context){
    bool isHover = false;

    return SizedBox(
      width: direction == Axis.vertical ? thickness : null,
      height: direction == Axis.horizontal ? thickness : null,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          final viewport = constraints.maxHeight;

          return ListenableBuilder(
            listenable: controller,
            builder: (BuildContext context, Widget? child){
              double length = controller._virtualScrollViewExtent == null ?
              min(thumbLength, 0.9 * viewport) :
              (0.8 * viewport * viewport / controller._virtualScrollViewExtent!).clamp(thumbLength, viewport);

              return Stack(
                children: [
                  child!,
                  Positioned(
                    left: 0,
                    top: controller.progress * (viewport - length),
                    right: 0,
                    height: length,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragDown: (DragDownDetails details){
                        controller._startDrag();
                      },
                      onVerticalDragEnd: (DragEndDetails details){
                        controller._endDrag();
                      },
                      onVerticalDragCancel: (){
                        controller._endDrag();
                      },
                      onVerticalDragUpdate: (DragUpdateDetails details){
                        switch(direction){
                          case Axis.horizontal:
                            controller.progress += details.delta.dx / (viewport - length);
                            break;
                          case Axis.vertical:
                            controller.progress += details.delta.dy / (viewport - length);
                            break;
                        }
                      },
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setThumbState){
                          return MouseRegion(
                            onEnter: (PointerEnterEvent event){
                              isHover = true;
                              setThumbState((){});
                            },
                            onExit: (PointerExitEvent event){
                              isHover = false;
                              setThumbState((){});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.all(thumbRadius),
                                color: controller.isDrag ? pressedColor : isHover ? hoveredColor : color,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
            child: Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.all(trackRadius),
                  color: trackColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}