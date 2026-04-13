import "launcher_channel.dart";

import "package:win32_registry/win32_registry.dart";

abstract class LocateToInfinityNikki{
  const LocateToInfinityNikki();

  String get locateToLauncher;
  String get locateToInstall;
}

class WindowsRegistryInfo extends LocateToInfinityNikki{
  @override
  final String locateToLauncher;
  @override
  final String locateToInstall;
  final RegistryHive hive;
  final String path;
  final String key;
  final String? configPath;

  const WindowsRegistryInfo({
    required this.locateToLauncher,
    required this.locateToInstall,
    required this.hive,
    required this.path,
    required this.key,
    this.configPath,
  });
}

class AndroidApplicationIdInfo extends LocateToInfinityNikki{
  @override
  final String locateToInstall;
  final String applicationId;
  final int appData;

  const AndroidApplicationIdInfo({
    required this.locateToInstall,
    required this.applicationId,
    required this.appData,
  });

  @override
  String get locateToLauncher => "/storage/emulated/0/Android/data/$applicationId";
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
        hive: RegistryHive.currentUser,
        path: r"Software\InfinityNikki Launcher",
        key: "",
        locateToLauncher: r"",
        locateToInstall: r"\InfinityNikki",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      ),
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\InfinityNikki Launcher.exe",
        key: "",
        locateToLauncher: r"\..",
        locateToInstall: r"\..\InfinityNikki",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      ),
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
        key: "DisplayIcon",
        locateToLauncher: r"\..",
        locateToInstall: r"\..\InfinityNikki",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      ),
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
        key: "UninstallString",
        locateToLauncher: r"\..",
        locateToInstall: r"\..\InfinityNikki",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      ),
    ],
    locateByAndroidApplicationId: [
      AndroidApplicationIdInfo(
        applicationId: r"com.papegames.infinitynikki",
        appData: 2,
        locateToInstall: r"/files/UnrealGame/X6Game",
      ),
    ],
  ),
  InfinityNikkiInfo(
    channel: LauncherChannel.paperGlobal,
    locateByWindowsRegistry: [
      WindowsRegistryInfo(
        hive: RegistryHive.currentUser,
        path: r"Software\InfinityNikkiGlobal Launcher",
        key: "",
        locateToLauncher: r"",
        locateToInstall: r"\InfinityNikkiGlobal",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      ),
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\InfinityNikkiGlobal Launcher.exe",
        key: "",
        locateToLauncher: r"\..",
        locateToInstall: r"\..\InfinityNikkiGlobal",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      ),
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
        key: "DisplayIcon",
        locateToLauncher: r"\..",
        locateToInstall: r"\InfinityNikkiGlobal",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      ),
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
        key: "InstallPath",
        locateToLauncher: r"",
        locateToInstall: r"\InfinityNikkiGlobal",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      ),
      WindowsRegistryInfo(
        hive: RegistryHive.localMachine,
        path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
        key: "UninstallString",
        locateToLauncher: r"\..",
        locateToInstall: r"\..\InfinityNikkiGlobal",
        configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      ),
    ],
    locateByAndroidApplicationId: [
      AndroidApplicationIdInfo(
        applicationId: r"com.infoldgames.infinitynikkien",
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