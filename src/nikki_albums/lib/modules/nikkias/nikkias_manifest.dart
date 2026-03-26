import "nikkias.dart";

import "package:nikkialbums/info.dart";

import "dart:convert";

/// manifest
// {
//   "nikkias": {
//     "manifestVersion": 0,
//     "type": "",
//     "launcherChannel": "",
//     "uid": "",
//     "albumType": ""
//   }
// }

enum NikkiasType{
  albumBackup,
  imageTransfer,
  other,
  ;

  static NikkiasType from(dynamic value){
    return NikkiasType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => NikkiasType.other,
    );
  }
}

abstract class NikkiasManifest{
  static NikkiasManifest? decode(String source){
    final dynamic json = jsonDecode(source);

    if(json is! Map || json[nikkiasExtension] is! Map) return null;

    final Map content = json[nikkiasExtension];

    if(content["manifestVersion"] != 0) return null;
    if(content["type"] is! String) return null;

    switch(NikkiasType.from(content["type"].toString())){
      case NikkiasType.albumBackup:
        return AlbumBackupNikkiasManifest.from(content);
      case NikkiasType.imageTransfer:
        return ImageTransferNikkiasManifest.from(content);
      case NikkiasType.other:
        return OtherNikkiasManifest.from(content);
    }
  }

  static String encode(NikkiasManifest source){
    final Map json = {
      nikkiasExtension: source.toMap(),
    };

    return jsonEncode(json);
  }


  final LauncherChannel launcherChannel;

  const NikkiasManifest({required this.launcherChannel});

  int get manifestVersion => 0;

  NikkiasType get type;

  Map<String, dynamic> toMap();

  @override
  bool operator ==(Object other) => identical(this, other) ||
    other is NikkiasManifest && launcherChannel == other.launcherChannel;

  @override
  int get hashCode => launcherChannel.hashCode;
}

class AlbumBackupNikkiasManifest extends NikkiasManifest{
  static AlbumBackupNikkiasManifest? from(dynamic source){
    if(source is! Map) return null;

    return AlbumBackupNikkiasManifest(launcherChannel: LauncherChannel.from(source["launcherChannel"]));
  }

  static Map<String, dynamic> to(AlbumBackupNikkiasManifest manifest){
    return manifest.toMap();
  }


  const AlbumBackupNikkiasManifest({
    required super.launcherChannel,
  });

  @override
  NikkiasType get type => NikkiasType.albumBackup;

  @override
  Map<String, dynamic> toMap(){
    return {
      "manifestVersion": manifestVersion,
      "type": type.name,
      "launcherChannel": launcherChannel.name,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) ||
    other is AlbumBackupNikkiasManifest && launcherChannel == other.launcherChannel;

  @override
  int get hashCode => launcherChannel.hashCode;
}

class ImageTransferNikkiasManifest extends NikkiasManifest{
  static ImageTransferNikkiasManifest? from(dynamic source){
    if(source is! Map) return null;

    return ImageTransferNikkiasManifest(
      launcherChannel: LauncherChannel.from(source["launcherChannel"]),
      uid: source["uid"].toString(),
      albumType: AlbumType.from(source["albumType"]),
    );
  }

  static Map<String, dynamic> to(ImageTransferNikkiasManifest manifest){
    return manifest.toMap();
  }


  final String uid;
  final AlbumType albumType;

  const ImageTransferNikkiasManifest({
    required super.launcherChannel,
    required this.uid,
    required this.albumType,
  });

  @override
  NikkiasType get type => NikkiasType.imageTransfer;

  @override
  Map<String, dynamic> toMap(){
    return {
      "manifestVersion": manifestVersion,
      "type": type.name,
      "launcherChannel": launcherChannel.name,
      "uid": uid,
      "albumType": albumType.name,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) ||
    other is ImageTransferNikkiasManifest && launcherChannel == other.launcherChannel && uid == other.uid && albumType == other.albumType;

  @override
  int get hashCode => Object.hash(launcherChannel, uid, albumType);
}

class OtherNikkiasManifest extends NikkiasManifest{
  static OtherNikkiasManifest? from(dynamic source){
    if(source is! Map) return null;

    return OtherNikkiasManifest();
  }

  static Map<String, dynamic> to(OtherNikkiasManifest manifest){
    return manifest.toMap();
  }


  const OtherNikkiasManifest() : super(launcherChannel: LauncherChannel.unknown);

  @override
  NikkiasType get type => NikkiasType.other;

  @override
  Map<String, dynamic> toMap(){
    return {
      "manifestVersion": manifestVersion,
      "type": type.name,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) ||
    other is OtherNikkiasManifest && launcherChannel == other.launcherChannel;

  @override
  int get hashCode => launcherChannel.hashCode;
}