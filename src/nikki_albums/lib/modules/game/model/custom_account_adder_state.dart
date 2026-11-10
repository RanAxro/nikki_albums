
import "package:freezed_annotation/freezed_annotation.dart";
import "package:nikki_albums/gen/rust/config/game.dart";
import "package:nikki_albums/gen/rust/config/rules/text_rule.dart";

part "custom_account_adder_state.freezed.dart";


@freezed
sealed class CustomAccountAdderState with _$CustomAccountAdderState{
  const factory CustomAccountAdderState.none() = CustomAccountAdderState_None;
  const factory CustomAccountAdderState.waiting() = CustomAccountAdderState_Waiting;
  const factory CustomAccountAdderState.error(TextRule? message) = CustomAccountAdderState_Error;
  const factory CustomAccountAdderState.success(DeviceGameAccount deviceGameAccount) = CustomAccountAdderState_Success;
}