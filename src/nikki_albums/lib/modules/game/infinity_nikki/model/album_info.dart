import "album_type.dart";
import "package:nikki_albums/modules/app_base/model/platform.dart";

/// 相册信息
/// [AlbumsInfoItem] item
/// - [insignificance] 不重要
/// - [visible] 是否允许用户查看此相册
/// - [isRequireUid] 否需要uid来查询相册
/// - [locateInGame] 相册路径(根的相对路径)
/// - [locateInBackup] 相册备份路径. 若为 null, 则没有移出与移入功能
/// - [locateInRecycleBin] 相册回收站路径. 若为 null, 在删除图像文件时会直接删除
/// - [recursionDepth] 递归遍历文件夹的深度, 从 0 开始计数
/// - [chainDeletion] 仅在windows可用 连锁删除: 当删除该相册的图片时, 是否同时删除其他相册(位于 chainDeletion.keys)的相同图片. chainDeletion.values决定默认行为
///                     isRequireUid = false 的相册不能删除 isRequireUid = true 的相册
/// - [supportedPlatforms] 支持的平台
class AlbumInfo{
  final bool insignificance;
  final bool visible;
  final bool isRequireUid;
  final String locateInGame;
  final String? locateInBackup;
  final String locateInRecycleBin;
  final int recursionDepth;
  final Map<AlbumType, bool> chainDeletion;
  final Platform supportedPlatforms;

  const AlbumInfo({
    required this.insignificance,
    required this.visible,
    required this.isRequireUid,
    required this.locateInGame,
    required this.locateInBackup,
    required this.locateInRecycleBin,
    required this.recursionDepth,
    required this.chainDeletion,
    required this.supportedPlatforms,
  });
}

const Map<AlbumType, AlbumInfo> albumInfos = {
  // 大喵相册高清图 无云端 拍照后保存到这(不会保存到LowQuality, 直到进入相册)
  // 游戏运行时 移动后点击图片会显示"图片错误" 然后从相册消失 同时把NikkiPhotos_LowQuality的同照片也删除
  // 游戏运行时 移入图片后要重进游戏或重登游戏才会显示
  // 不能导入不存在过的图像文件 游戏根据文件二进制识别是否存在
  // 留影照片有云端 删除后会下载到\CloudPhotos 与\CloudPhotos_LowQuality(1K?缩略图)  从相册删除会把这两张照片照片分别移动到HighQuality、LowQuality但不显示 重启后才显示
  AlbumType.nikkiPhotosHighQuality: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_HighQuality",
    locateInBackup: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiAlbums_NikkiPhotos",
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\NikkiPhotos_HighQuality\$uid$",
    recursionDepth: 0,
    chainDeletion: {
      AlbumType.nikkiPhotosLowQuality: true,
      AlbumType.screenShot: true,
      AlbumType.magazinePhotos: false,
      AlbumType.clockInPhoto: false,
      AlbumType.collageCollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 大喵相册缩略图 无云端 删除后只要NikkiPhotos_HighQuality存在 就会重新生成 每次进入相册会把HighQuality没有的缩略图的自动生成
  // 若只有LowQuality 没有HighQuality, 就会删除该图像文件
  AlbumType.nikkiPhotosLowQuality: AlbumInfo(
    insignificance: false,
    visible: false,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_LowQuality",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\NikkiPhotos_LowQuality\$uid$",
    recursionDepth: 0,
    chainDeletion: {
      AlbumType.nikkiPhotosHighQuality: false,
      AlbumType.screenShot: false,
      AlbumType.magazinePhotos: false,
      AlbumType.clockInPhoto: false,
      AlbumType.collageCollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 旅行手账 删了游戏内显示的是初始的/官方默认 与世界巡游照片同理
  AlbumType.magazinePhotos: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\MagazinePhotos",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\MagazinePhotos\$uid$",
    recursionDepth: 0,
    chainDeletion: {
      AlbumType.nikkiPhotosHighQuality: false,
      AlbumType.nikkiPhotosLowQuality: false,
      AlbumType.screenShot: false,
      AlbumType.clockInPhoto: false,
      AlbumType.collageCollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 世界巡游照片 没有云端 删除后游戏内有图片损坏的图案 显示官方默认照片"这张是大喵拍摄的备用照片哦~"
  AlbumType.clockInPhoto: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\ClockInPhoto",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\ClockInPhoto\$uid$",
    recursionDepth: 0,
    chainDeletion: {
      AlbumType.nikkiPhotosHighQuality: false,
      AlbumType.nikkiPhotosLowQuality: false,
      AlbumType.screenShot: false,
      AlbumType.magazinePhotos: false,
      AlbumType.collageCollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 趣拼海报
  AlbumType.collageHighQuality: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\Collage\HighQuality",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\Collage_HighQuality\$uid$",
    recursionDepth: 0,
    chainDeletion: {
      AlbumType.collageLowQuality: true
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 趣拼海报缩略图
  AlbumType.collageLowQuality: AlbumInfo(
    insignificance: false,
    visible: false,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\Collage\LowQuality",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\Collage_LowQuality\$uid$",
    recursionDepth: 0,
    chainDeletion: {
      AlbumType.collageLowQuality: false
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 趣拼海报原图
  AlbumType.collageCollagePhoto: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\Collage\CollagePhoto",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\Collage_CollagePhoto\$uid$",
    recursionDepth: 0,
    chainDeletion: {
      AlbumType.nikkiPhotosHighQuality: false,
      AlbumType.nikkiPhotosLowQuality: false,
      AlbumType.screenShot: false,
      AlbumType.magazinePhotos: false,
      AlbumType.clockInPhoto: false,
      AlbumType.collageCollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 使用过的头像
  AlbumType.customAvatar: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\CustomAvatar\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CustomAvatar\$uid$",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 使用过的名片 有云端 删除名片后不会删除本地照片
  // 图像文件后会下缩略图(1k?)到GamePlayPhotos\uid\CloudPhotos\temp
  // 还原图像文件后仍使用Cloud的图像
  // 删除名片后GamePlayPhotos\uid\CloudPhotos\temp的不会删除(若有)
  AlbumType.customCard: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\CustomCard\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CustomCard\$uid$",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  AlbumType.plantDyeing: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: false,
    locateInGame: r"\X6Game\Saved\PlantDyeing",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\PlantDyeing",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 从染色分享保存到星绘图册的图片, 只会保留最新的一张
  AlbumType.diy: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\DIY\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\DIY\$uid$",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  AlbumType.cloudPhotos: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CloudPhotos\$uid$",
    recursionDepth: 1,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  AlbumType.cloudPhotosLowQuality: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos_LowQuality",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CloudPhotos_LowQuality\$uid$",
    recursionDepth: 1,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 家园路牌封面图片
  AlbumType.customHomeBoardPhoto: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\CustomHomeBoardPhoto\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CustomHomeBoardPhoto\$uid$",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 家园模板封面图片
  AlbumType.homeTemplatePhoto: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\HomeTemplate\$uid$",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\HomeTemplatePhoto\$uid$",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 分享码
  AlbumType.xSdkQrCode: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: false,
    locateInGame: r"\X6Game\Saved\XSdkQrCode",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\XSdkQrCode",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  AlbumType.screenShot: AlbumInfo(
    insignificance: false,
    visible: true,
    isRequireUid: false,
    locateInGame: r"\X6Game\ScreenShot",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\ScreenShot",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.windows,
  ),

  /// insignificance
  AlbumType.accountAvatar: AlbumInfo(
    insignificance: true,
    visible: true,
    isRequireUid: false,
    locateInGame: r"\X6Game\Saved\PaperCache",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\AccountAvatar",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.windows,
  ),
  AlbumType.biologicalInvestigation: AlbumInfo(
    insignificance: true,
    visible: true,
    isRequireUid: false,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\108328049\Biologicalinvestigation",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\Biologicalinvestigation",
    recursionDepth: 0,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.windows,
  ),
  AlbumType.editorPhoto: AlbumInfo(
    insignificance: true,
    visible: true,
    isRequireUid: false,
    locateInGame: r"\X6Game\Saved\EditorPhoto",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\EditorPhoto",
    recursionDepth: 2,
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.windows,
  ),
};