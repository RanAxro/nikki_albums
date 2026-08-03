
import "package:nikki_albums/src/rust/config/common/text_config.dart";

import 'package:flutter/widgets.dart';

import "package:easy_localization/easy_localization.dart";


abstract final class TextConfigProcessor{
  String withConfig(TextConfig config, [BuildContext? context]){
    return config.when(
      literal: (LiteralTextConfig literalTextConfig){
        return literalTextConfig.text;
      },
      translate: (TranslateTextConfig translateTextConfig){
        return tr(
          translateTextConfig.key,
          context: context,
          args: translateTextConfig.args,
          namedArgs: translateTextConfig.namedArgs,
          gender: translateTextConfig.gender,
        );
      },
    );
  }
}