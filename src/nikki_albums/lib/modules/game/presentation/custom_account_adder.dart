
import "package:nikki_albums/modules/game/model/custom_account_adder_state.dart";
import "package:nikki_albums/modules/plugin/model/game_helper.dart";

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


class CustomAccountAdderDialog extends HookConsumerWidget{
  final DeviceGame deviceGame;
  final CustomAccountAdderConfig customAccountAdderConfig;
  final FDialogStyleDelta style;
  final Animation<double>? animation;
  final FutureOr<AddedCustomAccountResult> Function(String account) validate;
  final void Function(DeviceGameAccount)? onSave;
  final void Function()? onCancel;

  const CustomAccountAdderDialog({
    super.key,
    required this.deviceGame,
    required this.customAccountAdderConfig,
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
    return TextRuleHelper.resolve(textRule, context: context, pluginUuid: GameHelper.getOwnershipByUniqueId(deviceGame.uniqueId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final TextEditingController accountController = useTextEditingController();
    final ValueNotifier<String> accountValue = useState("");
    final String? debouncedAccount = useDebounced(accountValue.value, Duration(milliseconds: 400));
    final ValueNotifier<CustomAccountAdderState> adderState = useState(CustomAccountAdderState.none());

    useEffect((){
      if(accountValue.value.isEmpty){
        adderState.value = CustomAccountAdderState.none();
      }else{
        adderState.value = CustomAccountAdderState.waiting();
      }
      return null;
    }, [accountValue.value]);
    useEffect((){
      if(debouncedAccount != null){
        () async{
          if(debouncedAccount.isEmpty){
            adderState.value = CustomAccountAdderState.none();
          }else{
            adderState.value = CustomAccountAdderState.waiting();
            try{
              final AddedCustomAccountResult addedResult = await validate(accountValue.value);
              switch(addedResult){
                case AddedCustomAccountResult_Ok(field0: final String account):
                  adderState.value = CustomAccountAdderState.success(DeviceGameAccount(
                    deviceGame: deviceGame,
                    account: account,
                  ));
                  accountController.text = account;
                case AddedCustomAccountResult_Err(field0: final TextRule? message):
                  adderState.value = CustomAccountAdderState.error(message);
              }
            }catch(e){
              print(e);
              adderState.value = CustomAccountAdderState.error(null);
            }
          }
        }();
      }
      return null;
    }, [debouncedAccount]);

    return AdaptiveDialog(
      style: style,
      animation: animation,
      title: Text(resolveTextRule(context, customAccountAdderConfig.title, "添加自定义账号")),
      body: Column(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: .start,
        children: [
          Text(resolveTextRule(context, customAccountAdderConfig.tip, "")),

          FTextFormField(
            control: .managed(
              controller: accountController,
              onChange: (TextEditingValue value) => accountValue.value = value.text,
            ),
            label: Text(resolveTextRule(context, customAccountAdderConfig.accountTextFieldLabel, "账号")),
            hint: resolveTextRule(context, customAccountAdderConfig.accountTextFieldHint, "请填写您的账号"),
            clearable: (TextEditingValue value) => value.text.isNotEmpty,
            forceErrorText: switch(adderState.value){
              CustomAccountAdderState_Error(:final message) => resolveTextRule(context, message, "账号不存在"),
              _ => null,
            },
            errorBuilder: (BuildContext context, String message){
              return Text(message);
            },
          ),
        ],
      ),
      actions: [
        FButton(
          size: .sm,
          prefix: switch(adderState.value){
            CustomAccountAdderState_Waiting() => FCircularProgress(),
            _ => null,
          },
          onPress: switch(adderState.value){
            CustomAccountAdderState_Success(:final deviceGameAccount) => (){
              if(onSave != null){
                return onSave!.call(deviceGameAccount);
              }
              // ref.read(appStateProvider.notifier).setAppStateWith(
              //   pickedDeviceGame: [deviceGame, ...ref.read(appStateProvider).pickedDeviceGame],
              // );
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