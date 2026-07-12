
import "package:nikki_albums/modules/app_base/domain/lang_asset_loader.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/modules/setting/error_log/domain/log_manager.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/utils/system/system_service_windows.dart";
import "package:nikki_albums/utils/system/system_service_macos.dart";
import "package:nikki_albums/src/rust/frb_generated.dart";

import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "dart:io";
import "dart:isolate";
import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:window_manager/window_manager.dart";
import "package:windows_single_instance/windows_single_instance.dart";
import "package:media_kit/media_kit.dart";


void main(List<String> args) {
  if(!kDebugMode){
    // 最早挂载框架错误捕获，确保后续 init 阶段异常也能被记录
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppLogger.crash(
        "FlutterError",
        details.exceptionAsString(),
        details.stack.toString(),
      );
    };

    // Isolate 错误捕获（独立线程异常）
    Isolate.current.addErrorListener(
      RawReceivePort((dynamic pair) {
        final List<dynamic> data = pair as List<dynamic>;
        AppLogger.crash(
          "Isolate",
          data[0].toString(),
          data[1] is String ? data[1] as String : null,
        );
      }).sendPort,
    );
  }

  // 用 zone 包裹整个启动流程与 runApp，捕获未处理的异步错误
  runZonedGuarded(() async {
    await RustLib.init();

    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isWindows) {
      SystemFactory.register(WindowsSystemServices());
    } else if (Platform.isMacOS) {
      SystemFactory.register(MacOsSystemServices());
    }

    MediaKit.ensureInitialized();

    if (!kDebugMode) {
      if (Platform.isWindows) {
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

    if (Platform.isWindows || Platform.isMacOS) {
      await windowManager.ensureInitialized();
      WindowOptions windowOptions = const WindowOptions(
        size: Size(1280, 720),
        center: true,
        title: "Nikki Albums",
        titleBarStyle: TitleBarStyle.hidden,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale("zh", "CN"),
          Locale("en", "US"),
          Locale("fr", "FR"),
          Locale("de", "DE"),
          Locale("id", "ID"),
          Locale("it", "IT"),
          Locale("ja", "JP"),
          Locale("ko", "KR"),
          Locale("pt", "BR"),
          Locale("es", "ES"),
          Locale("th", "TH"),
          Locale("zh", "TW"),
        ],
        path: "assets/lang",
        // startLocale: Locale("en", "US"),
        fallbackLocale: Locale("en", "US"),
        useFallbackTranslations: true,
        useFallbackTranslationsForEmptyResources: true,
        saveLocale: false,
        assetLoader: AppLangAssetLoader(),
        child: Frame(ancestor),
      ),
    );
  }, (Object error, StackTrace stack) {
    if(kDebugMode){
      throw error;
    }
    AppLogger.crash("Zone", error.toString(), stack.toString());
  });
}

class StartupParam {
  final String? sfx;
  final bool force;
  final bool wait;
  final List<String> normal;

  const StartupParam._(this.sfx, this.force, this.wait, this.normal);

  factory StartupParam(List<String> args) {
    String? sfx;
    bool force = false;
    bool wait = false;
    List<String> normal = [];

    for (final String arg in args) {
      /// -sfx=
      if (arg.toLowerCase().startsWith("-sfx=")) {
        sfx = arg.substring("-sfx=".length);
      }
      /// -force
      else if (arg.toLowerCase().startsWith("-force")) {
        force = true;
      }
      /// -wait=
      else if (arg.toLowerCase().startsWith("-wait=")) {
        if (arg.substring("-wait=".length) == "1") {
          wait = true;
        }
      } else {
        normal.add(arg);
      }
    }

    return StartupParam._(sfx, force, wait, normal);
  }
}

void parseArgs(List<String> args) {
  final StartupParam params = StartupParam(args);

  AppState.sfxPath.value = params.sfx ?? AppState.sfxPath.value;
  AppState.nikkiasToBeParsed.value = params.normal.firstOrNull;
}
