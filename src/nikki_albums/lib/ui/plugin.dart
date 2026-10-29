
import "package:nikki_albums/modules/plugin/domain/plugin.dart";

import "package:flutter/widgets.dart";
import "dart:io";

import "package:forui/forui.dart";


class PluginPage extends StatefulWidget{
  const PluginPage({super.key});

  @override
  State<PluginPage> createState() => _PluginPageState();
}

class _PluginPageState extends State<PluginPage>{
  List<FileSystemEntity> getPluginList(){
    final Directory dir = Directory(r"C:\Users\Ran\Documents\Nikki Albums\Plugins");
    return dir.listSync();
  }

  @override
  Widget build(BuildContext context){
    final List<FileSystemEntity> entities = getPluginList();

    return Column(
      children: [
        FButton(
          onPress: (){
            setState(() {

            });
          },
          child: Text("加载"),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: entities.length,
            itemBuilder: (BuildContext context, int index){
              final Plugin plugin = Plugin(entities[index]);

              return FCard(
                child: FutureBuilder(
                  future: plugin.getReader(),
                  builder: (BuildContext context, AsyncSnapshot<PluginReader> snapshot){
                    if(snapshot.hasData){
                      return FutureBuilder(
                        future: snapshot.data!.readInfo(),
                        builder: (BuildContext context, AsyncSnapshot<PluginInfo> snapshot){
                          if(snapshot.hasData){
                            final PluginInfo info = snapshot.data!;
                            return FButton(
                              onPress: () async{
                                var runner = await plugin.getRunner();
                                final games = await runner.searchGame("114514");
                                print(games);
                                games.forEach((g){
                                  print(g.info);
                                  print(g.installPath);
                                });
                                runner.dispose();
                              },
                              child: Text(info.uuid.toString()),
                            );
                          }else if(snapshot.hasError){
                            return Text("读取Info失败: ${snapshot.error.toString()}");
                          }
                          return Text("读取Info中");
                        },
                      );
                    }else if(snapshot.hasError){
                      return Text("读取插件失败: ${snapshot.error.toString()}");
                    }
                    return Text("加载中");
                  },
                ),
              );

            },
          ),
        ),
      ],
    );
  }
}