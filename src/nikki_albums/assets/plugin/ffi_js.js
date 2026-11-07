class FileSystemHandler{
  _handlerId;
  constructor(handlerId){
    this._handlerId = handlerId;
  }
}
FileSystemHandler.prototype.exists = function(path){
  return sendMessage("api.file_system.exists", JSON.stringify([this._handlerId, path]));
}
FileSystemHandler.prototype.isFile = function(path){
  return sendMessage("api.file_system.isFile", JSON.stringify([this._handlerId, path]));
}
FileSystemHandler.prototype.isDir = function(path){
  return sendMessage("api.file_system.isDir", JSON.stringify([this._handlerId, path]));
}
FileSystemHandler.prototype.isLink = function(path){
  return sendMessage("api.file_system.isLink", JSON.stringify([this._handlerId, path]));
}
FileSystemHandler.prototype.identical = function(path1, path2){
  return sendMessage("api.file_system.identical", JSON.stringify([this._handlerId, path1, path2]));
}
FileSystemHandler.prototype.stat = function(path){
  return sendMessage("api.file_system.stat", JSON.stringify([this._handlerId, path]));
}
FileSystemHandler.prototype.list = function(path, recursive = false, followLinks = true){
  return sendMessage("api.file_system.list", JSON.stringify([this._handlerId, path, recursive, followLinks]));
}
FileSystemHandler.prototype.readString = function(path, encoding = "utf-8"){
  return sendMessage("api.file_system.readString", JSON.stringify([this._handlerId, path, encoding]));
}
FileSystemHandler.prototype.readLines = function(path, encoding = "utf-8"){
  return sendMessage("api.file_system.readLines", JSON.stringify([this._handlerId, path, encoding]));
}
FileSystemHandler.prototype.readBytes = function(path){
  return sendMessage("api.file_system.readBytes", JSON.stringify([this._handlerId, path]));
}


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
    sendMessage("api.registerGame", JSON.stringify({
      uuid: gameInfo.uuid,
      name: gameInfo.name,
      icon: gameInfo.icon,
    }));
    globalThis.__apiBridge.game[String(gameInfo.uuid)] = {
      searchGame: gameInfo.searchGame,
    };
  },

  //environment
  environment: {
    getEnv: function(key){
      return sendMessage("api.environment.getEnv", JSON.stringify(key));
    },
    getLocalHostname: function(){
      return sendMessage("api.environment.getLocalHostname", "null");
    },
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

  fileSystem: new FileSystemHandler(""),

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