
import "../modules/frame/presentation/header/header_windows.dart";
import "../modules/frame/presentation/nav/nav_desktop.dart";

import "package:flutter/material.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";


abstract final class AppRoutes{
  static const String bootstrap = "/bootstrap";
  static const String bootstrapName = "bootstrap";
  static const String home = "/";
  static const String homeName = "home";
  static const String albumManagerAlbum = "/album_manager/album";
  static const String albumManagerAlbumName = "album_manager_album";
  static const String albumManagerSimilarImageFinder = "/album_manager/similar_image_finder";
  static const String albumManagerSimilarImageFinderName = "album_manager_similar_image_finder";
  static const String albumManagerBackup = "/album_manager/backup";
  static const String albumManagerBackupName = "album_manager_backup";
  static const String albumManagerRecycleBin = "/album_manager/recycle_bin";
  static const String albumManagerRecycleBinName = "album_manager_recycle_bin";
  static const String albumManagerConfig = "/album_manager/config";
  static const String albumManagerConfigName = "album_manager_config";
  static const String parameterManagerInfinityNikki = "/parameter_manager/infinity_nikki";
  static const String parameterManagerInfinityNikkiName = "parameter_manager_infinity_nikki";
  static const String parameterManagerInfinityNikkiCameraParameterCode = "/parameter_manager/infinity_nikki_camera_parameter_code";
  static const String parameterManagerInfinityNikkiCameraParameterCodeName = "parameter_manager_infinity_nikki_camera_parameter_code";
  static const String parameterManagerInfinityNikkiClothDiyShareCode = "/parameter_manager/infinity_nikki_cloth_diy_share_code";
  static const String parameterManagerInfinityNikkiClothDiyShareCodeName = "parameter_manager_infinity_nikki_cloth_diy_share_code";
  static const String parameterManagerInfinityNikkiHomeBuildShareCode = "/parameter_manager/infinity_nikki_home_build_share_code";
  static const String parameterManagerInfinityNikkiHomeBuildShareCodeName = "parameter_manager_infinity_nikki_home_build_share_code";
  static const String parameterManagerInfinityNikkiRecycleBin = "/parameter_manager/infinity_nikki_recycle_bin";
  static const String parameterManagerInfinityNikkiRecycleBinName = "parameter_manager_infinity_nikki_recycle_bin";

  static const String settings = "/settings";
  static const String settingsName = "settings";
}


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: "root",
);

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.bootstrap,
  debugLogDiagnostics: true,
  routes: [
    ShellRoute(
      builder: (context, state, child){
        return FScaffold(
          scaffoldStyle: .delta(
            childPadding: .value(.zero),
          ),
          header: Builder(
            builder: (BuildContext context){
              return ColoredBox(
                color: context.theme.colors.muted,
                child: WindowsTitleBar(),
              );
            },
          ),
          child: child,
        );
      },
      routes: [
        /// 启动页
        GoRoute(
          path: AppRoutes.bootstrap,
          name: AppRoutes.bootstrapName,
          builder: (context, state){
            return Align(
              child: FButton(
                onPress: (){
                  context.go(AppRoutes.home);
                },
                child: Text("加载中"),
              ),
            );
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell){
            return MainShell(navigationShell: navigationShell);
          },
          branches: appShellRoutes,
        ),
      ],
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Text(state.uri.toString());
    // return RouteErrorPage(location: state.uri.toString());
  },
);

final List<StatefulShellBranch> appShellRoutes = [
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (BuildContext context, GoRouterState state){
          return Text("主页");
        },
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.albumManagerAlbum,
        name: AppRoutes.albumManagerAlbumName,
        builder: (BuildContext context, GoRouterState state){
          return Text("相册");
        },
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.albumManagerConfig,
        name: AppRoutes.albumManagerConfigName,
        builder: (BuildContext context, GoRouterState state){
          return Text("配置项");
        },
      ),
    ],
  ),
];


class MainShell extends StatelessWidget{
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context){
    return FResizable(
      axis: Axis.horizontal,
      divider: FResizableDivider.divider,
      children: [
        FResizableRegion.fixed(
          extent: 200,
          minExtent: 100,
          builder: (context, data, _) => DesktopSidebar(navigationShell: navigationShell),
        ),
        FResizableRegion.flex(
          builder: (context, data, _) => Align(
            child: navigationShell,
          ),
        ),
      ],
    );
  }
}

