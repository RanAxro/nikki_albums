
import "package:nikki_albums/modules/app_base/state.dart";
import "package:nikki_albums/modules/hot_update/domain/hot_update_service.dart";

import "dart:io";

import "package:path/path.dart" as p;


Future<void> fixAppAssets() async{
  final String hotUpdatePath = await getHotUpdatePath();
  final Directory hotUpdateDir = Directory(hotUpdatePath);

  if(await hotUpdateDir.exists()){
    await hotUpdateDir.delete(recursive: true);
  }

  if(AppState.sfxPath.value != null){
    final String exePath = Platform.resolvedExecutable;
    final String versionFilePath = p.join(p.dirname(exePath), "version.txt");
    final File versionFile = File(versionFilePath);

    if(await versionFile.exists()){
      await versionFile.delete();
    }

    await Process.run(AppState.sfxPath.value!, ["-force"], runInShell: false);
  }
}