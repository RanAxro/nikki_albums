
export "package:nikki_albums/src/rust/config/common/text_config.dart";

import "package:nikki_albums/src/rust/config/common/text_config.dart";

import 'package:flutter/widgets.dart';

import "package:easy_localization/easy_localization.dart";


abstract final class TextConfigHelper{
  static String resolveByConfig(TextConfig config, [BuildContext? context]){
    return switch(config){
      TextConfig_Literal(field0: final literalTextConfig) => literalTextConfig.text,
      TextConfig_Translate(field0: final translateTextConfig) => tr(
        translateTextConfig.key,
        context: context,
        args: translateTextConfig.args,
        namedArgs: translateTextConfig.namedArgs,
        gender: translateTextConfig.gender,
      ),
    };
  }
}