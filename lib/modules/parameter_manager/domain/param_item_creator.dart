
import "../model/param_type.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/src/rust/nuan5_params/decrypt.dart";
import "package:nikki_albums/src/rust/nuan5_params/decode.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/building_params.dart";

import "package:flutter/foundation.dart";
import "dart:convert";
import "dart:async";

import "package:path/path.dart" as p;


class ParamItemCreator extends ChangeNotifier{
  ParamItemCreator();

  String _paramString = "";
  dynamic _param;
  ParamType _type = ParamType.camera;

  String get paramString => _paramString;
  dynamic get param => _param;
  ParamType get type => _type;

  void setParamString(String newParamString){
    _paramString = newParamString;
  }

  void changeParamString(String newParamString) async{
    if(newParamString == _paramString){
      return;
    }

    _paramString = newParamString;

    tryDeParamDebounce(newParamString, onFinished: (dynamic param){
      _param = param;

      if(_param is CameraParams){
        _type = ParamType.camera;
      }
      if(_param is ClothDiyParams){
        _type = ParamType.cloth;
      }
      if(_param is RichBuildingParams){
        _type = ParamType.home;
      }

      notifyListeners();
    });
  }

  void changeType(ParamType newType) async{
    if(newType == _type){
      return;
    }

    _type = newType;

    switch(newType){
      case ParamType.camera:
        _param = await tryDeCameraParam(_paramString);
        break;
      case ParamType.cloth:
        if(_paramString.length < 2 || _paramString.length >= 64){
          _param = null;
          break;
        }
        _param = await tryDeClothDiyShareCode(_paramString);
        break;
      case ParamType.home:
        if(_paramString.length < 2 || _paramString.length >= 64){
          _param = null;
          break;
        }
        _param = await tryDeHomeBuildShareCode(_paramString);
        break;
    }

    notifyListeners();
  }
}

Future<dynamic> tryDeParam(String param) async{
  if(param.length < 2){
    return null;
  }

  /// Camera Params
  if(param.length >= 64){
    return await tryDeCameraParam(param);
  }
  /// Cloth Diy Share Code
  else if(param.endsWith("#")){
    return await tryDeClothDiyShareCode(param);
  }
  /// Home Build Share Code or Cloth Diy Share Code
  else{
    return await tryDeHomeBuildShareCode(param) ?? await tryDeClothDiyShareCode(param);
  }
}


Timer? _tryDeParamTimer;
void tryDeParamDebounce(String param, {Duration duration = const Duration(milliseconds: 400), void Function(dynamic)? onFinished}){
  _tryDeParamTimer?.cancel();

  if(param.length < 2){
    return onFinished?.call(null);
  }

  /// Camera Params
  if(param.length >= 64){
    tryDeCameraParam(param).then((CameraParams? value) => onFinished?.call(value));
  }else{
    _tryDeParamTimer = Timer(duration, () async{
      /// Cloth Diy Share Code
      if(param.endsWith("#")){
        onFinished?.call(await tryDeClothDiyShareCode(param));
      }
      /// Home Build Share Code or Cloth Diy Share Code
      else{
        onFinished?.call(await tryDeHomeBuildShareCode(param) ?? await tryDeClothDiyShareCode(param));
      }
    });
  }
}

Future<CameraParams?> tryDeCameraParam(String param) async{
  try{
    final MediaKey key = MediaKey.cameraParam();

    final CustomData data = mediaDecrypt(utf8.encode(param), key);
    final MediaCustomData mediaCustomData = await decodeMediaParam(paramType: MediaParamType.cameraParams, data: data);

    return mediaCustomData.whenOrNull(
      valid: (MediaParam mediaParam){
        return mediaParam.whenOrNull(
          cameraParams: (CameraParams cameraParams){
            return cameraParams;
          }
        );
      }
    );
  }catch(e){
    return null;
  }
}

Future<ClothDiyParams?> tryDeClothDiyShareCode(String code) async{
  try{
    final String cachePath = await getClothDiyShareCodeTemp(code);

    final ClothDiyShareCode key = ClothDiyShareCode.fromCodeStr(code);

    final ClothDiyParam? clothDiyParam = await clothDiyDeNetwork(key: key, cachePath: cachePath);

    return clothDiyParam?.whenOrNull(
      clothDiy: (ClothDiyParams clothDiyParams){
        return clothDiyParams;
      },
    );
  }catch(e){
    return null;
  }
}

Future<RichBuildingParams?> tryDeHomeBuildShareCode(String code) async{
  try{
    final String cachePath = await getHomeBuildShareCodeTemp(code);

    final HomeBuildShareCode key = HomeBuildShareCode.fromCodeStr(code);

    final HomeBuildParam? homeBuildParam = await homeBuildDeNetwork(key: key, cachePath: cachePath);

    return homeBuildParam?.whenOrNull(
      netHomeBuild: (RichBuildingParams richBuildingParams){
        return richBuildingParams;
      },
    );
  }catch(e){
    return null;
  }
}


Future<String> getClothDiyShareCodeTemp(String code) async{
  return p.join((await getAppDataDirectoryPath()).path, "temp", "ClothDiyShareCode", code);
}

Future<String> getHomeBuildShareCodeTemp(String code) async{
  return p.join((await getAppDataDirectoryPath()).path, "temp", "HomeBuildShareCode", code);
}