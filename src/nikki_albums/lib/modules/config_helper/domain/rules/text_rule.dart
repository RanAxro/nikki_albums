
import "package:easy_localization/easy_localization.dart";
import "package:nikki_albums/gen/rust/config/rules/text_rule.dart";

import "package:flutter/widgets.dart";


abstract final class TextRuleHelper{
  static String resolve(TextRule textRule, {BuildContext? context, String? pluginUuid}){
    switch(textRule){
      case TextRule_Literal(field0: final LiteralTextRule literalRule):
        return literalRule.text;
      case TextRule_Translate(field0: final TranslateTextRule translateRule):
        final String key = translateRule.global ? translateRule.key : "__plugin.$pluginUuid.${translateRule.key}";
        return context?.tr(
          key,
          args: translateRule.args,
          namedArgs: translateRule.namedArgs,
          gender: translateRule.gender,
        ) ?? translateRule.key;
    }
  }
}