
part of "../library_controller.dart";


mixin SortAndClassificationMixin<T extends MediaItem> on LibraryController<T>{
  bool _reverse = true;
  ClassificationStandard _classificationStandard = ClassificationStandard.day;
  SortingMethod<T> _sortingMethod = SortingMethod<T>.mTime();
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

  SortingMethod<T> get sortingMethod => _sortingMethod;
  void setSortingMethod(SortingMethod<T> method){
    if(method == _sortingMethod){
      return;
    }
    _sortingMethod = method;
    notify();
  }

  void _sort(List<T> sortable){
    switch(_sortingMethod){
      case SortingMethod_None<T>():
        return;
      case SortingMethod_CTime<T>():
        return sortable.sort((T a, T b) => _stats[a]!.changed.compareTo(_stats[b]!.changed));
      case SortingMethod_MTime<T>():
        return sortable.sort((T a, T b) => _stats[a]!.modified.compareTo(_stats[b]!.modified));
      case SortingMethod_ATime<T>():
        return sortable.sort((T a, T b) => _stats[a]!.accessed.compareTo(_stats[b]!.accessed));
      case SortingMethod_Size<T>():
        return sortable.sort((T a, T b) => _stats[a]!.size.compareTo(_stats[b]!.size));
      case SortingMethod_Custom<T>(:final int Function(T a, T b) compare):
        return sortable.sort(compare);
    }
  }

  void _sortReverse(List<T> sortable){
    switch(_sortingMethod){
      case SortingMethod_None<T>():
        return;
      case SortingMethod_CTime<T>():
        return sortable.sort((T a, T b) => _stats[b]!.changed.compareTo(_stats[a]!.changed));
      case SortingMethod_MTime<T>():
        return sortable.sort((T a, T b) => _stats[b]!.modified.compareTo(_stats[a]!.modified));
      case SortingMethod_ATime<T>():
        return sortable.sort((T a, T b) => _stats[b]!.accessed.compareTo(_stats[a]!.accessed));
      case SortingMethod_Size<T>():
        return sortable.sort((T a, T b) => _stats[b]!.size.compareTo(_stats[a]!.size));
      case SortingMethod_Custom<T>(:final int Function(T a, T b) compare):
        return sortable.sort((T a, T b) => compare(b, a));
    }
  }

  ClassificationStandard get classificationStandard => _classificationStandard;
  void setClassificationStandard(ClassificationStandard standard){
    if(standard == _classificationStandard){
      return;
    }
    _classificationStandard = standard;
    notify();
  }
  Map<DateTime?, List<T>> getClassifiedItems(){
    final Map<DateTime?, List<T>> res = <DateTime, List<T>>{};

    final List<T> unclassifiable = <T>[];
    for(final T item in items){
      final NGFileStat? stat = _stats[item];
      if(stat == null){
        unclassifiable.add(item);
        continue;
      }
      final DateTime itemTime = switch(sortingMethod){
        SortingMethod_CTime<MediaItem>() => stat.changed,
        SortingMethod_MTime<MediaItem>() => stat.modified,
        SortingMethod_ATime<MediaItem>() => stat.accessed,
        _ => throw Exception("当前排序方法不支持分类 $_sortingMethod"),
      };
      final DateTime classTime = switch(classificationStandard){
        ClassificationStandard.year => DateTime(itemTime.year),
        ClassificationStandard.month => DateTime(itemTime.year, itemTime.month),
        ClassificationStandard.day => DateTime(itemTime.year, itemTime.month, itemTime.day),
      };
      (res[classTime] ??= <T>[]).add(item);
    }

    res[null] = unclassifiable;
    return res;
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
      _sortReverse(sortable);
    }else{
      _sort(sortable);
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