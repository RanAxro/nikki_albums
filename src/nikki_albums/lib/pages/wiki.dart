import "package:nikki_albums/main.dart";
import "package:nikki_albums/constants.dart";
import "package:nikki_albums/ui/component.dart" as rui;

import "package:flutter/material.dart";

Future<Widget> wiki() async{
  return Container(
    padding: const EdgeInsets.all(10),
    child: ListView.builder(
      itemCount: config["wikiList"].length ?? 0,
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
                // child: Image.network(snapshot.data!["pic"], width: 150, height: 100, fit: BoxFit.cover,),
              ),
              label: Container(
                height: 100,
                alignment: Alignment.centerLeft,
                child: Text(config["wikiList"][index]["source"], style: TextStyle(color: Color(defaultAntiColor))),
              ),
              style: rui.buttonStyle(borderRadius: 8, color: defaultViceColor, colorOpacity: 1),
              onPressed: (){rui.webview.url(config["wikiList"][index]["url"]);},
            ),
          ),
        );
      },
    ),
  );
}