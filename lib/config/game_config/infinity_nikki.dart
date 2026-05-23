
import "package:nikki_albums/src/rust/serde_config/structs/game_config.dart";
import "package:nikki_albums/src/rust/serde_config/structs/common.dart";

const GameConfig infinityNikkiConfig = GameConfig(
  id: "infinity_nikki",
  name: Text.translate(TranslateText(key: "infinity_nikki.name")),
  icon: "infinity_nikki.webp",

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


