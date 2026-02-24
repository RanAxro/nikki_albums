

extension type const GameWeatherType(int data){
  static const GameWeatherType sunny = GameWeatherType(0);
  static const GameWeatherType rainy = GameWeatherType(2);

  static const Map<int, String> _map = {
    0: "game_weather_0",
    2: "game_weather_2",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameInteractivePhotoType(int data){

  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameInteractivePhotoState(bool data){
  static const GameInteractivePhotoState falseState = GameInteractivePhotoState(false);
  static const GameInteractivePhotoState trueState = GameInteractivePhotoState(true);

  static const Map<bool, String> _map = {
    false: "game_interactive_photo_state_false",
    true: "game_interactive_photo_state_true",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameRiskPhotoType(int data){

  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameRiskPhotoState(bool data){
  static const GameRiskPhotoState falseState = GameRiskPhotoState(false);
  static const GameRiskPhotoState trueState = GameRiskPhotoState(true);

  static const Map<bool, String> _map = {
    false: "game_risk_photo_state_false",
    true: "game_risk_photo_state_true",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GamePuzzleGame(int data){
  static const GamePuzzleGame none = GamePuzzleGame(-1);

  static const Map<int, String> _map = {
    -1: "game_puzzle_game_-1",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GamePortraitMode(int data){
  static const GamePortraitMode disable = GamePortraitMode(0);
  static const GamePortraitMode enable = GamePortraitMode(1);

  static const Map<int, String> _map = {
    0: "game_portrait_mode_0",
    1: "game_portrait_mode_1",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameApertureSection(int data){
  static const GamePortraitMode f_1_2 = GamePortraitMode(1);
  static const GamePortraitMode f_1_4 = GamePortraitMode(2);
  static const GamePortraitMode f_2 = GamePortraitMode(3);
  static const GamePortraitMode f_2_2 = GamePortraitMode(4);
  static const GamePortraitMode f_2_5 = GamePortraitMode(5);
  static const GamePortraitMode f_2_8 = GamePortraitMode(6);
  static const GamePortraitMode f_3_2 = GamePortraitMode(7);
  static const GamePortraitMode f_3_5 = GamePortraitMode(8);
  static const GamePortraitMode f_4 = GamePortraitMode(9);
  static const GamePortraitMode f_4_5 = GamePortraitMode(10);
  static const GamePortraitMode f_5 = GamePortraitMode(11);
  static const GamePortraitMode f_5_6 = GamePortraitMode(12);
  static const GamePortraitMode f_8 = GamePortraitMode(13);
  static const GamePortraitMode f_11 = GamePortraitMode(14);
  static const GamePortraitMode f_16 = GamePortraitMode(15);

  static const Map<int, String> _map = {
    1: "f/1.2",
    2: "f/1.4",
    3: "f/2",
    4: "f/2.2",
    5: "f/2.5",
    6: "f/2.8",
    7: "f/3.2",
    8: "f/3.5",
    9: "f/4",
    10: "f/4.5",
    11: "f/5",
    12: "f/5.6",
    13: "f/8",
    14: "f/11",
    15: "f/16",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => false;
}

extension type const GameLightId(String data){
  static const GameLightId None = GameLightId("None");
  static const GameLightId DirectionLight_L = GameLightId("DirectionLight_L");
  static const GameLightId DirectionLight_R = GameLightId("DirectionLight_R");
  static const GameLightId DirectionLight_T = GameLightId("DirectionLight_T");
  static const GameLightId DirectionLight_B = GameLightId("DirectionLight_B");
  static const GameLightId HueEdgeLight_001_L = GameLightId("HueEdgeLight_001_L");
  static const GameLightId HueEdgeLight_001_R = GameLightId("HueEdgeLight_001_R");
  static const GameLightId HueEdgeLight_002_L = GameLightId("HueEdgeLight_002_L");
  static const GameLightId HueEdgeLight_002_R = GameLightId("HueEdgeLight_002_R");
  static const GameLightId HueEdgeLight_003_L = GameLightId("HueEdgeLight_003_L");
  static const GameLightId HueEdgeLight_003_R = GameLightId("HueEdgeLight_003_R");
  static const GameLightId HueEdgeLight_004_L = GameLightId("HueEdgeLight_004_L");
  static const GameLightId HueEdgeLight_004_R = GameLightId("HueEdgeLight_004_R");
  static const GameLightId VibeLight_001 = GameLightId("VibeLight_001");
  static const GameLightId VibeLight_002 = GameLightId("VibeLight_002");
  static const GameLightId VibeLight_003 = GameLightId("VibeLight_003");
  static const GameLightId VibeLight_004 = GameLightId("VibeLight_004");

  static const Map<String, String> _map = {
    "None": "game_light_None",
    "DirectionLight_L": "game_light_DirectionLight_L",
    "DirectionLight_R": "game_light_DirectionLight_R",
    "DirectionLight_T": "game_light_DirectionLight_T",
    "DirectionLight_B": "game_light_DirectionLight_B",
    "HueEdgeLight_001_L": "game_light_HueEdgeLight_001_L",
    "HueEdgeLight_001_R": "game_light_HueEdgeLight_001_R",
    "HueEdgeLight_002_L": "game_light_HueEdgeLight_002_L",
    "HueEdgeLight_002_R": "game_light_HueEdgeLight_002_R",
    "HueEdgeLight_003_L": "game_light_HueEdgeLight_003_L",
    "HueEdgeLight_003_R": "game_light_HueEdgeLight_003_R",
    "HueEdgeLight_004_L": "game_light_HueEdgeLight_004_L",
    "HueEdgeLight_004_R": "game_light_HueEdgeLight_004_R",
    "VibeLight_001": "game_light_VibeLight_001",
    "VibeLight_002": "game_light_VibeLight_002",
    "VibeLight_003": "game_light_VibeLight_003",
    "VibeLight_004": "game_light_VibeLight_004",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameFilterId(String data){
  static const GameFilterId None = GameFilterId("None");
  static const GameFilterId Fresh_001 = GameFilterId("Fresh_001");
  static const GameFilterId Fresh_002 = GameFilterId("Fresh_002");
  static const GameFilterId Fresh_003 = GameFilterId("Fresh_003");
  static const GameFilterId Fresh_004 = GameFilterId("Fresh_004");
  static const GameFilterId Fresh_005 = GameFilterId("Fresh_005");
  static const GameFilterId Weather_001 = GameFilterId("Weather_001");
  static const GameFilterId Weather_002 = GameFilterId("Weather_002");
  static const GameFilterId Weather_003 = GameFilterId("Weather_003");
  static const GameFilterId Weather_004 = GameFilterId("Weather_004");
  static const GameFilterId Vibe_009 = GameFilterId("Vibe_009");
  static const GameFilterId Vibe_001 = GameFilterId("Vibe_001");
  static const GameFilterId Vibe_002 = GameFilterId("Vibe_002");
  static const GameFilterId Vibe_003 = GameFilterId("Vibe_003");
  static const GameFilterId Vibe_004 = GameFilterId("Vibe_004");
  static const GameFilterId Vibe_005 = GameFilterId("Vibe_005");

  static const Map<String, String> _map = {
    "None": "game_filter_None",
    "Fresh_001": "game_filter_Fresh_001",
    "Fresh_002": "game_filter_Fresh_002",
    "Fresh_003": "game_filter_Fresh_003",
    "Fresh_004": "game_filter_Fresh_004",
    "Fresh_005": "game_filter_Fresh_005",
    "Weather_001": "game_filter_Weather_001",
    "Weather_002": "game_filter_Weather_002",
    "Weather_003": "game_filter_Weather_003",
    "Weather_004": "game_filter_Weather_004",
    "Vibe_009": "game_filter_Vibe_009",
    "Vibe_001": "game_filter_Vibe_001",
    "Vibe_002": "game_filter_Vibe_002",
    "Vibe_003": "game_filter_Vibe_003",
    "Vibe_004": "game_filter_Vibe_004",
    "Vibe_005": "game_filter_Vibe_005",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}





extension type const GameNikkiGiantState(bool data){
  static const GameNikkiGiantState falseState = GameNikkiGiantState(false);
  static const GameNikkiGiantState trueState = GameNikkiGiantState(true);

  static const Map<bool, String> _map = {
    false: "game_giant_state_false",
    true: "game_giant_state_true",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameNikkiHiddenState(bool data){
  static const GameNikkiHiddenState falseState = GameNikkiHiddenState(false);
  static const GameNikkiHiddenState trueState = GameNikkiHiddenState(true);

  static const Map<bool, String> _map = {
    false: "game_hidden_state_false",
    true: "game_hidden_state_true",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

// 10位
// 3b -> 102
// 1b -> 服装状态
//    服饰
//        进化 0 -> 0进, 2 -> 换新, 3 -> 1进, 4 -> 2进, 5 -> 3进
//    饰品
//
//    妆容-肤色
//        不保存该数据(0 -> 无)
//        1 -> 浓情夜宴
//        2 -> 暮色倒影
//        3 -> 雪上月华
// 2b -> 类型
//    发型(Hair) 10
//    连衣裙(Dresses) 90
//    外套(Outerwear) 20
//    上衣(Tops) 30
//    下装(Bottoms) 41
//    袜子(Socks) 50
//    鞋子(Shoes) 60
//    饰品-发饰(Hair Accessories) 71
//    饰品-帽子(Headwear) 72
//    饰品-耳饰(Earrings) 73
//    饰品-颈饰(Neckwear) 74
//    饰品-腕饰(Bracelets) 75
//    饰品-项圈(Chokers) 76
//    饰品-手套(Gloves) 77
//    饰品-面饰(Face Decorations) 92
//    饰品-胸饰(Chest Accessories) 93
//    饰品-挂饰(Pendants) 94
//    饰品-背饰(Backpieces) 95
//    饰品-戒指(Rings) 96
//    饰品-臂饰(Arm Decorations) 97
//    饰品-手持物(Handhelds) 78
//    饰品-肤绘(Body Paint) 79
//    妆容-全妆(Full Makeup) 不保存该数据(80) 底妆+眉妆+睫毛+美瞳+唇妆 同一套装
//    妆容-底妆(Base Makeup) 81
//    妆容-眉妆(Eyebrows) 82
//    妆容-睫毛(Eyelashes) 83
//    妆容-美瞳(Contacts) 84
//    妆容-唇妆(Lips) 85
//    妆容-肤色(Skin Tones) 86
// 4b -> 套装id
//    0042 -> 初始

extension type const GameClothes(int data){

  static const Map<int, String> _map = {

  };

  /// 102 0 71 0353
  bool get isClothes => data >= 1e9 && data < 1e10;

  // 102 -> 暖暖
  // 116 -> 大喵
  int get prefixId => data ~/ 1e7;

  int get state{
    final int p = ((data ~/ 1e7) * 1e7).toInt();

    return (data - p) ~/ 1e6;
  }

  GameNikkiClothesType get type{
    final int p = ((data ~/ 1e6) * 1e6).toInt();

    final int type = (data - p) ~/ 1e4;

    return GameNikkiClothesType(type);
  }

  int get outfitsId{
    final int p = ((data ~/ 1e4) * 1e4).toInt();

    return data - p;
  }

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

/// 注: 截至 2.1版本
/// 妆容无法进化/焕新, 默认值为0
/// 大喵斗篷无法进化/焕新, 默认值为0
extension type const GameClothesState(int data){
  static const GameClothesState evolution_0 = GameClothesState(0);
  /// TODO 未知值
  static const GameClothesState value_1 = GameClothesState(1);
  static const GameClothesState glowUp = GameClothesState(2);
  static const GameClothesState evolution_1 = GameClothesState(3);
  static const GameClothesState evolution_2 = GameClothesState(4);
  static const GameClothesState evolution_3 = GameClothesState(5);
  /// TODO 未知值
  static const GameClothesState value_9 = GameClothesState(9);

  static const Map<int, String> _map = {
    0: "game_nikki_clothes_evolution_0",
    1: "game_nikki_clothes_value_1",
    2: "game_nikki_clothes_glow_up",
    3: "game_nikki_clothes_evolution_1",
    4: "game_nikki_clothes_evolution_2",
    5: "game_nikki_clothes_evolution_3",
    9: "game_nikki_clothes_value_9",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameNikkiClothesSlot(int data){
  static const GameNikkiClothesSlot unknown = GameNikkiClothesSlot(-1);
  static const GameNikkiClothesSlot outfits = GameNikkiClothesSlot(1);
  static const GameNikkiClothesSlot hair = GameNikkiClothesSlot(2);
  static const GameNikkiClothesSlot dresses = GameNikkiClothesSlot(3);
  static const GameNikkiClothesSlot outerwear = GameNikkiClothesSlot(4);
  static const GameNikkiClothesSlot tops = GameNikkiClothesSlot(5);
  static const GameNikkiClothesSlot bottoms = GameNikkiClothesSlot(6);
  static const GameNikkiClothesSlot socks = GameNikkiClothesSlot(7);
  static const GameNikkiClothesSlot shoes = GameNikkiClothesSlot(8);
  static const GameNikkiClothesSlot accessories = GameNikkiClothesSlot(9);
  static const GameNikkiClothesSlot makeup = GameNikkiClothesSlot(10);

  static const Map<int, String> _map = {
    -1: "game_nikki_clothes_slot_unknown",
    1: "game_nikki_clothes_slot_outfits",
    2: "game_nikki_clothes_slot_hair",
    3: "game_nikki_clothes_slot_dresses",
    4: "game_nikki_clothes_slot_outerwear",
    5: "game_nikki_clothes_slot_tops",
    6: "game_nikki_clothes_slot_bottoms",
    7: "game_nikki_clothes_slot_socks",
    8: "game_nikki_clothes_slot_shoes",
    9: "game_nikki_clothes_slot_accessories",
    10: "game_nikki_clothes_slot_makeup",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameNikkiClothesType(int data){
  static const GameNikkiClothesType hair = GameNikkiClothesType(10);
  static const GameNikkiClothesType dresses = GameNikkiClothesType(90);
  static const GameNikkiClothesType outerwear = GameNikkiClothesType(20);
  static const GameNikkiClothesType tops = GameNikkiClothesType(30);
  static const GameNikkiClothesType bottoms = GameNikkiClothesType(41);
  static const GameNikkiClothesType socks = GameNikkiClothesType(50);
  static const GameNikkiClothesType shoes = GameNikkiClothesType(60);
  static const GameNikkiClothesType hairAccessories = GameNikkiClothesType(71);
  static const GameNikkiClothesType headwear = GameNikkiClothesType(72);
  static const GameNikkiClothesType earrings = GameNikkiClothesType(73);
  static const GameNikkiClothesType neckwear = GameNikkiClothesType(74);
  static const GameNikkiClothesType bracelets = GameNikkiClothesType(75);
  static const GameNikkiClothesType chokers = GameNikkiClothesType(76);
  static const GameNikkiClothesType gloves = GameNikkiClothesType(77);
  static const GameNikkiClothesType faceDecorations = GameNikkiClothesType(92);
  static const GameNikkiClothesType chestAccessories = GameNikkiClothesType(93);
  static const GameNikkiClothesType pendants = GameNikkiClothesType(94);
  static const GameNikkiClothesType backpieces = GameNikkiClothesType(95);
  static const GameNikkiClothesType rings = GameNikkiClothesType(96);
  static const GameNikkiClothesType armDecorations = GameNikkiClothesType(97);
  static const GameNikkiClothesType handhelds = GameNikkiClothesType(78);
  static const GameNikkiClothesType bodyPaint = GameNikkiClothesType(79);
  static const GameNikkiClothesType fullMakeup = GameNikkiClothesType(80);
  static const GameNikkiClothesType baseMakeup = GameNikkiClothesType(81);
  static const GameNikkiClothesType eyebrows = GameNikkiClothesType(82);
  static const GameNikkiClothesType eyelashes = GameNikkiClothesType(83);
  static const GameNikkiClothesType contacts = GameNikkiClothesType(84);
  static const GameNikkiClothesType lips = GameNikkiClothesType(85);
  static const GameNikkiClothesType skinTones = GameNikkiClothesType(86);

  static const Map<int, String> _map = {
    10: "game_nikki_clothes_clothing_hair",
    90: "game_nikki_clothes_clothing_dresses",
    20: "game_nikki_clothes_clothing_outerwear",
    30: "game_nikki_clothes_clothing_tops",
    41: "game_nikki_clothes_clothing_bottoms",
    50: "game_nikki_clothes_clothing_socks",
    60: "game_nikki_clothes_clothing_shoes",
    71: "game_nikki_clothes_accessories_hair_accessories",
    72: "game_nikki_clothes_accessories_headwear",
    73: "game_nikki_clothes_accessories_earrings",
    74: "game_nikki_clothes_accessories_neckwear",
    75: "game_nikki_clothes_accessories_bracelets",
    76: "game_nikki_clothes_accessories_chokers",
    77: "game_nikki_clothes_accessories_gloves",
    78: "game_nikki_clothes_accessories_handhelds",
    92: "game_nikki_clothes_accessories_face_decorations",
    93: "game_nikki_clothes_accessories_chest_accessories",
    94: "game_nikki_clothes_accessories_pendants",
    95: "game_nikki_clothes_accessories_backpieces",
    96: "game_nikki_clothes_accessories_rings",
    97: "game_nikki_clothes_accessories_arm_decorations",
    79: "game_nikki_clothes_accessories_body_paint",
    80: "game_nikki_clothes_makeup_full_makeup",
    81: "game_nikki_clothes_makeup_base_makeup",
    82: "game_nikki_clothes_makeup_eyebrows",
    83: "game_nikki_clothes_makeup_eyelashes",
    84: "game_nikki_clothes_makeup_contacts",
    85: "game_nikki_clothes_makeup_lips",
    86: "game_nikki_clothes_makeup_skin_tones",
  };

  GameNikkiClothesSlot get slot => switch(data){
    10 => GameNikkiClothesSlot.hair,
    90 => GameNikkiClothesSlot.dresses,
    20 => GameNikkiClothesSlot.outerwear,
    30 => GameNikkiClothesSlot.tops,
    41 => GameNikkiClothesSlot.bottoms,
    50 => GameNikkiClothesSlot.socks,
    60 => GameNikkiClothesSlot.shoes,
    >= 70 && <= 79 || >= 92 && <= 97 => GameNikkiClothesSlot.accessories,
    >= 80 && <= 86 => GameNikkiClothesSlot.makeup,
    _ => GameNikkiClothesSlot.unknown,
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameNikkiClothesOutfits(int data){
  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameMomoClothesType(int data){
  static const GameNikkiClothesType cloak = GameNikkiClothesType(10);

  static const Map<int, String> _map = {
    10: "game_momo_clothes_cloak",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}


extension type const GameDIYType(int data){
  static const GameDIYType outfitDye = GameDIYType(1);
  static const GameDIYType specialEffect = GameDIYType(2);
  static const GameDIYType patternCreation = GameDIYType(3);

  static const Map<int, String> _map = {
    1: "game_DIY_outfit_dye",
    2: "game_DIY_special_effect",
    3: "game_DIY_pattern_creation",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameDIYColorGrid(int data){

  /// (R, G, B, A)
  static const Map<int, (double, double, double, double)> _map = {
    1: (0, 0, 0, 0),
  };

  bool get isInGrid => data == -1 || data >= 1 && data <= 144;

  GameDIYColorPalette get palette => data == -1 ? GameDIYColorPalette.custom : GameDIYColorPalette(1 + data ~/ 8);

  GameDIYColorSwatch get swatch => data == -1 ? GameDIYColorSwatch(0) : GameDIYColorSwatch(1 + data % 8);

  (double, double, double, double)? get color => _map[data];

  String get stringData => data.toString();

  bool get hasTranslation => false;
}

// 颜色id
// 1 -1 -> 自选 色盘
// 2 1 - 8 -> 飞球果飘飘 色盘
// 3 9 - 16 -> 春日满满星 色盘
// 4 17 - 24 -> 星光果之梦 色盘
// 5 25 - 32 -> 眼影鱼碎闪 色盘
// 6 33 - 40 -> 围兜暖毛球 色盘
// 7 41 - 48 -> 星夜时光树 色盘
// 8 49 - 56 -> 崖上的壁灯 色盘
// 9 57 - 64 -> 风铃子腹语 色盘
// 10 65 - 72 -> 风絮草飘飞时 色盘
// 11 73 - 80 -> 雨夜路灯花 色盘
// 12 81 - 88 -> 耳坠萤未眠 色盘
// 13 89 - 96 -> 碧波裙摆湖 色盘
// 14 97 - 104 -> 星荧草来信 色盘
// 15 105 - 112 -> 丝巾蛾魅影 色盘
// 16 113 - 120 -> 花伞藤萝之雨 色盘
// 17 121 - 128 -> 兔耳草嫩蕊 色盘
// 18 129 - 136 -> 裙撑萤之歌 色盘
// 19 137 - 144 -> 名流鸦盛宴 色盘
extension type const GameDIYColorPalette(int data){
  static const GameDIYColorPalette custom = GameDIYColorPalette(0);
  static const GameDIYColorPalette flightFruitFlutter = GameDIYColorPalette(1);
  static const GameDIYColorPalette springStarlitBreath = GameDIYColorPalette(2);
  static const GameDIYColorPalette stellarFruitDream = GameDIYColorPalette(3);
  static const GameDIYColorPalette palettetailShimmer = GameDIYColorPalette(4);
  static const GameDIYColorPalette bibcoonFurballHug = GameDIYColorPalette(5);
  static const GameDIYColorPalette starlitChronosTree = GameDIYColorPalette(6);
  static const GameDIYColorPalette lanternByTheCliff = GameDIYColorPalette(7);
  static const GameDIYColorPalette chimecadaMurmur = GameDIYColorPalette(8);
  static const GameDIYColorPalette windbloomWhirl = GameDIYColorPalette(9);
  static const GameDIYColorPalette lampbloomMist = GameDIYColorPalette(10);
  static const GameDIYColorPalette sleeplessGlimmerdrop = GameDIYColorPalette(11);
  static const GameDIYColorPalette silkenLakeEmerald = GameDIYColorPalette(12);
  static const GameDIYColorPalette glimmergrassLetter = GameDIYColorPalette(13);
  static const GameDIYColorPalette scarfmothPhantom = GameDIYColorPalette(14);
  static const GameDIYColorPalette wisteriasolRain = GameDIYColorPalette(15);
  static const GameDIYColorPalette buddingHareEars = GameDIYColorPalette(16);
  static const GameDIYColorPalette bustleflySong = GameDIYColorPalette(17);
  static const GameDIYColorPalette celebcrowFeast = GameDIYColorPalette(18);

  static const Map<int, String> _map = {
    0: "game_DIY_color_palette_custom",
    1: "game_DIY_color_palette_flight_fruit_flutter",
    2: "game_DIY_color_palette_spring_starlit_breath",
    3: "game_DIY_color_palette_stellar_fruit_dream",
    4: "game_DIY_color_palette_palettetail_shimmer",
    5: "game_DIY_color_palette_bibcoon_furball_hug",
    6: "game_DIY_color_palette_starlit_chronos_tree",
    7: "game_DIY_color_palette_lantern_by_the_cliff",
    8: "game_DIY_color_palette_chimecada_murmur",
    9: "game_DIY_color_palette_windbloom_whirl",
    10: "game_DIY_color_palette_lampbloom_mist",
    11: "game_DIY_color_palette_sleepless_glimmerdrop",
    12: "game_DIY_color_palette_silken_lake_emerald",
    13: "game_DIY_color_palette_glimmergrass_letter",
    14: "game_DIY_color_palette_scarfmoth_phantom",
    15: "game_DIY_color_palette_wisteriasol_rain",
    16: "game_DIY_color_palette_budding_hare_ears",
    17: "game_DIY_color_palette_bustlefly_song",
    18: "game_DIY_color_palette_celebcrow_feast",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameDIYColorSwatch(int data){
  static const GameDIYColorSwatch swatch_1 = GameDIYColorSwatch(1);
  static const GameDIYColorSwatch swatch_2 = GameDIYColorSwatch(2);
  static const GameDIYColorSwatch swatch_3 = GameDIYColorSwatch(3);
  static const GameDIYColorSwatch swatch_4 = GameDIYColorSwatch(4);
  static const GameDIYColorSwatch swatch_5 = GameDIYColorSwatch(5);
  static const GameDIYColorSwatch swatch_6 = GameDIYColorSwatch(6);
  static const GameDIYColorSwatch swatch_7 = GameDIYColorSwatch(7);
  static const GameDIYColorSwatch swatch_8 = GameDIYColorSwatch(8);

  static const Map<int, String> _map = {
    1: "game_DIY_color_palette_1",
    2: "game_DIY_color_palette_2",
    3: "game_DIY_color_palette_3",
    4: "game_DIY_color_palette_4",
    5: "game_DIY_color_palette_5",
    6: "game_DIY_color_palette_6",
    7: "game_DIY_color_palette_7",
    8: "game_DIY_color_palette_8",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameDIYHairColorMode(int data){

  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameDIYCoverDIYColor(bool data){
  static const GameDIYCoverDIYColor falseState = GameDIYCoverDIYColor(false);
  static const GameDIYCoverDIYColor trueState = GameDIYCoverDIYColor(true);

  static const Map<bool, String> _map = {
    false: "game_DIY_cover_DIY_color_false",
    true: "game_DIY_cover_DIY_color_true",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameDIYPatternTexture(int data){

  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameDIYOverridePatternA(bool data){
  static const GameDIYOverridePatternA defaultState = falseState;
  static const GameDIYOverridePatternA falseState = GameDIYOverridePatternA(false);
  static const GameDIYOverridePatternA trueState = GameDIYOverridePatternA(true);

  static const Map<bool, String> _map = {
    false: "game_DIY_override_pattern_A_false",
    true: "game_DIY_override_pattern_A_true",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}
