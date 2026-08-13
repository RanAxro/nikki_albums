
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";


class RepaintDetector extends SingleChildRenderObjectWidget{
  final VoidCallback onRepaint;

  const RepaintDetector({
    super.key,
    required this.onRepaint,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context){
    return RenderRepaintDetector(onRepaint: onRepaint);
  }

  @override
  void updateRenderObject(BuildContext context, RenderRepaintDetector renderObject){
    renderObject.onRepaint = onRepaint;
  }
}

class RenderRepaintDetector extends RenderProxyBox{
  RenderRepaintDetector({
    required this.onRepaint,
    RenderBox? child,
  }) : super(child);

  VoidCallback onRepaint;

  @override
  void paint(PaintingContext context, Offset offset){
    onRepaint(); // 每次重绘前触发回调
    super.paint(context, offset);
  }
}