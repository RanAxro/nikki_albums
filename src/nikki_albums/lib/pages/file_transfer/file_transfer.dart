export "send_file.dart";
export "receive_file.dart";

import "receive_file.dart";
import "package:nikkialbums/state.dart";
import "package:nikkialbums/ui/frame.dart";
import "package:nikkialbums/ui/theme.dart";

import "package:flutter/material.dart";
import "dart:io";

import "package:network_info_plus/network_info_plus.dart";



final ContentItem item = ContentItem(
  expectedPosition: 3,
  name: "file_transfer",
  icon: AssetImage("assets/icon/file_transfer.webp"),
  page: const FileTransfer(),
);

void init(){
  pages.addItem(item);
}


class FileTransfer extends StatelessWidget{
  const FileTransfer({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment.center,
      color: AppTheme.of(context)!.colorScheme.background.color,

      child: ReceiveFile(),
    );
  }
}



class TransmissionInfo{
  static Future<String?> getCode() async{
    try{
      final wifiIP = await NetworkInfo().getWifiIP();
      final submask = await NetworkInfo().getWifiSubmask();

      if (wifiIP == null || submask == null) return null;

      final ip = InternetAddress.tryParse(wifiIP);
      final mask = InternetAddress.tryParse(submask);

      if(ip?.type != InternetAddressType.IPv4 || mask?.type != InternetAddressType.IPv4) return null;

      final ipBytes = ip!.rawAddress;
      final maskBytes = mask!.rawAddress;

      int code = 0;
      for(int i = 0; i < 4; i++){
        code = (code << 8) | (ipBytes[i] & ~maskBytes[i]);
      }

      return code.toString();
    }catch(e){
      return null;
    }
  }

  static TransmissionInfo? fromString(String str){
    /// ["nikkialbums", "accessible", code, ipv4, port, ipv6?]
    final List<String> parts = str.split("|");

    if(parts.length != 5 && parts.length != 6) return null;

    if(parts[0] != "nikkialbums" || parts[1] != "accessible") return null;

    return TransmissionInfo(
      code: parts[2],
      ipv4: parts[3],
      ipv6: parts.length == 6 ? parts[5] : null,
      port: parts[4],
    );
  }

  final String code;
  final String ipv4;
  final String? ipv6;
  final String port;

  const TransmissionInfo({
    required this.code,
    required this.ipv4,
    this.ipv6,
    required this.port,
  });

  String get v4AccessLink{
    return "$ipv4:$port";
  }

  String? get v6AccessLink{
    if(ipv6 == null) return null;

    return "[$ipv6]:$port";
  }

  @override
  String toString(){
    if(ipv6 == null){
      return "nikkialbums|accessible|$code|$ipv4|$port";
    }else{
      return "nikkialbums|accessible|$code|$ipv4|$port|$ipv6";
    }
  }

  @override
  bool operator ==(Object other){
    return other is TransmissionInfo && other.code == code && other.ipv4 == ipv4 && other.ipv6 == ipv6 && other.port == port;
  }

  @override
  int get hashCode => Object.hash(code, ipv4, ipv6, port);
}