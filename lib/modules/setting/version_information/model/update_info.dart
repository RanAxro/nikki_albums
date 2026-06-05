import 'dart:io';

/*
/// 网络 api 示例
final _apiExample = {
  "version": 11,
  "versionString": "3.06",
  "downloadLink": "",
  "updateMessage": "",
  "windows": {
    "version": 11,
    "versionString": "3.06",
    "downloadLink": "",
    "updateMessage": {
      "zh-CN": "",
      "en-US": "",
    },
  },
  "macos": {
    "version": 11,
    "versionString": "3.06",
    "downloadLink": "",
    "updateMessage": {
      "zh-CN": "",
      "en-US": "",
    },
  }
};
*/

class UpdateInfo {
  static UpdateInfo? fromJson(dynamic json) {
    if (json is! Map) return null;

    if (json case {
      "version": int version,
      "versionString": String versionString,
      "downloadLink": String downloadLink,
      "updateMessage": String updateMessage,
      "windows": Map windows,
      "macos": Map macos,
    }) {
      return UpdateInfo(
        version: version,
        versionString: versionString,
        downloadLink: downloadLink,
        updateMessage: updateMessage,
        windows: PlatformUpdateInfo.fromJson(windows),
        macos: PlatformUpdateInfo.fromJson(macos),
      );
    }

    return null;
  }

  final int version;
  final String versionString;
  final String downloadLink;
  final String updateMessage;
  final PlatformUpdateInfo? windows;
  final PlatformUpdateInfo? macos;

  const UpdateInfo({
    required this.version,
    required this.versionString,
    required this.downloadLink,
    required this.updateMessage,
    required this.windows,
    required this.macos,
  });

  int get platformVersion {
    if (Platform.isWindows) {
      return windows?.version ?? version;
    } else if (Platform.isMacOS) {
      return macos?.version ?? version;
    } else {
      return 0;
    }
  }

  String get platformVersionString {
    if (Platform.isWindows) {
      return windows?.versionString ?? versionString;
    } else if (Platform.isMacOS) {
      return macos?.versionString ?? versionString;
    } else {
      return "";
    }
  }

  String get platformDownloadLink {
    if (Platform.isWindows) {
      return windows?.downloadLink ?? downloadLink;
    } else if (Platform.isMacOS) {
      return macos?.downloadLink ?? downloadLink;
    } else {
      return "";
    }
  }

  Map get platformUpdateMessage {
    if (Platform.isWindows) {
      return windows?.updateMessage ?? {"zh-CN": updateMessage};
    } else if (Platform.isMacOS) {
      return macos?.updateMessage ?? {"zh-CN": updateMessage};
    } else {
      return {"zh-CN": ""};
    }
  }
}

class PlatformUpdateInfo {
  static PlatformUpdateInfo? fromJson(dynamic json) {
    if (json is! Map) return null;

    if (json case {
      "version": int version,
      "versionString": String versionString,
      "downloadLink": String downloadLink,
      "updateMessage": Map updateMessage,
    }) {
      return PlatformUpdateInfo(
        version: version,
        versionString: versionString,
        downloadLink: downloadLink,
        updateMessage: updateMessage,
      );
    }

    return null;
  }

  final int version;
  final String versionString;
  final String downloadLink;
  final Map updateMessage;

  const PlatformUpdateInfo({
    required this.version,
    required this.versionString,
    required this.downloadLink,
    required this.updateMessage,
  });
}
