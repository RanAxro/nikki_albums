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

enum ClothType{
  unknown(0),
  hair(10),
  dresses(90),
  outerwear(20),
  tops(30),
  bottoms(41),
  socks(50),
  shoes(60),
  hairAccessories(71),
  headwear(72),
  earrings(73),
  neckwear(74),
  bracelets(75),
  chokers(76),
  gloves(77),
  faceDecorations(92),
  chestAccessories(93),
  pendants(94),
  backpieces(95),
  rings(96),
  armDecorations(97),
  handhelds(78),
  bodyPaint(79),
  fullMakeup(80),
  baseMakeup(81),
  eyebrows(82),
  eyelashes(83),
  contacts(84),
  lips(85),
  skinTones(86);

  final int flag;

  const ClothType(this.flag);

  static ClothType fromName(dynamic name){
    return ClothType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ClothType.unknown,
    );
  }

  static ClothType fromFlag(dynamic flag){
    return ClothType.values.firstWhere(
      (e) => e.flag == flag,
      orElse: () => ClothType.unknown,
    );
  }
}

enum NikkiClothState{
  evolution_0_1(0),
  none(1),
  glowUp(2),
  evolution_1(3),
  evolution_2(4),
  evolution_3(5),
  evolution_0_2(9);

  final int flag;

  const NikkiClothState(this.flag);

  static NikkiClothState fromName(dynamic name){
    return NikkiClothState.values.firstWhere(
      (e) => e.name == name,
      orElse: () => NikkiClothState.evolution_0_1,
    );
  }

  static NikkiClothState fromFlag(dynamic flag){
    return NikkiClothState.values.firstWhere(
      (e) => e.flag == flag,
      orElse: () => NikkiClothState.evolution_0_1,
    );
  }
}

enum EurekaAttachmentPoint{
  unknown(0),
  head(1),
  hands(2),
  feet(3);

  final int flag;

  const EurekaAttachmentPoint(this.flag);

  static EurekaAttachmentPoint fromName(dynamic name){
    return EurekaAttachmentPoint.values.firstWhere(
      (e) => e.name == name,
      orElse: () => EurekaAttachmentPoint.unknown,
    );
  }

  static EurekaAttachmentPoint fromFlag(dynamic flag){
    return EurekaAttachmentPoint.values.firstWhere(
      (e) => e.flag == flag,
      orElse: () => EurekaAttachmentPoint.unknown,
    );
  }
}

enum ColorSwatch{
  unknown(0),
  swatch_1(1),
  swatch_2(2),
  swatch_3(3),
  swatch_4(4),
  swatch_5(5),
  swatch_6(6),
  swatch_7(7),
  swatch_8(8);

  final int flag;

  const ColorSwatch(this.flag);

  static ColorSwatch fromName(dynamic name){
    return ColorSwatch.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ColorSwatch.unknown,
    );
  }

  static ColorSwatch fromFlag(dynamic flag){
    return ColorSwatch.values.firstWhere(
      (e) => e.flag == flag,
      orElse: () => ColorSwatch.unknown,
    );
  }
}