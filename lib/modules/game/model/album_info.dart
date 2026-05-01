import "album_type.dart";
import "package:nikki_albums/modules/app_base/model/platform.dart";

/// 相册信息
/// [AlbumsInfoItem] item
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
class AlbumInfo{
  final String type;
  final bool visible;
  final String name;
  final String description;
  final bool isRequireUid;
  final String locateInGame;
  final String? locateInBackup;
  final String locateInRecycleBin;
  final Map<AlbumType, bool> chainDeletion;
  final Platform supportedPlatforms;

  const AlbumInfo({
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

const Map<AlbumType, AlbumInfo> albumInfos = {
  // 大喵相册高清图 无云端 拍照后保存到这(不会保存到LowQuality, 直到进入相册)
  // 游戏运行时 移动后点击图片会显示"图片错误" 然后从相册消失 同时把NikkiPhotos_LowQuality的同照片也删除
  // 游戏运行时 移入图片后要重进游戏或重登游戏才会显示
  // 不能导入不存在过的图像文件 游戏根据文件二进制识别是否存在
  // 留影照片有云端 删除后会下载到\CloudPhotos 与\CloudPhotos_LowQuality(1K?缩略图)  从相册删除会把这两张照片照片分别移动到HighQuality、LowQuality但不显示 重启后才显示
  AlbumType.NikkiPhotos_HighQuality: AlbumInfo(
    type: "NikkiPhotos_HighQuality",
    visible: true,
    name: "album_type.NikkiPhotos_HighQuality_name",
    description: "album_type.NikkiPhotos_HighQuality_description",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_HighQuality",
    locateInBackup: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiAlbums_NikkiPhotos",
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\NikkiPhotos_HighQuality\$uid$",
    chainDeletion: {
      AlbumType.NikkiPhotos_LowQuality: true,
      AlbumType.ScreenShot: true,
      AlbumType.MagazinePhotos: false,
      AlbumType.ClockInPhoto: false,
      AlbumType.Collage_CollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 大喵相册缩略图 无云端 删除后只要NikkiPhotos_HighQuality存在 就会重新生成 每次进入相册会把HighQuality没有的缩略图的自动生成
  // 若只有LowQuality 没有HighQuality, 就会删除该图像文件
  AlbumType.NikkiPhotos_LowQuality: AlbumInfo(
    type: "NikkiPhotos_LowQuality",
    visible: false,
    name: "album_type.NikkiPhotos_LowQualityName",
    description: "album_type.NikkiPhotos_LowQualityDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_LowQuality",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\NikkiPhotos_LowQuality\$uid$",
    chainDeletion: {
      AlbumType.NikkiPhotos_HighQuality: false,
      AlbumType.ScreenShot: false,
      AlbumType.MagazinePhotos: false,
      AlbumType.ClockInPhoto: false,
      AlbumType.Collage_CollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 旅行手账 删了游戏内显示的是初始的/官方默认 与世界巡游照片同理
  AlbumType.MagazinePhotos: AlbumInfo(
    type: "MagazinePhotos",
    visible: true,
    name: "album_type.MagazinePhotosName",
    description: "album_type.MagazinePhotosDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\MagazinePhotos",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\MagazinePhotos\$uid$",
    chainDeletion: {
      AlbumType.NikkiPhotos_HighQuality: false,
      AlbumType.NikkiPhotos_LowQuality: false,
      AlbumType.ScreenShot: false,
      AlbumType.ClockInPhoto: false,
      AlbumType.Collage_CollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 世界巡游照片 没有云端 删除后游戏内有图片损坏的图案 显示官方默认照片"这张是大喵拍摄的备用照片哦~"
  AlbumType.ClockInPhoto: AlbumInfo(
    type: "ClockInPhoto",
    visible: true,
    name: "album_type.ClockInPhotoName",
    description: "album_type.ClockInPhotoDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\ClockInPhoto",
    locateInBackup: null,
    locateInRecycleBin: r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\ClockInPhoto\$uid$",
    chainDeletion: {
      AlbumType.NikkiPhotos_HighQuality: false,
      AlbumType.NikkiPhotos_LowQuality: false,
      AlbumType.ScreenShot: false,
      AlbumType.MagazinePhotos: false,
      AlbumType.Collage_CollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 趣拼海报
  AlbumType.Collage_HighQuality: AlbumInfo(
    type: "Collage_HighQuality",
    visible: true,
    name: "album_type.Collage_HighQualityName",
    description: "album_type.Collage_HighQualityDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\Collage\HighQuality",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\Collage_HighQuality\$uid$",
    chainDeletion: {AlbumType.Collage_LowQuality: true},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 趣拼海报缩略图
  AlbumType.Collage_LowQuality: AlbumInfo(
    type: "Collage_LowQuality",
    visible: false,
    name: "album_type.Collage_LowQualityName",
    description: "album_type.Collage_LowQualityDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\Collage\LowQuality",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\Collage_LowQuality\$uid$",
    chainDeletion: {AlbumType.Collage_LowQuality: false},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 趣拼海报原图
  AlbumType.Collage_CollagePhoto: AlbumInfo(
    type: "Collage_CollagePhoto",
    visible: true,
    name: "album_type.Collage_CollagePhotoName",
    description: "album_type.Collage_CollagePhotoDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\Collage\CollagePhoto",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\Collage_CollagePhoto\$uid$",
    chainDeletion: {
      AlbumType.NikkiPhotos_HighQuality: false,
      AlbumType.NikkiPhotos_LowQuality: false,
      AlbumType.ScreenShot: false,
      AlbumType.MagazinePhotos: false,
      AlbumType.ClockInPhoto: false,
      AlbumType.Collage_CollagePhoto: false,
    },
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 使用过的头像
  AlbumType.CustomAvatar: AlbumInfo(
    type: "CustomAvatar",
    visible: true,
    name: "album_type.CustomAvatarName",
    description: "album_type.CustomAvatarDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\CustomAvatar\$uid$",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CustomAvatar\$uid$",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 使用过的名片 有云端 删除名片后不会删除本地照片
  // 图像文件后会下缩略图(1k?)到GamePlayPhotos\uid\CloudPhotos\temp
  // 还原图像文件后仍使用Cloud的图像
  // 删除名片后GamePlayPhotos\uid\CloudPhotos\temp的不会删除(若有)
  AlbumType.CustomCard: AlbumInfo(
    type: "CustomCard",
    visible: true,
    name: "album_type.CustomCardName",
    description: "album_type.CustomCardDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\CustomCard\$uid$",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CustomCard\$uid$",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  AlbumType.PlantDyeing: AlbumInfo(
    type: "PlantDyeing",
    visible: true,
    name: "album_type.PlantDyeingName",
    description: "album_type.PlantDyeingDescription",
    isRequireUid: false,
    locateInGame: r"\X6Game\Saved\PlantDyeing",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\PlantDyeing",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 从染色分享保存到星绘图册的图片, 只会保留最新的一张
  AlbumType.DIY: AlbumInfo(
    type: "DIY",
    visible: true,
    name: "album_type.DIYName",
    description: "album_type.DIYDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\DIY\$uid$",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\DIY\$uid$",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  AlbumType.CloudPhotos: AlbumInfo(
    type: "CloudPhotos",
    visible: true,
    name: "album_type.CloudPhotosName",
    description: "album_type.CloudPhotosDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CloudPhotos\$uid$",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  AlbumType.CloudPhotos_LowQuality: AlbumInfo(
    type: "CloudPhotos_LowQuality",
    visible: true,
    name: "album_type.CloudPhotos_LowQualityName",
    description: "album_type.CloudPhotos_LowQualityDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos_LowQuality",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CloudPhotos_LowQuality\$uid$",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 家园路牌封面图片
  AlbumType.CustomHomeBoardPhoto: AlbumInfo(
    type: "CustomHomeBoardPhoto",
    visible: true,
    name: "album_type.CustomHomeBoardPhotoName",
    description: "album_type.CustomHomeBoardPhotoDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\CustomHomeBoardPhoto\$uid$",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\CustomHomeBoardPhoto\$uid$",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 家园模板封面图片
  AlbumType.HomeTemplatePhoto: AlbumInfo(
    type: "HomeTemplatePhoto",
    visible: true,
    name: "album_type.HomeTemplatePhotoName",
    description: "album_type.HomeTemplatePhotoDescription",
    isRequireUid: true,
    locateInGame: r"\X6Game\Saved\HomeTemplate\$uid$",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\HomeTemplatePhoto\$uid$",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  // 分享码
  AlbumType.XSdkQrCode: AlbumInfo(
    type: "XSdkQrCode",
    visible: true,
    name: "album_type.XSdkQrCodeName",
    description: "album_type.XSdkQrCodeDescription",
    isRequireUid: false,
    locateInGame: r"\X6Game\Saved\XSdkQrCode",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\XSdkQrCode",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.any,
  ),
  AlbumType.ScreenShot: AlbumInfo(
    type: "ScreenShot",
    visible: true,
    name: "album_type.ScreenShotName",
    description: "album_type.ScreenShotDescription",
    isRequireUid: false,
    locateInGame: r"\X6Game\ScreenShot",
    locateInBackup: null,
    locateInRecycleBin:
    r"\X6Game\NikkiAlbumsRecycleBin\$msSinceEpoch$\ScreenShot",
    chainDeletion: {},
    supportedPlatforms: InfinityNikkiPlatform.windows,
  ),
};