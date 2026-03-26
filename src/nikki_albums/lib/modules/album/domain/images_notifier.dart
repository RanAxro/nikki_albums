
import "../model/image_data.dart";

import "package:flutter/material.dart";



class ImagesNotifier extends ChangeNotifier{
  final List<ImageData> _images;

  ImagesNotifier(List<ImageData> images) : _images = images;

  List<ImageData> get images => List.of(_images);
}












