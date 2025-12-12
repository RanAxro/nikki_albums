import "package:nikkialbums/state.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/api/system/system.dart";
import "package:nikkialbums/api/path.dart";

import "package:flutter/material.dart";
import "dart:convert";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:http/http.dart" as http;
import "package:url_launcher/url_launcher.dart";
import "package:dio/dio.dart";



class VersionInformation extends StatelessWidget{
  const VersionInformation({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(smallPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: smallDialogMaxWidth,
          child: Column(
            spacing: bigListSpacing,
            children: [
              Text("${context.tr("version")}: $versionString", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),

              CheckUpdatesButton(),

              SmallButton(
                width: null,
                onClick: (){
                  launchOfficialWebsite(context);
                },
                child: Text(context.tr("toOfficialWebsite"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
              ),

              block10H,
              SelectableText(context.tr("info"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ],
          ),
        ),
      ),
    );
  }
}


class CheckUpdatesButton extends StatefulWidget {
  const CheckUpdatesButton({super.key});

  @override
  State<CheckUpdatesButton> createState() => _CheckUpdatesButtonState();
}
class _CheckUpdatesButtonState extends State<CheckUpdatesButton>{
  @override
  Widget build(BuildContext context){
    return SmallButton(
      padding: const EdgeInsets.symmetric(horizontal: smallPadding),
      colorRole: ColorRoles.secondary,
      transparent: true,
      width: null,
      onClick: (){
        setState((){

        });
      },
      child: Row(
        spacing: listSpacing,
        children: [
          Text("${context.tr("checkForUpdates")}: ", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
          RFutureBuilder(
            future: checkForUpdates(),
            builder: (BuildContext context, UpdateInfo? info){
              if(info == null) return Text(context.tr("checkFailed"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor));

              if(info.version <= version) return Text(context.tr("alreadyTheLatestVersion"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor));

              WidgetsBinding.instance.addPostFrameCallback((_){
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return UpdateDialog(info: info);
                  }
                );
              });

              return Text("${context.tr("findNewVersion")} ${info.versionString}", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor));
            },
          ),
        ],
      ),
    );
  }
}




class UpdateInfo{
  final int version;
  final String versionString;
  final String downloadLink;
  final String updateMessage;

  const UpdateInfo({
    required this.version,
    required this.versionString,
    required this.downloadLink,
    required this.updateMessage,
  });
}

Future<UpdateInfo?> checkForUpdates() async{
  try{
    final response = await http.get(Uri.parse("https://nikki.ranaxro.com/api.json"), headers: {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"});

    if(response.statusCode != 200) return null;

    final Map info = jsonDecode(response.body);

    if(info["version"] is! int){
      return null;
    }

    return UpdateInfo(
      version: info["version"],
      versionString: info["versionString"] is String ? info["versionString"] : info["version"].toString(),
      downloadLink: info["downloadLink"] is String ? info["downloadLink"] : "",
      updateMessage: info["updateMessage"] is String ? info["updateMessage"] : "",
    );
  }catch(e){
    return null;
  }
}

Future<void> launchOfficialWebsite(BuildContext context) async{
  final uri = Uri.parse("https://$officialWebsite");
  if(await canLaunchUrl(uri)){
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }else{
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(smallBorderRadius),
            ),
            backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
            child: Container(
              padding: const EdgeInsets.all(smallPadding),
              width: smallDialogMaxWidth,
              child: SelectableText(officialWebsite, style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ),
          );
        }
    );
  }
}

class UpdateDialog extends StatelessWidget{
  final UpdateInfo info;
  final ValueNotifier<double> downloadProgress = ValueNotifier<double>(0);
  final ValueNotifier<String?> errorInfo = ValueNotifier<String?>(null);
  
  UpdateDialog({
    super.key,
    required this.info,
  });

  Future<Path> _getSavePath(BuildContext context) async{
    final String name = context.tr("nikkialbums");
    return (await getTempPath()) + "$name.zip";
  }

  Future<void> _download(BuildContext context) async{
    final Path? desktopPath = getWindowsDesktopPath();

    if(info.downloadLink == "" || desktopPath == null){
      launchOfficialWebsite(context);
    }else{
      try{
        final Dio dio = Dio();

        showProgressBar(
          context: context,
          valueListenable: downloadProgress,
          barrierDismissible: false,
        );

        final Path savePath = await _getSavePath(context);

        final Response response = await dio.download(
          info.downloadLink,
          savePath.path,
          onReceiveProgress: (received, total){
            downloadProgress.value = (received / total - 0.01).clamp(0, 1);
          },
          options: Options(
            headers: {
              "Referer": "https://nikki.ranaxro.com",
            },
          ),
        );

        final Path? desktopPath = getWindowsDesktopPath();

        if(desktopPath != null){
          final int exitCode = await decompressInWindows(savePath, desktopPath);
          downloadProgress.value = 1;

          if(exitCode == 0){
            desktopPath.open(FileSystemEntityType.directory);
          }else{
            savePath.open(FileSystemEntityType.directory);
          }
        }else{
          savePath.open(FileSystemEntityType.directory);
          downloadProgress.value = 1;
        }

        WidgetsBinding.instance.addPostFrameCallback((_){
          Navigator.of(context).pop();
        });
      }catch(e){
        AppState.writeError("setting.versionInformation.download", e.toString());
        errorInfo.value = "downloadFailed";
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        width: smallDialogMaxWidth,
        child: Column(
          spacing: listSpacing,
          mainAxisSize: MainAxisSize.min,
          children: [

            Text("${context.tr("checkForUpdates")}: ${info.versionString} !", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),

            SmoothPointerScroll(
              builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
                return SingleChildScrollView(
                  controller: controller,
                  physics: physics,
                  child: Text("${context.tr("updateMessage")}:\n ${info.updateMessage}", style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                );
              },
            ),

            /// 错误提示
            ValueListenableBuilder(
              valueListenable: errorInfo,
              builder: (BuildContext context, String? error, Widget? child){
                if(error == null) return block0;

                return Text(context.tr(error), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor));
              },
            ),
            ValueListenableBuilder(
              valueListenable: errorInfo,
              builder: (BuildContext context, String? error, Widget? child){
                if(error == null) return block0;

                return SmallButton(
                  width: null,
                  onClick: (){
                    launchOfficialWebsite(context);
                  },
                  child: Text(context.tr("toOfficialWebsite"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                );
              },
            ),

            /// 下载按钮
            SmallButton(
              width: null,
              colorRole: ColorRoles.secondary,
              transparent: true,
              onClick: () async{
                _download(context);
              },
              child: Text(context.tr("download"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ),

            /// 关闭按钮
            SmallButton(
              width: null,
              colorRole: ColorRoles.secondary,
              transparent: true,
              onClick: (){
                Navigator.of(context).pop();
              },
              child: Text(context.tr("close"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            )
          ],
        ),
      ),
    );
  }
}



Future<void> check(BuildContext context) async{
  final UpdateInfo? info = await checkForUpdates();

  if(info == null || info.version <= version) return;

  WidgetsBinding.instance.addPostFrameCallback((_){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return UpdateDialog(info: info);
      }
    );
  });
}


// class DownloadDialog extends StatelessWidget{
//   final Path url;
//   final ValueNotifier<String> fileName;
//   final ValueNotifier<Path?> savePath;
//
//   DownloadDialog({
//     super.key,
//     required this.url,
//     required String fileName,
//   }) :
//     fileName = ValueNotifier<String>(fileName),
//     savePath = ValueNotifier(getWindowsDesktopPath())
//   ;
//
//   @override
//   Widget build(BuildContext context){
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(smallBorderRadius),
//       ),
//       backgroundColor: AppTheme.of(context)!.colorScheme.background.color,
//       child: Container(
//         padding: const EdgeInsets.all(smallPadding),
//         width: smallDialogMaxWidth,
//         child: MultiValueListenableBuilder(
//           listenables: [fileName, savePath],
//           builder: (BuildContext context, Widget? child){
//             return Column(
//               spacing: listSpacing,
//               children: [
//                 Text(fileName.value),
//                 Row(
//                   children: [
//                     Text("下载至"),
//                     Text(savePath.value?.path ?? "请选择保存文件夹")
//                   ],
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }