
import "package:nikki_albums/ui/plugin.dart";
import "package:nikki_albums/base/app_router.dart";

import "package:flutter/material.dart";

import "package:forui/forui.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";


class BootstrapPage extends ConsumerStatefulWidget{
  const BootstrapPage({super.key});

  @override
  ConsumerState<BootstrapPage> createState() => _BootstrapPageState();
}

class _BootstrapPageState extends ConsumerState<BootstrapPage>{
  bool loading = true;

  Future<void> load() async{
    try{
      await scanPlugin(ref);
    }catch(e){

    }finally{
      if(context.mounted){
        context.go(AppRoutes.home);
      }
      setState((){
        loading = false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: SizedBox(
        width: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              width: 100,
              height: 100,
              child: Image.asset("assets/logo/nikkialbums.webp", width: 100),
            ),
            if(loading)
              FProgress(),
            if(!loading)
              FButton(
                onPress: (){
                  context.go(AppRoutes.home);
                },
                child: Text("进入"),
              ),
          ],
        ),
      ),
    );
  }
}