
import "package:nikki_albums/gen/rust/config/rules/icon_rule.dart";
import "package:nikki_albums/modules/n_general_file_system/domain/n_general_file_system.dart";

import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'image_rule.freezed.dart';

class IconImageRule {
  final IconRule icon;

  const IconImageRule({required this.icon});

  @override
  int get hashCode => icon.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IconImageRule &&
              runtimeType == other.runtimeType &&
              icon == other.icon;
}

@freezed
sealed class ImageRule with _$ImageRule {
  const ImageRule._();

  const factory ImageRule.icon(IconImageRule field0) = ImageRule_Icon;
  const factory ImageRule.ngfs(NGFSImageRule field0) = ImageRule_NGFS;
  const factory ImageRule.native(NativeImageRule field0) = ImageRule_Native;
}

class NativeImageRule {
  final String path;

  const NativeImageRule({required this.path});

  @override
  int get hashCode => path.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NativeImageRule &&
              runtimeType == other.runtimeType &&
              path == other.path;
}

class NGFSImageRule {
  final NGeneralFileSystem fsHandler;
  final String path;

  const NGFSImageRule({required this.fsHandler, required this.path});

  @override
  int get hashCode => fsHandler.hashCode ^ path.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NGFSImageRule &&
              runtimeType == other.runtimeType &&
              fsHandler == other.fsHandler &&
              path == other.path;
}
