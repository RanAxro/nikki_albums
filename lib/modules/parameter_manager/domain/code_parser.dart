
import "package:nikki_albums/modules/parameter_manager/model/param_type.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/src/rust/nuan5_params/decrypt.dart";
import "package:nikki_albums/src/rust/nuan5_params/decode.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/building_params.dart";

import "dart:convert";
import "dart:async";

import "package:path/path.dart" as p;


Future<dynamic> tryDeCode(String code) async{
  if(code.length < 2){
    return null;
  }

  /// Camera Parameter
  if(code.length >= 64){
    return await tryDeCameraParameter(code);
  }
  /// Cloth Diy Share Code
  else if(code.endsWith("#")){
    return await tryDeClothDiyShareCode(code);
  }
  /// Home Build Share Code or Cloth Diy Share Code
  else{
    return await tryDeHomeBuildShareCode(code) ?? await tryDeClothDiyShareCode(code);
  }
}


Timer? _tryDeCodeTimer;
void tryDeCodeDebounce(String code, {Duration duration = const Duration(milliseconds: 400), void Function(dynamic)? onFinished}){
  _tryDeCodeTimer?.cancel();

  if(code.length < 2){
    return onFinished?.call(null);
  }

  /// Camera Parameter
  if(code.length >= 64){
    tryDeCameraParameter(code).then((CameraParams? value) => onFinished?.call(value));
  }else{
    _tryDeCodeTimer = Timer(duration, () async{
      /// Cloth Diy Share Code
      if(code.endsWith("#")){
        onFinished?.call(await tryDeClothDiyShareCode(code));
      }
      /// Home Build Share Code or Cloth Diy Share Code
      else{
        onFinished?.call(await tryDeHomeBuildShareCode(code) ?? await tryDeClothDiyShareCode(code));
      }
    });
  }
}

Future<CameraParams?> tryDeCameraParameter(String code) async{
  if(code.length < 64){
    return null;
  }

  try{
    final MediaKey key = MediaKey.cameraParam();

    final CustomData data = mediaDecrypt(utf8.encode(code), key);
    final MediaCustomData mediaCustomData = await decodeMediaParam(paramType: MediaParamType.cameraParams, data: data);

    return mediaCustomData.whenOrNull(
      valid: (MediaParam mediaParam){
        return mediaParam.whenOrNull(
          cameraParams: (CameraParams cameraParams){
            return cameraParams;
          },
        );
      },
    );
  }catch(e){
    return null;
  }
}

Future<ClothDiyParams?> tryDeClothDiyShareCode(String code) async{
  if(code.length < 2 || code.length > 30){
    return null;
  }

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
  if(code.length < 2 || code.length > 30){
    return null;
  }

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


Future<dynamic> tryDeByType(ParamType type, String code) async{
  return switch(type){
    ParamType.camera => tryDeCameraParameter(code),
    ParamType.cloth => tryDeClothDiyShareCode(code),
    ParamType.home => tryDeHomeBuildShareCode(code),
  };
}

bool isValidParam(dynamic param){
  if(param is CameraParams || param is ClothDiyParams || param is RichBuildingParams){
    return true;
  }
  return false;
}

ParamType? getTypeByParam(dynamic param){
  if(param is CameraParams){
    return ParamType.camera;
  }
  if(param is ClothDiyParams){
    return ParamType.cloth;
  }
  if(param is RichBuildingParams){
    return ParamType.home;
  }
  return null;
}


Future<String> getClothDiyShareCodeTemp(String code) async{
  return p.join((await getTempPath()).path, "ClothDiyShareCode", code);
}

Future<String> getHomeBuildShareCodeTemp(String code) async{
  return p.join((await getTempPath()).path, "HomeBuildShareCode", code);
}