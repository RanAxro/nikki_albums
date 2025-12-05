import "dart:math";

import "package:flutter/material.dart";

/// 将 [matrix] 作用在 [rect] 上，返回能包住变换后图形的最小轴对齐矩形。
Rect boundingRectAfterTransform(Rect rect, Matrix4 m){
  final a = m.storage;
  double minX = double.infinity, maxX = -minX;
  double minY = double.infinity, maxY = -minY;

  void ext(double x, double y){
    final double w = a[12] * x + a[13] * y + a[15]; // z=0
    final double inv = 1.0 / w;
    final double tx = (a[0] * x + a[1] * y + a[12]) * inv;
    final double ty = (a[4] * x + a[5] * y + a[13]) * inv;
    minX = min(minX, tx);
    maxX = max(maxX, tx);
    minY = min(minY, ty);
    maxY = max(maxY, ty);
  }

  ext(rect.left,  rect.top);
  ext(rect.right, rect.top);
  ext(rect.right, rect.bottom);
  ext(rect.left,  rect.bottom);

  return Rect.fromLTRB(minX, minY, maxX, maxY);
}

const int _ImageToggleDuration = 300;


// ImageViewerController
class ImageViewerController extends ChangeNotifier{
  late final _ImageViewerState _state;

  void _attach(_ImageViewerState state){
    _state = state;
  }

  int get page{
    return _state._pageController.page?.round() ?? 0;
  }

  void toPreviousImage(){
    _state._toPreviousImage();
    notifyListeners();
  }

  void toNextImage(){
    _state._toNextImage();
    notifyListeners();
  }

  void horizontalFlip(){
    _state._horizontalFlip();
    notifyListeners();
  }

  void verticalFlip(){
    _state._verticalFlip();
    notifyListeners();
  }

  void rotateRight90(){
    _state._rotateRight90();
    notifyListeners();
  }

  void rotateLeft90(){
    _state._rotateLeft90();
    notifyListeners();
  }

  void reset(){
    _state._reset();
    notifyListeners();
  }
}


class ImageViewer extends StatefulWidget{
  late final int _imageCount;
  late final int _initIndex;
  late final Function(BuildContext, int) _imageBuilder;
  late final ImageViewerController? _controller;

  ImageViewer({
    super.key,
    required int imageCount,
    required int initIndex,
    required Function(BuildContext, int) imageBuilder,
    ImageViewerController? controller,
  }){
    _imageCount = imageCount < 0 ? 0 : imageCount;
    _initIndex = initIndex.clamp(0, _imageCount == 0 ? 0 : _imageCount - 1);
    _imageBuilder = imageBuilder;
    _controller = controller;
  }

  @override
  State<ImageViewer> createState() => _ImageViewerState();

}



class _ImageViewerState extends State<ImageViewer>{
  List<ValueNotifier<Matrix4>> _imageMatrix = [];
  late final PageController _pageController;

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: widget._initIndex);
    widget._controller?._attach(this);
    _imageMatrix = List.generate(
      widget._imageCount,
      (_) => ValueNotifier<Matrix4>(Matrix4.identity()),
    );
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
    for(var matrix in _imageMatrix){
      matrix.dispose();
    }
  }


  /// Switch to the previous page
  _toPreviousImage(){
    if(_pageController.page != null && _pageController.page! > 0){
      _pageController.previousPage(
        duration: Duration(milliseconds: _ImageToggleDuration),
        curve: Curves.easeInOut,
      );
    }
  }
  /// Switch to the next page
  _toNextImage(){
    if(_pageController.page != null && _pageController.page! < widget._imageCount - 1){
      _pageController.nextPage(
        duration: Duration(milliseconds: _ImageToggleDuration),
        curve: Curves.easeInOut,
      );
    }
  }
  /// horizontal flip
  _horizontalFlip(){
    final int page = _pageController.page?.round() ?? 0;
    _imageMatrix[page].value = (Matrix4.identity()..scale(-1.0, 1.0, 1.0)) * _imageMatrix[page].value;
  }
  /// vertical flip
  _verticalFlip(){
    final int page = _pageController.page?.round() ?? 0;
    _imageMatrix[page].value = (Matrix4.identity()..scale(1.0, -1.0, 1.0)) * _imageMatrix[page].value;
  }
  /// Rotate 90 Degrees Clockwise
  _rotateRight90(){
    final int page = _pageController.page?.round() ?? 0;
    _imageMatrix[page].value = (Matrix4.identity()..rotateZ(pi / 2)) * _imageMatrix[page].value;
  }
  /// Rotate 90 Degrees Counter-clockwise
  _rotateLeft90(){
    final int page = _pageController.page?.round() ?? 0;
    _imageMatrix[page].value = (Matrix4.identity()..rotateZ(-pi / 2)) * _imageMatrix[page].value;
  }
  _reset(){
    final int page = _pageController.page?.round() ?? 0;
    _imageMatrix[page].value = Matrix4.identity();
  }


  @override
  Widget build(BuildContext context){
    return SizedBox.expand(
      child: PageView.builder(
        allowImplicitScrolling: true,
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget._imageCount,
        itemBuilder: (context, index){
          return InteractiveViewer(
            boundaryMargin: EdgeInsets.zero,
            minScale: 1,
            maxScale: 10,
            child: ValueListenableBuilder<Matrix4>(
              valueListenable: _imageMatrix[index],
              builder: (BuildContext context, Matrix4 matrix4, Widget? child){
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    final Rect childRect = boundingRectAfterTransform(Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxHeight), matrix4);
                    final scale = min(constraints.maxWidth / childRect.width, constraints.maxHeight / childRect.height);
                    return Transform(
                      transform: (Matrix4.identity()..scale(scale)) * matrix4,
                      alignment: Alignment.center,
                      child: widget._imageBuilder(context, index),
                    );
                  },
                );
              },
            )
          );
        },
      ),
    );
  }
}