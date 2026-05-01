
import "../../model/album_info.dart";
import "package:nikki_albums/modules/game/lib/uid.dart";
import "package:nikki_albums/modules/game/lib/game.dart";
import "package:nikki_albums/modules/app_base/data/log.dart";

import "dart:io";

import "package:path/path.dart" as p;


abstract class UidSearcher{
  static Future<List<Uid>> findByGame(Game game) async{
    final Set<Uid> uidList = {};

    for(AlbumInfo info in albumInfos.values){
      if(!info.isRequireUid) continue;

      final String rootPath = p.join(game.installPath, info.locateInGame.split(r"$uid$").first);
      final Directory rootDir = Directory(rootPath);
      try{
        // 判断文件夹合法性
        if(!(await rootDir.exists())) continue;

        await for(FileSystemEntity entity in rootDir.list(recursive: false)){
          final String uidValue = p.basename(entity.path);
          // 判断格式
          if(isUidType(uidValue)){
            uidList.add(Uid.ofGame(game, uidValue));
          }
        }
      }catch(e){
        AppLog.write("game.UidSearcher.findByGame", e.toString());
        continue;
      }
    }
    return uidList.toList(growable: false);
  }
}