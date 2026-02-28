




mixin _GetLast{
  static const List<int> _powMap = [1, 10, 100, 1000];

  static int getLast(int data){
    final int p = (data ~/ 10);
    final int l = data - p * 10;

    return p - (p ~/ _powMap[l]) * _powMap[l];
  }
}


extension type const GameDimension(int data){
  static const GameDimension miraland = GameDimension(1);
  static const GameDimension seaOfStars = GameDimension(2);
  static const GameDimension home = GameDimension(3);

  static const Map<int, String> _map = {
    1: "game_dimension_miraland",
    2: "game_dimension_sea_of_stars",
    3: "game_dimension_home",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameNation(int data){
  static const GameNation heartcraftKingdom = GameNation(111);
  static const GameNation empireOfLight = GameNation(211);
  static const GameNation terraAlliance = GameNation(311);
  static const GameNation starhailFederation = GameNation(1411);
  static const GameNation linlangEmpire = GameNation(511);
  static const GameNation twinmoonKingdom = GameNation(611);
  static const GameNation whalePort = GameNation(711);
  static const GameNation umbraso = GameNation(811);

  static const Map<int, String> _map = {
    111: "game_nation_heartcraft_kingdom",
    211: "game_nation_empire_of_light",
    311: "game_nation_terra_alliance",
    411: "game_nation_starhail_federation",
    511: "game_nation_linlang_empire",
    611: "game_nation_twinmoon_kingdom",
    711: "game_nation_whale_port",
    811: "game_nation_umbraso",
  };

  GameDimension get dimension{
    return GameDimension(_GetLast.getLast(data));
  }

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}




extension type const GameMap(int data){
  static const GameMap miraland = GameMap(1);
  static const GameMap fireworkIsles = GameMap(2);
  static const GameMap serenityIsland = GameMap(3);
  static const GameMap danqingIsland = GameMap(4);
  static const GameMap danqingRealm = GameMap(5);
  static const GameMap wanxiangRealm = GameMap(6);

  static const Map<int, String> _map = {
    1: "assets/map/miraland.webp",
    2: "assets/map/firework_isles.webp",
    3: "assets/map/serenity_island.webp",
    4: "assets/map/danqing_island.webp",
    5: "assets/map/danqing_realm.webp",
    6: "assets/map/wanxiang_realm.webp",
  };

  static const Map<int, (int, int)> _mapSize = {
    1: (16383, 10756),
  };

  /// (pixel point, coord point)
  static const Map<int, (((num, num), (num, num)), ((num, num), (num, num)))> _referencePoint = {
    1: (((11491, 5234), (-13172, -54273)), ((3941, 3823), (-501245, -145560))),
  };

  (int, int) coordToPixel((num, num) coordinates){
    final rp = _referencePoint[data] ?? _referencePoint[1]!;

    final r1 = rp.$1;
    final r2 = rp.$2;

    final p1 = r1.$1;
    final c1 = r1.$2;
    final p2 = r2.$1;
    final c2 = r2.$2;

    final x = p1.$1 + (p2.$1 - p1.$1) * (coordinates.$1 - c1.$1) / (c2.$1 - c1.$1);
    final y = p1.$2 + (p2.$2 - p1.$2) * (coordinates.$2 - c1.$2) / (c2.$2 - c1.$2);

    return (x.toInt(), y.toInt());
  }

  String get assetName => _map[data] ?? _map[1]!;

  (int, int) get mapSize => _mapSize[data] ?? _mapSize[1]!;
}

extension type const GamePhotoRegion(int data){
  static const GamePhotoRegion unknown = GamePhotoRegion(-1);
  static const GamePhotoRegion home = GamePhotoRegion(1);
  static const GamePhotoRegion seaOfStars = GamePhotoRegion(2);
  static const GamePhotoRegion memorialMountains = GamePhotoRegion(3);
  static const GamePhotoRegion florawish = GamePhotoRegion(4);
  static const GamePhotoRegion breezyMeadow = GamePhotoRegion(5);
  static const GamePhotoRegion stoneville = GamePhotoRegion(6);
  static const GamePhotoRegion abandonedDistrict = GamePhotoRegion(7);
  static const GamePhotoRegion wishingWoods = GamePhotoRegion(8);
  static const GamePhotoRegion fireworkIsles = GamePhotoRegion(9);
  static const GamePhotoRegion serenityIsland = GamePhotoRegion(10);
  static const GamePhotoRegion danqingIsland = GamePhotoRegion(11);
  static const GamePhotoRegion danqingRealm = GamePhotoRegion(12);
  static const GamePhotoRegion elderwoodForest = GamePhotoRegion(13);
  static const GamePhotoRegion spira = GamePhotoRegion(14);
  static const GamePhotoRegion wanxiangRealm = GamePhotoRegion(15);

  static const Map<int, String> _map = {
    -1: "game_photo_region_unknown",
    1: "game_photo_region_home",
    2: "game_photo_region_sea_of_stars",
    3: "game_photo_region_memorial_mountains",
    4: "game_photo_region_florawish",
    5: "game_photo_region_breezy_meadow",
    6: "game_photo_region_stoneville",
    7: "game_photo_region_abandoned_district",
    8: "game_photo_region_wishing_woods",
    9: "game_photo_region_firework_isles",
    10: "game_photo_region_serenity_island",
    11: "game_photo_region_danqing_island",
    12: "game_photo_region_danqing_realm",
    13: "game_photo_region_elderwood_forest",
    14: "game_photo_region_spira",
    15: "game_photo_region_wanxiang_realm",
  };

  /// (最小高度, 最大高度, [(x, y)])
  static const Map<int, (num, num, List<(num, num)>)> _enclosureMap = {
    // 家园
    1: (-300, 7000, [(-10174.93,-8472.43),(11535.34,-14879.2),(16067.64,-13760.11),(22306.55,-8108.73),(23733.38,1487.44),(17970.09,16790.94),(7590.57,25072.18),(8.76,25072.18),(-10482.68,17210.6),(-15658.45,4536.95),(-14007.8,-4052.04)]),
    // 星海
    2: (-21000, -16000, [(37807.43,72039.43),(-10490.97,65704.18),(-37023.73,52092.82),(-38591.86,43123.11),(-35392.88,33212.53),(-25105.94,24242.83),(-23914.16,16715.81),(-18143.45,11697.79),(-11118.22,12387.77),(-5222.06,16715.81),(6695.73,15524.03),(13030.98,9188.78),(20118.92,8436.08),(22627.93,10506.01),(18299.89,22674.7),(18299.89,27316.36),(25136.94,30828.98),(38873.76,32020.75),(45773.53,38544.17),(46651.68,43813.09),(43389.97,69781.32)]),
    // 纪念山地
    3: (double.negativeInfinity, double.infinity, [(-56614.89,-43412.28),(-26101.43,-48777.99),(-37026.8,-53303.29),(-40323.81,-59186.18),(-48469.35,-56600.3),(-52283.53,-62483.19),(-45948.11,-83040.99),(-95144.6,-80261.16)]),
    // 花愿镇
    4: (double.negativeInfinity, double.infinity, [(49277.16,-42636.51),(53349.93,-46192.1),(58651.0,-45674.93),(61948.0,-42636.51),(89616.98,-44705.22),(131766.93,-29707.08),(127694.16,-11670.52),(25163.77,-29448.49),(-25842.84,-47226.46),(-35992.45,-52592.17),(-40065.22,-59186.18),(-49245.12,-56858.89),(-52283.53,-63194.31),(-37285.39,-103081.61),(23095.06,-96487.6)]),
    // 微风绿野 (相交: 星海)
    5: (-25000, -6000, [(-57843.19,-42636.51),(-26360.02,-48519.4),(533.2,-15743.29),(16759.64,18261.11),(68089.48,54334.23),(68089.48,95191.23),(29947.66,133785.59),(-113439.75,102819.6),(-107621.5,42374.5),(-77172.69,6818.57),(-70578.68,-16001.88),(-79176.75,-36042.5)]),
    // 小石树田村
    6: (double.negativeInfinity, double.infinity, [(-71289.8,-15484.7),(-83249.52,32483.49),(-121326.7,26923.83),(-146474.44,-13480.64),(-146474.44,-29965.67),(-134773.31,-46450.69),(-116478.16,-54337.65)]),
    // 石树田无人区
    7: (double.negativeInfinity, double.infinity, [(-146733.03,-30482.84),(-140850.14,-41666.8),(-52283.53,-153829.63),(-173367.66,-244982.12),(-306152.93,-151049.8),(-300270.04,-89376.41),(-308674.17,-80713.69),(-307381.23,8628.69),(-188365.8,20265.18)]),
    // 祈愿树林
    8: (double.negativeInfinity, double.infinity, [(53091.34,-46192.1),(58651.0,-45480.99),(89616.98,-48002.23),(135322.53,-30741.43),(179476.54,-43153.69),(186587.73,-167793.41),(74942.08,-186605.74),(45204.39,-109417.03)]),
    // 花焰群岛
    9: (double.negativeInfinity, double.infinity, [(-231645.07,610721.77),(-190342.89,596028.51),(-186636.02,566951.78),(-211840.68,540972.71),(-240308.21,539888.52),(-267216.58,557204.46),(-271852.75,585362.23),(-259172.98,608099.08)]),
    // 无忧岛 (相交: 家园)
    10: (0, 35000, [(-57012.82,69452.59),(-16636.17,74358.82),(14406.68,21377.56),(-21303.07,-2196.26),(-54679.37,10169.02),(-61450.36,39815.79)]),
    // 丹青屿 (相交: 丹青之境)
    11: (-20000, 0, [(-259255.97,328276.73),(-224232.18,311115.98),(-215651.81,252870.23),(-276401.44,186410.52),(-320723.18,182837.91),(-333944.89,221067.89),(-317150.57,306474.64)]),
    // 丹青之境
    12: (-20000, -10000, [(-279384.94,307394.6),(-243497.55,303128.79),(-217917.92,271507.21),(-265175.72,189789.01),(-347258.25,148208.83),(-367145.09,162782.38),(-349383.56,249479.88)]),
    // 巨木之森
    13: (double.negativeInfinity, double.infinity, [(-545929.25,-254937.79),(-536296.82,-250865.01),(-523108.8,-250089.25),(-449475.69,-284352.24),(-388578.06,-261790.38),(-305053.93,-130815.24),(-299946.8,-89893.59),(-308092.35,-81036.92),(-557436.44,-1003.74),(-742327.32,-184472.38),(-623376.55,-310405.05)]),
    // 蜗牛城
    14: (double.negativeInfinity, double.infinity, [(-546187.84,-255907.49),(-535779.64,-250089.25),(-522074.45,-249830.66),(-504555.07,-259721.68),(-505072.24,-285128.01),(-558923.33,-296764.5)]),
    // 万相境
    15: (0, 60000, [(33713.85,104184.05),(118859.9,118094.84),(146941.68,109948.52),(142618.32,61490.93),(84573.3,4887.03),(46183.53,2244.98),(5892.28,64853.54),(12617.49,90033.07)]),
  };

  static const Map<Set<int>, int> _contradictionMap = {
    // 家园 & 微风绿野, 相交部分微风绿野大部分高度低于星海
    {2, 5}: 5,
    // 家园 & 无忧岛, 相交部分为家园需解锁区域
    {1, 10}: 10,
    // 丹青屿 & 丹青之境
    {11, 12}: 11,
  };

  /// 判断点是否在多边形内
  static bool _isPointInPolygon(num x, num y, List<(num, num)> polygon) {
    int windingNumber = 0;
    int n = polygon.length;

    for (int i = 0, j = n - 1; i < n; j = i++) {
      final (xi, yi) = polygon[i];
      final (xj, yj) = polygon[j];

      if (yi <= y) {
        if (yj > y && _isLeft(xi, yi, xj, yj, x, y) > 0) {
          windingNumber++;
        }
      } else {
        if (yj <= y && _isLeft(xi, yi, xj, yj, x, y) < 0) {
          windingNumber--;
        }
      }
    }
    return windingNumber != 0;
  }

  static num _isLeft(num x1, num y1, num x2, num y2, num x, num y) {
    return (x2 - x1) * (y - y1) - (x - x1) * (y2 - y1);
  }

  static List<GamePhotoRegion> byCoordinates((num, num, num) coordinates){
    final (x, y, z) = coordinates;
    final List<GamePhotoRegion> matches = [];

    // 收集所有匹配的区域
    for (final entry in _enclosureMap.entries) {
      final (minHeight, maxHeight, polygon) = entry.value;

      if (z < minHeight || z > maxHeight){
        continue;
      }
      if (_isPointInPolygon(x, y, polygon)) {
        matches.add(GamePhotoRegion(entry.key));
      }
    }

    if (matches.isEmpty) return [GamePhotoRegion.unknown];
    if (matches.length == 1) return matches;

    return matches;

    // 2. 修复冲突处理：使用 Set 提高查找效率
    final matchIds = matches.map((r) => r.data).toSet();

    // 按优先级分组
    final priorityRegions = <int>[];
    final remainingIds = matchIds.toSet();

    for (final entry in _contradictionMap.entries) {
      final conflictSet = entry.key;
      final priorityId = entry.value;

      // 检查是否包含此冲突对（子集检查）
      if(matchIds.containsAll(conflictSet)){
        priorityRegions.add(priorityId);
        remainingIds.removeAll(conflictSet);
        remainingIds.add(priorityId); // 保留优先级高的
      }
    }

    // 构建结果：优先级高的在前，其余按原顺序
    final result = <GamePhotoRegion>[];
    final seen = <int>{};

    // 先添加所有优先级区域
    for (final id in priorityRegions) {
      if (seen.add(id)) {
        result.add(GamePhotoRegion(id));
      }
    }

    // 再添加剩余区域
    for (final region in matches) {
      if (seen.add(region.data)) {
        result.add(region);
      }
    }

    return result;
  }

  GameMap get map => switch(data){
    (>=3 && <= 8) || (>= 13 && <= 14) => GameMap.miraland,
    9 => GameMap.fireworkIsles,
    10 => GameMap.serenityIsland,
    11 => GameMap.danqingIsland,
    12 => GameMap.danqingRealm,
    15 => GameMap.wanxiangRealm,
    _ => GameMap.miraland,
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameCheckpoint((num, num, num) data){

  static const Map<(num, num, num), String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}



extension type const GameCollageTemplate(int data){

  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameExpedition(int data){

  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameWeather(int data){
  static const GameWeather sunny = GameWeather(0);
  static const GameWeather rainy = GameWeather(2);

  static const Map<int, String> _map = {
    0: "game_weather_0",
    2: "game_weather_2",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GamePhotoWall(int data){

  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameInteractivePhoto(int data){

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

extension type const GameRiskPhoto(int data){

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

extension type const GameLight(String data){
  static const GameLight None = GameLight("None");
  static const GameLight DirectionLight_L = GameLight("DirectionLight_L");
  static const GameLight DirectionLight_R = GameLight("DirectionLight_R");
  static const GameLight DirectionLight_T = GameLight("DirectionLight_T");
  static const GameLight DirectionLight_B = GameLight("DirectionLight_B");
  static const GameLight HueEdgeLight_001_L = GameLight("HueEdgeLight_001_L");
  static const GameLight HueEdgeLight_001_R = GameLight("HueEdgeLight_001_R");
  static const GameLight HueEdgeLight_002_L = GameLight("HueEdgeLight_002_L");
  static const GameLight HueEdgeLight_002_R = GameLight("HueEdgeLight_002_R");
  static const GameLight HueEdgeLight_003_L = GameLight("HueEdgeLight_003_L");
  static const GameLight HueEdgeLight_003_R = GameLight("HueEdgeLight_003_R");
  static const GameLight HueEdgeLight_004_L = GameLight("HueEdgeLight_004_L");
  static const GameLight HueEdgeLight_004_R = GameLight("HueEdgeLight_004_R");
  static const GameLight VibeLight_001 = GameLight("VibeLight_001");
  static const GameLight VibeLight_002 = GameLight("VibeLight_002");
  static const GameLight VibeLight_003 = GameLight("VibeLight_003");
  static const GameLight VibeLight_004 = GameLight("VibeLight_004");

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

extension type const GameFilter(String data){
  static const GameFilter None = GameFilter("None");
  static const GameFilter Fresh_001 = GameFilter("Fresh_001");
  static const GameFilter Fresh_002 = GameFilter("Fresh_002");
  static const GameFilter Fresh_003 = GameFilter("Fresh_003");
  static const GameFilter Fresh_004 = GameFilter("Fresh_004");
  static const GameFilter Fresh_005 = GameFilter("Fresh_005");
  static const GameFilter Weather_001 = GameFilter("Weather_001");
  static const GameFilter Weather_002 = GameFilter("Weather_002");
  static const GameFilter Weather_003 = GameFilter("Weather_003");
  static const GameFilter Weather_004 = GameFilter("Weather_004");
  static const GameFilter Vibe_009 = GameFilter("Vibe_009");
  static const GameFilter Vibe_001 = GameFilter("Vibe_001");
  static const GameFilter Vibe_002 = GameFilter("Vibe_002");
  static const GameFilter Vibe_003 = GameFilter("Vibe_003");
  static const GameFilter Vibe_004 = GameFilter("Vibe_004");
  static const GameFilter Vibe_005 = GameFilter("Vibe_005");

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

extension type const GamePose(int data){

  static const Map<int, String> _map = {
    0: "game_pose_none",
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

  bool get isClothes => data >= 1e9 && data < 1e10;

  // 102 -> 暖暖
  // 116 -> 大喵
  int get prefixId => data ~/ 1e7;

  int get state{
    final int p = ((data ~/ 1e7) * 1e7).toInt();

    return (data - p) ~/ 1e6;
  }

  int get type{
    final int p = ((data ~/ 1e6) * 1e6).toInt();

    return (data - p) ~/ 1e4;
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
    10: "game_nikki_clothes_hair",
    90: "game_nikki_clothes_dresses",
    20: "game_nikki_clothes_outerwear",
    30: "game_nikki_clothes_tops",
    41: "game_nikki_clothes_bottoms",
    50: "game_nikki_clothes_socks",
    60: "game_nikki_clothes_shoes",
    71: "game_nikki_clothes_hair_accessories",
    72: "game_nikki_clothes_headwear",
    73: "game_nikki_clothes_earrings",
    74: "game_nikki_clothes_neckwear",
    75: "game_nikki_clothes_bracelets",
    76: "game_nikki_clothes_chokers",
    77: "game_nikki_clothes_gloves",
    78: "game_nikki_clothes_handhelds",
    92: "game_nikki_clothes_face_decorations",
    93: "game_nikki_clothes_chest_accessories",
    94: "game_nikki_clothes_pendants",
    95: "game_nikki_clothes_backpieces",
    96: "game_nikki_clothes_rings",
    97: "game_nikki_clothes_arm_decorations",
    79: "game_nikki_clothes_body_paint",
    80: "game_nikki_clothes_full_makeup",
    81: "game_nikki_clothes_base_makeup",
    82: "game_nikki_clothes_eyebrows",
    83: "game_nikki_clothes_eyelashes",
    84: "game_nikki_clothes_contacts",
    85: "game_nikki_clothes_lips",
    86: "game_nikki_clothes_skin_tones",
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


extension type const GameEureka(int data){

  static const Map<int, String> _map = {

  };

  bool get isEureka => data >= 1e3;

  // 102 -> 暖暖
  // 116 -> 大喵
  int get id => data ~/ 1e3;

  GameEurekaAttachmentPoint get attachmentPoint{
    final int p = ((data ~/ 1e3) * 1e3).toInt();

    final int attachmentPoint = (data - p) ~/ 1e2;

    return GameEurekaAttachmentPoint(attachmentPoint);
  }

  GameEurekaLevel get level{
    final int p = ((data ~/ 1e2) * 1e2).toInt();

    final int level = (data - p) ~/ 1e1;

    return GameEurekaLevel(level);
  }

  int get color{
    final int p = ((data ~/ 1e1) * 1e1).toInt();

    return data - p;
  }

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameEurekaAttachmentPoint(int data){
  static const GameEurekaAttachmentPoint head = GameEurekaAttachmentPoint(1);
  static const GameEurekaAttachmentPoint hands = GameEurekaAttachmentPoint(2);
  static const GameEurekaAttachmentPoint feet = GameEurekaAttachmentPoint(3);

  static const Map<int, String> _map = {
    1: "game_eureka_attachment_point_head",
    2: "game_eureka_attachment_point_hands",
    3: "game_eureka_attachment_point_feet",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameEurekaLevel(int data){
  static const GameEurekaLevel levelNonMax = GameEurekaLevel(1);
  static const GameEurekaLevel levelMaxStar_3 = GameEurekaLevel(2);
  static const GameEurekaLevel levelMaxStar_4 = GameEurekaLevel(3);
  static const GameEurekaLevel levelMaxStar_5 = GameEurekaLevel(4);

  static const Map<int, String> _map = {
    1: "game_eureka_level_non_max",
    2: "game_eureka_level_max_star_3",
    3: "game_eureka_level_max_star_4",
    4: "game_eureka_level_max_star_5",
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


extension type const GameWeapon(int data){

  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameWeaponSlotType(String data){
  static const GameWeaponSlotType bubbleMachine = GameWeaponSlotType("BubbleMachine");
  static const GameWeaponSlotType feedSnail = GameWeaponSlotType("FeedSnail");
  static const GameWeaponSlotType suit = GameWeaponSlotType("Suit");

  static const Map<String, String> _map = {
    "BubbleMachine": "game_slot_type_bubble_machine",
    "FeedSnail": "game_slot_type_feed_snail",
    "Suit": "game_slot_type_suit",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameWeaponCustomState(String data){
  static const GameWeaponCustomState close = GameWeaponCustomState("Weapon.State.Close");
  static const GameWeaponCustomState open = GameWeaponCustomState("Weapon.State.Open");

  static const Map<String, String> _map = {
    "Weapon.State.Close": "game_weapon_custom_state_close",
    "Weapon.State.Open": "game_weapon_custom_state_open",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}


extension type const GameInteraction(int data){

  static const Map<int, String> _map = {

  };

  GameInteractionType get type => switch(data){
    800002 => GameInteractionType.chair,
    _ => GameInteractionType.decoration,
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

extension type const GameInteractionType(int data){
  static const GameInteractionType chair = GameInteractionType(1);
  static const GameInteractionType decoration = GameInteractionType(2);

  static const Map<int, String> _map = {
    1: "game_interaction_type_chair",
    2: "game_interaction_type_decoration",
  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}


extension type const GameCarrier(int data){

  static const Map<int, String> _map = {

  };

  String get stringData => _map[data] ?? data.toString();

  bool get hasTranslation => _map.containsKey(data);
}

