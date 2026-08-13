export "package:nikki_albums/utils/common/platform.dart";

import "package:nikki_albums/utils/common/platform.dart";


class InfinityNikkiPlatform extends Platform{
  static const Platform windows = Platform.windows;
  static const Platform macOS = Platform.macOs;
  static const Platform android = Platform.android;
  static const Platform ios = Platform.ios;
  static const Platform desktop = Platform(PlatformBit.windowsBit | PlatformBit.macOsBit);
  static const Platform mobile = Platform(PlatformBit.androidBit | PlatformBit.iosBit);
  static const Platform any = Platform(PlatformBit.windowsBit | PlatformBit.macOsBit | PlatformBit.androidBit | PlatformBit.iosBit);

  const InfinityNikkiPlatform(super.bit);
}


extension InfinityNikkiPlatformExt on Platform{
  bool get canRunInfinityNikki{
    return canRunIn(InfinityNikkiPlatform.any);
  }
}