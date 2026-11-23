
part of "../library_controller.dart";


mixin SelectionMixin<T extends MediaItem> on LibraryController<T>{
  Set<T> _selected = <T>{};
  Set<T> get selected => Set<T>.unmodifiable(_selected);
  /// Stream 每次流出选中状态发生改变的所有 item 集合
  /// 不要调用 notify, 大量Widget重建会造成严重卡顿
  /// 不要使用 StreamController`<`T`>`, 当流出大量事件时会造成卡顿
  final StreamController<Set<T>> _selectionEventStreamController = StreamController<Set<T>>.broadcast();

  int get selectedCount => _selected.length;
  Stream<Set<T>> get selectionEventStream => _selectionEventStreamController.stream;

  bool isSelected(T item){
    return _selected.contains(item);
  }
  void select(T item){
    if(_selected.add(item)){
      _selectionEventStreamController.add(<T>{item});
    }
  }
  void unselect(T item){
    if(_selected.remove(item)){
      _selectionEventStreamController.add(<T>{item});
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
    final Set<T> event = <T>{};
    for(final T item in items){
      if(_selected.add(item)){
        event.add(item);
      }
    }
    if(event.isNotEmpty){
      _selectionEventStreamController.add(event);
    }
  }
  void invertMulti(Iterable<T> items){
    final Set<T> event = <T>{};
    for(final T item in items){
      if(!_selected.add(item)){
        _selected.remove(item);
      }
      event.add(item);
    }
    _selectionEventStreamController.add(event);
  }
  void unselectMulti(Iterable<T> items){
    final Set<T> event = <T>{};
    for(final T item in items){
      if(_selected.remove(item)){
        event.add(item);
      }
    }
    _selectionEventStreamController.add(event);
  }
  void selectAll(){
    selectMulti(items);
  }
  void invertAll(){
    final Set<T> invert = <T>{};
    final Set<T> event = <T>{};
    for(final T item in items){
      if(!_selected.contains(item)){
        invert.add(item);
      }
      event.add(item);
    }
    _selected = invert;
    _selectionEventStreamController.add(event);
  }
  void unselectAll(){
    final Set<T> event = _selected;
    _selected = <T>{};
    _selectionEventStreamController.add(event);
  }

  @override
  Future<void> onItemChanged(Set<T> newItems) async{
    await super.onItemChanged(newItems);
    _selected.removeWhere((T item) => !newItems.contains(item));
    notify();
  }

  @override
  void dispose(){
    _selectionEventStreamController.close();
    super.dispose();
  }
}