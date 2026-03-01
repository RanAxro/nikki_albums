export "map.dart";
import "map.dart";
import "dart:math";
import "package:nikkialbums/game/codec.dart";








enum SpecialData{
  locateOnMap,
  allowCopy,
  color,
}

class Field<K, V>{
  final bool visible;
  final String? keyIcon;
  final K? key;
  final String? _stringKey;
  final SpecialData? specialKey;
  final bool isTranslateKey;
  final List<String>? keyArgs;
  final String? valueIcon;
  final V? value;
  final String? _stringValue;
  final SpecialData? specialValue;
  final bool isTranslateValue;
  final List<String>? valueArgs;
  final List<Field> children;
  final bool expand;

  const Field({
    this.visible = true,
    this.keyIcon,
    this.key,
    String? stringKey,
    this.specialKey,
    this.isTranslateKey = true,
    this.keyArgs,
    this.valueIcon,
    this.value,
    String? stringValue,
    this.specialValue,
    this.isTranslateValue = false,
    this.valueArgs,
    this.children = const <Field>[],
    this.expand = false,
  }) :
    _stringKey = stringKey,
    _stringValue = stringValue;

  String get stringKey => _stringKey ?? key.toString();

  String get stringValue => _stringValue ?? value.toString();
}

class Rot extends Field<String, num>{
  const Rot({
    super.key = "ia_rot",
    required num rot,
    super.stringValue,
    super.specialValue,
  }) :
    super(value: rot);
}

class Rot3 extends Field<String, (num, num, num)>{
  const Rot3({
    super.key = "ia_rot3",
    required num yaw,
    required num pitch,
    required num roll,
    String? stringValue,
    super.specialValue,
  }) :
    super(
      value: (yaw, pitch, roll),
      stringValue: stringValue ?? "($yaw, $pitch, $roll)",
    );
}

class Loc2 extends Field<String, (num, num)>{
  const Loc2({
    super.key = "ia_loc2",
    required num x,
    required num y,
    String? stringValue,
    super.specialValue,
  }) :
    super(
      value: (x, y),
      stringValue: stringValue ?? "($x, $y)",
    );
}

class Loc3 extends Field<String, (num, num, num)>{
  const Loc3({
    super.key = "ia_loc3",
    required num x,
    required num y,
    required num z,
    String? stringValue,
    super.specialValue,
  }) :
    super(
      value: (x, y, z),
      stringValue: stringValue ?? "($x, $y, $z)",
    );
}

class Scale extends Field<String, num>{
  const Scale({
    super.key = "ia_scale",
    required num scale,
    super.stringValue,
    super.specialValue,
  }) :
    super(value: scale);
}

class Scale3 extends Field<String, (num, num, num)>{
  const Scale3({
    super.key = "ia_scale3",
    required num x,
    required num y,
    required num z,
    String? stringValue,
    super.specialValue,
  }) :
    super(
      value: (x, y, z),
      stringValue: stringValue ?? "($x, $y, $z)",
    );
}

class ColorRGBA extends Field<String, (num, num, num, num)>{
  const ColorRGBA({
    super.key = "ia_color_rgba",
    required num r,
    required num g,
    required num b,
    required num a,
    String? stringValue,
    super.specialValue = SpecialData.color,
  }) :
    super(
    value: (r, g, b, a),
    stringValue: stringValue ?? "($r, $g, $b, $a)",
  );
}



class InvaildParamsAddition extends Field{
  const InvaildParamsAddition({
    super.key = "ia_invaild_params_addition",
  });
}

class CollageAddition extends Field{
  static List<Field> parse(dynamic collageJson){
    final List<Field> res = <Field>[];

    if(collageJson is! Map) return res;

    if(collageJson case {
      "TemplateId": int templateId,
      "RegionPictures": dynamic regionPicturesJson,
    }){
      final GameCollageTemplate collageTemplateInfo = GameCollageTemplate(templateId);

      res.addAll([
        Field<String, GameCollageTemplate>(
          key: "ia_Collage_template_id",
          value: collageTemplateInfo,
          stringValue: collageTemplateInfo.stringData,
          isTranslateValue: collageTemplateInfo.hasTranslation,
        ),
        Field<String, int>(
          key: "ia_Collage_region_pictures",
          children: parseRegionPictures(regionPicturesJson),
        ),
      ]);
    }

    return res;
  }

  static List<Field> parseRegionPictures(dynamic regionPicturesJson){
    final List<Field> res = <Field>[];

    if(regionPicturesJson is Map){
      regionPicturesJson = [regionPicturesJson];
    }

    if(regionPicturesJson is! List) return res;

    for(final (int index, dynamic regionPictures) in regionPicturesJson.indexed){
      if(regionPictures is Map){
        final List<Field> children = [];

        if(regionPictures case {
          "Position": Map positionJson,
          "Rotation": num rotation,
          "Scale": num scale,
          "oriCustomData": Map oriCustomDataJson,
          "ImageId": String imageId,
        }){
          if(positionJson case {
            "x": num x,
            "y": num y,
          }){
            children.add(Loc2(x: x, y: y));
          }

          children.addAll([
            Rot(
              rot: rotation,
            ),
            Scale(
              scale: scale,
            ),
            Field<String, String>(
              key: "ia_Collage_image_id",
              value: imageId,
            ),
            NikkiPhotoAddition.fromGameJson(
              key: "ia_Collage_oriCustomData",
              nikkiPhotoJson: oriCustomDataJson,
            ),
          ]);
        }

        res.add(Field(
          key: "ia_Collage_region_pictures_X",
          keyArgs: [(index + 1).toString()],
          children: children,
        ));
      }
    }

    return res;
  }

  const CollageAddition._({
    super.key = "ia_collage_addition",
    super.expand,
    super.children,
  });

  factory CollageAddition.fromGameJson({
    String key = "ia_collage_addition",
    bool expand = true,
    dynamic collageJson,
  }){
    return CollageAddition._(
      key: key,
      expand: expand,
      children: parse(collageJson),
    );
  }
}

class ExpeditionAddition extends Field{
  static List<Field> parse(dynamic expeditionJson){
    final List<Field> res = <Field>[];

    if(expeditionJson is! Map) return res;

    if(expeditionJson case {
      "clockGamePlugin": Map clockGamePluginJson,
    }){
      if(clockGamePluginJson case {
        "Tag": int tag,
      }){
        final GameExpedition expeditionInfo = GameExpedition(tag);

        res.add(Field<String, GameExpedition>(
          key: "ia_expedition",
          value: expeditionInfo,
          stringValue: expeditionInfo.stringData,
          isTranslateValue: expeditionInfo.hasTranslation,
        ));
      }
    }

    res.addAll(NikkiPhotoAddition.fromGameJson(nikkiPhotoJson: expeditionJson).children);

    return res;
  }

  const ExpeditionAddition._({
    super.key = "ia_expedition_addition",
    super.expand,
    super.children,
  });

  factory ExpeditionAddition.fromGameJson({
    String key = "ia_expedition_addition",
    bool expand = true,
    dynamic expeditionJson,
  }){
    return ExpeditionAddition._(
      key: key,
      expand: expand,
      children: parse(expeditionJson),
    );
  }
}

class NikkiPhotoAddition extends Field{
  static List<Field> parse(dynamic nikkiPhotoJson){
    final List<Field> res = <Field>[];

    if(nikkiPhotoJson is! Map) return res;

    res.add(PhotographyInfo.fromGameJson(nikkiPhotoJson: nikkiPhotoJson));

    res.add(CameraInfo.fromGameJson(nikkiPhotoJson: nikkiPhotoJson));

    if(nikkiPhotoJson case {
      "SocialPhoto": Map socialPhotoJson,
    }){
      res.add(NikkiInfo.fromGameJson(socialPhotoJson: socialPhotoJson));

      res.add(MomoInfo.fromGameJson(socialPhotoJson: socialPhotoJson));
    }

    late final Field autoShootField;
    if(res.any((Field field) => field.key == "ia_nikki_info")){
      autoShootField = Field<String, bool>(
        key: "ia_auto_shoot",
        value: false,
        stringValue: "ia_state_false_2",
        isTranslateValue: true,
      );
    }else{
      autoShootField = Field<String, bool>(
        key: "ia_auto_shoot",
        value: true,
        stringValue: "ia_state_true_2",
        isTranslateValue: true,
      );
    }

    return [autoShootField, ...res];
  }

  const NikkiPhotoAddition._({
    super.key = "ia_nikki_photo_addition",
    super.expand,
    super.children,
  });

  factory NikkiPhotoAddition.fromGameJson({
    String key = "ia_nikki_photo_addition",
    bool expand = true,
    dynamic nikkiPhotoJson,
  }){
    return NikkiPhotoAddition._(
      key: key,
      expand: expand,
      children: parse(nikkiPhotoJson),
    );
  }
}

class DIYPhotoAddition extends Field{
  static List<Field> parse(dynamic DIYPhotoJson){
    final List<Field> res = <Field>[];

    if(DIYPhotoJson is! Map) return res;

    if(DIYPhotoJson case {
      "Content": Map contentJson,
    }){

    }

    return res;
  }

  const DIYPhotoAddition._({
    super.key = "ia_collage_addition",
    super.expand,
    super.children,
  });

  factory DIYPhotoAddition.fromGameJson({
    String key = "ia_collage_addition",
    bool expand = true,
    dynamic DIYPhotoJson,
  }){
    return DIYPhotoAddition._(
      key: key,
      expand: expand,
      children: parse(DIYPhotoJson),
    );
  }
}



class PhotographyInfo extends Field{
  static List<Field> parse(dynamic nikkiPhotoJson){
    final List<Field> res = <Field>[];

    if(nikkiPhotoJson is! Map) return res;

    final List<Field> editPhotoData = parseEditPhotoData(nikkiPhotoJson);
    res.add(Field<String, String>(
      key: "ia_edit_photo",
      value: editPhotoData.isEmpty ? "ia_state_false_1" : null,
      isTranslateValue: editPhotoData.isEmpty,
      children: editPhotoData,
    ));

    if(nikkiPhotoJson case {
      "SocialPhoto": Map socialPhotoJson,
    }){
      if(socialPhotoJson case {
        "Time": Map timeJson,
      }){
        res.add(Field<String, dynamic>(
          key: "ia_time",
          children: parseTimeData(timeJson),
        ));
      }

      if(socialPhotoJson case {
        "PhotoInfo": dynamic photoInfoJson,
      }){
        res.addAll(parsePhotoRegion(photoInfoJson));
      }

      if(socialPhotoJson case {
        "WeatherType": int weatherType,
      }){
        final GameWeather weatherTypeInfo = GameWeather(weatherType);

        res.add(Field<String, GameWeather>(
          key: "ia_weather",
          value: weatherTypeInfo,
          stringValue: weatherTypeInfo.stringData,
          isTranslateValue: weatherTypeInfo.hasTranslation,
        ));
      }
    }

    final List<Field> photoWallFields = parsePhotoWallData(nikkiPhotoJson);
    res.add(Field<String, String?>(
      key: "ia_photo_wall",
      value: photoWallFields.isEmpty ? "ia_state_false_1" : null,
      isTranslateValue: photoWallFields.isEmpty,
      children: photoWallFields,
    ));

    res.add(Field<String, dynamic>(
      key: "ia_task",
      children: parseTaskData(nikkiPhotoJson),
    ));

    return res;
  }

  static List<Field> parseEditPhotoData(dynamic nikkiPhotoJson){
    final List<Field> res = <Field>[];

    if(nikkiPhotoJson is! Map) return res;

    if(nikkiPhotoJson case {
      "EditPhotoHandler": Map editPhotoHandlerJson,
    }){
      if(editPhotoHandlerJson case {
        "hasSticker": bool hasSticker,
        "hasText": bool hasText,
        "editState": bool editState,
      }){
        if(editState){
          res.addAll([
            Field<String, bool>(
              key: "ia_edit_photo_has_sticker",
              value: hasSticker,
              stringValue: hasSticker ? "ia_state_true_1" : "ia_state_false_1",
              isTranslateValue: true,
            ),
            Field<String, bool>(
              key: "ia_edit_photo_has_text",
              value: hasText,
              stringValue: hasText ? "ia_state_true_1" : "ia_state_false_1",
              isTranslateValue: true,
            )
          ]);
        }
      }
    }

    return res;
  }

  static List<Field> parseTimeData(dynamic timeJson){
    final List<Field> res = <Field>[];

    if(timeJson is! Map) return res;

    if(timeJson case {
      "day": num day,
      "hour": num hour,
      "min": num min,
      "sec": num sec,
    }){
      res.addAll([
        Field<String, num>(
          key: "ia_time_day",
          value: day,
        ),
        Field<String, num>(
          key: "ia_time_hour",
          value: hour,
        ),
        Field<String, num>(
          key: "ia_time_min",
          value: min,
        ),
        Field<String, num>(
          key: "ia_time_sec",
          value: sec,
          stringValue: sec.toStringAsFixed(0)
        ),
      ]);
    }

    return res;
  }

  static List<Field> parsePhotoRegion(dynamic photoInfoJson){
    final List<Field> res = <Field>[];

    if(photoInfoJson is! Map) return res;

    if(photoInfoJson case {
      "nikkiLocX": num x,
      "nikkiLocY": num y,
      "nikkiLocZ": num z,
    }){
      final List<GamePhotoRegion> photoRegionInfoList = GamePhotoRegion.byCoordinates((x, y, z));

      if(photoRegionInfoList.length == 1){
        res.add(Field<String, (GamePhotoRegion, num, num, num)>(
          key: "ia_photo_region",
          valueIcon: "map",
          value: (photoRegionInfoList.first, x, y, z),
          stringValue: photoRegionInfoList.first.stringData,
          isTranslateValue: photoRegionInfoList.first.hasTranslation,
        ));
      }else{
        for(final GamePhotoRegion photoRegionInfo in photoRegionInfoList){
          res.add(Field<String, (GamePhotoRegion, num, num, num)>(
            key: "ia_possible_photo_region",
            valueIcon: "map",
            value: (photoRegionInfo, x, y, z),
            stringValue: photoRegionInfo.stringData,
            isTranslateValue: photoRegionInfo.hasTranslation,
          ));
        }
      }
    }

    return res;
  }

  static List<Field> parsePhotoWallData(dynamic nikkiPhotoJson){
    final List<Field> res = <Field>[];

    if(nikkiPhotoJson is! Map) return res;

    if(nikkiPhotoJson case {
      "PhotoWallPlugin": Map photoWallPluginJson
    }){
      if(photoWallPluginJson case {
        "photoID": dynamic photoIDJson,
      }){
        if(photoIDJson is int){
          photoIDJson = [photoIDJson];
        }

        if(photoIDJson is List){
          for(final dynamic photoId in photoIDJson){
            if(photoId is int){
              final GamePhotoWall photoWallInfo = GamePhotoWall(photoId);

              res.add(Field<GamePhotoWall, dynamic>(
                key: photoWallInfo,
                stringKey: photoWallInfo.stringData,
                isTranslateKey: photoWallInfo.hasTranslation,
              ));
            }
          }
        }
      }
    }

    return res;
  }

  static List<Field> parseTaskData(dynamic nikkiPhotoJson){
    final List<Field> res = <Field>[];

    final List<Field> riskPhotoFields = <Field>[];
    final List<Field> taskPhotoFields = <Field>[];

    if(nikkiPhotoJson is! Map) return res;

    if(nikkiPhotoJson case {
      "PuzzleGamePlugin": Map puzzleGamePluginJson,
    }){
      if(puzzleGamePluginJson case {
        "Tag": int tag,
      }){
        final GamePuzzleGame puzzleGameInfo = GamePuzzleGame(tag);
        res.add(Field<String, GamePuzzleGame>(
          key: "ia_puzzle_game",
          value: puzzleGameInfo,
          stringValue: puzzleGameInfo.stringData,
          isTranslateValue: puzzleGameInfo.hasTranslation,
        ));
      }
    }

    if(nikkiPhotoJson case {
      "RiskPhoto": Map riskPhotoJson,
    }){
      for(final riskPhotoEntry in riskPhotoJson.entries){
        if(riskPhotoEntry.key is int && riskPhotoEntry.value is bool){
          final GameRiskPhoto riskPhotoTypeInfo = GameRiskPhoto(riskPhotoEntry.key);
          final GameRiskPhotoState riskPhotoState = GameRiskPhotoState(riskPhotoEntry.value);

          riskPhotoFields.add(Field<GameRiskPhoto, GameRiskPhotoState>(
            key: riskPhotoTypeInfo,
            stringKey: riskPhotoTypeInfo.stringData,
            isTranslateKey: riskPhotoTypeInfo.hasTranslation,
            value: riskPhotoState,
            stringValue: riskPhotoState.stringData,
            isTranslateValue: riskPhotoState.hasTranslation,
          ));
        }
      }
    }

    if(nikkiPhotoJson case {
      "InteractivePhoto": Map interactivePhoto,
    }){
      for(final entry in interactivePhoto.entries){
        if(entry.key is int && entry.value is bool){
          final GameInteractivePhoto interactivePhotoTypeInfo = GameInteractivePhoto(entry.key);
          final GameInteractivePhotoState interactivePhotoStateInfo = GameInteractivePhotoState(entry.value);

          taskPhotoFields.add(Field<GameInteractivePhoto, GameInteractivePhotoState>(
            key: interactivePhotoTypeInfo,
            stringKey: interactivePhotoTypeInfo.stringData,
            isTranslateKey: interactivePhotoTypeInfo.hasTranslation,
            value: interactivePhotoStateInfo,
            stringValue: interactivePhotoStateInfo.stringData,
            isTranslateValue: interactivePhotoStateInfo.hasTranslation,
          ));
        }
      }
    }

    res.add(Field<String, bool>(
      key: "ia_risk_photo",
      value: riskPhotoFields.isNotEmpty,
      stringValue: riskPhotoFields.isNotEmpty ? "ia_has_risk_photo" : "ia_has_no_risk_photo",
      isTranslateValue: true,
      children: riskPhotoFields,
    ));

    res.add(Field<String, bool>(
      key: "ia_task_photo",
      value: taskPhotoFields.isNotEmpty,
      stringValue: taskPhotoFields.isNotEmpty ? "ia_has_task_photo" : "ia_has_no_task_photo",
      isTranslateValue: true,
      children: taskPhotoFields,
    ));

    return res;
  }


  const PhotographyInfo._({
    super.key = "ia_photography_info",
    super.expand,
    super.children,
  });

  factory PhotographyInfo.fromGameJson({
    String key = "ia_photography_info",
    bool expand = true,
    dynamic nikkiPhotoJson,
  }){
    return PhotographyInfo._(
      key: key,
      expand: expand,
      children: parse(nikkiPhotoJson),
    );
  }
}

class CameraInfo extends Field{
  static List<Field> parse(dynamic nikkiPhotoJson){
    final List<Field> res = <Field>[];

    if(nikkiPhotoJson is! Map) return res;

    if(nikkiPhotoJson case {
      "SocialPhoto": Map socialPhotoJson,
    }){
      if(socialPhotoJson case {
        "CameraParams": String cameraParams,
      }){
        res.add(Field<String, String>(
          key: "ia_camera_params",
          valueIcon: "copy",
          value: cameraParams,
        ));
      }
    }

    if(nikkiPhotoJson case {
      "PortraitModeHandler": Map portraitModeHandlerJson,
    }){
      if(portraitModeHandlerJson case {
        "PortraitMode": int portraitMode,
      }){
        final GamePortraitMode portraitModeInfo = GamePortraitMode(portraitMode);

        res.add(Field<String, GamePortraitMode>(
          key: "ia_portrait_mode",
          value: portraitModeInfo,
          stringValue: portraitModeInfo.stringData,
          isTranslateValue: portraitModeInfo.hasTranslation,
        ));
      }
    }

    if(nikkiPhotoJson case {
      "SocialPhoto": Map socialPhotoJson,
    }){

      if(socialPhotoJson case {
        "PhotoInfo": Map photoInfoJson,
      }){
        if(photoInfoJson case {
          "nikkiLocX": num nikkiLocX,
          "nikkiLocY": num nikkiLocY,
          "nikkiLocZ": num nikkiLocZ,
          "cameraActorLocX": num cameraLocX,
          "cameraActorLocY": num cameraLocY,
          "cameraActorLocZ": num cameraLocZ,
        }){
          final num dx = nikkiLocX - cameraLocX;
          final num dy = nikkiLocY - cameraLocY;
          final num dz = nikkiLocZ - cameraLocZ;
          final double distance = sqrt(dx * dx + dy * dy + dz * dz);
          final double zoom = -0.0035 * distance + 6.45;

          res.add(Field<String, double>(
            key: "ia_camera_zoom",
            value: zoom,
            stringValue: "${zoom.toStringAsFixed(1)}x",
          ));
        }

        if(photoInfoJson case {
          "cameraFocalLength": num cameraFocalLength,
        }){
          res.add(Field<String, double>(
            key: "ia_camera_focal_length",
            value: cameraFocalLength.toDouble(),
            stringValue: "${cameraFocalLength.toStringAsFixed(0)}mm",
          ));
        }

        if(photoInfoJson case {
          "cameraActorRotRoll": num cameraActorRotRoll,
        }){
          res.add(Field<String, double>(
            key: "ia_camera_rotation",
            value: cameraActorRotRoll.toDouble(),
            stringValue: "${cameraActorRotRoll.toStringAsFixed(0)}°",
          ));
        }

        if(photoInfoJson case {
          "apertureSection": num apertureSection,
        }){
          final GameApertureSection apertureSectionInfo = GameApertureSection(apertureSection.toInt());

          res.add(Field<String, GameApertureSection>(
            key: "ia_aperture_section",
            value: apertureSectionInfo,
            stringValue: apertureSectionInfo.stringData,
            isTranslateValue: apertureSectionInfo.hasTranslation,
          ));
        }

        if(photoInfoJson case {
          "vignetteIntensity": num vignetteIntensity,
        }){
          res.add(Field<String, double>(
            key: "ia_vignette_intensity",
            value: vignetteIntensity.toDouble(),
            stringValue: "${(vignetteIntensity * 100).toStringAsFixed(0)}%",
          ));
        }
      }

      /// TODO
      if(socialPhotoJson case {
        "CameraParams": String cameraParams,
      }){
        final decoded = GameCameraParamCodec.decode(cameraParams);

        res.add(Field<String, double>(
          key: "ia_bloom_intensity",
          value: 0,
          stringValue: "-",
        ));
        res.add(Field<String, double>(
          key: "ia_bloom_threshold",
          value: 0,
          stringValue: "-",
        ));
        res.add(Field<String, double>(
          key: "ia_brightness",
          value: 0,
          stringValue: "-",
        ));
        res.add(Field<String, double>(
          key: "ia_exposure",
          value: 0,
          stringValue: "-",
        ));
        res.add(Field<String, double>(
          key: "ia_contrast",
          value: 0,
          stringValue: "-",
        ));
        res.add(Field<String, double>(
          key: "ia_saturation",
          value: 0,
          stringValue: "-",
        ));
        res.add(Field<String, double>(
          key: "ia_vibrance",
          value: 0,
          stringValue: "-",
        ));
        res.add(Field<String, double>(
          key: "ia_highlights",
          value: 0,
          stringValue: "-",
        ));
        res.add(Field<String, double>(
          key: "ia_shadows",
          value: 0,
          stringValue: "-",
        ));
      }

      if(socialPhotoJson case {
        "PhotoInfo": Map photoInfoJson,
      }){
        if(photoInfoJson case {
          "lightId": String lightId,
        }){
          final GameLight lightIdInfo = GameLight(lightId);

          res.add(Field<String, GameLight>(
            key: "ia_light_id",
            value: lightIdInfo,
            stringValue: lightIdInfo.stringData,
            isTranslateValue: lightIdInfo.hasTranslation,
          ));

          if(lightIdInfo != GameLight.None){
            if(photoInfoJson case {
              "lightStrength": num lightStrength,
            }){
              res.add(Field<String, double>(
                key: "ia_light_strength",
                value: lightStrength.toDouble(),
                stringValue: "${(lightStrength * 100).toStringAsFixed(0)}%",
              ));
            }
          }
        }

        if(photoInfoJson case {
          "filterId": String filterId,
        }){
          final GameFilter filterIdInfo = GameFilter(filterId);

          res.add(Field<String, GameFilter>(
            key: "ia_filter_id",
            value: filterIdInfo,
            stringValue: filterIdInfo.stringData,
            isTranslateValue: filterIdInfo.hasTranslation,
          ));

          if(filterIdInfo != GameFilter.None){
            if(photoInfoJson case {
              "filterStrength": num filterStrength,
            }){
              res.add(Field<String, double>(
                key: "ia_filter_strength",
                value: filterStrength.toDouble(),
                stringValue: "${(filterStrength * 100).toStringAsFixed(0)}%",
              ));
            }
          }
        }

        if(photoInfoJson case {
          "poseId": int poseId,
        }){
          final GamePose poseIdInfo = GamePose(poseId);

          res.add(Field<String, GamePose>(
            key: "ia_pose_id",
            value: poseIdInfo,
            stringValue: poseIdInfo.stringData,
            isTranslateValue: poseIdInfo.hasTranslation,
          ));
        }
      }
    }

    return res;
  }

  const CameraInfo._({
    super.key = "ia_camera_info",
    super.expand,
    super.children,
  });

  factory CameraInfo.fromGameJson({
    String key = "ia_camera_info",
    bool expand = true,
    dynamic nikkiPhotoJson,
  }){
    return CameraInfo._(
      key: key,
      expand: expand,
      children: parse(nikkiPhotoJson),
    );
  }
}

class NikkiInfo extends Field{
  static List<Field> parse(dynamic socialPhotoJson){
    final List<Field> res = <Field>[];

    if(socialPhotoJson is! Map) return res;

    if(socialPhotoJson case {
      "GiantState": bool giantState,
    }){
      final GameNikkiGiantState giantStateInfo = GameNikkiGiantState(giantState);

      res.add(Field<String, GameNikkiGiantState>(
        key: "ia_nikki_giant_state",
        value: giantStateInfo,
        stringValue: giantStateInfo.stringData,
        isTranslateValue: giantStateInfo.hasTranslation,
      ));
    }

    if(socialPhotoJson case {
      "PhotoInfo": dynamic photoInfoJson,
    }){
      res.addAll(parseNikkiTransformationData(photoInfoJson));

      res.add(Field<String, dynamic>(
        key: "ia_nikki_clothes",
        children: parseNikkiClothesData(photoInfoJson),
      ));
    }

    res.add(parseWeaponData(socialPhotoJson));

    final List<Field> interactionsFields = parseInteractionsData(socialPhotoJson);
    res.add(Field<String, String?>(
      key: "ia_interaction",
      value: interactionsFields.isEmpty ? "ia_state_false_1" : null,
      isTranslateValue: true,
      children: interactionsFields,
    ));

    res.add(parseCarrierData(socialPhotoJson));

    return res;
  }

  static List<Field> parseNikkiTransformationData(dynamic photoInfoJson){
    final List<Field> res = <Field>[];

    if(photoInfoJson is! Map) return res;

    if(photoInfoJson case {
      "nikkiHidden": bool nikkiHidden,
    }){
      final GameNikkiHiddenState nikkiHiddenState = GameNikkiHiddenState(nikkiHidden);

      res.add(Field<String, GameNikkiHiddenState>(
        key: "ia_nikki_hidden",
        value: nikkiHiddenState,
        stringValue: nikkiHiddenState.stringData,
        isTranslateValue: nikkiHiddenState.hasTranslation,
      ));
    }

    if(photoInfoJson case {
      "nikkiLocX": num nikkiLocX,
      "nikkiLocY": num nikkiLocY,
      "nikkiLocZ": num nikkiLocZ,
    }){
      res.add(Loc3(
        x: nikkiLocX,
        y: nikkiLocY,
        z: nikkiLocZ,
      ));
    }

    if(photoInfoJson case {
      "nikkiRotYaw": num nikkiRotYaw,
      "nikkiRotPitch": num nikkiRotPitch,
      "nikkiRotRoll": num nikkiRotRoll,
    }){
      res.add(Rot3(
        yaw: nikkiRotYaw,
        pitch: nikkiRotPitch,
        roll: nikkiRotRoll,
      ));
    }

    if(photoInfoJson case {
      "nikkiScaleX": num nikkiScaleX,
      "nikkiScaleY": num nikkiScaleY,
      "nikkiScaleZ": num nikkiScaleZ,
    }){
      res.add(Scale3(
        x: nikkiScaleX,
        y: nikkiScaleY,
        z: nikkiScaleZ,
      ));
    }

    return res;
  }

  static List<Field> parseNikkiClothesData(dynamic photoInfoJson){
    final List<Field> res = <Field>[];

    if(photoInfoJson is! Map) return res;

    /// parse NikkiDIY
    final List<Field> nikkiDIYFields = [];
    if(photoInfoJson case {
      "nikkiDIY": dynamic nikkiDIYJson,
    }){
      nikkiDIYFields.addAll(parseNikkiDIYData(nikkiDIYJson));
    }

    /// parse eureka
    final List<Field> eurekaFields = [];
    if(photoInfoJson case {
      "magicballColorIds": dynamic magicballColorIdsJson,
    }){
      eurekaFields.addAll(parseEurekaData(magicballColorIdsJson));
    }

    /// parse NikkiClothes
    if(photoInfoJson case {
      "nikkiClothes": dynamic nikkiClothesJson,
    }){
      final List<Field> accessoriesFields = <Field>[];
      final List<Field> makeupFields = <Field>[];

      for(final dynamic data in nikkiClothesJson){
        if(data is int){
          final GameClothes clothesInfo = GameClothes(data);

          if(clothesInfo.isClothes){
            final GameNikkiClothesType typeInfo = GameNikkiClothesType(clothesInfo.type);
            final GameNikkiClothesSlot slotInfo = typeInfo.slot;
            final GameNikkiClothesOutfits outfitsInfo = GameNikkiClothesOutfits(clothesInfo.outfitsId);
            final GameClothesState stateInfo = GameClothesState(clothesInfo.state);

            final Field? clothesDIY = nikkiDIYFields.where((Field clothesDIYField) => clothesDIYField.key == clothesInfo.stringData).firstOrNull;
            final Field clothesDIYFields = Field<String, String>(
              key: "ia_nikki_clothes_DIY",
              value: clothesDIY?.children.isEmpty != false ? "ia_nikki_clothes_has_no_DIY" : "ia_nikki_clothes_has_DIY",
              isTranslateValue: true,
              children: clothesDIY?.children ?? const <Field>[],
            );

            switch(slotInfo){
              case GameNikkiClothesSlot.unknown:
                res.add(Field<GameNikkiClothesType, GameClothes>(
                  key: typeInfo,
                  stringKey: typeInfo.stringData,
                  isTranslateKey: typeInfo.hasTranslation,
                  value: clothesInfo,
                  stringValue: clothesInfo.stringData,
                  isTranslateValue: clothesInfo.hasTranslation,
                  children: [
                    clothesDIYFields,
                  ]
                ));
                break;
              case GameNikkiClothesSlot.accessories:
                accessoriesFields.add(Field<GameNikkiClothesType, GameClothes>(
                  key: typeInfo,
                  stringKey: typeInfo.stringData,
                  isTranslateKey: typeInfo.hasTranslation,
                  value: clothesInfo,
                  stringValue: clothesInfo.stringData,
                  isTranslateValue: clothesInfo.hasTranslation,
                  children: [
                    Field<String, GameNikkiClothesOutfits>(
                      key: "ia_nikki_clothes_clothing_outfits",
                      value: outfitsInfo,
                      stringValue: outfitsInfo.stringData,
                      isTranslateValue: outfitsInfo.hasTranslation,
                    ),
                    Field<String, GameClothesState>(
                      key: "ia_nikki_clothes_clothing_state",
                      value: stateInfo,
                      stringValue: stateInfo.stringData,
                      isTranslateValue: stateInfo.hasTranslation,
                    ),
                    clothesDIYFields,
                  ],
                ));
                break;
              case GameNikkiClothesSlot.makeup:
                makeupFields.add(Field<GameNikkiClothesType, GameClothes>(
                  key: typeInfo,
                  stringKey: typeInfo.stringData,
                  isTranslateKey: typeInfo.hasTranslation,
                  value: clothesInfo,
                  stringValue: clothesInfo.stringData,
                  isTranslateValue: clothesInfo.hasTranslation,
                  children: [
                    /// 肤色为 42
                    if(typeInfo != GameNikkiClothesType.skinTones)
                      Field<String, GameNikkiClothesOutfits>(
                        key: "ia_nikki_clothes_clothing_outfits",
                        value: outfitsInfo,
                        stringValue: outfitsInfo.stringData,
                        isTranslateValue: outfitsInfo.hasTranslation,
                      ),
                    clothesDIYFields,
                  ],
                ));
                break;
              default:
                res.add(Field<GameNikkiClothesType, GameClothes>(
                  key: typeInfo,
                  stringKey: typeInfo.stringData,
                  isTranslateKey: typeInfo.hasTranslation,
                  value: clothesInfo,
                  stringValue: clothesInfo.stringData,
                  isTranslateValue: clothesInfo.hasTranslation,
                  children: [
                    Field<String, GameNikkiClothesOutfits>(
                      key: "ia_nikki_clothes_clothing_outfits",
                      value: outfitsInfo,
                      stringValue: outfitsInfo.stringData,
                      isTranslateValue: outfitsInfo.hasTranslation,
                    ),
                    Field<String, GameClothesState>(
                      key: "ia_nikki_clothes_clothing_state",
                      value: stateInfo,
                      stringValue: stateInfo.stringData,
                      isTranslateValue: stateInfo.hasTranslation,
                    ),
                    clothesDIYFields,
                  ],
                ));
                break;
            }
          }
        }
      }

      if(accessoriesFields.isNotEmpty){
        res.add(Field(
          key: GameNikkiClothesSlot.accessories.stringData,
          isTranslateKey: GameNikkiClothesSlot.accessories.hasTranslation,
          children: accessoriesFields,
        ));
      }
      /// TODO 全妆
      if(makeupFields.isNotEmpty){
        res.add(Field(
          key: GameNikkiClothesSlot.makeup.stringData,
          isTranslateKey: GameNikkiClothesSlot.makeup.hasTranslation,
          children: makeupFields,
        ));
      }

      /// 祝福闪光
      res.add(Field(
        key: "ia_eureka",
        value: eurekaFields.isEmpty ? "ia_state_false_1" : null,
        isTranslateValue: true,
        children: eurekaFields,
      ));
    }

    return res;
  }

  static List<Field> parseNikkiDIYData(dynamic nikkiDIYJson){
    final List<Field> res = <Field>[];

    if(nikkiDIYJson is Map){
      nikkiDIYJson = [nikkiDIYJson];
    }

    if(nikkiDIYJson is! List) return res;

    /// sort
    final Map<int, Map<GameDIYType, List<Map>>> sortedWrapper = {};

    for(final dynamic data in nikkiDIYJson){
      if(data is Map){
        if(data case {
          "TargetClothID": int targetClothID,
          "FeatureTag": int featureTag,
          "TargetGroupID": int targetGroupID,
          "CoreData": Map coreData,
        }){
          final Map<GameDIYType, List> clothMap = (sortedWrapper[targetClothID] ??= <GameDIYType, List<Map>>{});

          /// GameDIYType.outfitDye & not hair
          if(coreData case {
            "ColorGridID": num _,
            "R": num _,
            "G": num _,
            "B": num _,
            "A": num _,
          }){
            (clothMap[GameDIYType.outfitDye] ??= <Map>[]).add(data);
          }
          /// GameDIYType.outfitDye & hair
          else if(coreData case {
            "TargetColor0": Map _,
            "ColorGridID0": num _,
            "RoughnessOffset": num _,
          }){
            (clothMap[GameDIYType.outfitDye] ??= <Map>[]).add(data);
          }
          /// GameDIYType.specialEffect
          else if(coreData case {
            "ColorGridID": num _,
            "CoverDIYColor": bool _,
          }){
            (clothMap[GameDIYType.specialEffect] ??= <Map>[]).add(data);
          }
          /// GameDIYType.patternCreation
          else if(coreData case {
            "ReplaceTextureID": num _,
          }){
            (clothMap[GameDIYType.patternCreation] ??= <Map>[]).add(data);
          }
          /// GameDIYType.patternCreation
          else if(coreData case {
            "TilingData": num _
          }){
            (clothMap[GameDIYType.patternCreation] ??= <Map>[]).add(data);
          }
        }
      }
    }

    /// clothes field
    final Map<int, List<Field>> fieldWrapper = {};

    for(final MapEntry<int, Map<GameDIYType, List<Map>>> clothesEntry in sortedWrapper.entries){
      final List<Field> typeFields = (fieldWrapper[clothesEntry.key] ??= <Field>[]);

      final List<Field> outfitDyeFields = [];
      final List<Field> specialEffectFields = [];
      final List<Field> patternCreationFields = [];

      for(final MapEntry<GameDIYType, List<Map>> DIYEntry in clothesEntry.value.entries){

        for(final Map DIYJson in DIYEntry.value){
          if(DIYJson case {
            "TargetClothID": int targetClothID,
            "FeatureTag": int featureTag,
            "TargetGroupID": int targetGroupID,
            "CoreData": Map coreDataJson,
          }){
            switch(DIYEntry.key){
              /// GameDIYType.outfitDye
              case GameDIYType.outfitDye:
                final List<Field> areaChildren = [];

                /// hair
                if(GameClothes(targetClothID).type == GameNikkiClothesType.hair.data){
                  if(coreDataJson case {
                    "TargetColor0": Map targetColor0,
                    "ColorGridID0": int colorGridID0,
                  }){
                    final GameDIYColorGrid colorGridInfo = GameDIYColorGrid(colorGridID0);

                    if(colorGridInfo.isInGrid){
                      if(targetColor0 case {
                        "R": num r,
                        "G": num g,
                        "B": num b,
                        "A": num a,
                      }){
                        areaChildren.add(ColorRGBA(r: r, g: g, b: b, a: a));
                      }

                      final GameDIYColorPalette colorPaletteInfo = colorGridInfo.palette;
                      final GameDIYColorSwatch colorSwatchInfo = colorGridInfo.swatch;

                      areaChildren.addAll([
                        Field<String, GameDIYColorPalette>(
                          key: "ia_DIY_color_palette_X",
                          keyArgs: ["1"],
                          value: colorPaletteInfo,
                          stringValue: colorPaletteInfo.stringData,
                          isTranslateValue: colorPaletteInfo.hasTranslation,
                        ),
                        Field<String, GameDIYColorSwatch>(
                          key: "ia_DIY_color_swatch_X",
                          keyArgs: ["1"],
                          value: colorSwatchInfo,
                          stringValue: colorSwatchInfo.stringData,
                          isTranslateValue: colorSwatchInfo.hasTranslation,
                        ),
                      ]);
                    }
                  }

                  if(coreDataJson case {
                    "TargetColor1": Map targetColor1,
                    "ColorGridID1": int colorGridID1,
                  }){
                    final GameDIYColorGrid colorGridInfo = GameDIYColorGrid(colorGridID1);

                    if(colorGridInfo.isInGrid){
                      if(targetColor1 case {
                        "R": num r,
                        "G": num g,
                        "B": num b,
                        "A": num a,
                      }){
                        areaChildren.add(ColorRGBA(r: r, g: g, b: b, a: a));
                      }

                      final GameDIYColorPalette colorPaletteInfo = colorGridInfo.palette;
                      final GameDIYColorSwatch colorSwatchInfo = colorGridInfo.swatch;

                      areaChildren.addAll([
                        Field<String, GameDIYColorPalette>(
                          key: "ia_DIY_color_palette_X",
                          keyArgs: ["2"],
                          value: colorPaletteInfo,
                          stringValue: colorPaletteInfo.stringData,
                          isTranslateValue: colorPaletteInfo.hasTranslation,
                        ),
                        Field<String, GameDIYColorSwatch>(
                          key: "ia_DIY_color_swatch_X",
                          keyArgs: ["2"],
                          value: colorSwatchInfo,
                          stringValue: colorSwatchInfo.stringData,
                          isTranslateValue: colorSwatchInfo.hasTranslation,
                        ),
                      ]);
                    }
                  }

                  if(coreDataJson case {
                    "RoughnessOffset": num roughnessOffset,
                  }){
                    areaChildren.add(Field<String, double>(
                      key: "ia_DIY_outfit_dye_glossiness",
                      value: (1 - roughnessOffset).toDouble(),
                    ));
                  }

                  if(coreDataJson case {
                    "HairColorMode": int hairColorMode,
                  }){
                    final GameDIYHairColorMode hairColorModeInfo = GameDIYHairColorMode(hairColorMode);

                    areaChildren.add(Field<String, GameDIYHairColorMode>(
                      key: "ia_DIY_outfit_dye_hair_color_mode",
                      value: hairColorModeInfo,
                      stringValue: hairColorModeInfo.stringData,
                      isTranslateValue: hairColorModeInfo.hasTranslation,
                    ));
                  }
                }
                /// not hair
                else{
                  if(coreDataJson case {
                    "ColorGridID": int colorGridID,
                    "R": num r,
                    "G": num g,
                    "B": num b,
                    "A": num a,
                  }){
                    areaChildren.add(ColorRGBA(r: r, g: g, b: b, a: a));

                    final GameDIYColorGrid colorGridInfo = GameDIYColorGrid(colorGridID);

                    if(colorGridInfo.isInGrid){
                      final GameDIYColorPalette colorPaletteInfo = colorGridInfo.palette;
                      final GameDIYColorSwatch colorSwatchInfo = colorGridInfo.swatch;

                      areaChildren.addAll([
                        Field<String, GameDIYColorPalette>(
                          key: "ia_DIY_color_palette",
                          value: colorPaletteInfo,
                          stringValue: colorPaletteInfo.stringData,
                          isTranslateValue: colorPaletteInfo.hasTranslation,
                        ),
                        Field<String, GameDIYColorSwatch>(
                          key: "ia_DIY_color_swatch",
                          value: colorSwatchInfo,
                          stringValue: colorSwatchInfo.stringData,
                          isTranslateValue: colorSwatchInfo.hasTranslation,
                        ),
                      ]);
                    }
                  }
                }

                outfitDyeFields.add(Field(
                  key: "ia_diy_area_X",
                  keyArgs: ["$featureTag-$targetGroupID"],
                  children: areaChildren,
                ));
                break;
              case GameDIYType.specialEffect:
                final List<Field> areaChildren = [];

                if(coreDataJson case {
                  "ColorGridID": int colorGridID,
                  "CoverDIYColor": bool coverDIYColor,
                }){
                  final GameDIYColorGrid colorGridInfo = GameDIYColorGrid(colorGridID);

                  if(colorGridInfo.isInGrid){
                    final GameDIYColorPalette colorPaletteInfo = colorGridInfo.palette;
                    final GameDIYColorSwatch colorSwatchInfo = colorGridInfo.swatch;

                    areaChildren.addAll([
                      Field<String, GameDIYColorPalette>(
                        key: "ia_DIY_color_palette",
                        value: colorPaletteInfo,
                        stringValue: colorPaletteInfo.stringData,
                        isTranslateValue: colorPaletteInfo.hasTranslation,
                      ),
                      Field<String, GameDIYColorSwatch>(
                        key: "ia_DIY_color_swatch",
                        value: colorSwatchInfo,
                        stringValue: colorSwatchInfo.stringData,
                        isTranslateValue: colorSwatchInfo.hasTranslation,
                      ),
                    ]);
                  }

                  final GameDIYCoverDIYColor coverDIYColorInfo = GameDIYCoverDIYColor(coverDIYColor);
                  areaChildren.add(Field<String, GameDIYCoverDIYColor>(
                    key: "ia_DIY_cover_DIY_color",
                    value: coverDIYColorInfo,
                    stringValue: coverDIYColorInfo.stringData,
                    isTranslateValue: coverDIYColorInfo.hasTranslation,
                  ));
                }

                specialEffectFields.add(Field<String, dynamic>(
                  key: "ia_diy_area_X",
                  keyArgs: ["$featureTag-$targetGroupID"],
                  children: areaChildren,
                ));
                break;
              case GameDIYType.patternCreation:
                final List<Field> areaChildren = [];

                if(coreDataJson case {
                  "ReplaceTextureID": int replaceTextureID,
                }){
                  final GameDIYPatternTexture patternTextureInfo = GameDIYPatternTexture(replaceTextureID);

                  areaChildren.add(Field<String, GameDIYPatternTexture>(
                    key: "ia_DIY_pattern_texture",
                    value: patternTextureInfo,
                    stringValue: patternTextureInfo.stringData,
                    isTranslateValue: patternTextureInfo.hasTranslation,
                  ));

                  if(coreDataJson case {
                    "OverridePatternA": bool overridePatternA,
                  }){
                    final GameDIYOverridePatternA overridePatternAInfo = GameDIYOverridePatternA(overridePatternA);
                    areaChildren.add(Field<String, GameDIYOverridePatternA>(
                      key: "ia_DIY_override_pattern_A_false",
                      value: overridePatternAInfo,
                      stringValue: overridePatternAInfo.stringData,
                      isTranslateValue: overridePatternAInfo.hasTranslation,
                    ));
                  }else{
                    areaChildren.add(Field<String, GameDIYOverridePatternA>(
                      key: "ia_DIY_override_pattern_A_false",
                      value: GameDIYOverridePatternA.defaultState,
                      stringValue: GameDIYOverridePatternA.defaultState.stringData,
                      isTranslateValue: GameDIYOverridePatternA.defaultState.hasTranslation,
                    ));
                  }
                }
                else if(coreDataJson case {
                  "TilingData": num tilingData,
                }){
                  areaChildren.add(Field<String, double>(
                    key: "ia_DIY_tiling_data",
                    value: tilingData.toDouble(),
                    stringValue: tilingData.toStringAsFixed(2),
                  ));
                }

                patternCreationFields.add(Field(
                  key: "ia_diy_area_X",
                  keyArgs: ["$featureTag-$targetGroupID"],
                  children: areaChildren,
                ));
                break;
            }
          }
        }
      }

      if(outfitDyeFields.isNotEmpty){
        typeFields.add(Field(
          key: GameDIYType.outfitDye.stringData,
          isTranslateKey: GameDIYType.outfitDye.hasTranslation,
          children: outfitDyeFields,
        ));
      }
      if(specialEffectFields.isNotEmpty){
        typeFields.add(Field(
          key: GameDIYType.specialEffect.stringData,
          isTranslateKey: GameDIYType.specialEffect.hasTranslation,
          children: specialEffectFields,
        ));
      }
      if(patternCreationFields.isNotEmpty){
        /// 合并 TilingData
        /// 寻找 TilingData
        Field? tilingDataAreaField;
        Field? tilingDataField;
        for(final Field patternCreationAreaField in patternCreationFields){
          for(final Field areaChildField in patternCreationAreaField.children){
            if(areaChildField.key == "ia_DIY_tiling_data"){
              tilingDataAreaField = patternCreationAreaField;
              tilingDataField = areaChildField;
              break;
            }
          }
        }
        /// 移出独立的 TilingData
        patternCreationFields.remove(tilingDataAreaField);

        /// 为每个 Field 添加 TilingData
        if(tilingDataField != null){
          for(final Field patternCreationAreaField in patternCreationFields){
            patternCreationAreaField.children.add(tilingDataField);
          }
        }

        typeFields.add(Field(
          key: GameDIYType.patternCreation.stringData,
          isTranslateKey: GameDIYType.patternCreation.hasTranslation,
          children: [
            ?tilingDataField,
            ...patternCreationFields,
          ],
        ));
      }
    }

    /// field
    for(final MapEntry entry in fieldWrapper.entries){
      final GameClothes clothesInfo = GameClothes(entry.key);

      res.add(Field(
        key: clothesInfo.stringData,
        isTranslateKey: clothesInfo.hasTranslation,
        children: entry.value,
      ));
    }

    return res;
  }

  static List<Field> parseEurekaData(dynamic magicballColorIdsJson){
    final List<Field> res = <Field>[];

    if(magicballColorIdsJson is! List) return res;

    for(final dynamic eureka in magicballColorIdsJson){
      if(eureka is int){
        final GameEureka eurekaInfo = GameEureka(eureka);

        if(eurekaInfo.isEureka){
          final int id = eurekaInfo.id;
          final GameEurekaAttachmentPoint attachmentPointInfo = eurekaInfo.attachmentPoint;
          final GameEurekaLevel eurekaLevelInfo = eurekaInfo.level;
          final int color = eurekaInfo.color;

          res.add(Field<GameEurekaAttachmentPoint, GameEureka>(
            key: attachmentPointInfo,
            stringKey: attachmentPointInfo.stringData,
            isTranslateKey: attachmentPointInfo.hasTranslation,
            value: eurekaInfo,
            stringValue: eurekaInfo.stringData,
            isTranslateValue: eurekaInfo.hasTranslation,
            children: [
              Field<String, int>(
                key: "ia_eureka_outfits",
                value: id,
              ),
              Field<String, GameEurekaLevel>(
                key: "ia_eureka_level",
                value: eurekaLevelInfo,
                stringValue: eurekaLevelInfo.stringData,
                isTranslateValue: eurekaLevelInfo.hasTranslation,
              ),
              Field<String, int>(
                key: "ia_eureka_color",
                value: color,
              ),
            ]
          ));
        }
      }
    }

    return res;
  }

  static Field parseWeaponData(dynamic socialPhotoJson){
    const Field noWeaponField = Field<String, String>(
      key: "ia_weapon",
      value: "ia_state_false_4",
      isTranslateValue: true,
    );

    if(socialPhotoJson is! Map) return noWeaponField;

    final List<Field> children = [];

    if(socialPhotoJson case {
      "WeaponSnapShot": Map weaponSnapShotJson
    }){
      if(weaponSnapShotJson case {
        "weaponID": int weaponID,
        "slotType": String slotType,
      }){
        final GameWeapon weaponInfo = GameWeapon(weaponID);
        final GameWeaponSlotType slotTypeInfo = GameWeaponSlotType(slotType);

        children.add(Field<String, GameWeaponSlotType>(
          key: "ia_weapon_slot",
          value: slotTypeInfo,
          stringValue: slotTypeInfo.stringData,
          isTranslateValue: slotTypeInfo.hasTranslation,
        ));

        if(weaponSnapShotJson case {
          "customState": String customState,
        }){
          final GameWeaponCustomState customStateInfo = GameWeaponCustomState(customState);

          children.add(Field<String, GameWeaponCustomState>(
            key: "ia_weapon_custom_state",
            value: customStateInfo,
            stringValue: customStateInfo.stringData,
            isTranslateValue: customStateInfo.hasTranslation,
          ));
        }

        return Field<String, GameWeapon>(
          key: "ia_weapon",
          value: weaponInfo,
          stringValue: weaponInfo.stringData,
          isTranslateValue: weaponInfo.hasTranslation,
          children: children,
        );
      }
    }

    return noWeaponField;
  }

  static List<Field> parseInteractionsData(dynamic socialPhotoJson){
    final List<Field> res = <Field>[];

    if(socialPhotoJson is! Map) return res;

    if(socialPhotoJson case {
      "Interactions": dynamic interactionsJson,
    }){
      if(interactionsJson is Map){
        interactionsJson = [interactionsJson];
      }

      if(interactionsJson is List){
        for(final dynamic interaction in interactionsJson){
          if(interaction is Map){
            if(interaction case {
              "CfgID": int cfgID,
            }){
              final GameInteraction interactionInfo = GameInteraction(cfgID);
              final GameInteractionType interactionTypeInfo = interactionInfo.type;

              final List<Field> children = [];

              children.add(Field<String, GameInteractionType>(
                key: "ia_interaction_type",
                value: interactionTypeInfo,
                stringValue: interactionTypeInfo.stringData,
                isTranslateValue: interactionTypeInfo.hasTranslation,
              ));

              if(interaction case {
                "LocX": num x,
                "LocY": num y,
                "LocZ": num z,
              }){
                children.add(Loc3(x: x, y: y, z: z));
              }

              if(interaction case {
                "RotYaw": num yaw,
                "RotPitch": num pitch,
                "RotRoll": num roll,
              }){
                children.add(Rot3(yaw: yaw, pitch: pitch, roll: roll));
              }

              if(interaction case {
                "ScaleX": num x,
                "ScaleY": num y,
                "ScaleZ": num z,
              }){
                children.add(Scale3(x: x, y: y, z: z));
              }

              res.add(Field<GameInteraction, dynamic>(
                key: interactionInfo,
                stringKey: interactionInfo.stringData,
                isTranslateKey: interactionInfo.hasTranslation,
                children: children,
              ));
            }
          }
        }
      }
    }

    return res;
  }

  static Field parseCarrierData(dynamic socialPhotoJson){
    const Field noCarrierField = Field<String, String>(
      key: "ia_carrier",
      value: "ia_state_false_3",
      isTranslateValue: true,
    );

    if(socialPhotoJson is! Map) return noCarrierField;

    if(socialPhotoJson case {
      "CarrierInfo": Map carrierInfoJson
    }){
      if(carrierInfoJson case {
        "ConfigObjID": int configObjID,
      }){
        final GameCarrier carrierInfo = GameCarrier(configObjID);

        final List<Field> children = [];

        if(carrierInfoJson case {
          "LocX": num x,
          "LocY": num y,
          "LocZ": num z,
        }){
          children.add(Loc3(x: x, y: y, z: z));
        }

        if(carrierInfoJson case {
          "RotYaw": num yaw,
          "RotPitch": num pitch,
          "RotRoll": num roll,
        }){
          children.add(Rot3(yaw: yaw, pitch: pitch, roll: roll));
        }

        if(carrierInfoJson case {
          "ScaleX": num x,
          "ScaleY": num y,
          "ScaleZ": num z,
        }){
          children.add(Scale3(x: x, y: y, z: z));
        }

        return Field<String, GameCarrier>(
          key: "ia_carrier",
          value: carrierInfo,
          stringValue: carrierInfo.stringData,
          isTranslateValue: carrierInfo.hasTranslation,
          children: children,
        );
      }
    }

    return noCarrierField;
  }

  const NikkiInfo._({
    super.key = "ia_nikki_info",
    super.expand,
    super.children,
  });

  factory NikkiInfo.fromGameJson({
    String key = "ia_nikki_info",
    bool expand = true,
    dynamic socialPhotoJson,
  }){
    return NikkiInfo._(
      key: key,
      expand: expand,
      children: parse(socialPhotoJson),
    );
  }
}

class MomoInfo extends Field{
  static List<Field> parse(dynamic socialPhotoJson){
    final List<Field> res = <Field>[];

    if(socialPhotoJson is! Map) return res;

    if(socialPhotoJson case {
      "DaMiaoInfo": Map daMiaoInfoJson,
    }){
      if(daMiaoInfoJson.isNotEmpty){
        res.add(Field<String, String>(
          key: "ia_momo_hidden",
          value: "ia_state_false_5",
          isTranslateValue: true,
        ));

        if(daMiaoInfoJson case {
          "LocX": num x,
          "LocY": num y,
          "LocZ": num z,
        }){
          res.add(Loc3(x: x, y: y, z: z));
        }

        if(daMiaoInfoJson case {
          "RotYaw": num yaw,
          "RotPitch": num pitch,
          "RotRoll": num roll,
        }){
          res.add(Rot3(yaw: yaw, pitch: pitch, roll: roll));
        }

        if(daMiaoInfoJson case {
          "ScaleX": num x,
          "ScaleY": num y,
          "ScaleZ": num z,
        }){
          res.add(Scale3(x: x, y: y, z: z));
        }

        if(daMiaoInfoJson case {
          "ClothIDS": List clothIDSJson,
        }){
          final List<Field> clothesFields = [];

          for(final dynamic clothes in clothIDSJson){
            if(clothes is int){
              final GameClothes clothesInfo = GameClothes(clothes);
              final GameMomoClothesType clothesTypeInfo = GameMomoClothesType(clothesInfo.type);

              clothesFields.add(Field<GameMomoClothesType, GameClothes>(
                key: clothesTypeInfo,
                stringKey: clothesTypeInfo.stringData,
                isTranslateKey: clothesTypeInfo.hasTranslation,
                value: clothesInfo,
                stringValue: clothesInfo.stringData,
                isTranslateValue: clothesInfo.hasTranslation,
              ));
            }
          }

          res.add(Field<String, String?>(
            key: "ia_momo_clothes",
            value: clothesFields.isEmpty ? "ia_state_false_1" : null,
            isTranslateValue: true,
            children: clothesFields,
          ));
        }
      }
    }

    if(res.isEmpty){
      res.add(Field<String, String>(
        key: "ia_momo_hidden",
        value: "ia_state_true_5",
        isTranslateValue: true,
      ));
    }

    return res;
  }

  const MomoInfo._({
    super.key = "ia_momo_info",
    super.expand,
    super.children,
  });

  factory MomoInfo.fromGameJson({
    String key = "ia_momo_info",
    bool expand = false,
    dynamic socialPhotoJson,
  }){
    return MomoInfo._(
      key: key,
      expand: expand,
      children: parse(socialPhotoJson),
    );
  }
}









/// data

// 可算参数
// 变焦
// 1700 → 0.5x
// 700 → 4.0x
// 计算公式:
// zoom = -0.0035 × distance + 6.45
// distance = (6.45 - zoom) / 0.0035
// distance = sqrt((nikkiLoc - cameraActorLoc) ** 2)

// 未储存数据：
//  辅助线 开关
//  NPC 开关
//  收集物 开关
//  祝福闪光 开关
//  动态动作的帧
//

// 部分任务过场自动拍摄图为 {}
const nikkiPhotoTemplate = {
  "SocialPhoto": {
    // 使用巨大化套装能力后为 true
    "GiantState": false,
    // 时间段
    // 天气

    // 相机位置

    // 竖构图 (int 0 - 1)
    // 焦距调节 (int 10mm - 55mm)
    // 镜头旋转 (int -180 - 180)
    // 光圈调节 (f/1.2 - f/16)

    // 晕影调节 (int 0% - 100%)
    // 柔光强度 (int 0% - 100%)
    // 柔光范围 (double_1 -1.0 - 1.0)
    // 亮度 (int 0% - 100%)
    // 曝光 (double_1 -1.0 - 1.0)
    // 对比度 (int 0% - 100%)
    // 饱和度 (double_1 -1.0 - 1.0)
    // 自然饱和度 (double_1 -1.0 - 1.0)
    // 高光 (double_1 -1.0 - 1.0)
    // 阴影 (double_1 -1.0 - 1.0)

    // 灯光类型 (String id ? "None")
    // 灯光强度 (int 0% - 100%)

    // 滤镜类型 (String id ? "None")
    // 滤镜强度 (int 0% - 100%)
    "CameraParams": "wSoYagilRTGn59TK6BNwo+xEPu0mn+L8s/HoByEkxNN0Bv7zwgkF6PqR9f4/gvD3A1sOSkXEdMajkRi09QeWT9aUkiecBDB2PXKNbSko14bdZV5D9g3+0N1MBiazNt9VEPeuzLPwGnDBu8Ji1Xns2w8S0L0AcUIv1lChd6x95/vwiiVI9QiLXugxzKOeWP2Xiwn+PjYfCesg9yo8dv8bTQ==",
    // 打开相机的游戏时间
    // 7:00 - 19:59 日间
    // 20:00 - 21:59 黄昏
    // 22:00 - 2:59 深夜
    // 3:00 - 3:59 日出
    // 4:00 - 6:59 清晨
    "Time": {
      "day": 1230017,
      "hour": 7,
      "min": 4,
      "sec": 49.304548740387
    },
    "PhotoInfo": {
      "cameraComponentRotYaw": -33.98800137192,
      "cameraComponentRotPitch": -17.855100631714,
      "nikkiLocZ": -13773.199372023,
      // “隐藏暖暖”
      "nikkiHidden": false,
      "cameraActorRotYaw": -33.98800137192,
      "cameraActorLocZ": -13608.885424295,
      "nikkiRotRoll": 0,
      // 焦距（mm） 8mm
      "cameraFocalLength": 8.7088031768799,
      "cameraComponentLocY": -62559.248185982,
      "nikkiLocX": -51253.037119155,
      // 决定 “滤镜” 的强度
      // 0 -> 0%
      // 1 -> 100%
      "filterStrength": 1,
      // "晕影调节" (暗角强度)
      // 0 —> 0%
      // 1 -> 100%
      "vignetteIntensity": 0.40000000596046,
      // “滤镜”
      //  清新
      //    薄雾 -> Fresh_001
      //    粉樱 -> Fresh_002
      //    奶油 -> Fresh_003
      //    暖阳 -> Fresh_004
      //    晴日 -> Fresh_005
      //  氛围
      //    暮色 -> Weather_001
      //    月白 -> Weather_002
      //    夜雨 -> Weather_003
      //    融雪 -> Weather_004
      //    夜河 -> Vibe_009
      //  风格
      //    复古胶片 -> Vibe_001
      //    悠然海岸 -> Vibe_002
      //    夏日午后 -> Vibe_003
      //    曼妙珠光 -> Vibe_004
      //    红蓝交响 -> Vibe_005
      "filterId": "None",
      "cameraActorRotRoll": -4.7382173564109e-8,
      // 由"光圈调节"决定
      // 1 -> f/1.2
      // 2 -> f/1.4
      // 3 -> f/2
      // 4 -> f/2.2
      // 5 -> f/2.5
      // 6 -> f/2.8
      // 7 -> f/3.2
      // 8 -> f/3.5
      // 9 -> f/4
      // 10 -> f/4.5
      // 11 -> f/5
      // 12 -> f/5.6
      // 13 -> f/8
      // 14 -> f/11
      // 15 -> f/16
      "apertureSection": 15,
      "cameraActorLocY": -62559.248185982,
      // 决定 “灯光” 的强度
      // 0 -> 0%
      // 1 -> 100%
      "lightStrength": 0.5,
      "cameraComponentLocX": -51624.502238339,
      // 外观形象
      // 10位
      // 3b -> 102
      // 1b -> 服装状态
      //    服饰
      //        进化 0 -> 0进, 2 -> 换新, 3 -> 1进, 4 -> 2进, 5 -> 3进
      //    饰品
      //
      //    妆容-肤色
      //        不保存该数据(0 -> 无)
      //        1 -> 浓情夜宴
      //        2 -> 暮色倒影
      //        3 -> 雪上月华
      // 2b -> 类型
      //    发型 10
      //    连衣裙 90
      //    外套 20
      //    上衣 30
      //    下装 41
      //    袜子 50
      //    鞋子 60
      //    饰品-发饰 71
      //    饰品-帽子 72
      //    饰品-耳饰 73
      //    饰品-颈饰 74
      //    饰品-腕饰 75
      //    饰品-项圈 76
      //    饰品-手套 77
      //    饰品-面饰 92
      //    饰品-胸饰 93
      //    饰品-挂饰 94
      //    饰品-背饰 95
      //    饰品-戒指 96
      //    饰品-臂饰 97
      //    饰品-手持物 78
      //    饰品-肤绘 79
      //    妆容-全妆 不保存该数据(80) 底妆+眉妆+睫毛+美瞳+唇妆 同一套装
      //    妆容-底妆 81
      //    妆容-眉妆 82
      //    妆容-睫毛 83
      //    妆容-美瞳 84
      //    妆容-唇妆 85
      //    妆容-肤色 86
      // 4b -> 套装id
      //    0042 -> 初始
      "nikkiClothes": [
        1021920002,
        1021920028,
        1020810353,
        1020200353,
        1020830353,
        1020840353,
        1020850353,
        1023860042,
        1020600353,
        1020300353,
        1020710353,
        1020100353,
        1020410353,
        1020740353,
        1020730353,
        1020720353,
        1020820353,
        1020790353
      ],
      // 手持物
      "nikkiWeaponTagName": "Weapon.State.Open",
      // 灯光
      // 默认 -> None
      //  方向补光
      //    侧光-左 -> DirectionLight_L
      //    侧光-右 -> DirectionLight_R
      //    顶光 -> DirectionLight_T
      //    底光 -> DirectionLight_B
      //  色相边光
      //    柔黄-左 -> HueEdgeLight_001_L
      //    柔黄-右 -> HueEdgeLight_001_R
      //    月蓝-左 -> HueEdgeLight_002_L
      //    月蓝-右 -> HueEdgeLight_002_R
      //    明紫-左 -> HueEdgeLight_003_L
      //    明紫-右 -> HueEdgeLight_003_R
      //    轻粉-左 -> HueEdgeLight_004_L
      //    轻粉-右 -> HueEdgeLight_004_R
      //  氛围灯光
      //    轻白边光 -> VibeLight_001
      //    梦幻虹光 -> VibeLight_002
      //    绚丽极光 -> VibeLight_003
      //    柔纱波光 -> VibeLight_004
      "lightId": "None",
      "nikkiScaleZ": 1,
      "cameraComponentRotRoll": 1.6707490187346e-15,
      "nikkiScaleY": 1,
      "cameraActorLocX": -51624.502238339,
      "cameraComponentLocZ": -13608.885424295,
      "nikkiScaleX": 1,
      // 祝福闪光
      // 将“祝福闪光”设置为关，也会有该数据
      // x位
      // ?b -> 套装id
      // 1b -> 部位
      //    1 -> 头部
      //    2 -> 手部
      //    3 -> 脚部
      // 1b -> 等级
      //    1 -> 未满级
      //    2 -> 3星满级
      //    3 -> 4星满级
      //    4 -> 5星满级
      // 1b -> 颜色
      //    3星 -> 1
      //    4星 -> 1-3
      //    5星 -> 1-5 (5 -> 彩色)
      "magicballColorIds": [
        19141,
        19341,
        12244
      ],
      // 服饰染色数据
      // 没数据时 "nikkiDIY": {}
      "nikkiDIY": [
        /// 服装虹染
        // 头发系列
        {
          // 区域 x
          "TargetGroupID": 1,
          "CoreData": {
            "TargetColor0": {
              "R": 0.062568999826908,
              "B": 0.25274699926376,
              "A": 1,
              "G": 0.082763999700546
            },
            // 颜色id
            "ColorGridID0": 17,
            // 粗糙度
            // 游戏里以光泽度显示
            // 转换关系 Glossiness = 1−Roughness
            "RoughnessOffset": 0,
            "ColorGridID1": -1,
            // 颜色混合模式 (可能没有 ? 无法调节光泽度时)
            "HairColorMode": 1
          },
          "FeatureTag": 6,
          "TargetClothID": 1023100128
        },
        /// 连衣裙 / 外套 / 上装 / 下装 / 袜子 / 鞋子 / 饰品 系列
        {
          // 染色区域
          // ! 游戏里的区域由 TargetGroupID 与 FeatureTag 配合决定
          "TargetGroupID": 1,
          "CoreData": {
            "B": 0.31389200687408,
            // 颜色id
            // -1 -> 自选色盘
            // 1 - 8 -> 飞球果飘飘 色盘
            // 9 - 16 -> 春日满满星 色盘
            // 17 - 24 -> 星光果之梦 色盘
            // 25 - 32 -> 眼影鱼碎闪 色盘
            // 33 - 40 -> 围兜暖毛球 色盘
            // 41 - 48 -> 星夜时光树 色盘
            // 49 - 56 -> 崖上的壁灯 色盘
            // 57 - 64 -> 风铃子腹语 色盘
            // 65 - 72 -> 风絮草飘飞时 色盘
            // 73 - 80 -> 雨夜路灯花 色盘
            // 81 - 88 -> 耳坠萤未眠 色盘
            // 89 - 96 -> 碧波裙摆湖 色盘
            // 97 - 104 -> 星荧草来信 色盘
            // 105 - 112 -> 丝巾蛾魅影 色盘
            // 113 - 120 -> 花伞藤萝之雨 色盘
            // 121 - 128 -> 兔耳草嫩蕊 色盘
            // 129 - 136 -> 裙撑萤之歌 色盘
            // 137 - 144 -> 名流鸦盛宴 色盘
            "ColorGridID": 21,
            "R": 0.13599300384521,
            "A": 1,
            "G": 0.17677299678326
          },
          // 部位特征
          "FeatureTag": 1,
          "TargetClothID": 1020900154
        },

        /// 特效调色
        {
          "TargetGroupID": 1,
          "CoreData": {
            "ColorGridID": 17,
            // false -> 多彩调色
            // true -> 单彩调色
            "CoverDIYColor": true
          },
          "FeatureTag": 7,
          "TargetClothID": 1025900128
        },

        /// 织纹绘制
        {
          "TargetGroupID": 1,
          "CoreData": {
            // 纹理id
            "ReplaceTextureID": 1330020020,
            // 可能没有, 默认false
            // false -> 取消底色
            // true -> 应用底色
            "OverridePatternA": false
          },
          "FeatureTag": 2,
          "TargetClothID": 1021300051
        },
        // 使用 织纹绘制 后才可能有该数据段
        // 没有时默认 "密度调节" 为 1.0
        {
          "TargetGroupID": 1,
          "CoreData": {
            // 密度调节
            "TilingData": 1.47
          },
          "FeatureTag": 5,
          "TargetClothID": 1021300051
        }
      ],
      "nikkiRotPitch": 0,
      "nikkiRotYaw": -34.310001373291,
      "nikkiLocY": -62809.69140625,
      // “动作”
      "poseId": 0,
      // 由 “镜头旋转” 决定
      "cameraActorRotPitch": -10.367793084871
    },
    "LocalTransforms": "D7000000000000000000000000000000000000000000000000000000000000000000F03F000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03FC1F46FFA94A6E6BF7D7EF93B46B9A5BFFC69DB9AC865E6BF241BCA7BD9D5B53F0000004053E4C4BF000000009E87C93F000000E016A85940000000000000F03F000000000000F03F000000000000F03F50334BDEA08A893FC02EA9498AED70BF9E48E995BCE49FBFB67BCB7551FBEF3F030000E08F3621400C00004083CAF1BF40FFFFFF127AD33F000000000000F03F000000000000F03F000000000000F03F80F54ABD9E4066BF804243BDE87F763F8AA5D23C8B1D9A3F5EB71B7C2EFDEF3F0B0000A0DC6A1E400000000000000BBD00000000000008BD000000000000F03F000000000000F03F000000000000F03F0CC72094CF3071BFA0DF9AEE2830893F29996693663EA23F96A2EA091BFAEF3F000000E0CEAD1E4000000000000017BD000000000000E0BC000000000000F03F000000000000F03F000000000000F03FE8F45922362395BFE0162345CB26833F62F67C89AC0CA03F1A142693DEF9EF3F020000E00D0722400000000000000DBD000000000000F03C000000000000F03F000000000000F03F000000000000F03FD643A6E192FFB1BF0048841B96A2553F8C649F9DE562C4BFBCD4DC0AE482EF3F02000080751A21400000000000000EBD00000000000008BD000000000000F03F000000000000F03F000000000000F03F00909127623C283F4043C3AE6E1971BFBACF832D5456823F9855BE9F99FFEF3F1600008025C40C40000000007483CEBD00009080134ADEBE000000000000F03F000000000000F03F000000000000F03FC08E218A9EA4323F0080AB9D40440D3F0013A39E0E717C3F42BD765ACDFFEF3FF1FFFF9F25C40C4000000000006C5DBD000000000000E4BC000000000000F03F000000000000F03F000000000000F03F3AF6F348F4FB783FC090D788B7AC98BFC39DBD251D05A03F003975EB74F9EF3FF5FFFF5FE3D60940000000000000003D00000000000003BD000000000000F03F000000000000F03F000000000000F03F1EE0FCF856A8E03FF896AFD8EE5FE1BF93B0CB13D6FDDC3F535A1B13BAA0DE3F080000C094901D400F000020285B24C030000020C550F4BF000000000000F03F000000000000F03F000000000000F03F2721B50266EFE13F3A5FC0C2DE39E2BF15790C64C2D1DA3F584F2A446797DB3FFCFFFF9FB2A11E400C0000E025AB23C01C000000B14205C0000000000000F03F000000000000F03F000000000000F03F18DDB0C11FEFE23F2B7CB641122EE3BFB0F02462ED02D83F7479368245C7D83F0A0000406BAF1E400F0000401D8B22C0220000204AEB0FC0000000000000F03F000000000000F03F000000000000F03F61861203BBA1E33FEA5328E30B2DE4BFFED23443E57CD43FC68585A38A80D63FFBFFFF9F71861D400A000000CBDD20C0070000E0988014C0000000000000F03F000000000000F03F000000000000F03F2210E670BBFDDC3F8F053DCEEAA0DEBF9AB9EF0465A8E03F6BAFC503D75FE13F020000C057901D400C0000205E5D24C0E0FFFFFF4555F43F000000000000F03F000000000000F03F000000000000F03F8012A2DDA2D1DA3F9399909D9C97DBBF0CC86A9E71EFE13F493864BECA39E23FFDFFFF7F8FA11E40060000E00FAC23C0F0FFFF7FD6440540000000000000F03F000000000000F03F000000000000F03FA8601583CC02D83F1CA32E237EC7D8BF327A6E222AEFE23FF48B7602002EE33FFEFFFFBF43AF1E400E0000A0628B22C0F2FFFF5FDFEC0F40000000000000F03F000000000000F03F000000000000F03F2895F35AC37CD43FAE6D749AC480D6BF528C29FBC3A1E33FFC3D079BFB2CE43F0600000040861D400B000060D8DD20C0FEFFFFDF30811440000000000000F03F000000000000F03F000000000000F03F6465CD25E438DF3FDD420B033161E0BF6565CD25E438DF3FDF420B033161E03FF8FFFF1F87901D400B000020618B24C000C0FEBF6640313F000000000000F03F000000000000F03F000000000000F03F599EFE97FBFFDF3F729EFE37FBFFDFBF984CFF1B0800E03FFE9EFEF7F8FFDF3FF4FFFF1F23141440090000406D3D15C010000040F0C306C0000000000000F03F000000000000F03F000000000000F03F82D994A6FF80D93F3CB135A748F0DBBF3DF69704FFCCE13F67D1D22412B1E23FFEFFFF1F012A13400B000060EA2521C01C00000086FDFCBF000000000000F03F000000000000F03F000000000000F03FCEFA0DC11C8FE03F3A62B8E1B902DBBF48002881B027E23F8AD7F6816BD7DE3F02000020769F1640080000E0F18821C012000020D5B403C0000000000000F03F000000000000F03F000000000000F03F8EF81E86C921E33FAD66364AADEBDFBF50AE2105180AE03F6218BB87F029D83F0E000040243617400D000060D95421C0180000809EC20CC0000000000000F03F000000000000F03F000000000000F03F828246A1A166E43FBB488123A4EBE2BFCC2A9E9A4DD2D83F780D85021F93D33F0F00000019E615400A000060177820C00E0000A0777112C0000000000000F03F000000000000F03F000000000000F03FC04FC8C16750E43FC7B5DE41AC4FE5BF2A55AB62AD6BCE3F8AC0BF61DBEED33F0A00002092941240110000C00DAC1EC00A0000E04E9014C0000000000000F03F000000000000F03F000000000000F03F9CB9ED804AD3E13F97DF19C1BF22E5BF1885D7400C29D03FB2BE73A1E4DFDB3F04000040172710400B0000E0EE1420C00500002014F611C0000000000000F03F000000000000F03F000000000000F03F0314589884A5DD3F0C8BE91A94B3E3BF1483409A2042D63FD3CE95FB8118E13F130000000F1E0F40080000A002D520C00800000032CE0BC0000000000000F03F000000000000F03F000000000000F03F78C8169F6697D83FD29E5D5F3C1FE1BF4B67E7BE5A96DD3F35DC4BBFA6FEE23F060000E0554D10400B000080140721C00C0000002D3403C0000000000000F03F000000000000F03F000000000000F03F37A4FE67FBFFDF3F3EA4FE87FBFFDFBFB154FF030800E03FA0A3FE07F9FFDF3F10000060081414400E000000743D15C0F8FFFF3FEFC40640000000000000F03F000000000000F03F000000000000F03FF451BF19F4CCE13FF3296F3926B1E2BF62930A371E81D93F7AC12FD612F0DB3FFDFFFF1FF02913400C000080EC2521C0F4FFFF5F5CFFFC3F000000000000F03F000000000000F03F000000000000F03F46C4BAB8F527E23FA118A6530ED8DEBF1F9D5E19CB8EE03F5C542F150E02DB3F0A0000205F9F16400A000020E08821C0F9FFFF7F0BB40340000000000000F03F000000000000F03F000000000000F03F25E4D1C8650AE03F38EA49CD042BD8BF86DC84EA7821E33FC3CD8C1101EBDF3F0A000080023617400B000040255521C0FAFFFF3F12C20C40000000000000F03F000000000000F03F000000000000F03F9CD3DA86CED2D83FE81568253B94D3BFC028A2E58866E43F4C6F39054BEBE23F0D000080EDE515400B0000E0937820C0000000E021711240000000000000F03F000000000000F03F000000000000F03FF520B334676BCE3FE24B985819EFD3BFEC2374B86D50E43F965715589E4FE53F030000E061941240110000001AAC1EC002000040C5901440000000000000F03F000000000000F03F000000000000F03F044D3B427B29D03F8D75D963E7E0DBBF060F76A204D3E13F4D16EB229022E53FF6FFFFDFEC261040090000800D1520C00500006031F61140000000000000F03F000000000000F03F000000000000F03F28A145641043D63FD07CB42ADA18E1BFF2B6133BF3A4DD3F717E76873AB3E33FFBFFFFBFCD1D0F400D0000E046D520C003000000A0CD0B40000000000000F03F000000000000F03F000000000000F03F9B687E1AB296DD3F7707777C06FFE2BFD1A66C1B7496D83F065BD07C031FE13FFEFFFF3F3F4D10400A000020DF0621C0FAFFFF5FB6330340000000000000F03F000000000000F03F000000000000F03F0AD7051D4CE4D33FDECF051D7CE4D3BF2B44F57C0853E43FE445F5FCFC52E43FA00000A0C70BD53F100000602BBF1DC0070000002B8F1240000000000000F03F000000000000F03F000000000000F03FABF6CD8973B6D03FAC96160B9FE6D2BFC973FAEB086BE43FA5A36A6C442AE53F120000A02B80054013000040AE5E1DC0060000C05DAF1540000000000000F03F000000000000F03F000000000000F03F571FE85FEF6AD83F2C1FE85F1C6BD8BFD05EEDBF130DE33FDF5EED7F050DE33F28FFFF7F57D1DDBF080000C0742E21C009000080E9410540000000000000F03F000000000000F03F000000000000F03F7F6B9C5F5011E03F1F853A9F39DDDFBF7F6B9C5F5011E03F21853A9F39DDDF3F1700008072780540070000C0DE8322C0F8FFFFDF6ECDFE3F000000000000F03F000000000000F03F000000000000F03F8527FAFFF1FFDF3FBF13FDBF0B00E0BFBF13FDFF0600E03F8127FA7FE8FFDF3F52000040C760EDBF0A000040EE1822C000E00000F13B203F000000000000F03F000000000000F03F000000000000F03F1E1EFA07F2FFDF3FBD13FDC30B00E0BF9012FD030700E03FC01BFA67E8FFDF3F7CFFFFFF0DCDD7BF080000C0A07022C000180000E870303F000000000000F03F000000000000F03F000000000000F03F50741FE0FF52E43F63741F600B53E4BF34C91E6070E4D33FE8C81E4040E4D33F40FFFF7F140ED53F1400006020BF1DC0060000007F8E12C0000000000000F03F000000000000F03F000000000000F03F380D70E7016BE43FD7BDB507522AE5BFD49116E696B6D03F437CE22661E6D23FF6FFFFDF7D81054010000000D2581DC00E0000C06DA915C0000000000000F03F000000000000F03F000000000000F03F358CE61F090DE33F238CE65F170DE3BF7C60DFFF106BD83FB860DF1FE46AD83FA00000E0CACFDDBF0C0000804A2E21C0040000A0294105C0000000000000F03F000000000000F03F000000000000F03F7F6B9C5F5011E03F1F853A9F39DDDFBF7F6B9C5F5011E03F21853A9F39DDDF3F010000A0967805400C000080DC8322C012000020EECBFEBF000000000000F03F000000000000F03F000000000000F03FE6AFF2D87537E53FE1ACF2F87E37E5BF7B2C8B557E75CF3F854D8BF51A75CF3F6CFFFF3F7D97DEBF09000060D4AA21C0060000A0EC84F9BF000000000000F03F000000000000F03F000000000000F03F158C4AC06179E33F4BC64B2076CBE3BF3CB55600A3A6D63FDC7A55608254D63FB2FFFF5F4F0FD6BF0E000060F36122C0040000A00B70F2BF000000000000F03F000000000000F03F000000000000F03F4AD413E3BAC8E13F7F4B17E3C1DCE1BFB2DAD00474D4DB3FC256D5845EEEDB3FAA0000404331D2BF090000C07BD222C0000000A0B311E3BF000000000000F03F000000000000F03F000000000000F03FB59D8C3AC6EADF3F1AB042DD950AE0BFB99D8C3AC6EADF3F1AB042DD950AE03F4AFFFFDFE28BCEBF0D0000809DF522C0004000404511213F000000000000F03F000000000000F03F000000000000F03F8FC3B6A455D4DB3FB83BBB64B8EEDBBF802D0323C7C8E13FDC8906639EDCE13F7A0000809D31D2BF0B0000807CD222C00B000060D313E33F000000000000F03F000000000000F03F000000000000F03F9F102B9B7CA6D63F46723C9B0155D6BF6C84D81B6179E33F1807C7DB5DCBE33F400000200410D6BF0B0000C0F46122C00C000040DA71F23F000000000000F03F000000000000F03F000000000000F03F83281E453475CF3FA5381E659775CFBF07A373C37C37E53F80A173637337E53F44FFFF7F9D98DEBF050000C0C7AA21C00A0000404E88F93F000000000000F03F000000000000F03F000000000000F03F46B6734380E4E33F84A473A38CE4E3BFE6800C812F91D53F58C40C810091D53F300000407906DFBF0A0000E0E8A821C0050000201A8AF9BF000000000000F03F000000000000F03F000000000000F03F84DFF5245946E23FB528A1449A7FE2BFF1C7BC782889DA3F8C673659F536DA3F15000020AE89E7BF0B000040D61C22C0FFFFFFFFEFF1F1BF000000000000F03F000000000000F03F000000000000F03F9EF6059E4DFCE03F9AF4051E5FFCE0BFC33C857C33E6DD3F7F4185BC0AE6DD3FC7FFFFFF0B83ECBF0C000000075C22C0FBFFFFFF1870E2BF000000000000F03F000000000000F03F000000000000F03F65380CE47908E03F56D90FA8EBEEDFBF68380CE47908E03F41E50FC81AEFDF3F9DFFFF1FF175EDBF07000080FE6D22C0004001A04F281F3F000000000000F03F000000000000F03F000000000000F03F57A44A5714E6DD3F86984AF73CE6DDBF157B0DBB5AFCE03F11800D9B49FCE03F490000803683ECBF0D000080075C22C016000000B973E23F000000000000F03F000000000000F03F000000000000F03F40EAF4F90789DA3FCF8E075A2C37DABFE483D69B6446E23FC480C91B877FE23F2C000040008AE7BF0B0000C0D11C22C00C0000C06EF4F13F000000000000F03F000000000000F03F000000000000F03F029EF6BE0C91D53FC49BF65E3B91D5BFF6360B9F89E4E33F94370BBF7CE4E33F600000C09907DFBF0D0000E0FDA821C007000000378DF93F000000000000F03F000000000000F03F000000000000F03F2745BE38AB4AD83FD1F54B3A6B17E3BFFE3FBE78BC4AD83F94FD4B3A5117E33F3D000020ACE0FB3F0E000080B2FB09C000C0FE1FC762293F000000000000F03F000000000000F03F000000000000F03FCFCF94376C68E23F4ECCF6333251DABFB0C794F77D68E23F76DFF6530851DA3F170000603E4AF93F0C0000C06FCA23C0EEFFFFDF7FD0D23F000000000000F03F000000000000F03F000000000000F03FCFCF94376C68E23F4ECCF6333251DABFB0C794F77D68E23F76DFF6530851DA3F2A0000C0494AF93F120000606FCA23C02800004039CBD2BF000000000000F03F000000000000F03F000000000000F03F66E9ED578B1CE43FC778ADB71FBDD4BF2AE1EDD79F1CE43F5387AD77FBBCD43FDDFFFF9F8C1CFD3F0C000060261826C00040FF1F6FF5243F000000000000F03F000000000000F03F000000000000F03F66E9ED578B1CE43FC778ADB71FBDD4BF2AE1EDD79F1CE43F5387AD77FBBCD43F15000040068B0F400A0000E0221223C000C0FDFFDED62A3F000000000000F03F000000000000F03F000000000000F03FC616B9865F7AEDBF2201AE054DE7D83F00000C4796F0DEBE00E8486707F11F3FE8FFFF9FF34FF0BF0C000080E8A618C0006000402D2D213F000000000000F03F000000000000F03F000000000000F03FA8983F3B0738E7BFE2657EDB2405E63F0000BF9B2CC3D4BE0000BE9B2CC3D43E77000080C7B2E3BF1400008012251CC000D00040FB9B213F000000000000F03F000000000000F03F000000000000F03F2AF0F32D2761E5BFEAB5E60B5DCFE73F0000BBF0D012D2BE00E47D32A300303FC6FFFF7FA6ADE2BF1700008080FE1EC0005000806643213F000000000000F03F000000000000F03F000000000000F03F26E13CCB0562E1BF7CF5E87FF2DDEA3F0000342226F4C8BE0068E3AC4D00303FA1FFFFFFC6F8E4BF0B00002080CB20C00020008026B6203F000000000000F03F000000000000F03F000000000000F03FC2A43A803CDFDDBFF08E3780EA4CEC3F000022E00C5CC2BE000020E00C5CC23EFDFFFF5F8757ECBF050000A00BE321C000C001A028B21F3F000000000000F03F000000000000F03F000000000000F03FFE12ECC1D8B9D9BF4116EC6104BAD93F741264819D9DE2BF551164618E9DE2BFC8FFFFFF7A61F03F08000060329922C0080000402321FF3F000000000000F03F000000000000F03F000000000000F03FAB080A43929DE23F1E0B0A43A19DE2BF443C3364F9B9D93F1D3533A4CDB9D93FFBFFFF7FC361F03F0C000000329922C00C000040481EFFBF000000000000F03F000000000000F03F000000000000F03F8527FAFFF1FFDF3FBF13FDBF0B00E0BFBF13FDFF0600E03F8127FA7FE8FFDF3F08000000599200C011000060D6EA1AC0000003C0FFBD1C3F000000000000F03F000000000000F03F000000000000F03F8527FAFFF1FFDF3FBF13FDBF0B00E0BFBF13FDFF0600E03F8127FA7FE8FFDF3F00000000D2CBFEBF070000605BC621C0000002408DE11A3F000000000000F03F000000000000F03F000000000000F03F1E1EFA07F2FFDF3FBD13FDC30B00E0BF9012FD030700E03FC01BFA67E8FFDF3F89000000F9B4D93F0F00000010C423C000DEFF7F0951223F000000000000F03F000000000000F03F000000000000F03F0E1B7181A72EDABF6E1D71C1D22EDA3F1B2F0401BA74E2BF422E0481AA74E2BF060000407020184009000060400422C0F6FFFF5F06F70140000000000000F03F000000000000F03F000000000000F03F3242B3A037BDDABF4F43B38062BDDA3F06627A205941E2BF9F617A604941E2BF0A000000488A18400B0000E0B86821C0F9FFFFBFC5FA0D40000000000000F03F000000000000F03F000000000000F03F2C4FCF9C82E2D5BF6648CF1CB1E2D53F02E61C3D3FCEE3BFE9E71C3D32CEE3BFFEFFFFFF56781640120000C0F8DB1FC000000060DF3C1440000000000000F03F000000000000F03F000000000000F03F644AB881AE74E23FD14BB8C1BD74E2BFEEA070E2C72EDA3FE49C70829C2EDA3F12000060852018400A0000C03D0422C0100000E019F601C0000000000000F03F000000000000F03F000000000000F03FC85121644D41E23F515521045D41E2BF91BC0CC657BDDA3FD5B20CC62CBDDA3F0C0000406B8A18400B000060B46821C018000080C7F90DC0000000000000F03F000000000000F03F000000000000F03FC05DED9835CEE33F3559ED5842CEE3BFF9392F78A5E2D53FA24A2FD876E2D53FFBFFFF7F86781640140000C0ECDB1FC0090000E05B3C14C0000000000000F03F000000000000F03F000000000000F03F9FF7929E9BE5E33F25317C1E6923E5BF59C5D77E8825D03F3DA1747EEE8CD53FFFFFFFBF7A8F1A40160000E086CE1DC00C0000C0D77817C0000000000000F03F000000000000F03F000000000000F03F068747DB6525D03FC1F4B2592C8DD5BF2AC92EDAA1E5E33F12E5D1195A23E53FFAFFFF7F438F1A40150000C094CE1DC0FBFFFF5F61791740000000000000F03F000000000000F03F000000000000F03F6CA46419B697E23F0D9F6439C597E2BF9AAAD516E7CAD93F24BAD556BBCAD93F1E0000E07B51FC3F0A000080771321C00E00006052AF0EC0000000000000F03F000000000000F03F000000000000F03F8F2A765BC6CAD9BFE42276FBF1CAD93F6F77BA7CC197E2BF1C7ABA3CB297E2BF140000E0FB50FC3F0B0000207C1321C00600008005B00E40000000000000F03F000000000000F03F000000000000F03F1E1EFA07F2FFDF3FBD13FDC30B00E0BF9012FD030700E03FC01BFA67E8FFDF3F08000080366B1C4006000000D271EEBF0080FD5F37AB333F000000000000F03F000000000000F03F000000000000F03F637D743FA033E03FA101F0DE5896DFBFB07FF13EFA69DF3F1FBB73DF2F4AE03F5D0000C01535E0BF0C000020078B22C00C000020555FE53F000000000000F03F000000000000F03F000000000000F03FCEF6B0CC07E8DF3F8FFE31E6F20BE0BFD0F6B0CC07E8DF3FC1FD3166F30BE03F4C0000E0C215E3BF0D00004075E722C000800020563E203F000000000000F03F000000000000F03F000000000000F03F6CDC7515306ADF3F80D988FA5D4AE0BF5F76901AAD33E03F6B4667D5A995DF3FA9FFFF5FE334E0BF0A000060068B22C000000020435DE5BF000000000000F03F000000000000F03F000000000000F03F667F52F5FB49DF3F3ECD6BFA0C59E0BF307652F5164ADF3F63D56B1AF558E03F07000060993F03C009000060619C21C00080032091B7183F000000000000F03F000000000000F03F000000000000F03FC501BA9C5E2FDDBF3CFDB91C872FDD3F98740F1E164BE1BF86760FDE044BE1BF13000080215E0B40080000C062DA20C0FEFFFF5FC0EC0B40000000000000F03F000000000000F03F000000000000F03F1796CBFF7C2FDD3F5D96CB3F542FDDBF8FF1E03F094BE1BF72F1E05F1A4BE1BF13000000635E0B400C0000A05EDA20C011000020EEEB0BC0000000000000F03F000000000000F03F000000000000F03F8527FAFFF1FFDF3FBF13FDBF0B00E0BFBF13FDFF0600E03F8127FA7FE8FFDF3FE4FFFF1FDCB3FDBF140000E0A08719C0110000800CF10D40000000000000F03F000000000000F03F000000000000F03F0F0FFD030700E0BFC45FFA87E8FFDF3FE94EFA27F2FFDF3FF806FDA30B00E03F200000604FB3FDBF13000000988719C0060000E093F00DC0000000000000F03F000000000000F03F000000000000F03F0C06270ACA37C53F8B78A31CA85BE73F6C6DFD3DABB5AF3F3B0C61AF6E20E53FF5FFFF3FF0CA1E40FCFFFF7F2487F2BF44000020B45EF7BF000000000000F03F000000000000F03F000000000000F03FDCC198F93360BC3F8A46C442BB3EDD3F24495A803129C4BF381671A2D6C9EB3FD4080010B83B244000289BE9764190BF20D02E6BAC6DB2BF000000000000F03F000000000000F03F000000000000F03F90E5612F96BACC3FEC6C1B20CBBFC53FD7083A7377A4E4BF2CBDAD3560BBE63F390500A0C73B3940C02DD39C7A84993F002333D35C64B13F000000000000F03F000000000000F03F000000000000F03F0192443F7124D43FFEED04D7E996B43F78CA0103457DB2BF14F5E0B11E2DEE3F9DC9CC9C02E137400075FF9138F4B13F80496776351CA73F000000000000F03F000000000000F03F000000000000F03FB73109824FBEE23FF487459EA153983FC5474321A213D0BF142A1EEAB8A5E83F0C000040103EE83FFCFFFFDF005001C0060000E0AF3EF4BF000000000000F03F000000000000F03F000000000000F03F945B18BD23C6AC3F0D8CD86FE812C33FA8133D1C97ED8C3FE5FBA5849D96EF3F040000E013CB0A40000000C058DFD43D00000000C0C8DA3D000000000000F03F000000000000F03F000000000000F03F0090638352CB2CBF24F7319BC612983F48456F7EE0A591BFC194A7C884FCEF3FFEFFFFFF43900340000000924D79353E000000000C89D33D000000000000F03F000000000000F03F000000000000F03F00D8FA9DAF203BBFF5E2B49EAC12D53F8025B454CA0781BF4DC727D9E436EE3FFFFFFFDFF4C51840FAFFFFBF1C76FFBF180000E03F60D2BF000000000000F03F000000000000F03F000000000000F03FA0EF43FA303C96BF502569E157FFD43F60EA511CB9F582BF34F334552438EE3FFEFFFFDF1174074000000000204DA4BD00000000E80FBA3D000000000000F03F000000000000F03F000000000000F03F305CA8CE2DF296BF5AD47CFC1841CF3F909C4879D3907EBF0E7916E6AE05EF3FF4FFFFFF634000400000000070409FBD00000000A030B23D000000000000F03F000000000000F03F000000000000F03F34E5537C9700A2BF4EEC06C2B591D93F481A00E33F9FA8BF4912F759F045ED3F000000E0850C1940D0FFFFFFCBFBD4BFA00000E0BF20C7BF000000000000F03F000000000000F03F000000000000F03FA0493B5414E88F3FFE71774B407CDD3F709E780A2D5B9CBF4441A6222962EC3F0A0000E063720A400000000040C5AEBD00000000F03FB03D000000000000F03F000000000000F03F000000000000F03FB04610D7C327A3BFC76A233704D6D83F254EBB9B28C97EBF304A52198B77ED3F0A00000082340240000000E05E6D2A3E000000000002A73D000000000000F03F000000000000F03F000000000000F03FAEDA86F802BBBABFCC719D47D570DA3F1C8BB2D974A4B3BFEADB5FEB4BD8EC3FF8FFFFDF499F1640FCFFFF5F68130440E2FFFFDFCF31EEBF000000000000F03F000000000000F03F000000000000F03FC8462EDA5620AABFB0F35C64DCE2DE3F40300942753A57BF92C2D00DB5FAEB3FFBFFFFDF9584054000000000409BAFBD000000000808B2BD000000000000F03F000000000000F03F000000000000F03FD836A199A4C17BBFA32FCB1A2484DD3F7335E3CA777989BF16332485D863EC3F130000E0F351F93F000000000026A9BD00000000E06DA5BD000000000000F03F000000000000F03F000000000000F03F8C97C9ACDE8CB2BF81A1BF737825DA3F2043FA65C552AEBFB66AC8CFC50DED3F020000E0311E1840040000C077FDF33F4E0000E0BFAFDABF000000000000F03F000000000000F03F000000000000F03F609858FC104884BF6A36F105111FE03F08E5680E674F90BF732DA7E5C8A2EB3F030000E09F180B40000000005042BABD0000000000C48CBD000000000000F03F000000000000F03F000000000000F03F282729711D9B813F97C70FB23973DE3F5D78DC38C6BA85BF3F3E99928224EC3FFDFFFFFF854C004000000050944246BE0000000080C680BD000000000000F03F000000000000F03F000000000000F03FF0E597454D7154BFC06F2DE816E38D3F6864F76550CEB53F600CB96858E1EFBFFBFFFFBF2D3DF63FF4FFFF7F537CF43F220000E0570BDCBF000000000000F03F000000000000F03F000000000000F03F0EC3143F7E91D1BFC9ADF45EE3F6E3BF2E2CDCDE6BCBE53F12CB1ADF2E1ED1BFFFFFFF5F372C1640F4FFFF5FF0A5D6BF08000080672F0BC0000000000000F03F000000000000F03F000000000000F03F60A0F77750F0633F995B1194250BB73F90C0CF46E0B196BF1ECE772FB3DCEF3FE7750A533DA6C4BF802BC374BAC67D3F6115D0C41DD4F03F000000000000F03F000000000000F03F000000000000F03FE0EB36E0DF255A3F4AC3CCA9A887AB3F200DDE6DDAC296BF23D40EA91CF2EF3F721DCF84E36BE1BF60FDFF4F09059D3FCC8A96699EAAFBBF000000000000F03F000000000000F03F000000000000F03F072BB69D45A6C43F009E78EA20CA46BF0075F0E0D6405A3F766B6122AF94EF3F080000D0AAE81F40000B00CEA900983F00FBFFEFD8DC8E3F000000000000F03F000000000000F03F000000000000F03F92E882F9EF5FD43F0070AB7359F63BBF006DC0D792C45B3FEB8F79B3C455EE3F9C999949C9CD2F400003004C71ECA73F80979919D9C29E3F000000000000F03F000000000000F03F000000000000F03F1016E6FA5FDB38BF00742C73E1314F3FD286CB821F11D63F8A12A535A509EE3F8F3C95BFBED7EB3F9A66D0DCD1E3ECBF001FFD4F8D40A9BF000000000000F03F000000000000F03F000000000000F03F0072B4E1F45F2EBF00B4FCFC37224B3FA4B8C8A537ADBB3F41635743FBCFEF3F87609779BDFF1F400CAF653EAE1508C0C0702D33E7FFACBF000000000000F03F000000000000F03F000000000000F03F5B432D9E5FDEC33F00FABFB4F48D54BF400F608438BF463F1AC57FEEB29CEF3F32333393D5CF204000CDCCBC52EF803F00D9CCEC572D973F000000000000F03F000000000000F03F000000000000F03F786ABA0171A1D33F00D10AA1609052BF00D83336D1D04C3F46B415C11C75EE3F72CECC64CED330400079A1A9CE12913F0024CFBCD03BA73F000000000000F03F000000000000F03F000000000000F03F002816E7B9AB113F00C06EC6BA46FE3EB4C18780D5AD97BFDC7BF538CFFDEFBF6A750470A2D1FC3FCD1833738C9809C0A0C9FD7F301DA4BF000000000000F03F000000000000F03F000000000000F03FFE795E161E9BA0BFD67D5DE0276DD9BF79B528B3BD75C03FE49C37C7D50EED3F6EDECB5C6FE2FFBFEA4EC2BC4D14DC3F94B400C01738FE3F000000000000F03F000000000000F03F000000000000F03FC347F9036EEDB5BFC8F4F9EA8853D0BF42DBC443D638C43F480F89C2F466EE3F74070E90EE36D1BF16669A49F7E20F400B2D6CEE7063DEBF000000000000F03F000000000000F03F000000000000F03F8EAC82C9FBFDBBBF1B5E046EE48DDDBFF22B380A3F1FB13FAE421268F715EC3F45F86596103316407949711C73C8E03F6B8F0090449906C0000000000000F03F000000000000F03F000000000000F03F0D77403214E3E73FBA3A489FA247C0BFE918454A8FE3E4BFF267246F0F9B963FF8FFFFFFEDCA1E40030000403A87F2BFD4FFFF9F195FF73F000000000000F03F000000000000F03F000000000000F03F427DD91D0540C13F528C16D53D53DF3FF03E497F3E0FB5BF0F55C97C9571EB3F40FBFF3FE52424C080BD3413FC918A3FE09364F6BA23B33F000000000000F03F000000000000F03F000000000000F03FF4B049E0D262C33F6359933208A2B93F0DE1ABB734E2E4BF3682DBA72C8AE73FDF34333B193539C080AEE34734169EBF0044C76C9705A9BF000000000000F03F000000000000F03F000000000000F03F45E5BC21291BD53F328119BECFDFC23F02BEB34BEACCC4BF098488DFE661ED3F3F3333EB98E237C000E7CC27605FAFBF003C3343783FA2BF000000000000F03F000000000000F03F000000000000F03FC9140491CD30E73F04EBF21480DF98BF74AE99AFE4D2CFBF1FC571BCBD8CE43FFAFFFF3F103EE8BF000000E000500140070000E0AF3EF43F000000000000F03F000000000000F03F000000000000F03FDCFC4655DC29A4BFD6D1E034E2EEC73F228198DF716D91BFEAFFDC67D967EF3F010000E013CB0AC000000000006D763D000000001079A63D000000000000F03F000000000000F03F000000000000F03F8061C09557EA1F3FD04A3ED553E0AE3FD094CBB280C78FBF1CE0042D1AF0EF3F04000000449003C000000020594735BE00000000905DA03D000000000000F03F000000000000F03F000000000000F03F246021A4A2CFAC3F118F32CC08BAC83F149E595506B3A0BFF93FFBD60354EF3F030000E0F4C518C0F1FFFFBF1C76FF3F420000E03F60D23F000000000000F03F000000000000F03F000000000000F03FEFD5F49E94E187BF0639AB0B9524DA3FA090B67C04D667BF351E0424BB34ED3FFEFFFFDF117407C000000000E0BE97BD0000000000C0743D000000000000F03F000000000000F03F000000000000F03F8018D85025BA0DBF5073D46AC0D4C43F00EC6AF47FE9253F96CA25E3C992EF3F07000000644000C000000000007F90BD00000000000C733D000000000000F03F000000000000F03F000000000000F03FC94C23ADABE6A1BFF103075242B5D53F4EF3A8992A1CA3BFCB68B83AF80EEE3F000000E0850C19C030000000CCFBD43F200000E0BF20C73F000000000000F03F000000000000F03F000000000000F03F0A71D2501152913F60925099B61EE03F2CB9AFD5468B9BBF185D80BCDE9FEB3FF2FFFFDF63720AC00000000020959BBD0000000000E0683D000000000000F03F000000000000F03F000000000000F03F285136ACA5FAA2BFA299F7A3314FDB3FE0E63A764F9782BFC687C01A28EAEC3FFBFFFFFF813402C000000000798B2ABE000000000046503D000000000000F03F000000000000F03F000000000000F03FE1092F4DEA31BDBFA4309FFFAAB8CC3F069CD600A07B8DBF826A175560F7EE3F020000E0499F16C0FEFFFF5F681304C0F0FFFFDFCF31EE3F000000000000F03F000000000000F03F000000000000F03FD0217F7A84FAA9BF5EDFC29DC1A9E13F4092A79ACD6E76BF842D673C32A2EA3F030000E0958405C000000000800C97BD00000000004077BD000000000000F03F000000000000F03F000000000000F03F809BB04CC71478BFB1585B739DCBE03F80FD456036648ABFF426B2A7FE3BEB3FF4FFFFDFF351F9BF0000000000A18CBD0000000000EA6FBD000000000000F03F000000000000F03F000000000000F03FE8678D2962C8B3BFA0413FD9D93FD63F629F34BD9F47ADBFB5D32A228CD8ED3F010000E0311E18C0F0FFFFBF77FDF3BFB0FFFFDFBFAFDA3F000000000000F03F000000000000F03F000000000000F03F9034A4DD647080BF5A62E32A2921E33F785606E5775491BFE4F8793C4CA5E93FFFFFFFDF9F180BC000000000C09C9EBD0000000000EA64BD000000000000F03F000000000000F03F000000000000F03FC075C1CBC20B843F2DE7FBCD7C77E23FC079568A657D83BF12D89A105621EA3F09000000864C00C0000000E08E39463E00000000801365BD000000000000F03F000000000000F03F000000000000F03F00EA97454D7154BF9C6F2DE816E38D3F7F64F76550CEB53F5F0CB96858E1EFBF080000C02D3DF6BF0A000080537CF4BF700000E0570BDC3F000000000000F03F000000000000F03F000000000000F03F154FE65B09B1D3BFB17181DB6D95E53F8964EB3B9F98E33F274B575C7092D13F000000A02C2C16C0E4FFFF1F6FADD63F060000A00D300B40000000000000F03F000000000000F03F000000000000F03FC0B8C55DD671643FCC24380F5012B63F06E1C42542B296BF17ED955973DFEF3FB621D8032391C63F001FDCDC9D417CBFBA339039A5AAEFBF000000000000F03F000000000000F03F000000000000F03F6017272889335B3F8D282C5BEA9AA93F666ABB9FF5C296BFBBB14E2BB6F3EF3F10AD626EA4FEE03F809833D3899B9CBF1277D1EC70BFFC3F000000000000F03F000000000000F03F000000000000F03F367CD6B0DA52C63F8054E019089F40BF6025A9E78BCF563FE7C107467182EF3F7166667682EB1FC0003233468AF694BF00A89921EC6288BF000000000000F03F000000000000F03F000000000000F03F222DA84596F9D53F0096751E2D0631BFC0139A0515E3573FB45B1BEAF30DEE3FDACCCCAC70CF2FC080DECC041BE4A4BF00D2CC647A4D98BF000000000000F03F000000000000F03F000000000000F03F00EA1CECF35335BF409D2304E47A563F84BDA9654E2CBB3F6ACDD76CB6D1EF3F667198B1F6A81FC0B9399949204E0840004101102120B63F000000000000F03F000000000000F03F000000000000F03F00313D8CDCA442BFC0F2D9C5441B573F3DA4C6489AA6D53FDB18EC9DFE1CEE3F46ACFD69BE75EBBF6DEB0190860CED3F7C9E9A710535B33F000000000000F03F000000000000F03F000000000000F03F46AE1A31027FBA3F00597A3B1B814DBF00792F256A5F463F00E67EB1FFD3EF3F9D999999B2C920C0406B66DE105584BF0000008C9CB890BF000000000000F03F000000000000F03F000000000000F03F968E41564F5DCA3FE06042292DF24ABF80A7A26B2364493FBDEC41FF5650EF3FD5CCCC9C39D030C000D2CC9CF85C94BF00D0CCEC1CBFA0BF000000000000F03F000000000000F03F000000000000F03F0000F0C257E792BE0070DA30B053E33E708BC73A43B697BF3107D5AACDFDEFBF7226CF2C8CF4FCBF16F2FFB7289F0940808A6836C892AE3F000000000000F03F000000000000F03F000000000000F03F65FF6AB25DE8A7BFD36011F4B05EDEBF7EBC41302F7FB33F50A075C5B005EC3F2B8D00C811AC014078B66216EDE2E6BF5ABA31BB73D9FABF000000000000F03F000000000000F03F000000000000F03FAC415AF10174B4BFE50623D52FBAD1BF283ED7B796D9B43F2687ADEAC987EE3FB07221936B3FCEBF6F2C9A4111B00EC0C1C06822FDF5D33F000000000000F03F000000000000F03F000000000000F03F120C6A4C0F09BFBF29F6611F2E86DEBFD46EB07A9029A03FBF454DB3BBD6EB3FA5B30018BA2D18C0F09863B99E5DB13F4835651E17E10340000000000000F03F000000000000F03F000000000000F03F4657626AC747983F84831DFBC3F2EF3F17FD80388858AABF4019602FA096713F0000E0DE6CE7C7BE000018E0FC7FDB3E0B00004092391EC0000000000000F03F000000000000F03F000000000000F03F000000000000683C000000000000A0BCC2CC37BE8064B43FA41B15B0F7E5EF3F06000040CF8F4440000000000000D4BC000000000000003D000000000000F03F000000000000F03F000000000000F03F0C9D3790FF1DA73FF05A8DD6F43F9CBFA0FBDC40A410D53FD115C033652BEE3F07000020086145400000000000000000000000000000323D000000000000F03F000000000000F03F000000000000F03F0048AA14293F7DBFC0D3CB6EC3788CBFEFB30F909CB3ECBF44BC47D62F48DC3F08000040FE57124018000040B82527C00000000000D074BD000000000000F03F000000000000F03F000000000000F03F0080069CED2ACFBE0000E67B6D71CEBE137436889A92DF3F633FCFBBC7D5EBBF00C2A52E84ADF4BF061776B1662F06C0C08D2226DFD5A63F000000000000F03F000000000000F03F000000000000F03F0000123FBBBDB2BE00000883B644A4BE04CF5B566373D3BFF4322D1B817CEE3FE37AA07A5482FE3F0695B0BF09A70F40003A84F526619DBF000000000000F03F000000000000F03F000000000000F03F80C50C5EA019893F000000000000000000000000000000007295837D62FFEF3F0E000000086135400000000000A0453D000000000000403D000000000000F03F000000000000F03F000000000000F03F00E0D337AC01D7BE0000F439EC02C1BEB2B21D382132A63F64ECA4744CF8EF3F140000C0234615401E0000000348184000000560F8CC283F000000000000F03F000000000000F03F000000000000F03F00E5135F419ED6BE000014FF38CAB53EA8CFB73EF0769FBF6062B2BE21FCEF3F9C000080E4F8CA3F130000C072740340005000A089922C3F000000000000F03F000000000000F03F000000000000F03F3C02F099561EA53F00000000000000000000000000006E3C48E65F4607F9EF3F01000040696A2B40000000000040FEBC000000000000143D000000000000F03F000000000000F03F000000000000F03FC29D564AE270B53F0000000000000000000000000000000032C1C89F37E3EF3F12000060696A3B400000000000C012BD0000000000002A3D000000000000F03F000000000000F03F000000000000F03F00D82C18D049B5BE000058B71F93A73E06321A790FBFA2BF98CA3BD481FAEF3F020000A01A180B401F0000C0709B154000C0064091F6243F000000000000F03F000000000000F03F000000000000F03FDB8CAAC1179EE6BFE03132E1633C803F60C03781C78790BFCAC8AA4145A1E63FF2FFFF9FEFCBFC3F1600004026BA1BC0800200A07830963F000000000000F03F000000000000F03F000000000000F03FFAD6B2DE1C9EE6BF8054117FEB33803FC0380CFFBB8C90BFCAA8B29E3FA1E63F200000C00286C1BF080000A01D4DB13F0C000000FCAC1640000000000000F03F000000000000F03F000000000000F03F540FEC66259EE6BF60564C2CE1C4813FD0BED6CC0C4891BFD2E3E84601A1E63F120000405FB10D4010000040077B2140400100A0BFEDB93F000000000000F03F000000000000F03F000000000000F03FB8DE1BA4E5FDEF3F189EFABE7E87783FD0986E135B2C96BF80DF217A840A683F00000CA0ECFCF23E00000260D91902BF0900006091391E40000000000000F03F000000000000F03F000000000000F03F000000000000683C000000000058A93CD984638BD006B63FE5CBECD39EE1EF3F0D000000CF8F44C000000000008005BD00000000000000BD000000000000F03F000000000000F03F000000000000F03F9CC5B12A524496BFAC42F55EFF1673BFFEC5025E9CB2D6BFF074EB5A57E9EDBF08000040086145C0000000000000F8BC0000000000000000000000000000F03F000000000000F03F000000000000F03FF07DC2C7545082BFD008BA9F80308ABF545700C6BCB3ECBF3E0E64B2B047DC3F18000080FE5712C002000040B82527400000D81F1524FABE000000000000F03F000000000000F03F000000000000F03F000035D728C5C63E004017B609D8C6BE042484168481E0BFFD2F825B1C6AEB3F00F0269D2F11F53F015851B7F62A05405847552E509DA6BF000000000000F03F000000000000F03F000000000000F03F000080CDAAD0943E0080521F357ABCBEE1D7878B45B1D5BF649033BB151BEE3F80D13DD46AD900C002CCAD9A480F10C0008E7EE953D89D3F000000000000F03F000000000000F03F000000000000F03F8CDCFE4CB3B394BF0000000000608B3C00000000000070BC9842A16253FEEF3F0E000000086135C000000000000032BD00000000000035BD000000000000F03F000000000000F03F000000000000F03F000002270B8BC5BE00FC5566B874E33E95F263E5C890A0BF1946680AB6FBEF3FF0FFFF3FD06DCDBF03000080D97703C00000F09FD0E1CB3E000000000000F03F000000000000F03F000000000000F03F000088158283B8BE00BEFA9D23A2E33E6C6F9F3A9892A53FA6F89AA8B9F8EF3FFEFFFFFF7AA715C00200000090A018C00000F85FBD44123F000000000000F03F000000000000F03F000000000000F03F862EAA1BF8C98A3F0080ABAAB50570BE000000000000883CDAB799944CFFEF3F08000060696A2BC0000000000000D83C000000000000F03C000000000000F03F000000000000F03F000000000000F03FB9D1709FD4EA9C3F00008C1FB31770BE000000603E5947BE769E619FBBFCEF3F18000060696A3BC0000000000000F33C0000000000001CBD000000000000F03F000000000000F03F000000000000F03F0000871833CDAB3E00ACA8D83924DB3E933BF79AF3A1A2BF261D5CD792FAEF3F120000402A070BC0010000205B9E15C00000F45FF3E4F03E000000000000F03F000000000000F03F000000000000F03F2D2BA662319EE6BFBCEEC7E26BBE673FC0E318C2BEE7413F1EBBA642FEA2E63F170000000A5200C0FFFFFFBFCAAE1B4080FFFF3FABDEAFBF000000000000F03F000000000000F03F000000000000F03FCD1B5519319EE6BFC48F0BB9AC97673FA05BD6BA6083413F57B153B9FEA2E63FC00000E0058FB33F100000C05FEFA3BF1600000096B317C0000000000000F03F000000000000F03F000000000000F03FA4A20CC15D9EE6BFC08171A1A71C6F3FC0D51481075137BF21D70C41C9A2E63F2200008024BA0BC003000080245421C080FFFFDF2870B4BF000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000000000000000F0BF000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F99FC1079A263B2BF49D678F71D9EE63FBA53D2D8D109B3BF966A8E97E264E6BF00000020221025401B0000002E05ED3FFFFFFF3FB5001840000000000000F03F000000000000F03F000000000000F03F685A540D7D57E63F4CD87ACFC0C483BF47C4DB4CC9E7E6BF3233B86F547B83BF00000060E44B21C0FCFFFF7F98011CC0040000801FC01840000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000000000000000F0BF000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F843CBBB855DBD6BF5DDFABB9A1E6A3BFBFE482F689D6ED3F3E9FB1D98DD4A3BF00000080ED5139C0D2FFFF9FE68E17C0000000E0A64F5440000000000000F03F000000000000F03F000000000000F03FDE5B249DF2A5E3BF2C449C7B892D8EBF80BA53DC4140E9BFA6CBE43CF05A853F010000A0858443C0000000401A7B07C001000080383F41C0000000000000F03F000000000000F03F000000000000F03F0000000000009EBC00000000000090BC0000000000009CBC000000000000F0BF705AB47B9566233DC0547B312066ADBC435774C7107D213D000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000000000000000F0BF000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000000000000000F0BF000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F96BE4B41FB67B53F00AAE498A9437BBF9C2DE1A2524DB43F5F4A68523CC9EF3F0D000000CF8F4440000000D037BD2E3E00000090B9D38FBE000000000000F03F000000000000F03F000000000000F03F2A55C11A61FD933FC0324C49055C7DBFC74ABD3CC0ECB2BFFCCA8D04CFE7EF3F0C0000E007614540000000D822A971BE000000760D7FC1BE000000000000F03F000000000000F03F000000000000F03FD2FFD934FC699C3FFEA85998327F63BFD5C75B774706B63F84FA7ED36FDEEF3F110000C0CE8F44C0000000D53F1B793E00000000203F183E000000000000F03F000000000000F03F000000000000F03F000AE0175B7C88BFD2647A562EB28C3FC8EBCDB7F4B2A8BFD15C653512F5EF3F140000C0076145C0000000EC0BD492BE000000007401433E000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000000000000000F03F000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F8AE667F394A6E6BFEF8F9C323EB9A5BFF9623013C965E6BFCEFAB472BED5B53F000000005EB2C4BF5E06002099FDC93F0000000008635640000000000000F03F000000000000F03F000000000000F03F16DE86CECFE69D3FC5E65D4BC0CFEF3F01E1E0B3C6AABABF807C8F343E417A3F04000040B5BA54C00C0000805C512540D8FFFF1F605822C0000000000000F03F000000000000F03F000000000000F03FC3186290A0FAEFBF2EE3E2A6BBDDA03F40EC43942E5F7D3F4444B177F7118B3F020000C02DD054C00A00004018631940080000E08B3D2640000000000000F03F000000000000F03F000000000000F03F2014316BE50F87BF40FEBE8ACD2486BF6893EFCAE988E6BFBCDA054BD2B6E63F02000020FE57124011000000B82527C00000001BE59795BE000000000000F03F000000000000F03F000000000000F03FB01E1C9A3D178ABF8C78D53B407482BFBE3EFB7AE53AE6BF8F06CEDA3203E73F05000040FE5712C0FFFFFF3FB82527400000FEBF3329FABE000000000000F03F000000000000F03F000000000000F03F14C7917AA780B03F345701F76555EBBF3DF6B218B22F963FAD4692BA237FE03F0000008071383A400000002052C0014000000060B4795440000000000000F03F000000000000F03F000000000000F03F9311717455DBD63F92B7EFF5A3E6A33F554EE9F089D6EDBFDECFF8B5A7D4A33F00000020EE5139C0000000C0E88E17C000000020A84F5440000000000000F03F000000000000F03F000000000000F03FFA9F0FCB155FE5BFFCF35BC94E15B23F9AAE7989BF4EC23F7B5B0ACC8843E73F000000C0B7BC3940000000C093A305400000000043DB5240000000000000F03F000000000000F03F000000000000F03F6EEB00BE442AE5BF3C00159C855C96BF57DED5A50C4AB03F09AB9A1970E7E73F00000040BC363BC000000000D3C515C0000000A0F0C15240000000000000F03F000000000000F03F000000000000F03F6EEB00BE442AE5BF3C00159C855C96BF57DED5A50C4AB03F09AB9A1970E7E73F00000040BC363BC000000000D3C515C0000000A0F0C15240000000000000F03F000000000000F03F000000000000F03F",
    // 手持物数据
    "WeaponSnapShot": {
      "weaponID": 1021780019,
      "customState": "Weapon.State.Open",
      "slotType": "Suit"
    },
    // 载具数据
    "CarrierInfo": {
      "ScaleX": 1,
      "ConfigObjID": 208408,
      "LocX": -34447.333122682,
      "RotYaw": -79.9067542905,
      "LocY": 41263.716974831,
      "RotRoll": 2.5560576006871,
      "ScaleZ": 1,
      "ScaleY": 1,
      "Pose": "12000000000000000000A0BC00000000000000000000000000000000000000000000F03F000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03FCD3B7F669EA0E63F00000000000000000000000000000000CD3B7F669EA0E6BF000000C00BF157C0000000007FEA204000000080E2824140000000000000F03F000000000000F03F000000000000F03FCD3B7F669EA0E63F00000000000000000000000000000000CD3B7F669EA0E6BF000000C00BF157C0000000007FEA20C000000080E2824140000000000000F03F000000000000F03F000000000000F03FCD3B7F669EA0E63F00000000000000000000000000000000CD3B7F669EA0E6BF000000E0A93B5840000000007FEA204000000080986D4140000000000000F03F000000000000F03F000000000000F03FCD3B7F669EA0E63F00000000000000000000000000000000CD3B7F669EA0E6BF000000E0A93B5840000000007FEA20C000000080986D4140000000000000F03F000000000000F03F000000000000F03F5BC4F2D9CEDDE8BFE630E7B95F0D69BEAF99275BCFE8633EE02B193B1924E43F0000000000000000000000C0DFD594BF000000C0DFD5C4B5000000000000F03F000000000000F03F000000000000F03F0000CCF22250A2BC00000000006ADCBB353D5A96A4D1433F4C78CD9DFFFFEF3F000000C00BF157C0FDFFFF7FE28241C000000000000000BD000000000000F03F000000000000F03F000000000000F03F3DBB27C8FD5B90BF7054D6C7D693C0BFBFA26848762FC0BFE96722D29F77EF3F00000060B7545340000000A0CFD859C000000000000020BD000000000000F03F000000000000F03F000000000000F03F00000000000080BC000000000000503C0D96C3FF1EA4E63F2A295E421D9DE63F600000A0833DFA3FFEFFFF5FCFD05140000000000000303D000000000000F03F000000000000F03F000000000000F03F00000030E3F074BC0000000020DB3ABC68A6FC399334C33F642B187643A3EFBF000000C0BB8F304004000020188054C0000000000000E4BE000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000010000000000F0BF010000809F015840040000407A3054C0000000000000103D000000000000F03F000000000000F03F000000000000F03F6C56AFCD7838943F6DA92D136F566CBF2BB4F2AE4516C63F2FE553B57283EF3F00000020994B40400600006071AD3EC0000000000000003D000000000000F03F000000000000F03F000000000000F03F02ABCF6F6C3894BFC086287666566C3F6C5145914516C6BFCC48A4B87283EF3F00FEFFFFFF9E9A3F000000E0FD702F40FFFFFF3F93203140000000000000F03F000000000000F03F000000000000F03FF6EE408FDC6194BFC0D8A38EF58F633F7046993558DCCCBFC59353D75B2BEF3F00FCFFFFFF8B9ABFFCFFFF9FF9702FC0FEFFFF1F701B2EC0000000000000F03F000000000000F03F000000000000F03F00000030E3F074BC0000000020DB3ABC68A6FC399334C33F642B187643A3EFBF000000C0FB1551C0040000C0108054C0000000000000C0BE000000000000F03F000000000000F03F000000000000F03FF5F1CF331927943F9A17154DE2476FBFDF7E41913F61C83F3174010D5B68EF3F0000000040284AC0050000C070AD3EC00000000000000000000000000000F03F000000000000F03F000000000000F03FD1DC24550C2794BF0044266FCB476F3FBBE3DD923F61C8BF90B9140F5B68EF3F00FBFFFFFF9D9A3FFEFFFF7FFC702F400000004093203140000000000000F03F000000000000F03F000000000000F03FB6790324995594BFE06972A4A787663F8FD624A69E20CFBFDF0D20E66108EF3F00010000008D9ABF03000000FB702FC0FDFFFFFF6F1B2EC0000000000000F03F000000000000F03F000000000000F03F",
      "LocZ": -19963.649804431,
      "RotPitch": -1.5918875026115
    },
    // 天气
    // 0 -> 晴天 / 彩虹天
    // 2 -> 雨天
    // 4 ->
    "WeatherType": 0,
    "StaticInfos": {},
    // 互动物数据
    /// 注: 由于叠纸的bug, 该数据记录并不准确
    /// 1) 坐椅子后与npc对话会出现该数据, 通常与npc对话不会出现状态. CfgID=100008, 其他数据正确记录
    "Interactions": [
      {
        "ScaleX": 1,
        "LocX": -33669.8984375,
        "RotYaw": 16.319381713867,
        "LocY": 40022.9296875,
        "ScaleZ": 1,
        "ScaleY": 1,
        "RotPitch": 0,
        "RotRoll": 0,
        "LocZ": -19980.26171875,
        /// 800002 -> 大世界交互物(椅子)
        /// 其他-> 摆饰
        "CfgID": 212021
      }
    ],
    // 大喵数据
    // “隐藏大喵” 开启后无数据
    "DaMiaoInfo": {
      "ScaleX": 1,
      "LocX": -51221.450092442,
      "RotYaw": -34.310001373291,
      "LocY": -62710.181307549,
      "ClothIDS": [
        1160100147,
        /// bug ?
        /// 1023860042
      ],
      "ScaleZ": 1,
      "ScaleY": 1,
      "RotRoll": 0,
      "Action": "D4000000000000C0C434B2BC00000000000000000000000000000000000000000000F03F000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F73F8B3FBDDACE6BF25307B05129190BFACF5DEDB0292E6BF628D31F9313E883F000000E0D990B73F000000A0EF77DBBF00000080FECE2740000000000000F03F000000000000F03F000000000000F03F2D330F826DE47E3F00AEFBC17BBF5D3F8972072222708E3FE6062242D9FEEF3FFEFFFFBF2AFB094000000084B4193A3E000000000000E03C000000000000F03F000000000000F03F000000000000F03FA06A9B5154FA7D3F003425FE3FE0353F0881344FAB876FBFB6B77A2EB8FFEF3F07000000799B0A40000000A1CF5054BE000000000000FEBC000000000000F03F000000000000F03F000000000000F03F50E9C5DB3D857E3F00B41ABCF5203C3FD0F8471DAFA1833F0C8A913B65FFEF3F040000806563124000000000000090BC00000000000010BD000000000000F03F000000000000F03F000000000000F03F30F456F2AC4B753F00E4A0AB04C24FBF98E7A0934D4993BFD3247AAB6EFEEF3F02000020B5B31040000000000080E1BC0000000000001D3D000000000000F03F000000000000F03F000000000000F03FEA42D9C17D0BA8BF0094CAE18A4C573FF7D0C8E19835973FC9FA74A2D8F4EF3F09000060A69BFD3F000000000060E2BC00000000008002BD000000000000F03F000000000000F03F000000000000F03F75DD6DFAD17ADB3F11C54EC82E54E1BF60C936989619DD3F76656B877CFAE13F000000606DA92240000000E0E64917C0FEFFFF7F7F0212C0000000000000F03F000000000000F03F000000000000F03F118A8EAC8247D73F870777ACA863D7BF0D6B9F504469E23F44ED07EF2751E43F000000407E39214001000080DEC124C0040000201A0008C0000000E0F30FF03F000000203EFEF13F000000000000F03FC4F3D636ABAFDF3FAA0E0D0F79E1D4BFB50977144A64DC3FA64680CF5181E53F0200002001CD21400400000079DE24C0040000008D860CC0000000A0C4DCE33F000000A05C71EF3F000000409D24F03F395340476E96E03FE19E9CA78F69E1BFB741440C7C0FDC3F0681CA8D318CDF3F00000020D0BD2140FFFFFF9F65D324C0FEFFFF1F09AB15C0000000006426F03F00000040214BE43F000000A01C14F03FEB1FA5B04DF0DE3F52BCDF94F46AE6BFCB2F72937F4BD93FBE2D07557B1BD63FFDFFFFBF5EFB2140000000206FC523C0000000C07EC21BC000000080F7E3F43F000000805A71F33F000000000251F03F40C62C7ABD07E43FB438BCF9C38AE5BFD822D0DA00D6D13FCEE6D27A7ECCD13F010000A065F821400000000004DD21C0FEFFFF3FA6541FC000000020500BF03F000000C05CDCF33F000000002214F03F379653E2C4FAE43FA10B2DE2379FE3BF9E7A5EC37F61CE3F8C8EA2E2E3C2D73FFFFFFF7FD6E21F4001000060660623C0000000C0EE5D1CC0000000A095F6EF3F00000000E7AEEF3F00000000E7AEEF3F02A731D40B54E03FAE34BE71D5B7E3BFFB530F8EE0CFD83FC8F5CF8AB24DDD3F0400004011571E40000000C0F73D24C0000000805CB816C00000002047E8ED3F000000000000F03F000000000000F03F2E2D62F00114E03F9678D6C23906DEBF74DFBB47C5FBD83F6EF3F64C1B99E33FFDFFFFFF130B2040FFFFFF9F7E6B24C0000000E04BCF0EC0000000E04004F03F000000000000F03F000000000000F03F9A885725B844DC3F86665A9B2BA9E1BFC9AB4A05EB4ADC3F8DF255FB50ABE13F020000606DA92240FFFFFFDFE64917C0000000807F021240000000000000F03F000000000000F03F000000000000F03F4836AA3D76C7E33F6731040DA65EDDBF358E583338B9D93FF2CFEA2828BBDF3F01000000AB102A40FFFFFFBFA3C926C008000080614803C0000000C09850F73F000000003FBCF53F000000000000F03F95CAF26FA883E23F4C3FFDEE9B66E1BF928A27F8630ADC3FFEC23B57ADF8DA3F0000000068282A40010000E0025E26C0F4FFFF7F41240BC0000000C0367AEE3F000000C0347CF23F000000000000F03FA64C3F1C8BA4E23F99C052DCE743E2BF5A3F55BA0227DC3FD945283BAF0ED83F020000C06BAB2A40FFFFFF7FA9B425C0020000603B2C11C0000000000000F03F000000203E39E83F000000000000F03F98E16FB12274E33F4F2253729044E2BF3339BECB510FDB3F4E6A020F4FB2D63F030000C052072B40FFFFFFBF3B0825C002000080A44F14C000000020BEB9F03F00000040434CE43F000000000000F03F8AEB94CF9785E43F3247E70DBC4FE2BF65C5CEF246C5D83FC76539B0375ED53F02000000E1192B400000000044D123C00000002053D018C000000000BEE6EF3F00000080491BE83F000000000000F03FF927D5E096B3D93FC95E076192C1DFBF6C2FA460FBCBE33F511EF3007350DD3F020000C031122A4001000020C0C626C0040000405C380340000000006D50F73F000000803F99F53F000000000000F03F4D794039440ADC3FCAF8803943FEDABF09038B1B1185E23F39D2D03BFE62E13F01000080FC2A2A4000000040195B26C0FCFFFF1F8B160B40000000C0367AEE3F00000000F089F23F000000000000F03FF45D1F7E2427DC3FA9C60C83E20ED8BFA4D88A49ABA9E23FBEBE0B2A8D3EE23F0100006077AD2A40000000606FB125C000000060FB241140000000000000F03F000000C06D34E83F000000000000F03F8E969E9FD103DB3F6321B68447C4D6BF2641A4E8DF7CE33FC45F270AE739E23F000000C0E5042B40020000E04B0525C0000000A03E4B1440000000C042B9F03F000000C00B51E43F000000000000F03F2387568952A6D83F0E2224A8867DD5BF0514D36790A7E43FA6CEE126AD2AE23F00000000781A2B40FEFFFF7F7CCE23C00000000032CC1840000000000000F03F00000000BF14E83F000000000000F03FB2B753AC9892DF3F6777E6557435E0BFB4B753AC9892DF3F7ACFE5D58136E03FFDFFFF5FB90F2940FFFFFFDFCF9127C000F8FFFF267472BF000000000000F03F000000000000F03F000000000000F03FE1F170BEBD34E13FB374681E7192E1BF07C16F9EE241E13F5700017E5D08D63F020000C0FEB11240030000E0511528C0FEFFFFDF285B01C0000000206A82F13F000000000B82F93F000000000000F03F404CA9996C45DD3F74E4DE79EE4DDCBFAA936A9BB62AE53F88147F9A346AD93FFFFFFF5FF17A124002000000411B28C0020000405B1300C000000060A4EDEF3F000000C09DE8F13F00000000380DF33FD57AA3483C2CE13F7FF93B99137FDCBFF5DAB6272DDAE13F0DBBD1F82CCDDC3F040000C024EE1140FFFFFFFF0B4E28C00C000080680CF7BF0000008098F2EF3F000000803895F23F000000000000F03F062EC6429665E03F98C0D3E40888DCBFD1D211C3AF24E23F83FD0B456FD4DD3FFEFFFF3FBEEC1140FFFFFF7F6B6D28C0040000800924F0BF000000E08620E33F00000000CD1AEB3F000000000000F03F6F2DF2C0C98FE13FAB8689616D89DCBF6E2DF2C0C98FE13FB48689016E89DC3FFCFFFFBFE0951340030000409D8B28C000F0FF7F1A696ABF000000E05DC6F03F000000001471EA3F000000000000F03F3C92E17F181AE23FAD65EBCA6DEADDBFAC93E042D169E03FF7976ACD2E82DC3F0200006038F11140000000A0CC6B28C0000000E0DA2CF03F000000E08620E33F00000000CD1AEB3F000000000000F03FCA10965DCDC5E13F9E93EDA732F5DCBF8A5CAF9E8734E13FD1F5E4687075DC3FFEFFFF5F5CF4114000000000414A28C0FEFFFF3FF531F73F0000008098F2EF3F000000803895F23F000000000000F03FBA7C30F96222E53F012CC6D7B486D9BF42899EF61B1CDD3FB587D336A977DC3FFEFFFF9FAE931240FEFFFF1F951328C0010000C0DC51004000000060A4EDEF3F000000C09DE8F13F000000C0370DF33FEA6A1D644557E13FF6D9312535E4D5BF8D530524BFF1E03FFD82382473C9E13F04000000E4CE1240FEFFFF7F9F0C28C0FFFFFFFFA0A40140000000206A82F13F000000000B82F93F000000000000F03F4E34C57DC396DF3F98DDBD1ED9D3E1BFDD19BF3D3BEDDF3F8783FE9DD46ADC3F0300008089C41240010000005F0928C0FEFFFFBF3A5A01C0000000408E1AF03F000000000000F03F000000000000F03FDE840F95466ED83F0D1BB09BFCA8E4BFBEF593AA1C65DE3F8865388CE675DD3FFEFFFF7F6E301240010000E011F227C0000000C014C900C0000000000000F03F000000000000F03F000000000000F03F80C6DDBD70A8DD3F527AB33E020EE2BFBE0CFA3D6E1FDC3F0298CBFECCBEE03F000000607A1412400300004043EA27C0000000003C49F8BF000000000000F03F000000000000F03F000000000000F03F028E267982E5DE3FE3334B3CDFB7E0BFA169C6996A14DC3F78D11A5C2092E13FFEFFFF1FA956124002000020230D28C000000000F3EBE8BF00000040D50BF03F000000000000F03F000000000000F03F983EA09517DFDF3FB56EC53A6310E0BF963EA09517DFDF3FA06EC57A6310E03F040000E06A781240000000E0261728C00010000090CE503F000000C042E1F03F000000000000F03F000000000000F03F4C38994B8A05DC3FCF0F26BF3491E1BF1A0B26069CEFDE3F5BBDB7C068BAE03F030000202F5B1240FFFFFFDF470C28C000000020347DE93F00000040D50BF03F000000000000F03F000000000000F03F2B93F5CF1331DC3FED006CE33DC5E0BFB3CE8E4DD799DD3F757947812207E23FFCFFFFFF20161240FFFFFF7F01E627C002000080CC93F83F000000000000F03F000000000000F03F000000000000F03FB95242B23CAEDC3FC87E7FCEF309DFBF2434CBD9C8F4D73F9D32C67E55D5E43F000000C01F3B124000000040BBE827C00100008054DF0040000000001DFFEF3F0000004087DCEF3F000000C0DA04F03F4A3A5F205719E03FD375A5A0EBF8DBBFBA18B8007B1FDF3FEFF86A00A315E23FFEFFFF5F21DD1240010000407E0228C0FFFFFFDF5A910140000000000000F03F000000000000F03F000000000000F03FAD7BAD270C25DB3F74F01E65E11AE2BFAD7BAD270C25DB3F72F01E65E11AE23F010000C04FDD194001000060C9A115C000000060000084BE000000000000F03F000000000000F03F000000000000F03FFB0D9D57A816E73FC0B2F3771F28E6BF0080CFF4CFCFFE3E00F0C73525223C3F040000E04938124000000040A1241FC0000000C042016C3F000000000000F03F000000000000F03F000000C03E33F03FE2D9B5FA4080E53F70552B3A4AB3E7BF0000B7FBE96A013F00C04BF919404B3F010000005C691240FEFFFF7F757722C000080040AF6A6D3F000000000000F03F000000000000F03F00000020A268F03FD5B72254B55BE43F939E9C515BB0E8BF002012D5BFC0023F00364B2F98AA4C3FFEFFFFDF15FE114001000080E9AE24C00000000062856E3F000000000000F03F000000000000F03F000000E02687F03F7EFAC9836296E23FF44F4F05530CEABF0060370413AF043F0084D763C9D8523FFFFFFF3F22141140020000C0DC0627C000000080E4C8623F000000000000F03F000000000000F03F000000A00FB6F03F97FFFFFFFFFFDFBF99FFFFDFFFFFDF3F98FFFF9FFFFFDFBFCDFFFF3F0000E0BFFFFFFFDF08D1264002000020DE74F53F0000008000007EBE000000000000F03F000000000000F03F000000000000F03F9414054CDC96DC3FA60DAFEC5F39DCBF00943A08A4ACDE3F7AD44F5CEEA0E33FFFFFFF5FCF5526400100004092C825C0FCFFFF3FBC7A0A40000000000000F03F000000000000F03F000000000000F03FD2EF78002533DD3F9E08DA65B937D8BF05F5734BAC07E33F78E73BED6361E13F02000040B2EF2640000000C077EF24C0FEFFFFBF141C1540000000000000F03F000000000000F03F000000000000F03F2C00DAF44947D83F7BFFD26F731BDBBF2C94CA99BE7FE53FD41F024A3361DE3FFEFFFFBF96692640FEFFFF3F5F1B23C00300004081461C40000000000000F03F000000000000F03F000000000000F03F120ECDFC67A9DE3FB8FEF4FDE294E3BF504501DDEDB4DC3FE27C0DDDD43FDC3FFEFFFFFFFD4F26400000008098C525C0FCFFFF7FD47A0AC0000000000000F03F000000000000F03F000000000000F03F92DAB339F707E33F2C9F435A7E55E1BF85654D16854EDD3FA874FCD7D737D83F000000402833274002000040FFE924C0000000C0281615C0000000000000F03F000000000000F03F000000000000F03F2816A5DDB48AE53F53638E4F3A60DEBF1D215C19893AD83FCE86E8D41A05DB3F020000805A612640FDFFFFDF411C23C0FCFFFFBF51411CC0000000000000F03F000000000000F03F000000000000F03FD6C52F5EEDC8D13F3EEAEEBCC013DEBFAA5B2E5ECDD6E13FD79AF55D6903E43F06000080837B0D40FFFFFFFF640E24C0000000C0316E1A40000000000000F03F000000000000F03F000000000000F03FD4B7A2C42F05D73FC3686BBD3B17CDBF240C7C4A8F19E23F59DA2065139BE63FFAFFFFFFE9A9174000000040189D22C0000000E0FA502040000000000000F03F000000000000F03F000000000000F03F7CA8E4DB0BC5D93FDDEC2FDC538FD9BF4BEF76268E39E23F71A75285280AE33FFEFFFFFF0646124000000080AB5E27C0FEFFFF7F99580D40000000000000F03F000000000000F03F000000000000F03F5F3C6E8FC4A9DD3F066A40AC4F8DD7BF555466AC32D6E73F545241EACEB6D33FFEFFFF7F75EA1D4002000040A62727C000000040A7FFFF3F000000000000F03F000000000000F03F000000000000F03F9AB0A3FABCD6E13FEE6AFCD96103E4BF16CEA73A0BC9D13FBB2AF6F6E913DE3FFCFFFFBF147B0D40FFFFFF3F8E0E24C0020000C0EB6D1AC0000000000000F03F000000000000F03F000000000000F03F6932AFC3DA1AE23F7EEAA8FCAA98E6BF945AF2BB650DD73FDBBC8E72420ECD3F00000080E1AB174001000040299D22C0020000C0195120C0000000000000F03F000000000000F03F000000000000F03FAE3DFCFAA365E23FD891DD7A29D6E2BFCBA8F61875D0D93F7BFC03D9909FD93F020000008D5D1240000000C0A66F27C002000080DB010DC0000000000000F03F000000000000F03F000000000000F03F61F7EACCC8D6E73F2EF53810E7B5D3BF3C80402802ABDD3FE65228AD218AD73FFEFFFF3F6CFF1D40020000C0C22E27C0000000C0691B00C0000000000000F03F000000000000F03F000000000000F03FA2E85600E74EE33F8CBA50206AEFE1BF4EC47F40B162DC3F22E2656094A2D63F0100000048411640000000C07BC725C0FCFFFFBFE9D016C0000000000000F03F000000000000F03F000000000000F03F169D4889965CDC3F63794A74FAA7D6BFD6ADC39AFB4CE33F70B9609D30F2E13FFEFFFF7F2B401640FFFFFF7F81C725C0FFFFFF5F59D11640000000000000F03F000000000000F03F000000000000F03FBBAA81F45025D33FE19E25328813E7BFF6E95410A319DA3FB14CCFAD184DDE3F040000801BBA0D40010000805C6427C002000000229105C0000000000000F03F000000000000F03F000000000000F03FFA750DFCA020DA3F967912F66279DEBFBE4A79C5A647D33FFDCF6060C7FBE63FFCFFFFBFE1E50D40FDFFFFFF5C5327C00000002095B20540000000000000F03F000000000000F03F000000000000F03FFB6963407908E03F9301C6C004EFDFBFFB6963407908E03F9101C64004EFDF3F040000E0B9391A40FEFFFF9FD68C28C00020000059B94DBF000000000000F03F000000000000F03F000000000000F03F832155F20153E43F29222E2C1D79DDBF1A61E1AE3175D93F6CB5866B1572DE3FFEFFFF1F5752184000000040BA7228C0FEFFFF9F15F900C0000000000000F03F000000000000F03F000000000000F03F725677B51669D93F9AD35C13207CDEBF09F29417954EE43F0A1EC3335F85DD3F030000609A30184001000040F87028C000000040E7140140000000000000F03F000000000000F03F000000000000F03F44E5727CCF0FE03FFECCF3B841E0DFBF45E5727CCF0FE03F04CDF39841E0DF3FFDFFFF9F8D821A4001000000AFF514C00000F8FF3F78FABE000000200F10F03F000000000000F03F000000000000F03F6BA0341E1993E03FB48304FD178CDBBF39DB36BE807EE03FE10C2ADEC9F4E03FFEFFFFBFC4FE1240FDFFFF1F9AF127C0FFFFFF7FE8FF0140000000000000F03F000000000000F03F000000000000F03FF821DB6027AAE13FA209D6400241E1BFBC6188016DA1DF3F3FDC3D818E9FD93FFDFFFF1FDAE7124001000040391228C0000000E012CB01C0000000000000F03F000000000000F03F000000000000F03F006808C6F227E23F191DE4C24D5AE4BF7C0DD2FDE5E5D73FC4317ABE5570D73F010000A0B23B2140FDFFFF9F1DD524C0020000000A930840000000E0F30FF03F000000203EFEF13F000000000000F03FF62DF94BE3FEDA3FF0DECF8F3BD2E5BFF61DF1131441E03F9A6D0E51D224D43F020000C0D1D12140FFFFFF7FD9E924C0FEFFFF9F9DF60C40000000A0C4DCE33F000000A05C71EF3F000000409D24F03F0FC29EA3C9F7DB3F852F2E20945BDFBFEF0A1F2F3DA2E03F0F50406EBC7DE13FFEFFFF7F14BD2140FFFFFFFF6CCF24C0FFFFFFFF47D31540000000006426F03F000000603A89E43F00000080E6C9EF3FC745D9A9688BD93F8D254B6D7192D5BF151FB3854454DE3F264A548C1DAFE63FFFFFFFFFC3FD2140000000E0A9BB23C0020000000AEB1B4000000080F7E3F43F000000805A71F33F000000000251F03F10E389D3A4C1D13FC21A80F3C0B8D1BFA0411E36C719E43F2CE3AA173B82E53FFDFFFFFF43022240FFFFFFBF43D521C00000000097651F4000000020560BF03F0000004084DCF33F000000002D14F03FAEB87717D216CE3F870D4CF941A3D7BF6D3B0B3A1101E53FFCBC6CBA36A9E33FFFFFFFBFC6DC1F40FFFFFF5F1FFE22C0000000C0C3771C40000000A095F6EF3F00000000E7AEEF3F00000000E7AEEF3F650CC6627290D83F76C83EBDF335DDBF9AB8840CB85FE03FE5937308C8CAE33F020000C054511E40FFFFFF3F653724C0000000C0BEE016400000002047E8ED3F000000000000F03F000000000000F03FC520D35090DED83F5109E45A1890E3BF022A6641C321E03F0345E9467218DE3F000000C03706204001000060C96C24C0FEFFFFDF48110F40000000405004F03F000000000000F03F000000000000F03FBE30FF0307FD94BF941C52A477B0E63F145878443C79A73F234649040F82E63FFFFFFF1FE71E1440FEFFFFFF70B627C000000080AFF6F43F000000000000F03F000000000000F03F000000000000F03F83558EE44EBBE63F6AEF9F056A108C3F15A08144E67BE6BF3ED6FDA35AEAA33F01000080700F144000000060BDB827C0FCFFFF3FE2EFF4BF000000000000F03F000000000000F03F000000000000F03F73B7B7535274B1BFCD27F212138DE2BFBB8A5E130CF3B13F30E5C88DB5E2E93F02000080FA471840010000205B8F22C001000040ABD22040000000000000F03F000000000000F03F000000000000F03F5611FC75159798BF6CC54053074CBF3F68AC07B6967AC8BFDB8A4FF3C227EFBF00000000F2FE1040000000000000ED3C0000000000202CBD000000000000F03F000000000000F03F000000000000F03FB07CD67761846FBF7D8BEFD9996AA73F5287BB3B6F7AC0BF5961CAB720B3EFBF00000000F2FE104000000000008017BD0000000000E8223D000000000000F03F000000000000F03F000000000000F03F00000000000040BC00000000000050BC00000000000020BC020000000000F0BF00000040A7E41240000000000080153D000000000000ECBC000000000000F03F000000000000F03F000000000000F03F04DF4EDE99B6A7BFAB8D639EB994E6BF7A39A17E5C34B33F8913655E617FE63FFDFFFF3F8BBB1540FEFFFFFFA24C23C0FFFFFF3F6DEB1F40000000000000F03F000000000000F03F000000000000F03F99433B7E8626A63F087FD77D1E08BB3FD179EBBDDF0DCABF8201843DD61DEFBF020000A083F80C40000000000000E8BC0000000000AA20BD000000000000F03F000000000000F03F000000000000F03FF9EA3C2ADF66AC3F55B80A46DDC2B03F34E4E149596ABBBF6F046DCB7EB2EFBF000000A083F80C40000000000000C83C000000000000FA3C000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000080BC0000000000007A3C010000000000F0BF040000A083F80C40000000000000F6BC0000000000800CBD000000000000F03F000000000000F03F000000000000F03F0A2781A8964CB13F91E81DE9728BE23F9B3CDAE8CB01B23FF679BA6C21E4E93F00000000C949184000000060558F22C00000000053D220C0000000000000F03F000000000000F03F000000000000F03F5011FC751597983F6AC54053074CBFBF6AAC07B6967AC8BFDB8A4FF3C227EFBF00000000F2FE1040000000000000DCBC000000000000F4BC000000000000F03F000000000000F03F000000000000F03FA07CD67761846F3F7C8BEFD9996AA7BF4E87BB3B6F7AC0BF5861CAB720B3EFBF04000000F2FE104000000000000022BD000000000018123D000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000050BC0000000000000000010000000000F0BF02000040A7E41240000000000000193D0000000000902BBD000000000000F03F000000000000F03F000000000000F03FCC522B180069A73FBDAA72D8B793E63FB5DD8D791745B33FC11979187C80E63F00000040E0BC1540FFFFFFBFC44C23C00100000024EB1FC0000000000000F03F000000000000F03F000000000000F03F99433B7E8626A6BF097FD77D1E08BBBFD179EBBDDF0DCABF8301843DD61DEFBF0E0000A083F80C40000000000000F53C0000000000F41ABD000000000000F03F000000000000F03F000000000000F03FF9EA3C2ADF66ACBF56B80A46DDC2B0BF32E4E149596ABBBF6E046DCB7EB2EFBF080000A083F80C40000000000000173D000000000080F83C000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000010000000000F0BF040000A083F80C4000000000000006BD00000000002012BD000000000000F03F000000000000F03F000000000000F03F305D6036ABCE9B3FB75DE358B78CD43F1C593596F64A8CBF3C6A84F5354AEEBF000000806380344004000000B58E0840000000E0F73B2440000000000000F03F000000000000F03F000000000000F03F0000000000000000000000000000000000000000000040BC010000000000F0BF000000004F251140000000000020013D00000000004034BD000000000000F03F000000000000F03F000000000000F03F315D6036ABCE9BBFBA5DE358B78CD4BF1C593596F64A8CBF3E6A84F5354AEEBFFEFFFF7F6380344000000000B58E0840000000E0F73B24C0000000000000F03F000000000000F03F000000000000F03F000000000000603C000000000000903C0000000000000000010000000000F0BF070000004F251140000000000000EE3C000000000000F2BC000000000000F03F000000000000F03F000000000000F03F0596840842DCAFBF54FCA5261ADEC8BFD6A193A45E1EC13FAFFB4B688A08EFBF020000C0074D324000000040529C23C0000000C0B1C0E93F000000000000F03F000000000000F03F000000000000F03FAA46DC3E5A91BBBF1660CB5E372ACD3F72CAD1FE028FDCBFBC38DD9E7A7AEBBF020000C0D4021340000000000000D83C000000000000F8BC000000000000F03F000000000000F03F000000000000F03F507E97FC9B3C88BF705E7C1C81FD983F32816E1C1860C9BFA651979B555AEFBF0300000045810F40180000A0FD56D8BF60000020983FBDBF000000000000F03F000000000000F03F000000000000F03F24F6C11E072B8B3FB778DD3E6CD1E83F816E3C9FC9B4903F06A8137F7B30E43F010000006F750B400500008022A0D1BF050000E0DFDC04C0000000000000F03F000000000000F03F000000000000F03F801B6F7BF9A7523FBA2E41247E7BDE3F94DCD210D111983F5AEDDE888F20EC3FFFFFFF3F248E1140000000000000FB3C0000000000102CBD000000000000F03F000000000000F03F000000000000F03F43664CA54725B7BF40DC9C45C584883F8A723724726BC2BFD8DF37C73B88EF3F010000A04DE91540000000000020123D0000000000000A3D000000000000F03F000000000000F03F000000000000F03F54C9D708E428DD3F60699586AFB5C53F3C7149E88153BBBF12AE6A081CC1EB3F0200008010521340000000000000073D000000000040323D000000000000F03F000000000000F03F000000000000F03FB067A33A9BB1A13F50FBAA7969E5943FA80274576F349CBFB88A50164AF6EFBF040000004AC6F23F00FCFFFFBF2358BF0020004001803B3F000000000000F03F000000000000F03F000000000000F03F306297E5EBCDBFBF702D96050FC7AFBF36D933636B37B23F8E8B8EA5A59BEF3F180000007B79C8BFF8FFFF7F4DD0CD3F01000040C10FF13F000000000000F03F000000000000F03F000000000000F03FE94AD1CA0DCEBFBFC8D0CE8AC5C6AFBFB42A32868537B23FC025C02AA59BEF3FE8FFFFBFC550DE3FFEFFFF3F00DED7BF0000008077FDFCBF000000000000F03F000000000000F03F000000000000F03F3704E913492ECBBFF6BC4836FAD7E5BFE8718016BC5AE53F7CEF1B94CEBBCABFFFFFFF3F7032F23F500000E07CA0A33F000000E0B350FABF000000000000F03F000000000000F03F000000000000F03FD7F0BC867295CE3F008041EBA82B0C3F00C0620EDA7FEABEC663D2C5B812EF3F0400008010520340000000000000FB3C000000000000243D000000000000F03F000000000000F03F000000000000F03F38253E824DD2963FC0DDF4A1A0E883BF279C9241D100B03F0D3F23238DEDEF3F320000409DBFC83F02000000160F01C0500000404927B8BF000000000000F03F000000000000F03F000000000000F03F68F99B3FFAF7963F0070A57FB2CB84BF41A6AF5F6173B23F740C759F34E8EF3F00000040DD04DABF070000A0E5CCF83FDEFFFF9F796AB03F000000000000F03F000000000000F03F000000000000F03FFB429D293EA7A7BF00E08289EEC207BF0030B24AA482163FE24ABFE140F7EF3F020000A04DE905400000000000C0003D000000000000ECBC000000000000F03F000000000000F03F000000000000F03FE53641F97A3BEA3F3E6CC178762C9CBFBC06557804D2DDBF9EE6897A373DD5BF020000E0B0811040FCFFFF9FC5D50D40060000C07A6DFA3F000000000000F03F000000000000F03F000000000000F03F000000000000803C0000000000006EBC00000000000080BC010000000000F0BF050000E0870A0140000000000040103D000000000000083D000000000000F03F000000000000F03F000000000000F03F00000000000080BC0000000000007ABC00000000000080BC010000000000F0BF0400000091840C4000000000008008BD0000000000001BBD000000000000F03F000000000000F03F000000000000F03F000000000000903C000000000030B7BC00000000000080BC010000000000F0BF020000C072E81540000000000000ECBC000000000000D0BC000000000000F03F000000000000F03F000000000000F03F7A08DC6040B9E53F4768FEE00B1EC9BFC830F5601835C8BF5BFDDC806DD1E5BF010000A0BE521740080000605CB9C0BFFCFFFF1FED780040000000000000F03F000000000000F03F000000000000F03F0000000000000000000000000000803C00000000000098BC010000000000F0BF08000080CAC5FA3F0000000000F834BD000000000000F7BC000000000000F03F000000000000F03F000000000000F03F00000000000000000000000000000000000000000000803C010000000000F0BF010000E0575807400000000000800E3D000000000000C03C000000000000F03F000000000000F03F000000000000F03F000000000000B43C0000000000000000000000000000B23C010000000000F0BF03000000760B1240000000000080023D0000000000000000000000000000F03F000000000000F03F000000000000F03F0DBF9D6469DBD13F226547074528DCBF7883E60533D3A6BF53240D07ED46EBBFFCFFFFBFA4290D4000000000E3A611C0020000800F63F73F000000000000F03F000000000000F03F000000000000F03F00000000000090BC0000000000000000000000000000803C000000000000F0BF080000C0C0F9FE3F000000000040143D000000000000E0BC000000000000F03F000000000000F03F000000000000F03F00000000000090BC000000000000000000000000000080BC000000000000F0BF0000002001890840000000000080173D00000000008013BD000000000000F03F000000000000F03F000000000000F03F000000000000A0BC000000000000A0BC00000000000090BC010000000000F0BF0000004021500D40000000000000E9BC000000000000073D000000000000F03F000000000000F03F000000000000F03FC7732A7EFAC7E83FA8860B3ED1698ABF0796805E3D3CE4BFD26CCD9E142E903FFFFFFFFF6E750B40060000C022A0D1BFFFFFFFDFDFDC0440000000000000F03F000000000000F03F000000000000F03FC010277C68DF243F5F7BF469F077DF3FA0A74AFBBE5F953F4087287046DBEB3FFFFFFF3F248E11C0000000000000F43C0000000000800D3D000000000000F03F000000000000F03F000000000000F03F85BD2ED3835FC1BF8FA2AEF021C3743F470A02531A9CC1BF522DD6687465EF3F000000A04DE915C00000000000F0E6BC000000000000F03C000000000000F03F000000000000F03F000000000000F03F47AED58B33E6DE3F532FCE305948C73F1C334DD274FDC4BF4CF3702EBFE7EA3F04000080105213C0000000000000FE3C00000000000008BD000000000000F03F000000000000F03F000000000000F03FAE67A33A9BB1A13F4CFBAA7969E5943F9C0274576F349CBFB68A50164AF6EFBF000000004AC6F2BF80F1FFFFBF23583F002000C0FE7F3BBF000000000000F03F000000000000F03F000000000000F03F6EF55334CE63C1BF44A123EDA919ACBFCEF6802E3311BA3F6CC9DD6A897CEF3F10000080AB27B63F1C0000E0EED2CEBF080000A0481CEFBF000000000000F03F000000000000F03F000000000000F03F90C7C0ADC863C1BFAA798442F818ACBF8CFDA5C41411BA3FC123F69E8A7CEF3FF8FFFF5F686FDFBF0C0000A042ADD83F03000060A18DFD3F000000000000F03F000000000000F03F000000000000F03F79EF1B94CEBBCABFE8718016BC5AE53FF5BC4836FAD7E53F3404E913492ECB3F000000407032F2BF000000E07CA0A3BF030000E0B350FA3F000000000000F03F000000000000F03F000000000000F03F1F455085B38DD03F00C8AE0F66F80D3F0060218F8650EEBEA7D22AEE3CE9EE3F02000080105203C0000000000000EC3C000000000000F03C000000000000F03F000000000000F03F000000000000F03FB899D48F3048A13FBDA793B0FD7B80BFB3ABB602254DAF3F3B4A22E2BBEBEF3FCCFFFF3F92B7C7BF020000E09EE20040F8FFFF7F2D31C23F000000000000F03F000000000000F03F000000000000F03FB0BCFB458E46A13F31A50E06003A81BF26434D2569BAB13F2B24F4EF5DE7EF3F0400002072DCD93F01000040F196F8BFC0FFFF9F1AA8B9BF000000000000F03F000000000000F03F000000000000F03F5B8146037AC7B1BFDFF13CC4580107BF38A689A47FA1183F568BE14538ECEF3F020000A04DE905C0000000000004E2BC000000000000F03C000000000000F03F000000000000F03F000000000000F03F256547074528DC3F0EBF9D6469DBD13F54240D07ED46EB3F7683E60533D3A6BFFDFFFFBFA4290DC000000000E3A61140F8FFFF5F1063F7BF000000000000F03F000000000000F03F000000000000F03F0000000000008ABC000000000000000000000000000080BC010000000000F0BF060000C0C0F9FE3F000000000060143D000000000000FF3C000000000000F03F000000000000F03F000000000000F03F00000000000091BC00000000000000000000000000000000000000000000F0BF0200002001890840000000000000093D000000000000F63C000000000000F03F000000000000F03F000000000000F03F000000000000AC3C000000000000A0BC000000000000A43C010000000000F0BFFEFFFF3F21500D40000000000000B03C000000000000E83C000000000000F03F000000000000F03F000000000000F03F3B6CC178762C9CBFE43641F97A3BEABF9FE6897A373DD5BFBC06557804D2DD3FFDFFFFDFB08110C0000000A0C5D50DC0FDFFFF9F7B6DFABF000000000000F03F000000000000F03F000000000000F03F000000000000603C00000000000050BC00000000000070BC010000000000F0BFFDFFFFDF870A01400000000000C0063D00000000008003BD000000000000F03F000000000000F03F000000000000F03F00000000000078BC00000000000068BC000000000000803C010000000000F0BFFFFFFFFF90840C40000000000000F0BC000000000000183D000000000000F03F000000000000F03F000000000000F03F000000000000ACBC00000000000086BC0000000000009CBC010000000000F0BF020000604CE81540000000000080003D000000000000C03C000000000000F03F000000000000F03F000000000000F03F4868FEE00B1EC93F7A08DC6040B9E53F5AFDDC806DD1E53FC630F5601835C8BFFDFFFF9FBE5217C0FEFFFF9F5CB9C03FFCFFFF7FED7800C0000000000000F03F000000000000F03F000000000000F03F00000000000070BC00000000000080BC00000000000080BC010000000000F0BF00000080CAC5FA3F00000000002033BD000000000000E53C000000000000F03F000000000000F03F000000000000F03F0000000000000000000000000000000000000000000090BC010000000000F0BF040000E057580740000000000080023D000000000000E2BC000000000000F03F000000000000F03F000000000000F03F00000000000000000000000000000000000000000000A0BC010000000000F0BF01000000760B1240000000000080183D000000000000D03C000000000000F03F000000000000F03F000000000000F03FC0C13F065927C63FAE3BB60878E2EEBFAEEE5366DF6EC63F0C2D63A6E9A4B63F01000000505F1240090000C0DD001AC0FEFFFFBF19EA0540000000000000F03F000000000000F03F000000000000F03F000000000000503C000000000000903C0000000000000000010000000000F0BFFCFFFFFF5D2A0840E0FFFF1FFFB2B03F00000000000002BD000000000000F03F000000000000F03F000000000000F03F000000000000603C00000000000000000000000000000000010000000000F0BF0000008067B4094000000000000001BD000000000000FA3C000000000000F03F000000000000F03F000000000000F03F000000000000ACBC00000000000090BC000000000000983C010000000000F0BF010000E0B88D084000000000000002BD000000000000D8BC000000000000F03F000000000000F03F000000000000F03FC0C13F065927C63FB03BB60878E2EEBFAFEE5366DF6EC6BF082D63A6E9A4B6BF06000000505F1240070000C0DD001AC0080000C019EA05C0000000000000F03F000000000000F03F000000000000F03F00000000000080BC0000000000000000000000000000743C010000000000F0BF040000005E2A0840D8FFFF1FFFB2B03F000000000000073D000000000000F03F000000000000F03F000000000000F03F00000000000090BC00000000000000000000000000008A3C010000000000F0BF0400008067B409400000000000800ABD000000000000E83C000000000000F03F000000000000F03F000000000000F03F000000000000983C000000000000B03C000000000080A23C010000000000F0BF050000E0B88D0840000000000080073D000000000000F83C000000000000F03F000000000000F03F000000000000F03F569E53B8C9E5B93F15E747BE1FD0EFBF854A3EF2DF5F9FBF50BF68EB7979963F000000000000D03C000000000000DEBC000000E09E5611C0000000000000F03F000000000000F03F000000000000F03F00000000000092BC000000000000903C82C770388313CC3F520264968038EF3F02000040F80A1640000000000000B0BC000000000000E83C000000000000F03F000000000000F03F000000000000F03FF8664AA07AF98A3FD013ECB59C5C99BF19EBD34B870BC0BFF011A38D22BCEF3F0500008011DC10400000000000000000000000000000F43C000000000000F03F000000000000F03F000000000000F03F00000411E7F9BC3E000064F7FF9FB03EDE3E8B2FC9D9DFBF00DEA8317AC1EB3F0500002058A9F63F02000080725BF0BF0000000230A1863E000000000000F03F000000000000F03F000000000000F03F54525CC87B2D723F403F1645EDB1843FE0805E431204863F3BE1631607FFEF3F1C00004093A2A33F0D000000347DFFBFE4FFFFBFCB4B94BF000000000000F03F000000000000F03F000000000000F03FC058692DC09A6E3FC0C507937E5A853FAC37C12E9864ACBFDE52980CE4F2EF3FFFFFFF1F09B2D03F060000E0E97EF03F8000000003886E3F000000000000F03F000000000000F03F000000000000F03F08506AFCC63984BF0000000000000000000080FD7F1E403EB42754BA99FFEF3F0300008011DC00400000006012F6583E0000000079CC243E000000000000F03F000000000000F03F000000000000F03F60130CAB90FC58BF00B0062665F94E3F5A7FD04F314DA3BF4A622FE529FAEF3F0E000080328ACABF04000060354200C080FEFFFF62D3783F000000000000F03F000000000000F03F000000000000F03F30723C201D2158BF00204E40C7304F3FD8CE48A06F109DBF402150E0AFFCEF3F08000040318FEB3F08000020FB5AFA3FE0FEFF7F42087ABF000000000000F03F000000000000F03F000000000000F03FA03565FE78D76A3F00000000C022C43D00000000000068BC904416BEF4FFEF3F02000040F80A0640000000A16B8B613E000000DEAA067DBE000000000000F03F000000000000F03F000000000000F03FC2FECD7AB7A6E5BFB8C7EA5BE403D1BF3FE7283ABA56C83FB4F7EE5A4E1DE53FFEFFFFBF21AF094006000060B24B09C0080000E049FFD33F000000000000F03F000000000000F03F000000000000F03F452548620197E6BF402E6DE2A605983F30C23BC25F1CB63F5A6345E2B47BE63F080000204ABAE23F200000C0A808A43F0100002018EC0440000000000000F03F000000000000F03F000000000000F03F7ABCB8F33115E5BFFBCE2D53BE03C63FF2E7D4AD3D32CFBFCE1C21138B19E63FFCFFFFFFCAA2F53F000000003B321040000000C05C5EC93F000000000000F03F000000000000F03F000000000000F03F0DEF654755D0EF3FC8E2935C6B27B73F00156CD03E9F983FF413DEE4434FAB3F000000C345FE90BE000000808D8FFC3D010000E09E561140000000000000F03F000000000000F03F000000000000F03F00000000000078BC0000000000009DBC697F87575DBACD3F8B6720CAFF1FEF3F03000020F80A16C0000000000000DC3C000000000000E0BC000000000000F03F000000000000F03F000000000000F03FB0F20F16F5E678BFD75C06F5FA7AA0BF02D96DB92F3FC3BF874550DC699EEF3F0400008011DC10C0000000000000A83C000000000000C0BC000000000000F03F000000000000F03F000000000000F03F00C0F8ED72A1BD3E004001484900B13E631505AFC9D9DF3F36BB160D7AC1EBBF0300002058A9F6BF00000080725BF03F0000803F30A186BE000000000000F03F000000000000F03F000000000000F03FB11A32987019823F5F080CF48DB88B3F14B6A293CFAC9C3F8F883572B7FBEF3F070000C09402B8BF00000040E00D0040080000E0381FA43F000000000000F03F000000000000F03F000000000000F03FCCEFAB9AE969813F92C5ED164EA58D3F9E207E594244A5BF07DF3756C6F7EF3F090000602E30CEBF0000002047EFF0BF3000004021C389BF000000000000F03F000000000000F03F000000000000F03FDEB3EBD965D193BF000009BB8E8E803E00000000565613BEB2852F3677FEEF3F0200008011DC00C00000000000001B3D000000000000F7BC000000000000F03F000000000000F03F000000000000F03F00E5897D2901733F9480FD3C1B3D57BF5A7D79BC7338ABBF5089DC5B51F4EF3FF5FFFF7F9D21CF3F010000E06D5E0040340000804ABF943F000000000000F03F000000000000F03F000000000000F03FE84E03B8F9CA723F484EAF354C4558BF61A1C417735EA3BFB2E268720AFAEF3F040000C01799ECBF000000C0F77FFABFC00000603C1C92BF000000000000F03F000000000000F03F000000000000F03FAC14E05CEE0B84BF000096E8A5F86F3E000000000000603CA110EF879BFFEF3F02000020F80A06C0000000000000E9BC000000000000D0BC000000000000F03F000000000000F03F000000000000F03F37F42C5DEBB0E5BFA2B1CC1D22E6D0BF8D1AE1FC70F7C73F8EDF3FFD9E1FE53F01000080B85709C0010000E067060940100000C01BDFD3BF000000000000F03F000000000000F03F000000000000F03F82205F251696E6BF7490980604BC9B3F908001856A0CB53FD0C95985A37FE63F00000040624DE3BFE8FFFFDF3E0AA4BF02000080F0E804C0000000000000F03F000000000000F03F000000000000F03F81ABC8FA1909E5BF710CA6B7C3CEC63FB94193078EE4CFBF843B05194408E63FFFFFFFBF50B3F6BFFFFFFFFFBCF80FC000000060C4C3C9BF000000000000F03F000000000000F03F000000000000F03FA2C598CCA6D3E53F902C814D5766E7BF80CB77CA5A23723FC0EB38ABFD71733F04000080E9D1E53F010000E005EB12C0000000000000A0BC000000000000F03F000000000000F03F000000000000F03F700A907FFC1AA43F048AA55FAB3EB0BFCE7F6BBFE0AAEA3F51689EFF8586E13FF4FFFF5FF685D93F000000206A3E1D40000000A07251C1BF000000000000F03F000000000000F03F000000000000F03FC0261D19C60169BFC00B2C66059C803FF1E1DC064D2AE0BF73C60E55889DEB3F04000020E4330C40000000000000F6BC0000000000000000000000000000F03F000000000000F03F000000000000F03FE4B3A93398F880BF70172C528B05933F54F1596D41A7D9BF4784B12A424FED3F03000020E4330C40000000000000F83C000000000000D0BC000000000000F03F000000000000F03F000000000000F03FFCA7CA465A5D88BF7864928E47D8A03FC7C7E3C61145B8BF7AB50FBF10D6EF3F0B000020E4330C40000000000000EFBC000000000000E8BC000000000000F03F000000000000F03F000000000000F03FFC104A32AA5B8BBFB05979137FFEA83F1031C0358173C43F68983030208CEF3F03000020E4330C40000000000040003D000000000000E8BC000000000000F03F000000000000F03F000000000000F03F98CD8248B7F490BFC0473E282E26B13F2FE63956B227CE3F2EDF06355405EF3F05000020E4330C40000000000000FABC000000000000C0BC000000000000F03F000000000000F03F000000000000F03F7068F8F13A9793BFA433F52B8CFCBB3FE7DEC34D7C76D93FCC3B212B8924ED3F000000E08D1C0C40000A0040DD5072BF000400A0199E683F000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000000000000000F0BF000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03FA3E4BDB48FDC95BF788654F42AA9E6BF83ACDA12E48699BF8D8E60F4CD91E63F0000006060980E4000000060F561E0BF000000C013880340000000000000F03F000000000000F03F000000000000F03F21A68AD46399E63FCB732FB32846993FFE6186D4CDA1E6BF59303135ED50953F000000C08E8A0EC000000000CA73E0BF000000C0D7860340000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000000000000000F0BF000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F2A1FD3C3ECF9E2BF7ABD7A236B43C13F7AEA82442162E63FF774D7C49405D83F00000000403225C0000000C04E5FD5BF000000606F303040000000000000F03F000000000000F03F000000000000F03F70ED5CAA04FAA6BF6EAEA38AE496E73FF12CB2496E7FE53FD856278DFF29AD3F400000808F0CD83F000000C0FA4B2FC0020000E02D772CC0000000000000F03F000000000000F03F000000000000F03F00000000000080BC0000000000000000000000000000A03C000000000000F0BF606A569E9833ABBCB0DA9DA7C51FCF3C64C61DB65D210F3D000000000000F03F000000000000F03F000000000000F03F000000000000000000000000000000000000000000000000000000000000F03F000000000000000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F73F8B3FBDDACE6BF25307B05129190BFACF5DEDB0292E6BF628D31F9313E883F000000C0E08AB73F000000C0FF83DBBF0000000004CF2740000000000000F03F000000000000F03F000000000000F03F401C09475F82773F9C6093A939FFEFBF087E9567745789BF00179D082EC85C3F010000C028F622C0010000600CCDBFBFFEFFFFDFE0F00EC0000000000000F03F000000000000F03F000000000000F03F00000411E7F9BC3E000068F7FF9FB03EDE3E8B2FC9D9DFBFFFDDA8317AC1EB3F0000002058A9F63FFEFFFF7F725BF0BF0000800030A1863E000000000000F03F000000000000F03F000000000000F03F164821FC7BF4EF3FFAE61C06CB0F773F40A64E0C1E8B71BFC635CF213EE5AA3F000000E06BE422C000000020B9D3C53F08000080552A0E40000000000000F03F000000000000F03F000000000000F03F00E0F6ED72A1BD3E006005484900B13E671505AFC9D9DF3F36BB160D7AC1EBBF0400002058A9F6BF00000080725BF03F0000803F30A186BE000000000000F03F000000000000F03F000000000000F03F",
      "LocZ": -13806.431179789,
      "RotPitch": 0
    }
  },
  // 任务过场 (一般自动拍摄  自动拍摄时只会包含该数据段)
  // ? 猜测 : 旧版本自动拍摄时 只包含 PortraitModeHandler 数据段
  "PhotoWallPlugin": {
    "photoID": 171160301
    // 或者
    // "photoID": [
    //    1101260306
    //  ]
  },
  // 错位摄影
  // -1 -> 无
  // 其他 -> 错位摄影类型
  "PuzzleGamePlugin": {
    "Tag": -1
  },
  // 部分任务过场自动拍摄图只会包含该数据段
  "PortraitModeHandler": {
    // 默认 0
    // 启用“竖构图” 为 1
    "PortraitMode": 1
  },
  // 编辑图片的信息
  "EditPhotoHandler": {
    // 是否有贴纸
    "hasSticker": true,
    // 是否有文字
    "hasText": false,
    "editState": true
  },
  // 惊险拍摄
  "RiskPhoto": [
    // 自定义格式
    //:21:true
  ],
  // 任务框
  "InteractivePhoto": [
    // 自定义格式
    //:101369:true
  ],
  // 该属性仅世界巡游图片拥有
  "ClockGamePlugin": {
    "Tag": 101020111
  },
};




const DIYPhotoTemplate = {
  "Content": {
    "patternData": [
    // :1020600042:0
    ],
    "wearingClothes": [
      1020100042,
      1021410041,
      1020600042,
      1021780015,
      1021300051
    ],
    "wearingDIYInfos": [
      {
        "TargetGroupID": 1,
        "CoreData": {
          "ReplaceTextureID": 1330020001
        },
        "FeatureTag": 2,
        "TargetClothID": 1021300051
      }
    ]
  }
};








// 相机位置 (xyz, yaw/pitch/roll)

// 竖构图 0 (int 0 - 1)
// 焦距调节 15 (int 10mm - 55mm)
// 镜头旋转 0 (int -180 - 180)
// 光圈调节 15 (1 - 15)

// 晕影调节 40% (int 0% - 100%)
// 柔光强度 12% (int 0% - 100%)
// 柔光范围 -0.2 (double_1 -1.0 - 1.0)
// 亮度 58% (int 0% - 100%)
// 曝光 0.0 (double_1 -1.0 - 1.0)
// 对比度 31% (int 0% - 100%)
// 饱和度 -0.6 (double_1 -1.0 - 1.0)
// 自然饱和度 0.0 (double_1 -1.0 - 1.0)
// 高光 -0.4 (double_1 -1.0 - 1.0)
// 阴影 -0.2 (double_1 -1.0 - 1.0)

// 灯光类型 无 (不存在或 String id ? "None")
// 灯光强度 无 (不存在或 int 0% - 100%)

// 滤镜类型 无 (不存在或 String id ? "None")
// 滤镜强度 无 (不存在或 int 0% - 100%)
