
import "package:nikki_albums/src/rust/serde_config/structs/game_config.dart";
import "package:nikki_albums/src/rust/serde_config/structs/common.dart";

const GameConfig infinityNikkiConfig = GameConfig(
  id: "infinity_nikki",
  name: Text.translate(TranslateText(key: "infinity_nikki.name")),
  icon: "infinity_nikki.webp",

  /// Albums
  albumsConfig: [
    /// NikkiPhotos_HighQuality
    GameAlbumConfig(
      id: "NikkiPhotos_HighQuality",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.nikki_photos_high_quality")),
      icon: "nikki_photos_high_quality.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/NikkiPhotos_HighQuality",
      toMedia: "",
      allowMove: true,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "NikkiPhotos_LowQuality": true,
        "ScreenShot": true,
        "MagazinePhotos": false,
        "ClockInPhoto": false,
        "Collage_CollagePhoto": false,
      },
      platforms: Platform.values,
    ),
    /// NikkiPhotos_LowQuality
    GameAlbumConfig(
      id: "NikkiPhotos_LowQuality",
      visible: false,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.nikki_photos_low_quality")),
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/NikkiPhotos_LowQuality",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "NikkiPhotos_HighQuality": false,
        "ScreenShot": false,
        "MagazinePhotos": false,
        "ClockInPhoto": false,
        "Collage_CollagePhoto": false,
      },
      platforms: Platform.values,
    ),
    /// Video
    GameAlbumConfig(
      id: "Video",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.video")),
      icon: "video.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/Videos",
      toMedia: r"/$boxName$.$videoFileExtension$",
      toCover: r"/$boxName$_cover.$imageFileExtension$",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "ExternalVideo": true,
      },
      platforms: Platform.values,
    ),
    /// MagazinePhotos
    GameAlbumConfig(
      id: "MagazinePhotos",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.magazine_photos")),
      icon: "magazine_photos.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/MagazinePhotos",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "NikkiPhotos_HighQuality": false,
        "NikkiPhotos_LowQuality": false,
        "ScreenShot": false,
        "ClockInPhoto": false,
        "Collage_CollagePhoto": false,
      },
      platforms: Platform.values,
    ),
    /// ClockInPhoto
    GameAlbumConfig(
      id: "ClockInPhoto",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.magazine_photos")),
      icon: "magazine_photos.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/ClockInPhoto",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "NikkiPhotos_HighQuality": false,
        "NikkiPhotos_LowQuality": false,
        "ScreenShot": false,
        "ClockInPhoto": false,
        "Collage_CollagePhoto": false,
      },
      platforms: Platform.values,
    ),
    /// Collage_HighQuality
    GameAlbumConfig(
      id: "Collage_HighQuality",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.collage_high_quality")),
      icon: "collage_high_quality.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/Collage/HighQuality",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "Collage_LowQuality": true
      },
      platforms: Platform.values,
    ),
    /// Collage_LowQuality
    GameAlbumConfig(
      id: "Collage_LowQuality",
      visible: false,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.collage_low_quality")),
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/Collage/LowQuality",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "Collage_HighQuality": true
      },
      platforms: Platform.values,
    ),
    /// Collage_CollagePhoto
    GameAlbumConfig(
      id: "Collage_CollagePhoto",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.collage_collage_photo")),
      icon: "collage_collage_photo.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/Collage/CollagePhoto",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "NikkiPhotos_HighQuality": false,
        "NikkiPhotos_LowQuality": false,
        "ScreenShot": false,
        "MagazinePhotos": false,
        "ClockInPhoto": false,
      },
      platforms: Platform.values,
    ),
    /// CustomAvatar
    GameAlbumConfig(
      id: "CustomAvatar",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.custom_avatar")),
      icon: "custom_avatar.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/CustomAvatar/$uid$",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {},
      platforms: Platform.values,
    ),
    /// CustomCard
    GameAlbumConfig(
      id: "CustomCard",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.custom_card")),
      icon: "custom_card.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/CustomCard/$uid$",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {},
      platforms: Platform.values,
    ),
    /// PlantDyeing
    GameAlbumConfig(
      id: "PlantDyeing",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.plant_dyeing")),
      icon: "plant_dyeing.webp",
      requireUid: false,
      locate: r"/X6Game/Saved/PlantDyeing",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {},
      platforms: Platform.values,
    ),
    /// DIY
    GameAlbumConfig(
      id: "DIY",
      visible: true,
      unimportance: true,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.diy")),
      icon: "diy.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/DIY/$uid$",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: false,
      chainDeletion: {},
      platforms: Platform.values,
    ),
    /// CloudPhotos
    GameAlbumConfig(
      id: "CloudPhotos",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.cloud_photos")),
      icon: "cloud_photos.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/CloudPhotos",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {},
      platforms: Platform.values,
    ),
    /// CloudPhotos_LowQuality
    GameAlbumConfig(
      id: "CloudPhotos_LowQuality",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.cloud_photos_low_quality")),
      icon: "cloud_photos_low_quality.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/GamePlayPhotos/$uid$/CloudPhotos_LowQuality",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {},
      platforms: Platform.values,
    ),
    /// CustomHomeBoardPhoto
    GameAlbumConfig(
      id: "CustomHomeBoardPhoto",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.custom_home_board_photo")),
      icon: "custom_home_board_photo.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/CustomHomeBoardPhoto/$uid$",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {},
      platforms: Platform.values,
    ),
    /// HomeTemplatePhoto
    GameAlbumConfig(
      id: "HomeTemplatePhoto",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.home_template_photo")),
      icon: "home_template_photo.webp",
      requireUid: true,
      locate: r"/X6Game/Saved/HomeTemplate/$uid$",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {},
      platforms: Platform.values,
    ),
    /// XSdkQrCode
    GameAlbumConfig(
      id: "XSdkQrCode",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.qr_code")),
      icon: "qr_code.webp",
      requireUid: false,
      locate: r"/X6Game/Saved/XSdkQrCode",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {},
      platforms: Platform.values,
    ),
    /// ScreenShot
    GameAlbumConfig(
      id: "ScreenShot",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.screen_shot")),
      icon: "screen_shot.webp",
      requireUid: false,
      locate: r"/X6Game/ScreenShot",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "NikkiPhotos_HighQuality": false,
        "NikkiPhotos_LowQuality": false,
        "MagazinePhotos": false,
        "ClockInPhoto": false,
        "Collage_CollagePhoto": false,
      },
      platforms: [Platform.windows],
    ),
    /// ExternalVideo
    GameAlbumConfig(
      id: "ExternalVideo",
      visible: true,
      unimportance: false,
      name: Text.translate(TranslateText(key: "infinity_nikki.album_name.external_video")),
      icon: "video.webp",
      requireUid: false,
      locate: r"/X6Game/Video",
      toMedia: "",
      allowMove: false,
      allowDelete: true,
      cacheByName: true,
      chainDeletion: {
        "Video": false,
      },
      platforms: [Platform.windows],
    ),
  ],

  /// Windows
  windows: WindowsGameConfig(
    locate: [
      /// paper
      WindowsGameLocationConfig(
        channel: "paper",
        name: Text.translate(TranslateText(key: "infinity_nikki.launcher_name.paper")),
        icon: "paper.webp",
        requireLauncher: false,
        searcher: [
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.currentUser,
              path: r"Software\InfinityNikki Launcher",
              key: "",
              locate: "",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.currentUser,
              path: r"Software\InfinityNikki Launcher",
              key: "",
              locate: r"\InfinityNikki",
            ),
            useConfigFile: true,
          ),
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\InfinityNikki Launcher.exe",
              key: "",
              locate: r"\..",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\InfinityNikki Launcher.exe",
              key: "",
              locate: r"\..\InfinityNikki",
            ),
            useConfigFile: true,
          ),
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
              key: "DisplayIcon",
              locate: r"\..",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
              key: "DisplayIcon",
              locate: r"\..\InfinityNikki",
            ),
            useConfigFile: true,
          ),
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
              key: "UninstallString",
              locate: r"\..",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
              key: "UninstallString",
              locate: r"\..\InfinityNikki",
            ),
            useConfigFile: true,
          ),
          WindowsGameSearcherConfig.configFile(
            path: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
            configType: ConfigFileType.ini,
            toInstall: "Download.gameDir",
          ),
        ],
      ),

      /// paper global
      WindowsGameLocationConfig(
        channel: "paper_global",
        name: Text.translate(TranslateText(key: "infinity_nikki.launcher_name.paper_global")),
        icon: "paper.webp",
        requireLauncher: false,
        searcher: [
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.currentUser,
              path: r"Software\InfinityNikkiGlobal Launcher",
              key: "",
              locate: "",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.currentUser,
              path: r"Software\InfinityNikkiGlobal Launcher",
              key: "",
              locate: r"\InfinityNikkiGlobal",
            ),
            useConfigFile: true,
          ),
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\InfinityNikkiGlobal Launcher.exe",
              key: "",
              locate: r"\..",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\InfinityNikkiGlobal Launcher.exe",
              key: "",
              locate: r"\..\InfinityNikkiGlobal",
            ),
            useConfigFile: true,
          ),
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
              key: "DisplayIcon",
              locate: r"\..",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
              key: "DisplayIcon",
              locate: r"\..\InfinityNikkiGlobal",
            ),
            useConfigFile: true,
          ),
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
              key: "InstallPath",
              locate: r"",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
              key: "InstallPath",
              locate: r"\InfinityNikkiGlobal",
            ),
            useConfigFile: true,
          ),
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
              key: "UninstallString",
              locate: r"\..",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
              key: "UninstallString",
              locate: r"\..\InfinityNikkiGlobal",
            ),
            useConfigFile: true,
          ),
          WindowsGameSearcherConfig.configFile(
            path: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
            configType: ConfigFileType.ini,
            toInstall: "Download.gameDir",
          ),
        ],
      ),

      /// taptap
      WindowsGameLocationConfig(
        channel: "taptap",
        name: Text.translate(TranslateText(key: "infinity_nikki.launcher_name.taptap")),
        icon: "taptap.webp",
        requireLauncher: false,
        searcher: [
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\TapTap\Games\247283",
              key: "InstallPath",
              locate: r"\InfinityNikki Launcher",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\TapTap\Games\247283",
              key: "InstallPath",
              locate: r"\InfinityNikki Launcher\InfinityNikki",
            ),
            useConfigFile: false,
          ),
        ],
      ),

      /// bilibili
      WindowsGameLocationConfig(
        channel: "bilibili",
        name: Text.translate(TranslateText(key: "infinity_nikki.launcher_name.bilibili")),
        icon: "bilibili.webp",
        requireLauncher: false,
        searcher: [
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiBili Launcher",
              key: "InstallPath",
              locate: r"",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiBili Launcher",
              key: "InstallPath",
              locate: r"\InfinityNikki",
            ),
            useConfigFile: false,
          ),
        ],
      ),

      /// steam
      WindowsGameLocationConfig(
        channel: "steam",
        name: Text.translate(TranslateText(key: "infinity_nikki.launcher_name.steam")),
        icon: "steam.webp",
        requireLauncher: false,
        searcher: [
          WindowsGameSearcherConfig.registry(
            toLauncher: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 3164330",
              key: "InstallLocation",
              locate: r"",
            ),
            toInstall: WindowsRegistryConfig(
              hive: WindowsRegistryHive.localMachine,
              path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 3164330",
              key: "InstallLocation",
              locate: r"\InfinityNikki",
            ),
            useConfigFile: false,
          ),
        ],
      ),
    ],
    custom: WindowsCustomGameConfig(
      toLauncherTip: Text.translate(TranslateText(key: "infinity_nikki.locate_launcher")),
      toLauncher: [
        FileEntityLocationConfig(
          entityType: FileEntityType.directory,
          on_: r"?/X6Game",
          locate: r"\..\..",
          andDiscoverFile: [r"launcher.exe"],
        ),
        FileEntityLocationConfig(
          entityType: FileEntityType.file,
          on_: r"?/InfinityNikki.exe",
          locate: r"\..\..",
          andDiscoverFile: [r"launcher.exe"],
        ),
        FileEntityLocationConfig(
          entityType: FileEntityType.directory,
          on_: r"?/InfinityNikki",
          locate: r"\..",
          andDiscoverFile: [r"launcher.exe"],
        ),
        FileEntityLocationConfig(
          entityType: FileEntityType.directory,
          on_: r"?/InfinityNikkiGlobal",
          locate: r"\..",
          andDiscoverFile: [r"launcher.exe"],
        ),
        FileEntityLocationConfig(
          entityType: FileEntityType.file,
          on_: r"?/launcher.exe",
          locate: r"\..",
        ),
        FileEntityLocationConfig(
          entityType: FileEntityType.file,
          on_: r"?/uninst.exe",
          locate: r"\..",
          andDiscoverFile: [r"launcher.exe"],
        ),
      ],
      toLauncherThenToInstall: [r"InfinityNikki", r"InfinityNikkiGlobal"],
      toInstallTip: Text.translate(TranslateText(key: "infinity_nikki.locate_install")),
      toInstall: [
        FileEntityLocationConfig(
          entityType: FileEntityType.directory,
          on_: r"?/X6Game",
          locate: r"\..",
        ),
        FileEntityLocationConfig(
          entityType: FileEntityType.directory,
          on_: r"?/Engine",
          locate: r"\..",
          andDiscoverDirectory: [r"\X6Game"],
        ),
        FileEntityLocationConfig(
          entityType: FileEntityType.directory,
          on_: r"?/InfinityNikki",
          locate: r"",
          andDiscoverDirectory: [r"\X6Game"],
        ),
        FileEntityLocationConfig(
          entityType: FileEntityType.directory,
          on_: r"?/InfinityNikkiGlobal",
          locate: r"",
          andDiscoverDirectory: [r"\X6Game"],
        ),
        FileEntityLocationConfig(
          entityType: FileEntityType.file,
          on_: r"?/InfinityNikki.exe",
          locate: r"\..",
          andDiscoverDirectory: [r"\X6Game"],
        ),
      ],
      toInstallThenToLauncher: [r"\.."],
    ),
  ),

  /// Android
  android: AndroidGameConfig(
    locate: [
      /// paper
      AndroidGameLocationConfig(
        channel: "paper",
        name: Text.translate(TranslateText(key: "infinity_nikki.launcher_name.paper")),
        icon: "paper.webp",
        searcher: AndroidGameSearcherConfig(
          applicationId: r"com.papegames.infinitynikki",
          toInstall: r"/files/UnrealGame/X6Game",
        ),
      ),

      /// paper global
      AndroidGameLocationConfig(
        channel: "paper_global",
        name: Text.translate(TranslateText(key: "infinity_nikki.launcher_name.paper_global")),
        icon: "paper.webp",
        searcher: AndroidGameSearcherConfig(
          applicationId: r"com.infoldgames.infinitynikkien",
          toInstall: r"/files/UnrealGame/X6Game",
        ),
      ),

      /// bilibili
      AndroidGameLocationConfig(
        channel: "bilibili",
        name: Text.translate(TranslateText(key: "infinity_nikki.launcher_name.bilibili")),
        icon: "bilibili.webp",
        searcher: AndroidGameSearcherConfig(
          applicationId: r"com.papegames.infinitynikki.bilibili",
          toInstall: r"/files/UnrealGame/X6Game",
        ),
      ),
    ],
  ),
);


