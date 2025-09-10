import "package:nikki_albums/constants.dart";
import "package:nikki_albums/ui/component.dart" as rui;

import "package:flutter/material.dart";

import "../main.dart";

Future<Widget> camera() async{
  return Container(
    padding: const EdgeInsets.all(10),
    child: ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index){
        return rui.KeepAliveWrapper(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextButton.icon(
              icon: Container(
                padding: const EdgeInsets.all(10),
                height: 100,
                alignment: Alignment.centerLeft,
                child: Image.asset("assets/logo/SpinningMomo.png"),
              ),
              label: Container(
                height: 100,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "旋转吧大喵",
                        style: TextStyle(color: Color(defaultAntiColor)),
                      ),
                      TextSpan(
                        text: "\n▸ 一键切换游戏窗口比例/尺寸，完美适配竖构图拍摄、相册浏览等场景\n▸ 突破原生限制，支持生成 8K-12K 超高清游戏截图\n▸ 专为《无限暖暖》优化，同时兼容多数窗口化运行的其他游戏",
                        style: TextStyle(color: Color(0xFF999999)),
                      ),
                    ],
                  ),
                ),
              ),
              style: rui.buttonStyle(borderRadius: 8, color: defaultViceColor, colorOpacity: 1),
              onPressed: (){rui.webview.url(config["camera"]);},
            ),
          ),
        );
      },
    ),
  );
}