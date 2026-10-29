
import "dart:ui";

import "package:forui/forui.dart";
import "package:nikki_albums/base/app_scope.dart";
import "package:nikki_albums/configuration.dart";
import "package:nikki_albums/modules/app_base/domain/lang_asset_loader.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/modules/frame/frame.dart";
import "package:nikki_albums/modules/frame/presentation/header/header_windows.dart";
import "package:nikki_albums/modules/frame/presentation/nav/nav_desktop.dart";
import "package:nikki_albums/modules/setting/error_log/domain/log_manager.dart";
import "package:nikki_albums/utils/system/system.dart";
import "package:nikki_albums/utils/system/system_service_windows.dart";
import "package:nikki_albums/utils/system/system_service_macos.dart";
import "package:nikki_albums/gen/rust/frb_generated.dart";

import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "dart:io";
import "dart:isolate";
import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:nikki_albums/widgets/app/component.dart";
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

    // 用 zone 包裹整个启动流程与 runApp，捕获未处理的异步错误
    runZonedGuarded(() => appMain(args), (Object error, StackTrace stack){
      AppLogger.crash("Zone", error.toString(), stack.toString());
    });
  }

  if(kDebugMode){
    appMain(args);
  }
}

void appMain(List<String> args) async{
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

  if(Platform.isWindows || Platform.isMacOS){
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      center: true,
      title: "Nikki Albums",
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async{
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await AppLangAssetLoader().load("assets/lang", Locale("zh", "TW"));

  // runApp(
  //   EasyLocalization(
  //     supportedLocales: const [
  //       Locale("zh", "CN"),
  //       Locale("en", "US"),
  //       Locale("fr", "FR"),
  //       Locale("de", "DE"),
  //       Locale("id", "ID"),
  //       Locale("it", "IT"),
  //       Locale("ja", "JP"),
  //       Locale("ko", "KR"),
  //       Locale("pt", "BR"),
  //       Locale("es", "ES"),
  //       Locale("th", "TH"),
  //       Locale("zh", "TW"),
  //     ],
  //     path: "assets/lang",
  //     // startLocale: Locale("en", "US"),
  //     fallbackLocale: Locale("en", "US"),
  //     useFallbackTranslations: true,
  //     useFallbackTranslationsForEmptyResources: true,
  //     saveLocale: false,
  //     assetLoader: AppLangAssetLoader(),
  //     child: Frame(ancestor),
  //   ),
  // );

  runApp(AppScope(
    configuration: configuration,
    // child: FScaffold(
    //   scaffoldStyle: .delta(
    //     childPadding: .value(.zero),
    //   ),
    //   header: Builder(
    //     builder: (BuildContext context){
    //       return ColoredBox(
    //         color: context.theme.colors.muted,
    //         child: WindowsTitleBar(),
    //       );
    //     },
    //   ),
    //   child: FResizable(
    //     axis: Axis.horizontal,
    //     divider: FResizableDivider.divider,
    //     children: [
    //       FResizableRegion.fixed(
    //         extent: 200,
    //         minExtent: 100,
    //         builder: (context, data, _) => DesktopSidebar(),
    //       ),
    //       FResizableRegion.flex(
    //         builder: (context, data, _) => Align(
    //           child: Text('Content', style: context.theme.typography.body.sm),
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
  ));

  // runApp(AppScope(
  //   configuration: configuration,
  //   child: Builder(
  //     builder: (BuildContext context){
  //       return FScaffold(
  //         header: ColoredBox(
  //           color: context.theme.colors.muted,
  //           child: FHeader(
  //             style: FHeaderStyleDelta.delta(
  //               padding: EdgeInsetsGeometryDelta.value(.all(0)),
  //             ),
  //             title: Row(
  //               children: [
  //                 const Text('我的桌面应用'),
  //                 FPopover(
  //                   cutoutBuilder: FModalBarrier.defaultCutoutBuilder, // Replace this to create a custom cutout shape.
  //                   popoverAnchor: .topCenter,
  //                   childAnchor: .bottomCenter,
  //                   popoverBuilder: (context, _) => Padding(
  //                     padding: const .only(left: 20, top: 14, right: 20, bottom: 10),
  //                     child: SizedBox(
  //                       width: 288,
  //                       child: Column(
  //                         mainAxisSize: .min,
  //                         crossAxisAlignment: .start,
  //                         children: [
  //                           Text('Dimensions', style: context.theme.typography.body.md),
  //                           const SizedBox(height: 7),
  //                           Text(
  //                             'Set the dimensions for the layer.',
  //                             style: context.theme.typography.body.sm.copyWith(
  //                               color: context.theme.colors.mutedForeground,
  //                               fontWeight: .w300,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 15),
  //                           for (final (index, (label, value)) in [
  //                             ('Width', '100%'),
  //                             ('Max. Width', '300px'),
  //                             ('Height', '25px'),
  //                             ('Max. Height', 'none'),
  //                           ].indexed) ...[
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: Text(
  //                                     label,
  //                                     style: context.theme.typography.body.sm,
  //                                   ),
  //                                 ),
  //                                 Expanded(
  //                                   flex: 2,
  //                                   child: FTextField(
  //                                     control: .managed(
  //                                       initial: TextEditingValue(text: value),
  //                                     ),
  //                                     autofocus: index == 0,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             const SizedBox(height: 7),
  //                           ],
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   builder: (_, controller, _) => FButton(
  //                     variant: .outline,
  //                     size: .sm,
  //                     mainAxisSize: .min,
  //                     onPress: controller.toggle,
  //                     child: ConstrainedBox(
  //                       constraints: BoxConstraints.tightFor(width: 200),
  //                       child: Row(
  //                         spacing: 10,
  //                         children: [
  //                           FAvatar.raw(
  //                             size: 20,
  //                             child: Icon(
  //                               FLucideIcons.userRound,
  //                               size: 18,
  //                               color: context.theme.colors.mutedForeground,
  //                             ),
  //                           ),
  //                           Text(
  //                             'Dash',
  //                             style: context.theme.typography.body.sm.copyWith(
  //                               fontWeight: .bold,
  //                               color: context.theme.colors.foreground,
  //                             ),
  //                             overflow: .ellipsis,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             suffixes: [
  //               FHeaderAction(
  //                 icon: const Icon(FLucideIcons.minus),
  //                 onPress: () => windowManager.minimize(),
  //               ),
  //               FHeaderAction(
  //                 icon: const Icon(FLucideIcons.square), // 或自定义最大化/还原图标
  //                 onPress: () async {
  //                   if (await windowManager.isMaximized()) {
  //                     await windowManager.unmaximize();
  //                   } else {
  //                     await windowManager.maximize();
  //                   }
  //                 },
  //               ),
  //               FHeaderAction(
  //                 icon: const Icon(FLucideIcons.x),
  //                 onPress: () => windowManager.close(),
  //               ),
  //             ],
  //           ),
  //         ),
  //         child: ColoredBox(
  //           color: context.theme.colors.background,
  //           child: FScaffold(
  //             sidebar: FSidebar(
  //               footer: Padding(
  //                 padding: const .symmetric(horizontal: 16),
  //                 child: FCard(
  //                   child: Padding(
  //                     padding: const .symmetric(vertical: 12, horizontal: 16),
  //                     child: Row(
  //                       spacing: 10,
  //                       children: [
  //                         FAvatar.raw(
  //                           child: Icon(
  //                             FLucideIcons.userRound,
  //                             size: 18,
  //                             color: context.theme.colors.mutedForeground,
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: .start,
  //                             spacing: 2,
  //                             children: [
  //                               Text(
  //                                 'Dash',
  //                                 style: context.theme.typography.body.sm.copyWith(
  //                                   fontWeight: .bold,
  //                                   color: context.theme.colors.foreground,
  //                                 ),
  //                                 overflow: .ellipsis,
  //                               ),
  //                               Text(
  //                                 'dash@forui.dev',
  //                                 style: context.theme.typography.body.xs.copyWith(
  //                                   color: context.theme.colors.mutedForeground,
  //                                 ),
  //                                 overflow: .ellipsis,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               children: [
  //                 FSidebarGroup(
  //                   label: const Text('Overview'),
  //                   children: [
  //                     FSidebarItem(
  //                       icon: const Icon(FLucideIcons.school),
  //                       label: const Text('Getting Started'),
  //                       initiallyExpanded: true,
  //                       onPress: () {},
  //                       children: [
  //                         FSidebarItem(
  //                           label: const Text('Installation'),
  //                           selected: true,
  //                           onPress: () {},
  //                         ),
  //                         FSidebarItem(label: const Text('Themes'), onPress: () {}),
  //                         FSidebarItem(label: const Text('Typography'), onPress: () {}),
  //                       ],
  //                     ),
  //                     FSidebarItem(
  //                       icon: const Icon(FLucideIcons.code),
  //                       label: const Text('API Reference'),
  //                       onPress: () {},
  //                     ),
  //                     FSidebarItem(
  //                       icon: const Icon(FLucideIcons.box),
  //                       label: const Text('Pub Dev'),
  //                       onPress: () {},
  //                     ),
  //                   ],
  //                 ),
  //                 FSidebarGroup(
  //                   action: const Icon(FLucideIcons.plus),
  //                   onActionPress: () {},
  //                   label: const Text('Widgets'),
  //                   children: [
  //                     FSidebarItem(
  //                       icon: const Icon(FLucideIcons.circleSlash),
  //                       label: const Text('Divider'),
  //                       onPress: () {},
  //                     ),
  //                     FSidebarItem(
  //                       icon: const Icon(FLucideIcons.scaling),
  //                       label: const Text('Resizable'),
  //                       onPress: () {},
  //                     ),
  //                     FSidebarItem(
  //                       icon: const Icon(FLucideIcons.layoutDashboard),
  //                       label: const Text('Scaffold'),
  //                       onPress: () {},
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             child: Padding(
  //               padding: const .symmetric(vertical: 14),
  //               child: Column(
  //                 crossAxisAlignment: .start,
  //                 spacing: 12,
  //                 children: [
  //                   FBreadcrumb(
  //                     children: [
  //                       FBreadcrumbItem(onPress: () {}, child: const Text('Forui')),
  //                       FBreadcrumbItem.collapsed(
  //                         menu: [
  //                           FItemGroup(
  //                             children: [
  //                               FItem(title: const Text('Documentation'), onPress: () {}),
  //                               FItem(title: const Text('Themes'), onPress: () {}),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       FBreadcrumbItem(onPress: () {}, child: const Text('Overview')),
  //                       const FBreadcrumbItem(current: true, child: Text('Installation')),
  //                     ],
  //                   ),
  //                   Expanded(
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color: context.theme.colors.muted,
  //                         borderRadius: context.theme.style.borderRadius.md,
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     flex: 3,
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color: context.theme.colors.muted,
  //                         borderRadius: context.theme.style.borderRadius.md,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   ),
  // ));
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
