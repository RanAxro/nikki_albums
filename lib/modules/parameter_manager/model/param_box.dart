
import "param_type.dart";


class ParamBox{
  final List<ParamSet> set;
  final List<ParamTag> tag;
  final List item;

  ParamBox({
    required this.set,
    required this.tag,
    required this.item,
  });
}

class ParamSet{
  final String uuid;
  String name;
  final List<ParamType> allowType;
  final List<ParamSet> children;

  ParamSet({
    required this.uuid,
    required this.name,
    required this.allowType,
    required this.children,
  });
}

class ParamTag{
  final String uuid;
  String name;

  ParamTag({
    required this.uuid,
    required this.name,
  });
}