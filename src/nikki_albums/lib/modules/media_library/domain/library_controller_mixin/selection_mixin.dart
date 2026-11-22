
part of "../library_controller.dart";


mixin SelectionMixin<T extends MediaItem> on LibraryController<T>{
  Set<T> _selected = <T>{};
  Set<T> get selected => Set<T>.unmodifiable(_selected);

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
  void invert(T item){
    if(isSelected(item)){
      unselect(item);
    }else{
      select(item);
    }
  }
  void selectMulti(Iterable<T> items){
    final int oldLength = _selected.length;
    _selected.addAll(items);
    if(oldLength != _selected.length){
      notify();
    }
  }
  void invertMulti(Iterable<T> items){
    for(final T item in items){
      if(!_selected.add(item)){
        _selected.remove(item);
      }
    }
    notify();
  }
  void unselectMulti(Iterable<T> items){
    final int oldLength = _selected.length;
    _selected.removeAll(items);
    if(oldLength != _selected.length){
      notify();
    }
  }
  void selectAll(){
    final int oldLength = _selected.length;
    _selected.addAll(items);
    if(oldLength != _selected.length){
      notify();
    }
  }
  void invertAll(){
    final Set<T> invert = <T>{};
    for(final T item in items){
      if(!_selected.contains(item)){
        invert.add(item);
      }
    }
    _selected = invert;
    notify();
  }
  void unselectAll(){
    if(_selected.isEmpty){
      return;
    }
    _selected.clear();
    notify();
  }

  @override
  Future<void> onItemChanged(Set<T> newItems) async{
    await super.onItemChanged(newItems);
    _selected.removeWhere((T item) => !newItems.contains(item));
    notify();
  }
}