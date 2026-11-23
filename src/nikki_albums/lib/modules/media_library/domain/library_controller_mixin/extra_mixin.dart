
part of "../library_controller.dart";


mixin ExtraMixin<E, T extends MediaItem> on LibraryController<T>{
  final Map<T, E> _extras = <T, E>{};

  bool hasExtra(T item){
    return _extras.containsKey(item);
  }

  E? getExtra(T item){
    return _extras[item];
  }

  void setExtra(T item, E extra){
    if(extra == _extras[item]){
      return;
    }
    _extras[item] = extra;
    notify();
  }

  E? removeExtra(T item){
    final E? removed = _extras.remove(item);
    notify();
    return removed;
  }
}