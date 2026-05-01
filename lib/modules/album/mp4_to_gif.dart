import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nikki_albums/utils/system/system.dart';
import 'package:nikki_albums/widgets/app/component.dart';
import 'package:nikki_albums/widgets/common/component.dart';
import "package:path/path.dart" as p;

class Mp4ToGifConverter{
  static Future<void> init() async{
    MediaKit.ensureInitialized();
  }

  /// 精确等待 seek 完成：监听 position + buffering，而非硬编码 delay
  static Future<void> _waitSeek(Player player, Duration target, {int toleranceMs = 150, int timeoutMs = 1200}) async{
    final completer = Completer<void>();
    Timer? timer;
    StreamSubscription? posSub;
    StreamSubscription? bufSub;

    void cleanup(){
      timer?.cancel();
      posSub?.cancel();
      bufSub?.cancel();
    }

    void tryComplete() {
      if (completer.isCompleted) return;
      final pos = player.state.position;
      final buffering = player.state.buffering;
      if ((pos - target).inMilliseconds.abs() <= toleranceMs && !buffering) {
        completer.complete();
        cleanup();
      }
    }

    posSub = player.stream.position.listen((_) => tryComplete());
    bufSub = player.stream.buffering.listen((buffering) {
      if (!buffering) tryComplete();
    });

    timer = Timer(Duration(milliseconds: timeoutMs), () {
      if (!completer.isCompleted) {
        completer.complete(); // 超时兜底，避免卡死
        cleanup();
      }
    });

    await completer.future;
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
    final player = Player();
    final controller = VideoController(player);

    try {
      await player.open(Media(videoPath));
      await player.pause();

      await controller.waitUntilFirstFrameRendered;

      final videoDuration = player.state.duration;
      if (videoDuration <= Duration.zero) {
        throw Exception('无法获取视频时长');
      }

      // ===== 关键修改 1：从 controller.rect 获取渲染尺寸 =====
      final rect = controller.rect.value;
      if (rect == null || rect.width <= 0 || rect.height <= 0) {
        throw Exception('无法获取视频尺寸');
      }
      final videoWidth = rect.width.round();
      final videoHeight = rect.height.round();

      final totalDurationSec = videoDuration.inMilliseconds / 1000.0;
      final endTime = duration != null
          ? (startTime + duration).clamp(0.0, totalDurationSec)
          : totalDurationSec;
      final actualDuration = endTime - startTime;

      if (actualDuration <= 0) throw Exception('截取时长无效');

      final frameCount = (actualDuration * fps).ceil();
      final interval = actualDuration / frameCount;

      final encoder = img.GifEncoder();
      final delayInHundredths = (100 / fps).round().clamp(1, 65535);
      int addedFrames = 0;

      final bool needResize = width > 0 && width != videoWidth;

      for (int i = 0; i < frameCount; i++) {
        final timeSec = startTime + i * interval;
        final position = Duration(milliseconds: (timeSec * 1000).round());

        await player.seek(position);
        await _waitSeek(player, position, timeoutMs: 800);

        // ===== 关键修改 2：获取 BGRA 原始像素数据，跳过 JPEG 编解码 =====
        Uint8List? bytes;
        for (int retry = 0; retry < 2; retry++) {
          bytes = await player.screenshot(format: null);
          if (bytes != null && bytes.isNotEmpty) break;
        }
        if (bytes == null || bytes.isEmpty) continue;

        // 校验 BGRA 数据长度（宽 × 高 × 4 字节/像素）
        final expectedLength = videoWidth * videoHeight * 4;
        if (bytes.length < expectedLength) continue;

        // ===== 关键修改 3：直接从 BGRA 字节构建 Image，无需 decodeJpg =====
        final raw = img.Image.fromBytes(
          width: videoWidth,
          height: videoHeight,
          bytes: bytes.buffer,
          order: img.ChannelOrder.bgra, // 直接按 BGRA 通道顺序解析
        );

        final frame = needResize
            ? img.copyResize(
          raw,
          width: width,
          height: (videoHeight * width / videoWidth).round(),
          interpolation: img.Interpolation.linear,
        )
            : raw;

        encoder.addFrame(frame, duration: delayInHundredths);
        addedFrames++;
        onProgress?.call(i + 1, frameCount);
      }

      if (addedFrames == 0) throw Exception('未能提取任何帧');

      final gifBytes = encoder.finish();
      if (gifBytes == null) throw Exception('GIF 编码失败');

      await File(outputPath).writeAsBytes(gifBytes);
    } finally {
      await player.dispose();
    }
  }
}


class VideoToGifPanel extends StatefulWidget{
  final String videoPath;

  const VideoToGifPanel({
    super.key,
    required this.videoPath,
  });

  @override
  State<VideoToGifPanel> createState() => _VideoToGifPanelState();
}
class _VideoToGifPanelState extends State<VideoToGifPanel>{
  final ValueNotifier<double> width = ValueNotifier(0);
  final ValueNotifier<double> height = ValueNotifier(0);
  final ValueNotifier<int> fps = ValueNotifier(10);
  late double ratio;
  late final TextEditingController widthTextController = TextEditingController(text: width.value.toInt().toString());
  late final TextEditingController heightTextController = TextEditingController(text: height.value.toInt().toString());
  late final TextEditingController fpsTextController = TextEditingController(text: fps.value.toInt().toString());
  final ValueNotifier<String?> widthError = ValueNotifier(null);
  final ValueNotifier<String?> heightError = ValueNotifier(null);
  final ValueNotifier<String?> fpsError = ValueNotifier(null);

  late final player = Player();
  late final controller = VideoController(player);

  void scaleMaxLineAuto(int maxLine){
    final longest = max(width.value, height.value);
    final scale = maxLine / longest;
    width.value *= scale;
    height.value *= scale;
  }

  void setLine({double? w, double? h}){
    if(w != null){
      width.value = w;
      height.value = w / ratio;
    }else if(h != null){
      height.value = h;
      width.value = h * ratio;
    }
  }

  String verifyInput(String source){
    return source.replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  void initState(){
    super.initState();
    player.open(Media(widget.videoPath), play: false);
  }

  @override
  void dispose(){
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return AppDialog(
      maxWidth: smallCardMaxWidth,
      child: ValueListenableBuilder(
        valueListenable: controller.rect,
        builder: (BuildContext context, Rect? rect, Widget? child){
          if(rect == null || rect.width == 0 || rect.height == 0){
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
                onChanged: (String source){
                  final TextSelection selection = widthTextController.selection;
                  widthTextController.text = verifyInput(source);
                  try{
                    widthTextController.selection = selection;
                  }catch(e){}

                  final double? toValue = double.tryParse(widthTextController.text);
                  if(toValue == null){
                    widthError.value = "mustIsNumber";
                  }else{
                    if(toValue <= 0){
                      widthError.value = "cannotIsNegativeNumber";
                    }else if(toValue == 1){
                      widthError.value = "cannotIsZero";
                    }else{
                      if(toValue > 1080){
                        widthError.value = "valueIsTooHigh";
                      }else{
                        widthError.value = null;
                      }
                      setLine(w: toValue);
                      heightTextController.text = height.value.toInt().toString();
                    }
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: widthError,
                builder: (BuildContext context, String? error, Widget? child){
                  if(error == null){
                    return block0;
                  }else{
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(context.tr(error), style: TextStyle(color: AppColorScheme.of(context).error.pressedColor)),
                    );
                  }
                },
              ),
              AppTextFiled(
                controller: heightTextController,
                labelText: "height",
                onChanged: (String source){
                  final TextSelection selection = heightTextController.selection;
                  heightTextController.text = verifyInput(source);
                  try{
                    heightTextController.selection = selection;
                  }catch(e){}

                  final double? toValue = double.tryParse(heightTextController.text);
                  if(toValue == null){
                    heightError.value = "mustIsNumber";
                  }else{
                    if(toValue <= 0){
                      heightError.value = "cannotIsNegativeNumber";
                    }else if(toValue == 1){
                      heightError.value = "cannotIsZero";
                    }else{
                      if(toValue > 1080){
                        heightError.value = "valueIsTooHigh";
                      }else{
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
                builder: (BuildContext context, String? error, Widget? child){
                  if(error == null){
                    return block0;
                  }else{
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(context.tr(error), style: TextStyle(color: AppColorScheme.of(context).error.pressedColor)),
                    );
                  }
                },
              ),
              AppTextFiled(
                controller: fpsTextController,
                labelText: "fps",
                onChanged: (String source){
                  final TextSelection selection = fpsTextController.selection;
                  fpsTextController.text = verifyInput(source);
                  try{
                    fpsTextController.selection = selection;
                  }catch(e){}

                  final double? toValue = double.tryParse(fpsTextController.text);
                  if(toValue == null){
                    fpsError.value = "mustIsNumber";
                  }else{
                    if(toValue <= 0){
                      fpsError.value = "cannotIsNegativeNumber";
                    }else if(toValue == 1){
                      fpsError.value = "cannotIsZero";
                    }else{
                      if(toValue > 25){
                        fpsError.value = "valueIsTooHigh";
                      }else{
                        fpsError.value = null;
                      }
                      fps.value = toValue.toInt();
                    }
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: fpsError,
                builder: (BuildContext context, String? error, Widget? child){
                  if(error == null){
                    return block0;
                  }else{
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(context.tr(error), style: TextStyle(color: AppColorScheme.of(context).error.pressedColor)),
                    );
                  }
                },
              ),


              Row(
                children: [
                  Expanded(
                    child: AppButton.smallText(
                      onClick: (){
                        Navigator.of(context).pop();
                      },
                      child: AppText("cancel"),
                    ),
                  ),
                  Expanded(
                    child: MultiValueListenableBuilder(
                      listenables: [widthError, heightError, fpsError],
                      builder: (BuildContext context, Widget? child){
                        final bool usable = (widthError.value == null || widthError.value == "valueIsTooHigh")
                          && (heightError.value == null || heightError.value == "valueIsTooHigh")
                          && (fpsError.value == null || fpsError.value == "valueIsTooHigh");

                        return AppButton.smallText(
                          colorRole: ColorRole.highlight,
                          isTransparent: false,
                          onClick: () async{
                            final String? output = await FilePicker.platform.saveFile(
                              dialogTitle: context.tr("export"),
                              fileName: "${p.basenameWithoutExtension(widget.videoPath)}.gif",
                              type: FileType.image,
                              allowedExtensions: ["gif"],
                              lockParentWindow: true,
                            );

                            if(output == null) return;


                            final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
                            if(context.mounted){
                              Navigator.of(context).pop();
                              WidgetsBinding.instance.addPostFrameCallback((_){
                                showProgressBar(
                                  context: context,
                                  valueListenable: progress,
                                );
                              });
                            }

                            await Mp4ToGifConverter.init();
                            await Mp4ToGifConverter.convert(
                              videoPath: widget.videoPath,
                              outputPath: output,
                              fps: fps.value,
                              width: width.value.toInt(),
                              onProgress: (c, t) => progress.value = c / t,
                            );

                            Explorer.openFile(File(output));
                          },
                          usable: usable,
                          child: AppText("export"),
                        );
                      },
                    ),
                  ),
                ],
              )

            ],
          );
        },
      ),
    );
  }
}