

class ImageData{
  final DateTime time;

  const ImageData({
    required this.time,
  });

  @override
  bool operator ==(Object other) => identical(other, this) || other is ImageData && other.time == time;

  @override
  int get hashCode => time.hashCode;
}