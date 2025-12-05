import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/frame.dart";

import "package:flutter/material.dart";

import "package:easy_localization/easy_localization.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";

void main() async{

  await initState();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  doWhenWindowReady(() async{
    final win = appWindow;
    // final Size screenSize = getScreenSize();
    // win.size = Size(0.5 * screenSize.width / dpr, 0.5 * screenSize.height / dpr);
    // win.minSize = Size(0.3 * screenSize.width / dpr, 0.3 * screenSize.height / dpr);
    win.size = Size(700, 500);
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