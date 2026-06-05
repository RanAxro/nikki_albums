
import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/gestures.dart";




class FloatingIndicatorGroup extends StatefulWidget{
  final Duration floatDuration;
  final Duration delta;
  final bool hideWhenNoTarget;
  final Widget Function(BuildContext, BoxConstraints, [Object?]) indicatorBuilder;
  final Widget child;

  const FloatingIndicatorGroup({
    super.key,
    this.floatDuration = const Duration(milliseconds: 100),
    this.delta = const Duration(milliseconds: 100),
    this.hideWhenNoTarget = true,
    required this.indicatorBuilder,
    required this.child,
  });

  @override
  State<FloatingIndicatorGroup> createState() => _FloatingIndicatorGroupState();
}
class _FloatingIndicatorGroupState extends State<FloatingIndicatorGroup>{
  Rect? _default;
  Object? _defaultInfo;
  Rect? _last;
  Rect? _current;
  Object? _currentInfo;

  Timer? _timer;

  Offset? _getOffset(BuildContext context){
    final RenderObject? renderObject = context.findRenderObject();
    if(renderObject == null) return null;

    if(renderObject is RenderBox && renderObject.hasSize){
      return renderObject.localToGlobal(Offset.zero);
    }

    return null;
  }

  void _setDefault(Rect? rect, Object? info){
    WidgetsBinding.instance.addPostFrameCallback((_){
      final Offset? offset = _getOffset(context);

      if(offset != null){
        setState((){
          _default = rect?.translate(-offset.dx, -offset.dy);
          _defaultInfo = info;
        });
      }
    });
  }

  void _set(Rect? rect, Object? info){
    _timer?.cancel();

    if(rect == null){
      /// If there is no new target after the delay of delta, then the process ends
      if(_default == null){
        _timer = Timer.periodic(widget.delta, (Timer timer){
          setState((){
            _last = _current;
            _current = rect;
            _currentInfo = info;
          });
        });
      }
      /// move indicator to default
      else{
        setState((){
          _last = _current;
          _current = _default;
          _currentInfo = _defaultInfo;
        });
      }
    }
    /// move indicator
    else{
      final Offset? offset = _getOffset(context);

      if(offset != null){
        setState((){
          _last = _current;
          _current = rect.translate(-offset.dx, -offset.dy);
          _currentInfo = info;
        });
      }
    }
  }

  Widget _buildIndicator(){
    late final double x;
    late final double y;
    late final double w;
    late final double h;
    late final bool transparent;
    late final Duration moveDuration;

    /// Start hovering
    if(_last == null && _current != null){
      x = _current!.left;
      y = _current!.top;
      w = _current!.width;
      h = _current!.height;
      transparent = false;
      moveDuration = Duration.zero;
    }
    /// Stop hovering
    else if(_last != null && _current == null){
      x = _last!.left;
      y = _last!.top;
      w = _last!.width;
      h = _last!.height;
      transparent = widget.hideWhenNoTarget;
      moveDuration = widget.floatDuration;
    }
    /// Is hovering
    else if(_last != null && _current != null){
      x = _current!.left;
      y = _current!.top;
      w = _current!.width;
      h = _current!.height;
      transparent = false;
      moveDuration = widget.floatDuration;
    }
    /// No hovering
    else{
      // It will never come to this code block.
      x = 0;
      y = 0;
      w = 0;
      h = 0;
      transparent = true;
      moveDuration = Duration.zero;
    }

    return AnimatedPositioned(
      duration: moveDuration,
      left: x,
      top: y,
      width: w,
      height: h,
      child: AnimatedOpacity(
        duration: widget.floatDuration,
        opacity: transparent ? 0 : 1,
        child: AnimatedContainer(
          duration: moveDuration,
          width: w,
          height: h,
          child: IgnorePointer(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                return widget.indicatorBuilder(context, constraints, _currentInfo ?? _defaultInfo);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        Positioned.fill(child: widget.child),

        _buildIndicator(),
      ],
    );
  }

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }
}



class FloatingIndicatorTarget extends StatefulWidget{
  final bool defaultTarget;
  final Object? info;
  final Widget? child;

  const FloatingIndicatorTarget({
    super.key,
    this.defaultTarget = false,
    this.info,
    this.child,
  });

  @override
  State<FloatingIndicatorTarget> createState() => _FloatingIndicatorTargetState();
}
class _FloatingIndicatorTargetState extends State<FloatingIndicatorTarget>{
  _FloatingIndicatorGroupState getGroup(BuildContext context){
    final _FloatingIndicatorGroupState? groupState = context.findAncestorStateOfType<_FloatingIndicatorGroupState>();

    if(groupState == null){
      throw "A FloatingIndicatorGroup parent Widget must be present.";
    }else{
      return groupState;
    }
  }

  Rect? _getRect(BuildContext context){
    final RenderObject? renderObject = context.findRenderObject();
    if(renderObject == null) return null;

    if(renderObject is RenderBox && renderObject.hasSize){
      final Offset offset = renderObject.localToGlobal(Offset.zero);
      final Size size = renderObject.size;
      return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    }

    return null;
  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      if(widget.defaultTarget){
        final Rect? rect = _getRect(context);

        getGroup(context)._setDefault(rect, widget.info);
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return MouseRegion(
      onEnter: (PointerEnterEvent event){
        final Rect? rect = _getRect(context);
        if(rect != null){
          getGroup(context)._set(rect, widget.info);
        }
      },
      onExit: (PointerExitEvent event){
        getGroup(context)._set(null, null);
      },
      opaque: false,
      child: widget.child,
    );
  }

  @override
  void dispose(){
    super.dispose();
    if(widget.defaultTarget){
      getGroup(context)._setDefault(null, null);
    }
  }
}

