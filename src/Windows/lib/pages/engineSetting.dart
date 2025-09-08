import "package:nikki_albums/constants.dart";
import "package:nikki_albums/ui/component.dart" as rui;

import "package:flutter/material.dart";


Future<Widget> engineSetting() async{
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
                child: Icon(Icons.favorite, color: Color(defaultAntiColor),),
              ),
              label: Container(
                height: 100,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "着色器缓存\n",
                        style: TextStyle(color: Color(defaultAntiColor)),
                      ),
                      TextSpan(
                        text: "若每次进入游戏时加载缓慢, 可尝试使用该方法",
                        style: TextStyle(color: Color(defaultHighLightColor)),
                      ),
                    ],
                  ),
                )
              ),
              style: rui.buttonStyle(borderRadius: 8, color: defaultViceColor, colorOpacity: 1),
              onPressed: (){rui.webview.url("https://ngabbs.com/read.php?tid=43146677&_fp=2&rand=958");},
            ),
          ),
        );
      },
    ),
  );
}