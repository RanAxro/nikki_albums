

import "dart:ffi" hide Size;

import 'package:flutter/material.dart';
import 'package:nikki_albums/src/rust/api/simple.dart';
import 'package:nikki_albums/src/rust/frb_generated.dart';


import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/utils/system/system.dart";

import "package:flutter/material.dart";
import "dart:ui" hide Path;
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";
import "package:windows_single_instance/windows_single_instance.dart";
import "package:media_kit/media_kit.dart";


void main(List<String> args) async{

  await RustLib.init();

  WidgetsFlutterBinding.ensureInitialized();

  MediaKit.ensureInitialized();

  // if(Platform.isWindows){
  //   await WindowsSingleInstance.ensureSingleInstance(
  //     args,
  //     "com_ranaxro_nikki_nikkialbums",
  //     onSecondWindow: parseArgs,
  //   );
  // }
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
    WidgetsBinding.instance.addPostFrameCallback((_){
      doWhenWindowReady((){
        appWindow.minSize = Size(0, 0);
        appWindow.alignment = Alignment.center;
        appWindow.title = "Nikki Albums";
        appWindow.show();
      });
    });

    // doWhenWindowReady(() async{
    //   WidgetsBinding.instance.addPostFrameCallback((_){
    //     // double dpr = 1;
    //     // try{
    //     //   dpr = PlatformDispatcher.instance.views.first.devicePixelRatio;
    //     //   dpr = dpr == 0 ? 1 : dpr;
    //     // }catch(e){
    //     //   dpr = 1;
    //     // }
    //     // final (int screenX, int screenY) = getWindowsScreenSize();
    //     // appWindow.size = Size(0.7 * screenX / dpr, 0.7 * screenY / dpr);
    //
    //     appWindow.minSize = Size(0, 0);
    //     appWindow.alignment = Alignment.center;
    //     appWindow.title = "Nikki Albums";
    //     appWindow.show();
    //
    //     // Future.delayed(const Duration(milliseconds: 500)).then((_){
    //     //   appWindow.size = appWindow.size;
    //     //   appWindow.show();
    //     //
    //     //   Future.delayed(const Duration(milliseconds: 500)).then((_){
    //     //     appWindow.size = appWindow.size;
    //     //     appWindow.show();
    //     //
    //     //     Future.delayed(const Duration(milliseconds: 500)).then((_){
    //     //       appWindow.size = appWindow.size;
    //     //       appWindow.show();
    //     //
    //     //       Future.delayed(const Duration(milliseconds: 1000)).then((_){
    //     //         appWindow.size = appWindow.size;
    //     //         appWindow.show();
    //     //       });
    //     //     });
    //     //   });
    //     // });
    //
    //   });
    // });

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
