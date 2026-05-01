import "component.dart";

import "package:flutter/material.dart";

class SlideFadeIn extends StatefulWidget {
  final Duration duration;
  final Curve curve;

  final Offset offsetBegin;
  final double opacityBegin;

  final Widget child;

  const SlideFadeIn({
    super.key,
    this.duration = animationTime,
    this.curve = Curves.easeOut,
    this.offsetBegin = Offset.zero,
    this.opacityBegin = 1,
    required this.child,
  });

  @override
  State<SlideFadeIn> createState() => _SlideFadeInState();
}

class _SlideFadeInState extends State<SlideFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    // 偏移
    _slideAnimation = Tween<Offset>(
      begin: widget.offsetBegin,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // 透明度
    _fadeAnimation = Tween<double>(
      begin: widget.opacityBegin,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // 启动动画
    _controller.forward();
  }

  @override
  void didUpdateWidget(SlideFadeIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 每次rebuild时重新播放动画
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
