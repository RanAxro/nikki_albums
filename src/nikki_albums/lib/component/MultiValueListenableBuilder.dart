import "package:flutter/material.dart";

//允许监听多个ValueNotifier
class MultiValueListenableBuilder extends StatelessWidget{
  final List<ValueNotifier<dynamic>> listenables; // 明确限制为 ValueNotifier

  final Widget Function(BuildContext context, Widget? child) builder;

  final Widget? child;

  const MultiValueListenableBuilder({
    super.key,
    required this.listenables,
    required this.builder,
    this.child, // 添加 child 参数
  });

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder<List<Object?>>(
      valueListenable: _CombinedValueListenable(listenables), // 使用改进后的内部类
      builder: (context, values, c) {
        return builder(context, child);
      },
      child: child, // 将外部传入的 child 传递给内部的 ValueListenableBuilder
    );
  }
}

class _CombinedValueListenable extends ValueNotifier<List<Object?>>{
  final List<ValueNotifier<dynamic>> _listenables; // 明确限制为 ValueNotifier
  final List<VoidCallback> _listenerCallbacks = []; // 存储回调函数

  _CombinedValueListenable(List<ValueNotifier<dynamic>> listenables)
      : _listenables = listenables,
        super([]){
    final List<Object?> initialValues = List<Object?>.generate(listenables.length, (i){
      return listenables[i].value; // 因为类型已限制，不再需要 if (listenable is ValueNotifier)
    });
    value = initialValues; // 设置初始值

    for(var i = 0; i < _listenables.length; i++){
      final listenable = _listenables[i];
      // 因为 _listenables 已经被明确限制为 ValueNotifier<dynamic>，所以不再需要类型检查
      listenerCallback(){
        final currentValues = List<Object?>.from(value); // 获取当前组合值
        currentValues[i] = listenable.value; // 更新对应的值
        value = currentValues; // 触发更新
      }
      listenable.addListener(listenerCallback);
      _listenerCallbacks.add(listenerCallback);
    }
  }

  @override
  void dispose(){
    for(var i = 0; i < _listenables.length; i++){
      final listenable = _listenables[i];
      listenable.removeListener(_listenerCallbacks[i]);
    }
    super.dispose();
  }
}