import "package:win32/win32.dart";
import "package:win32_registry/win32_registry.dart";



/// 布局方式
enum LayoutMethod{
  masonry("layout_masonry"),
  grid_1_1("layout_grid_1_1"),
  grid_16_9("layout_grid_16_9"),
  ;

  final String name;
  const LayoutMethod(this.name);

  static LayoutMethod? fromName(String name){
    return LayoutMethod.values.cast<LayoutMethod?>().firstWhere(
          (e) => e!.name == name,
      orElse: () => null,
    );
  }
}

/// 分类方式
enum ClassificationMethod{
  none("classification_none"),
  timeChanged("classification_timeChanged"),
  timeModified("classification_timeModified"),
  timeFileName("classification_timeFileName"),
  orientation("classification_orientation"),  // Landscape, Portrait or Square
  aspectRatio("classification_aspectRatio"),
  ;

  final String name;
  const ClassificationMethod(this.name);

  static ClassificationMethod? fromName(String name){
    return ClassificationMethod.values.cast<ClassificationMethod?>().firstWhere(
          (e) => e!.name == name,
      orElse: () => null,
    );
  }
}

/// 排序依据
enum SortKey{
  timeChanged("sortKey_timeChanged"),
  timeModified("sortKey_timeModified"),
  timeFileName("sortKey_timeFileName"),
  fileName("sortKey_fileName"),
  fileSize("sortKey_fileSize"),
  imageResolution("sortKey_imageResolution"),
  ;

  final String name;
  const SortKey(this.name);

  static SortKey? fromName(String name){
    return SortKey.values.cast<SortKey?>().firstWhere(
          (e) => e!.name == name,
      orElse: () => null,
    );
  }
}
/// 排序顺序
enum SortOrder{
  ascending("sortOrder_ascending"),
  descending("sortOrder_descending")
  ;
  final String name;
  const SortOrder(this.name);

  static SortOrder? fromName(String name){
    return SortOrder.values.cast<SortOrder?>().firstWhere(
          (e) => e!.name == name,
      orElse: () => null,
    );
  }
}


enum VersionType{
  paper("paper"),
  taptap("taptap"),
  bilibili("bilibili"),
  steam("steam"),
  other("other"),
  ;

  final String name;
  const VersionType(this.name);

  static VersionType? fromName(String name){
    return VersionType.values.cast<VersionType?>().firstWhere(
          (e) => e!.name == name,
      orElse: () => null,
    );
  }
}

const String INAppDataPath = r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher";

/// 无限暖暖Windows注册表信息
const windowsRegistryPaths = [
  // 官网版本 值为?\InfinityNikki Launcher\launcher.exe, (install在?\InfinityNikki Launcher\InfinityNikki)
  {
    "version": VersionType.paper,
    "hive": RegistryHive.localMachine,
    "path": r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
    "key": "DisplayIcon",
    "locateToRoot": r"\..",
    "locateToInstall": r"\InfinityNikki",
  },
  // TapTap版本 值为?\TapTap\PC Games\InfinityNikki, install在?TapTap\PC Games\InfinityNikki\InfinityNikki Launcher\InfinityNikki
  {
    "version": VersionType.taptap,
    "hive": RegistryHive.localMachine,
    "path": r"SOFTWARE\TapTap\Games\247283",
    "key": "InstallPath",
    "locateToRoot": r"\InfinityNikki Launcher",
    "locateToInstall": r"\InfinityNikki Launcher\InfinityNikki",
  },
  // bilibili版本 值为?\InfinityNikkiBili Launcher, install在?InfinityNikkiBili Launcher\InfinityNikki
  {
    "version": VersionType.bilibili,
    "hive": RegistryHive.localMachine,
    "path": r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiBili Launcher",
    "key": "InstallPath",
    "locateToRoot": r"",
    "locateToInstall": r"\InfinityNikki",
  },
  // steam版本 值为?\steam\steamapps\common\Infinity Nikki, install在?\steam\steamapps\common\Infinity Nikki\InfinityNikki
  {
    "version": VersionType.steam,
    "hive": RegistryHive.localMachine,
    "path": r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 3164330",
    "key": "InstallLocation",
    "locateToRoot": r"",
    "locateToInstall": r"\InfinityNikki",
  },
  //epic

  //inc
];

/// 无限暖暖Android应用包名
const androidPackages = [
  // 官网版本
  {
    "version": "paper",
    "package": "com.papegames.infinitynikki",
    "locate": 2,
    "locateToInstall": r"/files/UnrealGame",
  },
  // bilibili版本
  {
    "version": "bilibili",
    "package": "com.papegames.infinitynikki.bilibili",
    "locate": 2,
    "locateToInstall": r"/files/UnrealGame",
  },
];


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
  ScreenShot,
  XSdkQrCode,
}
/// RootType 无限暖暖根目录路径
/// - [launcher] 启动器根目录
/// - [install] 游戏下载根目录
/// - [appData] 官网启动器配置目录 C:\Users\$USERNAME$\AppData\Local\InfinityNikki Launcher
enum RootType{
  launcher,
  install,
  appData,
}
/// AlbumPermission 相册权限
/// - [none] 无权限
///  - [onlyView] 仅看
///  - [onlyBackup] 仅备份(禁止更改、禁止编辑)
///  - [notChange] 禁止更改(替换, 转移, 删除)
///  - [notImport] 禁止导入
///  - [all] 所有
enum AlbumPermission{
  none,
  onlyView,
  onlyBackup,
  notChange,
  notImport,
  all,
}
/// Collection类型
/// - [root] 只显示根目录
/// - [merge] 将所有 Collection 合并到根目录
/// - [all] 保留 Collection
enum AlbumCollection{
  root,
  merge,
  all,
}
/// 相册信息
/// [AlbumsPathItem] item
/// - [type] 相册类型
/// - [name] 相册名字
/// - [description] 相册介绍
/// - [permission] 相册权限
/// - [rootType] 相册路径(根类型)
/// - [isRequireUid] 否需要uid来查询相册
/// - [locate] 相册路径(根的相对路径)
/// - [backupPath] 相册备份路径
/// - [gameCollection] 游戏相册目录子目录的处理方式
/// - [backupCollection] 备份相册目录子目录的处理方式
class AlbumsInfoItem{
  final String type;
  final String name;
  final String description;
  final AlbumPermission permission;
  final RootType rootType;
  final bool isRequireUid;
  final String locate;
  final String backupPath;
  final AlbumCollection gameCollection;
  final AlbumCollection backupCollection;

  const AlbumsInfoItem({
    required this.type,
    required this.name,
    required this.description,
    required this.permission,
    required this.rootType,
    required this.isRequireUid,
    required this.locate,
    required this.backupPath,
    required this.gameCollection,
    required this.backupCollection,
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
    name: "NikkiPhotos_HighQualityName",
    description: "NikkiPhotos_HighQualityDescription",
    permission: AlbumPermission.all,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_HighQuality",
    backupPath: r"\$version$\$uid$\NikkiPhotos",
    gameCollection: AlbumCollection.root,
    backupCollection: AlbumCollection.all,
  ),
  // 大喵相册缩略图 无云端 删除后只要NikkiPhotos_HighQuality存在 就会重新生成 每次进入相册会把HighQuality没有的缩略图的自动生成
  // 若只有LowQuality 没有HighQuality, 就会删除该图像文件
  AlbumType.NikkiPhotos_LowQuality: AlbumsInfoItem(
    type: "NikkiPhotos_LowQuality",
    name: "NikkiPhotos_LowQualityName",
    description: "NikkiPhotos_LowQualityDescription",
    permission: AlbumPermission.none,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_LowQuality",
    backupPath: r"\$version$\$uid$\NikkiPhotos_Thumbnail",
    gameCollection: AlbumCollection.root,
    backupCollection: AlbumCollection.all,
  ),
  // 旅行手账 删了游戏内显示的是初始的/官方默认 与世界巡游照片同理
  AlbumType.MagazinePhotos: AlbumsInfoItem(
    type: "MagazinePhotos",
    name: "MagazinePhotosName",
    description: "MagazinePhotosDescription",
    permission: AlbumPermission.all,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\GamePlayPhotos\$uid$\MagazinePhotos",
    backupPath: r"\$version$\$uid$\MagazinePhotos",
    gameCollection: AlbumCollection.root,
    backupCollection: AlbumCollection.all,
  ),
  // 世界巡游照片 没有云端 删除后游戏内有图片损坏的图案 显示官方默认照片"这张是大喵拍摄的备用照片哦~"
  AlbumType.ClockInPhoto: AlbumsInfoItem(
    type: "ClockInPhoto",
    name: "ClockInPhotoName",
    description: "ClockInPhotoDescription",
    permission: AlbumPermission.all,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\GamePlayPhotos\$uid$\ClockInPhoto",
    backupPath: r"\$version$\$uid$\ClockInPhoto",
    gameCollection: AlbumCollection.root,
    backupCollection: AlbumCollection.all,
  ),
  // 使用过的头像
  AlbumType.CustomAvatar: AlbumsInfoItem(
    type: "CustomAvatar",
    name: "CustomAvatarName",
    description: "CustomAvatarDescription",
    permission: AlbumPermission.notImport,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\CustomAvatar\$uid$",
    backupPath: r"\$version$\$uid$\CustomAvatar",
    gameCollection: AlbumCollection.merge,
    backupCollection: AlbumCollection.all,
  ),
  // 使用过的名片 有云端 删除名片后不会删除本地照片
  // 图像文件后会下缩略图(1k?)到GamePlayPhotos\uid\CloudPhotos\temp
  // 还原图像文件后仍使用Cloud的图像
  // 删除名片后GamePlayPhotos\uid\CloudPhotos\temp的不会删除(若有)
  AlbumType.CustomCard: AlbumsInfoItem(
    type: "CustomCard",
    name: "CustomCardName",
    description: "CustomCardDescription",
    permission: AlbumPermission.notImport,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\CustomCard\$uid$",
    backupPath: r"\$version$\$uid$\CustomCard",
    gameCollection: AlbumCollection.merge,
    backupCollection: AlbumCollection.all,
  ),
  // 从染色分享保存到星绘图册的图片, 只会保留最新的一张
  AlbumType.DIY: AlbumsInfoItem(
    type: "DIY",
    name: "DIYName",
    description: "DIYDescription",
    permission: AlbumPermission.notImport,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\DIY\$uid$",
    backupPath: r"\$version$\$uid$\DIY",
    gameCollection: AlbumCollection.merge,
    backupCollection: AlbumCollection.all,
  ),
  AlbumType.CloudPhotos: AlbumsInfoItem(
    type: "CloudPhotos",
    name: "CloudPhotosName",
    description: "CloudPhotosDescription",
    permission: AlbumPermission.all,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos",
    backupPath: r"\$version$\$uid$\CloudPhotos",
    gameCollection: AlbumCollection.merge,
    backupCollection: AlbumCollection.all,
  ),
  AlbumType.CloudPhotos_LowQuality: AlbumsInfoItem(
    type: "CloudPhotos_LowQuality",
    name: "CloudPhotos_LowQualityName",
    description: "CloudPhotos_LowQualityDescription",
    permission: AlbumPermission.notImport,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos_LowQuality",
    backupPath: r"\$version$\$uid$\CloudPhotos_LowQuality",
    gameCollection: AlbumCollection.merge,
    backupCollection: AlbumCollection.all,
  ),
  // 家园路牌封面图片
  AlbumType.CustomHomeBoardPhoto: AlbumsInfoItem(
    type: "CustomHomeBoardPhoto",
    name: "CustomHomeBoardPhotoName",
    description: "CustomHomeBoardPhotoDescription",
    permission: AlbumPermission.all,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\CustomHomeBoardPhoto\$uid$",
    backupPath: r"\$version$\$uid$\CustomHomeBoardPhoto",
    gameCollection: AlbumCollection.merge,
    backupCollection: AlbumCollection.all,
  ),
  // 家园模板封面图片
  AlbumType.HomeTemplatePhoto: AlbumsInfoItem(
    type: "HomeTemplatePhoto",
    name: "HomeTemplatePhotoName",
    description: "HomeTemplatePhotoDescription",
    permission: AlbumPermission.all,
    rootType: RootType.install,
    isRequireUid: true,
    locate: r"\X6Game\Saved\HomeTemplate\$uid$",
    backupPath: r"\$version$\$uid$\HomeTemplate",
    gameCollection: AlbumCollection.merge,
    backupCollection: AlbumCollection.all,
  ),
  // 启动器图像缓存, paper启动器的位于C:\Users\用户名\AppData\Local\InfinityNikki Launcher\cache\images
  // AlbumType.LauncherImagesCache: {
  //   "type": "launcherImagesCache",
  //   "name": "LauncherImagesCacheName",
  //   "description": "launcherImagesCacheDescription",
  //   "permission": AlbumPermission.onlyBackup,
  //   "rootType": RootType.appData,
  //   "isRequireUid": true,
  //   "locate": r"\X6Game\Saved\HomeTemplate\$uid$",
  //   "backupPath": r"\$version$\$uid$\HomeTemplate",
  //   "gameCollection": AlbumCollection,
  //   "backupCollection": AlbumCollection,
  // },
  // 分享码
  AlbumType.XSdkQrCode: AlbumsInfoItem(
    type: "XSdkQrCode",
    name: "XSdkQrCodeName",
    description: "XSdkQrCodeDescription",
    permission: AlbumPermission.notImport,
    rootType: RootType.install,
    isRequireUid: false,
    locate: r"\X6Game\Saved\XSdkQrCode",
    backupPath: r"\$version$\XSdkQrCode",
    gameCollection: AlbumCollection.merge,
    backupCollection: AlbumCollection.all,
  ),
  // AlbumType.MallPic: {
  //   "type": "MallPic",
  //   "name": "MallPicName",
  //   "description": "MallPicDescription",
  //   "permission": AlbumPermission.notChange,
  //   "rootType": RootType.install,
  //   "isRequireUid": false,
  //   "locate": r"\X6Game\ScreenShot",
  //   "backupPath": r"\$version$\ScreenShot",
  //   "gameCollection": AlbumCollection,
  //   "backupCollection": AlbumCollection,
  // },
  AlbumType.ScreenShot: AlbumsInfoItem(
    type: "ScreenShot",
    name: "ScreenShotName",
    description: "ScreenShotDescription",
    permission: AlbumPermission.all,
    rootType: RootType.install,
    isRequireUid: false,
    locate: r"\X6Game\ScreenShot",
    backupPath: r"\$version$\ScreenShot",
    gameCollection: AlbumCollection.all,
    backupCollection: AlbumCollection.all,
  ),
};



/// api地址
const apiUrl = r"https://raw.githubusercontent.com/ranaxro/nikki_albums/main/api.json";