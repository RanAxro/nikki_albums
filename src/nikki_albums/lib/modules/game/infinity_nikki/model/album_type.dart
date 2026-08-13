enum AlbumType{
  collageCollagePhoto("Collage/CollagePhoto", "infinity_nikki.album_type.collage.collage_photo"),
  collageHighQuality("Collage/HighQuality", "infinity_nikki.album_type.collage.high_quality"),
  collageLowQuality("Collage/LowQuality", "infinity_nikki.album_type.collage.low_quality"),
  clockInPhoto("ClockInPhoto", "infinity_nikki.album_type.clock_in_photo"),
  cloudPhotosLowQuality("CloudPhotos_LowQuality", "infinity_nikki.album_type.cloud_photos_low_quality"),
  cloudPhotos("CloudPhotos", "infinity_nikki.album_type.cloud_photos"),
  customAvatar("CustomAvatar", "infinity_nikki.album_type.custom_avatar"),
  customCard("CustomCard", "infinity_nikki.album_type.custom_card"),
  customHomeBoardPhoto("CustomHomeBoardPhoto", "infinity_nikki.album_type.custom_home_board_photo"),
  diy("DIY", "infinity_nikki.album_type.diy"),
  homeTemplatePhoto("HomeTemplatePhoto", "infinity_nikki.album_type.home_template_photo"),
  // LauncherImagesCache,
  magazinePhotos("MagazinePhotos", "infinity_nikki.album_type.magazine_photos"),
  // MallPic,
  nikkiPhotosHighQuality("NikkiPhotos_HighQuality", "infinity_nikki.album_type.nikki_photos.high_quality"),
  nikkiPhotosLowQuality("NikkiPhotos_LowQuality", "infinity_nikki.album_type.nikki_photos.low_quality"),
  plantDyeing("PlantDyeing", "infinity_nikki.album_type.plant_dyeing"),
  screenShot("ScreenShot", "infinity_nikki.album_type.screen_shot"),
  xSdkQrCode("XSdkQrCode", "infinity_nikki.album_type.x_sdk_qr_code"),

  /// insignificance
  accountAvatar("PaperCache", "infinity_nikki.album_type.paper_cache"),
  biologicalInvestigation("Biologicalinvestigation", "infinity_nikki.album_type.biological_investigation"),
  corner("PendingUp", "infinity_nikki.album_type.corner"),
  editorPhoto("EditorPhoto", "infinity_nikki.album_type.editor_photo");

  final String displayName;
  final String nameKey;

  const AlbumType(this.displayName, this.nameKey);

  static AlbumType from(dynamic value){
    return AlbumType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AlbumType.screenShot,
    );
  }

  static AlbumType? fromStrictly(dynamic value){
    return AlbumType.values.where((e) => e.name == value).firstOrNull;
  }
}