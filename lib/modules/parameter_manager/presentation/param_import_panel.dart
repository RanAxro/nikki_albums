
import "../domain/camera_params_edit_controller.dart";
import "camera_params_edit_panel.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";

import "package:flutter/material.dart";


class CameraParamsImportInputPanel extends StatefulWidget{
  final void Function()? onCancel;
  final void Function(String?, CameraParams)? onFinish;
  final Nuan5DatabaseReaderV1? reader;

  const CameraParamsImportInputPanel({
    super.key,
    this.onCancel,
    this.onFinish,
    this.reader,
  });

  @override
  State<CameraParamsImportInputPanel> createState() => _CameraParamsImportInputPanelState();
}

class _CameraParamsImportInputPanelState extends State<CameraParamsImportInputPanel>{
  final CameraParamsEditController controller = CameraParamsEditController();

  @override
  Widget build(BuildContext context){
    return Column(
      spacing: bigPadding,
      children: [
        Expanded(
          child: SmoothPointerScroll(
            builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
              return SingleChildScrollView(
                controller: scrollController,
                physics: physics,
                child: CameraParamsEditPanel(
                  controller: controller,
                  reader: widget.reader,
                ),
              );
            },
          ),
        ),

        Row(
          children: [
            Expanded(
              child: AppButton.smallText(
                isTransparent: false,
                onClick: (){
                  widget.onCancel?.call();
                },
                child: AppText.tr("parameter_manager.cancel"),
              ),
            ),
            Expanded(
              child: AppButton.smallText(
                colorRole: ColorRole.highlight,
                isTransparent: false,
                onClick: (){
                  widget.onFinish?.call(controller.cameraParamString, controller.cameraParams);
                },
                child: AppText.tr("parameter_manager.finish"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


