import "dart:io";

import "package:nikkialbums/state.dart";
import "package:nikkialbums/utils/path.dart";


abstract class TestPermission{
  static Future<bool> mklink(Path test) async{
    if(!Platform.isWindows) return false;

    final String ms = DateTime.now().millisecondsSinceEpoch.toString();
    try{
      final ProcessResult result = await test.generateDirectoryMklink(test.cut(1), dirName: ms);
      print(result.stderr);
      if(result.exitCode == 0){
        await (test.cut(1) + ms).link.delete(recursive: false);
        return true;
      }
      return false;
    }catch(e){
      return false;
    }
  }

  static Future<bool> mklinkAsAdmin(Path test) async{
    if(!Platform.isWindows) return false;

    final String ms = DateTime.now().millisecondsSinceEpoch.toString();

    final bool res = await test.generateDirectoryMklinkAsAdmin(test.cut(1), dirName: ms);

    if(res){
      /// 延迟重试以尽量避免“句柄未立即释放”导致的瞬时删除失败
      int tryTimes = 5;
      while(tryTimes-- != 0){
        try{
          await (test.cut(1) + ms).link.delete(recursive: false);
          break;
        }catch(e){
          await Future.delayed(Duration(milliseconds: 50));
          if(tryTimes == 0){
            AppState.writeError("star.testPermission.mklinkAsAdmin.delete", e.toString());
          }
        }
      }
    }

    return res;
  }

  static Future<bool> mklinkOrAdmin(Path test) async{
    if(await mklink(test)) return true;

    return mklinkAsAdmin(test);
  }
}