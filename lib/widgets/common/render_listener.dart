
import "package:flutter/material.dart";

class RenderListener extends StatelessWidget{
  final void Function(Rect)? onRender;
  final Widget child;

  const RenderListener({
    super.key,
    this.onRender,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    if(onRender != null){
      WidgetsBinding.instance.addPostFrameCallback((_){
        final RenderObject? renderObject = context.findRenderObject();
        if(renderObject == null) return;

        if(renderObject is RenderBox && renderObject.hasSize){
          final Offset offset = renderObject.localToGlobal(Offset.zero);
          final Size size = renderObject.size;
          onRender?.call(Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height));
        }
      });
    }

    return child;
  }
}