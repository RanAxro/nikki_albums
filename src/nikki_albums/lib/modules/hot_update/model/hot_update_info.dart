

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
      }
    ]
  }
];
*/


class HotUpdateInfo{
  static HotUpdateInfo? fromJson(dynamic json){
    if(json is! Map) return null;

    if(json case{
      "id": String id,
      "versionId": String versionId,
      "files": List files,
    }){
      return HotUpdateInfo(
        id: id,
        versionId: versionId,
        files: files.map(FileHotUpdateInfo.fromJson).whereType<FileHotUpdateInfo>().toList(),
      );
    }

    return null;
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

class FileHotUpdateInfo{
  static FileHotUpdateInfo? fromJson(dynamic json){
    if(json is! Map) return null;

    if(json case{
      "path": String path,
      "downloadLink": String downloadLink,
    }){
      return FileHotUpdateInfo(
        path: path,
        downloadLink: downloadLink,
      );
    }

    return null;
  }


  final String path;
  final String downloadLink;

  const FileHotUpdateInfo({
    required this.path,
    required this.downloadLink,
  });
}