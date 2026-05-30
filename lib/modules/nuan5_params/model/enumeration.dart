enum Weather{
  unknown(-1),
  sunny(0),
  rainy(2),
  rainbow(4),
  seaOfStars(7);

  final int flag;

  const Weather(this.flag);

  static Weather fromName(dynamic name){
    return Weather.values.firstWhere(
      (e) => e.name == name,
      orElse: () => Weather.unknown,
    );
  }

  static Weather fromFlag(dynamic flag){
    return Weather.values.firstWhere(
      (e) => e.flag == flag,
      orElse: () => Weather.unknown,
    );
  }
}

enum ApertureSection{
  unknown(-1),
  f_1_2(1),
  f_1_4(2),
  f_2(3),
  f_2_2(4),
  f_2_5(5),
  f_2_8(6),
  f_3_2(7),
  f_3_5(8),
  f_4(9),
  f_4_5(10),
  f_5(11),
  f_5_6(12),
  f_8(13),
  f_11(14),
  f_16(15);

  final int flag;

  const ApertureSection(this.flag);

  static ApertureSection fromName(dynamic name){
    return ApertureSection.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ApertureSection.unknown,
    );
  }

  static ApertureSection fromFlag(dynamic flag){
    return ApertureSection.values.firstWhere(
      (e) => e.flag == flag,
      orElse: () => ApertureSection.unknown,
    );
  }
}