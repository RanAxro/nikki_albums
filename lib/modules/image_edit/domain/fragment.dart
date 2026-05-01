import "package:nikki_albums/utils/math/transform.dart";

import "package:flutter/material.dart";
import "dart:ui" as ui;

/// The sequence is from Darktable - Display-referred
enum ImageFragmentType {
  temperature,
  tint,
  lightSense,
  exposure,
  brightness,
  contrast,
  highlights,
  shadows,
  whites,
  blacks,
  vibrance,
  saturation,
  hslHue,
  hslSaturation,
  hslLightness,
  cyanRed,
  magentaGreen,
  yellowBlue,
  clarity,
  fade,
}

class ImageFragmentParamDef {
  static const ImageFragmentParamDef temperature = ImageFragmentParamDef(
    ImageFragmentType.temperature,
    "image_edit.temperature",
    -1.0,
    1.0,
    0,
    colors: [Color(0xFF3B82F6), Color(0xFFF97316)],
  );
  static const ImageFragmentParamDef tint = ImageFragmentParamDef(
    ImageFragmentType.tint,
    "image_edit.tint",
    -1.0,
    1.0,
    0,
    colors: [Color(0xFF84CC16), Color(0xFFA855F7)],
  );
  static const ImageFragmentParamDef lightSense = ImageFragmentParamDef(
    ImageFragmentType.lightSense,
    "image_edit.lightSense",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef exposure = ImageFragmentParamDef(
    ImageFragmentType.exposure,
    "image_edit.exposure",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef brightness = ImageFragmentParamDef(
    ImageFragmentType.brightness,
    "image_edit.brightness",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef contrast = ImageFragmentParamDef(
    ImageFragmentType.contrast,
    "image_edit.contrast",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef highlights = ImageFragmentParamDef(
    ImageFragmentType.highlights,
    "image_edit.highlights",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef shadows = ImageFragmentParamDef(
    ImageFragmentType.shadows,
    "image_edit.shadows",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef whites = ImageFragmentParamDef(
    ImageFragmentType.whites,
    "image_edit.whites",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef blacks = ImageFragmentParamDef(
    ImageFragmentType.blacks,
    "image_edit.blacks",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef vibrance = ImageFragmentParamDef(
    ImageFragmentType.vibrance,
    "image_edit.vibrance",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef saturation = ImageFragmentParamDef(
    ImageFragmentType.saturation,
    "image_edit.saturation",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef hslHue = ImageFragmentParamDef(
    ImageFragmentType.hslHue,
    "image_edit.hsl_hue",
    -1.0,
    1.0,
    0,
    hue: true,
  );
  static const ImageFragmentParamDef hslSaturation = ImageFragmentParamDef(
    ImageFragmentType.hslSaturation,
    "image_edit.hsl_saturation",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef hslLightness = ImageFragmentParamDef(
    ImageFragmentType.hslLightness,
    "image_edit.hsl_lightness",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef cyanRed = ImageFragmentParamDef(
    ImageFragmentType.cyanRed,
    "image_edit.cyan_red",
    -1.0,
    1.0,
    0,
    colors: [Color(0xFF06B6D4), Color(0xFFEF4444)],
  );
  static const ImageFragmentParamDef magentaGreen = ImageFragmentParamDef(
    ImageFragmentType.magentaGreen,
    "image_edit.magenta_green",
    -1.0,
    1.0,
    0,
    colors: [Color(0xFFD946EF), Color(0xFF22C55E)],
  );
  static const ImageFragmentParamDef yellowBlue = ImageFragmentParamDef(
    ImageFragmentType.yellowBlue,
    "image_edit.yellow_blue",
    -1.0,
    1.0,
    0,
    colors: [Color(0xFFEAB308), Color(0xFF3B82F6)],
  );
  static const ImageFragmentParamDef clarity = ImageFragmentParamDef(
    ImageFragmentType.clarity,
    "image_edit.clarity",
    -1.0,
    1.0,
    0,
  );
  static const ImageFragmentParamDef fade = ImageFragmentParamDef(
    ImageFragmentType.fade,
    "image_edit.fade",
    0.0,
    1.0,
    0,
  );

  static const Map<ImageFragmentType, ImageFragmentParamDef> _def = {
    ImageFragmentType.temperature: temperature,
    ImageFragmentType.tint: tint,
    ImageFragmentType.lightSense: lightSense,
    ImageFragmentType.exposure: exposure,
    ImageFragmentType.brightness: brightness,
    ImageFragmentType.contrast: contrast,
    ImageFragmentType.highlights: highlights,
    ImageFragmentType.shadows: shadows,
    ImageFragmentType.whites: whites,
    ImageFragmentType.blacks: blacks,
    ImageFragmentType.vibrance: vibrance,
    ImageFragmentType.saturation: saturation,
    ImageFragmentType.hslHue: hslHue,
    ImageFragmentType.hslSaturation: hslSaturation,
    ImageFragmentType.hslLightness: hslLightness,
    ImageFragmentType.cyanRed: cyanRed,
    ImageFragmentType.magentaGreen: magentaGreen,
    ImageFragmentType.yellowBlue: yellowBlue,
    ImageFragmentType.clarity: clarity,
    ImageFragmentType.fade: fade,
  };

  static ImageFragmentParamDef by(ImageFragmentType type) => _def[type]!;

  final ImageFragmentType type;
  final String key;
  final double min;
  final double max;
  final double defaultValue;
  final List<Color>? colors;
  final bool hue;

  const ImageFragmentParamDef(
    this.type,
    this.key,
    this.min,
    this.max,
    this.defaultValue, {
    this.colors,
    this.hue = false,
  });
}

class ImageFragmentParams {
  static final ImageFragmentParams defaultParams = ImageFragmentParams(
    temperature: ImageFragmentParamDef.temperature.defaultValue,
    tint: ImageFragmentParamDef.tint.defaultValue,
    lightSense: ImageFragmentParamDef.lightSense.defaultValue,
    exposure: ImageFragmentParamDef.exposure.defaultValue,
    brightness: ImageFragmentParamDef.brightness.defaultValue,
    contrast: ImageFragmentParamDef.contrast.defaultValue,
    highlights: ImageFragmentParamDef.highlights.defaultValue,
    shadows: ImageFragmentParamDef.shadows.defaultValue,
    whites: ImageFragmentParamDef.whites.defaultValue,
    blacks: ImageFragmentParamDef.blacks.defaultValue,
    vibrance: ImageFragmentParamDef.vibrance.defaultValue,
    saturation: ImageFragmentParamDef.saturation.defaultValue,
    hslHue: ImageFragmentParamDef.hslHue.defaultValue,
    hslSaturation: ImageFragmentParamDef.hslSaturation.defaultValue,
    hslLightness: ImageFragmentParamDef.hslLightness.defaultValue,
    cyanRed: ImageFragmentParamDef.cyanRed.defaultValue,
    magentaGreen: ImageFragmentParamDef.magentaGreen.defaultValue,
    yellowBlue: ImageFragmentParamDef.yellowBlue.defaultValue,
    clarity: ImageFragmentParamDef.clarity.defaultValue,
    fade: ImageFragmentParamDef.fade.defaultValue,
  );

  final double temperature;
  final double tint;
  final double lightSense;
  final double exposure;
  final double brightness;
  final double contrast;
  final double highlights;
  final double shadows;
  final double whites;
  final double blacks;
  final double vibrance;
  final double saturation;
  final double hslHue;
  final double hslSaturation;
  final double hslLightness;
  final double cyanRed;
  final double magentaGreen;
  final double yellowBlue;
  final double clarity;
  final double fade;

  const ImageFragmentParams({
    required this.temperature,
    required this.tint,
    required this.lightSense,
    required this.exposure,
    required this.brightness,
    required this.contrast,
    required this.highlights,
    required this.shadows,
    required this.whites,
    required this.blacks,
    required this.vibrance,
    required this.saturation,
    required this.hslHue,
    required this.hslSaturation,
    required this.hslLightness,
    required this.cyanRed,
    required this.magentaGreen,
    required this.yellowBlue,
    required this.clarity,
    required this.fade,
  });

  factory ImageFragmentParams.withValues({
    double? temperature,
    double? tint,
    double? lightSense,
    double? exposure,
    double? brightness,
    double? contrast,
    double? highlights,
    double? shadows,
    double? whites,
    double? blacks,
    double? vibrance,
    double? saturation,
    double? hslHue,
    double? hslSaturation,
    double? hslLightness,
    double? cyanRed,
    double? magentaGreen,
    double? yellowBlue,
    double? clarity,
    double? fade,
  }) {
    return defaultParams.copyWithValues(
      temperature: temperature,
      tint: tint,
      lightSense: lightSense,
      exposure: exposure,
      brightness: brightness,
      contrast: contrast,
      highlights: highlights,
      shadows: shadows,
      whites: whites,
      blacks: blacks,
      vibrance: vibrance,
      saturation: saturation,
      hslHue: hslHue,
      hslSaturation: hslSaturation,
      hslLightness: hslLightness,
      cyanRed: cyanRed,
      magentaGreen: magentaGreen,
      yellowBlue: yellowBlue,
      clarity: clarity,
      fade: fade,
    );
  }

  factory ImageFragmentParams.withMap(Map<ImageFragmentType, double> map) {
    return defaultParams.copyWithMap(map);
  }

  double by(ImageFragmentType type) => switch (type) {
    ImageFragmentType.temperature => temperature,
    ImageFragmentType.tint => tint,
    ImageFragmentType.lightSense => lightSense,
    ImageFragmentType.exposure => exposure,
    ImageFragmentType.brightness => brightness,
    ImageFragmentType.contrast => contrast,
    ImageFragmentType.highlights => highlights,
    ImageFragmentType.shadows => shadows,
    ImageFragmentType.whites => whites,
    ImageFragmentType.blacks => blacks,
    ImageFragmentType.vibrance => vibrance,
    ImageFragmentType.saturation => saturation,
    ImageFragmentType.hslHue => hslHue,
    ImageFragmentType.hslSaturation => hslSaturation,
    ImageFragmentType.hslLightness => hslLightness,
    ImageFragmentType.cyanRed => cyanRed,
    ImageFragmentType.magentaGreen => magentaGreen,
    ImageFragmentType.yellowBlue => yellowBlue,
    ImageFragmentType.clarity => clarity,
    ImageFragmentType.fade => fade,
  };

  ImageFragmentParams copyWithValues({
    double? temperature,
    double? tint,
    double? lightSense,
    double? exposure,
    double? brightness,
    double? contrast,
    double? highlights,
    double? shadows,
    double? whites,
    double? blacks,
    double? vibrance,
    double? saturation,
    double? hslHue,
    double? hslSaturation,
    double? hslLightness,
    double? cyanRed,
    double? magentaGreen,
    double? yellowBlue,
    double? clarity,
    double? fade,
    double? blur,
  }) {
    return ImageFragmentParams(
      temperature: temperature ?? this.temperature,
      tint: tint ?? this.tint,
      lightSense: lightSense ?? this.lightSense,
      exposure: exposure ?? this.exposure,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      highlights: highlights ?? this.highlights,
      shadows: shadows ?? this.shadows,
      whites: whites ?? this.whites,
      blacks: blacks ?? this.blacks,
      vibrance: vibrance ?? this.vibrance,
      saturation: saturation ?? this.saturation,
      hslHue: hslHue ?? this.hslHue,
      hslSaturation: hslSaturation ?? this.hslSaturation,
      hslLightness: hslLightness ?? this.hslLightness,
      cyanRed: cyanRed ?? this.cyanRed,
      magentaGreen: magentaGreen ?? this.magentaGreen,
      yellowBlue: yellowBlue ?? this.yellowBlue,
      clarity: clarity ?? this.clarity,
      fade: fade ?? this.fade,
    );
  }

  ImageFragmentParams copyWithMap(Map<ImageFragmentType, double> map) {
    return ImageFragmentParams(
      temperature: map[ImageFragmentType.temperature] ?? temperature,
      tint: map[ImageFragmentType.tint] ?? tint,
      lightSense: map[ImageFragmentType.lightSense] ?? lightSense,
      exposure: map[ImageFragmentType.exposure] ?? exposure,
      brightness: map[ImageFragmentType.brightness] ?? brightness,
      contrast: map[ImageFragmentType.contrast] ?? contrast,
      highlights: map[ImageFragmentType.highlights] ?? highlights,
      shadows: map[ImageFragmentType.shadows] ?? shadows,
      whites: map[ImageFragmentType.whites] ?? whites,
      blacks: map[ImageFragmentType.blacks] ?? blacks,
      vibrance: map[ImageFragmentType.vibrance] ?? vibrance,
      saturation: map[ImageFragmentType.saturation] ?? saturation,
      hslHue: map[ImageFragmentType.hslHue] ?? hslHue,
      hslSaturation: map[ImageFragmentType.hslSaturation] ?? hslSaturation,
      hslLightness: map[ImageFragmentType.hslLightness] ?? hslLightness,
      cyanRed: map[ImageFragmentType.cyanRed] ?? cyanRed,
      magentaGreen: map[ImageFragmentType.magentaGreen] ?? magentaGreen,
      yellowBlue: map[ImageFragmentType.yellowBlue] ?? yellowBlue,
      clarity: map[ImageFragmentType.clarity] ?? clarity,
      fade: map[ImageFragmentType.fade] ?? fade,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ImageFragmentParams &&
            other.temperature == temperature &&
            other.tint == tint &&
            other.lightSense == lightSense &&
            other.exposure == exposure &&
            other.brightness == brightness &&
            other.contrast == contrast &&
            other.highlights == highlights &&
            other.shadows == shadows &&
            other.whites == whites &&
            other.blacks == blacks &&
            other.vibrance == vibrance &&
            other.saturation == saturation &&
            other.hslHue == hslHue &&
            other.hslSaturation == hslSaturation &&
            other.hslLightness == hslLightness &&
            other.cyanRed == cyanRed &&
            other.magentaGreen == magentaGreen &&
            other.yellowBlue == yellowBlue &&
            other.clarity == clarity &&
            other.fade == fade;
  }

  @override
  int get hashCode => Object.hashAll([
    temperature,
    tint,
    lightSense,
    exposure,
    brightness,
    contrast,
    highlights,
    shadows,
    whites,
    blacks,
    vibrance,
    saturation,
    hslHue,
    hslSaturation,
    hslLightness,
    cyanRed,
    magentaGreen,
    yellowBlue,
    clarity,
    fade,
  ]);
}

class ImageFragmentProgram {
  static ui.FragmentProgram? _program;

  static Future<ImageFragmentProgram> load() async {
    return ImageFragmentProgram._(
      _program ??= await ui.FragmentProgram.fromAsset(
        "assets/shaders/image_fragment.frag",
      ),
    );
  }

  final ui.FragmentProgram program;

  const ImageFragmentProgram._(this.program);

  ui.FragmentShader shaderWith(
    ui.Image image,
    double offsetX,
    double offsetY,
    double width,
    double height,
    ImageFragmentParams params,
  ) {
    final ui.FragmentShader shader = program.fragmentShader();

    int idx = 0;

    // vec2 offset
    shader.setFloat(idx++, offsetX);
    shader.setFloat(idx++, offsetY);

    // vec2 size
    shader.setFloat(idx++, width);
    shader.setFloat(idx++, height);

    // sampler2D image
    shader.setImageSampler(0, image);

    shader.setFloat(idx++, params.temperature);
    shader.setFloat(idx++, params.tint);
    shader.setFloat(idx++, params.lightSense);
    shader.setFloat(idx++, params.exposure);
    shader.setFloat(idx++, params.brightness);
    shader.setFloat(idx++, params.contrast);
    shader.setFloat(idx++, params.highlights);
    shader.setFloat(idx++, params.shadows);
    shader.setFloat(idx++, params.whites);
    shader.setFloat(idx++, params.blacks);
    shader.setFloat(idx++, params.vibrance);
    shader.setFloat(idx++, params.saturation);
    shader.setFloat(idx++, params.hslHue);
    shader.setFloat(idx++, params.hslSaturation);
    shader.setFloat(idx++, params.hslLightness);
    shader.setFloat(idx++, params.cyanRed);
    shader.setFloat(idx++, params.magentaGreen);
    shader.setFloat(idx++, params.yellowBlue);
    shader.setFloat(idx++, params.clarity);
    shader.setFloat(idx++, params.fade);

    return shader;
  }
}

class ImageFragmentPainter extends CustomPainter {
  final ui.Image image;
  final ImageFragmentParams params;
  final ImageFragmentProgram shader;

  const ImageFragmentPainter({
    required this.image,
    required this.params,
    required this.shader,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final Size drawSize = fitRectangleSize(size, imageSize);
    final Offset offset = centerRectangle(size, drawSize);

    canvas.drawRect(
      Rect.fromLTWH(offset.dx, offset.dy, drawSize.width, drawSize.height),
      Paint()
        ..shader = shader.shaderWith(
          image,
          offset.dx,
          offset.dy,
          drawSize.width,
          drawSize.height,
          params,
        ),
    );
  }

  @override
  bool shouldRepaint(ImageFragmentPainter oldDelegate) =>
      oldDelegate.params != params;
}

class ImageFragmentHandler {
  final ui.Image image;

  const ImageFragmentHandler({required this.image});

  Future<ui.Image> handle(
    ImageFragmentParams params, {
    ImageFragmentProgram? shader,
  }) async {
    final double width = image.width.toDouble();
    final double height = image.height.toDouble();

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final ImageFragmentProgram program =
        shader ?? await ImageFragmentProgram.load();

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..shader = program.shaderWith(image, 0, 0, width, height, params),
    );

    final ui.Picture picture = recorder.endRecording();
    return await picture.toImage(image.width, image.height);
  }
}
