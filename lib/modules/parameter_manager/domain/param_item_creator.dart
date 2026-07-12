
import "../model/param_type.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/src/rust/nuan5_params/decrypt.dart";
import "package:nikki_albums/src/rust/nuan5_params/decode.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/cloth_diy_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/building_params.dart";

import "package:flutter/foundation.dart";
import "dart:convert";

import "package:path/path.dart" as p;


class ParamItemCreator{
  ParamItemCreator();

  String? _param;
  ParamType? _type;


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
    if(kDebugMode){
      rethrow;
    }

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
    if(kDebugMode){
      rethrow;
    }

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
    if(kDebugMode){
      rethrow;
    }

    return null;
  }
}


Future<String> getClothDiyShareCodeTemp(String code) async{
  return p.join((await getAppDataDirectoryPath()).path, "temp", "ClothDiyShareCode", code);
}

Future<String> getHomeBuildShareCodeTemp(String code) async{
  return p.join((await getAppDataDirectoryPath()).path, "temp", "HomeBuildShareCode", code);
}