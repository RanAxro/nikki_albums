import "dart:ui";

import "package:nikki_albums/constants.dart";
import "package:nikki_albums/state.dart";
import "package:nikki_albums/ui/component.dart";

import "api/api.dart" as api;
import "ui/desktop_frame.dart" as desktopFrame;

import "dart:io";
import "package:flutter/material.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";


// import "api/rColor.dart";

//配置
late final Map config;
//保存配置
Future save(Function? fn) async{
  if(fn != null) fn();
  api.saveConfig(config);
}

void main() async{

  // var a = RGB(R: 12);
  // var b = RGB(R: 50);
  // print(a.R.i);


  //初始化配置
  config = await api.readConfig();

  final dpr = PlatformDispatcher.instance.views.first.devicePixelRatio;

  //windows窗口初始化
  if(Platform.isWindows){
    runApp(const desktopFrame.mainWindow());

    doWhenWindowReady(() async{
      final win = appWindow;
      final (int width, int height) = api.getScreenSize();
      win.size = Size(0.5 * width.toDouble() / dpr, 0.5 * height.toDouble() / dpr);
      win.minSize = Size(0.3 * width.toDouble() / dpr, 0.3 * height.toDouble() / dpr);
      win.alignment = Alignment.center;
      win.title = "Nikki Albums";
      win.show();


      //阅读
      if(config["isAgreeAgreement"] == false){
        final res = await tip.show(title: "请先阅读并同意以下 MIT 许可证（中文翻译仅供参考）", message: agreement, isChoose: true, trueText: "我已阅读并同意上述英文版 MIT 许可证，并知晓中文翻译仅供参考", falseText: "我不同意", isForce: true);
        if(res == false){
          appWindow.close();
        }
        else if(res == true){
          save((){
            config["isAgreeAgreement"] = true;
          });
        }
      }

    });
  }

  //初始化state
  initState();




  try{
    final apiMap = await api.getWebApi(apiUrl, source: "github");
    final bool?  isWarning = apiMap["isWarning"];
    final String? warningTitle = apiMap["warningTitle"];
    final String? warningMessage = apiMap["warningMessage"];
    if(isWarning != null && isWarning){
      await tip.show(title: warningTitle ?? "", message: warningMessage ?? "", isForce: true, isWarning: true);
    }

    final String? version = apiMap["version"];
    final String? version0 = apiMap["version0"];
    final String? version1 = apiMap["version1"];
    final String? qq = apiMap["qq"];
    final String? url = apiMap["url"];
    final String? camera = apiMap["camera"];
    final String? paper_tool = apiMap["paper_tool"];
    final List? videoBilibiliVideos = apiMap["videoBilibiliVideos"];
    if(videoBilibiliVideos != null && api.checkRelation(config["videoBilibiliVideos"], videoBilibiliVideos) != 0){
      await tip.show(title: "有新的攻略视频!");
    }

    final Map? cdkey = apiMap["cdkey"];
    if(cdkey != null && api.checkRelation(config["cdkey"].keys.toList(), cdkey.keys.toList()) != 0){
      await tip.show(title: "有新的兑换码!");
    }

    final List? wikiList = apiMap["wikiList"];

    if(version != null && config["version"] != null && int.parse(version) > int.parse(config["version"])){
      await tip.show(title: "有新的版本: ${int.parse(version)}", url: url, urlMessage: "查看更新教程");
    }
    if(version0 == "3.0"){
      await tip.show(title: "有新的版本", url: url, urlMessage: "查看更新教程");
    }
    if(version1 != null){
      await tip.show(title: "有新的版本", url: url, urlMessage: "查看更新教程");
    }
    save((){
      config["qq"] = qq;
      config["url"] = url;
      config["camera"] = camera;
      config["paper_tool"] = paper_tool;
      config["videoBilibiliVideos"] = videoBilibiliVideos;
      config["cdkey"] = cdkey;
      config["wikiList"] = wikiList;
    });

  }catch(e){
    api.writeErrorLog("main : Cannot get webApi. Because : $e");
  }

}