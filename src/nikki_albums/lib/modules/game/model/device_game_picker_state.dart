
import "package:freezed_annotation/freezed_annotation.dart";
import "package:nikki_albums/gen/rust/config/game.dart";
import "package:nikki_albums/gen/rust/config/rules/text_rule.dart";

part "device_game_picker_state.freezed.dart";


@freezed
sealed class DeviceGamePickerState with _$DeviceGamePickerState{
  const factory DeviceGamePickerState.none() = DeviceGamePickerState_None;
  const factory DeviceGamePickerState.waiting() = DeviceGamePickerState_Waiting;
  const factory DeviceGamePickerState.error(TextRule? message) = DeviceGamePickerState_Error;
  const factory DeviceGamePickerState.success(DeviceGame deviceGame) = DeviceGamePickerState_Success;
}