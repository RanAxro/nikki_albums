
import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/frame.dart";
import "package:nikkialbums/utils/system/system.dart";

import "package:flutter/material.dart";
import "dart:ui" hide Path;
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";
import "package:windows_single_instance/windows_single_instance.dart";

void main(List<String> args) async{

  WidgetsFlutterBinding.ensureInitialized();

  if(Platform.isWindows){
    await WindowsSingleInstance.ensureSingleInstance(
      args,
      "com_ranaxro_nikki_nikkialbums",
      onSecondWindow: parseArgs,
    );
  }
  parseArgs(args);

  await EasyLocalization.ensureInitialized();

  await initApp();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale("zh", "CN"),
        Locale("en", "US"),
      ],
      path: "assets/lang",
      // startLocale: Locale("en", "US"),
      fallbackLocale: Locale("en", "US"),
      saveLocale: false,
      child: Frame(ancestor),
    )
  );

  if(Platform.isWindows){
    doWhenWindowReady(() async{
      WidgetsBinding.instance.addPostFrameCallback((_){
        double dpr = 1;
        try{
          dpr = PlatformDispatcher.instance.views.first.devicePixelRatio;
        }catch(e){
          dpr = 1;
        }
        final (int screenX, int screenY) = getWindowsScreenSize();
        appWindow.size = Size(0.7 * screenX / dpr, 0.7 * screenY / dpr);

        appWindow.minSize = Size(0, 0);
        appWindow.alignment = Alignment.center;
        appWindow.title = "Nikki Albums";
        appWindow.show();
      });
    });
  }
}



class StartupParam{
  final String? sfx;
  final bool wait;
  final List<String> normal;

  const StartupParam._(this.sfx, this.wait, this.normal);

  factory StartupParam(List<String> args){
    String? sfx;
    bool wait = false;
    List<String> normal = [];

    for(final String arg in args){
      /// -sfx=
      if(arg.toLowerCase().startsWith("-sfx=")){
        sfx = arg.substring("-sfx=".length);
      }
      /// -wait=
      else if(arg.toLowerCase().startsWith("-wait=")){
        if(arg.substring("-wait=".length) == "1"){
          wait = true;
        }
      }
      else{
        normal.add(arg);
      }
    }

    return StartupParam._(sfx, wait, normal);
  }
}
void parseArgs(List<String> args){
  final StartupParam params = StartupParam(args);

  AppState.sfxPath.value = params.sfx ?? AppState.sfxPath.value;
  AppState.nikkiasToBeParsed.value = params.normal.firstOrNull;
}




