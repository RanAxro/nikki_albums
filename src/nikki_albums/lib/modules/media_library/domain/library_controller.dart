
import "item.dart";
import "item_provider.dart";
import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";

import "package:flutter/widgets.dart";
import "dart:collection";

import "package:flutter_hooks/flutter_hooks.dart";



// LibraryController useAlbumController(MediaItemProvider provider){
//   final LibraryController controller = useMemoized(
//     () => LibraryController(provider: provider),
//     [provider],
//   );
//
//   useEffect(() => controller.dispose, [controller]);
//
//   return controller;
// }

class LibraryController<T extends MediaItem> extends ChangeNotifier{
  final MediaItemProvider<T> provider;

  LibraryController({required this.provider}){
    provider.addListener(_onItemChange);
  }

  void _onItemChange(){
    onItemChanged(provider.items.toSet());
  }

  List<T> get items{
    return List.from(getItems(provider.items));
  }

  @protected
  @visibleForTesting
  @mustCallSuper
  Iterable<T> getItems(Iterable<T> rawItems){
    return rawItems;
  }

  @protected
  @visibleForTesting
  @mustCallSuper
  Future<void> onItemChanged(Set<T> newItems) async{

  }

  @protected
  @visibleForTesting
  void notify(){
    notifyListeners();
  }

  @override
  void dispose(){
    provider.removeListener(_onItemChange);
    super.dispose();
  }
}


mixin InitializationMixin<T extends MediaItem> on LibraryController<T>{
  bool _isInit = false;
  double _initProgress = 0;
  bool get isInit => _isInit;
  double get initProgress => _initProgress;

  @protected
  void setProgress(double progress){
    if(_isInit){
      return;
    }
    _initProgress = progress;
    if(_initProgress >= 1){
      _isInit = true;
    }
    notify();
  }
}


mixin SortMixin<T extends MediaItem> on LibraryController<T>{
  bool _reverse = true;
  final Map<T, NGFileStat> _stats = {};

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

    final List<T> sortable = [];
    final List<T> unsortable = [];
    for(final T item in items){
      final NGFileStat? stat = _stats[item];
      if(stat == null){
        unsortable.add(item);
      }else{
        sortable.add(item);
      }
    }

    if(_reverse){
      sortable.sort((a, b) => _stats[b]!.modified.compareTo(_stats[a]!.modified));
    }else{
      sortable.sort((a, b) => _stats[a]!.modified.compareTo(_stats[b]!.modified));
    }
    return sortable..addAll(unsortable);
  }

  @override
  Future<void> onItemChanged(Set<T> newItems) async{
    await super.onItemChanged(newItems);
    _stats.removeWhere((item, stat) => !item.immutable || !newItems.contains(item));
    final int max = newItems.length - 1;
    for(final (int index, T item) in newItems.indexed){
      if(_stats.containsKey(items)){
        continue;
      }
      _stats[item] = await item.stat();

      if(this case InitializationMixin initializationMixin){
        initializationMixin.setProgress(index / max);
      }
    }
    notify();
  }
}


mixin SelectionMixin<T extends MediaItem> on LibraryController<T>{
  final Set<T> _selected = {};
  Set<T> get selected => Set.unmodifiable(_selected);

  int get selectedCount => _selected.length;

  bool isSelected(T item){
    return _selected.contains(item);
  }
  void select(T item){
    if(_selected.add(item)){
      notify();
    }
  }
  void unselect(T item){
    if(_selected.remove(item)){
      notify();
    }
  }
  void toggleSelect(T item){
    if(isSelected(item)){
      unselect(item);
    }else{
      select(item);
    }
  }
  void selectAll(){
    bool changed = false;
    for(final T item in items){
      changed |= _selected.add(item);
    }
    if(changed){
      notify();
    }
  }
  void clearSelection(){
    if(_selected.isEmpty) return;
    _selected.clear();
    notify();
  }

  @override
  Future<void> onItemChanged(Set<T> newItems) async{
    await super.onItemChanged(newItems);
    _selected.removeWhere((item) => !newItems.contains(item));
    notify();
  }
}


/// TODO Tag
mixin TagMixin<T extends MediaItem> on LibraryController<T>{

}


AlbumController useAlbumController(MediaItemProvider provider){
  final AlbumController controller = useMemoized(
    () => AlbumController(provider: provider),
    [provider],
  );

  useEffect(() => controller.dispose, [controller]);

  return controller;
}
class AlbumController<T extends MediaItem> extends LibraryController<T> with InitializationMixin<T>, SortMixin<T>, SelectionMixin<T>{
  new({required super.provider});
}