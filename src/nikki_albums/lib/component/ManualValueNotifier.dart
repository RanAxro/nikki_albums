import "package:flutter/material.dart";

class ManualValueNotifier<T> extends ChangeNotifier{
  T value;

  ManualValueNotifier(this.value);

  void notify(){
    notifyListeners();
  }
}
class ManualValueNotifierBuilder<T> extends StatelessWidget{
  final ManualValueNotifier<T> valueListenable;
  final Widget Function(BuildContext, T, Widget?) builder;
  final Widget? child;

  const ManualValueNotifierBuilder({
    super.key,
    required this.valueListenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context){
    return ListenableBuilder(
      listenable: valueListenable,
      builder: (BuildContext context, Widget? child){
        return builder(context, valueListenable.value, child);
      },
    );
  }
}


class Notifier extends ChangeNotifier{
  Notifier();

  void notify(){
    notifyListeners();
  }
}
class NotifierBuilder extends StatelessWidget{
  final Notifier listenable;
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const NotifierBuilder({
    super.key,
    required this.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context){
    return ListenableBuilder(
      listenable: listenable,
      builder: (BuildContext context, Widget? child){
        return builder(context, child);
      },
    );
  }
}