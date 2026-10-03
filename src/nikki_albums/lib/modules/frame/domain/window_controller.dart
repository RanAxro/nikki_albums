
import "package:window_manager/window_manager.dart";


Future<void> top(bool isTop) async{
  await windowManager.setAlwaysOnTop(isTop);
}

Future<void> minimize() async{
  await windowManager.minimize();
}

Future<void> maximizeOrRestore() async{
  if(await windowManager.isMaximized()){
    await windowManager.unmaximize();
  }else{
    await windowManager.maximize();
  }
}

Future<void> close() async{
  await windowManager.close();
}