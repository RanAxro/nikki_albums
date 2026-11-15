class Text{
  static l(text){ return new LiteralText(text); }
  static tr(key, extra){ return new TranslateText(key, extra); }
}
class LiteralText extends Text{
  constructor(text){
    super();
    this.text = text;
  }
}
class TranslateText extends Text{
  constructor(key, extra){
    super();
    this.key = key;
    this.global = extra?.global;
    this.args = extra?.args;
    this.named_args = extra?.namedArgs;
    this.gender = extra?.gender;
  }
}

class Icon{
  static image(path, global){ return new ImageIcon(path, global); }
  static app(name){ return new BuiltInIcon(name); }
}
class ImageIcon extends Icon{
  constructor(path, global){
    super();
    this.path = path;
    this.global = global;
  }
}
class BuiltInIcon extends Icon{
  constructor(name){
    super();
    this.name = name;
  }
}

class Image{
  static icon(icon){ return new IconImage(icon); }
  static fs(fsHandler, path){ return new NGFSImage(fsHandler, path); }
  static file(path){ return new NativeImage(path); }
}
class IconImage extends Image{
  constructor(icon){
    super();
    this.icon = icon;
  }
}
class NGFSImage extends Image{
  constructor(fsHandler, path){
    super();
    this.fs_handler = fsHandler;
    this.path = path;
  }
}
class NativeImage extends Image{
  constructor(path){
    super();
    this.path = path;
  }
}

class DeviceGame{
  constructor(installPath, info){
    this.info = info;
    this.install_path = installPath;
  }
}

class PickedDeviceGameResult{
  static ok(deviceGame){ return new PickedDeviceGameOkResult(deviceGame); }
  static err(text){ return new PickedDeviceGameErrResult(text); }
}
class PickedDeviceGameOkResult extends PickedDeviceGameResult{
  constructor(deviceGame){
    super();
    this.Ok = deviceGame;
  }
}
class PickedDeviceGameErrResult extends PickedDeviceGameResult{
  constructor(text){
    super();
    this.Err = text ?? null;
  }
}

class AddedCustomAccountResult{
  static ok(account){ return new AddedCustomAccountOkResult(account); }
  static err(text){ return new AddedCustomAccountErrResult(text); }
}
class AddedCustomAccountOkResult extends AddedCustomAccountResult{
  constructor(account){
    super();
    this.Ok = account;
  }
}
class AddedCustomAccountErrResult extends AddedCustomAccountResult{
  constructor(text){
    super();
    this.Err = text ?? null;
  }
}