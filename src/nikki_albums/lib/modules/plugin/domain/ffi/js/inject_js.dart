
import "../../permission/permission.dart";
import "../../api/environment.dart" as env;
import "../../permission/environment.dart" as env;
import "../../api/file_system.dart" as fs;
import "../../permission/file_system.dart" as fs;
import "../../api/ini.dart" as ini;
import "../../api/path.dart" as p;
import "../../api/registration.dart" as r;
import "../../permission/registration.dart" as r;
import "../../api/windows_registry.dart" as wr;
import "../../permission/windows_registry.dart" as wr;
import "../../../model/event_handler.dart";
import "../../../model/exception.dart";

import "package:flutter/services.dart" show rootBundle;

import "package:quickjs_engine/quickjs_engine.dart";


Future<void> injectJS(JavascriptRuntime js, Set<Object> permission, PluginEventHandler eventHandler) async{
  js.onMessage("api.registerLoc", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => r.canRegisterLoc(permission),
      fn: () => r.registerLoc(params),
    );
  });
  js.onMessage("api.registerGlobalLoc", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => r.canRegisterGlobalLoc(permission),
      fn: () => r.registerGlobalLoc(params),
    );
  });
  js.onMessage("api.registerIcon", (dynamic args){
    final List<String> params = List<String>.from(args);
    return requirePermissionThenRun(
      canCall: () => r.canRegisterIcon(permission),
      fn: () => r.registerIcon(params),
    );
  });
  js.onMessage("api.registerGlobalIcon", (dynamic args){
    final List<String> params = List<String>.from(args);
    return requirePermissionThenRun(
      canCall: () => r.canRegisterGlobalIcon(permission),
      fn: () => r.registerGlobalIcon(params),
    );
  });
  js.onMessage("api.registerFont", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => r.canRegisterFont(permission),
      fn: () => r.registerFont(params),
    );
  });
  js.onMessage("api.registerGlobalFont", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => r.canRegisterGlobalFont(permission),
      fn: () => r.registerGlobalFont(params),
    );
  });
  js.onMessage("api.registerGame", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => r.canRegisterGame(permission),
      fn: () => r.registerGame(params, eventHandler),
    );
  });

  // environment
  js.onMessage("api.environment.getEnv", (dynamic args){
    final String params = args;
    return requirePermissionThenRun(
      canCall: () => env.canGetEnv(permission),
      fn: () => env.getEnv(params),
    );
  });
  js.onMessage("api.environment.getLocalHostname", (_){
    return requirePermissionThenRun(
      canCall: () => env.canGetLocalHostname(permission),
      fn: () => env.getLocalHostname(),
    );
  });


  // ini
  js.onMessage("api.iniDecode", (dynamic args){
    final List<dynamic> params = args;
    return ini.iniDecode(params[0], params[1]);
  });
  js.onMessage("api.iniEncode", (dynamic args){
    final Map<String, dynamic> params = args;
    return ini.iniEncode(params);
  });

  // path
  js.onMessage("api.path.separator", (_){
    return p.separator;
  });
  js.onMessage("api.path.join", (dynamic args){
    final List<String> params = List<String>.from(args);
    return p.join(params);
  });
  js.onMessage("api.path.basename", (dynamic args){
    final String params = args;
    return p.basename(params);
  });
  js.onMessage("api.path.basenameWithoutExtension", (dynamic args){
    final String params = args;
    return p.basenameWithoutExtension(params);
  });
  js.onMessage("api.path.dirname", (dynamic args){
    final String params = args;
    return p.dirname(params);
  });
  js.onMessage("api.path.extension", (dynamic args){
    final List<dynamic> params = args;
    return p.extension(params[0], params[1]);
  });
  js.onMessage("api.path.rootPrefix", (dynamic args){
    final String params = args;
    return p.rootPrefix(params);
  });
  js.onMessage("api.path.isAbsolute", (dynamic args){
    final String params = args;
    return p.isAbsolute(params);
  });
  js.onMessage("api.path.isRelative", (dynamic args){
    final String params = args;
    return p.isRelative(params);
  });
  js.onMessage("api.path.isRootRelative", (dynamic args){
    final String params = args;
    return p.isRootRelative(params);
  });
  js.onMessage("api.path.split", (dynamic args){
    final String params = args;
    return p.split(params);
  });
  js.onMessage("api.path.canonicalize", (dynamic args){
    final String params = args;
    return p.canonicalize(params);
  });
  js.onMessage("api.path.normalize", (dynamic args){
    final String params = args;
    return p.normalize(params);
  });
  js.onMessage("api.path.isWithin", (dynamic args){
    final List<String> params = List<String>.from(args);
    return p.isWithin(params[0], params[1]);
  });
  js.onMessage("api.path.equals", (dynamic args){
    final List<String> params = List<String>.from(args);
    return p.equals(params[0], params[1]);
  });
  js.onMessage("api.path.withoutExtension", (dynamic args){
    final String params = args;
    return p.withoutExtension(params);
  });
  js.onMessage("api.path.setExtension", (dynamic args){
    final List<String> params = List<String>.from(args);
    return p.setExtension(params[0], params[1]);
  });
  js.onMessage("api.path.fromUri", (dynamic args){
    final String params = args;
    return p.fromUri(params);
  });
  js.onMessage("api.path.toUri", (dynamic args){
    final String params = args;
    return p.toUri(params);
  });

  // file_system
  js.onMessage("api.file_system.exists", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canExists(permission),
      fn: () => fs.exists(params[0], params[1]),
    );
  });
  js.onMessage("api.file_system.isFile", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canIsFile(permission),
      fn: () => fs.isFile(params[0], params[1]),
    );
  });
  js.onMessage("api.file_system.isDir", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canIsDir(permission),
      fn: () => fs.isDir(params[0], params[1]),
    );
  });
  js.onMessage("api.file_system.isLink", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canIsLink(permission),
      fn: () => fs.isLink(params[0], params[1]),
    );
  });
  js.onMessage("api.file_system.identical", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canIdentical(permission),
      fn: () => fs.identical(params[0], params[1], params[2]),
    );
  });
  js.onMessage("api.file_system.stat", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canStat(permission),
      fn: () => fs.stat(params[0], params[1]),
    );
  });
  js.onMessage("api.file_system.list", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canList(permission),
      fn: () => fs.list(params[0], params[1], params[2], params[3]),
    );
  });
  js.onMessage("api.file_system.readString", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canReadString(permission),
      fn: () => fs.readString(params[0], params[1], params[2]),
    );
  });
  js.onMessage("api.file_system.readLines", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canReadLines(permission),
      fn: () => fs.readLines(params[0], params[1], params[2]),
    );
  });
  js.onMessage("api.file_system.readBytes", (dynamic args){
    final List params = args;
    return requirePermissionThenRun(
      canCall: () => fs.canReadBytes(permission),
      fn: () => fs.readBytes(params[0], params[2]),
    );
  });

  // windows_registry
  js.onMessage("api.windowsRegistry.HKEY_CLASSES_ROOT", (_){
    return wr.HKEY_CLASSES_ROOT;
  });
  js.onMessage("api.windowsRegistry.HKEY_CURRENT_USER", (_){
    return wr.HKEY_CURRENT_USER;
  });
  js.onMessage("api.windowsRegistry.HKEY_LOCAL_MACHINE", (_){
    return wr.HKEY_LOCAL_MACHINE;
  });
  js.onMessage("api.windowsRegistry.HKEY_USERS", (_){
    return wr.HKEY_USERS;
  });
  js.onMessage("api.windowsRegistry.HKEY_PERFORMANCE_DATA", (_){
    return wr.HKEY_PERFORMANCE_DATA;
  });
  js.onMessage("api.windowsRegistry.HKEY_CURRENT_CONFIG", (_){
    return wr.HKEY_CURRENT_CONFIG;
  });
  js.onMessage("api.windowsRegistry.readString", (dynamic args){
    final List<dynamic> params = args;
    return requirePermissionThenRun(
      canCall: () => wr.canReadString(permission),
      fn: () => wr.readString(params[0], params[1], params[2]),
    );
  });
  js.onMessage("api.windowsRegistry.readMultiString", (dynamic args){
    final List<dynamic> params = args;
    return requirePermissionThenRun(
      canCall: () => wr.canReadMultiString(permission),
      fn: () => wr.readMultiString(params[0], params[1], params[2]),
    );
  });
  js.onMessage("api.windowsRegistry.readInt", (dynamic args){
    final List<dynamic> params = args;
    return requirePermissionThenRun(
      canCall: () => wr.canReadInt(permission),
      fn: () => wr.readInt(params[0], params[1], params[2]),
    );
  });
  js.onMessage("api.windowsRegistry.readBinary", (dynamic args){
    final List<dynamic> params = args;
    return requirePermissionThenRun(
      canCall: () => wr.canReadBinary(permission),
      fn: () => wr.readBinary(params[0], params[1], params[2]),
    );
  });

  final String ffi = await rootBundle.loadString("assets/plugin/ffi_js.js");
  final JsEvalResult result = js.evaluate(ffi);
  if(result.isError){
    throw InjectionFailedException("JS", result.stringResult);
  }
}