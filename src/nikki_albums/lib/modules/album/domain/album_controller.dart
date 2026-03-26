


import "package:nikkialbums/widgets/common/component.dart";

import "album_extended_data.dart";
import "../model/classification_standard.dart";
import "../model/image_data.dart";
import "images_notifier.dart";

import "package:flutter/material.dart";

class AlbumController extends ChangeNotifier{
  final ImagesNotifier notifier;
  ClassificationStandard _standard;
  bool _reverse;
  bool Function(ImageData, [AlbumExtendedData])? _filtration;
  final AlbumExtendedData defaultExtendedData;
  final Map<ImageData, AlbumExtendedData> _extended;

  AlbumController({
    required this.notifier,
    ClassificationStandard standard = ClassificationStandard.day,
    bool reverse = true,
    bool Function(ImageData, [AlbumExtendedData?])? filtration,
    this.defaultExtendedData = const AlbumExtendedData(),
    Map<ImageData, AlbumExtendedData> extended = const {},
  }) :
    _standard = standard,
    _reverse = reverse,
    _filtration = filtration,
    _extended = Map.of(extended)
  {
    notifier.addListener(_update);
  }


  List<ImageData> _sorted = [];

  final Map<DateTime, List<ImageData>> _processed = {};

  void _update(){
    final List<ImageData> source = notifier.images;

    _extended.removeWhere((ImageData data, AlbumExtendedData value) => !source.contains(data));

    // _sorted = _filtration != null ? source.where((ImageData data) => _filtration!.call(data, extendedOf(data))).toList() : List.of(source);
    _sorted = source.where((ImageData data) => _filtration?.call(data, extendedOf(data)) ?? false).toList();

    _sorted.sort((a, b) => _reverse ? b.time.compareTo(a.time) : a.time.compareTo(b.time));

    _processed.clear();

    for(final image in _sorted){
      final DateTime key = _truncateToStandard(image.time);

      (_processed[key] ??= []).add(image);
    }

    notifyListeners();
  }

  DateTime _truncateToStandard(DateTime time){
    switch(_standard){
      case ClassificationStandard.year:
        return DateTime(time.year);
      case ClassificationStandard.month:
        return DateTime(time.year, time.month);
      case ClassificationStandard.day:
        return DateTime(time.year, time.month, time.day);
      case ClassificationStandard.hour:
        return DateTime(time.year, time.month, time.day, time.hour);
      case ClassificationStandard.minute:
        return DateTime(time.year, time.month, time.day, time.hour, time.minute);
      case ClassificationStandard.second:
        return DateTime(time.year, time.month, time.day, time.hour, time.minute, time.second);
    }
  }

  List<ImageData> get images => notifier.images;

  List<ImageData> get sorted => List.of(_sorted);

  Map<DateTime, List<ImageData>> get processed{
    return _processed.map((DateTime time, List<ImageData> images) => MapEntry(time, List.of(images)));
  }

  ClassificationStandard get standard => _standard;
  set standard(ClassificationStandard arg){
    if(arg == _standard) return;

    _standard = arg;
    _update();
  }

  bool get reverse => _reverse;
  set reverse(bool arg){
    if(arg == _reverse) return;

    _reverse = arg;
    _update();
  }

  bool Function(ImageData, [AlbumExtendedData])? get filtration => _filtration;
  set filtration(bool Function(ImageData, [AlbumExtendedData])? arg){
    if(arg == _filtration) return;

    _filtration = arg;
    _update();
  }


  final DetailNotifier<ImageData> onExtendedChanged = DetailNotifier<ImageData>();

  AlbumExtendedData extendedOf(ImageData data){
    return _extended[data] ?? defaultExtendedData;
  }

  void setExtended(ImageData data, {AlbumExtendedData? value}){
    if(extendedOf(data) == (value ?? defaultExtendedData)) return;

    _extended[data] = value ?? defaultExtendedData;
    onExtendedChanged.notify(data);
  }


  @override
  void dispose(){
    notifier.removeListener(_update);
    super.dispose();
  }
}