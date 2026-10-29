
import "package:nikki_albums/ui/constants.dart";

import "package:flutter/widgets.dart";

import "package:forui/forui.dart";


class AlbumPage extends StatelessWidget{
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        SizedBox(
          height: albumTopBarHeight,
          child: Padding(
            padding: .all(4),
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: FSelect<String>.rich(
                    hint: 'Type',
                    contentDivider: .full,
                    format: (s) => s,
                    contentConstraints: const FPortalConstraints(
                      minWidth: 200,
                      maxWidth: 300,
                      maxHeight: double.infinity,
                    ),
                    children: [

                      FSelectItemMixin.richSection(
                        label: Text("大喵相册"),
                        children: [
                          FSelectItem.item(
                            prefix: const Icon(FLucideIcons.bug),
                            title: const Text('暖暖相册'),
                            subtitle: const Text('An unexpected problem or behavior'),
                            value: '暖暖相册',
                          ),
                          FSelectItem.item(
                            prefix: const Icon(FLucideIcons.filePlusCorner),
                            title: const Text('动态影集'),
                            subtitle: const Text('A new feature or enhancement'),
                            value: '动态影集',
                          ),
                          FSelectItem.item(
                            prefix: const Icon(FLucideIcons.messageCircleQuestionMark),
                            title: const Text('旅行手账'),
                            subtitle: const Text('A question or clarification'),
                            value: '旅行手账',
                          ),
                          FSelectItem.item(
                            prefix: const Icon(FLucideIcons.messageCircleQuestionMark),
                            title: const Text('拼贴'),
                            subtitle: const Text('A question or clarification'),
                            value: '拼贴',
                          ),
                        ],
                      ),

                      FSelectItemMixin.richSection(
                          label: SizedBox(),
                          children: [

                                .item(
                              prefix: const Icon(FLucideIcons.bug),
                              title: const Text('星绘图册'),
                              subtitle: const Text('An unexpected problem or behavior'),
                              value: '星绘图册',
                            ),
                                .item(
                              prefix: const Icon(FLucideIcons.filePlusCorner),
                              title: const Text('云缓存'),
                              subtitle: const Text('A new feature or enhancement'),
                              value: '云缓存',
                            ),
                                .item(
                              prefix: const Icon(FLucideIcons.messageCircleQuestionMark),
                              title: const Text('头像'),
                              subtitle: const Text('A question or clarification'),
                              value: '头像',
                            ),
                                .item(
                              prefix: const Icon(FLucideIcons.messageCircleQuestionMark),
                              title: const Text('名片'),
                              subtitle: const Text('A question or clarification'),
                              value: '名片',
                            ),
                          ]
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),

        const FDivider(
          style: .delta(
            padding: .value(.all(0))
          ),
        ),
        
        Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }
}