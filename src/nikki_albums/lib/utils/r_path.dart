
import "dart:io";

class RPath{
  final String? _drive;
  final List<String> _pathSplit;

  const RPath._(this._drive, this._pathSplit);

  // factory RPath(String source){
  //   return RPath._();
  // }

  static String? normalizePathDrive(String source, [bool isWindows = true]){
    if(isWindows && source.length >= 2 && source[1] == ":"){
      return source[0];
    }

    return null;
  }


  static String get symbol{
    return Platform.pathSeparator;
  }

}