import "file_transfer.dart";
import "package:nikkialbums/info.dart";
import 'package:nikkialbums/ui/theme.dart';
import "package:nikkialbums/ui/rui.dart";
import "package:nikkialbums/utils/path.dart";
import "package:nikkialbums/utils/system/system.dart";
import "package:nikkialbums/nikkias/nikkias.dart";

import "package:flutter/material.dart";
import "dart:io";
import "dart:async";
import "dart:convert";

import "package:easy_localization/easy_localization.dart";
import "package:dio/dio.dart";



class ReceiveFile extends StatefulWidget{
  const ReceiveFile({super.key});

  @override
  State<StatefulWidget> createState() => _ReceiveFileState();
}
class _ReceiveFileState extends State<ReceiveFile>{
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: smallPadding,
        vertical: bigPadding,
      ),
      width: mediumCardMaxWidth,
      child: Column(
        spacing: listSpacing,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: bigPadding),
            constraints: const BoxConstraints(maxWidth: 120),
            child: Image.asset("assets/icon/big/receiveFile.webp", color: AppTheme.of(context)!.colorScheme.background.onColor),
          ),

          Row(
            spacing: listSpacing,
            children: [
              Expanded(
                child: RTextFiled(
                  controller: controller,
                  hintText: context.tr("inputDownloadUrl"),
                  colorRole: ColorRoles.background,
                ),
              ),

              SmallButton(
                width: smallTextFieldHeight,
                height: smallTextFieldHeight,
                colorRole: ColorRoles.background,
                transparent: false,
                onClick: () async{
                  final File? downloadFile = await downloadFileByUrl(context, controller.text, await getTempPath() + "receive.zip");
                  if(downloadFile != null && context.mounted){
                    parseNikkiasFile(context, downloadFile);
                  }
                },
                child: Image.asset("assets/icon/forward.webp", height: 24, color: AppTheme.of(context)!.colorScheme.background.onColor),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(smallPadding, bigPadding, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(context.tr("downloadableContent"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
          ),

          Expanded(
            child: UdpListenerBuilder(
              builder: (BuildContext context, List<TransmissionInfo> items){
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index){
                    return SmallButton(
                      padding: const EdgeInsets.only(left: bigPadding),
                      width: null,
                      height: bigButtonSize,
                      colorRole: ColorRoles.background,
                      transparent: false,
                      onClick: () async{
                        final File? downloadFile = await downloadFileByUrl(context, items[index].v4AccessLink, await getTempPath() + "receive.zip");
                        if(downloadFile != null && context.mounted){
                          parseNikkiasFile(context, downloadFile);
                        }
                      },
                      child: Column(
                        children: [
                          Align(
                            child: Text(items[index].code, style: TextStyle(fontSize: 36)),
                          ),
                          Align(
                            child: Text(items[index].v4AccessLink),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }
}

class UdpTransmissionInfoWrapper{
  final TransmissionInfo info;
  final Duration survivalDuration;
  final void Function() onDie;
  Timer? _timer;

  UdpTransmissionInfoWrapper({
    required this.info,
    required this.survivalDuration,
    required this.onDie,
  }){
    _createTimer();
  }

  void _createTimer(){
    _timer = Timer(survivalDuration, (){
      onDie();
      _timer = null;
    });
  }

  bool get isAlive => _timer != null;

  void reset(){
    _timer?.cancel();
    _createTimer();
  }

  void dispose(){
    _timer?.cancel();
    _timer = null;
  }

  @override
  bool operator ==(Object other){
    return other is UdpTransmissionInfoWrapper && other.info == info;
  }

  @override
  int get hashCode => info.hashCode;
}
class UdpListenerBuilder extends StatefulWidget{
  final Widget Function(BuildContext, List<TransmissionInfo>) builder;

  const UdpListenerBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<UdpListenerBuilder> createState() => _UdpListenerBuilderState();
}
class _UdpListenerBuilderState extends State<UdpListenerBuilder>{
  final List<UdpTransmissionInfoWrapper> items = <UdpTransmissionInfoWrapper>[];
  RawDatagramSocket? socket;

  Future<void> startListenUdp() async{
    if(this.socket != null) stopListenUdp();

    final RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, udpPort);
    this.socket = socket;

    socket.broadcastEnabled = true;
    socket.listen((RawSocketEvent event){
      if(event != RawSocketEvent.read) return;

      final Datagram? datagram = socket.receive();
      if(datagram == null) return;

      final String data = utf8.decode(datagram.data);
      final TransmissionInfo? info = TransmissionInfo.fromString(data);
      if(info == null) return;

      /// If this item exists, reset the timer.
      for(final UdpTransmissionInfoWrapper item in items){
        if(item.info == info){
          item.reset();
          return;
        }
      }

      /// If the item does not exist, add it and setState.
      items.add(UdpTransmissionInfoWrapper(
        info: info,
        survivalDuration: udpBroadcastFrequency * 2,
        onDie: (){
          items.removeWhere((UdpTransmissionInfoWrapper item) => item.info == info);
          setState((){});
        }),
      );
      setState((){});
    });
  }

  void stopListenUdp(){
    socket?.close();
    socket = null;
  }

  @override
  void initState(){
    super.initState();
    startListenUdp();
  }

  @override
  Widget build(BuildContext context){
    return widget.builder(
      context,
      items.map((UdpTransmissionInfoWrapper item) => item.info).toList(),
    );
  }

  @override
  void dispose(){
    stopListenUdp();
    super.dispose();
  }
}






Future<File?> downloadFileByUrl(BuildContext context, String url, Path savePath) async{
  url = guessUrl(url);
  final Completer completer = Completer();

  final ValueNotifier<double?> downloadProgress = ValueNotifier<double?>(null);
  String? errorMessage;

  showProgressBar(
    context: context,
    valueListenable: downloadProgress,
    barrierDismissible: false,
    autoClose: false,
    completedBuilder: (BuildContext context, void Function() close){
      if(errorMessage == null){
        WidgetsBinding.instance.addPostFrameCallback((_){
          close();
          completer.complete();
        });
        return block0;
      }

      return Column(
        spacing: listSpacing,
        children: [
          Text(context.tr("downloadFailed"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),
          SelectableText(errorMessage, style: TextStyle(color: AppTheme.of(context)!.colorScheme.error.pressedColor)),
          SmallButton(
            width: null,
            colorRole: ColorRoles.background,
            transparent: false,
            onClick: (){
              close();
              completer.complete();
            },
            child: Text(context.tr("close"), style: TextStyle(color: AppTheme.of(context)!.colorScheme.background.onColor)),
          )
        ],
      );
    }
  );

  try{
    final Dio dio = Dio();

    /// download
    final Response response = await dio.download(
      "http://$url/api/download?index=1",
      savePath.path,
      onReceiveProgress: (received, total){
        if(total == -1){
          downloadProgress.value = null;
        }else{
          downloadProgress.value = ((received / total) * 0.99).clamp(0, 1);
        }
      },
    );

    if(response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300){
      // success
    }else{
      errorMessage = response.statusCode.toString();
    }
  }catch(e){
    errorMessage = e.toString();
  }

  downloadProgress.value = 1;
  await completer.future;
  return errorMessage == null ? savePath.file : null;
}


String guessUrl(String rawUrl){
  return rawUrl
    .replaceAll(" ", "")
    .replaceAll("\n", "")
    .replaceAll("\t", "")
    .replaceAll(",", ".")
    .replaceAll("，", ".")
    .replaceAll("。", ".")
    .replaceAll(";", ":")
    .replaceAll("：", ":")
    .replaceAll("；", ":")
    .replaceAll("《", ":")
    .replaceAll("》", ":")
    .replaceAll("<", ":")
    .replaceAll(">", ":")
    .replaceAll("b", ":")
    .replaceAll("B", ":")
    .replaceAll("n", ":")
    .replaceAll("N", ":")
    .replaceAll("\\", "/")
    .replaceAll("？", "/")
    .replaceAll("?", "/")
    .replaceAll("http://", "")
    .replaceAll("https://", "")
    .replaceAll(RegExp(r"[^\d.:]"), "");
}
bool isUrl(String text){
  // IPv4:port
  final m = RegExp(r"^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}):(\d{1,5})$").firstMatch(text);
  if(m == null) return false;

  // 四段 0-255
  for(int i = 1; i <= 4; i++){
    final n = int.parse(m.group(i)!);
    if(n > 255) return false;
  }
  // 端口 1-65535
  final port = int.parse(m.group(5)!);
  return port <= 65535;
}