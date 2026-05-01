

import "launcher_channel.dart";

import "package:win32_registry/win32_registry.dart";


class InfinityNikkiWindowsInfo{
  final RegistryHive hive;
  final String path;
  final String key;
  final String? configPath;
  final String locateToLauncher;
  final String locateToInstall;

  const InfinityNikkiWindowsInfo({
    required this.hive,
    required this.path,
    required this.key,
    this.configPath,
    required this.locateToLauncher,
    required this.locateToInstall,
  });
}

const Map<LauncherChannel, List<InfinityNikkiWindowsInfo>> infinityNikkiWindowsInfos = {
  LauncherChannel.paper: [
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.currentUser,
      path: r"Software\InfinityNikki Launcher",
      key: "",
      configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      locateToLauncher: r"",
      locateToInstall: r"\InfinityNikki",
    ),
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\InfinityNikki Launcher.exe",
      key: "",
      configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      locateToLauncher: r"\..",
      locateToInstall: r"\..\InfinityNikki",
    ),
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
      key: "DisplayIcon",
      configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      locateToLauncher: r"\..",
      locateToInstall: r"\..\InfinityNikki",
    ),
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher",
      key: "UninstallString",
      configPath: r"C:\Users\$username$\AppData\Local\InfinityNikki Launcher\config.ini",
      locateToLauncher: r"\..",
      locateToInstall: r"\..\InfinityNikki",
    ),
  ],
  LauncherChannel.paperGlobal: [
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.currentUser,
      path: r"Software\InfinityNikkiGlobal Launcher",
      key: "",
      configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      locateToLauncher: r"",
      locateToInstall: r"\InfinityNikkiGlobal",
    ),
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\InfinityNikkiGlobal Launcher.exe",
      key: "",
      configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      locateToLauncher: r"\..",
      locateToInstall: r"\..\InfinityNikkiGlobal",
    ),
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
      key: "DisplayIcon",
      configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      locateToLauncher: r"\..",
      locateToInstall: r"\InfinityNikkiGlobal",
    ),
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
      key: "InstallPath",
      configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      locateToLauncher: r"",
      locateToInstall: r"\InfinityNikkiGlobal",
    ),
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiGlobal Launcher",
      key: "UninstallString",
      configPath: r"C:\Users\$username$\AppData\Local\InfinityNikkiGlobal Launcher\config.ini",
      locateToLauncher: r"\..",
      locateToInstall: r"\..\InfinityNikkiGlobal",
    ),
  ],
  LauncherChannel.taptap: [
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\TapTap\Games\247283",
      key: "InstallPath",
      locateToLauncher: r"\InfinityNikki Launcher",
      locateToInstall: r"\InfinityNikki Launcher\InfinityNikki",
    ),
  ],
  LauncherChannel.bilibili: [
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiBili Launcher",
      key: "InstallPath",
      locateToLauncher: r"",
      locateToInstall: r"\InfinityNikki",
    ),
  ],
  LauncherChannel.steam: [
    InfinityNikkiWindowsInfo(
      hive: RegistryHive.localMachine,
      path: r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 3164330",
      key: "InstallLocation",
      locateToLauncher: r"",
      locateToInstall: r"\InfinityNikki",
    ),
  ]
};




class InfinityNikkiAndroidInfo{
  final String locateToInstall;
  final String applicationId;
  final int appData;

  const InfinityNikkiAndroidInfo({
    required this.locateToInstall,
    required this.applicationId,
    required this.appData,
  });

  String get locateToLauncher => "/storage/emulated/0/Android/data/$applicationId";
}

const Map<LauncherChannel, List<InfinityNikkiAndroidInfo>> infinityNikkiAndroidInfos = {
  LauncherChannel.paper: [
    InfinityNikkiAndroidInfo(
      applicationId: r"com.papegames.infinitynikki",
      appData: 2,
      locateToInstall: r"/files/UnrealGame/X6Game",
    ),
  ],
  LauncherChannel.paperGlobal: [
    InfinityNikkiAndroidInfo(
      applicationId: r"com.infoldgames.infinitynikkien",
      appData: 2,
      locateToInstall: r"/files/UnrealGame/X6Game",
    ),
  ],
  LauncherChannel.bilibili: [
    InfinityNikkiAndroidInfo(
      applicationId: r"com.papegames.infinitynikki.bilibili",
      appData: 2,
      locateToInstall: r"/files/UnrealGame/X6Game",
    ),
  ],
};