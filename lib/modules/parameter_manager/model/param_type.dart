
enum ParamType{
  camera(0),
  cloth(1),
  home(2);

  final int value;

  const ParamType(this.value);

  static ParamType? fromValue(dynamic v){
    return ParamType.values.cast<ParamType?>().firstWhere(
      (ParamType? type) => type?.value == v,
      orElse: () => null,
    );
  }

  int toValue() => value;
}