import "package:nikki_albums/constants.dart";
import "package:nikki_albums/state.dart";
import "package:nikki_albums/ui/component.dart";

import "api.dart" as api;
import "ui/frame.dart";

import "dart:io";
import "package:flutter/material.dart";
import "package:bitsdojo_window/bitsdojo_window.dart";

late final Map config;
Future save(Function? fn) async{
  if(fn != null) fn();
  api.saveConfig(config);
}

void main() async{
  //初始化配置
  config = await api.readConfig();

  runApp(const mainWindow());

  //windows窗口初始化
  if(Platform.isWindows){
    doWhenWindowReady(() async{
      final win = appWindow;
      final (int width, int height) = api.getScreenSize();
      win.size = Size(0.5 * width.toDouble(), 0.5 * height.toDouble());
      win.minSize = Size(500, 300);
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
    final String? version0 = apiMap["version0"];
    final String? version1 = apiMap["version1"];
    final String qq = apiMap["qq"];
    final String url = apiMap["url"];
    final String camera = apiMap["camera"];
    final String paper_tool = apiMap["paper_tool"];
    final List videoBilibiliVideos = apiMap["videoBilibiliVideos"];
    if(api.checkRelation(config["videoBilibiliVideos"], videoBilibiliVideos) != 0){
      await tip.show(title: "有新的攻略视频!");
    }

    final Map cdkey = apiMap["cdkey"];
    if(api.checkRelation(config["cdkey"].keys.toList(), cdkey.keys.toList()) != 0){
      await tip.show(title: "有新的兑换码!");
    }

    final List wikiList = apiMap["wikiList"];

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