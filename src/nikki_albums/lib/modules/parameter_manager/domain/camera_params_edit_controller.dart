
import "package:nikki_albums/src/rust/nuan5_params/encode.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/nikki_photo_params.dart";

import "package:flutter/material.dart";


const CameraParams defaultCameraParams = CameraParams(
  cameraActorLoc: (0.0, -449.91, 246.18),
  cameraActorRot: (90.0, -12.14, 0.0),
  cameraComponentLoc: (0.0, -449.91, 246.18),
  cameraComponentRot: (90.0, -18.0, 0.0),
  portraitMode: false,
  cameraFocalLength: 0.12,
  apertureSection: 15,
  vignetteIntensity: 0.4,
  bloomIntensity: 0.125,
  bloomThreshold: -0.18,
  brightness: 0.5833333333333334,
  exposure: 0.0,
  contrast: 0.31034482758620685,
  saturation: -0.55,
  vibrance: 0.0,
  highlights: -0.35,
  shadows: -0.17,
  light: LightParams.none(),
  filter: FilterParams.none(),
  momo: null,
);

const CameraParamsMomoHidden defaultCameraParamsMomo = CameraParamsMomoHidden.disable(
  momoPose: 0,
  horizontal: 100,
  distance: 100,
  height: 0,
  rotateMomo: 0,
  autoGroundSnap: true,
  floatingEffect: true,
  poseWithNikki: true,
);


extension CameraParamsCopyWith on CameraParams{
  CameraParams copyWith({
    (double, double, double)? cameraActorLoc,
    (double, double, double)? cameraActorRot,
    (double, double, double)? cameraComponentLoc,
    (double, double, double)? cameraComponentRot,
    bool? portraitMode,
    double? cameraFocalLength,
    int? apertureSection,
    double? vignetteIntensity,
    double? bloomIntensity,
    double? bloomThreshold,
    double? brightness,
    double? exposure,
    double? contrast,
    double? saturation,
    double? vibrance,
    double? highlights,
    double? shadows,
    LightParams? light,
    FilterParams? filter,
  }){
    return CameraParams(
      cameraActorLoc: cameraActorLoc ?? this.cameraActorLoc,
      cameraActorRot: cameraActorRot ?? this.cameraActorRot,
      cameraComponentLoc: cameraComponentLoc ?? this.cameraComponentLoc,
      cameraComponentRot: cameraComponentRot ?? this.cameraComponentRot,
      portraitMode: portraitMode ?? this.portraitMode,
      cameraFocalLength: cameraFocalLength ?? this.cameraFocalLength,
      apertureSection: apertureSection ?? this.apertureSection,
      vignetteIntensity: vignetteIntensity ?? this.vignetteIntensity,
      bloomIntensity: bloomIntensity ?? this.bloomIntensity,
      bloomThreshold: bloomThreshold ?? this.bloomThreshold,
      brightness: brightness ?? this.brightness,
      exposure: exposure ?? this.exposure,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      vibrance: vibrance ?? this.vibrance,
      highlights: highlights ?? this.highlights,
      shadows: shadows ?? this.shadows,
      light: light ?? this.light,
      filter: filter ?? this.filter,
      momo: momo,
    );
  }

  CameraParams copyWithMomo({
    required CameraParamsMomoHidden? momo,
  }){
    return CameraParams(
      cameraActorLoc: cameraActorLoc,
      cameraActorRot: cameraActorRot,
      cameraComponentLoc: cameraComponentLoc,
      cameraComponentRot: cameraComponentRot,
      portraitMode: portraitMode,
      cameraFocalLength: cameraFocalLength,
      apertureSection: apertureSection,
      vignetteIntensity: vignetteIntensity,
      bloomIntensity: bloomIntensity,
      bloomThreshold: bloomThreshold,
      brightness: brightness,
      exposure: exposure,
      contrast: contrast,
      saturation: saturation,
      vibrance: vibrance,
      highlights: highlights,
      shadows: shadows,
      light: light,
      filter: filter,
      momo: momo,
    );
  }
}

extension CameraParamsMomoHiddenCopyWith on CameraParamsMomoHidden{
  CameraParamsMomoHidden copyWithDisable({
    int? momoPose,
    double? horizontal,
    double? distance,
    double? height,
    double? rotateMomo,
    bool? autoGroundSnap,
    bool? floatingEffect,
    bool? poseWithNikki,
  }){
    return when(
      enable: () => CameraParamsMomoHidden.enable(),
      disable: (
        thisMomoPose,
        thisHorizontal,
        thisDistance,
        thisHeight,
        thisRotateMomo,
        thisAutoGroundSnap,
        thisFloatingEffect,
        thisPoseWithNikki,
      ){
        return CameraParamsMomoHidden.disable(
          momoPose: momoPose ?? thisMomoPose,
          horizontal: horizontal ?? thisHorizontal,
          distance: distance ?? thisDistance,
          height: height ?? thisHeight,
          rotateMomo: rotateMomo ?? thisRotateMomo,
          autoGroundSnap: autoGroundSnap ?? thisAutoGroundSnap,
          floatingEffect: floatingEffect ?? thisFloatingEffect,
          poseWithNikki: poseWithNikki ?? thisPoseWithNikki,
        );
      },
    );
  }
}


class CameraParamsEditController extends ChangeNotifier{
  String? _cameraParamString;
  CameraParams _cameraParams;
  bool _allowEdit;

  CameraParamsEditController({
    String? cameraParamString,
    CameraParams cameraParams = defaultCameraParams,
    bool allowEdit = true,
  }) :
    _cameraParamString = cameraParamString,
    _cameraParams = cameraParams,
    _allowEdit = allowEdit
  {
    if(cameraParamString == null){
      generateCameraParamString();
    }
  }

  Future<void> generateCameraParamString({void Function()? onError}) async{
    try{
      _cameraParamString = await encodeCameraParams(cameraParams: _cameraParams);
    }catch(e){
      onError?.call();
      _cameraParamString = null;
    }
    
    notifyListeners();
  }

  String? get cameraParamString => _cameraParamString;
  CameraParams get cameraParams => _cameraParams;
  bool get allowEdit => _allowEdit;

  set cameraParams(CameraParams newCameraParams){
    if(newCameraParams == _cameraParams){
      return;
    }

    _cameraParams = newCameraParams;
    generateCameraParamString();
  }

  set allowEdit(bool newValue){
    if(newValue == _allowEdit){
      return;
    }

    _allowEdit = newValue;
    notifyListeners();
  }
}