import "IndependentScrollbar.dart";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

/// 平滑滚动
class SmoothPointerScroll extends StatefulWidget{
  final double _initialScrollOffset;
  final ScrollController? _scrollController;  // ScrollView 的 ScrollController
  final IndependentScrollbarController? _scrollbarController;
  final Duration _duration;  // 平滑过渡动画时长
  final Curve _curve;  // 平滑过渡动画曲线
  final Widget Function(BuildContext, ScrollController, ScrollPhysics, IndependentScrollbarController) builder;  // builder 返回 ScrollController 传入到需要的 ScrollView 上

  const SmoothPointerScroll({
    super.key,
    double initialScrollOffset = 0,
    ScrollController? scrollController,
    IndependentScrollbarController? scrollbarController,
    Duration duration = const Duration(milliseconds: 150),
    Curve curve = Curves.easeOut,
    required this.builder,
  }) :
    _scrollController = scrollController,
    _initialScrollOffset = initialScrollOffset,
    _scrollbarController = scrollbarController,
    _duration = duration,
    _curve = curve
  ;

  @override
  State<SmoothPointerScroll> createState() => _SmoothPointerScroll();
}

class _SmoothPointerScroll extends State<SmoothPointerScroll>{
  late final ScrollController scrollController;
  late double _offset;  // ScrollView 当前位置, 不听从 ScrollController
  late final IndependentScrollbarController scrollbarController;  // 滚动条 Controller

  bool isMouse = false;  // 当前是否使用鼠标


  double get offset => _offset;
  set offset(double target){
    if(!scrollController.hasClients) return;

    // 更新 offset
    _offset = target.clamp(scrollController.position.minScrollExtent, scrollController.position.maxScrollExtent);
    animateTo();
  }
  set forceOffset(double target){
    if(!scrollController.hasClients) return;

    _offset = target.clamp(scrollController.position.minScrollExtent, scrollController.position.maxScrollExtent);
    jumpTo();
  }

  // 页面滚动动画
  void animateTo(){
    if(widget._duration == Duration.zero){
      jumpTo();
    }else{
      scrollController.animateTo(
        offset,
        duration: widget._duration,
        curve: widget._curve,
      );
    }
  }
  void jumpTo(){
    scrollController.jumpTo(offset);
  }

  @override
  void initState(){
    super.initState();

    _offset = widget._initialScrollOffset;
    scrollController = widget._scrollController ?? ScrollController(initialScrollOffset: offset);
    scrollbarController = widget._scrollbarController ?? IndependentScrollbarController();

    scrollbarController.addListener((){
      if(scrollbarController.isDrag){
        // 当前用户正在拖拽滚动条, 更新 ScrollView 的位置
        forceOffset = scrollController.position.maxScrollExtent * scrollbarController.progress;
      }
    });
    scrollController.addListener((){
      if(!scrollController.hasClients) return;

      scrollbarController.virtualScrollViewExtent = scrollController.position.maxScrollExtent;

      if(scrollbarController.isDrag == false){
        // ScrollView 的位置发生变化, 更新滚动条progress
        scrollbarController.progress = scrollController.offset / scrollController.position.maxScrollExtent;
      }
    });

    // 监听帧绘制完成
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(scrollController.hasClients){
        scrollbarController.virtualScrollViewExtent = scrollController.position.maxScrollExtent;
        scrollController.jumpTo(_offset);
      }else{
        scrollbarController.virtualScrollViewExtent = 0;
      }
    });
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
            child: widget.builder(context, scrollController, const NeverScrollableScrollPhysics(), scrollbarController),
          ),
        ),
      )
    );
  }

  @override
  void dispose(){
    super.dispose();
    if(widget._scrollController == null) scrollController.dispose();
    if(widget._scrollbarController == null) scrollbarController.dispose();
  }
}