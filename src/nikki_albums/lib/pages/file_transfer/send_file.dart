
import "file_transfer.dart";
import "package:nikkialbums/nikkias/nikkias.dart";
import "package:nikkialbums/info.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/game/game.dart";
import "package:nikkialbums/ui/theme.dart";
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/utils/path.dart";
import "package:nikkialbums/utils/system/system.dart";
import "package:nikkialbums/utils/archive.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:async";
import "dart:convert";
import "dart:math";

import "package:easy_localization/easy_localization.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:shelf/shelf.dart";
import "package:shelf/shelf_io.dart" as shelf_io;
import "package:shelf_static/shelf_static.dart";
import "package:network_info_plus/network_info_plus.dart";




Future<void> exportImageToNetwork(BuildContext context, Game game) async{
  final Path zipPath = (await getTempPath()) + r"NikkiImages.zip";
  final Path nikkiasPath = (await getTempPath()) + r"NikkiImages.nikkias";

  final List<double> progressDetail = [0, 0];
  final ValueNotifier<double?> progress = ValueNotifier<double?>(null);
  String? errorMessage;

  if(context.mounted){
    showProgressBar(
      context: context,
      barrierDismissible: false,
      autoClose: false,
      valueListenable: progress,
      completedBuilder: (BuildContext context, void Function() close){
        if(errorMessage == null){
          WidgetsBinding.instance.addPostFrameCallback((_){
            Navigator.of(context).pop();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context){
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
                      children: [
                        Expanded(child: block0),
                        SendImageBuilder(
                          images: game.album.selectedImages.toList(),
                          zipFile: zipPath.file,
                          nikkiasFile: nikkiasPath.file,
                        ),
                        Expanded(child: block0),

                        SmallButton(
                          width: null,
                          colorRole: ColorRoles.background,
                          transparent: false,
                          onClick: (){
                            Navigator.of(context).pop();
                          },
                          child: Text(context.tr("stopSharing"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                        ),
                      ],
                    ),
                  )
                );
              },
            );
          });

          return block0;
        }

        return Column(
          spacing: listSpacing,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.tr("packagingFailed"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),
            Text(errorMessage.toString(), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),
            SmallButton(
              width: null,
              colorRole: ColorRoles.background,
              transparent: false,
              onClick: close,
              child: Text(context.tr("close"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            ),
          ],
        );
      }
    );
  }

  final ImageTransferNikkiasManifest manifest = ImageTransferNikkiasManifest(
    launcherChannel: game.launcherChannel,
    uid: game.selectedUid?.value ?? "",
    albumType: game.selectedAlbum,
  );

  try{
    final ImageTransferNikkiasCodec codec = ImageTransferNikkiasCodec(manifest, nikkiasPath.file, game.installPath);
    codec.filenameWhitelist = game.album.selectedImages.map((ImageItem item) => item.name).toList();
    await Future.wait([
      // encode archive
      compressZipIoX(
        game.album.selectedImages.map((ImageItem item) => item.path.file).toList(),
        game.album.selectedImages.map((ImageItem item) => Path(item.name)).toList(),
        zipPath.file,
        onProcess: (double encodeProgress){
          progressDetail[0] = encodeProgress;
          progress.value = progressDetail.reduce((a, b) => a + b) / progressDetail.length;
        },
      ),
      // encode nikkias
      codec.encode((double encodeProgress){
        progressDetail[1] = encodeProgress;
        progress.value = progressDetail.reduce((a, b) => a + b) / progressDetail.length;
      }),
    ]);
  }catch(e){
    errorMessage = e.toString();
  }finally{
    progress.value = 1;
  }
}




class UdpBroadcastBuilder extends StatefulWidget{
  final TransmissionInfo info;
  final Widget Function(BuildContext context, Widget indicator)? waitingBuilder;
  final Widget Function(BuildContext context)? errorBuilder;
  final Widget Function(BuildContext context) builder;

  const UdpBroadcastBuilder({
    super.key,
    required this.info,
    this.waitingBuilder,
    this.errorBuilder,
    required this.builder,
  });

  @override
  State<UdpBroadcastBuilder> createState() => _UdpBroadcastBuilderState();
}
class _UdpBroadcastBuilderState extends State<UdpBroadcastBuilder>{
  RawDatagramSocket? socket;
  Timer? timer;

  Future<void> startBroadcastUdp() async{
    stopBroadcastUdp();

    socket = await RawDatagramSocket.bind(await NetworkInfo().getWifiIP() ?? "127.0.0.1", 5555);
    socket!.broadcastEnabled = true;

    final data = utf8.encode(widget.info.toString());

    final wifiBroadcast = await NetworkInfo().getWifiBroadcast();
    final broadcast = InternetAddress(wifiBroadcast ?? "192.168.1.255");

    timer = Timer.periodic(udpBroadcastFrequency, (timer){
      socket!.send(data, broadcast, udpPort);
    });
  }

  void stopBroadcastUdp(){
    socket?.close();
    socket = null;
    timer?.cancel();
    timer = null;
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return RFutureBuilder(
      future: startBroadcastUdp(),
      waitingBuilder: widget.waitingBuilder,
      errorBuilder: widget.errorBuilder ?? widget.builder,
      builder: (BuildContext context, void _){
        return widget.builder(context);
      },
    );
  }

  @override
  void dispose(){
    stopBroadcastUdp();
    super.dispose();
  }
}



class SendFileBuilder extends StatefulWidget{
  final List<File> files;
  final List<File>? archives;
  final List<String>? downloadArchiveButtonText;
  final Widget Function(BuildContext context, Widget indicator)? waitingBuilder;
  final Widget Function(BuildContext context)? errorBuilder;
  final Widget Function(BuildContext context, TransmissionInfo info) builder;

  const SendFileBuilder({
    super.key,
    required this.files,
    this.archives,
    this.downloadArchiveButtonText,
    this.waitingBuilder,
    this.errorBuilder,
    required this.builder,
  });

  @override
  State<SendFileBuilder> createState() => _SendFileBuilderState();
}
class _SendFileBuilderState extends State<SendFileBuilder>{
  HttpServer? server;

  Response getFileListResponse(Request request){
    //  /api/list
    // final List<String> segments = request.requestedUri.pathSegments;
    // if(segments.length != 2 || segments[0] != "api" || segments[1] != "list") return Response.notFound("");
    if(request.requestedUri.path != "/api/list") return Response.notFound("");

    final List<String> names = widget.files.map((File file) => Path(file.path).name).toList();

    return Response.ok(
      jsonEncode(names),
      headers: {"content-type": "application/json"},
    );
  }

  Response getDownloadButtonTextListResponse(Request request){
    //  /api/list
    // final List<String> segments = request.requestedUri.pathSegments;
    // if(segments.length != 2 || segments[0] != "api" || segments[1] != "downloadButtonTexts") return Response.notFound("");
    if(request.requestedUri.path != "/api/downloadButtonTexts") return Response.notFound("");

    if(widget.downloadArchiveButtonText == null) return Response.forbidden("");

    return Response.ok(
      jsonEncode(widget.downloadArchiveButtonText!),
      headers: {"content-type": "application/json"},
    );
  }

  Response downloadArchiveResponse(Request request){
    //  /api/download?index=
    final List<String> segments = request.requestedUri.pathSegments;
    if(segments.length != 2 || segments[0] != "api" || segments[1] != "download") return Response.notFound("");

    final int index = int.tryParse(request.requestedUri.queryParameters["index"].toString()) ?? 0;

    if(widget.archives == null || widget.archives!.length - 1 < index) return Response.forbidden("");
    final File archive = widget.archives![index];

    return Response.ok(archive.openRead(), headers: {
      HttpHeaders.contentTypeHeader: "application/octet-stream",
      HttpHeaders.contentDisposition: 'attachment; filename="${Path(archive.path).name}"',
      HttpHeaders.contentLengthHeader: archive.lengthSync().toString(),
    });
  }

  Future<Response> downloadFileResponse(Request request) async{
    //  /$filename?preview=
    final List<String> segments = request.requestedUri.pathSegments;
    if(segments.isEmpty) return Response.notFound("Not Found");

    final String filename = segments.last;
    final int index = widget.files.indexWhere((File file) => Path(file.path).name == filename);
    if(index == -1) return Response.notFound("Not Found");

    final Path path = Path(widget.files[index].path).cut(1);

    final Response res = await createStaticHandler(path.path, defaultDocument: null)(request);

    // preview or download
    final isPreview = request.requestedUri.queryParameters["preview"] == "1";
    return res.change(headers: isPreview ? {} : {
      HttpHeaders.contentDisposition: 'attachment; filename="$filename"',
      HttpHeaders.contentLengthHeader: widget.files[index].lengthSync().toString(),
    });
  }

  Future<TransmissionInfo> startServer() async{
    await stopServer();

    final Cascade cascade = Cascade()
    //  /api/list
      .add(getFileListResponse)
    //  /api/downloadButtonTexts
      .add(getDownloadButtonTextListResponse)
    //  /api/download?index=
      .add(downloadArchiveResponse)
    //  /$filename?preview=
      .add(downloadFileResponse)
      .add(createStaticHandler((getWebPath() + r"send_file").path, defaultDocument: "index_${AppState.lang.value}.html"));

    server = await shelf_io.serve(cascade.handler, InternetAddress.anyIPv4, 0);

    final String code = await TransmissionInfo.getCode() ?? Random().nextInt(100).toString();
    final String ip = await NetworkInfo().getWifiIP() ?? server!.address.address ?? "127.0.0.1";
    final String port = server!.port.toString();

    final TransmissionInfo info = TransmissionInfo(code: code, ipv4: ip, port: port);

    print('Serving at http://${await NetworkInfo().getWifiIP() ?? "127.0.0.1"}:$port');

    return info;
  }

  Future<void> stopServer() async{
    await server?.close();
    server = null;
  }

  @override
  Widget build(BuildContext context){
    return RFutureBuilder(
      future: startServer(),
      waitingBuilder: widget.waitingBuilder,
      errorBuilder: widget.errorBuilder,
      builder: (BuildContext context, TransmissionInfo info){
        return widget.builder(context, info);
      },
    );
  }

  @override
  void dispose(){
    stopServer();
    super.dispose();
  }
}



class SendImageBuilder extends StatelessWidget{
  final List<ImageItem> images;
  final File zipFile;
  final File nikkiasFile;
  final Widget Function(BuildContext context, TransmissionInfo info)? builder;

  const SendImageBuilder({
    super.key,
    required this.images,
    required this.zipFile,
    required this.nikkiasFile,
    this.builder,
  });

  @override
  Widget build(BuildContext context){
    return SendFileBuilder(
      files: images.map((ImageItem item) => item.path.file).toList(),
      archives: [zipFile, nikkiasFile],
      downloadArchiveButtonText: [context.tr("downloadAll"), context.tr("downloadNikkias")],
      waitingBuilder: (BuildContext context, Widget indicator){
        return Column(
          children: [
            Text(context.tr("activatingNetwork"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
            indicator,
          ],
        );
      },
      errorBuilder: (BuildContext context){
        return Text(context.tr("activatingNetworkFailed"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor));
      },
      builder: (BuildContext context, TransmissionInfo info){
        return UdpBroadcastBuilder(
          info: info,
          builder: (BuildContext context){
            return Column(
              spacing: listSpacing,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.tr("useSameNetworkDevice"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                Text(info.code, style: TextStyle(fontSize: 48, fontWeight: FontWeight.w500, color: AppTheme.of(context)!.colorScheme.background.onColor)),
                Container(
                  color: Colors.white,
                  child: QrImageView(
                    data: info.v4AccessLink,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
                Column(
                  children: [
                    Text(context.tr("downloadLink"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                    SelectableText(info.v4AccessLink, style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}








