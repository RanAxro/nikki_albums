
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
  void selectAll(){
    bool changed = false;
    for(final T item in items){
      changed |= _selected.add(item);
    }
    if(changed){
      notify();
    }
  }
  void invertAll(){
    final Set<T> invert = {};
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