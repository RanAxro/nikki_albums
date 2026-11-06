
import "package:nikki_albums/modules/plugin/domain/plugin.dart";
import "package:nikki_albums/gen/app_icons.dart";
import "package:nikki_albums/gen/rust/config/rules/icon_rule.dart";

import "package:flutter/widgets.dart";
import "dart:typed_data";

import "package:forui/forui.dart";


abstract final class IconRuleHelper{
  static Widget resolve(IconRule iconRule, {PluginReader? reader}){
    switch(iconRule){
      case IconRule_Image(field0: final ImageIconRule imageRule):
        if(imageRule.global){
          return Image.asset(imageRule.path);
        }else{
          return FutureBuilder(
            future: reader!.readFile(imageRule.path),
            builder: (_, AsyncSnapshot<Uint8List> snapshot){
              if(snapshot.hasData && snapshot.data != null){
                return Image.memory(snapshot.data!);
              }
              if(snapshot.hasError){
                return const SizedBox();
              }
              return FCircularProgress();
            },
          );
        }
      case IconRule_BuiltIn(field0: final BuiltInIconRule buildInRule):
        try{
          return Icon(AppIcons.byName(buildInRule.name));
        }catch(e){
          return const SizedBox();
        }
    }
  }
}