
import "package:nikki_albums/src/rust/nuan5_media_param/decode.dart";
import "package:nikki_albums/src/rust/nuan5_media_param/decrypt.dart";

import "package:nikki_albums/widgets/app/component.dart";
import "package:flutter/material.dart";

import "../../../nuan5_params/domain/tree_node_generator.dart";
import "../../../nuan5_params/presentation/media_params_tree.dart";



class AppStateDebug extends StatelessWidget{
  const AppStateDebug({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        children: [
          AppButton.smallText(
            onClick: () async{
              // print((await getPluginDirectory()).path);

              final MediaKey key = MediaKey.fromStr("108328049");
              final MediaCustomData? d = await mediaDeFileUnchecked(paramType: MediaParamType.nikkiPhoto, path: r"E:\game\InfinityNikki\InfinityNikki Launcher\InfinityNikki\X6Game\Saved\GamePlayPhotos\108328049\NikkiPhotos_HighQuality\2026_05_30_22_36_10_254303.jpeg", key: key);
              if(d != null){
                d.whenOrNull(
                    valid: (MediaParam params){
                      params.whenOrNull(
                          nikkiPhoto: (nikki){
                            genNikkiPhotoParams(nikki);
                            showAppDialog(context: context, builder: (c){
                              return AppDialog(
                                useIntrinsicHeight: false,
                                child: TreeViewPage(root: [genNikkiPhotoParams(nikki)]),
                              );
                            });
                          }
                      );
                    }
                );
              }
              key.dispose();

              // showAppDialog(context: context, builder: (c){
              //   return TreeViewPage();
              // });

              // await buildPlugin(builderConfig, Directory(r"E:\work\nikki_albums_file\plugin"));
              //
              // final p = await loadPlugin(Directory(r"E:\work\nikki_albums_file\plugin\05d5e067-ac1a-44c2-9f87-5ccaae613954"));
              // print(p?.enable);
              // print(p?.langPathList);
              // print(p?.iconPathList);
              // print(p?.gameConfigList);


              // serializeGameConfig(value: infinityNikkiConfig, pretty: true).then((v){
              //   File(r"E:\work\nikki_albums_file\game_config.json").writeAsBytes(v);
              // });
              //
              // print(greet(name: "rust"));
              //
              // print(testAdd(num1: 12, num2: 13));

              // final files = await Directory(r"E:\game\InfinityNikki\InfinityNikki Launcher\InfinityNikki\X6Game\Saved\GamePlayPhotos\108328049\NikkiPhotos_HighQuality").list().map((f) => f.path).toList();
              //
              // final MediaKey key = MediaKey.fromStr("108328049");
              // final stopwatch = Stopwatch()..start();
              // await for(final data in mediaDeFilesUnchecked(paramType: MediaParamType.nikkiPhoto, paths: files, key: key)){
              //   if(data.data != null){
              //     data.data!.whenOrNull(
              //       valid: (params){
              //         params.whenOrNull(
              //           nikkiPhoto: (nik){
              //             print(nik.camera?.params);
              //           }
              //         );
              //       }
              //     );
              //   }
              // }
              // key.dispose();
              // stopwatch.stop();
              // print('函数运行时长: ${stopwatch.elapsedMilliseconds} ms');

            },
            child: RichText(
              text: TextSpan(
                text: '\u{f06e}\u{f06d}\u{f050}',
                style: TextStyle(fontFamily: 'RanAppKey', fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}