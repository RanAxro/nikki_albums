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

  iniDecode: function(content, flatDefaultOption = true){
    return sendMessage("api.iniDecode", JSON.stringify([content, flatDefaultOption]));
  },
  iniEncode: function(content){
    return sendMessage("api.iniEncode", JSON.stringify(content));
  },

  path: {
    separator: sendMessage("api.path.separator", "null"),
    join: function(...parts){
      return sendMessage("api.path.join", JSON.stringify(parts));
    },
    basename: function(path){
      return sendMessage("api.path.basename", JSON.stringify(path));
    },
    basenameWithoutExtension: function(path){
      return sendMessage("api.path.basenameWithoutExtension", JSON.stringify(path));
    },
    dirname: function(path){
      return sendMessage("api.path.dirname", JSON.stringify(path));
    },
    extension: function(path, level = 1){
      return sendMessage("api.path.extension", JSON.stringify([path, level]));
    },
    rootPrefix: function(path){
      return sendMessage("api.path.rootPrefix", JSON.stringify(path));
    },
    isAbsolute: function(path){
      return sendMessage("api.path.isAbsolute", JSON.stringify(path));
    },
    isRelative: function(path){
      return sendMessage("api.path.isRelative", JSON.stringify(path));
    },
    isRootRelative: function(path){
      return sendMessage("api.path.isRootRelative", JSON.stringify(path));
    },
    split: function(path){
      return sendMessage("api.path.split", JSON.stringify(path));
    },
    canonicalize: function(path){
      return sendMessage("api.path.canonicalize", JSON.stringify(path));
    },
    normalize: function(path){
      return sendMessage("api.path.normalize", JSON.stringify(path));
    },
    isWithin: function(parent, child){
      return sendMessage("api.path.isWithin", JSON.stringify([parent, child]));
    },
    equals: function(path1, path2){
      return sendMessage("api.path.equals", JSON.stringify([path1, path2]));
    },
    withoutExtension: function(path){
      return sendMessage("api.path.withoutExtension", JSON.stringify(path));
    },
    setExtension: function(path, extension){
      return sendMessage("api.path.setExtension", JSON.stringify([path, extension]));
    },
    fromUri: function(url){
      return sendMessage("api.path.fromUri", JSON.stringify(url));
    },
    toUri: function(path){
      return sendMessage("api.path.toUri", JSON.stringify(path));
    },
  },

  fileSystem: {
    exists: function(path){
      return sendMessage("api.file_system.exists", JSON.stringify(path));
    },
    isFile: function(path){
      return sendMessage("api.file_system.isFile", JSON.stringify(path));
    },
    isDir: function(path){
      return sendMessage("api.file_system.isDir", JSON.stringify(path));
    },
    isLink: function(path){
      return sendMessage("api.file_system.isLink", JSON.stringify(path));
    },
    identical: function(path1, path2){
      return sendMessage("api.file_system.identical", JSON.stringify([path1, path2]));
    },
    stat: function(path){
      return sendMessage("api.file_system.stat", JSON.stringify(path));
    },
    list: function(path, recursive = false, followLinks = true){
      return sendMessage("api.file_system.list", JSON.stringify([path, recursive, followLinks]));
    },
    readString: function(path, encoding = "utf-8"){
      return sendMessage("api.file_system.readString", JSON.stringify([path, encoding]));
    },
    readLines: function(path, encoding = "utf-8"){
      return sendMessage("api.file_system.readLines", JSON.stringify([path, encoding]));
    },
    readBytes: function(path){
      return sendMessage("api.file_system.readBytes", JSON.stringify(path));
    },
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