
import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:file_picker/file_picker.dart";
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/src/rust/nuan5_media_param/decrypt.dart";
import "package:nikki_albums/utils/clipboard.dart";

import "package:nikki_albums/widgets/app/component.dart";
import "package:flutter/material.dart";

import "package:path/path.dart" as p;



class Nuan5DecryptionDebug extends StatelessWidget{
  const Nuan5DecryptionDebug({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        spacing: listSpacing,
        children: [
          ValueListenableBuilder(
            valueListenable: AppState.debugNuan5DecryptionOutput,
            builder: (BuildContext context, String? debugNuan5DecryptionOutput, Widget? child){
              return AppButton.smallText(
                onClick: () async{
                  final String? output = await FilePicker.platform.getDirectoryPath();
                  AppState.debugNuan5DecryptionOutput.value = output;
                },
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("解码后的decrypted.json文件输出文件夹", isTranslate: false),
                    ),

                    AppText(debugNuan5DecryptionOutput.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.debugNuan5DecryptionInput,
            builder: (BuildContext context, String? debugNuan5DecryptionInput, Widget? child){
              return AppButton.smallText(
                onClick: () async{
                  final FilePickerResult? output = await FilePicker.platform.pickFiles();
                  AppState.debugNuan5DecryptionInput.value = output?.paths.firstOrNull;
                },
                child: Row(
                  children: [
                    Expanded(
                      child: AppText("需要解码的媒体文件", isTranslate: false),
                    ),

                    AppText(debugNuan5DecryptionInput.toString(), isTranslate: false),
                  ],
                ),
              );
            },
          ),

          AppButton.smallText(
            onClick: () async{
              await copyTextToClipboard(base64Encode([0xff, 0xd9]));
              if(context.mounted){
                AppToast.showMessage(context: context, message: "已复制");
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: AppText("\\0xFF\\0xD9 的 base64", isTranslate: false),
                ),
                AppText(base64Encode([0xff, 0xd9]), isTranslate: false),
              ],
            ),
          ),
          AppButton.smallText(
            onClick: () async{
              await copyTextToClipboard(base64Encode(utf8.encode("%PAPERGAMES%")));
              if(context.mounted){
                AppToast.showMessage(context: context, message: "已复制");
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: AppText("%PAPERGAMES% 的 base64", isTranslate: false),
                ),
                AppText(base64Encode(utf8.encode("%PAPERGAMES%")), isTranslate: false),
              ],
            ),
          ),

          ValueListenableBuilder(
            valueListenable: AppState.debugNuan5DecryptionFlag,
            builder: (BuildContext context, String? debugNuan5DecryptionFlag, Widget? child){
              return AppTextFiled(
                labelText: "flag (请输入将flag进行Base64编码后的结果)",
                isTranslateLabel: false,
                controller: TextEditingController(text: debugNuan5DecryptionFlag ?? ""),
                onChanged: (String value){
                  AppState.debugNuan5DecryptionFlag.value = value;
                  print(AppState.debugNuan5DecryptionFlag.value);
                },
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: AppState.debugNuan5DecryptionKey,
            builder: (BuildContext context, String? debugNuan5DecryptionKey, Widget? child){
              return AppTextFiled(
                labelText: "解码密钥",
                isTranslateLabel: false,
                controller: TextEditingController(text: debugNuan5DecryptionKey ?? ""),
                onChanged: (String value){
                  AppState.debugNuan5DecryptionKey.value = value;
                },
              );
            },
          ),

          AppButton.smallText(
            onClick: () async{
              if(AppState.debugNuan5DecryptionOutput.value == null || AppState.debugNuan5DecryptionInput.value == null || AppState.debugNuan5DecryptionKey.value == null || AppState.debugNuan5DecryptionFlag.value == null){
                AppToast.showMessage(context: context, message: "值不能为null", state: false);
                return;
              }

              final MediaKey key = MediaKey.fromStr(AppState.debugNuan5DecryptionKey.value!);
              final flag = base64Decode(AppState.debugNuan5DecryptionFlag.value!);
              final CustomData? d = await mediaDecodeFileUnchecked(flag: flag, path: AppState.debugNuan5DecryptionInput.value!, key: key);
              if(d != null){
                d.when(
                  invalid: (){
                    AppToast.showMessage(context: context, message: "解码成功: Invalid Params");
                  },
                  valid: (Uint8List valid) async{
                    final String output = p.join(AppState.debugNuan5DecryptionOutput.value!, "decrypted.json");
                    await File(output).writeAsBytes(valid);
                    if(context.mounted){
                      AppToast.showMessage(context: context, message: "解码成功: 已保存到 $output");
                    }
                  },
                );
              }
              key.dispose();
            },
            child: AppText("开始解码", isTranslate: false),
          ),

          // AppButton.smallText(
          //   onClick: () async{
          //     // print((await getPluginDirectory()).path);
          //
          //     final MediaKey key = MediaKey.fromStr("108328049");
          //     final MediaCustomData? d = await mediaDeFileUnchecked(paramType: MediaParamType.nikkiPhoto, path: r"E:\game\InfinityNikki\InfinityNikki Launcher\InfinityNikki\X6Game\Saved\GamePlayPhotos\108328049\NikkiPhotos_HighQuality\2026_05_30_22_36_10_254303.jpeg", key: key);
          //     if(d != null){
          //       d.whenOrNull(
          //           valid: (MediaParam params){
          //             params.whenOrNull(
          //                 nikkiPhoto: (nikki){
          //                   genNikkiPhotoParams(nikki);
          //                   showAppDialog(context: context, builder: (c){
          //                     return AppDialog(
          //                       useIntrinsicHeight: false,
          //                       child: TreeViewPage(root: [genNikkiPhotoParams(nikki)]),
          //                     );
          //                   });
          //                 }
          //             );
          //           }
          //       );
          //     }
          //     key.dispose();
          //
          //     // showAppDialog(context: context, builder: (c){
          //     //   return TreeViewPage();
          //     // });
          //
          //     // await buildPlugin(builderConfig, Directory(r"E:\work\nikki_albums_file\plugin"));
          //     //
          //     // final p = await loadPlugin(Directory(r"E:\work\nikki_albums_file\plugin\05d5e067-ac1a-44c2-9f87-5ccaae613954"));
          //     // print(p?.enable);
          //     // print(p?.langPathList);
          //     // print(p?.iconPathList);
          //     // print(p?.gameConfigList);
          //
          //
          //     // serializeGameConfig(value: infinityNikkiConfig, pretty: true).then((v){
          //     //   File(r"E:\work\nikki_albums_file\game_config.json").writeAsBytes(v);
          //     // });
          //     //
          //     // print(greet(name: "rust"));
          //     //
          //     // print(testAdd(num1: 12, num2: 13));
          //
          //     // final files = await Directory(r"E:\game\InfinityNikki\InfinityNikki Launcher\InfinityNikki\X6Game\Saved\GamePlayPhotos\108328049\NikkiPhotos_HighQuality").list().map((f) => f.path).toList();
          //     //
          //     // final MediaKey key = MediaKey.fromStr("108328049");
          //     // final stopwatch = Stopwatch()..start();
          //     // await for(final data in mediaDeFilesUnchecked(paramType: MediaParamType.nikkiPhoto, paths: files, key: key)){
          //     //   if(data.data != null){
          //     //     data.data!.whenOrNull(
          //     //       valid: (params){
          //     //         params.whenOrNull(
          //     //           nikkiPhoto: (nik){
          //     //             print(nik.camera?.params);
          //     //           }
          //     //         );
          //     //       }
          //     //     );
          //     //   }
          //     // }
          //     // key.dispose();
          //     // stopwatch.stop();
          //     // print('函数运行时长: ${stopwatch.elapsedMilliseconds} ms');
          //
          //   },
          //   child: RichText(
          //     text: TextSpan(
          //       text: '\u{f06e}\u{f06d}\u{f050}',
          //       style: TextStyle(fontFamily: 'RanAppKey', fontSize: 20),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}