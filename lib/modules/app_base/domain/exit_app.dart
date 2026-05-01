

import "dart:async";
import "dart:io";

import "package:bitsdojo_window/bitsdojo_window.dart";

final List<FutureOr Function()> _runBeforeExitApp = [];

void onExitApp(FutureOr Function() fn){
  _runBeforeExitApp.add(fn);
}

Future<void> exitApp() async{
  for(final fn in _runBeforeExitApp){
    await fn();
  }

  // await AppState.save();

  if(Platform.isWindows || Platform.isLinux || Platform.isMacOS){
    appWindow.close();
  }else{
    exit(0);
  }
}