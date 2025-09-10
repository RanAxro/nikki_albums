import "package:nikki_albums/constants.dart";
import "package:nikki_albums/ui/component.dart" as rui;

import "package:flutter/material.dart";

import "../main.dart";

Future<Widget> paper_tool() async{
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
                child: Image.asset("assets/logo/InfinityNikki.png"),
              ),
              label: Container(
                height: 100,
                alignment: Alignment.centerLeft,
                child: Text("鸭梨没压力", style: TextStyle(color: Color(defaultAntiColor))),
              ),
              style: rui.buttonStyle(borderRadius: 8, color: defaultViceColor, colorOpacity: 1),
              onPressed: (){rui.webview.url(config["paper_tool"]);},
            ),
          ),
        );
      },
    ),
  );
}