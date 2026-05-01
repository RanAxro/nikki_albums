import "package:flutter/material.dart";

class ManualValueNotifier<T> extends ChangeNotifier {
  T value;

  ManualValueNotifier(this.value);

  void notify() {
    notifyListeners();
  }
}

class ManualValueNotifierBuilder<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: valueListenable,
      builder: (BuildContext context, Widget? child) {
        return builder(context, valueListenable.value, child);
      },
    );
  }
}

class Notifier extends ChangeNotifier {
  Notifier();

  void notify() {
    notifyListeners();
  }
}

class NotifierBuilder extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: listenable,
      builder: (BuildContext context, Widget? child) {
        return builder(context, child);
      },
    );
  }
}

class DetailNotifier<T>{
  final Set<void Function(T)> _listeners = {};

  DetailNotifier();

  void addListener(void Function(T) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(T) listener) {
    _listeners.remove(listener);
  }

  void notify(T value) {
    for (final void Function(T) listener in _listeners) {
      listener.call(value);
    }
  }

  void dispose() {
    _listeners.clear();
  }
}

class DetailNotifierBuilder<T> extends StatefulWidget{
  final T detail;
  final DetailNotifier<T> notifier;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const DetailNotifierBuilder({
    super.key,
    required this.detail,
    required this.notifier,
    required this.builder,
    this.child,
  });

  @override
  State<DetailNotifierBuilder<T>> createState() => _DetailNotifierBuilderState<T>();
}

class _DetailNotifierBuilderState<T> extends State<DetailNotifierBuilder<T>> {
  void listener(T value){
    if(value == widget.detail){
      setState(() {});
    }
  }

  @override
  void initState(){
    super.initState();
    widget.notifier.addListener(listener);
  }

  @override
  Widget build(BuildContext context){
    return widget.builder(context, widget.child);
  }

  @override
  void dispose(){
    widget.notifier.removeListener(listener);
    super.dispose();
  }
}
