
enum ParamType{
  camera(0),
  cloth(1),
  home(2);

  final int value;

  const ParamType(this.value);

  List<ParamSubType> get subType => paramTypeConfig[this]!;

  static ParamType? fromValue(dynamic v){
    return ParamType.values.cast<ParamType?>().firstWhere(
      (ParamType? type) => type?.value == v,
      orElse: () => null,
    );
  }

  int toValue() => value;
}

enum ParamSubType{
  island(0),
  group(1);

  final int value;

  const ParamSubType(this.value);

  static ParamSubType? fromValue(dynamic v){
    return ParamSubType.values.cast<ParamSubType?>().firstWhere(
      (ParamSubType? type) => type?.value == v,
      orElse: () => null,
    );
  }

  int toValue() => value;
}

const Map<ParamType, List<ParamSubType>> paramTypeConfig = {
  ParamType.camera: [],
  ParamType.cloth: [],
  ParamType.home: [
    ParamSubType.island,
    ParamSubType.group,
  ],
};