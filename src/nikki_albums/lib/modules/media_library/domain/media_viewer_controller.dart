
import "library_controller.dart";
import "../domain/item.dart";

import "package:flutter/widgets.dart";
import "dart:math";

import "package:flutter_hooks/flutter_hooks.dart";


MediaViewerController<T> useMediaViewerController<T extends MediaItem>({
  required LibraryController<T> libraryController,
  T? initItem,
  int initIndex = -1,
}){
  final MediaViewerController<T> controller = useMemoized(
    () => MediaViewerController<T>(libraryController: libraryController, initItem: initItem, initIndex: initIndex),
    <Object?>[libraryController, initItem, initIndex],
  );

  useEffect(() => controller.dispose, <Object?>[controller]);

  return controller;
}

class MediaViewerController<T extends MediaItem> extends ChangeNotifier{
  final LibraryController<T> libraryController;

  MediaViewerController({required this.libraryController, T? initItem, int initIndex = -1})
    : _items = libraryController.items,
      _currentItem = initItem,
      _currentIndex = initIndex
  {
    _onItemChange();
    libraryController.addListener(_onItemChange);
  }

  bool _isInit = false;
  List<T> _items;
  T? _currentItem;
  int _currentIndex;

  T? get currentItem => _currentItem;
  int get currentIndex => _currentIndex;

  void previous([bool loop = false]){
    if(loop){
      _currentIndex = (_currentIndex - 1) % _items.length;
    }else{
      _currentIndex = max(_currentIndex - 1, 0);
    }
    _currentItem = _items[_currentIndex];
    notifyListeners();
  }

  void next([bool loop = false]){
    if(loop){
      _currentIndex = (_currentIndex + 1) % _items.length;
    }else{
      _currentIndex = min(_currentIndex + 1, _items.length - 1);
    }
    _currentItem = _items[_currentIndex];
    notifyListeners();
  }

  void _onProviderInit(){
    _isInit = true;
    if(_items.isEmpty){
      _currentIndex = -1;
      _currentItem = null;
      return notifyListeners();
    }

    /// 判断 initItem 合法
    if(_currentItem != null){
      final int index = _items.indexOf(_currentItem!);
      if(index != -1){
        _currentIndex = index;
        return notifyListeners();
      }
    }
    /// 判断 initIndex 合法
    if(_currentIndex >= 0 && _currentIndex < _items.length){
      _currentItem = _items[_currentIndex];
      return notifyListeners();
    }
    /// 默认使用第一个 item
    _currentItem = _items.first;
    _currentIndex = 0;
    return notifyListeners();
  }

  void _onItemChange(){
    _items = libraryController.items;

    /// provider 未初始化
    if(!_isInit && !libraryController.provider.isInit){
      return;
    }
    /// provider 初始化完成
    if(!_isInit && libraryController.provider.isInit){
      return _onProviderInit();
    }

    /// provider 为空时, 置空 item 和 index
    if(_items.isEmpty){
      if(_currentItem == null){
        return;
      }
      _currentItem = null;
      _currentIndex = -1;
      return notifyListeners();
    }

    /// item 和 index 关系未发生变化
    if(_items[_currentIndex] == _currentItem){
      return;
    }

    /// old item 为空时, 自动选中第一个 new item
    if(_currentItem == null){
      _currentItem = _items.first;
      _currentIndex = 0;
      return notifyListeners();
    }

    /// 根据 old item 寻找到新的 index
    final int newIndex = _items.indexOf(_currentItem!);
    if(newIndex != -1){
      _currentIndex = newIndex;
    }
    /// old item 已不存在于 new items
    else{
      /// 寻找 old index 对应的 new item
      if(_currentIndex < _items.length){
        _currentItem = _items[_currentIndex];
      }
      /// old index 超出 new items 的范围, 回调到第一个 new item
      else{
        _currentItem = _items.first;
        _currentIndex = 0;
      }
    }
    notifyListeners();
  }

  @override
  void dispose(){
    libraryController.removeListener(_onItemChange);
    super.dispose();
  }
}