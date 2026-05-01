import "package:nikki_albums/widgets/common/component.dart";

import "cropping.dart";
import "fragment.dart";

import "package:flutter/material.dart";
import "dart:ui" as ui;

enum ImageEditPlate { cropping, colorTuning }

class ImageEditParams {
  static final defaultParams = ImageEditParams(
    cropping: ImageCroppingParams.defaultParams,
    fragment: ImageFragmentParams.defaultParams,
  );

  final ImageCroppingParams cropping;
  final ImageFragmentParams fragment;

  const ImageEditParams({required this.cropping, required this.fragment});

  ImageEditParams withCropping(ImageCroppingParams cropping) {
    return ImageEditParams(cropping: cropping, fragment: fragment);
  }

  ImageEditParams withFragment(ImageFragmentParams fragment) {
    return ImageEditParams(cropping: cropping, fragment: fragment);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ImageEditParams &&
            other.cropping == cropping &&
            other.fragment == fragment;
  }

  @override
  int get hashCode => Object.hashAll([cropping, fragment]);
}

class ImageEditorController extends ChangeNotifier
    implements EditStackController<ImageEditParams> {
  ImageEditPlate _plate;
  final EditStackController<ImageEditParams> _stack;

  ImageEditorController({
    required ImageEditPlate initPlate,
    ImageEditParams? initParams,
  }) : _plate = initPlate,
       _stack = EditStackController<ImageEditParams>(
         initParams ?? ImageEditParams.defaultParams,
       );

  final Notifier onPlateUpdate = Notifier();
  final Notifier onCroppingUpdate = Notifier();
  final Notifier onFragmentUpdate = Notifier();

  @override
  int? get size => _stack.size;

  @override
  set size(int? newSize) {
    _stack.size = newSize;
  }

  @override
  bool get canRedo => _stack.canRedo;

  @override
  bool get canSave => _stack.canSave;

  @override
  bool get canUndo => _stack.canUndo;

  @override
  get current => _stack.current;

  @override
  get lastSaved => _stack.lastSaved;

  @override
  int get length => _stack.length;

  @override
  int get pointer => _stack.pointer;

  @override
  List<ImageEditParams> get stack => _stack.stack;

  @override
  void undo() {
    final ImageEditParams oldParams = current;

    _stack.undo();

    _notifyDifference(oldParams, current);
    notifyListeners();
  }

  @override
  void redo() {
    final ImageEditParams oldParams = current;

    _stack.redo();

    _notifyDifference(oldParams, current);
    notifyListeners();
  }

  @override
  void reset() {
    final ImageEditParams oldParams = current;

    _stack.reset();

    _notifyDifference(oldParams, current);
    notifyListeners();
  }

  @override
  void save() => _stack.save();

  @override
  void set(ImageEditParams params) {
    final ImageEditParams oldParams = current;

    _stack.set(params);

    _notifyDifference(oldParams, params);
    notifyListeners();
  }

  void setCropping(ImageCroppingParams params) {
    if (params == current.cropping) return;

    _stack.set(current.withCropping(params));
    onCroppingUpdate.notify();
    notifyListeners();
  }

  void setFragment(ImageFragmentParams params) {
    if (params == current.fragment) return;

    _stack.set(current.withFragment(params));
    onFragmentUpdate.notify();
    notifyListeners();
  }

  void _notifyDifference(ImageEditParams params1, ImageEditParams params2) {
    if (params1.cropping != params2.cropping) {
      onCroppingUpdate.notify();
    }
    if (params1.fragment != params2.fragment) {
      onFragmentUpdate.notify();
    }
  }

  ImageEditPlate get plate => _plate;

  set plate(ImageEditPlate p) {
    _plate = p;
    onPlateUpdate.notify();
    notifyListeners();
  }

  @override
  void dispose() {
    _stack.dispose();
    onPlateUpdate.dispose();
    onCroppingUpdate.dispose();
    onFragmentUpdate.dispose();
    super.dispose();
  }
}

class ImageEditHandler {
  final ui.Image image;

  const ImageEditHandler({required this.image});

  Future<ui.Image> handle(ImageEditParams params) async {
    final ImageFragmentHandler fragmentHandler = ImageFragmentHandler(
      image: image,
    );

    final ui.Image fragmentImage = await fragmentHandler.handle(
      params.fragment,
    );

    final ImageCroppingHandler croppingHandler = ImageCroppingHandler(
      image: fragmentImage,
    );

    final ui.Image croppingImage = await croppingHandler.handle(
      params.cropping,
    );

    fragmentImage.dispose();
    return croppingImage;
  }
}
