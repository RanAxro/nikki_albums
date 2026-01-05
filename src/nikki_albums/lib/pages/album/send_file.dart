import "package:nikkialbums/api/path.dart";
import "package:nikkialbums/api/system/system.dart";
import 'package:nikkialbums/ui/theme.dart';
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/ui/rui.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:shelf/shelf.dart";
import "package:shelf/shelf_io.dart" as shelf_io;
import "package:network_info_plus/network_info_plus.dart";





class ExportNetworkDialog extends StatelessWidget{
  final List<ImageItem> images;
  const ExportNetworkDialog({
    super.key,
    required this.images,
  });

  void _startupMethod1(BuildContext context){
    showDialog(
      barrierDismissible: false,
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
            child: SendImages(
              images: images,
              builder: (BuildContext context, Path zipPath, String ip, int port, String url, void Function() refresh, void Function() stopServer){
                return Column(
                  spacing: listSpacing,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: block0),
                    Text(context.tr("useSameNetworkDevice"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    Container(
                      color: Colors.white,
                      child: QrImageView(
                        data: url,
                        version: QrVersions.auto,
                        size: 200,
                      ),
                    ),
                    Column(
                      children: [
                        Text(context.tr("downloadLink"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                        SelectableText(url, style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                      ],
                    ),
                    Expanded(child: block0),
                    SmallButton(
                      width: null,
                      height: mediumButtonSize,
                      colorRole: ColorRoles.background,
                      transparent: false,
                      onClick: refresh,
                      child: Text(context.tr("refresh"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    ),
                    SmallButton(
                      width: null,
                      height: mediumButtonSize,
                      colorRole: ColorRoles.background,
                      transparent: false,
                      onClick: (){
                        stopServer();
                        Navigator.of(context).pop();
                      },
                      child: Text(context.tr("stopSharing"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      }
    );
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
          children: [
            SmallButton(
              height: bigButtonContentSize,
              width: null,
              colorRole: ColorRoles.background,
              transparent: false,
              onClick: (){
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_){
                  _startupMethod1(context);
                });
              },
              child: Text(context.tr("methodX", args:  ["1"]), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ),
          ],
        ),
      ),
    );
  }
}




class SendImages extends StatefulWidget{
  final List<ImageItem> images;
  final Widget Function(BuildContext context, Path zipPath, String ip, int port, String url, void Function() refresh, void Function() stopServer) builder;

  const SendImages({
    super.key,
    required this.images,
    required this.builder,
  });

  @override
  State<SendImages> createState() => _SendImagesState();
}
class _SendImagesState extends State<SendImages>{
  Path? zipPath;
  final ValueNotifier<double> progress = ValueNotifier<double>(0);
  String? ip;
  int? port;
  String? shareUrl;
  HttpServer? server;

  Future<void> pack([void Function(double progress)? onProgress]) async{
    if(widget.images.isEmpty){
      onProgress?.call(1);
      return;
    }

    final Path zip = (await getTempPath()) + r"NikkiImages.zip";

    await compressInWindows(widget.images.map((item) => item.path).toList(), zip, onProgress);

    zipPath = zip;
  }
  
  Future<int> findAvailablePort() async{
    final ServerSocket socket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
    final int port = socket.port;
    await socket.close();
    return port;
  }

  Future<String?> startServer() async{
    if(zipPath == null) await pack();

    if(zipPath == null) return null;

    await stopServer();

    // 1. 随机端口
    final int port = await findAvailablePort();
    final File file = zipPath!.file;
    final String fileName = zipPath!.name;
    final int fileSize = await file.length();

    // 2. 创建 Shelf 路由
    final handler = Cascade().add((Request request) async{
      if(request.url.path == "file"){
        return Response.ok(file.openRead(), headers: {
          HttpHeaders.contentTypeHeader: "application/octet-stream",
          HttpHeaders.contentDisposition: 'attachment; filename="$fileName"',
          HttpHeaders.contentLengthHeader: fileSize.toString(),
        });
      }
      return Response.notFound("Not Found");
    }).handler;

    // 3. 启动服务器
    server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
    final localIp = await NetworkInfo().getWifiIP() ?? "127.0.0.1";

    ip = localIp;
    this.port = port;
    // 4. 生成对外 URL
    shareUrl = "http://$localIp:$port/file";
    return shareUrl!;
  }

  Future<void> stopServer() async{
    if(server != null){
      await server!.close();
      server = null;
    }
    shareUrl = null;
  }


  @override
  Widget build(BuildContext context){
    return RFutureBuilder(
      future: pack((double currentProgress){progress.value = currentProgress;}),
      waitingBuilder: (BuildContext context, Widget indicator){
        return Column(
          spacing: bigListSpacing,
          children: [
            Text(context.tr("packaging"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ValueListenableBuilder(
              valueListenable: progress,
              builder: (BuildContext context, double currentProgress, Widget? child){
                return LinearProgressIndicator(
                  value: currentProgress,
                  backgroundColor: AppTheme.of(context)!.colorScheme.primary.color,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.of(context)!.colorScheme.primary.onColor),
                  minHeight: 4,
                );
              },
            ),
            LinearProgressIndicator(
              value: null,
              backgroundColor: AppTheme.of(context)!.colorScheme.primary.color,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.of(context)!.colorScheme.primary.onColor),
              minHeight: 4,
            ),
          ],
        );
      },
      builder: (BuildContext context, v){

        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) refresh){
            return RFutureBuilder(
              future: startServer(),
              waitingBuilder: (BuildContext context, Widget indicator){
                return Column(
                  children: [
                    indicator,
                    Text(context.tr("activatingNetwork"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ],
                );
              },
              builder: (BuildContext context, String? url){
                if(zipPath == null) return Text(context.tr("packagingFailed"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor));

                if(ip == null || port == null || url == null) return Text(context.tr("activatingNetworkFailed"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor));

                return widget.builder(context, zipPath!, ip!, port!, url, (){refresh((){});}, stopServer);
              },
            );
          },
        );
      },
    );
  }
}