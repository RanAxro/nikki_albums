import "package:flutter/material.dart";
import "dart:math";

class EditStackController<T> extends ChangeNotifier {
  int? _size;

  EditStackController(T initValue, {int? size}) {
    _stack.add(initValue);
    _size = size;
  }

  List<T> _stack = [];
  T? _edited;
  int _pointer = 0;

  List<T> get stack => List<T>.from(_stack);
  int get pointer => _pointer;
  T get lastSaved => _stack[_pointer];
  T get current => _edited ?? lastSaved;

  void set(T value) {
    _edited = value;
    notifyListeners();
  }

  bool get canSave => _edited != null && _edited != _stack[_pointer];
  void save() {
    if (canSave) {
      if (canRedo) _stack = _stack.sublist(0, _pointer + 1);
      _stack.add(_edited as T);
      _pointer++;
      _edited = null;

      if (_size != null && _stack.length > _size!) {
        _stack.removeAt(0);
        _pointer--;
      }
      notifyListeners();
    }
  }

  bool get canUndo => _pointer > 0;
  void undo() {
    if (canUndo) {
      _pointer--;
      notifyListeners();
    }
  }

  bool get canRedo => _pointer < _stack.length - 1;
  void redo() {
    if (canRedo) {
      _pointer++;
      notifyListeners();
    }
  }

  int? get size => _size;

  set size(int? newSize) {
    if (newSize == _size) return;

    _size = newSize;
    if (newSize != null) {
      final int overflow = _stack.length - newSize;
      if (overflow > 0) {
        for (int i = 0; i < overflow; i++) {
          _stack.removeAt(0);
        }
        _pointer = max(0, _pointer - overflow);
      }
    }

    notifyListeners();
  }

  int get length => _stack.length;

  void reset() {
    _stack = [_stack.first];
    _pointer = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _stack.clear();
  }
}
