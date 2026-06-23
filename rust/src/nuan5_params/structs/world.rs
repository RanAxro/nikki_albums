
#[derive(Clone)]
pub enum Location{
  Standard{
    dimension: Option<Dimension>,
    nation: Option<Nation>,
    region: Option<Region>,
    area: Option<Area>,
    subarea: Option<Subarea>,
  },
  Special{
    dimension: Option<Dimension>,
    subarea: Option<Subarea>
  }
}


#[derive(Clone)]
pub enum Dimension{
  Miraland,                     // 奇迹大陆
  SeaOfStars,                   // 星海
  Home,                         // 家园
}

#[derive(Clone)]
pub enum Nation{
  /// # Dimension::Miraland
  HeartcraftKingdom,            // 筑心王国
  EmpireOfLight,                // 光芒帝国
  TerraAlliance,                // 大地联盟
  StarhailFederation,           // 慕星联邦
  LinlangEmpire,                // 琳琅帝国
  TwinmoonKingdom,              // 双月王国
  WhalePort,                    // 孤鲸港
  Umbraso,                      // 影谷议会国
}

#[derive(Clone)]
pub enum Region{
  /// # Nation::HeartcraftKingdom
  Wishfield,                    // 心愿乡 | 心愿原野

  /// # Nation::TerraAlliance
  Itzaland,                     // 伊赞之土
}

#[derive(Clone)]
pub enum Area{
  /// # Region::Wishfield
  MemorialMountains,            // 纪念山地
  Florawish,                    // 愿望镇 | 花愿镇
  BreezyMeadow,                 // 微风绿野
  Stoneville,                   // 小石树田村
  AbandonedDistrict,            // 石树田无人区
  WishingWoods,                 // 祈愿树林
  FireworkIsles,                // 花焰群岛
  SerenityIsland,               // 无忧岛
  DanqingIsland,                // 丹青屿
  DanqingRealm,                 // 丹青之境

  /// # Region::Itzaland
  ItzalandCanyon,               // 伊地峡谷
  ElderwoodForest,              // 巨木之森
  Spira,                        // 蜗牛城
  Boneyard,                     // 埋骨地
  WanxiangRealm,                // 万相境
}

#[derive(Clone)]
pub enum Subarea{
  /// # Region::MemorialMountains
  OldFlorawishMemorial,         // 古花愿镇纪念公园
  StylistGuildMemorial,         // 搭配师协会纪念旧址

  /// # Region::Florawish
  DreamwovenRuins,              // 栖愿遗迹
  FortuneFalls,                 // 福鸣瀑布
  GreatWishtreeSquare,          // 大许愿树广场
  LakesideDistrict,             // 湖畔街区
  OutskirtsForest,              // 镇郊林区

  /// # Region::BreezyMeadow
  AbandonedFanaticWisherCamp,   // 废弃疯愿之子营地
  BreezyMeadowActivityArea,     // 绿野活动区
  BugSongHills,                 // 虫鸣花坡
  CiciaHighlands,               // 花树高地
  HeartcraftKingdomOutpost,     // 筑心王国边境哨所
  LakesideHill,                 // 河畔山地
  MeadowWharf,                  // 绿野货运码头
  QueenPalaceRuins,             // 女王行宫遗迹
  RelicHill,                    // 遗迹山坡
  SleepyFishHills,              // 悠悠草坡
  SwanGazebo,                   // 天鹅羽亭

  /// # Region::Stoneville
  DyeWorkshop,                  // 染织工坊
  FlowerFieldsResidence,        // 花田民居
  RockfallValley,               // 落石谷
  StonevilleMarket,             // 村口集市

  /// # Region::AbandonedDistrict
  ChooChooStation,              // 呜呜车站
  GoldenFields,                 // 麦浪农场
  MarketOfMirth,                // 欢乐市集
  Prosperville,                 // 丰饶古村
  RippleEstate,                 // 涟漪庄园
  StellarFishingGround,         // 星空钓场
  Stonecrown,                   // 石之冠
  WindriderMill,                // 乘风磨坊

  /// # Region::WishingWoods
  BrookwoodForest,              // 溪声林地
  CavernOfWishes,               // 心愿洞窟
  FallenWishHighlands,          // 殒愿山岭
  GrandTreeValley,              // 大树谷
  SacredMountains,              // 圣山
  ValleyOfBlossoms,             // 圣地花谷

  /// # Region::FireworkIsles
  ClearheartLake,               // 澄净湖
  CrescentMoonRuins,            // 月角遗迹区
  FlamingForest,                // 焰光森林
  RelicIsles,                   // 遗迹群岛
  SongbreezeHighland,           // 聆风高地
  SparkheartIsland,             // 焰心岛

  /// # Region::SerenityIsland
  OldRuins,                     // 古老的废墟
  Soakville,                    // 布露村
  SoakvilleOutskirts,           // 布露村郊外
  Steamville,                   // 蒸汽维尔

  /// # Region::DanqingIsland
  DanqingIsland_BackMountain,   // 后山
  BambooGrove,                  // 竹林
  DanqingIsland_Inkville,       // 墨缘乡
  InkwashStream,                // 洗墨涧
  LoongPagoda,                  // 奉龙塔
  LoongPeak,                    // 栖龙峰
  ReedblossomShore,             // 芦花水畔

  /// # Region::DanqingRealm
  GreenBambooGrove,             // 青竹林地
  InkPool,                      // 墨池
  InkshorePlain,                // 临墨坪
  DanqingRealm_Inkville,        // 墨缘乡
  WildfieldWaterside,           // 野郊水畔

  /// # Region::ElderwoodForest
  BehemothObservationSite,      /// 巨兽观测点
  Coliseum,                     // 巨兽堡垒
  ElderwoodShade,               // 古木荫地
  ElderwoodWharf,               // 巨森码头
  ForestOfSlumber,              // 安眠之林
  ForgottenStreet,              // 遗忘旧街
  GiantVineForest,              // 遗忘旧街
  LeafRiver,                    // 叶子河
  MothershroomWoods,            // 母菇林地
  ParkyaCraterLake,             // 帕克亚火山湖
  Pottsville,                   /// 陶罐村
  RockvilleRuins,               // 岩村遗址
  ShellIsland,                  // 壳壳岛
  Shroomville,                  // 菇菇聚落
  SnailRanch,                   // 蜗牛农场
  SpiraWaterfall,               // 蜗牛城瀑布
  TitanGraveyard,               /// 大拉姆居落
  TitansOutpostRuins,           /// 叶子河

  /// # Region::Spira
  Spira1F,                      // 蜗牛城一层
  Spira2F,                      // 蜗牛城二层
  Spira3F,                      // 蜗牛城三层
  SpiraShelldome,               // 蜗牛城壳顶

  /// # Region::Boneyard
  BluePools,                    /// 蓝池
  Cultivarium,                  /// 修习所
  DragonRuins,                  /// 龙埙遗所
  DragonrestFlowerfield,
  GlimmeringLake,
  GreatLumieville,
  HealingGround,
  HollowbreathPassage,          /// 幽息廊道
  LonestoneShore,               /// 孤石滩
  SoulSpring,                   /// 甜泉

  /// # Region::WanxiangRealm
  WanxiangRealm_BackMountain,   // 后山
  CaiYeMarket,                  // 彩靥城集市
  CaiYeOutskirts,               // 彩靥城近郊
  DazzlebloomMeadow,            // 迷花甸
  DeepValleySpring,             // 深谷幽泉
  JiuhuaPavilion,               // 九华阙
  JiuhuaPenitentiary,           // 九华监
  ValleyPath,                   // 峡谷山径
  WhereWoodEchoes,              // 悲木空鸣地

  /// # Dimension::SeaOfStars
  Crystalvale,                  // 晶簇之谷
  DreamStarIsles,               // 梦幻星岛
  Starshore,                    // 繁星之滨
  UnboundWharf,                 // 无界码头

  /// # Dimension::Home
  DockArea,
}