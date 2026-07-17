
enum DyeCondition implements Comparable<DyeCondition>{
  directly(0),
  complete(1),
  growUp(2),
  evolution_1(3),
  evolution_2(4),
  evolution_3(5);

  final int value;

  const DyeCondition(this.value);

  @override
  int compareTo(DyeCondition other) => value.compareTo(other.value);

  bool operator <(DyeCondition other) => value < other.value;
  bool operator >(DyeCondition other) => value > other.value;
  bool operator <=(DyeCondition other) => value <= other.value;
  bool operator >=(DyeCondition other) => value >= other.value;
}

enum EffectScheme{
  allOn,
  allOff,
  custom,
}