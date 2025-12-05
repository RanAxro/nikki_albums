import "IndependentScrollbar.dart";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

/// 平滑滚动
class SmoothPointerScroll extends StatefulWidget{
  final ScrollController _scrollController;  // ScrollView 的 ScrollController
  final double _initialScrollOffset;
  final bool _isInternalController;  // 外部是否传入了ScrollController
  final Duration _duration;  // 平滑过渡动画时长
  final Curve _curve;  // 平滑过渡动画曲线
  final Widget Function(BuildContext, ScrollController, ScrollPhysics, IndependentScrollbar) builder;  // builder 返回 ScrollController 传入到需要的 ScrollView 上

  SmoothPointerScroll({
    super.key,
    ScrollController? scrollController,
    double initialScrollOffset = 0,
    Duration duration = const Duration(milliseconds: 150),
    Curve curve = Curves.easeOut,
    required this.builder,
  }) :
    _scrollController = scrollController ?? ScrollController(),
    _initialScrollOffset = initialScrollOffset,
    _isInternalController = scrollController == null,
    _duration = duration,
    _curve = curve
  ;

  @override
  State<SmoothPointerScroll> createState() => _SmoothPointerScroll();
}

class _SmoothPointerScroll extends State<SmoothPointerScroll>{
  late double _offset;  // ScrollView 当前位置, 不听从 ScrollController
  bool isMouse = false;  // 当前是否使用鼠标
  late final IndependentScrollController scrollbarController;  // 滚动条 Controller
  late final IndependentScrollbar scrollbar;

  double get offset => _offset;
  set offset(double target){
    if(!widget._scrollController.hasClients) return;
    // 更新 offset
    _offset = target.clamp(widget._scrollController.position.minScrollExtent, widget._scrollController.position.maxScrollExtent);
    animateTo();
  }
  set forceOffset(double target){
    if(!widget._scrollController.hasClients) return;
    _offset = target.clamp(widget._scrollController.position.minScrollExtent, widget._scrollController.position.maxScrollExtent);
    jumpTo();
  }

  // 页面滚动动画
  void animateTo(){
    if(widget._duration == Duration.zero){
      jumpTo();
    }else{
      widget._scrollController.animateTo(
        offset,
        duration: widget._duration,
        curve: widget._curve,
      );
    }
  }
  void jumpTo(){
    widget._scrollController.jumpTo(offset);
  }

  @override
  void initState(){
    super.initState();

    _offset = widget._initialScrollOffset;

    scrollbarController = IndependentScrollController();
    scrollbarController.addListener((){
      if(scrollbarController.isDrag){
        forceOffset = widget._scrollController.position.maxScrollExtent * scrollbarController.progress;
        // 当前用户正在拖拽滚动条, 更新 ScrollView 的位置
        // offset = widget._scrollController.position.maxScrollExtent * scrollbarController.progress;
      }
    });
    widget._scrollController.addListener((){
      if(scrollbarController.isDrag == false){
        // ScrollView 的位置发生变化, 更新滚动条progress
        scrollbarController.progress = widget._scrollController.offset / widget._scrollController.position.maxScrollExtent;
      }
    });

    // 监听帧绘制完成
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(widget._scrollController.hasClients){
        widget._scrollController.jumpTo(_offset);
        
        // 将 ScrollView 的长度传给滚动条
        final maxExtent = widget._scrollController.position.maxScrollExtent;
        scrollbarController.length = maxExtent;
      }
    });

    scrollbar = IndependentScrollbar(
      controller: scrollbarController,
      thickness: 8,
      radius: const Radius.circular(4),
      color: Colors.blue,
      trackColor: Colors.grey[300],
    );
  }

  @override
  Widget build(BuildContext context){
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (details){
        if(details.kind == PointerDeviceKind.mouse){
          isMouse = true;
        }
      },
      onPointerUp: (details){
        if(details.kind == PointerDeviceKind.mouse){
          isMouse = false;
        }
      },
      onPointerSignal: (event){
        if(event is PointerScrollEvent) offset += event.scrollDelta.dy;
      },
      child: GestureDetector(
        onVerticalDragUpdate: (event){
          // 仅在触摸屏上才可拖拽
          if(isMouse) return;

          if(event.primaryDelta != null) offset -= event.primaryDelta!;
        },
        child: MouseRegion(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: widget.builder(context, widget._scrollController, const NeverScrollableScrollPhysics(), scrollbar),
          ),
        ),
      )
    );
  }

  @override
  void dispose(){
    super.dispose();
    if(widget._isInternalController) widget._scrollController.dispose();
    scrollbarController.dispose();
  }
}