
part of "../library_controller.dart";


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