
import "../model/device_game_picker_state.dart";
import "package:nikki_albums/base/app_state.dart";
import "package:nikki_albums/modules/config_helper/domain/config_helper.dart";
import "package:nikki_albums/gen/rust/config/game.dart";
import "package:nikki_albums/gen/rust/config/plugin.dart";
import "package:nikki_albums/gen/rust/config/rules/text_rule.dart";
import "package:nikki_albums/ui/common/common.dart";

import "package:flutter/widgets.dart";
import "dart:async";

import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:forui/forui.dart";
import "package:file_picker/file_picker.dart";


class DeviceGamePickerDialog extends HookConsumerWidget{
  final String? pluginUuid;
  final DeviceGamePickerConfig deviceGamePickerConfig;
  final FDialogStyleDelta style;
  final Animation<double>? animation;
  final FutureOr<PickedDeviceGameResult> Function(String path, String name) validate;
  final void Function(DeviceGame)? onSave;
  final void Function()? onCancel;

  const DeviceGamePickerDialog({
    super.key,
    this.pluginUuid,
    required this.deviceGamePickerConfig,
    this.style = const .context(),
    this.animation,
    required this.validate,
    this.onSave,
    this.onCancel,
  });

  String resolveTextRule(BuildContext context, TextRule? textRule, String defaultText){
    if(textRule == null){
      return defaultText;
    }
    return TextRuleHelper.resolve(textRule, context: context, pluginUuid: pluginUuid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final TextEditingController pathController = useTextEditingController();
    final ValueNotifier<String> nameValue = useState("");
    final ValueNotifier<String> pathValue = useState("");
    final String? debouncedPath = useDebounced(pathValue.value, Duration(milliseconds: 400));
    final ValueNotifier<DeviceGamePickerState> pickerState = useState(DeviceGamePickerState.none());

    useEffect((){
      if(pathValue.value.isEmpty){
        pickerState.value = DeviceGamePickerState.none();
      }else{
        pickerState.value = DeviceGamePickerState.waiting();
      }
      return null;
    }, [pathValue.value]);
    useEffect((){
      if(debouncedPath != null){
        () async{
          if(debouncedPath.isEmpty){
            pickerState.value = DeviceGamePickerState.none();
          }else{
            pickerState.value = DeviceGamePickerState.waiting();
            try{
              final PickedDeviceGameResult pickedResult = await validate(pathValue.value, nameValue.value);
              switch(pickedResult){
                case PickedDeviceGameResult_Ok(field0: final DeviceGame deviceGame):
                  pickerState.value = DeviceGamePickerState.success(deviceGame);
                  pathController.text = deviceGame.installPath;
                case PickedDeviceGameResult_Err(field0: final TextRule? message):
                  pickerState.value = DeviceGamePickerState.error(message);
              }
            }catch(e){
              print(e);
              pickerState.value = DeviceGamePickerState.error(null);
            }
          }
        }();
      }
      return null;
    }, [debouncedPath]);

    return AdaptiveDialog(
      style: style,
      animation: animation,
      title: Text(resolveTextRule(context, deviceGamePickerConfig.title, "添加自定义游戏位置")),
      body: Column(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: .start,
        children: [
          Text(resolveTextRule(context, deviceGamePickerConfig.tip, "")),

          FTextField(
            control: .managed(
              onChange: (TextEditingValue value) => nameValue.value = value.text,
            ),
            label: Text(resolveTextRule(context, deviceGamePickerConfig.nameTextFieldLabel, "名称")),
            hint: resolveTextRule(context, deviceGamePickerConfig.nameTextFieldHint, "请输入一个名称"),
            clearable: (TextEditingValue value) => value.text.isNotEmpty,
          ),

          FTextFormField(
            control: .managed(
              controller: pathController,
              onChange: (TextEditingValue value) => pathValue.value = value.text,
            ),
            label: Text(resolveTextRule(context, deviceGamePickerConfig.pathTextFieldLabel, "游戏路径")),
            hint: resolveTextRule(context, deviceGamePickerConfig.pathTextFieldHint, "文件夹路径"),
            clearable: (TextEditingValue value) => value.text.isNotEmpty,
            forceErrorText: switch(pickerState.value){
              DeviceGamePickerState_Error(:final message) => resolveTextRule(context, message, "该路径不是游戏路径"),
              _ => null,
            },
            errorBuilder: (BuildContext context, String message){
              return Text(message);
            },
            suffixBuilder: (BuildContext context, _, _){
              return Padding(
                padding: .all(1),
                child: FTooltip(
                  tipBuilder: (BuildContext context, _){
                    return Text(resolveTextRule(context, deviceGamePickerConfig.pickerBtnTooltip, "选择文件夹"));
                  },
                  child: FButton.icon(
                    variant: .ghost,
                    onPress: () async{
                      final String? path = await FilePicker.platform.getDirectoryPath(
                        dialogTitle: resolveTextRule(context, deviceGamePickerConfig.pickerTitle, "请选择游戏文件夹"),
                      );
                      if(path != null){
                        pathController.text = path;
                      }
                    },
                    child: Icon(FLucideIcons.files),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        FButton(
          size: .sm,
          prefix: switch(pickerState.value){
            DeviceGamePickerState_Waiting() => FCircularProgress(),
            _ => null,
          },
          onPress: switch(pickerState.value){
            DeviceGamePickerState_Success(:final deviceGame) => (){
              if(onSave != null){
                return onSave!.call(deviceGame);
              }
              ref.read(appStateProvider.notifier).setAppStateWith(
                pickedDeviceGame: [deviceGame, ...ref.read(appStateProvider).pickedDeviceGame],
              );
              Navigator.of(context).pop();
            },
            _ => null,
          },
          child: const Text("保存"),
        ),
        FButton(
          variant: .outline,
          size: .sm,
          child: const Text("取消"),
          onPress: (){
            if(onCancel != null){
              return onCancel!.call();
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}