/*
/// 网络 api 示例
const _example = [
  {
    "id": "infinity-nikki-cloth-lang",
    "versionId": "f26cab19-151b-4ee4-98a1-4332eb0bd04a",
    "files": [
      {
        "path": "cloth/zh-CN.json",
        "downloadLink": "https://file-nikki.ranaxro.com/hot_update/lang/infinity_nikki/cloth/zh-CN.json"
      },
      {
        "path": "cloth/en-US.json",
        "downloadLink": "https://file-nikki.ranaxro.com/hot_update/lang/infinity_nikki/cloth/en-US.json",
        "sha256": "283ce7f975e9889d4c1a81e2f0331272a43c73dc969073980df8432094f312c2"
      }
    ]
  }
];
*/

class HotUpdateInfo {
  static HotUpdateInfo? fromJson(dynamic json) {
    if (json is! Map) return null;

    final Object? id = json["id"];
    final Object? versionId = json["versionId"];
    final Object? filesJson = json["files"];
    if (id is! String || versionId is! String || filesJson is! List) {
      return null;
    }

    final List<FileHotUpdateInfo> files = <FileHotUpdateInfo>[];
    for (final Object? fileJson in filesJson) {
      final FileHotUpdateInfo? file = FileHotUpdateInfo.fromJson(fileJson);
      if (file == null) return null;
      files.add(file);
    }

    return HotUpdateInfo(id: id, versionId: versionId, files: files);
  }

  final String id;
  final String versionId;
  final List<FileHotUpdateInfo> files;

  const HotUpdateInfo({
    required this.id,
    required this.versionId,
    required this.files,
  });
}

class FileHotUpdateInfo {
  static FileHotUpdateInfo? fromJson(dynamic json) {
    if (json is! Map) return null;

    final Object? path = json["path"];
    final Object? downloadLink = json["downloadLink"];
    final Object? sha256 = json["sha256"];
    if (path is! String || downloadLink is! String) return null;
    if (sha256 != null && sha256 is! String) return null;

    final String? normalizedSha256 = (sha256 as String?)?.trim().toLowerCase();
    return FileHotUpdateInfo(
      path: path,
      downloadLink: downloadLink,
      sha256: normalizedSha256 == null || normalizedSha256.isEmpty
          ? null
          : normalizedSha256,
    );
  }

  final String path;
  final String downloadLink;
  final String? sha256;

  const FileHotUpdateInfo({
    required this.path,
    required this.downloadLink,
    this.sha256,
  });
}
