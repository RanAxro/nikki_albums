import "package:flutter/services.dart";
import "package:nikki_albums/main.dart";
import "package:nikki_albums/constants.dart";
import "package:nikki_albums/ui/component.dart" as rui;

import "package:flutter/material.dart";


Future<Widget> cdkey() async{
  return Container(
    padding: const EdgeInsets.all(10),
    child: ListView.builder(
      itemCount: config["cdkey"].length,
      itemBuilder: (context, index){
        final cdkey = config["cdkey"].keys.toList()[index];
        return rui.KeepAliveWrapper(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Tooltip(
              message: "点击复制",
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
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: cdkey,
                          style: TextStyle(color: Color(defaultAntiColor)),
                        ),
                        TextSpan(
                          text: config["cdkey"][cdkey][1] == null ? "" : "\n截至日期: ${config["cdkey"][cdkey][1]}",
                          style: TextStyle(color: Color(defaultHighLightColor)),
                        ),
                      ],
                    ),
                  )
                ),
                style: rui.buttonStyle(borderRadius: 8, color: defaultViceColor, colorOpacity: 1),
                onPressed: () async{await Clipboard.setData(ClipboardData(text: cdkey));},
              ),
            ),
          ),
        );
      },
    ),
  );
}