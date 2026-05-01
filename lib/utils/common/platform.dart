
import "package:flutter/foundation.dart" as f;
import "dart:io" as io;

// const int inWeb = 1 << 0;
// const int inWindows = 1 << 1;
// const int inLinux = 1 << 2;
// const int inMacOS = 1 << 3;
// const int inAndroid = 1 << 4;
// const int inIOS = 1 << 5;
// const int inFuchsia = 1 << 6;
// const int inOhos = 1 << 7;
// const int inAndroidOrOhos = inAndroid | inOhos;
// const int inAllPlatforms = inWindows | inLinux | inMacOS | inAndroid | inIOS | inFuchsia | inOhos;
//
// extension PlatformBits on int{
//   bool get canRunPlatform{
//     if(kIsWeb) return canRunInWeb;
//     if(Platform.isWindows) return canRunInWindows;
//     if(Platform.isLinux) return canRunInLinux;
//     if(Platform.isMacOS) return canRunInMacOS;
//     if(Platform.isAndroid) return canRunInAndroid;
//     if(Platform.isIOS) return canRunInIOS;
//     if(Platform.isFuchsia) return canRunInFuchsia;
//     return false;
//   }
//
//   bool get canRunInWeb => this & inWeb != 0;
//   bool get canRunInWindows => this & inWindows != 0;
//   bool get canRunInLinux => this & inLinux != 0;
//   bool get canRunInMacOS => this & inMacOS != 0;
//   bool get canRunInAndroid => this & inAndroid != 0;
//   bool get canRunInIOS => this & inIOS != 0;
//   bool get canRunInFuchsia => this & inFuchsia != 0;
//   bool get canRunInOhos => this & inOhos != 0;
//   bool get canRunInAndroidOrOhos => this & inAndroidOrOhos != 0;
//   bool get canRunInAllPlatforms => this & inAllPlatforms != 0;
// }
abstract class PlatformBit{
  static const int webBit = 1 << 0;
  static const int windowsBit = 1 << 1;
  static const int linuxBit = 1 << 2;
  static const int macOsBit = 1 << 3;
  static const int androidBit = 1 << 4;
  static const int iosBit = 1 << 5;
  static const int fuchsiaBit = 1 << 6;
  static const int ohOsBit = 1 << 7;
}

class Platform{

  static const Platform unknown = Platform(0);
  static const Platform web = Platform(PlatformBit.webBit);
  static const Platform windows = Platform(PlatformBit.windowsBit);
  static const Platform linux = Platform(PlatformBit.linuxBit);
  static const Platform macOs = Platform(PlatformBit.macOsBit);
  static const Platform android = Platform(PlatformBit.androidBit);
  static const Platform ios = Platform(PlatformBit.iosBit);
  static const Platform fuchsia = Platform(PlatformBit.fuchsiaBit);
  static const Platform ohOs = Platform(PlatformBit.ohOsBit);
  static const Platform androidOrOhos = Platform(PlatformBit.androidBit | PlatformBit.ohOsBit);
  static const Platform desktop = Platform(PlatformBit.windowsBit | PlatformBit.linuxBit | PlatformBit.macOsBit);
  static const Platform mobile = Platform(PlatformBit.androidBit | PlatformBit.iosBit);
  static const Platform any = Platform(-1);
  static final Platform current = _current();

  static Platform _current(){
    if(f.kIsWeb) return web;
    if(io.Platform.isWindows) return windows;
    if(io.Platform.isLinux) return linux;
    if(io.Platform.isMacOS) return macOs;
    if(io.Platform.isAndroid) return android;
    if(io.Platform.isIOS) return ios;
    if(io.Platform.isFuchsia) return fuchsia;

    return unknown;
  }


  final int bit;

  const Platform(this.bit);

  // factory Platform.multi(Iterable<Platform> args){
  //   return Platform(1);
  // }

  bool canRunIn(Platform platform){
    return bit & platform.bit != 0;
  }

  @override
  int get hashCode => bit.hashCode;

  @override
  bool operator ==(Object other) => identical(other, this) || other is Platform && bit == other.bit;

  Platform operator |(Platform other){
    return Platform(bit | other.bit);
  }

  Platform operator &(Platform other){
    return Platform(bit & other.bit);
  }
}