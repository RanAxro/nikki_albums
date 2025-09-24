import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SmoothGridviewBuilder extends StatefulWidget {
  const SmoothGridviewBuilder({super.key});
  @override
  State<SmoothGridviewBuilder> createState() => _SmoothGridviewBuilderState();
}

class _SmoothGridviewBuilderState extends State<SmoothGridviewBuilder> {
  final ScrollController _ctrl = ScrollController();

  /* 记录当前滚动位置 */
  double _currentY = 0;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => _currentY = _ctrl.position.pixels);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /* 处理滚轮事件 */
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;

    // 滚轮滚动的距离 d
    final double d = event.scrollDelta.dy;

    // 目标位置
    final double to =
    (_currentY + d).clamp(0.0, _ctrl.position.maxScrollExtent);

    // 平滑滚动
    _ctrl.animateTo(
      to,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wheel → GridView')),
      body: Listener(
        // 把事件交给 resolver，统一分发
        onPointerSignal: (e) =>
            GestureBinding.instance.pointerSignalResolver.register(e, _onPointerSignal),
        child: GridView.builder(
          controller: _ctrl,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: 1000,
          itemBuilder: (_, i) => Card(child: Center(child: Text('$i'))),
        ),
      ),
    );
  }
}