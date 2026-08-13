

import "dart:async";
import "dart:io";
import "package:window_manager/window_manager.dart";
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
    await windowManager.close();
  }else{
    exit(0);
  }
}