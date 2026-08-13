import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:nikki_albums/utils/native_file_picker.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nikki_albums/utils/system/system.dart';
import 'package:nikki_albums/widgets/app/component.dart';
import 'package:nikki_albums/widgets/common/component.dart';
import "package:path/path.dart" as p;
import 'package:flutter/services.dart';
import 'package:nikki_albums/utils/ffmpeg_manager.dart';

class Mp4ToGifConverter {
  static Future<void> init() async {
    MediaKit.ensureInitialized();
  }

  static Future<void> convert({
    required String videoPath,
    required String outputPath,
    int fps = 10,
    int width = 480,
    double startTime = 0.0,
    double? duration,
    void Function(int current, int total)? onProgress,
  }) async {
    const MethodChannel channel = MethodChannel(
      'com.ranaxro.nikki.nikkiAlbums/live_photo',
    );
    if (Platform.isMacOS) {
      await channel.invokeMethod('exportToGif', {
        'inputPath': videoPath,
        'outputPath': outputPath,
        'fps': fps,
        'width': width,
        'startTime': startTime,
        'duration': duration ?? -1.0,
      });
      return;
    }

    if (Platform.isWindows) {
      // Assuming FFmpeg is already checked/downloaded before calling this
      final List<String> args = ['-y', '-ss', startTime.toStringAsFixed(3)];
      if (duration != null && duration > 0) {
        args.addAll(['-t', duration.toStringAsFixed(3)]);
      }
      args.addAll([
        '-i',
        videoPath,
        '-vf',
        'fps=$fps,scale=$width:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse',
        '-loop',
        '0',
        outputPath,
      ]);

      final result = await FFmpegManager.execute(args);
      if (result.exitCode != 0) {
        throw Exception('FFmpeg GIF conversion failed: ${result.stderr}');
      }
      return;
    }

    throw UnsupportedError('GIF conversion is not supported on this platform');
  }
}

class VideoToGifPanel extends StatefulWidget {
  final String videoPath;

  const VideoToGifPanel({super.key, required this.videoPath});

  @override
  State<VideoToGifPanel> createState() => _VideoToGifPanelState();
}

class _VideoToGifPanelState extends State<VideoToGifPanel> {
  final ValueNotifier<double> width = ValueNotifier(0);
  final ValueNotifier<double> height = ValueNotifier(0);
  final ValueNotifier<int> fps = ValueNotifier(10);
  late double ratio;
  late final TextEditingController widthTextController = TextEditingController(
    text: width.value.toInt().toString(),
  );
  late final TextEditingController heightTextController = TextEditingController(
    text: height.value.toInt().toString(),
  );
  late final TextEditingController fpsTextController = TextEditingController(
    text: fps.value.toInt().toString(),
  );
  final ValueNotifier<String?> widthError = ValueNotifier(null);
  final ValueNotifier<String?> heightError = ValueNotifier(null);
  final ValueNotifier<String?> fpsError = ValueNotifier(null);

  late final player = Player();
  late final controller = VideoController(player);

  void scaleMaxLineAuto(int maxLine) {
    final longest = max(width.value, height.value);
    final scale = maxLine / longest;
    width.value *= scale;
    height.value *= scale;
  }

  void setLine({double? w, double? h}) {
    if (w != null) {
      width.value = w;
      height.value = w / ratio;
    } else if (h != null) {
      height.value = h;
      width.value = h * ratio;
    }
  }

  String verifyInput(String source) {
    return source.replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.videoPath), play: false);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      maxWidth: smallCardMaxWidth,
      child: ValueListenableBuilder(
        valueListenable: controller.rect,
        builder: (BuildContext context, Rect? rect, Widget? child) {
          if (rect == null || rect.width == 0 || rect.height == 0) {
            return CircularProgressIndicator();
          }

          width.value = rect.width;
          height.value = rect.height;
          ratio = rect.width / rect.height;
          scaleMaxLineAuto(480);
          widthTextController.text = width.value.toInt().toString();
          heightTextController.text = height.value.toInt().toString();

          return Column(
            spacing: listSpacing,
            children: [
              AppTextFiled(
                controller: widthTextController,
                labelText: "width",
                onChanged: (String source) {
                  final TextSelection selection = widthTextController.selection;
                  widthTextController.text = verifyInput(source);
                  try {
                    widthTextController.selection = selection;
                  } catch (e) {}

                  final double? toValue = double.tryParse(
                    widthTextController.text,
                  );
                  if (toValue == null) {
                    widthError.value = "mustIsNumber";
                  } else {
                    if (toValue <= 0) {
                      widthError.value = "cannotIsNegativeNumber";
                    } else if (toValue == 1) {
                      widthError.value = "cannotIsZero";
                    } else {
                      if (toValue > 1080) {
                        widthError.value = "valueIsTooHigh";
                      } else {
                        widthError.value = null;
                      }
                      setLine(w: toValue);
                      heightTextController.text = height.value
                          .toInt()
                          .toString();
                    }
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: widthError,
                builder: (BuildContext context, String? error, Widget? child) {
                  if (error == null) {
                    return block0;
                  } else {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.tr(error),
                        style: TextStyle(
                          color: AppColorScheme.of(context).error.pressedColor,
                        ),
                      ),
                    );
                  }
                },
              ),
              AppTextFiled(
                controller: heightTextController,
                labelText: "height",
                onChanged: (String source) {
                  final TextSelection selection =
                      heightTextController.selection;
                  heightTextController.text = verifyInput(source);
                  try {
                    heightTextController.selection = selection;
                  } catch (e) {}

                  final double? toValue = double.tryParse(
                    heightTextController.text,
                  );
                  if (toValue == null) {
                    heightError.value = "mustIsNumber";
                  } else {
                    if (toValue <= 0) {
                      heightError.value = "cannotIsNegativeNumber";
                    } else if (toValue == 1) {
                      heightError.value = "cannotIsZero";
                    } else {
                      if (toValue > 1080) {
                        heightError.value = "valueIsTooHigh";
                      } else {
                        heightError.value = null;
                      }
                      setLine(h: toValue);
                      widthTextController.text = width.value.toInt().toString();
                    }
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: heightError,
                builder: (BuildContext context, String? error, Widget? child) {
                  if (error == null) {
                    return block0;
                  } else {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.tr(error),
                        style: TextStyle(
                          color: AppColorScheme.of(context).error.pressedColor,
                        ),
                      ),
                    );
                  }
                },
              ),
              AppTextFiled(
                controller: fpsTextController,
                labelText: "fps",
                onChanged: (String source) {
                  final TextSelection selection = fpsTextController.selection;
                  fpsTextController.text = verifyInput(source);
                  try {
                    fpsTextController.selection = selection;
                  } catch (e) {}

                  final double? toValue = double.tryParse(
                    fpsTextController.text,
                  );
                  if (toValue == null) {
                    fpsError.value = "mustIsNumber";
                  } else {
                    if (toValue <= 0) {
                      fpsError.value = "cannotIsNegativeNumber";
                    } else if (toValue == 1) {
                      fpsError.value = "cannotIsZero";
                    } else {
                      if (toValue > 25) {
                        fpsError.value = "valueIsTooHigh";
                      } else {
                        fpsError.value = null;
                      }
                      fps.value = toValue.toInt();
                    }
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: fpsError,
                builder: (BuildContext context, String? error, Widget? child) {
                  if (error == null) {
                    return block0;
                  } else {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.tr(error),
                        style: TextStyle(
                          color: AppColorScheme.of(context).error.pressedColor,
                        ),
                      ),
                    );
                  }
                },
              ),

              Row(
                children: [
                  Expanded(
                    child: AppButton.smallText(
                      onClick: () {
                        Navigator.of(context).pop();
                      },
                      child: AppText("cancel"),
                    ),
                  ),
                  Expanded(
                    child: MultiValueListenableBuilder(
                      listenables: [widthError, heightError, fpsError],
                      builder: (BuildContext context, Widget? child) {
                        final bool usable =
                            (widthError.value == null ||
                                widthError.value == "valueIsTooHigh") &&
                            (heightError.value == null ||
                                heightError.value == "valueIsTooHigh") &&
                            (fpsError.value == null ||
                                fpsError.value == "valueIsTooHigh");

                        return AppButton.smallText(
                          colorRole: ColorRole.highlight,
                          isTransparent: false,
                          usable: usable,
                          child: AppText("export"),
                          onClick: () async {
                            final String?
                            output = await NativeFilePicker.saveFile(
                              dialogTitle: context.tr("export"),
                              fileName:
                                  "${p.basenameWithoutExtension(widget.videoPath)}.gif",
                            );

                            if (output == null) return;

                            final ValueNotifier<double?> progress =
                                ValueNotifier<double?>(null);
                            BuildContext? navContext;
                            if (context.mounted) {
                              navContext = Navigator.of(context).context;
                              Navigator.of(context).pop();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (navContext != null && navContext.mounted) {
                                  showProgressBar(
                                    context: navContext,
                                    valueListenable: progress,
                                  );
                                }
                              });
                            }

                            try {
                              await Mp4ToGifConverter.init();
                              await Mp4ToGifConverter.convert(
                                videoPath: widget.videoPath,
                                outputPath: output,
                                fps: fps.value,
                                width: width.value.toInt(),
                                onProgress: (c, t) => progress.value = c / t,
                              );
                              Explorer.openFile(File(output));
                            } catch (e) {
                              if (navContext != null && navContext.mounted) {
                                ScaffoldMessenger.of(navContext).showSnackBar(
                                  SnackBar(content: Text('GIF 导出失败: $e')),
                                );
                              }
                            } finally {
                              progress.value = 1.0;
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
