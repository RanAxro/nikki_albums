enum AlbumType{
  Collage_CollagePhoto,
  Collage_HighQuality,
  Collage_LowQuality,
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
  XSdkQrCode;

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