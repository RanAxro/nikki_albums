
enum ParamType{
  camera,
  cloth,
  home,
}

enum ParamSubType{
  island,
  group,
}

const Map<ParamType, List<ParamSubType>> paramTypeConfig = {
  ParamType.camera: [],
  ParamType.cloth: [],
  ParamType.home: [
    ParamSubType.island,
    ParamSubType.group,
  ],
};