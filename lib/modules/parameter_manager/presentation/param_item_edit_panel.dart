
import "package:nikki_albums/modules/parameter_manager/domain/camera_params_edit_controller.dart";
import "package:nikki_albums/modules/parameter_manager/domain/param_item_creator.dart";
import "package:nikki_albums/modules/parameter_manager/presentation/camera_params_edit_panel.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/camera_params.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";


class ParamItemEditPanel extends StatefulWidget{
  const ParamItemEditPanel({super.key});

  @override
  State<ParamItemEditPanel> createState() => _ParamItemEditPanelState();
}

class _ParamItemEditPanelState extends State<ParamItemEditPanel>{
  final ValueNotifier<dynamic> currentParam = ValueNotifier(null);

  @override
  Widget build(BuildContext context){
    tryDeParam("lGoSGGot2pbfRozyhnAnEUQ89OMsIaB4ekxCAO1Y8WKQULnVJlz3hI+qW46E40+sU+B1kx+IgtBEq8wBxOM5kXxOTamKCz60zCykyQ1+/ZGo+anNzqQ7Hr6maME5FuV4GPJfQd5HUDO+thoax5xcZVFGxo86fUW5yPQy2Rk065XA/r6UjbmeVdNkHcH63ROU")
      .then((onValue) => currentParam.value = onValue);

    return Row(
      children: [
        SizedBox(
          width: 600,
          child: Column(
            children: [
              AppTextFiled(
                onChanged: (String value) async{
                  final t = await tryDeParam(value);
                  currentParam.value = t;
                  print(t);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: currentParam,
            builder: (BuildContext context, dynamic param, Widget? child){
              if(param == null){
                return block0;
              }

              if(param is CameraParams){
                return CameraParamsEditPanel(
                  controller: CameraParamsEditController(cameraParams: param),
                );
              }

              return block0;
            },
          ),
        ),
      ],
    );
  }
}