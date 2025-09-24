const _maxBitDepth = 48;

enum ColorModel{
  f,
  i,
  h,
}


/// -------------------------------------------------
/// Channel
/// -------------------------------------------------
class Channel{

  late double _value;  // Channel Value
  late int _bitDepth;  // Bit Depth
  // cache
  late int _cacheMax;  // 2^(Bit Depth) - 1
  late int _cacheValueInt;  // valueFloat * max
  late double _cacheValueAngle;  // valueFloat * 360

  _updateValueCache(){
    _cacheValueInt = (_value * _cacheMax).round().clamp(0, _cacheMax);
    _cacheValueAngle = _value * 360;
  }

  Channel({
    double value = 0,
    int bitDepth = 8,
    ColorModel model = ColorModel.i,
  }){
    _bitDepth = bitDepth.clamp(1, _maxBitDepth);
    _cacheMax = (1 << _bitDepth) - 1;
    switch(model){
      case ColorModel.i:
        _value = value.clamp(0, _cacheMax) / _cacheMax;
        break;
      case ColorModel.f:
        _value = value.clamp(0, 1);
        break;
      case ColorModel.h:
        _value = value.clamp(0, 360) / 360;
        break;
    }
    _updateValueCache();
  }

  double get f{
    return _value;
  }
  int get i{
    return _cacheValueInt;
  }
  double get h{
    return _cacheValueAngle;
  }
  num get(ColorModel model){
    switch(model){
      case ColorModel.i:
        return _cacheValueInt;
      case ColorModel.f:
        return _value;
      case ColorModel.h:
        return _cacheValueAngle;
    }
  }
  int get bitDepth{
    return _bitDepth;
  }

  set f(double v){
    _value = v.clamp(0, 1);
    _updateValueCache();
  }
  set i(int v){
    _value = v.clamp(0, _cacheMax) / _cacheMax;
    _updateValueCache();
  }
  set h(double v){
    _value = v.clamp(0, 360) / 360;
    _updateValueCache();
  }
  set bitDepth(int v){
    _bitDepth = v.clamp(1, _maxBitDepth);
    _cacheMax = (1 << _bitDepth) - 1;
    _updateValueCache();
  }
}


/// -------------------------------------------------
/// ColorSpace
/// -------------------------------------------------
abstract class ColorSpace{
  final List<Channel> channels;

  ColorSpace(this.channels);

  int get bitDepth => channels.first.bitDepth;
  
  set bitDepth(int v){
    for(final channel in channels){
      channel.bitDepth = v;
    }
  }


  @override
  bool operator == (Object other){
    return identical(this, other) || (
      other is ColorSpace &&
      other.channels.length == channels.length &&
      Iterable.generate(channels.length).every((i) => other.channels[i].i == channels[i].i)
    );
  }

  @override
  int get hashCode => Object.hashAllUnordered(
    channels.map((c) => c.i),  // The order is irrelevant.
  );

}


/// -------------------------------------------------
/// RGB
/// -------------------------------------------------
class RGB extends ColorSpace{
  late final Channel R, G, B;

  RGB({
    double R = 0,
    double G = 0,
    double B = 0,
    int bitDepth = 8,
    ColorModel model = ColorModel.i,
  }) : super([]){
    this.R = Channel(value: R, bitDepth: bitDepth, model: model);
    this.G = Channel(value: G, bitDepth: bitDepth, model: model);
    this.B = Channel(value: B, bitDepth: bitDepth, model: model);
    channels.addAll([this.R, this.G, this.B]);
  }

  (num, num, num) get(ColorModel RModel, ColorModel GModel, ColorModel BModel){
    return (R.get(RModel), G.get(GModel), B.get(BModel));
  }

  // HSL get getHSL{
  //   final
  //   final max = list.reduce((a, b) => a > b ? a : b);
  //
  //   return HSL();
  // }


  // static HslColor rgbToHsl(int r, int g, int b) {
  //   double rd = r / 255.0;
  //   double gd = g / 255.0;
  //   double bd = b / 255.0;
  //
  //   final max = math.max(rd, math.max(gd, bd));
  //   final min = math.min(rd, math.min(gd, bd));
  //   final delta = max - min;
  //
  //   double h = 0.0;
  //   double s = 0.0;
  //   final l = (max + min) / 2.0;
  //
  //   if (delta != 0.0) {
  //     s = l > 0.5 ? delta / (2.0 - max - min) : delta / (max + min);
  //
  //     if (max == rd) {
  //       h = (gd - bd) / delta + (gd < bd ? 6 : 0);
  //     } else if (max == gd) {
  //       h = (bd - rd) / delta + 2;
  //     } else {
  //       h = (rd - gd) / delta + 4;
  //     }
  //     h *= 60.0;
  //   }
  //   return HslColor(h, s, l);
  // }



}


/// -------------------------------------------------
/// HSL
/// -------------------------------------------------
class HSL extends ColorSpace{
  late final Channel H, S, L;

  HSL({
    double H = 0,
    double S = 0,
    double L = 0,
    int bitDepth = 8,
    ColorModel model = ColorModel.i,
  }) : super([]){
    this.H = Channel(value: H, bitDepth: bitDepth, model: model);
    this.S = Channel(value: S, bitDepth: bitDepth, model: model);
    this.L = Channel(value: L, bitDepth: bitDepth, model: model);
    channels.addAll([this.H, this.S, this.L]);
  }

  (num, num, num) get(ColorModel HModel, ColorModel SModel, ColorModel LModel){
    return (H.get(HModel), S.get(SModel), L.get(LModel));
  }

}