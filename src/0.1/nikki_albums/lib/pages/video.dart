import "package:nikki_albums/main.dart";
import "package:nikki_albums/state.dart";
import "package:nikki_albums/constants.dart";
import "package:nikki_albums/ui/component.dart" as rui;
import "package:nikki_albums/api.dart" as api;

import "package:flutter/material.dart";
// import "dart:async";
import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:flutter_inappwebview/flutter_inappwebview.dart";
import 'package:http/http.dart' as http;

InAppWebViewController? webView;

Future<Widget> video() async{
  return Container(
    padding: const EdgeInsets.all(10),
    child: ListView.builder(
      itemCount: config["videoBilibiliVideos"].length,
      itemBuilder: (context, index){
        final bvid = config["videoBilibiliVideos"][index];
        print(index);
        return rui.KeepAliveWrapper(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: FutureBuilder(
              future: api.getWebApi(api.getBilibiliApiUrl(bvid), source: "bilibili"),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return TextButton.icon(
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      height: 100,
                      alignment: Alignment.centerLeft,
                      child: Image.network(snapshot.data!["pic"], width: 150, height: 100, fit: BoxFit.cover,),
                    ),
                    label: Container(
                      height: 100,
                      alignment: Alignment.centerLeft,
                      child: Text(snapshot.data!["title"], style: TextStyle(color: Color(defaultAntiColor))),
                    ),
                    style: rui.buttonStyle(borderRadius: 8, color: defaultViceColor, colorOpacity: 1),
                    onPressed: (){rui.webview.url(api.getBilibiliVideoUrl(bvid));},
                  );
                }
                return Container();
              }
            ),
          ),
        );
      },
    ),
  );
}