import "MultiValueListenableBuilder.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";

// ImageViewerController
class ImageViewerController extends ChangeNotifier {
  _ImageViewerState? _state;

  void _attach(_ImageViewerState state) {
    _state = state;
    notifyListeners();
  }

  bool get isAttach => _state != null;

  int get index => _state!.index;

  void toPreviousImage() {
    _state?._toPreviousImage();
    notifyListeners();
  }

  void toNextImage() {
    _state?._toNextImage();
    notifyListeners();
  }

  void horizontalFlip() {
    _state?._horizontalFlip();
    notifyListeners();
  }

  void verticalFlip() {
    _state?._verticalFlip();
    notifyListeners();
  }

  void rotateRight90() {
    _state?._rotateRight90();
    notifyListeners();
  }

  void rotateLeft90() {
    _state?._rotateLeft90();
    notifyListeners();
  }

  void reset() {
    _state?._reset();
    notifyListeners();
  }
}

class ImageViewer extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final int imageCount;
  final int initIndex;
  final Function(BuildContext, int) imageBuilder;
  final ImageViewerController? controller;

  const ImageViewer({
    super.key,
    this.duration = imageToggleDuration,
    this.curve = animationCurve,
    required this.imageCount,
    required this.initIndex,
    required this.imageBuilder,
    this.controller,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  List<ValueNotifier<Matrix4>> imageMatrix = [];
  List<ValueNotifier<int>> imageRotation = [];
  late final PageController pageController;
  late int index;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initIndex);

    index = widget.initIndex;
    imageMatrix = List.generate(
      widget.imageCount,
      (_) => ValueNotifier<Matrix4>(Matrix4.identity()),
    );
    imageRotation = List.generate(
      widget.imageCount,
      (_) => ValueNotifier<int>(0),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller?._attach(this);
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    for (var matrix in imageMatrix) {
      matrix.dispose();
    }
  }

  /// Switch to the previous page
  _toPreviousImage() {
    if (index > 0) {
      index--;
      pageController.animateToPage(
        index,
        duration: widget.duration,
        curve: Curves.easeInOut,
      );
    }
  }

  /// Switch to the next page
  _toNextImage() {
    if (index < widget.imageCount - 1) {
      index++;
      pageController.animateToPage(
        index,
        duration: widget.duration,
        curve: Curves.easeInOut,
      );
    }
  }

  /// horizontal flip
  _horizontalFlip() {
    final int page = pageController.page?.round() ?? 0;
    imageMatrix[page].value =
        (Matrix4.identity()..scale(-1.0, 1.0, 1.0)) * imageMatrix[page].value;
  }

  /// vertical flip
  _verticalFlip() {
    final int page = pageController.page?.round() ?? 0;
    imageMatrix[page].value =
        (Matrix4.identity()..scale(1.0, -1.0, 1.0)) * imageMatrix[page].value;
  }

  /// Rotate 90 Degrees Clockwise
  _rotateRight90() {
    final int page = pageController.page?.round() ?? 0;
    imageRotation[page].value++;
  }

  /// Rotate 90 Degrees Counter-clockwise
  _rotateLeft90() {
    final int page = pageController.page?.round() ?? 0;
    imageRotation[page].value--;
  }

  _reset() {
    final int page = pageController.page?.round() ?? 0;
    imageMatrix[page].value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: PageView.builder(
        allowImplicitScrolling: true,
        controller: pageController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.imageCount,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            boundaryMargin: EdgeInsets.zero,
            minScale: 1,
            maxScale: 10,
            child: MultiValueListenableBuilder(
              listenables: [imageMatrix[index], imageRotation[index]],
              builder: (BuildContext context, Widget? child) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return RotatedBox(
                      quarterTurns: imageRotation[index].value,
                      child: Transform(
                        transform: imageMatrix[index].value,
                        alignment: Alignment.center,
                        child: widget.imageBuilder(context, index),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
