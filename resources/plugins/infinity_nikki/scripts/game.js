const env = api.environment;
const p = api.path;
const fs = api.fileSystem;
const wr = api.windowsRegistry;

const windowsGameSearcherPaperConfig = {
  paper: "C:\\Users\\{username}\\AppData\\Local\\InfinityNikki Launcher\\config.ini",
  paperGlobal: "C:\\Users\\{username}\\AppData\\Local\\InfinityNikkiGlobal Launcher\\config.ini",
};
const windowsGameSearcherRegistryConfig = {
  paper: [
    {
      hive: wr.HKEY_CURRENT_USER,
      path: "Software\\InfinityNikki Launcher",
      key: "",
      locateToInstall: "InfinityNikki",
    },
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\InfinityNikki Launcher.exe",
      key: "",
      locateToInstall: "..\\InfinityNikki",
    },
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\InfinityNikki Launcher",
      key: "DisplayIcon",
      locateToInstall: "..\\InfinityNikki",
    },
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\InfinityNikki Launcher",
      key: "UninstallString",
      locateToInstall: "..\\InfinityNikki",
    },
  ],
  paperGlobal: [
    {
      hive: wr.HKEY_CURRENT_USER,
      path: "Software\\InfinityNikkiGlobal Launcher",
      key: "",
      locateToInstall: "InfinityNikkiGlobal",
    },
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\InfinityNikkiGlobal Launcher.exe",
      key: "",
      locateToInstall: "..\\InfinityNikkiGlobal",
    },
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\InfinityNikkiGlobal Launcher",
      key: "DisplayIcon",
      locateToInstall: "..\\InfinityNikkiGlobal",
    },
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\InfinityNikkiGlobal Launcher",
      key: "InstallPath",
      locateToInstall: "InfinityNikkiGlobal",
    },
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\InfinityNikkiGlobal Launcher",
      key: "UninstallString",
      locateToInstall: "..\\InfinityNikkiGlobal",
    },
  ],
  taptap: [
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\TapTap\\Games\\247283",
      key: "InstallPath",
      locateToInstall: "InfinityNikki Launcher\\InfinityNikki",
    },
  ],
  bilibili: [
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\InfinityNikkiBili Launcher",
      key: "InstallPath",
      locateToInstall: "InfinityNikki",
    },
  ],
  steam: [
    {
      hive: wr.HKEY_LOCAL_MACHINE,
      path: "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Steam App 3164330",
      key: "InstallLocation",
      locateToInstall: "InfinityNikki",
    },
  ],
};


export async function searchGameInWindows(fsHandler){
  let res = {};

  try{
    let username = env.getLocalHostname();
    for(const [channel, configPath] of Object.entries(windowsGameSearcherPaperConfig)){
      let cfgPath = configPath.replace("{username}", username);
      let cfgString = await fsHandler.readString(cfgPath);
      let cfg = api.iniDecode(cfgString);
      let installPath = cfg.Download.gameDir;
      installPath = p.canonicalize(installPath);
      res[installPath] = {
        info: {
          channel: channel,
        },
        install_path: installPath,
      };
    }
  }catch(e){
    throw e;
  }

  for(const [channel, registryConfigList] of Object.entries(windowsGameSearcherRegistryConfig)){
    for(const registryConfig of registryConfigList){
      try{
        let obtainedPath = wr.readString(
          registryConfig.hive,
          registryConfig.path,
          registryConfig.key,
        );
        let installPath = p.join(obtainedPath, registryConfig.locateToInstall);
        installPath = p.canonicalize(installPath);
        res[installPath] = {
          info: {
            channel: channel,
          },
          install_path: installPath,
        };
      }catch(_){
        continue;;
      }
    }
  }

  return Object.values(res);
}
