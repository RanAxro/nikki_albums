
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";
import "package:nikki_albums/base/app_router.dart";


class DesktopSidebar extends ConsumerWidget{
  final StatefulNavigationShell navigationShell;

  const DesktopSidebar({
    super.key,
    required this.navigationShell,
  });

  int _getIndex(String path){
    return appShellRoutes.indexWhere((StatefulShellBranch branch){
      return branch.routes.any((RouteBase route){
        assert(route is GoRoute);
        return (route as GoRoute).path == path;
      });
    });
  }

  Widget _buildLeafFSidebarItem({
    required String path,
    Widget? icon,
    Widget? label,
  }){
    final int index = _getIndex(path);

    return FSidebarItem(
      icon: icon,
      label: label,
      selected: navigationShell.currentIndex == index,
      onPress: (){
        assert(index >= 0, "Sidebar StatefulShellBranch 缺失: $path");
        navigationShell.goBranch(index);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return FSidebar(
      // footer: Padding(
      //   padding: const .symmetric(horizontal: 16),
      //   child: FCard(
      //     child: Padding(
      //       padding: const .symmetric(vertical: 12, horizontal: 16),
      //       child: Row(
      //         spacing: 10,
      //         children: [
      //           FAvatar.raw(
      //             child: Icon(
      //               FLucideIcons.userRound,
      //               size: 18,
      //               color: context.theme.colors.mutedForeground,
      //             ),
      //           ),
      //           Expanded(
      //             child: Column(
      //               crossAxisAlignment: .start,
      //               spacing: 2,
      //               children: [
      //                 Text(
      //                   'Dash',
      //                   style: context.theme.typography.body.sm.copyWith(
      //                     fontWeight: .bold,
      //                     color: context.theme.colors.foreground,
      //                   ),
      //                   overflow: .ellipsis,
      //                 ),
      //                 Text(
      //                   'dash@forui.dev',
      //                   style: context.theme.typography.body.xs.copyWith(
      //                     color: context.theme.colors.mutedForeground,
      //                   ),
      //                   overflow: .ellipsis,
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      children: [
        FSidebarGroup(
          children: [
            FSidebarItem(
              icon: const Icon(FLucideIcons.album),
              label: const Text("相册管理器"),
              initiallyExpanded: true,
              onPress: () {},
              children: [
                _buildLeafFSidebarItem(
                  path: AppRoutes.albumManagerAlbum,
                  label: const Text('游戏相册'),
                ),
                _buildLeafFSidebarItem(
                  path: AppRoutes.albumManagerSimilarImageFinder,
                  label: const Text('相似图查找'),
                ),
                _buildLeafFSidebarItem(
                  path: AppRoutes.albumManagerBackup,
                  label: const Text('相册备份'),
                ),
                _buildLeafFSidebarItem(
                  path: AppRoutes.albumManagerRecycleBin,
                  label: const Text('回收站'),
                ),
                _buildLeafFSidebarItem(
                  path: AppRoutes.albumManagerConfig,
                  label: const Text('配置项'),
                ),
              ],
            ),
            FSidebarItem(
              icon: const Icon(FLucideIcons.album),
              label: const Text("参数管理器"),
              initiallyExpanded: true,
              onPress: () {},
              children: [
                FSidebarItem(
                  label: const Text('无限暖暖'),
                  onPress: () {},
                  children: [
                    _buildLeafFSidebarItem(
                      path: AppRoutes.parameterManagerInfinityNikkiCameraParameterCode,
                      label: const Text('相机参数'),
                    ),
                    _buildLeafFSidebarItem(
                      path: AppRoutes.parameterManagerInfinityNikkiClothDiyShareCode,
                      label: const Text('染色码'),
                    ),
                    _buildLeafFSidebarItem(
                      path: AppRoutes.parameterManagerInfinityNikkiHomeBuildShareCode,
                      label: const Text('家园码'),
                    ),
                    _buildLeafFSidebarItem(
                      path: AppRoutes.parameterManagerInfinityNikkiRecycleBin,
                      label: const Text('配置项'),
                    ),
                  ],
                ),
              ],
            ),
            FSidebarItem(
              icon: const Icon(FLucideIcons.album),
              label: const Text("壁纸"),
              onPress: () {},
            ),
          ],
        ),



        FSidebarGroup(
          label: const Text('其他'),
          children: [
            FSidebarItem(
              icon: const Icon(FLucideIcons.school),
              label: const Text('文件传输'),
              onPress: () {},
              children: [
                FSidebarItem(label: const Text('发送'), onPress: () {}),
                FSidebarItem(label: const Text('接收'), onPress: () {}),
                FSidebarItem(label: const Text('历史记录'), onPress: () {}),
              ],
            ),
            _buildLeafFSidebarItem(
              path: AppRoutes.plugin,
              icon: const Icon(FLucideIcons.settings),
              label: const Text('插件'),
            ),
            FSidebarItem(
              icon: const Icon(FLucideIcons.settings),
              label: const Text('设置'),
              onPress: () {},
            ),
          ],
        ),

        // FSidebarGroup(
        //   label: const Text('Overview'),
        //   children: [
        //     FSidebarItem(
        //       icon: const Icon(FLucideIcons.school),
        //       label: const Text('Getting Started'),
        //       initiallyExpanded: true,
        //       onPress: () {},
        //       children: [
        //         FSidebarItem(
        //           label: const Text('Installation'),
        //           selected: true,
        //           onPress: () {},
        //         ),
        //         FSidebarItem(label: const Text('Themes'), onPress: () {}),
        //         FSidebarItem(label: const Text('Typography'), onPress: () {}),
        //       ],
        //     ),
        //     FSidebarItem(
        //       icon: const Icon(FLucideIcons.code),
        //       label: const Text('API Reference'),
        //       onPress: () {},
        //     ),
        //     FSidebarItem(
        //       icon: const Icon(FLucideIcons.box),
        //       label: const Text('Pub Dev'),
        //       onPress: () {},
        //     ),
        //   ],
        // ),
        // FSidebarGroup(
        //   action: const Icon(FLucideIcons.plus),
        //   onActionPress: () {},
        //   label: const Text('Widgets'),
        //   children: [
        //     FSidebarItem(
        //       icon: const Icon(FLucideIcons.circleSlash),
        //       label: const Text('Divider'),
        //       onPress: () {},
        //     ),
        //     FSidebarItem(
        //       icon: const Icon(FLucideIcons.scaling),
        //       label: const Text('Resizable'),
        //       onPress: () {},
        //     ),
        //     FSidebarItem(
        //       icon: const Icon(FLucideIcons.layoutDashboard),
        //       label: const Text('Scaffold'),
        //       onPress: () {},
        //     ),
        //   ],
        // ),
      ],
    );
  }
}