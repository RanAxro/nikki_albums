import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/frame.dart";
import "package:nikkialbums/api/system/system.dart";

import "package:flutter/material.dart";
import "dart:ui";

import "package:easy_localization/easy_localization.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";

void main() async{

  await initState();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  doWhenWindowReady(() async{
    final win = appWindow;

    final dpr = PlatformDispatcher.instance.views.first.devicePixelRatio;
    final (int screenX, int screenY) = getWindowsScreenSize();
    win.size = Size(0.7 * screenX / dpr, 0.7 * screenY / dpr);

    win.minSize = Size(0, 0);
    win.alignment = Alignment.center;
    win.title = "Nikki Albums";
    win.show();
  });

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
}