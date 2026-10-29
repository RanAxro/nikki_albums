
export "registration.dart";
export "windows_registry.dart";

import "../../model/exception.dart";


T requirePermissionThenRun<T>({
  required bool Function() canCall,
  required T Function() fn,
  String? message,
}){
  if(!canCall()){
    throw PermissionDeniedException(fn.toString());
  }
  return fn();
}