import "package:flutter/material.dart";

/// 独立滚动条, 不依赖于 ScrollView

/* =========================  Controller ========================= */

class IndependentScrollController extends ChangeNotifier{
  double _progress;
  double _length;
  double _viewportExtent = 0;

  IndependentScrollController({
    double initialProgress = 0.0,
    double initialLength = 1000,
  }) :
    _progress = initialProgress.clamp(0.0, 1.0),
    _length = initialLength
  ;

  double get progress => _progress;
  bool get isDrag => _isDrag;
  double get length => _length;

  set length(double value){
    if(value <= 0) value = 1;
    if(_length == value) return;
    _length = value;
    notifyListeners();
  }

  void _updateViewport(double vp){
    if(_viewportExtent == vp) return;
    _viewportExtent = vp;
    notifyListeners();
  }

  bool _isDrag = false;

  set progress(double value){
    value = value.clamp(0.0, 1.0);
    if(_progress == value) return;
    _progress = value;
    notifyListeners();
  }

  void _updateProgressFromDrag(double value){
    value = value.clamp(0.0, 1.0);
    if(_progress == value && _isDrag) return;
    _progress = value;
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
  final IndependentScrollController controller;
  final double thickness;
  final Radius radius;
  final Color? color;
  final Color? trackColor;

  const IndependentScrollbar({
    super.key,
    required this.controller,
    this.thickness = 10,
    this.radius = Radius.zero,
    this.color,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context){
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __){
        return _ScrollbarRender(
          controller: controller,
          thickness: thickness,
          radius: radius,
          color: color ?? Theme.of(context).highlightColor,
          trackColor: trackColor ?? Colors.grey[200],
        );
      },
    );
  }
}

/* ========================  Render + Painter ==================== */

class _ScrollbarRender extends StatefulWidget{
  final IndependentScrollController controller;
  final double thickness;
  final Radius radius;
  final Color color;
  final Color? trackColor;

  const _ScrollbarRender({
    required this.controller,
    required this.thickness,
    required this.radius,
    required this.color,
    required this.trackColor,
  });

  @override
  State<_ScrollbarRender> createState() => _ScrollbarRenderState();
}

class _ScrollbarRenderState extends State<_ScrollbarRender>{
  bool _hovering = false;

  double _thumbHeight(double vp){
    final ratio = vp / widget.controller.length;
    return (vp * ratio).clamp(20.0, vp);
  }

  double _offsetToProgress(Offset local, double vp){
    final th = _thumbHeight(vp);
    final half = th / 2;
    final valid = vp - half * 2;
    return ((local.dy - half) / valid).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (_, constraints){
        final viewport = constraints.maxHeight;
        WidgetsBinding.instance.addPostFrameCallback((_){
          widget.controller._updateViewport(viewport);
        });

        return MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            // 不再用 onVerticalDragDown 更新进度
            onVerticalDragUpdate: (d){
              widget.controller._startDrag();
              widget.controller._updateProgressFromDrag(
                  _offsetToProgress(d.localPosition, viewport));
            },
            onVerticalDragEnd: (_) => widget.controller._endDrag(),
            child: CustomPaint(
              size: Size(widget.thickness, double.infinity),
              painter: _ScrollbarPainter(
                progress: widget.controller.progress,
                thickness: widget.thickness,
                radius: widget.radius,
                color: widget.color.withValues(alpha: _hovering ? 1.0 : 0.5),
                trackColor: widget.trackColor,
                viewportExtent: viewport,
                contentLength: widget.controller.length,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScrollbarPainter extends CustomPainter{
  final double progress, thickness;
  final Radius radius;
  final Color color, trackColor;
  final double viewportExtent;
  final double contentLength;

  _ScrollbarPainter({
    required this.progress,
    required this.thickness,
    required this.radius,
    required this.color,
    required Color? trackColor,
    required this.viewportExtent,
    required this.contentLength,
  }) : trackColor = trackColor ?? Colors.grey[200]!;

  double _thumbHeight(){
    if(contentLength <= viewportExtent) return viewportExtent;
    final ratio = viewportExtent / contentLength;
    return (viewportExtent * ratio).clamp(40.0, viewportExtent);
  }

  @override
  void paint(Canvas canvas, Size size){
    final track = Rect.fromLTWH(0, 0, thickness, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(track, radius),
      Paint()..color = trackColor,
    );

    final th = _thumbHeight();
    final top = (size.height - th) * progress;
    final thumb = Rect.fromLTWH(0, top, thickness, th);
    canvas.drawRRect(
      RRect.fromRectAndRadius(thumb, radius),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _ScrollbarPainter old) => old.progress != progress || old.viewportExtent != viewportExtent || old.contentLength != contentLength || old.color != color;
}