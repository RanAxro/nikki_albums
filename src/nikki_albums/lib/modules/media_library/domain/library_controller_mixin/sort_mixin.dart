
part of "../library_controller.dart";


mixin SortMixin<T extends MediaItem> on LibraryController<T>{
  bool _reverse = true;
  final Map<T, NGFileStat> _stats = <T, NGFileStat>{};

  bool get reverse => _reverse;
  void setReverse(bool reverse){
    if(reverse == _reverse){
      return;
    }
    _reverse = reverse;
    notify();
  }
  void toggleReverse(){
    setReverse(!_reverse);
  }

  @override
  Iterable<T> getItems(Iterable<T> rawItems){
    final Iterable<T> items = super.getItems(rawItems);

    final List<T> sortable = <T>[];
    final List<T> unsortable = <T>[];
    for(final T item in items){
      final NGFileStat? stat = _stats[item];
      if(stat == null){
        unsortable.add(item);
      }else{
        sortable.add(item);
      }
    }

    if(_reverse){
      sortable.sort((T a, T b) => _stats[b]!.modified.compareTo(_stats[a]!.modified));
    }else{
      sortable.sort((T a, T b) => _stats[a]!.modified.compareTo(_stats[b]!.modified));
    }
    return sortable..addAll(unsortable);
  }

  @override
  Future<void> onItemChanged(Set<T> newItems) async{
    await super.onItemChanged(newItems);
    _stats.removeWhere((T item, _) => !item.immutable || !newItems.contains(item));
    final int max = newItems.length - 1;
    for(final (int index, T item) in newItems.indexed){
      if(_stats.containsKey(items)){
        continue;
      }
      _stats[item] = await item.stat();

      if(this case InitializationMixin<T> initializationMixin){
        initializationMixin.setProgress(index / max);
      }
    }
    notify();
  }
}