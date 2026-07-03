
import "param_type.dart";

class ParamItem{
  final String uuid;
  bool delete;
  final ParamType type;
  final ParamSubType? subType;
  final String value;
  final int time;
  String? title;
  String? description;
  List<String> tag;
  String? set;
  String? originImagePath;
  String? image;
  String? cacheParams;

  ParamItem({
    required this.uuid,
    this.delete = false,
    required this.type,
    required this.subType,
    required this.value,
    required this.time,
    this.title,
    this.description,
    required this.tag,
    this.set,
    this.originImagePath,
    this.image,
    this.cacheParams,
  });
}