import "dart:io";

import "package:flutter/foundation.dart";
import "package:win32_registry/win32_registry.dart";

const int version = 6;
const String versionString = "3.03";
const String appName = "nikkialbums";
const String appDefaultClassName = "FLUTTER_RUNNER_WIN32_WINDOW";
const String appClassName = "RANAXRO_NIKKI_ALBUMS_WIN32_WINDOW";
const String appWindowName = "Nikki Albums";

const int ipcPort = 12061;
const int udpPort = 12060;
const Duration udpBroadcastFrequency = Duration(milliseconds: 200);

const String officialWebsite = r"nikki.ranaxro.com";
const String apiUrl = "https://nikki.ranaxro.com/api.json";
const String githubWebsite = r"github.com/RanAxro/nikki_albums";
const String qqGroup = r"1062670402";



const int inWindows = 1 << 0;
const int inAndroid = 1 << 1;
const int inIos = 1 << 2;
const int inAllPlatforms = inWindows | inAndroid | inIos;
extension PlatformBits on int{
  bool get canRunPlatform{
    if(kIsWeb) return false;
    if(Platform.isWindows) return this & inWindows != 0;
    if(Platform.isAndroid) return this & inAndroid != 0;
    if(Platform.isIOS) return this & inIos != 0;
    return false;
  }
}



enum LauncherChannel{
  unknown,
  paper,
  taptap,
  bilibili,
  steam,
  ;

  static LauncherChannel from(dynamic value){
    return LauncherChannel.values.firstWhere(
      (e) => e.name == value,
      orElse: () => LauncherChannel.unknown,
    );
  }
}



abstract class LocateToInfinityNikkiInfo{
  final String locateToLauncher;
  final String locateToInstall;

  const LocateToInfinityNikkiInfo({
    required this.locateToLauncher,
    required this.locateToInstall,
  });
}
class WindowsRegistryInfo extends LocateToInfinityNikkiInfo{
  final RegistryHive hive;
  final String path;
  final String key;
  final String? configPath;

  const WindowsRegistryInfo({
    required super.locateToLauncher,
    required super.locateToInstall,
    required this.hive,
    required this.path,
    required this.key,
    this.configPath,
  });
}
class AndroidApplicationIdInfo extends LocateToInfinityNikkiInfo{
  final String applicationId;
  final int appData;

  const AndroidApplicationIdInfo({
    required super.locateToLauncher,
    required super.locateToInstall,
    required this.applicationId,
    required this.appData,
  });
}
class InfinityNikkiInfo{
  final LauncherChannel channel;
  final List<WindowsRegistryInfo> locateByWindowsRegistry;
  final List<AndroidApplicationIdInfo> locateByAndroidApplicationId;

  const InfinityNikkiInfo({
    required this.channel,
    required this.locateByWindowsRegistry,
    required this.locateByAndroidApplicationId,
  });
}

const List<InfinityNikkiInfo> infinityNikkiInfos = [
  InfinityNikkiInfo(
    channel: LauncherChannel.paper,
    locateByWindowsRegistry: [
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
        key: "DisplayIcon",
        locateToLauncher: r"\..",
        locateToInstall: r"\InfinityNikki",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      ),
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
        key: "UninstallString",
        locateToLauncher: r"\..",
        locateToInstall: r"\InfinityNikki",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      ),
    ],
    locateByAndroidApplicationId: [
      AndroidApplicationIdInfo(
        locateToLauncher: r"com.papegames.infinitynikki",
        applicationId: r"com.papegames.infinitynikki",
        appData: 2,
        locateToInstall: r"/files/UnrealGame/X6Game",
      ),
    ],
  ),
  InfinityNikkiInfo(
    channel: LauncherChannel.taptap,
    locateByWindowsRegistry: [
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\TapTap\Games\247283",
        key: "InstallPath",
        locateToLauncher: r"\InfinityNikki Launcher",
        locateToInstall: r"\InfinityNikki Launcher\InfinityNikki",
      ),
    ],
    locateByAndroidApplicationId: [],
  ),
  InfinityNikkiInfo(
    channel: LauncherChannel.bilibili,
    locateByWindowsRegistry: [
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiBili Launcher",
        key: "InstallPath",
        locateToLauncher: r"",
        locateToInstall: r"\InfinityNikki",
      ),
    ],
    locateByAndroidApplicationId: [
      AndroidApplicationIdInfo(
        locateToLauncher: r"com.papegames.infinitynikki.bilibili",
        applicationId: r"com.papegames.infinitynikki.bilibili",
        appData: 2,
        locateToInstall: r"/files/UnrealGame/X6Game",
      ),
    ],
  ),
  InfinityNikkiInfo(
    channel: LauncherChannel.steam,
    locateByWindowsRegistry: [
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 3164330",
        key: "InstallLocation",
        locateToLauncher: r"",
        locateToInstall: r"\InfinityNikki",
      ),
    ],
    locateByAndroidApplicationId: [],
  ),
];

// const String gameWindowsAppDataPath = r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher";

// /// 无限暖暖Windows注册表信息
// const List<Map<String, dynamic>> gameWindowsRegistryPaths = [
//   // 官网版本 值为?\InfinityNikki Launcher\launcher.exe, (install在?\InfinityNikki Launcher\InfinityNikki)
//   {
//     "channel": LauncherChannel.paper,
//     "hive": RegistryHive.localMachine,
//     "path": r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
//     "key": "DisplayIcon",
//     "locateToLauncher": r"\..",
//     "locateToInstall": r"\InfinityNikki",
//   },
//   // 官网版本 值为?\InfinityNikki Launcher\uninst.exe, (install在?\InfinityNikki Launcher\InfinityNikki)
//   {
//     "channel": LauncherChannel.paper,
//     "hive": RegistryHive.localMachine,
//     "path": r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
//     "key": "UninstallString",
//     "locateToLauncher": r"\..",
//     "locateToInstall": r"\InfinityNikki",
//   },
//   // TapTap版本 值为?\TapTap\PC Games\InfinityNikki, install在?TapTap\PC Games\InfinityNikki\InfinityNikki Launcher\InfinityNikki
//   {
//     "channel": LauncherChannel.taptap,
//     "hive": RegistryHive.localMachine,
//     "path": r"SOFTWARE\TapTap\Games\247283",
//     "key": "InstallPath",
//     "locateToLauncher": r"\InfinityNikki Launcher",
//     "locateToInstall": r"\InfinityNikki Launcher\InfinityNikki",
//   },
//   // bilibili版本 值为?\InfinityNikkiBili Launcher, install在?InfinityNikkiBili Launcher\InfinityNikki
//   {
//     "channel": LauncherChannel.bilibili,
//     "hive": RegistryHive.localMachine,
//     "path": r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiBili Launcher",
//     "key": "InstallPath",
//     "locateToLauncher": r"",
//     "locateToInstall": r"\InfinityNikki",
//   },
//   // steam版本 值为?\steam\steamapps\common\Infinity Nikki, install在?\steam\steamapps\common\Infinity Nikki\InfinityNikki
//   {
//     "channel": LauncherChannel.steam,
//     "hive": RegistryHive.localMachine,
//     "path": r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 3164330",
//     "key": "InstallLocation",
//     "locateToLauncher": r"",
//     "locateToInstall": r"\InfinityNikki",
//   },
//   //epic
//
//   //inc
// ];
//
//
// /// 无限暖暖Android应用包名
// const List<Map<String, dynamic>> androidPackages = [
//   // 官网版本
//   {
//     "channel": LauncherChannel.paper,
//     "package": "com.papegames.infinitynikki",
//     "locate": 2,
//     "locateToInstall": r"/files/UnrealGame",
//   },
//   // bilibili版本
//   {
//     "channel": LauncherChannel.bilibili,
//     "package": "com.papegames.infinitynikki.bilibili",
//     "locate": 2,
//     "locateToInstall": r"/files/UnrealGame",
//   },
// ];







const AlbumType defaultAlbumTypeWithUid = AlbumType.NikkiPhotos_HighQuality;
const AlbumType defaultAlbumTypeWithoutUid = AlbumType.ScreenShot;
/// AlbumType 相册类型
enum AlbumType{
  ClockInPhoto,
  CloudPhotos_LowQuality,
  CloudPhotos,
  CustomAvatar,
  CustomCard,
  CustomHomeBoardPhoto,
  DIY,
  HomeTemplatePhoto,
  // LauncherImagesCache,
  MagazinePhotos,
  // MallPic,
  NikkiPhotos_HighQuality,
  NikkiPhotos_LowQuality,
  PlantDyeing,
  ScreenShot,
  XSdkQrCode,
  ;

  static AlbumType from(dynamic value){
    return AlbumType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AlbumType.ScreenShot,
    );
  }

  static AlbumType? fromStrictly(dynamic value){
    return AlbumType.values.where((e) => e.name == value).firstOrNull;
  }
}
/// 相册信息
/// [AlbumsPathItem] item
/// - [type] 相册类型
/// - [visible] 是否允许用户查看此相册
/// - [name] 相册名字
/// - [description] 相册介绍
/// - [isRequireUid] 否需要uid来查询相册
/// - [locateInGame] 相册路径(根的相对路径)
/// - [locateInBackup] 相册备份路径. 若为 null, 则没有移出与移入功能
/// - [locateInRecycleBin] 相册回收站路径. 若为 null, 在删除图像文件时会直接删除
/// - [chainDeletion] 仅在windows可用 连锁删除: 当删除该相册的图片时, 是否同时删除其他相册(位于 chainDeletion.keys)的相同图片. chainDeletion.values决定默认行为
///                     isRequireUid = false 的相册不能删除 isRequireUid = true 的相册
/// - [supportedPlatforms] 支持的平台
class AlbumsInfoItem{
  final String type;
  final bool visible;
  final String name;
  final String description;
  final bool isRequireUid;
  final String locateInGame;
  final String? locateInBackup;
  final String locateInRecycleBin;
  final Map<AlbumType, bool> chainDeletion;
  /// TODO
  // final bool worthBackup;
  final int supportedPlatforms;

  const AlbumsInfoItem({
    required this.type,
    required this.visible,
    required this.name,
    required this.description,
    required this.isRequireUid,
    required this.locateInGame,
    required this.locateInBackup,
    required this.locateInRecycleBin,
    required this.chainDeletion,
    required this.supportedPlatforms,
  });
}
const Map<AlbumType, AlbumsInfoItem> albumsInfoMap = {
  // 大喵相册高清图 无云端 拍照后保存到这(不会保存到LowQuality, 直到进入相册)
  // 游戏运行时 移动后点击图片会显示"图片错误" 然后从相册消失 同时把NikkiPhotos_LowQuality的同照片也删除
  // 游戏运行时 移入图片后要重进游戏或重登游戏才会显示
  // 不能导入不存在过的图像文件 游戏根据文件二进制识别是否存在
  // 留影照片有云端 删除后会下载到\CloudPhotos 与\CloudPhotos_LowQuality(1K?缩略图)  从相册删除会把这两张照片照片分别移动到HighQuality、LowQuality但不显示 重启后才显示
  AlbumType.NikkiPhotos_HighQuality: AlbumsInfoItem(
    type: "NikkiPhotos_HighQuality",
    visible: true,
    name: "NikkiPhotos_HighQualityName",
    description: "NikkiPhotos_HighQualityDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_HighQuality",
    locateInBackup: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiAlbums_NikkiPhotos",
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\NikkiPhotos_HighQuality\$uid$",
    chainDeletion: {
      AlbumType.NikkiPhotos_LowQuality: true,
      AlbumType.ScreenShot: true,
      AlbumType.MagazinePhotos: false,
      AlbumType.ClockInPhoto: false,
    },
    supportedPlatforms: inWindows | inAndroid,
  ),
  // 大喵相册缩略图 无云端 删除后只要NikkiPhotos_HighQuality存在 就会重新生成 每次进入相册会把HighQuality没有的缩略图的自动生成
  // 若只有LowQuality 没有HighQuality, 就会删除该图像文件
  AlbumType.NikkiPhotos_LowQuality: AlbumsInfoItem(
    type: "NikkiPhotos_LowQuality",
    visible: false,
    name: "NikkiPhotos_LowQualityName",
    description: "NikkiPhotos_LowQualityDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_LowQuality",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\NikkiPhotos_LowQuality\$uid$",
    chainDeletion: {
      AlbumType.NikkiPhotos_HighQuality: true,
      AlbumType.ScreenShot: true,
      AlbumType.MagazinePhotos: false,
      AlbumType.ClockInPhoto: false,
    },
    supportedPlatforms: inWindows | inAndroid,
  ),
  // 旅行手账 删了游戏内显示的是初始的/官方默认 与世界巡游照片同理
  AlbumType.MagazinePhotos: AlbumsInfoItem(
    type: "MagazinePhotos",
    visible: true,
    name: "MagazinePhotosName",
    description: "MagazinePhotosDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\MagazinePhotos",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\MagazinePhotos\$uid$",
    chainDeletion: {
      AlbumType.NikkiPhotos_HighQuality: false,
      AlbumType.NikkiPhotos_LowQuality: false,
      AlbumType.ScreenShot: false,
      AlbumType.ClockInPhoto: false,
    },
    supportedPlatforms: inWindows | inAndroid,
  ),
  // 世界巡游照片 没有云端 删除后游戏内有图片损坏的图案 显示官方默认照片"这张是大喵拍摄的备用照片哦~"
  AlbumType.ClockInPhoto: AlbumsInfoItem(
    type: "ClockInPhoto",
    visible: true,
    name: "ClockInPhotoName",
    description: "ClockInPhotoDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\ClockInPhoto",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\ClockInPhoto\$uid$",
    chainDeletion: {
      AlbumType.NikkiPhotos_HighQuality: false,
      AlbumType.NikkiPhotos_LowQuality: false,
      AlbumType.ScreenShot: false,
      AlbumType.MagazinePhotos: false,
    },
    supportedPlatforms: inWindows | inAndroid,
  ),
  // 使用过的头像
  AlbumType.CustomAvatar: AlbumsInfoItem(
    type: "CustomAvatar",
    visible: true,
    name: "CustomAvatarName",
    description: "CustomAvatarDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\CustomAvatar\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CustomAvatar\$uid$",
    chainDeletion: {},
    supportedPlatforms: inWindows | inAndroid,
  ),
  // 使用过的名片 有云端 删除名片后不会删除本地照片
  // 图像文件后会下缩略图(1k?)到GamePlayPhotos\uid\CloudPhotos\temp
  // 还原图像文件后仍使用Cloud的图像
  // 删除名片后GamePlayPhotos\uid\CloudPhotos\temp的不会删除(若有)
  AlbumType.CustomCard: AlbumsInfoItem(
    type: "CustomCard",
    visible: true,
    name: "CustomCardName",
    description: "CustomCardDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\CustomCard\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CustomCard\$uid$",
    chainDeletion: {},
    supportedPlatforms: inWindows | inAndroid,
  ),
  AlbumType.PlantDyeing: AlbumsInfoItem(
    type: "PlantDyeing",
    visible: true,
    name: "PlantDyeingName",
    description: "PlantDyeingDescription",
    isRequireUid: false,
    locateInGame: r"\X6Game\Saved\PlantDyeing",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\PlantDyeing",
    chainDeletion: {},
    supportedPlatforms: inWindows | inAndroid,
  ),
  // 从染色分享保存到星绘图册的图片, 只会保留最新的一张
  AlbumType.DIY: AlbumsInfoItem(
    type: "DIY",
    visible: true,
    name: "DIYName",
    description: "DIYDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\DIY\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\DIY\$uid$",
    chainDeletion: {},
    supportedPlatforms: inWindows | inAndroid,
  ),
  AlbumType.CloudPhotos: AlbumsInfoItem(
    type: "CloudPhotos",
    visible: true,
    name: "CloudPhotosName",
    description: "CloudPhotosDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CloudPhotos\$uid$",
    chainDeletion: {},
    supportedPlatforms: inWindows | inAndroid,
  ),
  AlbumType.CloudPhotos_LowQuality: AlbumsInfoItem(
    type: "CloudPhotos_LowQuality",
    visible: true,
    name: "CloudPhotos_LowQualityName",
    description: "CloudPhotos_LowQualityDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos_LowQuality",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CloudPhotos_LowQuality\$uid$",
    chainDeletion: {},
    supportedPlatforms: inWindows | inAndroid,
  ),
  // 家园路牌封面图片
  AlbumType.CustomHomeBoardPhoto: AlbumsInfoItem(
    type: "CustomHomeBoardPhoto",
    visible: true,
    name: "CustomHomeBoardPhotoName",
    description: "CustomHomeBoardPhotoDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\CustomHomeBoardPhoto\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CustomHomeBoardPhoto\$uid$",
    chainDeletion: {},
    supportedPlatforms: inWindows | inAndroid,
  ),
  // 家园模板封面图片
  AlbumType.HomeTemplatePhoto: AlbumsInfoItem(
    type: "HomeTemplatePhoto",
    visible: true,
    name: "HomeTemplatePhotoName",
    description: "HomeTemplatePhotoDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\HomeTemplate\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\HomeTemplatePhoto\$uid$",
    chainDeletion: {},
    supportedPlatforms: inWindows | inAndroid,
  ),
  // 分享码
  AlbumType.XSdkQrCode: AlbumsInfoItem(
    type: "XSdkQrCode",
    visible: true,
    name: "XSdkQrCodeName",
    description: "XSdkQrCodeDescription",
    isRequireUid: false,
    locateInGame: r"\X6Game\Saved\XSdkQrCode",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\XSdkQrCode",
    chainDeletion: {},
    supportedPlatforms: inWindows | inAndroid,
  ),
  AlbumType.ScreenShot: AlbumsInfoItem(
    type: "ScreenShot",
    visible: true,
    name: "ScreenShotName",
    description: "ScreenShotDescription",
    isRequireUid: false,
    locateInGame: r"\X6Game\ScreenShot",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\ScreenShot",
    chainDeletion: {},
    supportedPlatforms: inWindows,
  ),
};

const String locateToGamePlayPhotos = r"\X6Game\Saved\GamePlayPhotos";
const String locateToTag = r"\X6Game\Saved\nikkialbums_tag.json";
const String locateToRecycleBin = r"\X6Game\NikkiAlbumsRecycleBin";



enum ResourceType{
  LauncherCacheImages,
  MallPic,
  Movies,
}
class ResourceInfoItem{
  final String type;
  final String name;
  final String description;
  final bool isImage;
  final bool onlyWindows;
  final bool isRequireInstall;
  final String locate;

  const ResourceInfoItem({
    required this.type,
    required this.name,
    required this.description,
    required this.isImage,
    required this.onlyWindows,
    required this.isRequireInstall,
    required this.locate,
  });
}
const Map<ResourceType, ResourceInfoItem> resourcesInfoMap = {
  ResourceType.LauncherCacheImages: ResourceInfoItem(
    type: "LauncherCacheImages",
    name: "LauncherCacheImagesName",
    description: "LauncherCacheImagesDescription",
    isImage: true,
    onlyWindows: true,
    isRequireInstall: false,
    locate: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\cache\images",
  ),
  ResourceType.MallPic: ResourceInfoItem(
    type: "MallPic",
    name: "MallPicName",
    description: "MallPicDescription",
    isImage: true,
    onlyWindows: false,
    isRequireInstall: true,
    locate: r"\X6Game\Saved\MallPic",
  ),
  ResourceType.Movies: ResourceInfoItem(
    type: "Movies",
    name: "MoviesName",
    description: "MoviesDescription",
    isImage: false,
    onlyWindows: false,
    isRequireInstall: true,
    locate: r"\X6Game\Content\Movies",
  ),
};