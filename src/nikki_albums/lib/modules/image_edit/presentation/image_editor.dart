

import "package:easy_localization/easy_localization.dart";
import "package:nikkialbums/modules/image_edit/domain/cropping.dart";
import "package:nikkialbums/modules/image_edit/domain/editor.dart";
import "package:nikkialbums/modules/image_edit/presentation/image_cropping.dart";

import "../domain/fragment.dart";
import "package:nikkialbums/widgets/app/component.dart";
import "package:nikkialbums/widgets/common/component.dart";
import "package:nikkialbums/utils/image/dominant_color.dart";
import "package:nikkialbums/utils/color/hsl.dart";

import "package:flutter/material.dart";
import "dart:ui" as ui;
import "dart:io";
import "dart:typed_data";

import "package:multi_split_view/multi_split_view.dart";
import "package:file_picker/file_picker.dart";
import "package:path/path.dart" as p;




class ImageEditor extends StatefulWidget{
  final String imagePath;
  final ImageEditorController? controller;
  final Duration duration;
  final Curve curve;

  const ImageEditor({
    super.key,
    required this.imagePath,
    this.controller,
    this.duration = animationTime,
    this.curve = animationCurve,
  });

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}
class _ImageEditorState extends State<ImageEditor>{
  static final Map<ImageEditPlate, int> _plateMap = {
    ImageEditPlate.cropping: 0,
    ImageEditPlate.colorTuning: 1,
  };


  bool isInit = false;
  late final ImageEditorController controller;
  late final PageController pageController;
  late final ui.Image image;
  late final ImageCroppingController croppingController;
  late final ImageCroppingHandler croppingHandler;
  late Future<ui.Image> croppedImage;
  late final Color domainColor;
  late final ImageFragmentProgram program;

  Future<void> init() async{
    if(isInit) return;

    controller = widget.controller ?? ImageEditorController(initPlate: ImageEditPlate.colorTuning);
    controller.onPlateUpdate.addListener(onPlateUpdate);
    controller.onCroppingUpdate.addListener(onCroppingUpdate);

    pageController = PageController(initialPage: _plateMap[controller.plate]!);
    final Uint8List bytes = await File(widget.imagePath).readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    image = (await codec.getNextFrame()).image;
    croppingController = ImageCroppingController.fromParams(
      width: image.width.toDouble(),
      height: image.height.toDouble(),
      params: ImageCroppingParams.defaultParams,
    );
    croppingHandler = ImageCroppingHandler(image: image);
    croppedImage = Future<ui.Image>.value(image);
    domainColor = await getDominantColor(bytes) ?? Colors.grey;
    program = await ImageFragmentProgram.load();
  }

  @override
  void initState(){
    super.initState();
    init().then((_){
      setState((){
        isInit = true;
      });
    });
  }

  void onCroppingUpdate() async{
    croppingController.params = controller.current.cropping;
    final ui.Image cropped = await croppedImage;
    if(cropped != image){
      cropped.dispose();
    }
    croppedImage = croppingHandler.handle(croppingController.params);
  }

  void onPlateUpdate(){
    pageController.animateToPage(_plateMap[controller.plate]!, duration: widget.duration, curve: widget.curve);
  }

  void saveCroppingParams(){
    controller.setCropping(croppingController.params);
    controller.save();
  }

  void export(BuildContext context) async{
    saveCroppingParams();

    late final bool res;
    dynamic error;

    try{
      res = await exportFile(context);
    }catch(e){
      error = e;
      res = false;
    }

    if(res){
      if(context.mounted){
        AppToast.showMessage(
          context: context,
          state: true,
          message: context.tr("image_edit.export_successful"),
        );
      }
    }else if(!res && error != null){
      if(context.mounted){
        Navigator.of(context).pop();
        AppToast.showMessage(
          context: context,
          state: false,
          message: "${context.tr("image_edit.export_failed")}\n$error",
        );
      }
    }

    // showAppDialog(
    //   context: context,
    //   builder: (BuildContext context){
    //     return AppDialog(
    //       useIntrinsicHeight: false,
    //       child: EditedImageExportPanel(
    //         image: image,
    //         params: controller.lastSaved,
    //       ),
    //     );
    //   }
    // );
  }

  Future<bool> exportFile(BuildContext context) async{
    final String filename = "${p.basenameWithoutExtension(widget.imagePath)}.png";

    final String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: context.tr("image_edit.export_to"),
      fileName: filename,
      type: FileType.custom,
      allowedExtensions: ["png"],
      lockParentWindow: true,
    );

    if(outputFile == null) return false;

    if(context.mounted){
      AppToast.showMessage(
        context: context,
        state: true,
        message: context.tr("image_edit.exporting"),
      );
    }

    final ImageEditHandler handler = ImageEditHandler(image: image);
    final ui.Image processed = await handler.handle(controller.lastSaved);
    final ByteData? bytes = await processed.toByteData(format: ui.ImageByteFormat.png);

    if(bytes == null) return false;

    File(outputFile).writeAsBytes(bytes.buffer.asUint8List());

    return true;
  }

  Widget buildSlider(ImageFragmentType type){
    final ImageFragmentParamDef def = ImageFragmentParamDef.by(type);

    return Container(
      padding: const EdgeInsets.fromLTRB(smallPadding, smallPadding, smallPadding, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(smallBorderRadius)),
        color: AppColorScheme.of(context).background.enabledColor,
      ),
      child: Column(
        children: [
          Row(
            spacing: listSpacing,
            children: [
              AppText(ImageFragmentParamDef.by(type).key),
              Expanded(child: block0),
              AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget? child){
                  return AppText((100 * controller.current.fragment.by(type)).toInt().toString(), isTranslate: false);
                },
              ),
              AppButton.smallIcon(
                toolTip: "reset",
                onClick: (){
                  controller.set(controller.current.withFragment(controller.current.fragment.copyWithMap({
                    type: def.defaultValue,
                  })));
                  controller.save();
                },
                child: AppIcon("refresh"),
              ),
            ],
          ),

          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget? child){
              late final Gradient? gradient;
              if(ImageFragmentParamDef.by(type).colors != null){
                gradient = LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: ImageFragmentParamDef.by(type).colors!,
                  tileMode: TileMode.clamp,
                );
              }else if(ImageFragmentParamDef.by(type).hue){
                gradient = LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: getHueGradientColor(domainColor),
                  tileMode: TileMode.clamp,
                );
              }else{
                gradient = null;
              }

              return AppSlider(
                value: controller.current.fragment.by(type),
                min: def.min,
                max: def.max,
                divisions: (100 * (def.max - def.min)).toInt(),
                onChanged: (double value){
                  controller.set(controller.current.withFragment(controller.current.fragment.copyWithMap({
                    type: value,
                  })));
                },
                onChangeEnd: (double value){
                  controller.save();
                },
                gradient: gradient,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    if(!isInit){
      return Container(
        padding: const EdgeInsets.all(smallPadding),
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          backgroundColor: AppTheme.of(context)!.colorScheme.primary.color,
          color: AppTheme.of(context)!.colorScheme.primary.onColor,
          constraints: const BoxConstraints(
            maxWidth: 50,
            maxHeight: 50,
          ),
        ),
      );
    }

    return (){
      final Widget topBar = SizedBox(
        height: topBarHeight,
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton.smallIcon(
                      onClick: Navigator.of(context).pop,
                      child: AppIcon("cross"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListenableBuilder(
                  listenable: controller,
                  builder: (BuildContext context, Widget? child){
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton.smallIcon(
                          toolTip: "image_edit.undo",
                          onClick: (){
                            controller.undo();
                          },
                          usable: controller.canUndo,
                          child: AppIcon("undo"),
                        ),
                        AppButton.smallIcon(
                          toolTip: "image_edit.redo",
                          onClick: (){
                            controller.redo();
                          },
                          usable: controller.canRedo,
                          child: AppIcon("redo"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // AppButton.smallText(
                    //   child: AppText("保存为草稿"),
                    // ),
                    AppButton.smallText(
                      onClick: (){
                        export(context);
                      },
                      child: Row(
                        spacing: listSpacing,
                        children: [
                          AppIcon("save"),
                          AppText("image_edit.export"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

      final Widget imageView = NotifierBuilder(
        listenable: controller.onPlateUpdate,
        builder: (BuildContext context, Widget? child){
          if(controller.plate == ImageEditPlate.cropping){
            return ListenableBuilder(
              listenable: controller.onFragmentUpdate,
              builder: (BuildContext context, Widget? child){
                return ImageCroppingViewer(
                  controller: croppingController,
                  child: CustomPaint(
                    painter: ImageFragmentPainter(
                      image: image,
                      params: controller.current.fragment,
                      shader: program,
                    ),
                  ),
                );
              },
            );
          }else if(controller.plate == ImageEditPlate.colorTuning){
            return ListenableBuilder(
              listenable: controller.onCroppingUpdate,
              builder: (BuildContext context, Widget? child){
                return ListenableBuilder(
                  listenable: controller.onFragmentUpdate,
                  builder: (BuildContext context, Widget? child){
                    return RFutureBuilder(
                      future: croppedImage,
                      builder: (BuildContext context, ui.Image croppedImage){
                        return InteractiveViewer(
                          minScale: 1,
                          maxScale: 10,
                          child: CustomPaint(
                            painter: ImageFragmentPainter(
                              image: croppedImage,
                              params: controller.current.fragment,
                              shader: program,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }

          return block0;
        },
      );

      final Widget croppingPanel = Column(
        spacing: listSpacing,
        children: [
          Row(
            children: [
              AppButton.smallIcon(
                toolTip: "image_edit.rotate_left_90",
                onClick: croppingController.contraRotate,
                child: AppIcon("rotate_left_90", height: 20),
              ),

              AppButton.smallIcon(
                toolTip: "image_edit.rotate_right_90",
                onClick: croppingController.rotate,
                child: AppIcon("rotate_right_90", height: 20),
              ),

              Expanded(child: block0),

              AppButton.smallIcon(
                toolTip: "image_edit.reset_rotation",
                onClick: croppingController.resetRotation,
                child: AppIcon("refresh", height: 20),
              ),
            ],
          ),

          AppButton.smallText(
            onClick: croppingController.resetFrame,
            isTransparent: false,
            child: AppText("image_edit.reset_crop_frame"),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(smallPadding, smallPadding, smallPadding, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(smallBorderRadius)),
              color: AppColorScheme.of(context).background.enabledColor,
            ),
            child: Column(
              spacing: listSpacing,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText("image_edit.ratio"),
                ),

                AppButtonStack(
                  direction: Axis.vertical,
                  buttonWidth: null,
                  children: [
                    for(final CropFrameRatio ratio in CropFrameRatio.values)
                      ListenableBuilder(
                        listenable: croppingController,
                        builder: (BuildContext context, Widget? child){
                          return AppSwitch.smallText(
                            value: croppingController.ratio == ratio,
                            onChanged: (bool value){
                              croppingController.ratio = ratio;
                            },
                            child: AppText(ratio.key),
                          );
                        },
                      )
                  ],
                )

              ],
            ),
          ),
        ],
      );

      final Widget colorTuningPanel = Column(
        spacing: listSpacing,
        children: [
          for(final ImageFragmentType type in ImageFragmentType.values)
            buildSlider(type),
        ],
      );

      final Widget editPanel = Column(
        spacing: listSpacing,
        children: [
          Row(
            children: [
              AppNavBuilder<int>(
                initValue: _plateMap[controller.plate]!,
                onChanged: (int value){
                  if(value != 0){
                    saveCroppingParams();
                  }
                  controller.plate = _plateMap.keys.toList()[value];
                },
                builder: (BuildContext context, int value, void Function(int newValue) change){
                  return Row(
                    spacing: listSpacing,
                    children: [
                      AppSwitch.smallText(
                        value: value == 0,
                        onChanged: (bool value){
                          if(value) change(0);
                        },
                        child: AppText("image_edit.crop"),
                      ),
                      AppSwitch.smallText(
                        value: value == 1,
                        onChanged: (bool value){
                          if(value) change(1);
                        },
                        child: AppText("image_edit.color_tuning"),
                      ),
                    ],
                  );
                }
              ),
              Expanded(child: block0),
              ListenableBuilder(
                listenable: controller.onPlateUpdate,
                builder: (BuildContext context, Widget? child){
                  if(controller.plate == ImageEditPlate.colorTuning){
                    return AppButton.smallText(
                      toolTip: "reset",
                      onClick: (){
                        controller.setFragment(ImageFragmentParams.defaultParams);
                        controller.save();
                      },
                      child: AppIcon("refresh"),
                    );
                  }

                  return block0;
                },
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                late final Widget child;
                if(index == 0){
                  child = croppingPanel;
                }else if(index == 1){
                  child = colorTuningPanel;
                }else{
                  child = block0;
                }

                return SmoothPointerScroll(
                  builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
                    return SingleChildScrollView(
                      controller: controller,
                      physics: physics,
                      child: child,
                    );
                  },
                );
              },
            ),
          ),
        ],
      );


      return Padding(
        padding: const EdgeInsets.fromLTRB(listSpacing, 0, listSpacing, listSpacing),
        child: Column(
          children: [
            topBar,

            Expanded(
              child: MultiSplitViewTheme(
                data: MultiSplitViewThemeData(
                  dividerPainter: DividerPainters.grooved1(
                    color: AppColorScheme.of(context).byRole(ColorRole.of(context)).pressedColor,
                    highlightedColor: AppColorScheme.of(context).byRole(ColorRole.of(context)).onPressedColor,
                  )
                ),
                child: MultiSplitView(
                  initialAreas: [
                    Area(data: "image_view"),
                    Area(data: "edit_panel", flex: 0.5),
                  ],
                  builder: (BuildContext context, Area area){
                    if(area.data == "image_view"){
                      return imageView;
                    }else{
                      return editPanel;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }();
  }

  @override
  void dispose(){
    controller.dispose();
    pageController.dispose();
    croppingController.dispose();
    image.dispose();
    /// croppedImage会自动dispose
    super.dispose();
  }
}



enum ImageWidthPixel{
  p480(480),
  p720(720),
  p1080(1080),
  p2k(2560),
  p4k(3840),
  p8k(7680),
  p12k(11520),
  p16k(15360);

  final int pixel;
  const ImageWidthPixel(this.pixel);
}

class EditedImageExportPanel extends StatefulWidget{
  final ui.Image image;
  final ImageEditParams params;

  const EditedImageExportPanel({
    super.key,
    required this.image,
    required this.params,
  });

  @override
  State<EditedImageExportPanel> createState() => _EditedImageExportPanelState();
}
class _EditedImageExportPanelState extends State<EditedImageExportPanel>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: [

      ],
    );
  }
}








