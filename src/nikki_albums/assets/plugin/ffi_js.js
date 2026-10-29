globalThis.__apiBridge = {
  game: {},
};

globalThis.api = {
  registerLoc: function(localeAndPathMap){
    return sendMessage("api.registerLoc", JSON.stringify(localeAndPathMap));
  },
  registerGlobalLoc: function(localeAndPathMap){
    return sendMessage("api.registerGlobalLoc", JSON.stringify(localeAndPathMap));
  },
  registerIcon: function(iconPaths){
    return sendMessage("api.registerIcon", JSON.stringify(iconPaths));
  },
  registerGlobalIcon: function(iconPaths){
    return sendMessage("api.registerGlobalIcon", JSON.stringify(iconPaths));
  },
  registerFont: function(fontFamilyAndPathMap){
    return sendMessage("api.registerFont", JSON.stringify(fontFamilyAndPathMap));
  },
  registerGlobalFont: function(fontFamilyAndPathMap){
    return sendMessage("api.registerGlobalFont", JSON.stringify(fontFamilyAndPathMap));
  },
  registerGame: function(gameInfo){
    let id = sendMessage("api.registerGame", JSON.stringify({
      uuid: gameInfo.uuid,
    }));
    globalThis.__apiBridge.game[String(id)] = {
      searchGame: gameInfo.searchGame,
    };
  },

  windowsRegistry: {
    HKEY_CLASSES_ROOT: sendMessage("api.windowsRegistry.HKEY_CLASSES_ROOT", "null"),
    HKEY_CURRENT_USER: sendMessage("api.windowsRegistry.HKEY_CURRENT_USER", "null"),
    HKEY_LOCAL_MACHINE: sendMessage("api.windowsRegistry.HKEY_LOCAL_MACHINE", "null"),
    HKEY_USERS: sendMessage("api.windowsRegistry.HKEY_USERS", "null"),
    HKEY_PERFORMANCE_DATA: sendMessage("api.windowsRegistry.HKEY_PERFORMANCE_DATA", "null"),
    HKEY_CURRENT_CONFIG: sendMessage("api.windowsRegistry.HKEY_CURRENT_CONFIG", "null"),
    readString: function(hkey, path, name){
      return sendMessage("api.windowsRegistry.readString", JSON.stringify([hkey, path, name]));
    },
    readMultiString: function(hkey, path, name){
      return sendMessage("api.windowsRegistry.readMultiString", JSON.stringify([hkey, path, name]));
    },
    readInt: function(hkey, path, name){
      return sendMessage("api.windowsRegistry.readInt", JSON.stringify([hkey, path, name]));
    },
    readBinary: function(hkey, path, name){
      return sendMessage("api.windowsRegistry.readBinary", JSON.stringify([hkey, path, name]));
    },
  },
};