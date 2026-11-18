
import "item.dart";
import "item_provider.dart";

import "package:flutter/widgets.dart";
import "dart:collection";

import "package:flutter_hooks/flutter_hooks.dart";



class AlbumController extends ChangeNotifier{
  final AlbumItemProvider provider;

  AlbumController({required this.provider}){
    provider.addListener(_onItemChange);
  }

  Future<void> _onItemChange() async{
    await _sortByItemsMTime();
    _notify();
  }

  /// items
  List<AlbumItem> _items = [];
  List<AlbumItem> get items{
    final Iterable<AlbumItem> raw = reverse ? _items.reversed : List.from(_items);

    return raw.toList();
  }

  /// 正序或倒序
  bool _reverse = true;
  bool get reverse => _reverse;
  void setReverse(bool reverse){
    if(reverse == _reverse){
      return;
    }
    _reverse = reverse;
    _notify();
  }
  void toggleReverse(){
    setReverse(!_reverse);
  }

  /// 排序
  final Map<AlbumItem, DateTime> _itemsMTimeCache = {};
  Future<void> _sortByItemsMTime() async{
    final SplayTreeMap<DateTime, AlbumItem> sortedItems = SplayTreeMap();
    for(final AlbumItem item in provider.items){
      DateTime? mTime;
      if(item.immutable){
        mTime = _itemsMTimeCache[item];
      }
      mTime ??= await item.stat().then((s) => s.modified);
      sortedItems[mTime!] = item;
    }
    _items = sortedItems.values.toList();
  }

  /// item 选中状态
  final Set<AlbumItem> _selectedItem = {};
  Set<AlbumItem> get selectedItem => Set.unmodifiable(_selectedItem);
  bool isSelect(AlbumItem item){
    return _selectedItem.contains(item);
  }
  void select(AlbumItem item){
    if(_selectedItem.add(item)){
      _notify();
    }
  }
  void unselect(AlbumItem item){
    if(_selectedItem.remove(item)){
      _notify();
    }
  }
  void toggleSelect(AlbumItem item){
    if(isSelect(item)){
      unselect(item);
    }else{
      select(item);
    }
  }

  /// tag


  void _notify(){
    final Set<AlbumItem> items = _items.toSet();
    _itemsMTimeCache.removeWhere((item, _) => !items.contains(item));
    _selectedItem.removeWhere((item) => !items.contains(item));
    notifyListeners();
  }

  @override
  void dispose(){
    provider.removeListener(_onItemChange);
    super.dispose();
  }
}


AlbumController useAlbumController(AlbumItemProvider provider){
  final AlbumController controller = useMemoized(
    () => AlbumController(provider: provider),
    [provider],
  );

  useEffect(() => controller.dispose, [controller]);

  return controller;
}
