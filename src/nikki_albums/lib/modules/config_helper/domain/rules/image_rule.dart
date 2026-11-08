
import "icon_rule.dart";
import "../../model/image_rule.dart";
import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";
import "package:nikki_albums/gen/rust/config/rules/image_rule.dart" as rust;

import "package:flutter/widgets.dart";
import "dart:io";
import "dart:typed_data";

import "package:forui/forui.dart";


abstract final class ImageRuleHelper{
  static ImageRule convertToDart(rust.ImageRule rustImageRule, {NGeneralFileSystem Function(String)? onGetNGFS}){
    switch(rustImageRule){
      case rust.ImageRule_Icon(:final rust.IconImageRule field0):
        return ImageRule.icon(IconImageRule(icon: field0.icon));
      case rust.ImageRule_NGFS(:final rust.NGFSImageRule field0):
        return ImageRule.ngfs(NGFSImageRule(
          fsHandler: onGetNGFS!.call(field0.fsHandlerId),
          path: field0.path,
        ));
      case rust.ImageRule_Native(:final rust.NativeImageRule field0):
        return ImageRule.native(NativeImageRule(path: field0.path));
    }
  }

  static Widget resolve(ImageRule imageRule){
    switch(imageRule){
      case ImageRule_Icon(field0: final IconImageRule iconRule):
        return IconRuleHelper.resolve(iconRule.icon);
      case ImageRule_NGFS(field0: final NGFSImageRule ngfsRule):
        return FutureBuilder(
          future: ngfsRule.fsHandler.readBytes(ngfsRule.path),
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
      case ImageRule_Native(field0: final NativeImageRule nativeRule):
        return Image.file(File(nativeRule.path));
    }
  }
}