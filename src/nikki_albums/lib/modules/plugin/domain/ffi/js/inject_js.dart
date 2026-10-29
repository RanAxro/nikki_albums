
import "../../api/api.dart";
import "../../permission/permission.dart";
import "../../../model/exception.dart";

import "package:flutter/services.dart" show rootBundle;

import "package:quickjs_engine/quickjs_engine.dart";


Future<void> injectJS(JavascriptRuntime js, Set<Object> permission) async{
  js.onMessage("api.registerLoc", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => canRegisterLoc(permission),
      fn: () => registerLoc(params),
    );
  });
  js.onMessage("api.registerGlobalLoc", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => canRegisterGlobalLoc(permission),
      fn: () => registerGlobalLoc(params),
    );
  });
  js.onMessage("api.registerIcon", (dynamic args){
    final List<String> params = List<String>.from(args);
    return requirePermissionThenRun(
      canCall: () => canRegisterIcon(permission),
      fn: () => registerIcon(params),
    );
  });
  js.onMessage("api.registerGlobalIcon", (dynamic args){
    final List<String> params = List<String>.from(args);
    return requirePermissionThenRun(
      canCall: () => canRegisterGlobalIcon(permission),
      fn: () => registerGlobalIcon(params),
    );
  });
  js.onMessage("api.registerFont", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => canRegisterFont(permission),
      fn: () => registerFont(params),
    );
  });
  js.onMessage("api.registerGlobalFont", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => canRegisterGlobalFont(permission),
      fn: () => registerGlobalFont(params),
    );
  });
  js.onMessage("api.registerGame", (dynamic args){
    final Map<String, String> params = Map<String, String>.from(args);
    return requirePermissionThenRun(
      canCall: () => canRegisterGame(permission),
      fn: () => registerGame(params),
    );
  });

  // windows_registry
  js.onMessage("api.windowsRegistry.HKEY_CLASSES_ROOT", (_){
    return HKEY_CLASSES_ROOT;
  });
  js.onMessage("api.windowsRegistry.HKEY_CURRENT_USER", (_){
    return HKEY_CURRENT_USER;
  });
  js.onMessage("api.windowsRegistry.HKEY_LOCAL_MACHINE", (_){
    return HKEY_LOCAL_MACHINE;
  });
  js.onMessage("api.windowsRegistry.HKEY_USERS", (_){
    return HKEY_USERS;
  });
  js.onMessage("api.windowsRegistry.HKEY_PERFORMANCE_DATA", (_){
    return HKEY_PERFORMANCE_DATA;
  });
  js.onMessage("api.windowsRegistry.HKEY_CURRENT_CONFIG", (_){
    return HKEY_CURRENT_CONFIG;
  });
  js.onMessage("api.windowsRegistry.readString", (dynamic args){
    final List<dynamic> params = args;
    return requirePermissionThenRun(
      canCall: () => canReadString(permission),
      fn: () => readString(params[0], params[1], params[2]),
    );
  });
  js.onMessage("api.windowsRegistry.readMultiString", (dynamic args){
    final List<dynamic> params = args;
    return requirePermissionThenRun(
      canCall: () => canReadMultiString(permission),
      fn: () => readMultiString(params[0], params[1], params[2]),
    );
  });
  js.onMessage("api.windowsRegistry.readInt", (dynamic args){
    final List<dynamic> params = args;
    return requirePermissionThenRun(
      canCall: () => canReadInt(permission),
      fn: () => readInt(params[0], params[1], params[2]),
    );
  });
  js.onMessage("api.windowsRegistry.readBinary", (dynamic args){
    final List<dynamic> params = args;
    return requirePermissionThenRun(
      canCall: () => canReadBinary(permission),
      fn: () => readBinary(params[0], params[1], params[2]),
    );
  });

  final String ffi = await rootBundle.loadString("assets/plugin/ffi_js.js");
  final JsEvalResult result = js.evaluate(ffi);
  if(result.isError){
    throw InjectionFailedException("JS", result.stringResult);
  }
}