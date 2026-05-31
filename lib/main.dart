

import "dart:ffi" hide Size;

import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';
import 'package:nikki_albums/src/rust/api/simple.dart';
import 'package:nikki_albums/src/rust/frb_generated.dart';


import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/utils/system/system_service_windows.dart";
import "package:nikki_albums/utils/system/system_service_macos.dart";
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

  if(Platform.isWindows){
    SystemFactory.register(WindowsSystemServices());
  }else if (Platform.isMacOS){
    SystemFactory.register(MacOsSystemServices());
  }

  MediaKit.ensureInitialized();

  if(!kDebugMode){
    if(Platform.isWindows){
      await WindowsSingleInstance.ensureSingleInstance(
        args,
        "com_ranaxro_nikki_nikkialbums",
        onSecondWindow: parseArgs,
      );
    }
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

  if(Platform.isWindows || Platform.isMacOS){
    WidgetsBinding.instance.addPostFrameCallback((_){
      doWhenWindowReady((){
        final win = appWindow;
        final initialSize = win.size;
        
        // 专门修复 Windows 隐藏启动时的白屏 Bug：在显示前微调一次尺寸强制引擎同步
        if(Platform.isWindows){
          win.size = Size(initialSize.width, initialSize.height + 1);
          win.size = initialSize;
        }

        win.minSize = const Size(0, 0);
        win.alignment = Alignment.center;
        win.title = "Nikki Albums";
        win.show();
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
